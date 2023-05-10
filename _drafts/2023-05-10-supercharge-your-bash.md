---
layout: post
title: 'Contextualize your bash'
categories: [software, terminal]
date: 2023-05-10
tags: [software, terminal, bash]
---

## Why

I've been using bash for a few years now and I'm still trying to improve my workflow with it.
I am a freelancer and I can work on multiple projects at the same time, so I like to unify my development workflow.
My laptop setup is entirely automated with ansible, and I have one "role" by projet.

In each of these roles, I have a bashrc that I used to source [globally][use_bashrc_directory]

My main issue is: I cannot reuse the same alias for my projects, so I ended up prefixing everything (for example, working on [Camino][camino], when I wanted to create a PR, I had an alias camino_pr). 
This has some drawbacks, the most obvious one being the alias camino_pr is available everywhere, but is usable only on certain directories.

So, I searched for a way to load some of my .bashrc files only when I'm in certain directories


## Existing stuff

- https://direnv.net/
  - Only load environment variables
- https://github.com/alecthomas/ondir
  - All in one ~/.ondirrc file, difficult to manage with multiple heterogeneous projects
- https://github.com/Tarrasch/zsh-autoenv
  - Only for zsh unfortunately
- https://github.com/cxreg/smartcd
  - That's what I want basically, but with a more full bash approach

#### Hacking CD

My need is simple: I want to source one or more files when I enter a directory.


```bash
function cd () {
  builtin cd "$@"
  local x=`pwd`
  local aliases_to_source=()
  while [ "$x" != "/" ]; do
    if [ -f "${x}/.aliases" ]
    then
        aliases_to_source+=("${x}/.aliases")
    fi
    x=`dirname "$x"`
  done

  local current_index=$(( ${#aliases_to_source[@]} -1 ))
  while [[ current_index -gt -1 ]]
  do
      local alias_to_source="${aliases_to_source[$current_index]}"
      echo "Sourcing ${alias_to_source}"
      source "${alias_to_source}"
      (( current_index-- ))
  done
}
```


[2D_football]: /images/posts/turtle/2d_football.jpg
[^1]: [How to Draw a Hexagon][draw_hexagon]

[use_bashrc_directory]: https://waxzce.medium.com/use-bashrc-d-directory-instead-of-bloated-bashrc-50204d5389ff
[camino]: https://camino.beta.gouv.fr/

