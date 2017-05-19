# Apache Nutch with Apache Tika

Apache Nutch uses Apache Tika standard as the parsing tool, but in our project this output wasn't the one we wanted to use.
Because Nutch does not let us choose the options to use Tika with, we made our own script.

## Prerequisite
1. Run the installationNutch.sh script
2. Run the installationTika.sh script

## Apache Nutch and Apache Tika (tikaAndNutch.sh)

This script will make a new directory to store his output. After that it will read for every directory in the output directory of installationNutch.sh every file in it.
It will make a file where the output of that file will be send to with, with the content of the file (without the xml from Nutch). 

After this it will check every file for the url and will make a file where it will call tika to parse this url.
Juset like we did at parserTika.sh .

After that we are going to add some metadata from Nutch to that file. 

### parserTikaBackground.sh
This script will call Tika in the background. This will enhance the speed of this process.

*Written by Jorick Triempont ([jorickjt](https://github.com/jorickjt )) & Jirry Haerinck ([JirryH](https://github.com/jirryh )) commissioned by [Big Industries - Big Data Consulting](http://www.bigindustries.be/)*
