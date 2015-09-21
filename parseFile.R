# init
# setwd("~/Documents/DaSH")
library(XML)
library(magrittr)

## parse calorie data
# load XML
calorieData <- xmlParse("data/calories90.xml")
calorieXML <- xmlToList(calorieData)

# extract date
dateCalories <- calorieXML[["chart_data"]][[1]] %>%
        unlist(., use.names = FALSE)

# extract calories
calories <- calorieXML[["chart_data"]][[2]] %>%
        unlist(., use.names = FALSE) %>%
        .[-1] # remove row name

# create calories data frame
caloriesDF <- cbind(dateCalories, calories)


## parse calories burned data
# load XML
caloriesBurnedData <- xmlTreeParse("data/caloriesBurned90.xml")
caloriesBurnedXML <- xmlToList(caloriesBurnedData)

caloriesBurnedChart <- caloriesBurnedXML$chart_data[-1,]
colnames(caloriesBurnedChart)<-c('date','caloriesBurned')
rownames(caloriesBurnedChart)<-c()
caloriesBurnedDF<-data.frame(caloriesBurnedChart)
caloriesBurnedDF$caloriesBurned <- as.numeric(caloriesBurnedDF$caloriesBurned)


# create calories burned data frame
caloriesBurnedDF <- cbind(dateCaloriesBurned, caloriesBurned)


## parse weight data
# load XML
weightData <- xmlParse("progress90.xml")
weightXML <- xmlToList(weightData)

# extract date
dateWeight <- weightXML[["chart_data"]][[1]] %>%
        unlist(., use.names = FALSE)

# extract date
weight <- weightXML[["chart_data"]][[2]] %>%
        unlist(., use.names = FALSE) %>%
        .[-1] # remove row name

# create weight data frame
weightDF <- cbind(dateWeight, weight)

