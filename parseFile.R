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


xmlToChart <- function(path){
	fileData <- xmlTreeParse(path)
	fileXML <- xmlToList(fileData)

	fileChart <- fileXML$chart_data[-1,]
	colnames(fileChart)<-c('date','caloriesBurned')
	rownames(fileChart)<-c()
	df<-data.frame(fileChart)
	df$caloriesBurned <- as.numeric(df$caloriesBurned)

	df
}

dataFiles <- dir('data')
xmlFiles<-dataFiles[grep('xml',dataFiles)]

chartList<- list()
for(i in 1:length(xmlFiles)){
	chartList[[i]] <- xmlToChart(paste0('data/',xmlFiles[i]))
}
merge(chartList)


caloriesBurned <- xmlToChart("data/caloriesBurned90.xml")
carbs90 <- xmlToChart("data/carbs90.xml")
head(caloriesBurned)
head(carbs90)

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

