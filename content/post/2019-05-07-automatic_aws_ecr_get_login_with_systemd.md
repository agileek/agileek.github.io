---
categories:
- docker
- terminal
date: "2019-05-07T00:00:00Z"
tags:
- aws
- ecr
- docker
- systemd
title: Login to AWS ECR using systemd
aliases: ['/docker/terminal/2019/05/07/automatic_aws_ecr_get_login_with_systemd/']
---

## First try without systemd

During my previous mission, we used AWS ECR to manage the docker images.

> Amazon EC2 Container Registry (ECR) is a fully-managed Docker container registry that makes it easy for developers to store, manage, and deploy Docker container images.

To be able to store/retrieve docker images, you have to be authenticated.
AWS CLI provides a command which takes your credentials and generate a token, authenticating the user for 12 hours.

Our continuous integration servers (ie. Jenkins nodes) needed to access to the ECR so we had to provide an automated mechanism.

The first idea was to use 2 crons:

* The first on @reboot, to ensure the machine will be authenticated upon reboot.
* The second every 11 hours.

This was not a good idea, sometimes it did not work and it was difficult to know why.
(In fact, the @reboot only works when using root, which we try to avoid)

## Systemd

So we used systemd and:

* it just worked
* we can monitor the executions

Here is the unit located here: /etc/systemd/system/docker_ecr_login.service

{{< highlight bash >}}
[Unit]
Description=Docker aws ecr login
Wants=network-online.target
After=network.target network-online.target

[Service]
Type=oneshot
User=builder
ExecStart=/usr/bin/bash -c '$$(/usr/bin/aws ecr get-login --no-include-email)'

[Install]
WantedBy=default.target
{{< / highlight >}}

Dont forget to `systemctl daemon-reload` and `systemctl enable docker_ecr_login`

Now we only use one cron, every 11 hours it launches `systemctl start docker_ecr_login`

### Investigate

Now it's easier to monitor past executions with:

{{< highlight bash >}}
$ journalctl -u docker_ecr_login
-- Logs begin at Fri 2017-05-19, end at Mon 2017-07-10. --
Starting Docker aws ecr login...
docker_ecr_login.service: Main process exited, code=exited, status=217/USER
Failed to start Docker aws ecr login.
docker_ecr_login.service: Unit entered failed state.
docker_ecr_login.service: Failed with result 'exit-code'.
{{< / highlight >}}

The error status 217/USER means that the user 'builder' doesn't exist on this system.

### ToDo

We are looking into systemd timers with something like `OnUnitActiveSec=` we should be able to completely get rid of cron and go full systemd.
