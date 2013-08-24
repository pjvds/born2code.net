---
layout: post
title: "MacBook Pro retina display resolution in Ubuntu"
categories: [programming]
keywords: [ubuntu, golang, wercker]
---

Here is a quick post on how I fixed my retina resolution on ubuntu.

Today I installed [ubuntu 13.04](http://www.ubuntu.com) on my MacBook Pro Retina (10,1). Everything worked fine out of the box, but ubuntu has set the display resolution to 2880x1800. Although I looks pretty sexy to have such a high resolution, I thought it was a bit to much. I played a bit with different settings and I found that a scale factor of `0.6x0.6` works the best. Here is a command to change it:

	xrandr --output eDP-2 --scale .6x.6