# Creating Scala support

Tomorrow [wercker](http://wercker.com) will host the [Scala Hackathon](http://www.meetup.com/amsterdam-scala/events/116311362/). A meetup with only one goal; hacking some scala code. Since people showed interesest in wercker during the [last meetup](http://www.meetup.com/amsterdam-scala/events/116300402/) I decided to do a short lightning talk to show wercker and tell what continuous delivery can do for you and your project. But here is the catch, at the time of writing wercker does not support Scala out of the box. So let us find out how we can add this.

## Open platform

One of the goals of wercker is to become an open platform to build, test and deliver software. This means users should be able to extend the platform easily. Before we can talk about adding Scala support, we need to understand some core concents of wercker.

Let us start by the build pipeline. This is roughly what wercker does everytime a developer pushes his code to git.

1. Cloning project repository from git.
2. Provision a box based on the project requirements.
3. Execute the build pipeline in this box.
4. Store pipeline output

## The box

A box is an machine that provides a context to execute the build pipeline. For example, if you have a Scala project, you want to run your pipeline in a context that runs the JVM, Scala, SBT and other tools that you need. Not all tools need to be present in that context.

Wercker highly encourages her users to create boxes and to share them with the community. What is better than creating a box for yourself and share it with others. This allows others to provide valuable feedback and even come with improvements. Creating a box is easy. It is nothing more than a simple yaml-file that contains the definition. This means you do not need to install any software to create your own box. Contributing to an existing box is also easy and users can leverage all the power from social coding platforms like Github and Bitbucket.

	apt-get install openjdk-7-jre -qq
	
	sudo wget http://www.scala-lang.org/downloads/distrib/files/scala-2.10.0.tgz
	tar zxvf scala-2.10.0.tgz
	mv scala-2.10.0 /usr/share/scala
	
	ln -s /usr/share/scala/bin/scala /usr/bin/scala
	ln -s /usr/share/scala/bin/scalac /usr/bin/scalac
	ln -s /usr/share/scala/bin/fsc /usr/bin/fsc
	ln -s /usr/share/scala/bin/sbaz /usr/bin/sbaz
	ln -s /usr/share/scala/bin/sbaz-setup /usr/bin/sbaz-setup
	ln -s /usr/share/scala/bin/scaladoc /usr/bin/scaladoc
	ln -s /usr/share/scala/bin/scalap /usr/bin/scalap

	wget http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch//0.12.3/sbt-launch.jar
	printf 'java -Xmx512M -jar `dirname $0`/sbt-launch.jar "$@"' > sbt
	chmod +x ./sbt
	sudo mv sbt /usr/share/sbt
	sudo mv sbt-launch.jar /usr/share/sbt-launch.jar
	sudo ln -s /usr/share/sbt /usr/bin/sbt
	sudo ln -s /usr/share/sbt-launch.jar /usr/bin/sbt-launch.jar