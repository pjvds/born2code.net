---
layout: post
title: "jump fast with autojump"
comments: true
categories: [programming]
tag: [terminal, zsh, cd, autojump]
keywords: [terminal, zsh, cd, autojump]
---

Sometimes you discover a tool that makes you wonder how you ever lived without it. [Autojump](https://github.com/joelthelion/autojump) is such a tool. It allows blazing fast file system navigation from the terminal. Autojump allows you to jump to any path you previously visited. For example, if I want to change directory to `/Users/pjvds/dev/born2code.net`, I simply execute `j born2code`. Autojump doesn't need the full directory name. Just a piece of it enough. It will match your input with a list of weighted paths and pick the top one.

## How does autojump work
Autojump stores the path and weight information of all directories you visit in a simple textfile called `autojump.txt`. For example, if you execute the following `cd` command:

    cd ~/dev/getting-started-python/src

Your autojump.txt file will look like this:

    10  /Users/pjvds/dev/getting-started-python/src

When you `cd` to another directory.

    cd ~/dev/getting-started-ruby/src

Autojump.txt file will contain both directories.

    10  /Users/pjvds/dev/getting-started-ruby/src
    10  /Users/pjvds/dev/getting-started-python/src

The `10` in fron of both lines is the weight of the directories. They both have the same weight because they where visited once. Now when one of the directories is visited again the weight will get updated.

    cd ~/dev/getting-started-python/src

Will update the weight of `/Users/pjvds/dev/getting-started-python/src`:

    14   /Users/pjvds/dev/getting-started-python/src
    10   /Users/pjvds/dev/getting-started-ruby/src

Now when `j src` will jump to `/Users/pjvds/dev/getting-started/python/src` because has a higher weigth than the other `src` directory in `getting-started-ruby`. Also the `j` jump command will update the weight of a directory. So the `autojump.txt` now looks like the following:

    17   /Users/pjvds/dev/getting-started-python/src
    10   /Users/pjvds/dev/getting-started-ruby/src

You can give extra hints to autojump. If I want to jump to the ruby `src` instead of the heavier weighted python one I simply do the following:

    j ruby src

## More
Installation information and more examples can be found at the [Github page](https://github.com/joelthelion/autojump). Happy jumping!
