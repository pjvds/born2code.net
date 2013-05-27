---
layout: post
title: "Open Mou from terminal"
categories: [programming]
keywords: [mou, mouapp, terminal, open, commandline]
---

I'm a big fan of [Mou](http://mouapp.com). However I find that I almost always want to use it while at the terminal. Especially since I started using [autojump](/blog/2013/05/19/jump-faster-with-autojump/). We have two options here, creating an alias or writing a script. I prefer the first because I already have a huge number of aliases in my `~/.zshrc` file and don't have to `chmod` anything.

## Using an alias
Add the following line to your `.zshrc`, `.bashrc` or `.profile` file.

{% highlight bash %}
alias mou="open -a Mou.app"
{% endhighlight %}

## Using a script file
Create a file names `mou` in your `/usr/local/bin` (or any other path that is exported in `$PATH`) with the following content:

{% highlight bash %}
#! /bin/sh
open -a Mou.app "$@"
{% endhighlight %}

After the file is created add execution rights via:

{% highlight bash session %}
chmod +x /usr/local/bin/mou
{% endhighlight %}

## Open it

Now you can just do:

{% highlight bash session %}
mou [file.md]
{% endhighlight %}
