# !/bin/bash
# This script will download tika, extract tika and install tika.
# It will loop the directory and parse every file in it to an standarized manner
# Written by Jorick Triempont (jorickjt) & Jirry Haerinck (JirryH) commissioned by Big Industries - Big Data Consulting

version="1.14"
tikaName=tika-$version
tikaLocation=$(find ~ -name "$tikaName" -type d 2>&1 | grep -v 'Permission denied' | tail -n1) #Search tika installation
inputDir=$1
outputDir=$2

#Check if the argument is a directory or not
if [ -z $1 ]
then
	echo "exit 3: please give target dir"
	exit 3
fi

#Check if argument is a directory
if ! [ -d $1 ]
then
	echo "Exit 1: The first parameter must be a directory"
	exit 1
fi

#Check if argument is a directory
if ! [[ $2 == *"/"* ]]
then
	echo "Exit 1: The second parameter must be a directory"
	exit 1
fi

echo "Input: $1"
echo "Output: $2"

#Check if tika is installed
if ! [ -d "$tikaLocation" ]
then
	echo "Exit 4: Tika isn't install please install Tika first before running this script."	
	exit 4
fi

#Check if directory exists and is executable 
if ! [ -x $outputDir ]
then
	#Create directory if it doesn't exists
	mkdir $outputDir
else
	#Remove directory so you hava a clean line
	rm -rf $outputDir
	#Create directory
	mkdir $outputDir
fi

#Change directory to the output folder
cd $outputDir

#Check if the inputDir exists
if ! [ -x $inputDir ]
then
	echo "please define an inputDirectory in your directory"
	echo "Exit 2: no inputfile (it should be $1 input)"
	exit 2
fi

#Search in the inputDir the files and replace space by "_"
find $inputDir/ -depth -name "* *" -execdir rename 's/ /_/g' "{}" \;

#Set counter on 0
counter=0

#Get al the files in the inputDirectory
for f in $(find $inputDir -type f 2>&1 | grep -v 'Permission denied')
do
	#add 1 by the counter
	let counter+=1
	echo $counter
	#create file
	touch testfile${counter}.txt
	#Open the content tag
	echo "<content>" > testfile${counter}.txt
	#Get the HTML content
	java -jar $tikaLocation/tika-app/target/tika-app-$version.jar -T -r $f >> testfile${counter}.txt
	#Close the content tag
	echo "</content>" >> testfile${counter}.txt
	#Open the meta tag
	echo "<meta>" >> testfile${counter}.txt
	#Get the meta file
	java -jar $tikaLocation/tika-app/target/tika-app-$version.jar -m $f >> testfile${counter}.txt
	#Close the meta tag
	echo "</meta>" >> testfile${counter}.txt
done