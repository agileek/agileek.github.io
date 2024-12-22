---
categories: java
date: "2015-04-10T00:00:00Z"
title: 'Devoxx France : jour 3'
---

![Devoxx][devoxxFrance]

## Keynote

### Un robot peut-il apprendre comme un enfant ?

On recommence avec les robots pour cette première keynote de Pierre-Yves Oudeyer.

Nous avons tous une vision des robots en tant qu'extension de nos mains (robots aspirateurs, ceux sur Mars, pour tondre la pelouse,...) mais Pierre-Yves essaie de créer des robots qui étendent notre esprit. Pour cela il se base sur l'observation de l'apprentissage des enfants. C'est bluffant de voir à quel point en analysant mathématiquement nos interactions avec le monde extérieur on peut modéliser le comportement d'un nouveau né.

#### Comment les langues naissent-elles ?

En mettant un groupe de robots "curieux" dans un espace restreint, on peut observer l'apparition d'un langage. Les robots désignent un objet et tentent de le nommer par paire. Au bout d'un moment un consensus apparait et ce mot se diffuse auprès des autres robots.

Il nous a également présenté [Poppy][poppy_project], un robot imprimé en 3D open source.


### The decentralization singularity

Stéphan Tual nous parle d'Ethereum. Il commence avec le constat de la centralisation d'internet (Facebook, Amazon), qui n'était pas intentionnel, mais a émergé par simplicité.

Pour ceux qui ne connaissent pas, Ethereum se base sur Bitcoin. L'idée est de mettre du code dans la blockchain pour que tous les éléments du réseau puissent l'exécuter et s'assurer qu'il n y a pas de fraude.

### Clever cloud

Le présentateur prend à contre pied le mouvement DevOps en nous exposant un parallèle très intéressant avec l'électricité. En effet au début de l'électricité les entreprises avaient leur propre façon de générer l'électricité, avec tous les écarts que ça implique (alternatif/continue, voltage). Aujourd'hui on ne se pose plus de question sur l'électricité, ça fonctionne, point.

L'infrastructure doit être pour les développeurs comme l'électricité : accessible sans même avoir à y penser, et fiable. J'avoue être plus proche du mouvement DevOps mais sa vision donne à réfléchir.


### Future\<Java\>

Brian Goetz nous parle pour cette dernière keynote du futur de Java, en nous parlant de son passé. Ayant suivi sa conférence hier, je n'ai pas appris grand chose à celle-ci.

Une chose très intéressante par contre, c'est l'arrivée (Java 10 ?) des value class, qui sont à la limite entre objets et type primitifs, permettant une abstraction équivalent à l'objet tout en ayant un comportement mémoire primitif.

Ça permettra ce genre de concepts, j'ai déjà hâte.

{{< highlight java >}}
public int integerSum(List<int> integers) {
	return integers.parallelStream().sum();
}
{{< / highlight >}}

Avouez que ça fait rêver non ?

## Des tablettes d'écriture aux tablettes pour écrire

Première session non technique. J'avoue que j'ai fait le choix à cause de la speaker : Clarrisse Herrenschmidt. Elle avait fait une keynote d'ouverture à Devoxx 2013 tout simplement fabuleuse. Elle avait parlé de l'histoire des chiffres, du début de l'humanité à aujourd'hui. C'est je pense la seule session à laquelle j'ai assisté et que j'ai re-regardée sur Parleys. Allez [la voir][histoire_ecriture], vous ne serez pas déçu.

Pour cette session elle nous parle de l'évolution de l'écriture avec l'essort des technologies modernes.

Les choses bougent un peu partout :

* 45 états américains sur 50 ont arrêté l'écriture cursive pour l'écriture script
* Allemagne, chaque chef d'établissement décide
* En Suisse, ils étaient passés à l'écriture script, ils en sont revenus et maintenant c'est de la responsabilité des cantons.

Depuis l'origine, ce sont les nombres qui ont amenés les modifications dans les langues (l'Homme est-il vénal ?).

> Écrire, c'est soumettre la main et le corps à l'activité mentale.

Betty Moreau nous parle ensuite de l'activité du cerveau lié à l'écriture. C'est en fait une activité qui occupe presque tout le cerveau.

Il y'a des différences fondamentales entre l'écriture cursive et l'écriture liée :

***L'écriture cursive***

* liée comme la pensée
* rapide

mais elle demande une finesse motrice importante à la différence de ***l'écriture script*** qui est :

* simple
* ressemblant aux écrits sur écran

mais son espacement donnant du sens est difficile à acquérir pour les petits et elle est lente.

Que se passe-t-il quand on se sert d'un clavier ? Le cortex sensori-moteur ne s'active pas. Le cerveau est statisticien, il se conditionne et se lasse, et il aime les récompenses.

Plusieurs études sont en cours pour évaluer l'impact de l'utilisation d'un clavier plutôt que l'écriture manuelle à l'école

Pour un test, ils ont pris 76 enfants de 33 à 57 mois, la moitié apprenant au stylo, l'autre au clavier. Il est apparu clairement que les enfants utilisant des stylos avaient une meilleurs reconnaissance des lettres que les autres.


La deuxième étude a été effectuée sur un échantillon de 1000 élèves de niveau CE1.

Ils se sont rendu compte que si l'écriture était correcte à 4 ans, le niveau de l'élève était meilleur en math ET en français[^1].


> Ne laissons pas de côté un quelconque savoir. Car un savoir ne peut être quelconque.


## Iot, Java and Autonomous Drones

Dernière conférence pour moi, il faut bien rentrer et ce n'est pas la porte à côté.

James Weaving va nous parler de programmation de drones autonomes. Concrètement il branche des RaspBerry Pi sur des quadcopters.

Ils ont fait plusieurs choix techniques :

* Parrot 2.0
* Parrots On Java/Parroteer
* Raspberry Pi
* PowerBank pour rendre le raspberry pi "autonome"

Le Raspberry Pi possède deux dongles wifi, un pour communiquer avec le parrot, l'autre sert d'access point pour pouvoir s'y connecter depuis son laptop.
Ils voulaient embarquer le raspberry pi directement sur le parrot, mais le poids supplémentaire le rendait trop instable.

Ils ont crée une API pour simplifier les commandes (Autonomous4J), et pouvoir envoyer des scénarios prédéterminés au drone.

Comme leurs tests étaient trop dangereux pour leur famille et leurs objets personnels, ils ont crée un simulateur 3D en JavaFX (Arf).

Toutes les resources sont sur le bitbucket [autonomous4j][autonomous4j].


## Conclusion

Encore une grosse édition Devoxx, bien fatiguante. Cette année est en demi teinte pour moi car je considérais Devoxx comme une conférence pour développeurs passionnés, mais j'ai croisé beaucoup de personnes qui étaient là "quasiment obligé" par leur entreprise parce que "Devoxx c'est cool".

En tout cas j'ai hâte que le vidéos soient sur Parleys pour visionner tout ce que je voulais aller voir et que j'ai manqué.

### PS

Dès que les vidéos sont sur Parleys, je vais repasser sur les 3 posts devoxx pour faire une jolie mise en forme et faire les liens vers les vidéos.


[devoxxFrance]: /images/posts/devoxx/devoxx_france.png
[poppy_project]: http://www.poppy-project.com
[autonomous4j]: http://autonomous4j.org
[histoire_ecriture]: https://www.parleys.com/tutorial/lhistoire-des-ecritures
[^1]: ce n'est pas forcément une relation de causalité directe
