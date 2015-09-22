

#' @title Scrape data from my fitness pal
#'
#' @param username for person of interest
#' @param fromDate date to start gathering R data. Should have class "Date"
#' @param toDate date to stop gathering R data. Should have class "Date"
#' @param includeDailyCal whether to include an additional (redundant) table showing the calories burned and consumed on each day.
#' @param verbose  whether to print progress 
#' @export
#' @import rvest dplyr
#' @return A list containing tables of: all exercises, all food items eaten, and (optionally) the calories burned and consumed on each day. In the food table, cholest and sodium are reported in mg. All other nutritional values (except calories) are reported in grams. 
#' @examples \dontrun{
#' username = 'funchords'
#' fromDate = as.Date('2015-08-01','%Y-%m-%d')
#' toDate =   as.Date('2015-08-10','%Y-%m-%d')
#' 
#' z<-scrappal(
#' 		username = username,
#' 		fromDate = fromDate,
#' 		toDate = toDate,
#'		includeDailyCal = TRUE
#' 		)
#'
#' ### Show food labels separately, because they're large
#' z$food[1:10,1]
#' ### preview everything but the label
#' z$food[,-1]
#'
#' z$exercise
#' z$dailyCal
#'
#'}
scrappal <- function(username='bcaffo', fromDate, toDate, includeDailyCal = FALSE, verbose=getOption('verbose')){



############
############
############
# Retrieve data

if(verbose) message('retrieving data from my fitness pal...')

session<-html_session(paste0('http://www.myfitnesspal.com/reports/printable_diary/',username))

form_blank <- html_form(html(session))[[1]]
form_filled <- set_values(form_blank,
	from = as.character(fromDate, format='%Y-%m-%d'),
  	to =   as.character(toDate,   format='%Y-%m-%d'))
form_output<-submit_form(session,form_filled)

if(verbose) message('reformatting data...')

tab<-html_table(form_output,header=TRUE) #gets tables

hOut<-html(form_output) #gets in html form
titles<-html_nodes(hOut,'#date , thead .first') %>%
	html_text()
# print(object.size(tab),units='Mb')

# xOut<-xmlTreeParse(form_output) #in xml form, not currently used.


#!!?? Do we need to "close" the `session` object? What do you think Daniel?






##########
##########
##########
# Get Dates & Table Labels

isFood<- unlist(lapply(tab, function(x) colnames(x)[1]=='Foods'))
isExercise<- unlist(lapply(tab, function(x) colnames(x)[1]=='Exercises'))
# all((isFood + isExercise) == 1) #workcheck


#Assign dates to all elements of `tab`
dates <- rep(as.Date('January 1, 0001',format='%B %d,%Y'),length(tab))

lastDate<-NA
counter<-0
for(i in 1:length(titles)){
	ti <- titles[i] 

	if(! ti %in%c('Foods','Exercises')){
		lastDate <- as.Date(ti, format = '%B %d,%Y')
		next
	}

	#if not a date, then it's a table
	counter <- counter + 1
	dates[counter] <- as.Date(lastDate)
}

#In-console summary of the tables we've retrieved
as.tbl(data.frame(dates,isFood,isExercise))



processTable <- function(x, typeName){
	dx <- dim(x)
	
	out<-data.frame()
	lastType<-NA
	counter<-0
	for(i in 1:nrow(x)){
		
		#skip totals columns, as these are redundant
		if(	grepl(x[i,1], 'TOTAL:',  fixed=TRUE) |
			grepl(x[i,1], 'TOTALS:', fixed=TRUE)) next 

		#Keep track of the most recent category header, but don't log it as a food or exercise item
		if(all(is.na(x[i,-1]))) { 
			lastType <- x[i,1]
			next
		}

		#if not a meal-type (or exercise-type), then it's a food item (or exercise activity),
		#so add it to our output data.frame
		counter <- counter + 1
		for(j in 1:ncol(x)){
			x_ij <- x[i,j]
			if(j>1){
				#for non-labels:
				# remove 'mg' and 'g' units. Also remove commas (from large numbers like 1,100)
				#!! Check !! can users enter items in something other than 'g' or 'mg'? Do they have a choice of units? If so, this could break our parser
				x_ij <- gsub('mg', '', x_ij, fixed=TRUE)
				x_ij <- gsub('g',  '', x_ij, fixed=TRUE)
				x_ij <- gsub(',',  '', x_ij, fixed=TRUE)
				x_ij <- as.numeric(x_ij)
			}
			out[counter,names(x)[j]] <- x_ij
		}
		out[counter,typeName] <- lastType
	}

	out
}



allFood<-data.frame()
for(i in 1:length(tab)){
	if(isExercise[i]) next
	thisFoodDay <- processTable(tab[[i]], typeName='meal')

	thisFoodDay$day <- dates[i]

	allFood <- rbind(allFood,thisFoodDay)
		#bind more efficiently?? (not urgent, already fast). Probably the issue is the within table parsing, not the the combining.
}

colnames(allFood) <- tolower(colnames(allFood))
allFood$username <- username

allFood <- as.tbl(allFood)
allFood[,-1]
allFood[,1]

unlist(lapply(allFood, class))

allExercise<-data.frame()
for(i in 1:length(tab)){
	if(isFood[i]) next
	thisExerciseDay <- processTable(tab[[i]], typeName='exercise_type')
	thisExerciseDay$day <- dates[i]

	allExercise <- rbind(allExercise,thisExerciseDay)
}
colnames(allExercise) <- tolower(colnames(allExercise))
colnames(allExercise)[which(colnames(allExercise)=='exercise_type')] <- 'exerciseType'
allExercise <- as.tbl(allExercise)

allExercise



dailyCal <- NULL
if(includeDailyCal){
	posCal <- group_by(allFood, day) %>%
	summarise(calories = sum(calories))
	negCal <- group_by(allExercise, day) %>%
	summarise(calories = sum(calories))

	dailyCal <- merge(posCal, negCal, by ='day', suffixes = c('Pos','Neg')) %>%
		as.tbl
	names(dailyCal)<-c('day','posCalories','negCalories')
	dailyCal <- mutate(dailyCal,netCalories = posCalories - negCalories) #what exactly are "fitbit adjustements"?? 
}


#How to identify common activities:
#1) concatenate all labels
#2) split into words
#3) table words
#4) use grep to find words in activity names
#Problem: will also return words like "the", "mph", "pace", etc. Ignore this issue for now??


return(list(food = allFood, exercise = allExercise, dailyCal = dailyCal))

}





