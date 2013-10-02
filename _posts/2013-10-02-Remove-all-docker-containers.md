---
layout: post
title: Remove all docker containers
categories: [programming]
tag: [docker, snippet]
---
Here is a quick snippet to delete all your docker containers:

{% highlight bash %}
docker rm $(docker ps -a -q)
{% endhighlight %}
