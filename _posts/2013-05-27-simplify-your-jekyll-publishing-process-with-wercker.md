---
layout: post
title: "Simplify your Jekyll publishing process with wercker"
categories: [programming]
tag: [wercker, jekyll, continuous deployment]
keywords: [wercker, jekyll, continuous deployment, Amazone S3]
---

NIEUWE TEXT

With many [bloggers moving to static site generators](https://www.google.nl/search?q=popular+bloggers+moving+to+jekyll) and success stories like [Obama's $250 million fundraising platform](http://kylerush.net/blog/meet-the-obama-campaigns-250-million-fundraising-platform/) people are accepting static site generators as a serious alternative. Especially when security and performance is important.

Beside all the goodness that static site generators offer, they come with a price. You need to regenerate the site every time the content changes. This must be done by a machine that has the static site generator software installed. Although this may not be a problem when you are at the office, it will hold you from finishing an article on your tablet or fixing a typo from your cell phone.

## Wercker to the rescue!

Wercker is a content continuous delivery platform in the cloud. You can leverage its power to do the content generation and deployment process for you. Here is how you set it up for a [Jekyll](http://jekyllrb.com) site that is hosted on [Amazon S3](http://aws.amazon.com/s3/).

## Assumptions

* You have [created a free account](https://app.wercker.com/users/new/) at wercker.
* You have the code of your jekyll site hosted at [Github](http://github.com) or [Bitbucket](http://bitbucket.com).
* You have cloned a repository that contains a [jekyll](http://jekyllrb.com) site locally.
* You have an [Amazon S3 bucket](http://docs.aws.amazon.com/AmazonS3/latest/dev/HostingWebsiteOnS3Setup.html) that hosts your website.

## Add your application to wercker

First you need to add application to wercker. [Sign in](http://app.wercker.com/) at wercker and click the big blue `add an application` button.

![image]({{ 'simplify-your-jekyll-publishing-process-with-wercker/welcome-to-wercker.png' | asset_url }})

Follow the steps that and make sure you give the `werckerbot` user read rights on your repository at Github or Bitbucket.

At the end of the process the following screen appears.

![image]({{ 'simplify-your-jekyll-publishing-process-with-wercker/thank-you-for-adding-a-new-project.png' | asset_url }})

## Creating the wercker.yml
Now it is time to define your build process. This is the process that will get executed everytime changes are pushed to the git repository.

Create a new file called `wercker.yml` in the root of your repository with the following content:

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

This is what you defined in the wercher.yml file. The first line contains `box: wercker/ruby` which defines that you want to run the build in a ruby box.
The second line defines the `build` section that consists of steps, in this case two. These steps are performed during the execution of the build. The first step `bundle-install` is a smart version of the `bundle install` command that uses caching so future build will execute faster. The second step `script` executes the script that is defined the `code` option that consists of a single command `bundler exec jekyll build --trace`.

## Add wercker.yml to your repository

After you created the `wercker.yml` add it to your repository by executing the following commands.

{% highlight bash %}
git add wercker.yml
git commit -m 'Add wercker.yml'
git push origin master
{% endhighlight %}

Because you have created an application for this repository at wercker it should now start building. Open the application page at wercker to see the following result.

![image]({{ 'simplify-your-jekyll-publishing-process-with-wercker/first-build.png' | asset_url }})

Congratulations, you first green build at wercker! If you [tweet me](http://twitter.com/pjvds) or e-mail [pj@born2code.net](mailto:pj@born2code.net) a screenshot I will make sure you receive a sticker to celebrate.

## Add deployment target information
Now you have automated your content generation process that will get executed every time you push your code to git. This is helpful to catch jekyll errors early, but without a deployment it doesn't help your live website. Let's add a deploy target to you wercker application so we can close the loop.

Goto your application at [app.wercker.com](https://app.wercker.com) and click on the settings tab.

![image]({{ 'simplify-your-jekyll-publishing-process-with-wercker/add-custom-deploy.png' | asset_url }})

A new form opens that you can use to enter information that is passed to the deployment context. Here you enter the details of our Amazon S3 bucket. The key and secret key can be found in the [AWS security credentials](https://portal.aws.amazon.com/gp/aws/securityCredentials) page.

![image]({{ 'simplify-your-jekyll-publishing-process-with-wercker/deploy-details.png' | asset_url }})

_note: this aren't my real keys… duh!_

When you are hosting on another platform, you could use this to enter the FTP or other details.

## Add deployment steps
The current `wercker.yml` file contains the steps that are executed when the application is build. Now you want to add steps that are executed when the application is deployed. The steps is executed in a context that hold the information you have entered in the previous step; key, secret and s3 url.

Add the following to the end of your current `wercker.yml` file:

{% highlight yaml %}
deploy:
  steps:
    - s3sync
        key_id: $KEY
        key_secret: $SECRET
        bucket_url: $BUCKET
        source: _site/
{% endhighlight %}

The `s3sync` step synchronises a source directory with an Amazon S3 bucket. The `key_id`, `key_secret` and `bucket_url` options are set to the information from the deploy target created informationevious step. Only the `source` option is _hard coded_ (or should I say _hard configured_?) to `_site/`. This is the directory where jekyll stores the output.

We could also _hard code_ the key and key secret in here, but that is not something you want to put in your git repository. Especially not when you repository is public like [mine](https://github.com/pjvds/born2code.net).

Commit the changes of the `wercker.yml` file and push them to your repository.

{% highlight bash %}
git add wercker.yml
git commit -m 'Add deployment section'
git push origin master
{% endhighlight %}

## Deploy it!
You have pushed changes to your repository, thus wercker created another build. Now the deployment information that you have added in the previous steps can be used to deploy the website. This can be done for every successful build in your application by clicking the blue deploy button.

![image]({{ 'simplify-your-jekyll-publishing-process-with-wercker/deploy-it.png' | asset_url }})

## Did anything go wrong?
Let me help you! Just [tweet me](http://twitter.com/pjvds) or sent me an e-mail [pj@born2code.net](mailto:pj@born2code.net).

## Learn more

* You can learn more from [my wercker.yml file](https://github.com/pjvds/born2code.net/blob/master/wercker.yml).
* See my [born2code.net application](https://app.wercker.com/#project/5198a619a4dd999717000331) at wercker.
* More about the wercker.yml can be found at the [wercker devcenter](http://devcenter.wercker.com/articles/werckeryml/).
