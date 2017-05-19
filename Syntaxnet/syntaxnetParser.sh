# !/bin/bash
#This script will get the combined nutch and tika script and run it through syntaxnet/parsey mcparseface

#Read the file
foundcontent="start"
foundmeta="start"
content=''
teller=1
contentToConvert=""
metaToConvert=""
newsType=$2
#touch ~/Desktop/TestData.csv
for file in `ls $1/*/*`
do
	echo $file
	let teller+=1
	while IFS='' read -r line || [[ -n "$line" ]]
	do
		if [ $foundcontent == "found" ]
		then
			if [ "$line" == "</content>" ]
			then
				foundcontent="end"
			else
				line="${line//.}"
				line="${line//;}"
				cd ~/Desktop/models/syntaxnet
				newLine=`echo $line | syntaxnet/demo.sh`
				contentToConvert="${lineToConvert} $newLine"
				cd ~/Desktop	
			fi
		fi

		if [ $foundmeta == "found" ]
		then
			if [ "$line" == "</meta>" ]
			then
				foundcontent="end"
			else
				line="${line//;}"
				newLine=`echo $line`
				metaToConvert="${metaToConvert} $newLine"
				cd ~/Desktop	
			fi
		fi
		if [ "$foundcontent" == "start" ]
		then
			if [ "$line" == "<content>" ]
			then
				foundcontent="found"
			fi
		fi
		if [ "$foundmeta" == "start" ]
		then
			if [ "$line" == "<meta>" ]
			then
				foundmeta="found"
			fi
		fi
		

	done < $file
	foundcontent="start"
	foundmeta="start"
	contentToConvert="${contentToConvert};"
	metaToConvert="${metaToConvert};"
	echo -n $contentToConvert >> ~/Desktop/TestData.csv
	echo -n $metaToConvert >> ~/Desktop/TestData.csv
	echo "${newsType};" >> ~/Desktop/TestData.csv
	contentToConvert=""
	metaToConvert=""
done