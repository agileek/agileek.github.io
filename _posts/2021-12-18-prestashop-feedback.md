---
layout: post
title: "Retour d'expérience Prestashop"
categories: [artisanat]
date: 2021-12-18
tags: [france, artisanat, toulouse]
---

Sur ce blog post, je m'éloigne des sentiers battus pour découvrir un domaine que je ne connais pas trop : La vente en ligne.

## Contexte

Ma compagne s'est lancée dans [une activité][lespetitsbibis] où elle crée des produits du quotidien, cousus-main, avec du matériel issu de ressourceries ou de fins de rouleaux.
Ses enjeux/envies sont multiples : 
- Trouver une activité à temps partiel pour pouvoir conjuguer vie de famille et professionnelle
- Réduire nos déchets[^dechets]
- Gagner de l'argent[^argent]
- Essayer quelque chose de nouveau
- Faire quelque chose d'utile[^utile]

## État des lieux

Pour pouvoir vendre, il y'a plusieurs façons de faire :
- En ligne
- En boutique
- Dans des marchés (de créateurs, de plein vents, de noël, ...)

Comme on est sur un blog plutôt technique, on va se concentrer sur la partie "En ligne".

La partie "En ligne" se divise en 2 catégories, utiliser un service tiers (etsy, ...) ou faire sa propre boutique.
Ma femme ayant la chance de connaitre une personne technique dans son entourage (hey, mais c'est moi!) on est parti sur la boutique en ligne hostée soi-même (tant qu'à faire)

## Le choix des boutiques en ligne

Alors là c'est le chaos, y'a des solutions à peu près partout, du wordpress avec le plugin "shop", à des CMS possédant les bonnes extensions, à des solutions plus ou moins payantes (shopify, wix, ...)

Comme on part sur de la "petite" activité, les solutions hostées coûtent vite assez cher (alors qu'une journée de développeur logiciel, surtout quand c'est son mari, ça coûte pas grand chose !)

Bref, après de moultes péripéties, on s'est lancé sur du prestashop.

## La mise en place

En vrai, ça a été très vite, image docker lancée, configurée sur un MySQL, rien à dire, en quelques minutes il y'a un site qui tourne et avec lequel on peut jouer.
La prise en main n'est pas forcément simple pour qui n'est pas familier avec tout le jargon et l'agencement de la plateforme, mais une fois qu'on a trouvé ses marques, ça passe.

Le systême de thèmes est ce qui m'a donné le plus de fil à retordre, notamment pour pouvoir itérer rapidement sur les changements css.
Au début, j'étais obligé de recréer tout le zip du thème, de supprimer le thème existant pour le re-charger, perdre toutes les configurations, c'était hyper frustrant.
Jusqu'au moment où j'ai commencé à directement mettre le fichier css au bon endroit dans le path du serveur, et que j'ai désactivé le cache (attention à la prod)
À partir de là c'était plutôt simple, bien que long.


### Les outils

Pas mal de manipulation d'images avec Gimp, et quelques scripts, notamment pour éviter les bordures sur les images des catégories.

Si je veux avoir une image de 141x180, ça se passe en deux étapes :
- réduire la hauteur de l'image en 141
- supprimer tout ce qui est trop long

Il faut que l'image de base soit à peu près dans ce ratio là déjà, sinon on va croper et ça va ressembler à rien au final
```bash
convert original_image.jpg -resize 141x reduced_image.jpg
convert reduced_image.jpg -crop 141x180 final_image.jpg
```


### Les craintes

Ma plus grosse crainte est liée à l'hébergement et la maintenance de l'outil, les différents tests que j'ai pu faire pour restaurer les différents backups s'avère assez complexe.
Il n'y a qu'à voir le nombre de plugins de [backup/restore][presta_backup_plugin].

Comme ça reste une petite boutique, ce n'est pas vraiment critique, il n'y a pas de SLA à proprement parlé !



[^dechets]: Le gaspillage textile est [impressionnant][infographie_textile]
[^argent]: On y travaille
[^utile]: Les produits confectionnés sont utilisés par nous-même

[infographie_textile]: https://multimedia.ademe.fr/infographies/infographie-mode-qqf/
[presta_backup_plugin]: https://addons.prestashop.com/en/search?search_query=backup
[lespetitsbibis]: https://lespetitsbibis.fr