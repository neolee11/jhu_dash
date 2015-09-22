#' @title Generate summary plots from user data
#'
#' @param dataTable a table of food or exercise elements from \code{\link{scrappal}}
#' @param outcome a column name of dataTable to put on y axis
#' @param alsoMeal should we also break it down by meal
#' @export 
#' @import ggplot2 dplyr
#' @return a plot to be used in a shiny app
#' @examples \dontrun{
#'
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
#' dailySummaryPlot(dataTable=z$food, outcome='calories', alsoMeal=FALSE)
#' dailySummaryPlot(dataTable=z$food, outcome='fat', alsoMeal=TRUE)
#' dailySummaryPlot(dataTable=z$exercise, outcome='calories', alsoMeal=FALSE, title='calories burned')
#' dailySummaryPlot(dataTable=z$exercise, outcome='minutes', alsoMeal=FALSE, title='exercise per day (minutes)')
#'
#'}

dailySummaryPlot <- function(dataTable, outcome='calories', alsoMeal=FALSE, title=paste('daily intake of',outcome)){

	#If needed, add weekday column
	if(!'weekday' %in% colnames(dataTable)){
		dataTable<- mutate(dataTable,
			weekday = weekdays(day))
	}
	if(!'yearMonth' %in% colnames(dataTable)){
		dataTable<- mutate(dataTable,
			yearMonth = as.character(day,format='%Y-%m'))
	}


	#Since dplyr only accepts hardcoded variable names by default, the next lines get a little messy:

	dt2 <- mutate(dataTable,
			outcomeVar = get(outcome, envir=as.environment(dataTable))) 

	if(alsoMeal){
		out <- group_by(dt2, day, meal) %>%
		summarize(total_y = sum(outcomeVar),
			weekday = head(weekday,1)) %>%
		ggplot(., aes_string(y='total_y',x='weekday',fill='meal')) + geom_boxplot() 
	}
	if(!alsoMeal){
		out <- group_by(dt2, day) %>%
		summarize(total_y = sum(outcomeVar),
			weekday = head(weekday,1)) %>%
		ggplot(., aes_string(y='total_y',x='weekday')) + geom_boxplot() 
	}


	out<- out+ labs(y=outcome,title=title)

	out

}
