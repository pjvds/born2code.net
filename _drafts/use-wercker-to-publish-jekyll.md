---
layout: post
title: "Simplify the publishing process of Jekyll using wercker"
comments: true
categories: [programming]
tag: [wercker, jekyll, continuous deployment]
keywords: [wercker, jekyll, continuous deployment, Amazone S3]
---

We usually associate a *automated deployment pipeline* as a solution to lower the complexity of deployment for applications that are developed by big teams. But in this article we will go into details of how we can leverage it for static site generators.

With many [blogger moving to static site generators](https://www.google.nl/search?q=popular+bloggers+moving+to+jekyll) and success stories like [Obama's $250 million fundraising platform](http://kylerush.net/blog/meet-the-obama-campaigns-250-million-fundraising-platform/), people are now accepting them as an alternative to dynamically generated websites. Especially when security, performance and hosting simplicity are important.

Although static site generators introduce a lot of goodness, they come with a price. Every time the content changes, you need to regenerate the site. This regeneration must be done by a machine that has the static site generator software installed. For Jekyll this means you need to have [Ruby](http://www.ruby-lang.org/) and [Jekyll](http://jekyllrb.com) installed. Although this may not be a problem for your development machine, it will held you from finishing an article on your tablet or fixing a typo from your cell phone.

## Wercker to the rescue!

Wercker is a content continuous delivery platform in the cloud. We can leverage its power to do the content generation and deployment process for us.

## Assumptions

I assume the following:

* You have [created a account](https://app.wercker.com/users/new/) at wercker.
* You have the code of your yekyll site hosted at [Github](http://github.com) or [Bitbucket](http://bitbucket.com).
* You have cloned a repository that contains a [jekyll](http://jekyllrb.com) site locally.
* You have an [Amazon S3 bucket setup](http://docs.aws.amazon.com/AmazonS3/latest/dev/HostingWebsiteOnS3Setup.html) that hosts your website.

## Add your application to wercker

After you signed into [wercker](http://app.wercker.com/) you can add your application by clicking the `add an application` button.

![image]({{ 'use-wercker-to-publish-jekyll/welcome-to-wercker.png' | asset_url }})

The process that starts let you choose your repository at Github or Bitbucket. After you picked your repository, make sure you give the user `werckerbot` read rights on your repository by making it a collaborator.

When everything succeeded, the following screen should appear.

![image]({{ 'use-wercker-to-publish-jekyll/thank-you-for-adding-a-new-project.png' | asset_url }})

## Creating the wercker.yml

The [`wercker.yml`](http://devcenter.wercker.com/articles/werckeryml/intro.html) file is the place where we define our build and deployment process.

Create a `wercker.yml` file in the root of your repository with the following content:

{% highlight yaml %}
# define we want to run our build in a ruby box
box: wercker/ruby
build:
  steps:
    # Run a smart version of bundle install
    # which improves build execution time of
    # future builds
    - bundle-install
    
    # A customer script step 
    # that build the jekyll site
    - script:
        name: generate site
        code: bundler exec jekyll build --trace
{% endhighlight %}

The first line contains `box: wercker/ruby` which specifies that we want to run our build in a ruby box.
The second line defines the `build` section which consists of two steps that we want preform when we build the application. In first step `bundle-install` is a smart version of the `bundle install` which uses caching so future build will execute faster. The second step `script` executes the script we define in `code` which hold just a single command `bundler exec jekyll build`.

## Add wercker.yml to your repository

After you created the `wercker.yml` add it to your repository.

{% highlight bash %}
git add wercker.yml
git commit -m 'Add wercker.yml'
git push origin master
{% endhighlight %}

Because you have created an application for this repository on wercker it should now start building.

![image]({{ 'use-wercker-to-publish-jekyll/first-build.png' | asset_url }})

Congratulations, you first green build at wercker! If you send me a screenshot I will make sure you receive a sticker to celibrate.

## Add deployment target
Now you have automated your content genereration process. Everytime you push your code to git wercker will start this process. This is helpful to catch jekyll errors early, but without a deployment it doesn't help your live website.

Goto your application at [app.wercker.com](https://app.wercker.com) and click on the settings tab.