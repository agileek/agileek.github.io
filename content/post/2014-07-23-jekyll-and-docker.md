---
categories: docker jekyll
date: "2014-07-23T00:00:00Z"
lastmod: "2015-11-08"
redirect_from: /jekyll/docker/2014/07/23/jekyll-and-docker/
title: Jekyll quickstart with docker
---
![Jekyll][jekyllImage]{: .float_image }

This is my first blog post!

It's been quite some time that I wanted to start it but I never had the energy to do it.

After a quick search on blog engines, I decided to give a try to [Jekyll][jekyll], since it is integrated with github pages and is very simple to use.
I followed their tutorial and Bam!

{{< highlight bash >}}
$ sudo gem install jekyll
Building native extensions.  This could take a while...
ERROR:  Error installing jekyll:
	ERROR: Failed to build gem native extension.

        /usr/bin/ruby1.9.1 extconf.rb
/usr/lib/ruby/1.9.1/rubygems/custom_require.rb:36:in `require': cannot load such file -- mkmf (LoadError)
	from /usr/lib/ruby/1.9.1/rubygems/custom_require.rb:36:in `require'
	from extconf.rb:1:in `<main>'


Gem files will remain installed in /var/lib/gems/1.9.1/gems/fast-stemmer-1.0.2 for inspection.
Results logged to /var/lib/gems/1.9.1/gems/fast-stemmer-1.0.2/ext/gem_make.out
{{< / highlight >}}

It didn't work on my computer... and since i'm a lazy person, I get tired really fast when things don't work like expected.

On the other side I'm a huge [Docker][docker] fan, so I looked for a dockerized jekyll and I found this one: [Jekyll with docker][jekyll-docker].

In 3 steps, this blog was on:

{{< highlight bash >}}
# Added alias to use 'jekyll' command easily
$ echo alias jekyll=\'sudo docker run --rm -v \"\$PWD:/src\" -p 4000:4000 grahamc/jekyll\' >> ~/.bash_aliases
# Create a blog in 'blog' directory
$ jekyll new blog
$ cd blog
# Serve the blog on http://localhost:4000 and automatically reload on file changes
$ jekyll serve --watch
{{< / highlight >}}

This was painless for me, as someone else already had a jekyll correctly installed and working in a docker environment.

Thanks [Graham Christensen][grahamc]!


## Update 2015-11-08
I now use the official docker image, and I made a Makefile that you can reuse :

{% gist MichaelBitard/88d922d0615bcf78b720 jekyll.Makefile %}

There are 2 commands:

- `test` will serve on port 4000 with drafts enabled
- `deploy` will build everything, commit it on master for gh-pages, waiting for you to push


[jekyll]:    http://jekyllrb.com
[docker]:    https://www.docker.com/
[jekyll-docker]: https://registry.hub.docker.com/u/grahamc/jekyll/
[grahamc]: http://grahamc.com/
[jekyllImage]: /images/posts/2014-07-23/jekyll.png
