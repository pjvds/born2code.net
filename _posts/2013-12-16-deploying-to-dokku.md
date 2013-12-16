---
layout: post
title: "Deploying to Dokku"
description: ""
category: ""
tags: [docker, dokku]
---

[Jeff Lindsay] created [Dokku](https://github.com/progrium/dokku), the smallest PaaS implementation you've even seen. It is powered by Docker and written in less than 100 lines of Bash code. I wanted to play with even since it was released. This weekend I finally did and successfully deployed my application to Dokku running on an Digital Ocean droplet. In this post I share how you can do this as well.

## Prerequisites

First of all, to use dokku with wercker (as described here) you need:

* a [github](http://github.com) or [bitbucket](http://bitbucket.org) account,
* a [wercker account](https://app.wercker.com/sessions/new),
* a [digital ocean account](https://www.digitalocean.com/login),
* the [wercker cli installed](http://devcenter.wercker.com/articles/gettingstarted/cli.html).

## Add app to wercker

[Fork](https://github.com/pjvds/getting-started-nodejs) the [getting-started-nodejs sample application](https://github.com/wercker/getting-started-nodejs) and clone it on a local machine.

{% highlight bash %}
$ git clone git@github.com:pjvds/getting-started-nodejs.git
Cloning into 'getting-started-nodejs'...
remote: Counting objects: 24, done.
remote: Compressing objects: 100% (19/19), done.
remote: Total 24 (delta 5), reused 17 (delta 1)
Receiving objects: 100% (24/24), done.
Resolving deltas: 100% (5/5), done.
Checking connectivity... done
{% endhighlight %}

With the [wercker cli installed](http://devcenter.wercker.com/articles/gettingstarted/cli.html) add the project to wercker
using the `wercker create` command (you can use the default options with any questions it will ask you).

{% highlight bash %}
$ cd getting-started-nodejs
$ wercker create
{% endhighlight %}

The wercker command should finish with something that looks like:

{% highlight bash %}
Triggering build
A new build has been created

Done.
-------------

You are all set up to for using wercker. You can trigger new builds by
committing and pushing your latest changes.

Happy coding!
{% endhighlight %}

## Generate an SSH key

Run `wercker open` to open the newly added project on wercker. You should see a successfull build that was triggered during the project creation via the wercker cli. Go to the settings tab and scroll down to 'Key management'. Click the __generate new key pair__ button and enter a meaningful name, I named it "DOKKU".

![add ssh key]({{ 'deploy-to-dokku/add-key.png' | asset_url }})

## Create a Dokku Droplet

Now that we have an application in place and have generated an SSH key that will be used in deployment pipeline, it is time to get a dokku environment. Although you can run dokku virtually on every place that runs Linux, we'll use Digital Ocean to get the environment up and running within a minute.

After logging in to Digital Ocean, create a new droplet. Enter the details of your liking. The important part is to pick __Dokku on Ubuntu 13.04__ in the applications tab.

![dokku droplet]({{ 'deploy-to-dokku/dokku_image.png' | asset_url }})

## Get the ip

After the droplet is created, you'll see a small dashboard with the details of that droplet. Next, **replace** the public *SSH key* in the dokku setup with the one from wercker. You can find it in the settings tab of your project. Copy the public key from the key management section and replace the existing key. Next, copy the ip address from the dokku setup(you can find the ip address of it in the left top corner), we'll use it later. You can now click 'Finish setup'.

![configure dokku]({{ 'deploy-to-dokku/config-dokku.png' | asset_url }})

## Create a deploy target

Go to the settings tab of the project on wercker, click on __add deploy target__ and choose __custom deploy target__. Let's name it production and add two environment variables by clicking the __add new variable__ button. The first one is the server host name:
name it SERVER\_HOSTNAME and set the value to the ip address of your newly created digital ocean droplet. Add another with the name DOKKU and choose SSH Key pair as a type. Now select the previously created ssh key from the dropdown and hit __ok__.

Don't forget to save the deploy target by clicking the __save__ button!

## Add the wercker.yml

We're ready for the last step which is setting up our deployment pipeline using the [wercker.yml file](http://devcenter.wercker.com/articles/werckeryml/). All we need to do now is tell wercker which steps to perform during a deploy. Create a file called `wercker.yml` in the root of your repository with the following content:

{% highlight yaml %}
box: wercker/nodejs
build:
  steps:
    - npm-install
    - npm-test
deploy:
  steps:
    - add-to-known_hosts:
        hostname: $SERVER_HOSTNAME
    - add-ssh-key:
        keyname: DOKKU
    - script:
        name: Initialize new repository
        code: |
            rm -rf .git
          git init
          git config --global user.name "wercker"
          git config --global user.email "pleasemailus@wercker.com"
          git remote add dokku dokku@$SERVER_HOSTNAME:getting-started-nodejs
    - script:
        name: Add everything to the repository
        code: |
          git add .
          git commit -m "Result of deploy $WERCKER_GIT_COMMIT"
    - script:
        name: Push to dokku
        code: |
          git push dokku master
{% endhighlight %}

Add the file to the git repository and push it.

{% highlight bash %}
$ git add wercker.yml
$ git commit -m 'wercker.yml added'
$ git push origin master
{% endhighlight %}

## Deploy

Go to your project on wercker and open the latest build, wait until it is finished (and green). You can now click the __Deploy to__ button and select the deploy target we created earlier. A new deploy will be queued and you'll be redirected to it.
Wait untill the deploy is finished and enjoy your first successfull deploy to a Digital Ocean droplet running dokku!