#!/bin/bash
# This script will install Nutch, Nutch can be used for scraping websites
# Source from script
# Written by Jorick Triempont (jorickjt) & Jirry Haerinck (JirryH) commissioned by Big Industries - Big Data Consulting

#Get directory where the script get runned from
SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Check if wget is installed
if ! [ -x /usr/bin/wget ]
then
		#Install wget
        sudo apt-get install wget > /dev/null
fi

#Check if nutch is already installed
if ! [ -x $SOURCE/apache-nutch-1.13 ]
then
	#Remove package if package already should exists
	rm -rf apache-nutch-1.13-bin.tar.gz
	echo "Downloading Nutch"
	#Download Nutch package
	wget 'http://apache.cu.be/nutch/1.13/apache-nutch-1.13-bin.tar.gz' >  /dev/null
	#Unzip Nutch
	echo "Installing Nutch"
	tar xf apache-nutch-1.13-bin.tar.gz > /dev/null
	#Remove nutch package
	rm -f apache-nutch-1.13-bin.tar.gz
else
	#Nutch is already installed
	echo "Nutch in already installed"
fi
