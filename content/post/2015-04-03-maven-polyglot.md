---
categories: java
date: "2015-04-03T00:00:00Z"
title: 'Maven 3.3.1: La mort du pom.xml'
aliases: ['/java/2015/04/03/maven-polyglot/']
---
![Maven][mavenLogo]

## Maven

Haaaa, maven, le seul, l'unique. On l'a tous détesté pour plein de raisons, que ce soit :

* son fonctionnement 'convention over configuration'
* sa lenteur
* sa capacité à télécharger la terre entière
* son cycle de vie limité.

Sans oublier sa syntaxe ultra verbeuse en ***XML***.

### Le constat

Petit rappel qui pique les yeux : voici comment déclarer ***UNE*** dépendance dans son pom :

{{< highlight xml >}}
<dependency>
    <groupId>net.code-story</groupId>
    <artifactId>http</artifactId>
    <version>2.83</version>
    <scope>test</scope>
</dependency>
{{< / highlight >}}

Ça fait quand même ***6*** lignes pour ***1*** dépendance, soyons réalistes, c'est juste ignoble...


### Polyglot
Annoncé il y'a très longtemps (j'en ai entendu parler en 2012, il y avait quelques articles prometteurs), maven-polyglot avait pour but de rajouter le support de plusieurs langages dans les pom. Ça a été complètement abandonné et toutes les resources ont [disparues du net][maven_polyglot_old].

C'est récemment revenu au goût du jour avec Maven 3.3.1 (17 mars 2015) et l'arrivée du "Core Extension Mechanism" amélioré. Maintenant, pour modifier le coeur de maven (ok, je simplifie), il "suffit" de rajouter à la base de son projet maven ```.mvn/extensions.xml```

### Concrètement, ça ressemble à quoi ?

À ça :

{{< highlight xml >}}
<?xml version="1.0" encoding="UTF-8"?>
<extensions>
  <extension>
    <groupId>io.takari.polyglot</groupId>
    <artifactId>polyglot-yaml</artifactId>
    <version>0.1.7</version>
  </extension>
</extensions>
{{< / highlight >}}

> Vous remarquerez que pour le moment on s'est pas trop débarrassé du XML, on en a même rajouté...

### Il s'est passé quoi ?
Concrètement, vous venez de rajouter le support de lecture des pom.yml et pom.yaml. ***C'est pas énorme ça ?***

Ensuite, Vous pouvez convertir votre ```pom.xml``` grâce à un plugin via cette commande :

{{< highlight java >}}
 mvn io.takari.polyglot:polyglot-translate-plugin:translate -Dinput=pom.xml -Doutput=pom.yml
{{< / highlight >}}

Et voilà, vous pouvez vous débarrasser du pom.xml et lancer ```mvn clean install```. Vérifier que tout fonctionne comme avant quand même, on ne sait jamais.

Pour le plaisir des yeux, voici la même dépendance en yaml
{{< highlight yaml >}}
- {groupId: net.code-story, artifactId: http, version: 2.9.1}
{{< / highlight >}}

Je trouve ça infiniment plus lisible. (Ok, c'est one-line, mais franchement, c'est lisible, essayez de mettre le xml sur une ligne, pour la blague).

### C'est tout ? C'est bon on peut supprimer nos pom.xml ?

Malheureusement non, car si maven s'en sort très bien, ce n'est pas le cas (encore) des IDE.

Donc pour le moment si vous tenez absolument à vous débarrasser des pom.xml, vous pouvez faire en sorte de transformer votre pom.yml en pom.xml avec le même plugin. Ça duplique les fichiers, c'est moche, mais ça fonctionne.

Si vous êtes un peu patient, vous pouvez attendre que votre IDE favori implémente le support du polyglot en natif.

#### Intellij
Pour avoir le support sous IntelliJ, n'hésitez pas à allez voter là : [IDEA-138776][idea_polyglot]

#### PS

* Je vous ai parlé que de yaml, mais il existe déjà plein d'autres langages
  * atom
  * groovy
  * ruby
  * scala
* En ruby par exemple il y'a la possibilité d'appeler du code ruby directement dans le pom.rb. Je trouve ça vraiment pas propre, à voir à l'usage.
* N'hésitez pas à aller voir les [différents exemples][polyglot_maven_examples]
* Un de nos pom faisait 205 lignes, il en fait maintenant 74, en étant plus lisible[^1]

[mavenLogo]: /images/posts/maven/maven_logo.png
[maven_polyglot_old]: http://stackoverflow.com/questions/11170057/what-happened-to-maven-polyglot
[idea_polyglot]: https://youtrack.jetbrains.com/issue/IDEA-138776
[polyglot_maven_examples]: https://github.com/takari/polyglot-maven-examples
[^1]: C'est mon opinion personnelle à moi, vous avez le droit de préférer le xml
