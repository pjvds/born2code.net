---
layout: page
title: "Git recipes"
date: 2013-05-05 12:00
permalink: /pages/git-recipes.html
page-class: page-git-recipes
comments: true
categories: [programming]
tag: [git]
keywords: [git, github, branching, commands]
---

Short, to the point, example driven recipes for git.

## Push new branch to remote

    git push origin new-branch

Where `origin` is your remote name and `new-branch` is the name of the local branch you want to push.

## Create and checkout new branch

    git checkout -b new-branch

Where `new-branch` is the name of the branch you want to create and checkout.

## Delete remote branch

    git push origin :branch-name

Notice the `:` before the branch name. Where `origin` is your remote name and `branch-name` is the name of the remote branch to delete.


## Delete local branch

    git branch -d branch-name

Where `branch-name` is the name of the local branch to delete. If the branch is not fully merged, use `-D` to force removal.

## Rename a branch

    git branch -m current-branch new-branch

Where `current-branch` is the name of the current branch you want to rename and `new-branch` the new name.

## Move commits to feature branch

    git branch feature-branch
    git reset --hard HEAD~1
    git

## Fix wrong commit author

    git filter-branch --commit-filter '
        if [ "$GIT_COMMITTER_NAME" = "<old-name>" ];
        then
                GIT_COMMITTER_NAME="<new-name>";
                GIT_AUTHOR_NAME="<new-name>";
                GIT_COMMITTER_EMAIL="<new-email>";
                GIT_AUTHOR_EMAIL="<new-email>";
                git commit-tree "$@";
        else
                git commit-tree "$@";
        fi' HEAD


Where `<old-name>` is the name of the committer you want to fix and `<new-name>` and `<new-mail>` are the new name and email address of the committer.

## Change origin url

    git remote set-url origin <new-url>

Where `<new-url>` is the new origin, eq: `https://pjvds@bitbucket.org/pjvds/healthcheck.git`.

## Unstage a file

    git reset HEAD <file>

Where `<file>` is the path to the file. This will unstage the file by removing it from the current index but leaves the content changes. A `git status` will show the file as untracked.
