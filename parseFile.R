# init
setwd("~/Documents/DaSH")
library(XML)
library(magrittr)

## parse calorie data
# load XML
calorieData <- xmlParse("calories90.xml")
calorieXML <- xmlToList(calorieData)

# extract date
dateCalories <- calorieXML[["chart_data"]][[1]] %>%
        unlist(., use.names = FALSE)

# extract calories
calories <- calorieXML[["chart_data"]][[2]] %>%
        unlist(., use.names = FALSE) %>%
        .[-1] %>%
        as.numeric(.)

# create data frame
caloriesDF <- cbind(dateCalories, calories)

# parse calories burned data
caloriesBurnedData <- xmlTreeParse("caloriesBurned90.xml")
caloriesBurnedXML <- xmlToList(caloriesBurnedData)
dateCaloriesBurned <- caloriesBurnedXML[['chart_data']][[1]]
dateCaloriesBurned <- unlist(dateCaloriesBurned, use.names = FALSE)
caloriesBurned <- caloriesBurnedXML[['chart_data']][[2]]
caloriesBurned <- unlist(caloriesBurned, use.names = FALSE)
caloriesBurned <- as.numeric(caloriesBurned[-1])
caloriesBurnedDF <- cbind(dateCaloriesBurned, caloriesBurned)

# parse weight data
weightData <- xmlParse("progress90.xml")
weightsXML <- xmlToList(weightData)
date <- weightsXML[[5]][[1]]
date <- unlist(date, use.names = FALSE)
weights <- weightsXML[[5]][[2]]
weights <- unlist(weights, use.names = FALSE)
weights <- as.numeric(weights[2:91])
weightDF <- cbind(date, weights)

