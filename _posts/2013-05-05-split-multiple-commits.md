---
layout: post
title: "Split multiple commits in git"
categories: [programming]
keywords: [git, rebase, commits, history]
---

I have added a new feature to the [node auth module](https://github.com/ciaranj/node-oauth) to not follow redirects. Next to functional changes I also [removed](https://github.com/pjvds/node-oauth/commit/e16527e674d26733763028667b92e539126d691c) some trailing white spaces. This to satisfy tools like [jshint](http://jshint.com).

Ciaran, the maintainer of the module, [tell me](https://github.com/ciaranj/node-oauth/pull/138#issuecomment-16996402) that he likes what I did but would like to see the functional- and white spaces changes in separate commits. This means I need to split some commits in made. Splitting commits and rewriting git repository history is not something I do on a daily basis, and I guess there are more out there, so I decided to write down how I did it for future reference.

## The commits

Here is [the list](https://github.com/pjvds/node-oauth/commits/no-follow-option-original) of commits I made:

	3458576  Adds test to proof default value for followRedirects is true
	e16527e  Add followRedirect client option to turn auto follow on or off
	04eb6fa  Add test cases for 302 response status
	6e215f9  Add failing test for 301 redirect for followRedirect client option

Only the last two, `3458576` and `e16527`, contain whitespace fixes. I want to split the work I did in both commits into two new commits. One containing the functional change and the other the whitespace change.

## Creating a backup

Before I start messing around I create a new branch `backup`. In my case this isn't really necessary because the changes are already pushed to Github. But I'm not sure all the readers of this have.

	git branch backup

## Rebase commits

I use git rebase to rebase my two commits onto the HEAD. I specify `-i` to do this in interactive mode. Which gives me the opportunity to stop after each commit and split the functional and whitespace work in multiple commits.

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

## We want to mark them with edit

I change the status for both commits from `pick` to `edit`.

	edit e16527e Add followRedirect client option to turn auto follow on or off
	edit 3458576 Adds test to proof default value for followRedirects is true

Now I write the file and quit my editor VIM to start the rebase.

## Stopped at first commit

Git response with the following message:

	stopped at e16527e... Add followRedirect client option to turn auto follow on or off
	You can amend the commit now, with

		git commit --amend

	Once you are satisfied with your changes, run

		git rebase --continue

When I execute `git log --pretty=format:'%h  %s' -n 3` I get the following:

	e16527e  Add followRedirect client option to turn auto follow on or off
	04eb6fa  Add test cases for 302 response status
	6e215f9  Add failing test for 301 redirect for followRedirect client option

This shows that the HEAD and index are both at `e16527`. I now mixed reset that commit.

	git reset HEAD^ --mixed

	Unstaged changes after reset:
	M	lib/oauth.js

## Stage hunks

The HEAD and index are now both at `04eb6fa` but my working directory contains the work I have done in the commit that I want to split. I will now stage what I want to commit first. In my case there is only a single file that has been changed, `lib/oauth.js`. I specify to stage only parts of the file with the `-p` option.

	git add -p lib/oauth.js

Git will now ask me for every part what to do. This is what the first part looks like:

	diff --git a/lib/oauth.js b/lib/oauth.js
	index 7607ee6..2998ab4 100644
	--- a/lib/oauth.js
	+++ b/lib/oauth.js
	@@ -29,7 +29,8 @@ exports.OAuth= function(requestUrl, accessUrl, consumerKey, consumerSecret, vers
	                                    "Connection" : "close",
	                                    "User-Agent" : "Node authentication"}
	   this._clientOptions= this._defaultClientOptions= {"requestTokenHttpMethod": "POST",
	-                                                    "accessTokenHttpMethod": "POST"};
	+                                                    "accessTokenHttpMethod": "POST",
	+                                                    "followRedirects": true};
	   this._oauthParameterSeperator = ",";
	 };

	Stage this hunk [y,n,q,a,d,/,j,J,g,e,?]?

Staging a hunk has the following options:

	y - stage this hunk
	n - do not stage this hunk
	q - quit; do not stage this hunk nor any of the remaining ones
	a - stage this hunk and all later hunks in the file
	d - do not stage this hunk nor any of the later hunks in the file
	g - select a hunk to go to
	/ - search for a hunk matching the given regex
	j - leave this hunk undecided, see next undecided hunk
	J - leave this hunk undecided, see next hunk
	k - leave this hunk undecided, see previous undecided hunk
	K - leave this hunk undecided, see previous hunk
	s - split the current hunk into smaller hunks
	e - manually edit the current hunk
	? - print help

I choose `y` to stage this hunk. The next hunk appears, it is also a functional change. I choose `y` again and the next hunk appears. I continue this process by choosing `y` to stage and `n` to not stage the hunks until there is no hunk left.

__tip__: Enabling git colours will help you to understand the diff output better. To enable git colours globally run: `git config --global color.ui auto`.

## Commit it

Now parts of the `lib/oauth.js` are staged. I simply commit this with:

	git commit -m 'Add followRedirect client option to turn auto follow on or off'

## Add the whitespace changes

All functional changes are staged and committed. Now I can simply stage the full `lib/oauth.js` file and commit that as well.

	git add lib/oauth.js
	git commit -m 'Remove trailing white spaces'

## Continue the rebase

I have split commit `e16527e` in two new commits. Now I continue the rebase which will move us to the next commit `3458576`.

	git rebase --continue

	Stopped at 3458576... Adds test to proof default value for followRedirects is true
	You can amend the commit now, with

		git commit --amend

	Once you are satisfied with your changes, run

		git rebase --continue

Once again I reset the HEAD and the index without resetting the actual content of the files.

	git reset HEAD^ --mixed

	Unstaged changes after reset:
	M	tests/oauth.js

I stage `tests/oauth.js` with the `-p` option:

	git add tests/oauth.js -p

After accepting the first hunk I discover that there are no hunks left. Which means I did not make any whitespace changes to this file.

	diff --git a/tests/oauth.js b/tests/oauth.js
	index ab1c296..99e5bb6 100644
	--- a/tests/oauth.js
	+++ b/tests/oauth.js
	@@ -24,6 +24,12 @@ DummyRequest.prototype.end= function(){
	 }

	 vows.describe('OAuth').addBatch({
	+    'When newing OAuth': {
	+      topic: new OAuth(null, null, null, null, null, null, "PLAINTEXT"),
	+      'followRedirects is enabled by default': function (oa) {
	+        assert.equal(oa._clientOptions.followRedirects, true)
	+      }
	+    },
	     'When generating the signature base string described in http://oauth.net/core/1.0/#sig_base_example': {
	         topic: new OAuth(null, null, null, null, null, null, "HMAC-SHA1"),
	         'we get the expected result string': function (oa) {
	Stage this hunk [y,n,q,a,d,/,e,?]? y # this is a functional change

I commit with a slightly different message than the original. I start with _add_ instead of _adds_ to make my commit message consistent":

	git commit -m 'Add test to proof default value for followRedirects is true'

## Finish rebase

I tell git to continue with the rebase.

	git rebase --continue

The rebase will finish because there are not commits left.

	Successfully rebased and updated refs/heads/no-follow-option.

## Push with force

I now want to push my changes to Github to update my pull request.

	git push origin no-follow-redirect

Git rejects my commit because my HEAD doesn't match with the HEAD of the remote.

	To git@github.com:pjvds/node-oauth.git
	 ! [rejected]        no-follow-option -> no-follow-option (non-fast-forward)
	error: failed to push some refs to 'git@github.com:pjvds/node-oauth.git'
	hint: Updates were rejected because the tip of your current branch is behind
	hint: its remote counterpart. Merge the remote changes (e.g. 'git pull')
	hint: before pushing again.
	hint: See the 'Note about fast-forwards' in 'git push --help' for details.

This may look scary and definitely is when others are working on my branch as well. But in this case I want to push anyway and discard the _wrong_ history of the remote. I now push with the `-f` force option.

	git push origin no-follow-redirect -f

And I am done!

	Counting objects: 17, done.
	Delta compression using up to 8 threads.
	Compressing objects: 100% (12/12), done.
	Writing objects: 100% (12/12), 1.43 KiB, done.
	Total 12 (delta 8), reused 0 (delta 0)
	To git@github.com:pjvds/node-oauth.git
	 + 3458576...3584b43 no-follow-option -> no-follow-option (forced update)

## Final pull request

Here is the final pull request version that - hopefully - satisfies Carian: [Don't follow redirects opt-out](https://github.com/ciaranj/node-oauth/pull/138).
