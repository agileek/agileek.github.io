---
layout: post
title: 'Contextualize your bash'
categories: [software, terminal]
date: 2023-05-10
tags: [software, terminal, bash]
---

## Why

I've been using terminal/tmux/bash for a few years now and I'm still trying to improve my workflow with it.
I am a freelancer and I work on multiple heterogeneous projects at the same time, so I like to unify my workflow.
My laptop setup is entirely automated with ansible, and I have one "role" by projet.

In each of these roles, I have a bashrc that I used to source [globally][use_bashrc_directory]

My main issue is: I cannot reuse the same alias for my projects, so I ended up prefixing everything (for example, working on [Camino][camino], when I wanted to create a PR, I had an alias camino_pr). 
This has some drawbacks, the most obvious one being the alias camino_pr is available everywhere, but is usable only on certain directories.

So, I looked for a way to load some of my .bashrc files depending on my current working directory.


## Existing stuff

- [Direnv][direnv]
  - Only load environment variables
- [Ondir][ondir]
  - All in one ~/.ondirrc file, difficult to manage with multiple heterogeneous projects
- [ZSH Autoenv][zsh-autoenv]
  - Only for zsh unfortunately
- [Smartcd][smartcd]
  - That's what I want basically, but with a more full bash approach

#### Hacking CD

My need is simple: I want to source one or more files when I enter a directory.

One solution is to hook the `cd` command, each time you type `cd`, it'll execute a bash function.


For example, this bash function:

```bash
function cd () {
  builtin cd "$@"
  echo "Moving to $(pwd)"
}
```

will print the new path everytime I move to another directory.

In the end what I want is to source every `.my_bash_file` I encounter along my current path.

I ended up with this:

```bash
function cd () {
  builtin cd "$@"
  local x=`pwd`
  local bash_files_to_source=()
  while [ "$x" != "/" ]; do
    if [ -f "${x}/.my_bash_file" ]
    then
        bash_files_to_source+=("${x}/.my_bash_file")
    fi
    x=`dirname "$x"`
  done

  local current_index=$(( ${#bash_files_to_source[@]} -1 ))
  while [[ current_index -gt -1 ]]
  do
      local bash_file_to_source="${bash_files_to_source[$current_index]}"
      echo "Sourcing ${bash_file_to_source}"
      source "${bash_file_to_source}"
      (( current_index-- ))
  done
}
```

I put this in my .bashrc (with a `cd .` at the end to activate this when I open a new tmux pane for example)


## Usage

It's quite powerful, now I know I always have a `pr` command available in every project I work with, sometimes it will be aliased to `gh pr create`, sometimes it's a custom python command, or whatever the team I'm working with is using.

I'm even able now to automatically fetch secrets from my keepassxc instance when I enter some folders, so almost all my secrets are not physiscally on my machine anymore (that will probably be another blog post, where we will talk about secret service integration)

## TODO

* Unsource stuff when I move out
* Secure what I can source or not?


[direnv]: https://direnv.net/
[ondir]: https://github.com/alecthomas/ondir
[zsh-autoenv]: https://github.com/Tarrasch/zsh-autoenv
[smartcd]: https://github.com/cxreg/smartcd
[use_bashrc_directory]: https://waxzce.medium.com/use-bashrc-d-directory-instead-of-bloated-bashrc-50204d5389ff
[camino]: https://camino.beta.gouv.fr/

