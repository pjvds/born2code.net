---
layout: post
title: "Open Mou from terminal"
categories: [programming], [terminal]
keywords: [mou, mouapp, terminal, open]
---

I'm a big fan of [Mou](http://mouapp.com). However I find that I almost always want to use it while at the terminal. Since I start using [autojump](/blog/2013/05/19/jump-faster-with-autojump/) I dislike finding files using the GUI. So here are two ways to allow opening a file with Mou from the command line.

We have two options here, creating an alias or writing a script. I prefer the first one because I already have a huge number of aliases in my `~/.zshrc` file and don't have to `chmod` anything.

## Using an alias
Add the following line to your `.zshrc`, `.bashrc` or `.profile` file.

	alias mou="open -a Mou.app"

## Using a script file
Create a file names `mou` in your `/usr/local/bin` (or any other path that is exported in `$PATH`) with the following content:

	#! /bin/sh
	open -a Mou.app "$@"
	
After the file is created add execution rights via:

	chmod +x /usr/local/bin/mou
	
## Open it

Now you can just do:

	mou [file.md]