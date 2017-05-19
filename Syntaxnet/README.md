# Syntaxnet stand-alone

This part will consist of the stand-alone version of Syntaxnet model.
This part of the git will consist out of 1 bash scripts, that will be explained later in this file.

## Installation Synaxnet (installationSyntaxnet.sh)

Call this script with: ./installationSyntaxnet.sh

## Syntaxnet with Apache Nutch/Tika
To use this Syntaxnet model with our previous Apache Nutch And Apache Tika you can use this syntaxnetParser.sh script.
This script wants you to first run the parserTikaAndNutch.sh script.

you can run this script by calling: ./parserTikaAndNutch.sh TikaAndNutchDir NewsType

With NewsType you can say if the news site you provide is
Fake News (-1), No News (0) or Real News (1)

*Written by Jorick Triempont ([jorickjt](https://github.com/jorickjt )) & Jirry Haerinck ([JirryH](https://github.com/jirryh )) commissioned by [Big Industries - Big Data Consulting](http://www.bigindustries.be/)*

