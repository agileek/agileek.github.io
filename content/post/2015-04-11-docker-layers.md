---
categories: docker
date: "2015-04-11T00:00:00Z"
title: 'Docker Tips #2: Limit the layers'
aliases: ['/docker/2015/04/11/docker-layers/']
---

## Scenario

I want to transfer ***efficiently*** my images to the production machines.

### Given
My Dockerfile with android sdk

{{< highlight docker >}}
ADD http://dl.google.com/android/android-sdk_r24.0.2-linux.tgz /opt/android-sdk.tgz
RUN tar xzf /opt/android-sdk.tgz -C /opt/
RUN rm -f /opt/android-sdk.tgz
{{< / highlight >}}

built with ```docker build -t docker_layers .```

### When
I want to push it to the registry

### Then

It will push 3 layers:

* the first is the android tgz pushed into /opt
* the second is the ***extracted*** sdk into the /opt directory
* the last one is the deletion of the tgz

This is really not optimal, the first and third layer are useless. Worst, they use space on your filesystems, on your network when you pull/push, ...

## Solution

It is a good practice to merge common operations into one single docker command.

For this example it would be:
{{< highlight docker >}}
RUN cd /opt && \
    wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.0.2-linux.tgz && \
    tar xzf android-sdk.tgz && \
    rm -f android-sdk.tgz
{{< / highlight >}}

In that way you only have one layer commited, and it contains only the needed android sdk extracted.

### Caveats

There is one drawback with this particular approach: You lose the capacities of the ```ADD``` syntax.

If you build the first Dockerfile, you will notice that each time the tgz is downloaded. Docker then verifies that the file hasn't changed and if not, uses the cached image.

That means that if the tgz changes, there will be a new build, whereas with the one-line approach, it will not, because docker will just verify that the command hasn't changed, not the content downloaded by the wget.


## Templates

The general approach is :

* Prepare what you want to do
* Do it
* Clean everything that is not necessary


The example with the android sdk works for all archives that must be extracted.

Below are templates from our experience that we think doesn't alter readability while reducing the layers and the size of the docker image.

### APT
{{< highlight docker >}}
RUN apt-get update &&  \
    apt-get install -y whatever && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
{{< / highlight >}}


### Yum
{{< highlight docker >}}
RUN yum -y update && \
    yum -y install whatever && \
    yum clean all
{{< / highlight >}}

### An other ***very*** important thing is to keep your Dockerfile ***readable***

This example is, in my opinion, a bad one.

{% gist MichaelBitard/7bd7bc71385326ab3238 Dockerfile %}

> Yes, it's only one docker RUN command


#### PS

* If you know other tips to reduce the number of layers without losing readability, feel free to post a comment, I'll gladly add them here.
