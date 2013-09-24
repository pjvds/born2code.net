---
layout: post
title: Import a Go package from a private git repository
categories: [programming]
tag: [golang]
---

The `go get` command helps to download the packages to the right location for you. Currently this command does not support cloning a git repository over SSH, which makes it harder to retrieve private packages in an automated fassion. In this blogpost I want to share my solution for retrieving private packages from GitHub or Bitbucket from your build at [wercker](http://wercker.com) using deploy keys.

Go dependencies are quite simple. All code should be available in the Go workspace. This means that you must have a copy of the source code of all your dependencies stored in the local file system. With the `go get` command you retrieve these from remote source control systems. Go knowns populair hostings services like GitHub and BitBucket. It supports git, mercurial, svn and bazzaar.

## No SSH support

Although the documentation states otherwise, the current version of go does not support the retrieval of code from private repositories via SSH. We need to do this manually in the build pipeline. It will allways try to retrieve the code via https. Https is not the protocoll you want to use for this because it requires a username and password from an existing GitHub or BitBucket user account which will also effect the limits of your plan. When using SSH you can use deploy keys to gain access to a repository.

## Deploy Keys

A deploy key is simply a password-less SSH key that grants read-only access to a repository. Both GitHub and Bitbucket support deploy keys by adding the public part of a key. Deploy keys have the following features and limitations:

* Deployment keys do not apply to your plan limit.
* You can add the same deployment key to multiple repositories.
* The deployment key must be unique — it cannot also be associated with an account.

## Adding a key to your application

Wercker allows you to generate SSH keys for your application, which we can be used as a deploy key. Open your application on wercker and go to the application settings tab. Here you find the _key management_ section. Use the *generate new key pair* button to create a new key.

![create ssh key at wercker](/images/posts/import-go-package-from-private-git-repository/generate-key.png)

## Add variable for key

Before we can use the key in our build pipeline, we need to expose it as a variable. This can be done in the pipeline section of the application settings tab. Press the *add new variable* button, pick the SSH Key pair option and select your key.

![](/images/posts/import-go-package-from-private-git-repository/pipeline-variable.png)

This will expose the key as two variables, in my case: `MYPACKAGE_KEY_PUBLIC` and `MYPACKAGE_KEY_PRIVATE`. The first one holds the public part of the key, and the latter the private part.

## Add key as deploy key

You can copy the public key from the previous step and add this as a deploy key to the private git repository that contains the package. This option can be found in the settings page of your repository at either GitHub or Bitbucket.

![deploy key](/images/posts/import-go-package-from-private-git-repository/deploy-key.png)

## Add key to build pipeline

We can leverage the [add-ssh-key](TODO) step to write the key as an identity file.

{% highlight yaml %}
box: wercker/golang
build:
  steps:
    - add-ssh-key:
        keyname: MYPACKAGE_KEY
{% endhighlight %}

## Getting the dependency

Due to a bug in `go get` we cannot get the private package via ssh. Until this is fixed we need to clone the repository ourself. As said in the intro, an import path denotes a package stored in the local file system. If we clone the package into the correct location, `go get` will see it is already installed and will not try to get it. It will also be able to update the package, since `go get` will execute a `git fetch` with the default remote that is added by our clone.

To clone the package to the correct path we need to understand the structure for code hosting services. Here are the conventions for GitHub and Bitbucket, a full list is available via the `go help remote` command:

    Bitbucket (Git, Mercurial)
            import "bitbucket.org/user/project"

    GitHub (Git)
            import "github.com/user/project"

These import paths are relative from the `$GOPATH/src/` path. Here is an updated version of my wercker.yml that clones the private package into the correct directory:

{% highlight yaml %}
box: wercker/golang
build:
  steps:
    - add-ssh-key:
        keyname: MYPACKAGE_KEY
    - setup-go-workspace
    - script:
        name: Clone private packages
        code: |-
          git clone git@github.com:pjvds/private-package.git $GOPATH/src/github.com/pjvds/private-package
{% endhighlight %}

The `GOPATH` environment variable is created by the `setup-go-workspace` step.

## Final pipeline

We can now execute a `go get` to get the rest of the dependencies, if any. Executing a `go build` and a `go test` finalizes the build pipeline. Here is the final wercker.yml I used:

{% highlight yaml %}
box: wercker/golang
build:
  steps:
    - add-ssh-key:
        keyname: MYPACKAGE_KEY
    - setup-go-workspace
    - script:
        name: Clone private packages
        code: |-
          git clone git@github.com:pjvds/private-package.git $GOPATH/src/github.com/pjvds/private-package
    - script:
        name: Go build
        code: go build -v
    - script:
        name: Go test
        code: go test -v
{% endhighlight %}

You could also execute only the `go test` command in the build pipeline, since it will also build the code if needed. But by spliting these steps you better understanding which of these two failed.

### Earn some stickers!

Let me know about the applications you build with wercker. Don't forget to tweet out a screenshot of your first green build with **#wercker** and we'll send you some [@wercker](http://twitter.com/wercker) stickers.
