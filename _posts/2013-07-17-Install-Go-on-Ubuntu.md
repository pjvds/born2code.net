---
layout: post
title: "Install Go on Ubuntu"
categories: [programming]
keywords: [ubuntu, golang]
---

Here is a quick gist that installs [Go](http://golang.org) on Ubuntu.

* Go root will be in `usr/local/go`
* Go path will be in `$HOME/go`

{% highlight bash %}
wget https://go.googlecode.com/files/go1.1.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.1.1.linux-amd64.tar.gz
rm go1.1.1.linux-amd64.tar.gz

mkdir -p "$HOME/go"{src,pkg,bin}
echo 'export GOPATH="$HOME/go"' >> "$HOME/.profile"

echo 'export GOROOT="/usr/local/go"' >> "$HOME/.profile"
echo 'export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"' >> "$HOME/.profile"

source "$HOME/.profile"
{% endhighlight %}
