---
categories: docker
date: "2015-12-05T00:00:00Z"
image: /images/posts/letsencrypt/meme.jpg
socialmessage: Http is dead, long live https!
tags:
  - letsencrypt
  - docker
title: Http is dead
---

In a [previous article][previous_article] I talked about switching to **_https_**.

Since the 3rd December, [_Let's Encrypt_][letsencrypt] is in public beta[^1], that means that everybody can have free trusted ssl certificates.

That's right, you heard it.

![OprahHttps][OprahHttps]

What would be an agileek article without a little bit of **Docker** in it?

# Goal

I will show you how to generate and use an ssl certificate with nginx.

First, you generate the certificate with:
{{< highlight bash >}}
docker run -it --rm -p 443:443 --name letsencrypt -v /etc/letsencrypt:/etc/letsencrypt -v /var/lib/letsencrypt:/var/lib/letsencrypt quay.io/letsencrypt/letsencrypt:latest --server https://acme-v01.api.letsencrypt.org/directory certonly -a standalone -d hello.bitard.fr
{{< / highlight >}}

Then you configure your nginx in order to use this certificates :

{{< highlight bash >}}
ssl_certificate      /etc/letsencrypt/live/bitard.fr-0001/fullchain.pem;
ssl_certificate_key  /etc/letsencrypt/live/bitard.fr-0001/privkey.pem;
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:50m;
ssl_session_tickets off;


# modern configuration. tweak to your needs.
ssl_protocols TLSv1.1 TLSv1.2;
ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!3DES:!MD5:!PSK';
#    ssl_prefer_server_ciphers on;

# HSTS (ngx_http_headers_module is required) (15768000 seconds = 6 months)
add_header Strict-Transport-Security max-age=15768000;

# OCSP Stapling ---
# fetch OCSP records from URL in ssl_certificate and cache them
ssl_stapling on;
ssl_stapling_verify on;

    ## verify chain of trust of OCSP response using Root CA and Intermediate certs

server {
        listen       443 ssl;
        server_name  hello.bitard.fr;

        location / {
            add_header Content-Type text/plain;
            return 200 'Take a look at this awesome certificate!';
        }
}
{{< / highlight >}}

Aaaaaaand it's done.

You can look at [https://hello.bitard.fr/][hello_https] and see that everything is ![so green][soGreen]

[previous_article]: /jekyll/2015/11/20/disqus-https-and-http/
[letsencrypt]: https://letsencrypt.org/
[OprahHttps]: /images/posts/letsencrypt/meme.jpg
[hello_https]: https://hello.bitard.fr/
[soGreen]: /images/posts/letsencrypt/super_green.gif
[donate]: https://letsencrypt.org/donate
[donate_eff]: https://eff.org/donate-le
[^1]: You can donate to them:  [https://letsencrypt.org/donate][donate] or to EFF: [https://eff.org/donate-le][donate_eff]
