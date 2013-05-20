---
layout: post
title: "Move local master commits to feature branch"
comments: true
categories: [programming]
tag: [git]
keywords: [git, reset, feature branch, branches]
---

I'm a big fan of feature branches. Especially because it allows me to rewrite history and therefor keeping it clean and to the point. But there is one thing I keep doing wrong. I forget to create a feature branch and commit my work directly to master. I normally notice this just before pushing. In this post I'd like to share the steps I take to fix my work and move the local commits from master to a feature branch.

## tldr;

1. `git branch feature` will simply create a new branch called feature.
2. `git reset --hard HEAD~4` will reset the current master branch to HEAD minus 3 commits (C--D--E)
3. `git checkout feature` will simply switch to the feature branch which still contains the 4 commits (`B--C--D--E`)

## Moving local master commits to feature branch

The following ASCII drawing represents the situation.

                        master
                          ↓
    commits   A--B--C--D--E
              ↑
        origin/master

Commit `A` is where `origin/HEAD` (the remote master branch) is and `B`, `C`, `D` and `E` is the work I did on master directly and should moved to a feature branch.

Since a branch in git is just a pointer this is can easily be done. Let us first create the new feature branch and call it `feature`. We do this now because it should have the same state as the current `master` branch.

    git branch feature

Both `master` and `feature` point to the last commit `E`.

                         feature
                          master
                            ↓
    commits     A--B--C--D--E
                ↑
          origin/master

We do not want the commits `B` to `E` to be on the `master` branch, so we reset that one to commit `A`. This can be done by resetng it _x_ possitions back.

    git reset --hard HEAD~4

I use that approuch when it is just a single commit (`HEAD^`) or not more than a hand full. Otherwise, I reset it to `origin/master`.

    git reset --hard origin/master

I rarely reset to a commit sha like the following. But if you know the sha from commit `A` you can use it to reset to there.

    git reset --hard fd83c2

All the above reset (move the pointer) the local `master` branch to point to commit `A`.

              master     feature
                ↓           ↓
    commits     A--B--C--D--E
                ↑
          origin/master

We can now checkout branch `feature` to continue our work in the feature branch.

    git checkout feature

Every commit we do now adds to the `feature` branch.

    touch file.txt
    git add file.txt
    git commit -m 'Adds file.txt'

And our git repository will look like the following.

              master        feature
                ↓              ↓
    commits     A--B--C--D--E--F
                ↑
          origin/master

We can share our feature branch by pushing it to the remote.

    git push origin feature

This closes there circle and the repository looks like the following.

              master        feature
                ↓              ↓
    commits     A--B--C--D--E--F
                ↑              ↑
          origin/master  origin/feature

Happy git'ng!
