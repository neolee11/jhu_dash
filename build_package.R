#A script for building & updating the R package


library('roxygen2')
library('devtools')

#Create the package:
packagePath <- 'scrappal-package'
#create(scrappal) #only do this once 
use_travis(packagePath) #Don't worry if throws error due to file already existing

## Create the documentation fresh
document(packagePath)
check_doc(packagePath)
## Install the package
install(packagePath)
 
## Check the help
library(scrappal)
help(package='scrappal')
 