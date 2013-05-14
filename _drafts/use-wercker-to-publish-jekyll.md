---
layout: post
title: "Simplify the publishing process of Jekyll"
comments: true
categories: [programming]
tag: [wercker, jekyll, continuous deployment]
keywords: [wercker, jekyll, continuous deployment, Amazone S3]
---

We usually associate a *automated deployment pipeline* as a solution to lower the complexity of deployment for applications that are developed by big teams. But in this article we will go into details of how we can leverage this power for static site generators.

## Static website generators

A static site generator is a program that generates an HTML website as an output, mostly based on simple content like [markdown](http://daringfireball.net/projects/markdown/) or [textile](http://textile.sitemonks.com/). With many [blogger moving to static site generators](https://www.google.nl/search?q=popular+bloggers+moving+to+jekyll) and success stories like [Obama's $250 million fundraising platform](http://kylerush.net/blog/meet-the-obama-campaigns-250-million-fundraising-platform/) which was build with the static site generator Jekyll, people are now accepting them as an alternative to dynamicly generated websites. Especially when security, performance and hosting simplicity are important.

## Generation and publishing

Although static site generators introduce a lot of goodness, they come with a price. Everytime the content changes, you need to regenerate the site. This regeneration must be done with a machine that has the static site generator software installed. For Jekyll this means you need to have [Ruby](http://www.ruby-lang.org/) installed. This means you can't just finish an article on your tablet or fix a type from your cell phone.

## Wercker to the rescue!

Wercker is a content continuous delivery platform in the cloud. We can leverage its power to do not only the content generation process for us, but also deploys our website to Amazon S3 and invalidating a CDN like Amazon CloudFront.

## Assumptions

I assume the following:

* You have create a account at wercker.
* You have the code of your yekyll site hosted at [Github](http://github.com) or [Bitbucket](http://bitbucket.com).
* You have [Ruby](http://ruby-lang.org) and [Yekyll](http://jekyllrb.com/) installed.
* You have [git](http://git-scm.com/) installed.

## Add your site to wercker

After you signed into [wercker](http://app.wercker.com/) you can add your application by clicking the `add an application` button.

![image]({{ 'use-wercker-to-publish-jekyll/welcome-to-wercker.png' | asset_url }})

The process that starts let you choose your repository at Github or Bitbucket. After you picked your repository, make sure you give the user `werckerbot` read rights on your repository.

When everything succeeded, the follwing screen should appear.

![image]({{ 'use-wercker-to-publish-jekyll/thank-you-for-adding-a-new-project.png' | asset_url }})

## Adding wercker.yml

The `wercker.yml` file is the place where we define our build and deployment process.
