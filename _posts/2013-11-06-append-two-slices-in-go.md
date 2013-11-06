---
layout: post
title: "Append two slices in Go"
description: ""
category: ""
tags: []
---

[Go]("http://golang.org") ships with a buildin function `append` that can append
elements to the end of a slice and returns the updated slice. Here is an example:

{% hightlight go %}
data := []int{ 1,2,3 }
data = append(data, 4)

fmt.Println(data)
{% endhighlight %}

This will print the following:

{% hightlight %}
[1 2 3 4]
{% hightlight %}

Now I was browsing to some Go code and found something like this:

{% highlight go %}
data := []int{ 1,2,3 }
next := []int{ 4,5,6 }

for _ , v := range next {
    data = append(data, v)
}
{% endhighlight %}

This is not a very good way to append a slice to another slice. Actually
it is bad and here is why. The append function appends elements to
the end of a slice. If it has sufficient capacity, the destination is resliced
to accommodate the new elements. If it does not, a new underlying array will be allocated.

The important part here is that it will allocate a new underlying array everytime
there is insufficient capacity. Because the code above only appends a single
value at the time, the runtime does not know what to expect, otherwise that it
should grow to make room for an single extra value. The whole idea behind slices
is to prevent unnecessary allocations.

An easy way to fix this is to pass all the data that needs to be appended at once.
This way the runtime has all the information needed to grow only once, if needed.

{% highlight %}
data := []int{ 1,2,3 }
next := []int{ 4,5,6 }

data = append(data, next...)
{% endhighlight %}

Notice the suffix `...` added to `next`. This is Go's way of telling to a variadict
that we want to pass multiple arguments instead of a single value.
If we remove the `...` we will receive an compile error that `next` an invalid
type to append to `data`. This makes sense because we can't append an `[]int` value
to an `[]int`, only `int` values are allowed.

I guess that the programmer used an `for` loop to resolve this compile error instead
of passing multiple arguments at once.
