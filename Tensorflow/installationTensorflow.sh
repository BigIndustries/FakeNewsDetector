#!/bin/bash
# Install tensorflow (we use python2.7 because we want to use syntaxnet (uncompatible with higher version) with it, 
# Written by Jorick Triempont (jorickjt) & Jirry Haerinck (JirryH) commissioned by Big Industries - Big Data Consulting

#Default python version stands on 2.7
pythonVersion="2.7"
#Default support version stands on CPU
supportVersion="CPU"

#Check for flags
while getopts ":p:s:" opt; do
	#Check if the argument of the flag doesn't start with a "-" so it can't be other flag as argument
	if [[ $OPTARG == "-"* ]]
	then
		echo "Option -$opt can't have requirement $OPTARG"
		exit 1
	fi
	
  	case $opt in
	#p flag: changing the python version that you want to  use
    	p)
      		echo "-p was triggered, Parameter: $OPTARG" >&2
      		pythonVersion=$OPTARG
      		;;
	#s flag: change the support version that you want to  use (CPU/GPU)
    	s)
      		echo "-s was triggered, Parameter: $OPTARG" >&2
      		supportVersion=$OPTARG
      		;;
	#? flag: dissable the ? flag for the arguments
    	\?)
      		echo "Invalid option: -$OPTARG" >&2
      		exit 1
      		;;
	#: flag: check if the flag has an argument
    	:)
      		echo "Option -$OPTARG requires an argument." >&2
      		exit 1
      		;;
  	esac
done

#Check if the pythonversion is supported
if [[ $pythonVersion = *"2."* ]]
then
	echo "Version 2.x selected"
	pythonVersion="2.7"
elif [[ $pythonVersion = *"3."* ]]
then
	echo "Version 3.x selected"
	pythonVersion="3.5"
else
	echo "Python-version: $pythonVersion isn't available!"
	exit 1
fi

#Check if supportversion is CPU or GPU
if [[ $supportVersion = *"C"* || $supportVersion = *"c"* ]]; then
	echo "Version support CPU selected"
	supportVersion="CPU"
elif [[ $supportVersion = *"G"* || $supportVersion = *"g"* ]]; then
	echo "Version support GPU selected"
	supportVersion="GPU"
else
	echo "Version-support: $supportVersion: isn't available!"
	exit 1
fi

echo "Python:"$pythonVersion
echo "Support Version:"$supportVersion

#python2.7 section start
#If python2.7 is selected
if [ $pythonVersion = "2.7" ]
then
	echo "Check python = 2.7" 
	#Check if python2.7 already is installed
	python2.7 -V &> /dev/null

	#If python2.7 isn't installed
	if ! [ $? -eq 0 ]
	then
		echo "installing python2.7"
		#Install python2.7
		sudo apt-get -y install python2.7

		#Check if python2.7 is good installed
		if [ $? -ne 0 ]; then
			echo "Exit 2: Something went wrong while installing python2.7!"
			exit 2
		fi
		echo "python2.7 installed"
	fi

	echo "check if pip install is installed"
	
	#Check if pip is installed
	if ! [ -x /usr/local/bin/pip ]
	then
		echo "installing pip"
		#Install pip and the extra packages
		sudo apt-get -y install python-pip python-dev build-essential

		#Check if pip installation is suceeded
		if [ $? -ne 0 ]; then
			echo "Exit 2: Something went wrong while installing pip!"
			exit 2
		fi

		#Upgrade pip
		sudo pip install --upgrade pip
	fi

	echo "Pip is installed"

	#Check if CPU or GPU is selecter
	if [[ $support == "CPU" ]]; then
		#Install tensorflow package CPU support
		sudo pip install tensorflow      # Python 2.7; CPU support (no GPU support)
	elif [[ $support == "GPU" ]]; then
		#Install tensorflow package GPU support
		sudo pip install tensorflow-gpu  # Python 2.7;  GPU support
	fi
fi
#python2.7 section end

#python3.5 section start
if [ $pythonVersion = "3.5" ]
then
	echo "Check python = 3.5"
	#Check if python3.5 already is installed
	python3.5 -V &> /dev/null

	#If python3.5 isn't installed
	if ! [ $? = 0 ]
	then
		echo "installing python3.5"
		#Install python3.5
		sudo apt-get -y install python3.5
		
		#Check if python2.7 is good installed
		if [ $? -ne 0 ]; then
			echo "Exit 2: Something went wrong while installing python3.5!"
			exit 2
		fi
		echo "python3.5 installed"
	fi

	echo "check if pip3 install is installed"

	#Check if pip is installed
	if ! [ -x /usr/local/bin/pip3 ]
	then
		echo "installing pip3"
		#Install pip3 and the extra packages
		sudo apt-get -y install python3-pip python-dev build-essential

		#Check if pip3 installation is suceeded
		if [ $? -ne 0 ]; then
			echo "Exit 2: Something went wrong while installing pip3!"
			exit 2
		fi

		#Upgrade pip3
		sudo pip3 install --upgrade pip3
	fi

	echo "Pip3 is installed"

	#Check if CPU or GPU is selecter
	if [[ $support = "CPU" ]]; then
		#Install tensorflow package CPU support
		sudo pip3 install tensorflow     # Python 3.n; CPU support (no GPU support)
	elif [[ $support = "GPU" ]]; then
		#Install tensorflow package GPU support
		sudo pip3 install tensorflow-gpu # Python 3.n; GPU support 
	fi
	
fi
#python3.5 section end	
