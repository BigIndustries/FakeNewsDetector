# Apache Nutch stand-alone

This part will consist of the stand-alone version of Apache Nutch. This part of the git will consist out of one bash script, that will be explained later in this file.

## Installation Nutch (installationNutch.sh)

call this script with *./installationNutch*

Then it will download Apache Nutch. This will first install wget. Notice that we are using apt-get.
After this it will download, extract and remove (for storage issues) the bin.tar.gz file.

## Parser Nutch (parserNutch.sh)
call this script with *./parserNutch.sh seed.txt output/Path 1* or  *./parserNutch.sh webpage outputPath 1*

It will first check if you have provided a file or a html page.
The file you need to provide consist of a list of html pages.

When you have provided a html page, it will add this to an seed.txt file (consisting only with that url).

Then it will crawl the seed file with an provided depth.

When this is done the script will parse the crawl data to an readable file.

This script has two variables
1. nutchName: The name of the crawlapp
2. depth: the depth of the crawling



*Written by Jorick Triempont ([jorickjt](https://github.com/jorickjt )) & Jirry Haerinck ([JirryH](https://github.com/jirryh )) commissioned by [Big Industries - Big Data Consulting](http://www.bigindustries.be/)*
