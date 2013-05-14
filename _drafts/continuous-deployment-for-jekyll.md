---
layout: post
title: "Put your Jekyll deploy on steriods with Wercker"
comments: true
categories: [programming]
tag: [wercker, jekyll, continuous deployment]
keywords: [wercker, jekyll, continuous deployment, Amazone S3]
---

We usually associate a *deployment pipeline* as a solution to lower the complexity of deployment for applications that are developed by big teams. But in this article we will go into details of how we can leverage this power for static site generators.

## Static website generators

Static website generatos are getting popular. Many of bloggers are switching from [Wordpress](http://wordpress.org) to [Jekyll](http://jekyllrb.com/), [Hyde](http://ringce.com/hyde) or [Octopress](http://octopress.org/). Webdevelopers leverage the power of static site generation to build [Obama's $250 million fundraising platform](http://kylerush.net/blog/meet-the-obama-campaigns-250-million-fundraising-platform/) with great success.



## Static output



With this week's news that [Jekyll](http://jekullrb.com) is at version 1, I decided to share the way I switched from [Github Pages](http://pages.github.com/) to [Amazon S3](http://aws.amazon.com/s3/) for hosting and how I leverage the power of [Wercker](https://wercker.com/) to automate my build and deployment process.

## Why switching?

First of all, Github is doing a great job with [Github Pages](http://pages.github.com/). Fast and simple webhosting with support for custom domains for nothing. I count it as one of the reasons static site generators made it to the main stream. Especially because it [runs Jekyll](https://help.github.com/articles/using-jekyll-with-pages).

Hosting your static site is at Github is [very popular](https://www.google.nl/search?q=hosting+blog+at+github). One of the main reasons is free pricing without loosing [custom domain names](https://help.github.com/articles/setting-up-a-custom-domain-with-pages).

Beside all the goodness, Github Pages has a few downsides. The biggest one is that Github runs Jekyll in `--safe` mode. In short this means you can not add plugins. Although not everybody needs plugins, there are a few reasons why you could:

* [Adding search to your site](https://github.com/cobbler/jekyll-dynamic-search)
* [Adding a sitemap.xml](https://github.com/kinnetica/jekyll-plugins)
* [Adding full text search](https://github.com/slashdotdash/jekyll-lunr-js-search) - wow!

Next to that you also do not know where your website is actually hosted. And when speed is important you want to host it close to your main audience.

## Amazon S3 hosting

### Create an S3 bucket

We start by create a [Amazon S3 bucket](http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingBucket.html) that will hold the website.

Login to [S3 web console](https://console.aws.amazon.com/s3/home). If you have no buckets, Amazon will start the _create a bucket_ wizard directly. Otherwise, click the big blue button called `Create Bucket` to start it.

Enter the url of the website as bucketname. I entered `born2code.net`, since that is the domain that will host my blog.

![image]({{ 'continuous-deployment-for-jekyll/create-bucket-name.png' | asset_url }})

### Enable website hosting

The bucket is now created and we need to enable website hosting in it.

* Select your bucket on the left pane by clicking on the row. Do not click on the name itself, because this will open the content of the bucket.
* In the right pane, open the tab called `static website hosting`.
* Select the `enable website hosting` option.
* Fill in `index.html` as index document.
* Fill in `404.html` as error document.
* Hit `save` to confirm the changes.

![image]({{ 'continuous-deployment-for-jekyll/enable-website-hosting.png' | asset_url }})

### Access credentials

We need to create a key pair that we will use to upload content to the bucket.

* Navigate to [security credentials](https://portal.aws.amazon.com/gp/aws/securityCredentials#access_credentials). Note that this is another section on AWS.
* Click the `create a new access key` link below the access key list. A new key will be added to the list.
* Write down the `Access Key Id` and `Secret Access Key`. Click the `show` link to view your secret access key.

![image]({{ 'continuous-deployment-for-jekyll/generate-key.png' | asset_url }})
