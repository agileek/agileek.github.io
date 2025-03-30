---
categories:
- software
date: "2025-03-30T00:00:00Z"
tags: ["software"]
title: Publishing this blog on Gemini
summary: Using Hugo
---

TLDR: I have [my blog][blog_gemini] published on gemini.
You can look at my [Pull request][pull_request] if you want to copy/paste the code for Hugo.

I've looked at [Gemini][gemini] for quite a while, and I wanted to use it for this blog.
Some time ago I used Jekyll and could not found any resource on how to create gemini files from jekyll.

I switched to Hugo some time ago and I tried to output to gemtext, without success.

This time I really gave it a try and I think I found a nice setup.

I relied on 2 blog posts I found, the first one by [Sylvain Durand][sylvaindurand] and the second one by [Brain baking][brainbaking]

These resources were quite outdated, they both gave up on gemini after quite some time, which I can understand but at the same time makes me sad.

## Main issue

My biggest problem is the conversion of links into a Gemtext compatible format.
For those who use the inline syntax (brackets+parentheses), that's pretty straightforward, but I use the markdown indirections, where all my links are at the bottom of the document.


First I had to create a map containing all the key/url pairs.
Then replace every link in my document with a reference number.
And finally, display all the references at the end of the document.

## Build and serve

You can have a look at this [pull request][pull_request] to glue this together, then you can build and deploy.

Building is as easy as typing `hugo build`.
To deploy, I used [Agate][agate] server, with the docker image it's as easy as `docker run --name gemini -d --restart unless-stopped -p 1965:1965 -v /path_to_public_folder/:/gmi:ro -v /path_to_certs:/certs ghcr.io/mbrubeck/agate:3.3.14 --hostname blog.bitard.fr`

From now one, I should by able to publish both on the web and on Gemini \o/


[agate]: https://github.com/mbrubeck/agate
[blog_gemini]: gemini://blog.bitard.fr
[pull_request]: https://github.com/agileek/agileek.github.io/pull/3
[gemini]: https://geminiprotocol.net/
[sylvaindurand]: https://sylvaindurand.org/gemini-and-hugo/
[brainbaking]: https://brainbaking.com/post/2021/04/using-hugo-to-launch-a-gemini-capsule/
