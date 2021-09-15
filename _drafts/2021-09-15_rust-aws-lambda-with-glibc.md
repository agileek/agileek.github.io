---
layout: post
title: "Rust AWS lambda with glibc"
categories: [software, aws]
date: 2021-09-15
tags: [rust, software, aws]
---

## Why

AWS has announced supporting rust for the lambda, but does not provide an official runtime for it. You have to provide your own, and the [official][aws_rust_lambda_runtime] way is through building a target where you can statically link a libc implementation: [musl][musl].

While it appears you could [statically link the glibc][glibc_statically_link], it is not advised. (see [here][dont_static_link_glibc_1] and [here][dont_static_link_glibc_2])


So for AWS:

![ThisIsTheWay][ThisIsTheWay]


## How

While searching for alternative solutions to this (I like being as free as possible when executing software), I found that since late 2020, they added a [container image support][container_image_support] to AWS lambda.

![ThereIsAnother][ThereIsAnother]








[musl]: https://musl.libc.org/
[aws_rust_lambda_runtime]: https://github.com/awslabs/aws-lambda-rust-runtime
[glibc_statically_link]: https://users.rust-lang.org/t/statically-link-executable-with-glibc/32648
[dont_static_link_glibc_1]: https://stackoverflow.com/questions/3430400/linux-static-linking-is-dead
[dont_static_link_glibc_2]: https://lwn.net/Articles/117972/
[ThisIsTheWay]: /images/posts/rust_aws_lambda/this_is_the_way.jpg
[ThereIsAnother]: /images/posts/rust_aws_lambda/there_is_another.jpg
[container_image_support]: https://aws.amazon.com/blogs/aws/new-for-aws-lambda-container-image-support/
