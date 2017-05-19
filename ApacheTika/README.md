# Apache Tika stand-alone

This part will consist of the stand-alone version of Apache Tika.
This part of the git will consist out of 2 bash scripts, that will be explained later in this file.

## Installation Tika (installationTika.sh)

Call this script with: ./installationTika.sh

This script will download Apache Tika version 1.14 to a location.
It will first check if Tika hasn't already been installed on this location.
If this is not then it will download, unzip and remove (for storage reasons) the src.zip file.

Afterwards, or when Tika is already installed, it will install maven.  **Make sure java is installed ** 
If Maven is already installed then it will update the version you have.

When this is done, this script will install Tika by using maven to build the target directory.
When this file already exist it doesn't do anything.


This script has a few variables you can change:
1. version: The version number of Tika
2. tikaname: The name for tika (tika as string and the version from 1): tika-$version
3. tikaplace: The location you want tika to install to
4. tikalocation: The full path of Tika: tikaplace/tikaname
5. tikaurl: The location of the file you have to download
6. tikafilename: The name of the file


## Parse your text (parserTika.sh)

Call this script with: ./parserTika.sh targetdir 

This script will install Tika (like described above) and is going to parse the websites. In this script we expect you to **download the webpages into an input directory** before you begin.

It will first check if the parameter you gave is not empty or not a directory.
It then will check if you already have installed Tika (see installation Tika).

It is going to check if you have an output map in the targetdir you provided. If this is not, it will make one.
If you do not have an input file, this script will stop and ask you to make one.
Otherwise it will run the tika command twice. Once it will use -T, this stands for  Output plain text content (main content only), and -r, this stands for XML and XHTML outputs, adds newlines and whitespace, for better readability.
The other one is going to use -m, this will output only metadata.

To see all the options, go to [Apache getting started](https://tika.apache.org/1.5/gettingstarted.html)

This script will add the two options into one file.

There are 2 added variables:
7. inputdir: The location of the directory where the downloaded html pages are located
8. outputdir: The location of the directory to save the output of this file to


*Written by Jorick Triempont ([jorickjt](https://github.com/jorickjt )) & Jirry Haerinck ([JirryH](https://github.com/jirryh )) commissioned by [Big Industries - Big Data Consulting](http://www.bigindustries.be/)*

