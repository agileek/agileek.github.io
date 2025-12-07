---
categories:
- software
date: "2025-12-06T00:00:00Z"
tags: ["software"]
title: What can we do to prevent stuff like Shai-Hulud to affect our computers.
summary: Npm, docker and the least privileges possible
---

This is my attempt to mitigate the risks of future problems like Shai-Hulud.

Because let's face it, it will happen again.
The root causes are still here.

## Disable automatic script execution

You can disable that by putting `ignore-scripts=true` in your .npmrc file.

This can [be setup][npmrc_doc]:

- by project (at the root of your repository)
- per-user config file (~/.npmrc) **recommended**
- global config file ($PREFIX/etc/npmrc)
- npm builtin config file (/path/to/npm/npmrc)

## Wrap inside Docker

They can't access your home and all its credentials if they don't see your home.

![think_meme][think_meme]

I created a docker image for my fedora machine with the strict minimum:

```Dockerfile
FROM fedora:43

RUN dnf install -y git
RUN curl https://nodejs.org/dist/v24.11.1/node-v24.11.1-linux-x64.tar.xz -o /node-v24.11.1-linux-x64.tar.xz && \
  tar -xf /node-v24.11.1-linux-x64.tar.xz && \
  ln -s /node-v24.11.1-linux-x64/bin/node /bin/node

ENTRYPOINT [ "/node-v24.11.1-linux-x64/bin/npm" ]
```

Build it with `docker build -t my_node .` and add an alias to your .bashrc like this one:

```bash
alias npm='docker run -ti --rm -v $PWD:/root/project --network=host -w /root/project my_node'
```

And you should be good to go, you know have npm wrapped inside docker.

> [!CAUTION]
> Wait! Now we have npm running with root rights inside docker, this could be problematic

Yes! Let's go try docker rootless then!

### Docker rootless

The [setup][docker_rootless_setup] is pretty straightforward, but I ran in a few strange things, so let's see that.

> [!NOTE]
> If you have docker already running as root, you may want to disable its
>
> ```bash
> sudo systemctl disable --now docker.service docker.socket
> sudo rm /var/run/docker.sock
> ```

You can launch the script `dockerd-rootless-setuptool.sh install`

Then confirm that docker is running rootless:

```bash
$ docker info
Client: Docker Engine - Community
 Version:    29.1.2
 Context:    rootless
...
Server:
...
 Security Options:
  seccomp
   Profile: builtin
  rootless
  cgroupns
...

```

I faced two issues.
First, I wanted my docker to be able to reach my computer address.

For this, We use the extra_hosts `host-gateway` inside our docker compose, but it does not work anymore with rootless mode.
There is an [issue still open][issue_host_gateway].

You have to enable host loopback by putting this environment variable to false in your `~/.config/systemd/user/docker.service`:

```systemd
Environment="DOCKERD_ROOTLESS_ROOTLESSKIT_DISABLE_HOST_LOOPBACK=false"
```

Then you have to set your IP address in the docker daemon config `~/.config/docker/daemon.json`:

```json
{
  "host-gateway-ips": [
    "MACHINE_IP_ADDRESS"
  ]
}
```

That's a real bummer, if you have a dynamic IP, that'll change...

The second issue is that I wanted to reach to container network with it's IP from my machine.
It's not possible with docker rootless (at least I did not found a way to do it, so I user --network=host more often now... on my development machine)

[issue_host_gateway]: https://github.com/moby/moby/issues/47684
[docker_rootless_setup]: <https://docs.docker.com/engine/security/rootless/#install>
[npmrc_doc]: <https://docs.npmjs.com/cli/v9/configuring-npm/npmrc?v=true#files>
[think_meme]: /images/think-meme.jpg
