---
categories: docker
date: "2016-03-10T00:00:00Z"
draft: true
tags:
- docker
- docker-registry
title: 'Docker Tips #4: Transferring images without registry'
---

## Scenario

I want to transfer ***efficiently*** my images to the production machines ***without*** a docker registry.

We all agree that the better way for tranferring images is to use docker registries, public or private ones.

However, sometimes you can't use a docker registry (In my case it's a client with some strange network constraints, we even talked about sending the docker images through usb key...)

### Docker save

No magic here, if you want to extract your images from a registry, or your local machine, you have to use `docker save`

{{< highlight bash >}}
Usage: docker save [OPTIONS] IMAGE [IMAGE...]

Save an image(s) to a tar archive (streamed to STDOUT by default)

  --help             Print usage
  -o, --output=""    Write to a file, instead of STDOUT
{{< / highlight >}}

When you are using a lot of images, the total size to transfer is the sum(all the layers * all the images). It could not be an issue, but when all your images are using the same base image (




[razberry]: http://razberry.z-wave.me/
[previous_article]: /
