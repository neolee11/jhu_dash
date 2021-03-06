#A script for building & updating the R package

# rm(list=ls())

library('roxygen2')
library('devtools')

#Create the package:
packagePath <- 'scrappal-package'
#create(scrappal) #only do this once 
# use_travis(packagePath)
# foodUnits<-read.csv('units.csv', stringsAsFactors=FALSE)
# devtools::use_data(foodUnits,foodUnits,pkg=packagePath)

## Create the documentation fresh
document(packagePath)
check_doc(packagePath)
## Install the package
install(packagePath)
 
# install_github('neolee11/jhu_dash/scrappal-package')

## Check the help
library(scrappal)
help(package='scrappal')

runScrappalApp()
#OR:
runApp(paste0(packagePath,'/inst/shiny_app'))


 