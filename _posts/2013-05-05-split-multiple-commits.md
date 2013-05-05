---
layout: post
title: "Split multiple commits in git"
date: 2013-03-21 05:16
categories: [programming]
keywords: [git, rebase, commits, history]
---

I have added a new feature to the [node auth module](https://github.com/ciaranj/node-oauth) to not follow redirects. Next to functional changes I also [removed](https://github.com/pjvds/node-oauth/commit/e16527e674d26733763028667b92e539126d691c) some trailing whitespaces. This to satisfy tools like [jshint](http://jshint.com).

Ciaran, the maintainer of the module, [tell me](https://github.com/ciaranj/node-oauth/pull/138#issuecomment-16996402) that he likes what I did but would like to see the functional- and whitespaces changes in separate commits. This means I need to split some commits in made. Spliting commits and rewriting git repository history is not something I do on a daily basis, and I guess there are more out there, so I decided to write down how I did it for future reference.

## The commits

Here is [the list](https://github.com/pjvds/node-oauth/commits/no-follow-option-original) of commits I made:

	3458576  Adds test to proof default value for followRedirects is true
	e16527e  Add followRedirect client option to turn auto follow on or off
	04eb6fa  Add test cases for 302 response status
	6e215f9  Add failing test for 301 redirect for followRedirect client option

Only the last two, `3458576` and `e16527`, contain whitespace fixes. I want to split the work I did in both commits into two new commits. One containing the functional change and the other the whitespace change.

## Creating a backup

Before I start messing around I create a new branch `backup`. In my case this isn't realy necesery because the changes are already pushed to github. But I'm not sure all the readers of this have.

	git branch backup

## Rebase commits

I use git rebase to rebase my two commits onto the HEAD. I specify `-i` to do this in interactive mode. Which gives me the oppertunity to stop after each commit and split the functional and whitespace work in multiple commits.

	git rebase -i 04eb6fa
	
	pick e16527e Add followRedirect client option to turn auto follow on or off
	pick 3458576 Adds test to proof default value for followRedirects is true
	
	# Rebase 04eb6fa..3458576 onto 04eb6fa
	#
	# Commands:
	#  p, pick = use commit
	#  r, reword = use commit, but edit the commit message
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#  f, fixup = like "squash", but discard this commit's log message
	#  x, exec = run command (the rest of the line) using shell
	#
	# These lines can be re-ordered; they are executed from top to bottom.
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#
	# Note that empty commits are commented out

## Edit both

I change the status for both commits from `pick` to `edit`.

	edit e16527e Add followRedirect client option to turn auto follow on or off
	edit 3458576 Adds test to proof default value for followRedirects is true
	
Now I write the file and quit my editor VIM to start the rebase.

## Stopped at first commit

Git reponse with the following message:
	
	stopped at e16527e... Add followRedirect client option to turn auto follow on or off
	You can amend the commit now, with

		git commit --amend

	Once you are satisfied with your changes, run

		git rebase --continue
	