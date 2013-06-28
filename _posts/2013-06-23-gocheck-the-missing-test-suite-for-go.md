---
layout: post
title: "Gocheck, the missing test suite for Go"
categories: [programming]
keywords: [golang, gocheck, tdd]
---

I always loved the fact that [Go](http://golang.org/) ships with a build in test
runner that allows you to `go test` your application without any additional
tools required. Although the simplicity of Go tests is high, the API doesn't
allow you to create any suites with tear ups and tear downs. Stuff I usually
use for integration tests. So I started using [Gocheck](http://labix.org/gocheck)
today and I must say that I am in love! It has one of the best Go API's I've
seen so far (ok, it shares the first place with the [Gorilla Web Toolkit](http://www.gorillatoolkit.org/)).
Here are some examples of the features I enjoy!

## Test suites

Bundle your tests and add state to them.

{% highlight go %}
// Setup the test suite
var _ = Suite(&ApiIntegrationTestSuite{
  ProcessFilename: "httpcallback.io",
})

// The state for the test suite
type ApiIntegrationTestSuite struct {
  ProcessFilename string
  process         *os.Process
}
{% endhighlight %}


## Test suites with set up and tear down

{% highlight go %}
// Runs before the test suite starts
func (s *ApiIntegrationTestSuite) SetUpSuite(c *C) {
  var procAttr os.ProcAttr
  procAttr.Files = []*os.File{nil, os.Stdout, os.Stderr}
  procArgs := []string{"-config config.toml -port 8000"}
  process, err := os.StartProcess(s.ProcessFilename, procArgs, &procAttr)
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
{% endhighlight %}

## Tests come with set up and tear down

{% highlight go %}
// Runs before the test starts
func (s *ApiIntegrationTestSuite) SetUpTest(c *C) {
  s.ResetDataContext()
}

// Runs after the test finished, even when failed
func (s *ApiIntegrationTestSuite) TearDownTest(c *C) {
  s.Flush()
}
{% endhighlight %}

## Assert API

No more `if err != nil`'s in your Go test code, but a decent
assert API.

{% highlight go %}
func (s *ApiIntegrationTestSuite) TestPing(c *C) {
  response, err := http.Get("http://api.localhost:8000/ping")
  c.Assert(err, IsNil)
  c.Assert(response.StatusCode, Equals, http.StatusOK)

  doc, err := GetBodyAsDocument(c, response)
  c.Assert(err, IsNil)

  c.Assert(doc["message"], Equals, "pong")
}
{% endhighlight %}

## Skipping tests

{% highlight go %}
var aws = flag.Bool("aws", false, "Include aws tests")

func (s *ApiIntegrationTestSuite) TestAwsProvisioning(c *C) {
  if *aws {
    c.Skip("-aws not provided")
  }
}
{% endhighlight %}

## Support benchmark tests

{% highlight go %}
func (s *ApiIntegrationTestSuite) BenchmarkPing(c *C) {
  // c.N contains the number of times to repeat
  // the benchmark test. This number is dynamicly
  // set by the Go test runner.
  for i := 0; i < c.N; i++ {
    response, err := http.Get("http://api.localhost:8000/ping")

    if err != nil {
      c.Fatalf("Error while getting response: %v", err.Error())
    } else {
      response.Body.Close()
    }
  }
}
{% endhighlight %}

## Learn more

Read the [gocheck introduction page](http://labix.org/gocheck) to learn more
about the framework and its benefits.
