---
layout: post
title: Fix Go compilation errors after update
categories: [programming]
tag: [golang]
---

After upgrading my Go 1.1.1 to 1.1.2, 9o fails to compile packages - or have dependencies - that are already compiled with errors like this:

    specs/client/AppendingToAStream_test.go:4: import /Users/pjvds/dev/mygo/pkg/darwin_amd64/github.com/smartystreets/goconvey/convey.a: object is [darwin amd64 go1.1.1 X:none] expected [darwin amd64 go1.1.2 X:none]

The last part in the errors tells me that this is because the code has previously been compiled with Go 1.1.1. Which makes perfect sense since I just updated. After a short journey of trial and error I found the solution that worked for me.

Since building is very fast with Go, the easiest thing to do is to remove the compiled packages.

    rm -rf $GOPATH/{bin,pkg}

Happy coding!
