---
categories: docker jekyll
date: "2015-04-02T00:00:00Z"
title: 'Jekyll : ajouter des catégories à vos menus'
---

## Jekyll

Comme il y'a ***énormément*** de posts sur ce blog, j'ai eu envie de pouvoir lister les posts par catégories.

Je me suis dis que c'était relativement facile, et au final j'y ai passé un moment avant de réussir à le faire fonctionner complètement avec githup pages.

J'ai trouvé des resources un peu partout mais rien qui expliquait de bout en bout la manipulation, d'où le post.

### Le générateur

Jekyll sert statiquement les pages, il n'y a donc pas la possibilité de récupérer les paramètres de l'url pour s'en servir.

Par exemple, j'aurais aimé que `http://agileek.github.io/?category=docker` fonctionne.

Ce n'est pas possible de le faire autrement que par javascript (ce qui implique de charger tous les posts côté client), ce que je ne trouve pas optimal.

Si vous voulez le faire, jetez un oeil au [commit][danielsiwiec_commit] de [@danielsiwiec][danielsiwiec]

#### Côté serveur

Je me suis attaqué aux plugins de jekyll, plus précisément aux [generators][jekyll_plugins_generator].

Je n'ai rien touché au code du générateur de catégories qui est dans la doc de jekyll:
{{< highlight ruby >}}
module Jekyll

  class CategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category

      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
    end
  end

  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'category_index'
        dir = site.config['category_dir'] || 'categories'
        site.categories.each_key do |category|
          site.pages << CategoryPage.new(site, site.source, File.join(dir, category), category)
        end
      end
    end
  end
end
{{< / highlight >}}

Par contre ce qu'ils n'expliquent pas (ou pas bien), c'est qu'il faut un fichier de template pour pouvoir générer toutes les pages de catégories.

Voici le [commit][commit_categories], qui contient également la partie template web (le `category_index.html`).

Et voilà, ça fonctionne parfaitement sur ***mon poste***.

### Et docker dans tout ça

Vous l'avez peut-être remarqué, mais il y'a le tag docker sur ce post, si vous vous demandez pourquoi, voilà la raison :

Github ne permet pas d'exécuter les plugins jekyll (il le lance avec `--safe`) donc ce qui fonctionnait ***sur mon poste*** ne fonctionnait pas en ligne.

Il me faut donc générer statiquement le blog et le commiter sur master "à la mano".

Comme je me sers déjà de docker pour [tester mon site][first_blog], autant m'en servir pour le builder.

Je me suis inspiré de [cet article][article_makefile], surtout de son [makefile][makefile], pour faire le [mien][my_makefile] :

{{< highlight make >}}
JEKYLL = docker run --rm -v "$(shell pwd):/src" -p 4000:4000 grahamc/jekyll
RUNNER = `whoami`
COMMIT = `git rev-parse --short HEAD`

test:
  @${JEKYLL} serve --watch -H 0.0.0.0 --drafts

deploy:
  @echo "Building site"
  @${JEKYLL} build
  @git checkout master
  @sudo chown -R ${RUNNER}. _site && sudo cp -r _site/* . && sudo rm -rf _*/
  @git add --all . && git commit -m "Jekyll deployment from commit ${COMMIT}"
  @echo "You can now push master"
  @echo "Once everything is valid, git checkout develop && sudo git clean -f -d"
  @python -m SimpleHTTPServer 4000
{{< / highlight >}}


Maintenant, je n'ai même plus besoin de me souvenir de la commande jekyll à taper, un simple `make test` suffit.

Quand je suis satisfait du résultat, un `make deploy` suivi d'un `git push` de `master` et c'est en ligne.

Du coup je me suis amusé à rajouter un [generateur d'archives][archives] qui me classe les articles par années. Inutile, donc indispensable. Si ça vous intéresse, le commit est [là][commit_archives_generator]

### Edit 2015-04-03
> Jean-Philippe m'a expliqué qu'il n'y avait pas besoin de générateur pour les archives, ce qui est beaucoup plus simple et plus propre.

> Voici la [page en question][archive_barre_verte]. Je vous conseille de faire un tour sur leur [blog][barre_verte], c'est fait par des anciens collègues que j'apprécie énormément.

## Résultat

Maintenant, les images à droites des posts sur la page principale sont cliquables!!!!

C'est pas magnifique ça? Non? Mince alors.

#### PS :
* Petit précision, ça peut fonctionner avec les 'tags' bien sûr

[first_blog]: http://agileek.github.io/docker/jekyll/2014/07/23/jekyll-and-docker/
[article_makefile]: http://nicoespeon.com/en/2013/04/building-a-multinlingual-jekyll-blog/
[makefile]: https://github.com/nicoespeon/nicoespeon.github.io/blob/develop/Makefile
[my_makefile]: https://github.com/agileek/agileek.github.io/blob/develop/Makefile
[archives]: http://agileek.github.io/archives/index.html
[commit_archives_generator]: https://github.com/agileek/agileek.github.io/commit/5f60f98cac273ee53dc4b458a06ba9e668f054b7
[danielsiwiec]: https://github.com/danielsiwiec/
[danielsiwiec_commit]: https://github.com/danielsiwiec/danielsiwiec.github.io/commit/cf04dd322f5ffe2251ca6e3733d2707c2eaec7d4
[commit_categories]: https://github.com/agileek/agileek.github.io/commit/14d1c8ffb3863fd5746cb28daefa5aee3f1bf99f
[jekyll_plugins_generator]: http://jekyllrb.com/docs/plugins/#generators
[archive_barre_verte]: https://github.com/barreverte/barreverte.github.io/blob/master/archive.html
[barre_verte]: http://www.barreverte.fr/
