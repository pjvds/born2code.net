---
layout: post
title: "Use Go reflection to get func type information"
categories: [programming]
keywords: [golang, reflection, snippet]
---

Here is a small code snipped that demonstrates how to get type information
from a `func` in [Go](http://golang.org).

## Code

{% highlight go %}
package main

import (
  "fmt"
  "reflect"
)

type Multiplier func(x int, y int) int

func main() {
  m := Multiplier(Multipli)
  mType := reflect.TypeOf(m)

  fmt.Printf("name: %v\n", mType.Name())
  fmt.Printf("in args: %v\n", mType.NumIn())
  fmt.Printf("out args: %v\n", mType.NumOut())
  fmt.Printf("in arg 1 type: %v\n", mType.In(0).Name())
  fmt.Printf("in arg 2 type: %v\n", mType.In(1).Name())
  fmt.Printf("out arg 1 type: %v\n", mType.Out(0).Name())
}

func Multipli(x int, y int) int {
  return x * y
}
{% endhighlight %}

## Prints

{% highlight terminal %}
name: Multiplier
in args: 2
out args: 1
in arg 1 type: int
in arg 2 type: int
out arg 1 type: int
{% endhighlight %}
