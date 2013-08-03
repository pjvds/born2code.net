---
layout: post
title: "Remove all containers from docker"
categories: [programming]
keywords: [ubuntu, golang, wercker]
---

Working with [docker](http://docker.io) is great, but sometimes I feel the need to cleanup my containers. Currently docker has no easy way for doing this.

There has been some talk on Github about a docker clean command. If you are interested I suggest you to watch this issue: [Implement a 'clean' command](https://github.com/dotcloud/docker/issues/928). Until this feature is released, you can use one of the following command to clean up all your containers:

## Clean all containers

    # WARNING: This will remove all your docker containers!
    docker ps -a | tail -n +2 | awk '{print $1}' | xargs docker rm

## Remove containers older than a week

    # WARNING: This will remove all docker containers older than one week!
    docker ps -a | grep 'week ago' | awk '{print $1}' | xargs docker rm

## Remove containers from specific image

    # WARNING: This will remove all containers from matching image(s)
    docker ps -a | tail -n +2 | awk '{$2 ~ /my-image-name/} {print $1}' | xargs docker rm
