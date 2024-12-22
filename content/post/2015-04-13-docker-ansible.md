---
categories: docker
date: "2015-04-13T00:00:00Z"
title: Poste de dev avec docker et ansible
aliases: ['/docker/2015/04/13/docker-ansible/']
---
![meme][meme]
Vous avez un projet où il faut 3 jours d'installation acharnée en suivant un wiki obsolète pour réussir à faire un premier commit ?

Vous n'osez plus mettre à jour votre poste depuis 2006 de peur de ne plus pouvoir travailler ?

Vous en avez marre d'oublier de mettre à jour le wiki chaque fois qu'il faut installer quelque chose de nouveau pour votre projet ?

Ce post est fait pour vous !


## Idée originale

A mes débuts chez Orange Business Services (en fait, c'était CVF, puis MBS, puis OBS et maintenant OAB...), je suis tombé dans une super équipe avec laquelle j'ai appris énormément de choses. Je travaillais sur une partie écrite en Erlang et j'avais été impressionné car en quelques minutes, j'avais un environnement de travail de base prêt à l'emploi, léger et entièrement customisable.

C'était à base de [chroot][chroot] (Ils ont écrit 2 articles à ce sujet, le premier sur la [création d'une chroot][creer_chroot] et le deuxième sur la [connexion à cette chroot][connecter_chroot]), ça fonctionnait très bien, je m'en suis servi sur bon nombre de projets, en le faisant évoluer.

Au début nous packagions la chroot en tgz pour la partager mais chaque fois qu'il y avait une modification il fallait tout repackager/redistribuer. On a changé d'approche en construisant une chroot minimale très stable, customisée directement sur le poste du developpeur avec puppet.

Puis l'approche de puppet n'étant pas satisfaisante[^1], nous sommes passés à Ansible.

Puis la chroot nous a posé pas mal de soucis, notamment sur les changements de version d'Ubuntu (ok, on pourrait utiliser debian), donc on est passé sur docker (il faut dire aussi que, comme docker c'est plus hype, chez mon client les développeurs étaient plus intéressés pour tester docker).

Comme vous pouvez le voir, ça a pas mal évolué, jusqu'à arriver à ce que je vais vous présenter maintenant.

## Le principe de docker-ansible

* Utilise ansible pour construire une image docker custom
  * On joue avec les uid/gid d'un user pour permettre le lancement d'applis graphiques dans docker
  * On monte '/usr/bin/docker' et '/var/run/docker.sock' pour accéder à docker depuis le container
* Une fois l'image buildée, on la lance avec ansible
  * On monte par défaut tout ```/home/developer``` (c'est l'utilisateur dans le docker), ce qui permet de tout persister sur son poste et de pouvoir réinitialiser docker sans perdre de données
* Pour finir, on customise cette instance avec ansible

### Utilisation

1. Forker [github.com/agileek/docker-ansible][docker-ansible]
2. Copier vars_example.yml vers vars.yml
  * Customiser vars.yml (vous pouvez même surcharger les variables dans ```ansible/default_*.yml``` à cet endroit)
3. lancer ```./launch.sh path_to_save_docker_home_folder```
4. lancer ```./enter.sh``` pour rentrer dans le docker

Résultat attendu :

Vous êtes dans le container, dans le home de l'utilisateur developer, qui est sudoer et ne possède pas de mot de passe. Vous avez accès à votre docker parent (donc vous pouvez tuer votre propre docker, attention ;)). Tout ce que vous écrivez dans /home/developer se retrouve dans path_to_save_docker_home_folder avec les mêmes droits que votre utilisateur linux.

### Mise à jour de l'image docker

1. Modifier ```ansible/customize_docker_container.yml```
  * Par exemple, vous pouvez rajouter ```meld``` pour tester qu'une application graphique fonctionne bien
2. Relancer ```./launch.sh path_to_save_docker_home_folder```
3. Vérifier que ce que vous avez fait est effectif dans le container docker.

### Cycle de vie

Nous, nous avons, par projet, un repo git docker-ansible, qui contient tout un tas d'utilitaires (bash, git-prompt, serveur mysql avec bases et droits, serveur neo4j, l'IDE, des alias pour se connecter aux machines, alias git ...) que chacun est libre de faire évoluer par un simple commit git. Il suffit pour récupérer les modifications de faire un git pull, puis de relancer le launch.sh (ça ne tue pas l'instance docker, donc c'est peu risqué, on peut continuer à travailler).

### Tips

La bonne approche, pour moi, est de ne pas figer le poste de développement à travers des process lourds, ou une sur-automatisation du poste. Par exemple dans le .bashrc il y a une partie qui essaie de sourcer ```~/.bash_perso``` et ce ```bash_perso``` n'est pas managé par ansible, ce qui permet à tout un chacun de personnaliser son poste. C'est quelque chose qu'il faut garder à l'esprit si on ne veut pas se retrouver avec quelque chose de très lourd à maintenir.

Chez mon client actuel, au début nous clonions tous les projets git avec ansible, c'était très pratique mais très lourd, maintenant nous avons convenu d'un certain nombre de projets de bases, les autres sont clonés 'à la mano'. Ça permet de ne pas se retrouver perdu quand on va binomer sur le poste du collègue. Après, testez, refactorez, expérimentez, allez-y, c'est vraiment fait pour ça et je pense que c'est vraiment pour ça que ça plait. Au final on est quand même capable de REFACTORER son poste de dev !

### Futur

Je voulais à la base mettre tous mes dotfiles directement dans ce projet, mais je me rends compte qu'il est plus intéressant de faire une version minimale et de laisser les membres de l'équipe apporter au fur et à mesure les outils qui leur font gagner du temps, permettant ainsi d'arriver à un poste de travail vraiment commun.


[meme]: /images/posts/docker-ansible/meme_post_fait_pour_vous.jpg
[chroot]: http://fr.wikipedia.org/wiki/Chroot
[creer_chroot]: http://www.barreverte.fr/creer-un-chroot-part-1-un-linux-de-base/
[connecter_chroot]: http://www.barreverte.fr/creer-un-chroot-part-2-se-connecter/
[docker-ansible]: https://github.com/agileek/docker-ansible
[^1]: c'est un avis très personnel, que je pourrais argumenter si besoin
