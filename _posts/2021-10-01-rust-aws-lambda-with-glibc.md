---
layout: post
title: "Rust AWS lambda with glibc"
categories: [software, aws]
date: 2021-10-01
tags: [rust, software, aws]
---

## Why

AWS has announced supporting rust for the lambda, but does not provide an official runtime for it. You have to provide your own, and the [official][aws_rust_lambda_runtime] way is through building a target where you can statically link a libc implementation: [musl][musl].

While it appears you could [statically link the glibc][glibc_statically_link], it is not advised. (see [here][dont_static_link_glibc_1] and [here][dont_static_link_glibc_2])


So for AWS:

![ThisIsTheWay][ThisIsTheWay]{: .center-image }


## What

While searching for alternative solutions to this (Because reasons), I found that since late 2020, they added a [container image support][container_image_support] to AWS lambda.

![ThereIsAnother][ThereIsAnother]{: .center-image }

Sooooooo, if we want to use glibc, we need to have docker.
Fine, let's give it a try

### How

First we have to create a simple rust application.

```bash 
cargo new test_aws_lambda
cargo add lambda_runtime
cargo add tokio
cargo add aws_lambda_events
```

Let's change the `src/main.rs` a bit.
Basically we will just return everything that is sent to us.

```rust
use aws_lambda_events::event::sns::SnsEvent;
use lambda_runtime::Context;
use lambda_runtime::{handler_fn, Error};

#[tokio::main]
pub async fn main() -> Result<(), Error> {
    let func = handler_fn(handler);
    lambda_runtime::run(func).await?;

    Ok(())
}

async fn handler(sns_event: SnsEvent, _context: Context) -> Result<SnsEvent, Error> {
    println!("Handler");
    Ok(sns_event)
}
```

Now comes the build part, we will use docker to build the release.
We will need a custom ENTRYPOINT for aws to be able to understand the lambda.
Here is the `entry.sh` you'll need:

```bash
#!/bin/sh
set -x
if [ -z "${AWS_LAMBDA_RUNTIME_API}" ]; then
	  exec /usr/bin/aws-lambda-rie "$@"
  else
	    exec "$@"
fi 
```

```Docker
FROM rust:buster as build

COPY test_aws_lambda /test_aws_lambda
RUN cd test_aws_lambda && cargo build --release

FROM debian:buster

ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/download/1.1/aws-lambda-rie /usr/bin/aws-lambda-rie
RUN chmod 755 /usr/bin/aws-lambda-rie
COPY entry.sh /
RUN chmod 755 /entry.sh
ENTRYPOINT [ "/entry.sh" ]

COPY --from=build /test_aws_lambda/target/release/test_aws_lambda /test_aws_lambda
CMD [ "/test_aws_lambda" ]
```

Now we have to build it: `docker build -t aws-lambda-test .`

Run it: `docker run --rm -p 9000:8080 aws-lambda-test`

And test it: `curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{ "Records": [] }'`

It should respond `{"Records":[]}`

### Deploy on AWS

You need to have a docker registry (ECR) in the same account as your lambda.

First, create an ECR repository `ACCOUNTID.dkr.ecr.AWS_REGION.amazonaws.com/aws-lambda-test`

You can then tag and push your local image in this repository:

```bash 
docker tag aws-lambda-test ACCOUNTID.dkr.ecr.AWS_REGION.amazonaws.com/aws-lambda-test
docker push ACCOUNTID.dkr.ecr.AWS_REGION.amazonaws.com/aws-lambda-test
```

Create the lambda, use the container image, and go to the test section.

![AwsTest][AwsTest]{: .center-image }

And voilà, you now have a rust container running as an aws lambda!

[musl]: https://musl.libc.org/
[aws_rust_lambda_runtime]: https://github.com/awslabs/aws-lambda-rust-runtime
[glibc_statically_link]: https://users.rust-lang.org/t/statically-link-executable-with-glibc/32648
[dont_static_link_glibc_1]: https://stackoverflow.com/questions/3430400/linux-static-linking-is-dead
[dont_static_link_glibc_2]: https://lwn.net/Articles/117972/
[ThisIsTheWay]: /images/posts/rust_aws_lambda/this_is_the_way.jpg
[ThereIsAnother]: /images/posts/rust_aws_lambda/there_is_another.jpg
[AwsTest]: /images/posts/rust_aws_lambda/aws_test.png
[container_image_support]: https://aws.amazon.com/blogs/aws/new-for-aws-lambda-container-image-support/
