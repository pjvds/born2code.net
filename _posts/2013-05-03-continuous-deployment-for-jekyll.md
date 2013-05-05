---
layout: post
title: "Put your Jekyll deploy on steriods with Wercker"
date: 2013-05-03 22:00
comments: true
categories: [programming]
tag: [wercker, jekyll, continuous deployment]
keywords: [wercker, jekyll, continuous deployment, Amazone S3]
---

One thing that we all noticed is that static site generators are definite. I saw many of bloggers moving to Jekyll, Hyde or Octopress and have spoken to web developers that succesfully used one of these generators for simple websites.  When you have been browsing the blogosphere, you have noticed that many bloggers or moving from towards static site generator. Especially Jekyll is extremely populair. A simple [search at Google](https://www.google.nl/search?q=moving+to+jekyll) for with the phrase "moving to jekyll" gives around the 2 million results.

## Requirements

* You have the [AWS Command Line Interface](http://aws.amazon.com/cli/) installed

## Create an S3 bucket

In order to serve your site from Amazon S3 you need to first create a bucket to hold it. Using the [S3 web console](https://console.aws.amazon.com/s3/home) you can create a new bucket by clicking the big blue button called `Create Bucket`. A popup will appear where you can enter your bucket name. I entered `born2code.net`, since that is the domain I will host my blog on.

![image]({{ 'continuous-deployment-for-jekyll/create-bucket-name.png' | asset_url }})

## Enable website hosting

The bucket is now created and we need to enable website hosting in it. Click on the

![image]({{ 'continuous-deployment-for-jekyll/create-bucket-name.png' | asset_url }})

## Access credentials

![image]({{ 'continuous-deployment-for-jekyll/generate-key.png' | asset_url }})

