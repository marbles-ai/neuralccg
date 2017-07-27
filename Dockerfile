FROM ubuntu:16.04

# Set the working directory where CMD will be run
WORKDIR /root

RUN apt-get update \
    && apt-get install -y software-properties-common python-software-properties \
    && apt-get install -y openjdk-8-jdk \
    && apt-get install -y maven git curl wget vim
	
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
    && curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
	
RUN apt-get update \
    && apt-get install -y bazel
	
#RUN ./setup.sh

# This is the command to be executed when done creating our container
CMD ["/bin/bash", "--login"]
