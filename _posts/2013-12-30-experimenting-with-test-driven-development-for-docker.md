---
layout: post
title: "Experimenting with Test Driven Development for Docker"
tags: ["docker", "tdd", "ruby", "rspec"]
---

One of the programming practices that had the biggest impact on the way I write code is Test Driven Development. It significantly shortened the development feedback loop and helps to break down development into small steps with each have a clear goal. The test suite acts as a safety net that enables me to refactor with confidence. It is also a fun way to document a project in an executable form.

What if I could bring this technique to the development of my docker containers? I expect that it will improve at least something to the ssh-into-a-container-and-start-trail-and-erroring-while-putting-the-succesfull-commands-in-a-dockerfile way I currently work.</h4>

## The test environment

Docker doesn't come with a test environment, nor are there specific test tools for docker. But this doesn't mean we cannot test our containers. We just a good test runner and something that can interact with the docker environment. I decided to use ruby with [rspec](http://rspec.info) as a test runner and the [docker-api](https://github.com/swipely/docker-api/) gem to interact with the docker environment.

Here is a list of docker client libraries for other platforms:

* Erlang: [erldocker](https://github.com/proger/erldocker)
* Go [go-dockerclient](https://github.com/fsouza/go-dockerclient)
* Java [docker-java](https://github.com/kpelykh/docker-java)
* Nodejs: [docker.io](https://github.com/appersonlabs/docker.io)
* PHP [Alvine](http://pear.alvine.io/)
* PHP: [docker-php](https://github.com/mikemilano/docker-php)
* Python: [docker-py](https://github.com/dotcloud/docker-py)
* Ruby: [docker-api](https://github.com/swipely/docker-api/)

## Gemfile

To setup the environment I create a new folder and put the following Gemfile into it:

``` ruby
source 'https://rubygems.org'

gem 'rspec'
gem 'docker-api'
```

A simple `bundle install` will retrieve all the dependencies.

## Test Driven Development

Here is the process that I have in mind:

1. Start with a failing test
2. Verify the test fails
3. Implement the fix
4. Run tests again to see verify it works and doesn't break anything else
5. Repeat

## What I want to develop

My goal is to develop a docker image that can be used to run as the database service for my application. It needs to run postgres 9.3 and must have a user in place for my application that has an empty database present.

## Writing the first test

It is time to write the first test. It should just guide me to the next step in my development process, and not any further. It also must have a single and clear goal. A good one to start with is to verify if there is an image present in the docker environment. I don't care about the details of the image yet, just that is has the correct name `pjvds/postgres`. So I start by creating a file called `specs.rb`, require docker and write down the first spec:

``` ruby
require 'docker'

describe "Postgres image" do
    before(:all) {
        @image = Docker::Image.all().detect{|i| i.info['Repository'] == 'pjvds/postgres'}
    }

    it "should be availble" do
        expect(@image).to_not be_nil
    end
end
```

Running this spec will fail as expected:

``` bash
$ rspec specs.rb
F

Failures:

  1) Postgres image should be availble
     Failure/Error: expect(image).to_not be_nil
       expected: not nil
            got: nil
     # ./specs.rb:9:in `block (2 levels) in <top (required)>'

Finished in 0.00282 seconds
1 example, 1 failure

Failed examples:

rspec ./specs.rb:8 # Postgres image should be availble
```

## Implementing the first test

To satisfy the test I create a docker image with the name `pjvds/postgres`. So I create a very simple Dockerfile that just inherits from ubuntu.

```
FROM ubuntu
MAINTAINER Pieter Joost van de Sande <pj@wercker.com>
```

I use the `docker build` command to build an image based on the Dockerfile and give it the repository name that corresponds with the test:

``` console
$ docker build -t=pjvds/postgres .
Uploading context 61.44 kB
Step 1 : FROM ubuntu
 ---> 8dbd9e392a96
Successfully built 8dbd9e392a96
```

## Green

When I now run the specs again, it succeeds:

``` console
$ rspec specs.rb
.

Finished in 0.00278 seconds
1 example, 0 failures
```

## Automate

But, I don't want to type in the commands each time I want to build and run the tests. I create a file called `build` with execution permissions and add the steps I just took:

``` bash
#!/bin/bash
echo "Building docker image:"
docker build -t=pjvds/postgres .
echo
echo "Executing tests:"
rspec specs.rb
```

## Driving the next step

I must write another failing test to drive the next step in my development process. Since I want to run postgres, the image should expose the postgres default tcp port 5432. This is docker's way to make a port inside a container available to the outside. This information is stored in the image container configuration and can easily be accessed with the docker-api gem. So, I write the following test:

``` ruby
it "should expose the default tcp port" do
    expect(image.json["container_config"]["ExposedPorts"]).to include("5432/tcp")
end

```

## See it fail again

I run the tests again to see one example fail:

``` console
$ ./build
Finished in 0.007 seconds
2 examples, 1 failure

Failed examples:

rspec ./specs.rb:12 # Postgres image should expose the default tcp port
```

## Implementing the test

A small addition to the Dockerfile should satisfy the failing test:

```
FROM ubuntu
MAINTAINER Pieter Joost van de Sande <pj@wercker.com>
EXPOSE 5432
```

## Green

If I now run the specs again, it succeeds:

``` console
$ ./build
.

Finished in 0.00278 seconds
3 example, 0 failures
```

## Starting the container

In the previous tests I asserted the docker environment and the image configuration. For the next test I want to test if the container accepts postgres connections and need a running container instance for this. In short I want to do the following:

1. Start a container
2. Execute tests
3. Stop it

I introduce a new describe level where I start the container based on the image:

``` ruby
describe "running it as a container" do
    before(:all) do
        id = `docker run -d -p 5432:5432 #{@image.id}`.chomp
        @container = Docker::Container.get(id)
    end

    after(:all) do
        @container.kill
    end
end
```

## Test postgres accepts connections

Now that I have a context where the container is running, I write a small test to make sure it does not refuse connections to postgres.

``` ruby
it "should accept connection to the default port" do
    expect{ PG.connect('host=127.0.0.1') }.to_not raise_error(PG::ConnectionBad, /Connection refused/)
end
```

I run the build script again to see it fail.

## Adding Postgres

Now it is time to add postgres to the container. Installing it is easy with the postgresql apt repository. Here is the updated `Dockerfile` with detailed comments:

```
FROM ubuntu
MAINTAINER Pieter Joost van de Sande <pj@born2code.net>

# Allow incomming connection on default postgres port
EXPOSE 5432

# Store postgres directories as environment variables
ENV DATA_DIR /var/lib/postgresql/9.3/main
ENV BIN_DIR /usr/lib/postgresql/9.3/bin
ENV CONF_DIR /etc/postgresql/9.3/main

# Install required packages for setup
RUN apt-get update
RUN apt-get install wget -y

# Adds postgresql apt repository.
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" | tee -a /etc/apt/sources.list.d/postgresql.list
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update

# Install the postgresql packages
RUN apt-get install postgresql-9.3 postgresql-contrib-9.3 -y

# Configure postgres to accept connections from everywhere
# and let it listen to all addresses of the container.
RUN echo "host all all 0.0.0.0/0 md5" | tee -a $CONF_DIR/pg_hba.conf
RUN echo "listen_addresses='*'" | tee -a $CONF_DIR/postgresql.conf

# Set defaults for container execution. This will run the postgres process with
# the postgres user account and  specifies the data directory and configuration file location.
CMD ["/bin/su", "postgres", "-c", "$BIN_DIR/postgres -D $DATA_DIR -c config_file=$CONFIG_DIR/postgresql.conf"]
```

## Green!

If we now run the build again, we see it succeed:

``` console
$ ./build
.

Finished in 0.04833 seconds
2 examples, 0 failures
```

## Test for the super user

It doesn't make sense to have a database running without the power to make changes to it. Let's write a spec to drive the development of adding a super user to the postgres environment.

``` ruby
it "should accept connections from superuser" do
    expect{ PG.connect(:host => '127.0.0.1', :user => 'root', :password => 'h^oAYozk&rC&', :dbname => 'postgres')}.to_not raise_error()
end
```

Running the tests will now have one failure as expected:

``` console
$ ./build
.

Finished in 0.05978 seconds
3 examples, 1 failures
```

## Adding a super user

Here is a tricky part, I can't add a user with the `createuser` tool that ships with postgres. This requires postgres to be running, and since we are running postgres in an environment that doesn't have upstart available it isn't running after the installation. I could spend a lot of time getting it up and running in the background, or could start it in the foreground and pipe a command to it via stin. I opt for the later and create a small script that does exactly that:

``` bash
#!/bin/bash
if [[ ! $BIN_DIR ]]; then echo "BIN_DIR not set, exiting"; exit -1; fi
if [[ ! $DATA_DIR ]]; then echo "DATA_DIR not set, exiting"; exit -1; fi
if [[ ! $CONF_DIR ]]; then echo "CONF_DIR not set, exiting"; exit -1; fi
if [[ ! $1 ]]; then echo "Missing query parameter, exiting"; exit -2; fi

su postgres sh -c "$BIN_DIR/postgres --single -D $DATA_DIR -c config_file=$CONF_DIR/postgresql.conf" <<< "$1"
```

I save this file as `psql` and add the following details to the Dockerfile to add a super user to the database:

```
# Bootstrap postgres user and db
ADD psql /
RUN chmod +x /psql
RUN /psql "CREATE USER root WITH SUPERUSER PASSWORD 'h^oAYozk&rC&';"
```

The `ADD` command copies the psql file into the container. Then it will give the file execution permissions and uses it to create a superuser with the name root.

## Green!

If we now run the spec again, we see it succeed:

``` console
$ build
.

Finished in 0.05831 seconds
4 examples, 0 failures
```

## What is next

I can repeat this loop until I've added all the features requirements. Some tests that would follow could be;

* does it have a user for our application?
* does this user also have a database?
* is this database empty?
* is the postgis extension available?

Taking this to the next level I could add this to a CI service, like [wercker](http://wercker.com) and execute the tests on every push. This also makes it possible to do automated deployments to a docker index. But thats a scenario to cover in another post.

## Conclusion

Using tests to drive the development of a docker container is pretty easy. There are a lot of client api's that enables almost any major programming environment to become a docker test environment. The biggest difference that I see compared with testing software applications that the docker tests come in the form of integration tests. This could be a problem if some aspect will take more time, but my current container tests are executing very fast. Also rebuilding the container is quite fast because of the way dockers caching works. You can even leverage this further by creating a base image for the stable prerequisites.

In short, it's a great addition to the ssh-into-a-container-and-start-trial-and-erroring-while-putting-the-succesfull-commands-in-a-dockerfile way of working and we will definitely explore this route even further.
