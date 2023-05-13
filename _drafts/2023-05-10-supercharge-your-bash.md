---
layout: post
title: 'Contextualize your bash'
categories: [software, terminal]
date: 2023-05-10
tags: [software, terminal, bash]
---

## Why I'm Always Trying to Improve My Terminal Workflow

I have been using terminal/tmux/bash for several years now, constantly striving to enhance my workflow. As a freelancer, I often juggle multiple heterogeneous projects simultaneously, which motivates me to streamline my approach. I have automated my laptop setup entirely using Ansible, assigning a unique "role" to each project.

Within each role, I had a bashrc file that I used to [source globally][use_bashrc_directory].

However, a major challenge I face is the inability to reuse the same alias across different projects. Consequently, I resorted to prefixing everything. For instance, when working on Camino, I had to create an alias called "camino_pr" for generating pull requests. This approach has its drawbacks, such as the alias "camino_pr" being available everywhere but only usable in certain directories.

Therefore, I explored various solutions to load specific .bashrc files based on my current working directory. Here are some existing options I found:

* [Direnv][direnv]: It allows loading environment variables only.
* [Ondir][ondir]: This tool relies on a single ~/.ondirrc file, making it difficult to manage with multiple heterogeneous projects.
* [ZSH Autoenv][zsh-autoenv]: Unfortunately, it is designed exclusively for zsh users.
* [Smartcd][smartcd]: This tool aligns with my requirements, but I prefer a more bash-based approach.

## Hacking CD to Achieve My Goal

My requirement is simple: I want to automatically source one or more files when I enter a directory.

One potential solution is to hook the cd command, so that every time I use `cd` it executes a bash function.

For example, consider the following bash function:

```bash
function cd() {
  builtin cd "$@"
  echo "Moving to $(pwd)"
}
```

This function will print the new path every time I switch to a different directory.

In the end, what I aim for is to source any `.my_bash_file` encountered along my current path.

After some experimentation, I arrived at the following implementation:

```bash

function cd() {
  builtin cd "$@"
  local x=$(pwd)
  local bash_files_to_source=()

  while [ "$x" != "/" ]; do
    if [ -f "${x}/.my_bash_file" ]; then
        bash_files_to_source+=("${x}/.my_bash_file")
    fi
    x=$(dirname "$x")
  done

  local current_index=$(( ${#bash_files_to_source[@]} - 1 ))
  while [[ current_index -gt -1 ]]; do
    local bash_file_to_source="${bash_files_to_source[$current_index]}"
    echo "Sourcing ${bash_file_to_source}"
    source "${bash_file_to_source}"
    ((current_index--))
  done
}
```

I added this code to my `.bashrc`, along with a `cd .` command at the end to activate it when I open a new tmux pane, for example.

## Enhanced Usage

This approach provides significant flexibility. Now, I have a consistent pr command available in every project I work on. Sometimes, it is aliased to gh pr create, other times it might be a custom Python command or any other tool used by the team I collaborate with.

Moreover, I have even automated the retrieval of secrets from my keepassxc instance when entering specific folders. As a result, most of my secrets are no longer stored physically on my machine. (I will likely write another blog post to discuss secret service integration in detail.)

## TODO

* Unsource stuff when I move out
* Secure what I can source or not?


[direnv]: https://direnv.net/
[ondir]: https://github.com/alecthomas/ondir
[zsh-autoenv]: https://github.com/Tarrasch/zsh-autoenv
[smartcd]: https://github.com/cxreg/smartcd
[use_bashrc_directory]: https://waxzce.medium.com/use-bashrc-d-directory-instead-of-bloated-bashrc-50204d5389ff
[camino]: https://camino.beta.gouv.fr/

