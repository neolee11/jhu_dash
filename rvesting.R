library(rvest)

username <- 'funchords'
fromDate <- '2015-08-01'
toDate='2015-08-04'

session<-html_session(paste0('http://www.myfitnesspal.com/reports/printable_diary/',username))

form_blank <- html_form(html(session))[[1]]
form_filled <- set_values(form_blank,
	from=fromDate,
  	to=toDate)
out<-submit_form(session,form_filled)

tab<-html_table(out,header=TRUE) #gets tables
hout<-html(out) #gets in html form
# xout<-xmlTreeParse(out) #in xml form



# print(object.size(tab),units='Mb')


##########
##########
##########
# Get Dates & Table Labels

lt<-length(tab)
dates <- rep(as.Date('January 1, 0001',format='%B %d,%Y'),lt)
isFood<- unlist(lapply(tab, function(x) colnames(x)[1]=='Foods'))
isExercise<- unlist(lapply(tab, function(x) colnames(x)[1]=='Exercises'))
isFood + isExercise

titles<-html_nodes(hout,'#date , thead .first') %>%
	html_text()


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

data.frame(dates,isFood,isExercise)

names(tab)


processTable <- function(x, typeName){
	dx <- dim(x)
	
	out<-data.frame()
	lastType<-NA
	counter<-0
	for(i in 1:nrow(x)){

		if(grepl(x[i,1],'TOTAL:')) next

		if(all(is.na(x[i,-1]))) {
			lastType <- x[i,1]
			next
		}

		#if not a meal, then it's a food item
		counter <- counter + 1
		for(j in 1:ncol(x)){
			out[counter,names(x)[j]] <- x[i,j]
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
}
colnames(allFood) <- tolower(colnames(allFood))
allFood <- as.tbl(allFood)
allFood[,-1]
allFood[,1]

allExercise<-data.frame()
for(i in 1:length(tab)){
	if(isFood[i]) next
	thisExerciseDay <- processTable(tab[[i]], typeName='ExerciseType')
	thisExerciseDay$day <- dates[i]

	allExercise <- rbind(allExercise,thisExerciseDay)
}
colnames(allExercise) <- tolower(colnames(allExercise))
allExercise <- as.tbl(allExercise)

allExercise$calories <- -1 * abs(allExercise$calories)

allExercise





