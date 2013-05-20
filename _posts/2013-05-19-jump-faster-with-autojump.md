---
layout: post
title: "Jump fast with autojump"
comments: true
categories: [programming]
tag: [terminal, zsh, cd, autojump]
keywords: [terminal, zsh, cd, autojump]
---

Once in a while you discover a tool that makes you wonder how you ever lived without it. [Autojump](https://github.com/joelthelion/autojump) is such a tool. It allows blazing fast file system navigation from the terminal by letting you to jump to any path you previously visited. The command `j born2code` changes directory to `/Users/pjvds/dev/born2code.net`. Autojump doesn't need the full directory name, a small piece is enough. It will match your input with a list of weighted paths and picks the one on top.

## How does autojump work
Autojump stores the paths you visit in a simple textfile called `autojump.txt`. Picture the following `cd` command.

    cd ~/dev/getting-started-python/src

That command will update your autojump.txt file  to look like this:

    10  /Users/pjvds/dev/getting-started-python/src

When you `cd` to another directory with the following.

    cd ~/dev/getting-started-ruby/src

Autojump.txt file will contain both directories.

    10  /Users/pjvds/dev/getting-started-ruby/src
    10  /Users/pjvds/dev/getting-started-python/src

The `10` in front of both lines is the weight of the directories. They now have both the same weight because they are both visited once. Now when one of the directories is visited again the weight will get updated.

    cd ~/dev/getting-started-python/src

Will update the weight of `/Users/pjvds/dev/getting-started-python/src`:

    14   /Users/pjvds/dev/getting-started-python/src
    10   /Users/pjvds/dev/getting-started-ruby/src

So `/Users/pjvds/dev/getting-started-python/src` is now the heaviest weighted path in the list. If you want to change directory to it - in other words jumping - you simply execute the following.

    j src

A `pwd` command would output `/Users/pjvds/dev/getting-started-python/src`. The `j` jump command will also update the weight of a directory. So the `autojump.txt` now looks like the following:

    17   /Users/pjvds/dev/getting-started-python/src
    10   /Users/pjvds/dev/getting-started-ruby/src

You can give extra hints to autojump. If I want to jump to the ruby `src` instead of the heavier weighted python one I simply do the following:

    j ruby src

## More
Installation information and more examples can be found at the [Github page](https://github.com/joelthelion/autojump). Happy jumping!
