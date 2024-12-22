---
categories: terminal
date: "2015-04-14T00:00:00Z"
title: 'HTTPie and json: REST in your terminal'
---

Je suis, comme [Emmanuel Bernard][tare_du_terminal], un taré du terminal. Ce que je trouve génial avec cet outil, c'est qu'on n'arrête jamais de découvrir de nouvelles choses.

Je vais vous parler de la combinaison de 2 outils pour jouer avec du Rest depuis votre terminal :

* [HTTPie][httpie], qui est un "cURL-like tool for humans"
* [json][json] (très mauvais nom), qui est un utilitaire pour travailler sur du json

Pour notre exemple on va jouer avec l'API de github, en essayant d'afficher tous les repos docker de l'organisation ```agileek```.

### Installation

Sous ubuntu/debian : ```sudo apt-get install httpie && npm install -g json```

Commençons par récupérer la liste des repos associée à mon organisation.

{{< highlight bash >}}
$ http https://api.github.com/orgs/agileek/repos
{{< / highlight >}}

Nous avons un joli résultat bien formaté ...

{{< highlight json >}}
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
...plein de headers...
X-XSS-Protection: 1; mode=block

[
    {
        "archive_url": "https://api.github.com/repos/agileek/agileek.github.io/{archive_format}{/ref}", 
        "assignees_url": "https://api.github.com/repos/agileek/agileek.github.io/assignees{/user}", 
        "blobs_url": "https://api.github.com/repos/agileek/agileek.github.io/git/blobs{/sha}", 
        "branches_url": "https://api.github.com/repos/agileek/agileek.github.io/branches{/branch}", 
        "clone_url": "https://github.com/agileek/agileek.github.io.git", 
        "collaborators_url": "https://api.github.com/repos/agileek/agileek.github.io/collaborators{/collaborator}", 
        "comments_url": "https://api.github.com/repos/agileek/agileek.github.io/comments{/number}", 
        "commits_url": "https://api.github.com/repos/agileek/agileek.github.io/commits{/sha}", 
        "compare_url": "https://api.github.com/repos/agileek/agileek.github.io/compare/{base}...{head}", 
        "contents_url": "https://api.github.com/repos/agileek/agileek.github.io/contents/{+path}", 
        "contributors_url": "https://api.github.com/repos/agileek/agileek.github.io/contributors", 
        "created_at": "2014-07-23T09:51:52Z", 
        "default_branch": "master", 
        "description": "", 
        "downloads_url": "https://api.github.com/repos/agileek/agileek.github.io/downloads", 
        "events_url": "https://api.github.com/repos/agileek/agileek.github.io/events", 
        "fork": false,
        "url": "https://api.github.com/repos/agileek/agileek.github.io",
        .... trop de données ...
    }
] 

{{< / highlight >}}

... mais il y a tout simplement trop d'informations. Si je veux trouver tous les repos qui ont un lien avec docker, comment je fais ? 

> Mes solutions précédentes consistaient en une série de awk, sed...<br /> 
Vous savez ces choses dont on est fier quand on a un résultat mais quand on revient dessus quelques temps plus tard, on ne comprend plus rien.

C'est là qu'intervient json. Pour y voir plus clair, n'affichons que les urls.

{{< highlight bash >}}
$ http https://api.github.com/orgs/agileek/repos | json -a url
https://api.github.com/repos/agileek/agileek.github.io
https://api.github.com/repos/agileek/docker
https://api.github.com/repos/agileek/docker-ansible
https://api.github.com/repos/agileek/docker-jenkins
https://api.github.com/repos/agileek/docker-tips
{{< / highlight >}}

> le '-a' indique qu'on descend dans un array

Voilà, ça pique moins les yeux quand même. Maintenant ne gardons que les urls qui contiennent docker

{{< highlight bash >}}
$ http https://api.github.com/orgs/agileek/repos | json -c 'this.url.indexOf("docker") >= 0' -a url
https://api.github.com/repos/agileek/docker
https://api.github.com/repos/agileek/docker-ansible
https://api.github.com/repos/agileek/docker-jenkins
https://api.github.com/repos/agileek/docker-tips
{{< / highlight >}}

Voilà, c'est terminé ! le ```-c``` indique que vous allez écrire du javascript pour retourner un boolean, je me sers du indexOf pour filtrer tout ce qui contient "docker".

### Pour aller plus loin

Je ne vous ai montré que l'interaction basique entre httpie et json, n'hésitez pas à jouer avec httpie pour faire des ```POST```, ```PUT```, ```DELETE```, c'est vraiment très intuitif, je ne peux déjà plus m'en passer.

### PS

Merci à [Cédric Gatay][cedric_gatay], des [Code Troopers][code-troopers] pour m'avoir fait découvrir HTTPie.

[tare_du_terminal]: http://agileek.github.io/java/2015/04/08/devoxx-jour-1/#le-tar-du-terminal
[cedric_gatay]: http://www.bloggure.info/
[code-troopers]: http://code-troopers.com/
[json]: http://trentm.com/json/
[httpie]: http://httpie.org/