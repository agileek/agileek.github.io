---
layout: post
title: "Using an AWS ECR image as a Github Action container"
categories: [software, aws]
date: 2020-10-28
tags: [software, aws, cloud]
---
## Moving from Docker Hub to ECR

[Pubstack][pubstack], my current client decided to migrate all its docker images to [ECR][ecr]. 

With the recent [announcement][docker_rate_limiting] about rate limiting on Docker Hub, maybe we will not be the only ones moving away.

For our **CI/CD** pipelines we use both [CircleCI][circleci] and [GitHub Actions][githubactions].

Using an **ECR** image is a really simple task in **CircleCI**, it consists of adding the `aws_auth` to the image configuration.

```yaml
  docker:
    - image: ACCOUNT.dkr.ecr.REGION.amazonaws.com/IMAGE:VERSION
      aws_auth:
        aws_access_key_id: $AWS_ACCESS_KEY_ID
        aws_secret_access_key: $AWS_SECRET_ACCESS_KEY
```

On the other hand, using **ECR** images in **GitHub Actions** was a bit more tricky.

The problem is, you could only use images from private registries in job and service containers since [late september][githubactionsprivate], and they only did the "credentials" implementation.
It means something like this is expected:

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    container:
      image: ACCOUNT.dkr.ecr.REGION.amazonaws.com/IMAGE:VERSION
      credentials:
        username: AWS
        password: {% raw %}${{ secrets.ECR_PASSWORD }}{% endraw %}
    steps:
      - run: echo "inside an ecr container"
``` 

With aws, you can get a password with `aws ecr get-login-password`, and it is valid 12 hours.

You can manually set the GitGub secret "ECR_PASSWORD" every 12 hours, but that's not really convenient.

After a little digging, I found an [answer][githubcommunitythread] on a GitHub community thread explaining what seems like a good solution.[^1]

Basically what we will do is:

1. Retrieve **ECR** password from aws
2. Store it as a **GitHub** secret name `ECR_PASSWORD`

All that inside a **GitHub** action scheduled to run every 6 hours.

It was not really as simple as I first thought, so here is all I had to do.
I hope it can help you.

First, I created some aws credentials (ie. a couple `aws_access_key_id` and `aws_secret_access_key` with enough right to pull from ECR)
I put them as secrets inside the **GitHub** project, let's call them `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
Then I generated a personal access token (the "provided by default" `GITHUB_TOKEN` doest not have sufficient rights), let's call it `GH_API_ACCESS_TOKEN`.

The complete **GitHub** workflow:

```yaml
name: ecr-login
on:
  # Every 6 hours, the password validity is 12 hours
  schedule:
    - cron:  '0 */6 * * *'
jobs:
  login:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: AWS cli install action
        uses: chrislennon/action-aws-cli@1.1
      - name: retrieve ecr password and store as secret
        run: |
          pip3 install -r .github/requirements.txt
          python3 .github/ecr_password_updater.py
        env:
          AWS_ACCESS_KEY_ID: {% raw %}${{ secrets.AWS_ACCESS_KEY_ID }}{% endraw %}
          AWS_SECRET_ACCESS_KEY: {% raw %}${{ secrets.AWS_SECRET_ACCESS_KEY }}{% endraw %}
          AWS_DEFAULT_REGION: AWS_REGION
          GH_API_ACCESS_TOKEN: {% raw %}${{ secrets.GH_API_ACCESS_TOKEN }}{% endraw %}
  # This 'test' job is usefull for fast debugging
  test:
    needs: login
    runs-on: ubuntu-latest
    container:
      image: ACCOUNT.dkr.ecr.REGION.amazonaws.com/IMAGE:VERSION
      credentials:
        username: AWS
        # Here is the password retrieved as a secret that is set by the `login` job
        password: {% raw %}${{ secrets.ECR_PASSWORD }}{% endraw %}
    steps:
      - run: echo "Inside a container pulled from ECR \o/"
```

The python file `ecr_password_updater.py`:

```python
# From https://github.community/t/github-actions-new-pulling-from-private-docker-repositories/16089/28
# The goal is to retrieve the ecr password every 6 hours and put it as a secret
from base64 import b64encode, b64decode
from nacl import encoding, public
import requests
import os
import json
import boto3


def encrypt(raw_public_key: str, secret_value: str) -> str:
    """Encrypt a Unicode string using the public key."""
    public_key = public.PublicKey(raw_public_key.encode("utf-8"), encoding.Base64Encoder())
    sealed_box = public.SealedBox(public_key)
    encrypted = sealed_box.encrypt(secret_value.encode("utf-8"))
    return b64encode(encrypted).decode("utf-8")


def get_ecr_password() -> str:
    """Retrieve ECR password, it comes b64 encoded, in the format user:password
       From https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ecr.html#ECR.Client.get_authorization_token
    """
    ecr = boto3.client('ecr')
    response = ecr.get_authorization_token()
    encoded_login_password = response['authorizationData'][0]['authorizationToken']

    decoded_login_password = b64decode(encoded_login_password).decode('UTF-8')
    return decoded_login_password.split(':')[1]


if __name__ == '__main__':

    get_public_key = requests.get('https://api.github.com/repos/ORG/REPOSITORY/actions/secrets/public-key',
                                  headers={'Accept': 'application/vnd.github.v3+json',
                                           'Authorization': 'token ' + os.environ['GH_API_ACCESS_TOKEN']})
    if get_public_key.ok is False:
        print('could not retrieve public key')
        print(get_public_key.text)
        exit(1)
    get_public_key_response = get_public_key.json()
    public_key_value = get_public_key_response['key']
    public_key_id = get_public_key_response['key_id']

    password = get_ecr_password()
    encrypted_password = encrypt(public_key_value, password)
    update_password = requests.put('https://api.github.com/repos/ORG/REPOSITORY/actions/secrets/ECR_PASSWORD',
                                   headers={'Accept': 'application/vnd.github.v3+json',
                                            'Authorization': 'token ' + os.environ['GH_API_ACCESS_TOKEN']},
                                   data=json.dumps({'encrypted_value': encrypted_password, 'key_id': public_key_id,
                                                    'visibility': 'all'}))
    if update_password.ok is False:
        print('could not update password')
        print(update_password.text)
        exit(1)

```

The dependencies used by the python code:
```text
pynacl==1.4.0
requests==2.25.1
boto3==1.17.107
```

I first started with a simple bash script, but it became quite complex[^2], so I switched to python.

Enjoy!

### Edit 2021-07-09

Thanks to Alex Pavlenko, I switched from using the aws cli to boto3. Python all the way!

[pubstack]: https://pubstack.io/
[ecr]: https://aws.amazon.com/ecr/
[docker_rate_limiting]: https://www.docker.com/pricing/resource-consumption-updates
[circleci]: https://circleci.com/
[githubactions]: https://github.com/features/actions
[githubactionsprivate]: https://github.blog/changelog/2020-09-24-github-actions-private-registry-support-for-job-and-service-containers/
[githubcommunitythread]: https://github.community/t/github-actions-new-pulling-from-private-docker-repositories/16089/28
[^1]: ok, maybe not good, but at least it works
[^2]: you need to encrypt the password, and you need the public key id of the repository when you put the encrypted secret. I often start with bash, if it's simple enough I keep it, if not I switch to python.