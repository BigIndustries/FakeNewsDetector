# FakeNewsDetector

Fake News Detector is a project on behalf of Big industries. This project uses following technologies: Apache Tika, Apache Nutch, Apache TensorSpark (Tensorflow + Spark) and Syntaxnet. Through the combination of those technologies are we trying to detect if a provided news article (URL)  is fake news, real news or no news.

## Installation

1. Give the setup.sh the rights for being executed.
2. Execute setup.sh
3. Select the technologies that you wanne have installed for you.
4. You're ready to use those technologies now.

## Get started

If you want to analyse a news article you have found online then these are the steps you need to do.
Every technology in this git has been developed as if it can be used on his own. But when you follow our directions, it will become a coherent project. 

If we say in these guidelines how to install something then you are free to choose how. This can be by running the setup script or the install scripts in each directory.

1. Apache Nutch installation
2. Apache Nutch parser
3. Apache Tika installation
4. Apache Nutch with Apache Tika (parserTikaAndNutch.sh)
5. Tensorflow installation
6. Syntaxnet installation
7. Syntaxnet (syntaxnetParser.sh)

Now you will have a csv file than you can use to train a Machine Learning Model. 

### Steps still under construction
1. Creating the model
2. Creating the sample script that is going to use the model
3. Creating a Tensorflow server
4. Optimise the Tensorflow parameters
5. Deploy the model to Tensorflow serving
6. Deploy model with TensorSpark

For some of these we have given you a basic start (installationscript,...)


*Written by Jorick Triempont ([jorickjt](https://github.com/jorickjt )) & Jirry Haerinck ([JirryH](https://github.com/jirryh )) commissioned by [Big Industries - Big Data Consulting](http://www.bigindustries.be/)*
