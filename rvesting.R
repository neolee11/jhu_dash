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


last_date<-NA
counter<-0
for(i in 1:length(titles)){
	ti <- titles[i] 

	if(! ti %in%c('Foods','Exercises')){
		last_date <- as.Date(ti, format = '%B %d,%Y')
		next
	}

	#if not a date, then it's a table
	counter <- counter + 1
	dates[counter] <- as.Date(last_date)
}

data.frame(dates,isFood,isExercise)

names(tab)


