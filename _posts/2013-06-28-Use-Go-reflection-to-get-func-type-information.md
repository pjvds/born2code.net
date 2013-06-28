---
layout: post
title: "Use Go reflection to get func type information"
categories: [programming]
keywords: [golang, reflection, snippet, go]
---

Here is a small code snipped that demonstrates how to get type information
from a `func` type in [Go](http://golang.org "Go's homepage"). I prints the
information to the console. More information about reflection can be found at
the great Go docs article [The Laws of Reflection](http://golang.org/doc/articles/laws_of_reflection.html).


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
  fmt.Printf("number of in args: %v\n", mType.NumIn())
  fmt.Printf("number of out args: %v\n", mType.NumOut())
  fmt.Printf("in arg 1 type: %v\n", mType.In(0).Name())
  fmt.Printf("in arg 2 type: %v\n", mType.In(1).Name())
  fmt.Printf("out arg 1 type: %v\n", mType.Out(0).Name())
}

func Multipli(x int, y int) int {
  return x * y
}
{% endhighlight %}

## Prints

    $ go run method.go
    name: Multiplier
    number of in args: 2
    number of out args: 1
    in arg 1 type: int
    in arg 2 type: int
    out arg 1 type: int
