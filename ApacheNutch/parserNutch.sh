# !/bin/bash
# This script will scrape a website / set of websites and output it to an txtfile
SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#depth is how manny sub links you wanne get
depth=1
#outputFolder is the folder where the processed files get saved
outputFolder=~/Desktop
#pathNutch is the location where Nutch is installed. If Nutch is't installed is the location empty
pathNutch=$(find ~ -name "apache-nutch*" -type d 2>&1 | grep -v 'Permission denied' | tail -n1)

#Check if Nutch is installed
if ! [ -d "$pathNutch" ]
then
	echo "Exit 4: Nutch isn't installed! Please install Nutch before running this script."	
	exit 4
fi

#Check input
if [ -z $1 ]
then
        echo "exit -1: please give a file or html"
        exit -1
else
        if [ -f $1 ]
        then
                isFile="true"
                isHtml="false"
        else
                curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." > /dev/null
                if ! [ $? -eq 0 ]
                then
                        echo "Exit 1: not an url"
                        exit 1
                else
                        isHtml="true"
                        isFile="false"
                fi
        fi
fi

#Check output
if [ -z $2 ]
then
	echo "exit -1: please give a output "
	exit -1
else
	outputFolder=$2
	
	if [[ "$outputFolder" == *"/" ]]
	then
		outputFolder=${outputFolder:: -1}
	fi

	rm -rf $outputFolder
	mkdir -p $outputFolder
fi
echo "OUTPUT: $outputFolder"

#Check depth
if [ -z $3 ]
then
	echo "exit -1: please give a depth"
	exit -1
else
	depth=$3

	if ! [[ "$depth" =~ ^[0-9]+$ ]]
	then
		echo "dept only can be a number"
		exit -1
	fi
fi

#Change directory back to excecuting path
cd $SOURCE
#Remove url folder if that one already exists
rm -rf urls
#Create new folder for the url(s)
mkdir urls
#Change directory to the url folder
cd $SOURCE/urls

#If the input is a file
if [ $isFile == "true" ]
then
        echo "seed file kopiëren"
	#Copy the file to the seed file
        cp -R $1 seed.txt
fi

#If the input is a URL
if [ $isHtml == "true" ]
then
        echo "seed html invoegen"
	#Copy the URL to the seed file
        echo $1 > seed.txt
fi

#crawl
cd $pathNutch
echo "Crawling"
#Crawl the URL's to the output (crawl) folder
bin/crawl $SOURCE/urls/seed.txt $outputFolder/Crawl $depth

#Turn into textfile
echo "Exporting"
#Remove the folder if it exists
rm -rf $outputFolder/CrawlOutput
#Create the crawl output folder for the text files
mkdir $outputFolder/CrawlOutput
#Go through all the files that got Crawled
for m in `ls $outputFolder/Crawl/segments/`
do
    #Construct all the files to readable text files in the output (CrawlOutput) folder
    bin/nutch readseg -dump $outputFolder/Crawl/segments/$m $outputFolder/CrawlOutput/$m -nofetch -nogenerate -noparse
done
