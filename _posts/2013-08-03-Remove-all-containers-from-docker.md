---
layout: post
title: "Remove all containers from docker"
categories: [programming]
keywords: [ubuntu, golang, wercker]
---

Working with [docker](http://docker.io) is great, but sometimes I feel the need to cleanup my containers. Currently docker has no easy way for doing this.

There has been some talk on Github about a docker clean command. If you are interested I suggest you to watch this issue: [Implement a 'clean' command](https://github.com/dotcloud/docker/issues/928). Until this feature is released, you can use the following command to clean up all your containers:

    # WARNING: This will remove all your docker containers!
    docker ps -a | tail -n +2 | awk '{print $1}' | xargs docker rm
