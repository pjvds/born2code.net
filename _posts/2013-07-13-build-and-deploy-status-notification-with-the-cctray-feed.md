---
layout: post
title: Build and deploy status notification with the cctray feed
categories: [programming, wercker]
keywords: [wercker, notifications, cctray]
---

At [wercker](http://wercker.com) we have added build and deployment status output in the <strong>cctray.xml</strong> format, an RSS-like continuous integration server status feed, which was originally developed for CruiseControl.net. In this post I would like to share the details and how I leverage this to get notified on important wercker status changes via CCMenu.

![image]({{ 'build-and-deploy-status-notification–with-the-cctray-feed/tray.png' | asset_url }})

## Configuration
Wercker offers two endpoints per project that serve status information in the **cctray.xml** format. One for the build status, and one for the deployment status.

### Buids status feed

The feed url that contains the build status from an project is:

    https://app.wercker.com/api/v2/applications/{PROJECT-ID}/cc/build

You need to replace `{PROJECT-ID}` with the project id of the project you want to monitor.

### Deploy status feed

The feed url that contains the deployment status of a project's deploy target is:

    https://app.wercker.com/api/v2/applications/{PROJECT-ID}/cc/deploytargets/{DEPLOY-TARGET-NAME}

You need to replace `{PROJECT-ID}` with the project id of the project you want to monitor and `{DEPLOY-TARGET-NAME}` with the name of the deploy target. Read more about deploy targets on ou [dev center](http://devcenter.wercker.com/articles/introduction/deploys.html#deploy-targets)

## Tools

Here is a list of tools that allow you to monitor **cctray.xml** feeds and that can be used to monitor your build and deployment statuses of your wercker projects.

* [CCMenu for Mac](http://ccmenu.sourceforge.net/)
* [CCTray for Windows](http://confluence.public.thoughtworks.org/display/CCNET/CCTray)
* [buildnotify for Linux](https://bitbucket.org/Anay/buildnotify/wiki/Home)
* [CruiseControl Monitor for Firefox](https://addons.mozilla.org/en-US/firefox/addon/cruisecontrol-monitor/)

## Using CCMenu

There are a lot of tools that support the cc status format. As I'm mostly working on a Mac I decided to use [CCMenu](http://ccmenu.sourceforge.net/). It allows you to monitor multiple projects at the same time, and identifies the overall build status with just a glance at the menu bar.

![image]({{ 'build-and-deploy-status-notification–with-the-cctray-feed/tray.png' | asset_url }})

Download and install the latest version of ccmenu from the [CCMenu project](http://sourceforge.net/projects/ccmenu/files/CCMenu/).

### Finding your project id

Navigate to your project page at [app.wercker.com](https://app.wercker.com) and copy your project id from the url.

![image]({{ 'build-and-deploy-status-notification–with-the-cctray-feed/project_id.png' | asset_url }})

### Add builds to CCMenu

Open CCMenu by clicking on the icon in the top menu bar and open preferences.

![image]({{ 'build-and-deploy-status-notification–with-the-cctray-feed/open_preferences.png' | asset_url }})

### Enter feed details

Click on the **plus** sign in the preference window and enter your project `cc` feed url. It is important to follow the following steps closely because CCMenu was acting a bit weird when I entered my details.

1. Enter your feed url
2. Click `Use URL as entered above` option
3. Enter your wercker credentials
4. Check `The server requires authentication`
5. Click `Continue`
6. See the status of your project in your menu bar!

![image]({{ 'build-and-deploy-status-notification–with-the-cctray-feed/add_feed.png' | asset_url }})


### Other feeds

You can repeat the previous steps for other feeds as well.

### Notification center

CCMenu supports Mac's [Notification Center](http://support.apple.com/kb/ht5362)

![image]({{ 'build-and-deploy-status-notification–with-the-cctray-feed/notifications.png' | asset_url }})

### Final result

![image]({{ 'build-and-deploy-status-notification–with-the-cctray-feed/final.png' | asset_url }})

## Earn some stickers

Let me know about the applications you build with wercker. Don't forget to tweet out a screenshot of your first green build with **#wercker** and I'll send you some [@wercker](http://twitter.com/wercker) stickers.
