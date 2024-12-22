---
categories: java
date: "2015-04-09T00:00:00Z"
title: 'Devoxx France : jour 2'
aliases: ['/java/2015/04/09/devoxx-france-second-day/']
---

![Devoxx][devoxxFrance]{: .float_image }

## Keynotes

Cette première session de keynotes va nous parler du futur de l'informatique.

### Aldebaran

Le premier speaker nous parle de ce que sera la robotique dans le futur, au travers de sa société.

Les premières applications seront probablement l'assistance aux personnes agées, ce qui ne sera pas disponible avant 5 ans, à cause des problématiques de reconnaissance vocale à distance.

Pour lui, dans 20 ans les robots seront devenus des compagnons présents dans nos logements, nous assistant dans nos taches quotidiennes. Il seront en quelque sorte au coeur de la domotique.

Petit point bluffant avec ces petits robots : ils sont capables de détecter les émotions (colère, tristesse) au travers des dialogues.

#### Quelle responsabilité pour le développeur

Le robot est un outil, il peut être bien ou mal utilisé.

Le robot est une plateforme programmable par n'importe qui, intégrer les  lois de la robotique d'Asimov s'avère compliqué, et au final pas très efficace (Si on lit ses livres, on se rend compte qu'elles ne fonctionnent pas).

Il existe un problème lié à la responsabilité du robot. Qui est responsable en cas d'accident? Le robot ? La société qui a crée le robot ? Le développeur ?

### La problématique du contrôle des technologies de l'information

Excellente proposition : après Devoxx4Kids, faire un Devoxx4HommesPolitiques.

La problématique actuelle est la démocratisation des outils informatiques. Les premiers acteurs de l'informatique étaient des techos qui avaient un idéal, maintenant ce sont des gens qui ne maitrisent pas la technique et sont intéressés par le pouvoir.

Cinq phases de contrôle :

* Préhistoire
* Phase de mutation
* Phase de globalisation
* Phase légale
* Phase d'assimilation culturelle

> Qu'on me donne six lignes écrites de la main du plus honnête homme, j'y trouverai de quoi le faire pendre (Richelieu)

Le problème qui se pose derrière la surveillance globalisée qui se met en place, c'est que le citoyen n'est plus "présumé innocent", mais "présumé coupable", ce qui change les fondements de notre société.

Le scénario de l'espoir :

* Le respect de la vie privée redevient une priorité
  * Inscription dans la constitution
  * Renforcement du rôle du juge d'instruction
  * Création d'un comité d'éthique
* Nous redevenos des citoyens
* Développement du marché de la confiance


En conclusion :

* L'espionnage des citoyens par leur propre état trahit la faiblesse et la peur de ces états
* Le rôle fondamental des concepteurs et des developpeurs
  * Ce sont les gardiens de la technologie
* La liberté sans libre arbitre n'existe pas et le libre arbitre sans le respect de notre vie privée n'existe pas


## Reading and writing in 20 years

Aujourd'hui, tout ce que nous écrivons a une durée de vie qui nous dépasse (on peut retrouver ses premiers email facilement), c'était quelque chose qui n'était pas possible avant, pas à cette échelle. Que se passera-t-il dans 20 ans ?


Il nous parle beaucoup de la capacité qu'on a maintenant à écrire, à partager[^1] de plus en plus facilement. Mais il nous parle également des freins que l'on peut rencontrer.

Quelles sont les contraintes actuelles qui nous empêchent de publier ? Il prend pour exemple le PDF, en tant que technologie du passé qui s'accroche encore au support papier et qui nous impose des contraintes (Je possède un kindle, c'est tout simplement impossible de lire un PDF, ce n'est pas du tout adapté)

## Quickies
Haa, les quickies, ou le gros dilemme du : je mange ou j'assiste à une conf ?


### Avro : la souplesse du Json, les performances du binaire

Outil de sérialisation, c'est à la base un sous projet d'hadoop.

Il est utilisé dans hadoop pour stoquer des gros volumes de données dans des fichiers.

L'idée derrière ce lightning talk c'est de montrer qu'il est possible d'utiliser Avro pour autre chose que du bigData. Tout transfert de données un peu important (Rest, ...) peut être amélioré avec Avro. Il permet d'encoder nos données dans un format spécifique. IL permet en plus d'ajouter simplement des compresseurs afin d'optimiser les transferts.

La killer feature : il est possible de spécifier un schéma d'écriture et un schéma de lecture, ce qui permet de pouvoir extraire que les données que l'on souhaite utiliser et ainsi gagner du temps et de la place. (Il y a une méthode qui permet de vérifier la compatibilité entre le writer et le reader)

Les [sources][sources_avro].

## Changing wheels of a moving car

Présenté par Nicolas De Loof. Cet homme est fou :)

Je préfère ne pas vous spoiler cette session, il faut la voir[^2]. Il nous parle de son retour d'expérience sur cloudbees, notamment ses déboires/surprises avec le cloud amazon.


## Modular Java Platform

### Constat

Java connait un certain nombre de problèmes, notamment :

* Taille
  * Java a continuellement grossi avec le temps (55 MB). Ce n'était pas forcément un problème vu le prix du stockage, c'est en train de le devenir avec l'émergence de l'IoT.
* Démarrage
  * Java est lent à démarrer (la compilation dynamique, JIT, ...) sans parler du classloader.
* Sécurité
  * Le security manager est trop limité, de plus personne ne s'en sert (2 mains levées dans l'assistance)
* Utilisation d'api internes
  * Rien n'empêche d'utiliser ces api.
* Jar hell
  * On connait tous les problème de versions multiples dans le classpath


### Jigsaw

En rendant Java modulaire, les problèmes cités ci-dessus devraient disparaitre (ou être plus simples à addresser).

Pour le moment, ils ont identifié une cinquantaine de modules dans le JDK. Il y'a 4 JEP (200, 201, 220...)

JShell : java va enfin avoir son REPL !

#### JEP 201: Modular Source Code

Toutes les sources ont du être déplacées pour les pre-fixer par leur module.

#### JEP 220: Modular Run-Time images

Pour récupérer une SystemResource (ClassLoader.getSystemResource()), java ne retournera plus un path du filesystem mais plutôt un pointeur vers la resource. Ça risque de faire mal à migrer.


#### Ce qui change pour nous

Un nouveau format de fichier apparait : jmod.
Le Jar étant juste un zip renommé, il est trop limitant et aucune meta-data ne peut y être ajouté (c'est faux, Osgi par exemple se sert du MANIFEST.mf, mais ça reste une convention). Le .jmod permet de déclarer les dépendances aux différents modules java, afin d'avoir un arbre de dépendance très fin.


```sun.*``` et ```*.internal.*``` ne seront plus accessibles (un support temporaire est prévu pour aider aux migrations).

jdeps : permet de savoir quels sont les apis de base dont notre code dépent (accessible depuis java 8).

rt.jar et tools.jar ont disparu.

[devoxxFrance]: /images/posts/devoxx/devoxx_france.png
[sources_avro]: https://github.com/alexvictoor/AvroDevoxxFr

[^1]: Ce blog en est la preuve
[^2]: Dès que le lien est sur Parleys, je linkerai la vidéo ici
