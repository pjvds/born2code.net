---
layout: post
title: "Gocheck, the missing test suite for Go"
categories: [programming]
keywords: [golang, gocheck, tdd]
---

I've written quite some [Go](http://golang.org/) code this weekend. I always
loved that Go ships with a build in test runner that allows you to `go test`
your application without any additional tools required. Although the simplicity
of Go tests is high, the API doesn't allow you to create any suites with tear
ups and tear downs. Stuff I usually use for integration tests. So I started
using [Gocheck](http://labix.org/gocheck) today and I must say that I am in
love! It has one of the best Go API's I've seen so far (ok, it shares the
first place with the [Gorilla Web Toolkit](http://www.gorillatoolkit.org/)).

Let this code example speak for itself:

{% highlight go %}
package main

import (
  "encoding/json"
  "io/ioutil"
  . "launchpad.net/gocheck"
  "net/http"
  "os"
  "testing"
  "time"
)

// Hook up gocheck into the "go test" runner.
func Test(t *testing.T) {
  TestingT(t)
}

// Setup the test suite
var _ = Suite(&ApiIntegrationTestSuite{
  ProcessFilename: "httpcallback.io",
})

// The state for the test suite
type ApiIntegrationTestSuite struct {
  ProcessFilename string
  process         *os.Process
}

// Runs before the test suite starts
func (s *ApiIntegrationTestSuite) SetUpSuite(c *C) {
  var procAttr os.ProcAttr
  procAttr.Files = []*os.File{nil, os.Stdout, os.Stderr}
  process, err := os.StartProcess(s.ProcessFilename, []string{"-config config.toml -port 8000"}, &procAttr)
  if err != nil {
    c.Errorf("Unable to start %s: %s", s.ProcessFilename, err.Error())
    c.Fail()
  }

  // Allow process to warm up
  time.Sleep(2 * time.Second)
  s.process = process

  c.Logf("Started %s, pid %v", s.ProcessFilename, process.Pid)
}

// Runs after the test suite finished, even when failed
func (s *ApiIntegrationTestSuite) TearDownSuite(c *C) {
  if err := s.process.Kill(); err != nil {
    c.Logf("Unable to kill %s: %s", s.ProcessFilename, err.Error())
  }
}

func (s *ApiIntegrationTestSuite) TestPing(c *C) {
  response, err := http.Get("http://api.localhost:8000/ping")
  c.Assert(err, IsNil)
  c.Assert(response.StatusCode, Equals, http.StatusOK)

  doc, err := GetBodyAsDocument(c, response)
  c.Assert(err, IsNil)

  c.Assert(doc["message"], Equals, "pong")
}

func GetBodyAsDocument(c *C, response *http.Response) (map[string]interface{}, error) {
  var document map[string]interface{}
  data, err := ioutil.ReadAll(response.Body)
  if err != nil {
    return document, err
  }

  err = json.Unmarshal(data, &document)
  if err != nil {
    c.Logf("RAW Json: %s", string(data))
  }

  return document, err
}
{% endhighlight %}
