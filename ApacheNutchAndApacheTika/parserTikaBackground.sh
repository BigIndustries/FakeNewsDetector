#!/bin/bash
# Get a file and process this with Tika and saves the output
# Written by Jorick Triempont (jorickjt) & Jirry Haerinck (JirryH) commissioned by Big Industries - Big Data Consulting

#Variables
inputFile=$1
outputDir=$2
executingPath=$(find ~ -name "tika-1.14" -type d 2>&1 | grep -v 'Permission denied' | tail -n1)

#Check if first argument is given
if [[ -z $1 ]]
then
	echo "Exit -1: please give a input directory"
	exit -1
else 
	#Check if the path ends with '/'
	if [[ "$inputFile" == *"/" ]]
	then
		#Remove the '/' out of the path
		inputFile=${inputFile:: -1}
	fi
fi

#Check if second argument is given
if [[ -z $2 ]]
then
	echo "Exit -1: please give a output directory"
	exit -1
else 
	#Check if the path ends with '/'
	if [[ "$outputDir" == *"/" ]]
	then
		#Remove the '/' out of the path
		outputDir=${outputDir:: -1}
	fi
fi

fileName=$(basename "$inputFile")
outputDir="$outputDir/$fileName"

echo "$fileName"
urlToKeep="init"

#Read te file in line by line
while IFS='' read -r line || [[ -n "$line" ]]
do
	#Check if the line contains 'URL'
        if [[ $line == *"URL"*  ]]
        then
	    #Check the tag of the articel (default is this in begin of the articel 'init')
            if [ "$urlToKeep" == "init" ]
            then    
		#Get the URL                     
                url=`echo $line | cut -d ' ' -f 2`
                echo $url
		#Add the content tag in the output file
                echo "<content>" > $outputDir
		#Use Tika for getting the main content in plain text without anny HTML elements and write this in the output file
                java -jar $executingPath/tika-app/target/tika-app-1.14.jar -T -r $url >> $outputDir
		#Close the content tag in the output file
                echo "</content>" >> $outputDir
		#Add the meta tag in the output file
                echo "<meta>" >> $outputDir
		#Use Tika for getting the meta of the URL and write this in the output file
                java -jar $executingPath/tika-app/target/tika-app-1.14.jar -m $url >> $outputDir
		#Add outlink tag in the output file
                echo "<outlink>" >> $outputDir
		#Put the line that got readed in in the variable urlToKeep
                urlToKeep="$line"	
            fi
        fi

	#Check if the line that got readed in contains 'outlink'
        if [[ $line == *"outlink:"* ]]
        then
	    #Write the line away to the output file
            echo $line >> $outputDir
        fi  
done < $inputFile

    #Close the outlink tag in the output file
    echo "</outlink>" >> $outputDir
    #Close the meta tag in the output file
    echo "</meta>" >> $outputDir
    urlToKeep="init"

