---
layout: post
title: "Move local master commits to feature branch"
comments: true
categories: [programming]
tag: [git]
keywords: [git, reset, feature branch, branches]
---

I'm a big fan of feature branches. Especially because it allows you to rewrite history and therefor keeping it clean and to the point. But there is a single thing I keep doing wrong. I forget to create a feature branch and commit my work directly to master. I normally notice this just before pushing. In this post I'd like to share the steps I take to fix my work and move the local commits from master to a feature branch.

## tldr;

1. `git branch feature-x` will simply create a new branch called feature-x.
2. `git reset --hard HEAD~4` will reset the current master branch to HEAD minus 3 commits (C--D--E)
3. `git checkout feature-x` will simply switch to the feature-x branch which still contains the 4 commits (B--C--D--E)

## Moving local master commits to feature branch

Let me share a recipe how to introduce a feature branch and move your commits to it.

Commit `A` is where `origin/HEAD` (the remote master branch) is and `B`, `C`, `D` and `E` is the work I did and which should move to a feature branch:

                        master
                          ↓
    commits   A--B--C--D--E
              ↑
        origin/master

Since a branch in git is just a pointer this is can easily be done.

Let's first create the new feature branch and call it `feature-x`:

    git branch feature-x

                          master
                            ↓
    commits     A--B--C--D--E
                ↑
          origin/master

Now reset the branch of `master` to commit `A` which is 4 positions from `HEAD`:

    git reset --hard HEAD~4


              master    feature-x
                ↓           ↓
    commits     A--B--C--D--E
                ↑
          origin/master

This will reset the current `master` branch to `HEAD` minus `4` positions.
