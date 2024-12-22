---
categories: jekyll
date: "2015-11-20T14:00:00Z"
title: Forcing https for GitHub Pages and Disqus
---

### Observation

This blog uses [GitHub Pages][github_pages], which are by default available using both **_http_** and **_https_** protocols.

The comments are powered by Disqus, and it works really well. Almost really well, actually, because something strange appeared using only **_https_**.

Why switching to **_https_** only ?

 - [Firefox starts to deprecate non secure **_http_**][firefox_http]
 - [Https as a ranking signal on google][google_https]
 - [Let's Encrypt is trusted!][letsencrypt][^1]

### Force **_https_** on Github Pages

I found this gist to force the **_https_** redirection, simple, efficient.

{% gist konklone/9968713 ssl-redirect.html %}

Then I noticed that some of the comments were gone. As you can see on the animation below, they appeared only when using **_http_**

![Disqus http vs https][http_https]

### Migrate Disqus comments

In fact, Disqus treat [http://agileek.github.io][agileek_http] and [https://agileek.github.io][agileek_https] as 2 differents sites[^2], so if someone post a comment on the **_http_** "version" it's not displayed on the **_https_** side.

Luckily, Disqus has some migration tools, and in this case an **"URL mapper"** which can be found in the admin section "https://YOURDISQUSNAME.disqus.com/admin/discussions/migrate/".

It's a three steps procedure:

 1. Download via Disqus admin tool the list of [blog posts.][initial_disqus_import][^3]
 2. Add a second column where "http" is [replaced by "https"][disqus_mapper]
 3. Launch the migration

24 hours later, all the comments are available via the **_https_** URL, and nobody can comment on the **_http_** part thanks to the script above.

[github_pages]: https://pages.github.com/
[firefox_http]: https://blog.mozilla.org/security/2015/04/30/deprecating-non-secure-http/
[google_https]: http://googlewebmastercentral.blogspot.fr/2014/08/https-as-ranking-signal.html
[letsencrypt]: https://letsencrypt.org/2015/10/19/lets-encrypt-is-trusted.html
[http_https]: /images/posts/jekyll/disqus_http_https.gif
[agileek_http]: http://agileek.github.io
[agileek_https]: https://agileek.github.io
[initial_disqus_import]: /images/posts/jekyll/initial_disqus_import.csv
[disqus_mapper]: /images/posts/jekyll/disqus_mapper.csv

[^1]: Ok, this is not relevant here since I'm using GitHub's certificates, but Let's Encrypt is just too huge to not talk about. I will soon write an article about it.
[^2]: The "issue" has been reported several times but never corrected, is this a hidden feature?
[^3]: There is a lot of unnecessary links, even my drafts appear here
