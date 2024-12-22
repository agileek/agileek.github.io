---
categories: docker
date: "2014-08-06T00:00:00Z"
lastmod: "2016-01-06"
tags: ["docker"]
title: Playing with docker and cpuset
---

For my client I need to benchmark a multi-threaded/multi-server solution.

Unfortunately, we only have a big server (128 GB, 32 cores,...) and we are putting all our instances on this single server.
As each instance is multi-threaded, we noticed that they often get in each others way, resulting in bad performances (context swapping, ...).

We solved this problem in 2 ways.

On one hand we used thread affinity in the application in order to bind some thread to a given CPU, and on the other hand we used [docker][docker] to authorize a given application to access only some CPUs (via cpuset).

To be sure that docker was correctly restricting the access to the CPUs, I created a [docker image][docker-image]:

If you run it with

{{< highlight bash >}}
$ docker run -ti --cpuset-cpus=6 agileek/cpuset-test
{{< / highlight >}}

it will take one cpu (the 7th) at 100%.

You can see it in action:

{{< youtube 1BMKK812y5A >}}

If you run it with
{{< highlight bash >}}
$ docker run -ti --cpuset-cpus=0,4,6 agileek/cpuset-test
{{< / highlight >}}

it will take all available CPUs (the 1st, 5th and 7th)

You can see it in action:

{{< youtube ITcyeL8V35I >}}


### Edit 2016-01-06
* Replace `cpuset` with `cpuset-cpus`
* [Smallest docker image][docker-cpuset] possible (1.5MB with 2 layers). The old one was ~10 layers and 180MB
* Use [cpuburn][cpuburn]

[docker]:    https://www.docker.com/
[docker-image]: https://registry.hub.docker.com/u/agileek/cpuset-test/
[cpuburn]: https://patrickmn.com/projects/cpuburn/
[docker-cpuset]: https://github.com/agileek/docker/tree/master/cpuset-test
