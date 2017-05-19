# !/bin/bash
# Installation script for Tensorflow Serving
# Written by Jorick Triempont (jorickjt) & Jirry Haerinck (JirryH) commissioned by Big Industries - Big Data Consulting

installbazel=$1


##Install bazel on Ubuntu 16 (for other OS versions please look at https://bazel.build/versions/master/docs/install.html)
if [ installbazel == "True" ]
then
    ### Add bazel distribution URI as a package source
    echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
    curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
    ## Install and update Bazel
    sudo apt-get update && sudo apt-get install bazel
    sudo apt-get upgrade bazel
fi

##Download relevant binary
cd ~/Downloads/
wget https://github.com/bazelbuild/bazel/releases/download/0.4.5/bazel-0.4.5-jdk7-installer-linux-x86_64.sh
chmod +x bazel-0.4.5-installer-linux-x86_64.sh
./bazel-0.4.5-installer-linux-x86_64.sh --user

##Set up environment
export PATH="$PATH:$HOME/bin"
echo $PATH >> ~/.bashrc    

##Install gRCP
sudo pip install grpcio

## Install Tensorflow Serving Dependencies
sudo apt-get update && sudo apt-get install -y \
        build-essential \
        curl \
        libcurl3-dev \
        git \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python-dev \
        python-numpy \
        python-pip \
        software-properties-common \
        swig \
        zip \
        zlib1g-dev

##Installation from source
###Clone the TensorFlow Serving repository
git clone --recurse-submodules https://github.com/tensorflow/serving
cd serving

###Install prerequisites
cd tensorflow
./configure
cd ..

##Build Tensorflow Serving
bazel build tensorflow_serving/...
./bazel-bin/tensorflow_serving/example/mnist_inference
bazel test tensorflow_serving/...