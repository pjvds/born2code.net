---
layout: post
title: "Installing Ubuntu 13.10 on MacBook Pro Retina (10,1)"
description: ""
category: ""
tags: []
---

I've using Ubuntu 13.10 on my MacBook Pro for a couple of weeks now, and things have been working great so far. It is definitely an major improvement, especially because I totally fell in love with the taling window manager Awesome and finally found a way to minimize my mouse/trackpad usage to the absolute minimum. In this post I want to document my configuration, of others and my future self.

## Preparation

I choose for a dual boot configuration that allows me still to boot in Mac OS from time to time. I installed [rEFit 0.14](http://refit.sourceforge.net/) and created a bootable USB drive from the [Ubuntu 13.10 64-bit PC (AMD64) desktop image](http://releases.ubuntu.com/saucy/ubuntu-13.10-desktop-amd64.iso) with [UNetbootin](http://unetbootin.sourceforge.net/).

Before booting from that USB drive, download the wifi drivers and its dependencies (dkms, libc6-dev,linux-libc-dev):

1. [bcmwl-kernel-source](http://packages.ubuntu.com/raring/amd64/bcmwl-kernel-source/download)
2. [dkms](http://packages.ubuntu.com/raring/all/dkms/download)
3. [libc6-dev](http://packages.ubuntu.com/raring/amd64/libc6-dev/download)
4. [linux-libc-dev](http://packages.ubuntu.com/raring/amd64/linux-libc-dev/download)

Just download these .deb packages and put them in a folder, I called it wifi, on the USB drive.

## Install Ubuntu

Reboot your machine with the USB drive attached and follow the steps. There isn't really much to say about this step. The installation is pretty self explaining and shouldn't take more than a few minutes, depending on the speed of your USB drive.

## Install Wifi Drivers

Once Ubuntu is installed, boot it and login. Open a terminal window and `cd` to `/media/{username}/{usb-drive}/{wifi-folder}` and execute the following:

    sudo dpkq -i *.deb

This will install the packages. Wifi should start working after this step.

## Install Nvidia Drivers

Although the default drivers work pretty well, I had some trouble resuming my MacBook after it went to sleep. Installing the Nvidia drivers solved this problem. This is how I installed them:

    sudo apt-get update
    sudo apt-get install nvidia-319-updates nvidia-settings-319-updates

A reboot is required to get it all working correctly. After a reboot, start `nvidia-settings` to configure your environment.

