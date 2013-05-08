---
layout: post
title: "Put your Jekyll deploy on steriods with Wercker"
comments: true
categories: [programming]
tag: [wercker, jekyll, continuous deployment]
keywords: [wercker, jekyll, continuous deployment, Amazone S3]
---

At wercker, we are big fans of static site generators. Wercker's [blog](http://blog.wercker.com/) is powered by [Jekyll](http://jekyllrb.com/) and [devcenter](http://devcenter.wercker.com) by [middleman](http://middlemanapp.com/). The blog that you are currently visiting - if you are not reading this via RSS or other content aggregation - is also powered by Jekyll.

But we are not the only one. I see many of bloggers moving away from [Wordpress](http://wordpress.org) to [Jekyll](http://jekyllrb.com/), [Hyde](http://ringce.com/hyde) or [Octopress](http://octopress.org/). Next to them I met web developers that succesfully used one of these generators for _simple_ websites. One of the best examples is [Obama's $250 million fundraising platform](http://kylerush.net/blog/meet-the-obama-campaigns-250-million-fundraising-platform/).

With this week's news that [Jekyll](http://jekullrb.com) is at version 1, I decided to share the way I switched from [Github Pages](http://pages.github.com/) to [Amazon S3](http://aws.amazon.com/s3/) for hosting and how I leverage the power of [Wercker](https://wercker.com/) to automate my build and deployment process.

## Why switching?

Github is doing a great job with Github Pages. Simple, reliable and fast webhosting using your own domain for free. I count it as one of the reasons static site generators really took off. Especially because it is powered by Jekyll.

Hosting your static site is at Github is [very popular](https://www.google.nl/search?q=hosting+blog+at+github). One of the main reasons is free pricing without loosing [custom domain names](https://help.github.com/articles/setting-up-a-custom-domain-with-pages).

Beside all the goodness, Github runs Jekyll in `--safe` mode. In short this means you can runs plugins. Although not everybody needs plugins, there are a few reasons why you could:

* [Adding search to your site](https://github.com/cobbler/jekyll-dynamic-search)
* [Adding a sitemap.xml](https://github.com/kinnetica/jekyll-plugins)
* 

## Create an S3 bucket

We start by create a Amazon S3 bucket that will hold the site. Using the [S3 web console](https://console.aws.amazon.com/s3/home) you can create a new bucket by clicking the big blue button called `Create Bucket`. A popup will appear where you can enter your bucket name. I entered `born2code.net`, since that is the domain that will host my blog.

![image]({{ 'continuous-deployment-for-jekyll/create-bucket-name.png' | asset_url }})

## Enable website hosting

The bucket is now created and we need to enable website hosting in it. Click on the

![image]({{ 'continuous-deployment-for-jekyll/enable-website-hosting.png' | asset_url }})

## Access credentials

![image]({{ 'continuous-deployment-for-jekyll/generate-key.png' | asset_url }})

