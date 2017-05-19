#!/bin/bash
# This script will download tika, extract tika and install tika.
# It will loop the directory and parse every file in it to an standarized manner
# This script will look if Tika is installed on location: executed path ./tika-1.14
# Written by Jorick Triempont (jorickjt) & Jirry Haerinck (JirryH) commissioned by Big Industries - Big Data Consulting

version="1.14"
tikaName=tika-$version
tikaPlace="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #Installation path
tikaLocation=$tikaPlace/$tikaName/
tikaUrl="http://apache.belnet.be/tika/tika-1.14-src.zip"
tikaFilename="tika-1.14-src.zip"

#Check if Tika is installed
if ! [ -d $tikaLocation ]
then
	echo "Tika doesn't exist on location $tikaLocation. It will be installed now on this location."
	
	#Check if zip package already exists or not
	if [ -d $tikaPlace/$tikaFilename ]; then
		echo "Zip file already exists"
	else
		echo "Downloading tika file"
		#Download the tika package
		sudo wget $tikaUrl -P $tikaPlace
	fi
	
	echo "installing unzip"
	#Install unzip so you can unzip the Tika package
	sudo apt-get -y install unzip &> /dev/null
	echo "unzip tika file"
	#Unzip the package to the place that you wanne have
	unzip -o $tikaPlace/$tikaFilename -d $tikaPlace
	echo "remove zip file"
	#Remove the zip file
	sudo rm -rf $tikaPlace/$tikaFilename	
fi
echo "Installing/upgrading maven"
#Install maven for compiling the Tike package
sudo apt-get -y install maven

#Change the directory to the correct directory for compiling
cd $tikaPlace/$tikaName/tika-app/

#Chck if the target file already exists
if ! [ -x ./target ]
then
	echo "Install tika (maven)"
	#Compile the Tika package and install the target
	mvn install #&> /dev/null
fi
