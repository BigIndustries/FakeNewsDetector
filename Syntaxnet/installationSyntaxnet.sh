#!/bin/bash
# Installation of syntaxnet
# Written by Jorick Triempont (jorickjt) & Jirry Haerinck (JirryH) commissioned by Big Industries - Big Data Consulting

#Check for extra flags
if [ $# -ne 0 ]
then
	#Check if s flag is triggerd
	if [[ $1 == *"s" ]]
	then
		echo "-s is triggerd"
		commandShow="true"
		#Set the option on for showing the commands before they get executed
		set -x
	fi
fi

#Check Python
echo 'Check python = 2.7' 
#Check if python exists
python2.7 -V &> /dev/null

#If python isn't installed install python
if ! [ $? = 0 ]
then
	echo "Installing python2.7"
	#Install python2.7
	sudo apt-get -y install python2.7

	#Check if python2.7 is good installed
	if [ $? -ne 0 ]; then
		echo "Error 1: Something went wrong while installing python2.7"
		exit 1
	fi

	echo "Python2.7 installed"
fi

#If pip isn't installed install pip
if ! [ -x /usr/local/bin/pip ]
then
	echo "installing pip"
	#Install pip and extra packages
	sudo apt-get -y install python-pip python-dev build-essential

	#Check if installation is succeeded
	if [ $? -ne 0 ]; then
		echo "Error 1: Something went wrong while installing pip"
		exit 1
	fi	

	#Upgrade pip
	sudo -H pip install --upgrade pip

	#Check if upgrade is succeeded
	if [ $? -ne 0 ]; then
		echo "Error 1: Something went wrong while upgrading pip"
		exit 1
	fi
fi

echo "install bazel"
echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list 

#If curl isn't installed install curl
if ! [ -x /usr/bin/curl ]
then
	echo "Installing curl"
	sudo apt-get -y install curl

	if [ $? -ne 0 ]; then
		echo "Error 1: Something went wrong while installing curl"
		exit 1
	fi	

	echo "Curl installed"
fi

#Get the bazel packages and add the key to the system
sudo curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -

#Install and upgrade bazel
sudo apt-get -y update && sudo apt-get -y install bazel
#Upgrade bazel
sudo apt-get -y upgrade bazel
echo "bazel installed"
	
echo "installing swig"
#Install swig
sudo apt-get -y install swig
echo "install protocol buffers"
#Install freeze package
sudo -H pip freeze | grep protobuf
#Install protobuf package
sudo -H pip install -U protobuf==3.2
echo "install mock"
#Install mock package
sudo -H pip install mock
echo "install asciitree"
#Install asciitree package
sudo -H pip install asciitree
echo "install numpy"
#Install numpy package
sudo -H pip install numpy
echo "install pygraphviz"
#Install graphviz
sudo apt-get install -y graphviz-dev
#Install pygraphviz package
sudo -H pip install pygraphviz --install-option="--include-path=/usr/include/graphviz" --install-option="--library-path=/usr/lib/graphviz/"

#Install and update extra packages
sudo apt-get install -y file
sudo apt-get install -y graphviz
sudo apt-get install -y libcurl3
sudo apt-get install -y libfreetype6
sudo apt-get install -y libgraphviz-dev
sudo apt-get install -y liblapack3
sudo apt-get install -y libopenblas-base
sudo apt-get install -y libpng12-0
sudo apt-get install -y libxft2
sudo apt-get install -y python-dev
sudo apt-get install -y python-mock
sudo apt-get install -y python-pip
sudo apt-get install -y python2.7
sudo apt-get install -y zlib1g-dev

#If git isn't installed install then git
if ! [ -x /usr/bin/git ]
then
	echo "Installing git"
	#Install git
	sudo apt-get install -y git

	#Check if git is succeeded
	if [ $? -ne 0 ]; then
		echo "Error 1: Something went wrong while installing git"
		exit 1
	fi

	echo "Git installed"
fi

#Change back to Desktop
cd ~/Desktop

#Clone the tenserflow model git if this  one doesn't exists yet
if [ -d ~/Desktop/models ]
then
	echo "Git clone already exist"
else
	echo "cloning the git https://github.com/tensorflow/models.git"
	#Clone the tenforflow model git
	git clone --recursive https://github.com/tensorflow/models.git

	#Check if the git is succeeded
	if [ \( $? -ne 0 \) -o \( $? -ne 128 \) ]; then
		echo "Error 2: Something went wrong while cloning the git"
		exit 2
	fi
fi

#Change the directory to the tensorflow directory for making ready to configuration
cd models/syntaxnet/tensorflow

echo "build syntaxnet"
#Execute the configure script and replay on all option 'Yes'
yes '' | sudo ./configure

#Check if the model is correctly configured
if [ $? -ne 0 ]; then
	echo "Error 3: Something went wrong while configuring the model"
	exit 3
fi

#Change the direcoty to the directory above for testing the model
cd ..
#Compile and test the tensorflow model that you wanne create
sudo bazel test ... --test_verbose_timeout_warnings

#Check if the model is correct compiled and if all tests suceeded 
if ! [ $? = 0 ]
then
	echo "Error 4: Please resolve previous issues"
	exit 4
fi

echo "creating the pkg"
#Remove the tmp package file if that file already exists
sudo rm -rf /tmp/syntaxnet_pkg
#Make new package folder for making the model package
sudo mkdir /tmp/syntaxnet_pkg

#Check if there accure anny error while making the new directory
if [ $? -ne 0 ]; then
	echo "Error 5: Something went wrong while creating directory /tmp/syntaxnet_pkg"
	exit 5
fi

#Builded model get transfered to a package
sudo bazel-bin/dragnn/tools/build_pip_package --output-dir=/tmp/syntaxnet_pkg
#Show the version
version=`sudo ls /tmp/syntaxnet_pkg/ | head -n 1`
sudo -H pip install /tmp/syntaxnet_pkg/$version