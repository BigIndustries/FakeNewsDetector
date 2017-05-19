# !/bin/bash
# This script parserTikaAndNutch can be used for downloading one or multiple url's at onces and search and get the content from the requested website('s)
# Written by Jorick Triempont (jorickjt) & Jirry Haerinck (JirryH) commissioned by Big Industries - Big Data Consulting

#Variables
countCPU=`grep -c ^processor /proc/cpuinfo`
executingPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
outputDir=$2
inputDir=$1
index=-1

echo "CPU's: $countCPU"

#Check if first argument is given
if [[ -z $1 ]]
then
	echo "Exit -1: please give a input directory"
	exit -1
else 
	#Check if the path ends with '/'
	if [[ "$inputDir" == *"/" ]]
	then
		#Remove the '/' out of the path
		inputDir=${inputDir:: -1}
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

#Remove the output directory if it already exists
rm -rf $outputDir
#Make new Output directory
mkdir -p $outputDir/Files/

#Get all te file names from the input directory
for dir in `ls $inputDir`
do
    #Change the directory one level deeper
    cd $inputDir/$dir 
    #Get al the files in the directory
    for file in `ls`
    do
        echo "$dir/$file"
	#Read the file
        while IFS='' read -r line || [[ -n "$line" ]]
        do
	    #Check if the line that is readed in contains 'Reco'
            if [[ $line == *"Recno::"* ]] 
                then
		#Raise the index by 1
                let index+=1
            fi
	    #Check if the index isn't -1 (meaning that there where articels found"
            if [ $index -ne -1 ]
            then  
		#Read the line from the document to other document so the big file get splitted in multiple files  
                echo $line >> $outputDir/Files/fileno${index}
            fi
        done < "$file"
    done    
done

#Make background script executable
chmod +x $executingPath/parserTikaBackground.sh
#Change the directory to the output directory
#Where the files stand that just got splitted by articel
cd $outputDir/Files
#Make the output folder for the finished files
mkdir -p $outputDir/Output
processesArray=("")
#Get the files splitted files from the outputfolder
fileArray=( $(find $outputDir/Files -type f) )
echo ${#fileArray[*]} "artikels found"
#PID array of started background processes for Tika
processesList=()
for file in ${fileArray[@]}; do
	#Start Tika script in the background
	$executingPath/parserTikaBackground.sh "$file" "$outputDir/Output" &
	#Save the PID in the arraylist
	processesList+=($!)
	
	#Check if we reached maximum processes
	if [[ ${#processesList[@]} -ge $countCPU ]]; then
		echo ${processesList[*]}
		echo "Waiting"
		#Wait till all processes are finished
		wait ${processesList[*]}
		echo "Waiting is done"
		#Reset processList
		processesList=()
	fi
done

#Check if the file array is smaller then the count of cpu's
if [[ ${#processesList[@]} -ne 0 ]]; then
	echo ${processesList[*]}
	echo "Waiting"
	#Wait till all processes are finished
	wait ${processesList[*]}
	echo "Waiting is done"
	#Reset processList
	processesList=()
fi

echo "done"

exit 0
