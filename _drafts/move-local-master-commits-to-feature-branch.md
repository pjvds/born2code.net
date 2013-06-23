---
layout: post
title: "Move commits from master to feature branch"
comments: true
categories: [programming]
tag: [git]
keywords: [git, reset, feature branch, branches]
---

I am a big fan of the [feature branching model](http://nvie.com/posts/a-successful-git-branching-model/). Working in an isolated branch created especially for the feature you are working on has its advantages. But, there is one thing I keep forgetting: creating the actual feature branch. This means I'm commiting directly to the master branch. Most of the times I notice this just before pushing. When this is the case, I quickly create a new feature branch and move my commits to it. In this post I'd like to share how I do this, how I move my  commits from the master to a new feature branch.

## Move commits to a new feature branch

Make sure you have checked out the branch that contains the commits you like to move and execute the following:

1. `git branch feature` will create the feature branch called feature.
2. `git reset --hard origin/master` will reset the current local master branch to the same commit as the remote master branch.
3. `git checkout feature` will simply switch to the feature branch which still contains the 4 commits.
4. `git push origin feature` will push it to the remote repository.

## Here is what happened

The following ASCII drawing represents the situation I'm in when I discoved I have working on the master instead of a feature branch.

                        master
                          ↓
    commits   A--B--C--D--E
              ↑
        origin/master

Commit `A` is where `origin/master` the remote master branch. Commit `B`, `C`, `D` and `E` are the commits that should be moved to a new feature branch.

I start by creating the new feature branch and call it `feature`. This should set the state of the `feature` branch to the same state as the one currently checked out, in my case master.

    git branch feature

Now I have the following situation where `master` and `feature` point to the same commit `E`.

                         feature
                          master
                            ↓
    commits     A--B--C--D--E
                ↑
          origin/master

I do not want commits from `B` to `E` to be on the `master` branch, so I reset to commit `A` with the `git reset` command. The easiest way to to reset to `origin/master`:

    git reset --hard origin/master

Alternatively I could reset it _n_ possitions back. I use that approuch when it is just a single commit (`HEAD^`), or not more than a hand full (`HEAD~5`).

    git reset --hard HEAD~4

I rarely reset to a commit sha like the following. But if you know the sha from commit `A` you can use it to reset to there.

    git reset --hard fd83c2

The above resets the index and directory content the local `master` branch to point to commit `A`.

              master     feature
                ↓           ↓
    commits     A--B--C--D--E
                ↑
          origin/master

Now I can checkout the `feature` branch to continue working in it.

    git checkout feature

Every commit we do now adds to the `feature` branch.

    echo "foobar" >> file.txt
    git add file.txt
    git commit -m 'Adds file.txt'

And our git repository will look like the following.

              master        feature
                ↓              ↓
    commits     A--B--C--D--E--F
                ↑
          origin/master

The feature branch can be shared by pushing it to the remote.

    git push origin feature

This closes there circle and the repository looks like the following.

              master        feature
                ↓              ↓
    commits     A--B--C--D--E--F
                ↑              ↑
          origin/master  origin/feature

Happy git'ng!