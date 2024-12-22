---
categories: java
date: "2015-04-08T00:00:00Z"
title: 'Devoxx France : Jour 1'
aliases: ['/java/2015/04/08/devoxx-jour-1/']
---

## Devoxx France

![Devoxx][devoxxFrance]

## 09:30-12:30 [Google Cloud Platform][hands_on_GCP]

### Présentation de Google Cloud Platform par David Gageot et Ludovic Champenois.

J'ai hésité avec "Quand Devops rencontre BigData", mais il est trop tôt pour attaquer violemment avec du spark.

Le but de cette session est de nous présenter une bonne partie de l'infrastructure google cloud au travers du déploiement d'une application de vote de tapis[^1].

Pas de slides pour cette session, tout est live.

Énormément de produits sur [https://cloud.google.com][https://cloud.google.com] :

* Compute
  * Compute Engine
  * App Engine
  * Container Engine
* Storage
  * SQL
  * Storage
  * Datastore
* Networking
  * Load Balancing
  * Interconnect
  * DNS
* Big Data
  * BigQuery
  * Dataflow
  * Pub/Sub
* Services
  * Translate API
  * Prediction API
  * Endpoints
* Management
  * Deployment Manager
  * Monitoring

Petit fait intéressant, SnapChat tourne sur App Engine et ce sont les équipes de google qui s'occupent de la scalabitité de SnapChat.

L'idée derrière le google cloud, c'est de pouvoir changer de stratégie (Je gère ma VM, ça monte en charge, je passe sur AppEngine) sans que ça soit coûteux.

### Coût d'une VM

Chaque VM est facturée à la minute de CPU (les 10 premières minutes sont indivisibles).

À titre d'exemple, ils ont joué une semaine avec l'application de démo, ils ont fait des benchs (pour pousser le CPU) et ça leur a coûté 28$.

### Dockerizer la démo

L'idée c'est que plutôt que de lancer une VM, de la configurer et d'installer son application, on crée une image docker qu'on va déployer sur le cloud.

L'intérêt principal est de pouvoir tester son conteneur sur son infrastructure, puis de le déployer chez google.

Avec Docker machine, il est possible de créer des VMs et de tout configurer directement dans le cloud google, c'est franchement impressionnant.

Il est également possible de faire les mêmes commandes que sur sa machine, mais sur le cloud avec :

{{< highlight bash >}}
docker $(docker-machine config mavmgoogle) ps
{{< / highlight >}}
> le "docker-machine config mavmgoogle" permet de récupérer toutes les options docker pour se connecter au docker de la vm.

Quelques petits soucis avec Docker et Google Cloud, il travaillent dessus.

### GRPC

[Google RPC][grpc_io], nouveau service de google pour les messages entre machines.

C'est un langage, le Protocol Buffer, qui génère des clients et des serveurs dans plein de technos différentes.

Annoncé comme plus puissant que XML, plus léger que Json. Utilisé en interne chez google depuis 15 ans, il est open-sourcé depuis peu (0.0.4).

### App engine

Après avoir joué avec les VMs, puis docker, maintenant le déploiement se fait bien app-engine.

> AppEngine permet de faire tourner une collection de modules, avec plusieurs versions. Ça permet nativement le traffic splitting pour tester différentes versions en live.

Il a suffit d'un app.yaml à la racine pour décrire ce qui va se lancer. Il est possible de déclarer des règles (à la manière d'une conf nginx) pour déclarer les resources statiques et dynamiques, pour éviter de solliciter l'applicatif pour servir du contenu statique.

Le déploiement docker sous app-engine crée automatiquement un registry privé, donc les images docker ne sont pas accessibles par les autres comptes.

### Console

La console est complète, fonctionne en application mobile également.

Un full accès aux logs en live est possible

#### BigQuery

Il est possible de streamer les logs en live vers BigQuery, ce qui permet une approche plus intéressante de nos logs "plats".
Pour la démo, les logs (un log par vote) de l'application sont insérés dans BigQuery et permettent de sortir toutes les informations des votes, donc de pouvoir double checker que les résultats calculés par l'applicatif sont cohérent.

### Runtime supportés

Avec la contenairization, AppEngine s'ouvre au monde. Google supporte Java, NodeJs, Go, Python, Ruby. Ils sont en train de définir les contraintes pour pouvoir rajouter un runtime custom, la communauté C# travaille déjà à supporter C# dans AppEngine.


### Debug

Il est possible de connecter différents SCM (github, bitbucket,...) à son projet afin de pouvoir naviguer dans le code source sans quitter la console google.

C'est par cette interface qu'il y a la possibilité de debugger. Ce n'est pas vraiment du debugger au sens où on ne peut pas attacher de breakpoint et arrêter l'application. Il s'agit plutôt d'un watchpoint, qui permet de prendre des snapshots mémoire aux endroits indiqués. Super puissant comme outil, il permet vraiment de capturer l'état de l'application, sans bloquer l'expérience utilisateur. La démo a été faite sur NodeJs et Java, c'est impressionnant.

### Kubernetes

Un groupe de machine (un pod) déployé en cluster. On décrit l'état souhaité de l'environnement (3 JVM, 1 Nginx) et le cluster se débrouille pour faire tourner tout ça "au mieux". Il est capable de relancer les services sur d'autres machines si la machine venait à planter par exemple. Ce qu'il faut retenir au final c'est qu'avec 2 fichiers de conf on est capable de déclarer une architecture complexe à déployer, ça fait rêver.

### Firebase

Solution de Backend As A Service, rachetée par google il y'a 6 mois, pour faire face au rachat de parse par facebook (la guerre continue).
Regardez le nobackend.coffee dans la démo. C'est juste bluffant. Firebase peut notifier les différentes applis d'une mise à jour de son état, en websocket.



La démo est bien évidemment sur [github][fluenthttp_demo], elle contient de quoi lancer l'application en java, mais aussi en node js. D'ailleurs, n'hésitez pas à comparer les code produit en nodeJs avec celui en Java, vous serez surpris. Un article sur FluentHttp est prévu, c'est, je pense, le meilleur serveur web java8.

## 13:30-16:30 Hackergarten

Hop, dès la deuxième session on s'écarte du [planning][planning_devoxx].

Je suis allé faire un tour du côté des [Hackergarten][hackergarten]

> A Computer Programming Contributor Group

afin de contribuer sur un projet de la communauté open source.

À Devoxx le principe est le même que partout : des porteurs de projets présentent leur projet et des groupes se forment pour corriger des issues, ou ajouter des fonctionnalités au projet.

Voici les sujets de cette année :

* AsciiDoctor
* Golo
* FluentLenium
* Mockito
* JHipster
* RestX
* VoxxRin
* Ceylon
* XWiki


J'ai choisi [FluentLenium][fluentlenium] que j'ai pas mal utilisé dans des missions précédentes. C'est un wrapper de Sélénium en java, vachement plus simple à utiliser que Sélénium, avec tous les outils à portée de main pour faire ses tests sans galérer.


### Bilan

C'est très intéressant de rentrer rapidement sur un projet par une issue, c'est un très bon exercice.
En plus ce n'était pas du temps perdu, car ma [merge request][merge_request] a été acceptée !

Je repars avec du travail, j'ai trouvé de la duplication entre [Fluent][fluent_duplicate] et [FluentAdapter][fluent_adapter_duplicate] (la méthode initPage).

***Quand est-ce qu'on organise ça sur Toulouse?***

## 17:10-17:40 Le taré du terminal

Les sources sont [là][sources_command_line_nuts].

Principe : Automatiser un maximum de choses pour ne pas casser son workflow quand on développe.

Premier outil : Tmux, l'incontournable émulateur de terminal.

### Deuxième outil : Vim

Pas besoin de le présenter. Il découpe les commandes avec [action][repetition multiplier]

* Remettre plusieurs lignes sur une seule : passer en mode visuel, sélectionner les lignes et taper 'J'.
* f[character] : Aller au premier charactère trouvé
* ci : se mettre sur une parenthèse, remplace tout ce qu'il y'a à l'intérieur des paranthèses.

Il existe des plugins pour avoir les raccourcis vim dans les IDE : IdeaVim (IntelliJ) et Vrapper (Eclipse)

### Dotfiles

Conseil : les mettre sur git

### Misc

* git
  * Tig : un outil git en ligne de commande
  * send-pull-request : script qui crée automatiquement une pull request sous github
* Commandes : faire un script qui lance la commande et qui envoie une notif d'OS à la fin (remote)

## 18:40-19:10 Maven

### Jongler entre les différentes versions

Avec la prise en charge de Java par Oracle, les versions sont ```deprecated``` beaucoup plus rapidement (en fait, elles ne sont pas dépréciées, elles deviennent juste ... payantes).

Java 6 devient très très payante et Java 7 devient deprecated ce mois-ci. Il faut donc pouvoir switcher de plus en plus rapidement et avec le moins de surprises (Ou prendre le support oracle et payer pour conserver les anciennes versions).

Les différents conseils :

* Utiliser les properties ```maven.compiler.target``` et ```maven.compiler.source``` pour spécifier la version Java
* Utiliser le maven-enforcer-plugin ```enforceBytecodeVersion``` pour s'assurer que toutes les dépendances sont utilisables par une JRE donnée
* animal-sniffer-maven-plugin permet de contrôler que les bonnes versions d'API sont utilisées (ça peut être une rule CheckSignature dans le maven enforcer plugin pour éviter la multiplication des plugins)

### Toolchains et JDK

Permet d'utiliser un JDK pour compiler indépendant du JRE avec lequel Maven et ses plugins s'exécutent.

L'idée c'est d'utiliser un JRE récent pour exécuter maven et ses plugins, tout en utilisant un autre JDK pour les phases de compilation.

> Des toolchains customs existent pour protobuf, netbeans, ...

### maven-jdeps-plugin

* Analyse statique des dépendances (préparation à JigSaw)

## Les autres confs marquantes

J'ai fait un petit tour auprès des gens que je connais et qui font devoxx pour savoir quelle avait été leur session préférée, ça me permettra de voir quoi regarder une fois les vidéos sur Parleys.

Dans le désordre nous avons :

* Hackergarten (Celle là ne sera pas sur Parleys)
* Spring boot

[devoxxFrance]: /images/posts/devoxx/devoxx_france.png
[hands_on_GCP]: http://cfp.devoxx.fr/2015/talk/GOB-3561/La_Google_Cloud_Plaform_-_Au_dela_des_simples_demos
[fluenthttp_demo]: https://github.com/CodeStory/devoxxcarpet
[grpc_io]: http://www.grpc.io
[planning_devoxx]: http://agileek.github.io/java/2015/04/07/before-devoxx-france/
[hackergarten]: http://hackergarten.net/
[fluentlenium]: https://github.com/FluentLenium/FluentLenium
[merge_request]: https://github.com/FluentLenium/FluentLenium/pull/159
[fluent_duplicate]: https://github.com/FluentLenium/FluentLenium/blob/master/fluentlenium-core/src/main/java/org/fluentlenium/core/Fluent.java#L170
[fluent_adapter_duplicate]: https://github.com/FluentLenium/FluentLenium/blob/master/fluentlenium-core/src/main/java/org/fluentlenium/core/FluentAdapter.java#L102
[sources_command_line_nuts]: https://github.com/emmanuelbernard/command-line-nuts
[https://cloud.google.com]: https://cloud.google.com

[^1]: Si vous suivez le compte de David Gageot, vous comprenez mieux pourquoi il demandait qu'on lui envoie des photos de tapis.
[^2]: J'imagine qu'il y a des porteurs de projet sur Toulouse,
