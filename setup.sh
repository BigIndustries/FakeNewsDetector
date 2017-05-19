#!/bin/bash
# Master script that installes all the technologies that we use for our project
# Written by Jorick Triempont (jorickjt) & Jirry Haerinck (JirryH) commissioned by Big Industries - Big Data Consulting

#All the bash filenames
fileArray=("Tensorflow/installationTensorflow.sh" "Syntaxnet/installationSyntaxnet.sh" "ApacheNutch/installationNutch.sh" "ApacheTika/installationTika.sh")
#Path of script startup
SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Clear screen 
clear
#Check if scrip is started as root
if [[ $EUID -ne 0 ]]
then
	echo "Exit 1: You must run this script as root"	
	exit 1
fi

#Go through all files in the array
for indexScript in ${fileArray[@]}
do
	echo $SOURCE/$indexScript
	#Add executing permissing on file
	chmod +x $SOURCE/$indexScript
	#If file doesn't exist
	if ! [ -f $SOURCE/$indexScript ]
	then
		echo "Exit 2: Script $SOURCE/$indexScript isn't found!"
		exit 2
	fi
done

echo "Check if dialog is installed"
#Check if dialog is already installed
if [ -x /usr/bin/dialog ]
then
	echo ! "Intalling dialog"
	#Install dialog
	sudo apt-get -y install dialog
else
	echo "Check if dialog can be updated"
	#Upgrade dialog
	sudo apt-get -y upgrade dialog
fi

#Check if dialog is good installed
if [ $? -ne "0" ]
then
	echo "Exit 3: something went wrong while installing/upgrading dialog"
	exit 3
else
	echo "Check dialog is complete"
fi

#Parameters for Main menu GUI
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Master installation script"
TITLE="Installation script"
MENU="Choose one or more of the following options:"

#Options to show, "index" "name" "selected"
OPTIONS=(1 "Tensorflow" on \
         2 "Syntaxnet" on \
         3 "Nutch" on \
	 4 "Tika" on)
#Show dialog and catch output
CHOICES=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --checklist "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

#Clear screen
clear
clear

#Go through all the choices that where selected
for indexChoice in ${CHOICES[@]}
do
	#Jump to the correct index number
	case $indexChoice in
		1)	clear
			cd $SOURCE
			echo "You chose Option 1 (install Tensorflow)"
			echo $SOURCE/${fileArray[0]}
			#Parameters for Python selection GUI
			BACKTITLE="installation Tensorflow"
			TITLE="Python version"
			MENU="Choose one or of the following options:"
			#Options to show, "index" "name" "selected"
			OPTIONS=(1 "Python2.7" on \
				 2 "Python3.5" off )
			#Show dialog and catch the output
			CHOICE=$(dialog --clear \
		        --backtitle "$BACKTITLE" \
		        --title "$TITLE" \
		        --radiolist "$MENU" \
		        $HEIGHT $WIDTH $CHOICE_HEIGHT \
		        "${OPTIONS[@]}" \
		        2>&1 >/dev/tty)
			#Change the index to the python version number
			case $CHOICE in
				1) PYT="2.7" ;;
				2) PYT="3.5" ;;
			esac
			#Parameters for Version selection GUI
			TITLE="Support version"
			MENU="Choose one or of the following options:"
			#Options to show, "index" "name" "selected"
			OPTIONS=(1 "CPU" on \
				 2 "GPU" off )
			#Show dialog and catch the output
			CHOICE=$(dialog --clear \
		        --backtitle "$BACKTITLE" \
		        --title "$TITLE" \
		        --radiolist "$MENU" \
		        $HEIGHT $WIDTH $CHOICE_HEIGHT \
		        "${OPTIONS[@]}" \
		        2>&1 >/dev/tty)
			#Change the index to the support version name
			case $CHOICE in
				1) SUP="CPU" ;;
				2) SUP="GPU" ;;
			esac
			clear
			#execute the script with the correct parameters and catch the message from the script
			message=$($SOURCE/${fileArray[0]} -p "$PYT" -s "$SUP")
			#Catch the error code from the script
			exitCode=$?
			#Show message that got caught from the script
			echo -n $message
			#Check if the exit code is not 0
			if ! [ $exitCode -eq 0 ]
			 then
				echo -e "\033[0;31m Something went wrong while installing tensorflow (code: $exitCode)"
				exit 1
			else
				echo "Tensorflow succesfully installed"
				sleep 3		
			fi
		    	;;

		2)	clear
			cd $SOURCE
		    	echo "You chose Option 2 (install Syntaxnet)"
			sleep 1; clear
			#Parameters for command sectection GUI
			BACKTITLE="installation Syntaxnet"
			TITLE="Show commands"
			MENU="Choose one or of the following options:"
			OPTIONS=(1 "off" on \
				 2 "on" off )
			#Show the dialog and catch the output
			CHOICE=$(dialog --clear \
		        --backtitle "$BACKTITLE" \
		        --title "$TITLE" \
		        --radiolist "$MENU" \
		        $HEIGHT $WIDTH $CHOICE_HEIGHT \
		        "${OPTIONS[@]}" \
		        2>&1 >/dev/tty)
			clear
			#Run the script with the correct parameters
			case $CHOICE in
				#Run the script and catch the output message
				1) message=$( sudo "`$SOURCE/${fileArray[1]}`"  ) ;;
				2) message=$( sudo "`$SOURCE/${fileArray[1]} \"-s\"`"  );;
			esac
			#Get the exit code from the script
			exitCode=$?
			echo $message
			#If the exit code is not equal to 0 exit the script
			if ! [ $exitCode -eq 0 ]
			 then
				echo -e "\033[0;31m Something went wrong while installing syntaxnet (code: $exitCode)"
				exit 1
			else
				echo "Syntaxnet succesfully installed"
				sleep 3		
			fi
		    	;;

		3)	clear
			cd $SOURCE
		    	echo "You chose Option 3 (install Nutch)"
			#Run the script and catch the output message
			message=$( sudo sh "$SOURCE/${fileArray[2]}" )
			#Get the exit code from the script
			exitCode=$?
			echo $message
			#If the exit code doesn't equal to 0 
			if ! [ $exitCode -eq 0 ]
			 then
				echo -e "\033[0;31m Something went wrong while installing Nutch (code: $exitCode)"
				exit 1
			else
				echo "Nutch succesfully installed"
				sleep 3		
			fi
		    	;;

		4)	clear
			cd $SOURCE
		    	echo "You chose Option 4 (install Tika)"
			#Run the script and catch the output message
			message=$( sudo sh "$SOURCE/${fileArray[3]}" )
			#Get the exit code from the script
			exitCode=$?
			echo $message
			#If the exit code doesn't equal to 0 
			if ! [ $exitCode -eq 0 ]
			 then
				echo -e "\033[0;31m Something went wrong while installing Tika (code: $exitCode)"
				exit 1
			else
				echo "Tika succesfully installed"
				sleep 3		
			fi
		    	;;
	esac
done