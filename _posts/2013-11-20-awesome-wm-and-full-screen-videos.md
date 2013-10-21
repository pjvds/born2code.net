---
layout: post
title: "Awesome WM and full screen videos"
categories: [os]
keywords: [ubuntu]
---

I recently switched my main operating system from Mac OSX to Ubuntu with [AwesomeWM](http://awesome.naquadah.org/), a [tailing window manager](http://en.wikipedia.org/wiki/Tiling_window_manager). I notice a vast improvement in my ability to focus and definitely get into _the zone_ quicker. Unfortunately it also broke the ability to watch video's full screen. Here is how I fixed it.

## The problem

Here is a screenshot of a setup that I use pretty frequently when I am watching a video.

![awesome video setup]({{ 'awesomewm-and-full-screen-video/awesome-video-setup.png' | asset_url }})

A video on the right, a twitter client - especially when watching a live stream -, and vim for taking notes.

But this setup breaks in awesomewm as soon as I switch the video to fullscreen.

![awesome broken fullscreen]({{ 'awesomewm-and-full-screen-video/awesome-broken-fullscreen.png' | asset_url }})

## The solution

The fix is pretty easy. We need to tell awesomewm how to handle `plugin-container` instances in a different way. It must not try to arrange them like other windows (the whole idea behind a tiling window manager), but just let it float on top of everything in the size it wants (fullscreen). To do so, add the following rule to your `rc.lua`.

{% highlight lua %}
{ rule = { instance = "plugin-container" },
  properties = { floating = true,
                 focus = yes } },
{% endhighlight %}

After the change your can restart awesomewm by pressing `modkey+control+r`, or if that doesn't work, just logout and login again.

From now on fullscreen video will just work like you would expect it to work, fullscreen.

![awesome fullscreen video]({{ 'awesomewm-and-full-screen-video/awesome-fullscreen.png' | asset_url }})

New instances will be floating fullscreen and get focus as they spawn. Just press `ESC` to exit them.

_ps: The video is: [Everything I Know About Fast Databases I Learned at the Dog Track](http://vimeo.com/63690418)._
