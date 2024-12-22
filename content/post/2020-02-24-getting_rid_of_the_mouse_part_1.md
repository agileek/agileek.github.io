---
categories:
- terminal
date: "2020-02-24T00:00:00Z"
tags:
- keyboard
- mouse
- terminal
- git
title: 'Going mouseless #1: Git push a new branch'
---

> TLDR: install thefuck

## The Right Tool for the Right Job

**Using the right tool for the right job** is kind of why I can't decide myself on using one programming language.

When it comes to programming, I have the feeling that using the mouse is highly unefficient.[^1]

It really breaks the flow, you are in the process of writing some code, with both your hands on the keyboard, and all of a sudden you grab the mouse to, I don't know, launch the tests or click on some website you are testing.
I don't like that.

What I try to do on a daily basis is find **where** and **when** my mouse is breaking my flow.

This (I hope so) will be a series of articles where I take one part of my working flow and try to get rid of the mouse.

**Protip**: Put my mouse on its back so every access to the mouse is a conscious one. Try it, and let me know.

## The git 'flow'

Each time I work on a new task, I start by creating a new branch. 
Let's say I work on this article.

`git co -b going-mouseless-part-1`

After that I create the file, write some stuff down, the usual...

When I'm satisfied with my work, I commit

```bash
git add mouseless-article-1.md
git commit -m"meaningful commit message"
git push
```
and **BAM**

```bash
fatal: The current branch going-mouseless-part-1 has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin going-mouseless-part-1
```

I grab my mouse, select the last line and copy/paste it. At least that's what I used to do.

A perfect solution for this use case is [TheFuck][thefuck].

> Magnificent app which corrects your previous console command. 

Once installed, instead of grabbing my mouse, I just type `fuck` then enter twice and that's it!

Here is a complete demo:

<asciinema-player src="/images/posts/mouseless/mouseless_1" cols="120" rows="20"></asciinema-player>

This tool is a really useful one, it saves me on a daily basis with everything, typos, missing sudo,... plus, it's pleasant to curse.


[thefuck]: https://github.com/nvbn/thefuck
[^1]: This is only my opinion