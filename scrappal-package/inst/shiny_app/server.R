library(shiny)
library(scrappal)
library(ggplot2)
library(httr)
library(dplyr)

# dat <- z$food



#sources citation.. 
# http://www.glucomenu.com/new_research/minimum_carbohydrate_recommendations.asp for carbs
# http://www.fda.gov/ForConsumers/ConsumerUpdates/ucm181577.htm for sodium
# http://www.livestrong.com/article/47612-recommended-daily-intake-fat-grams/ for fat
# http://www.pcrm.org/health/diets/vegdiets/how-can-i-get-enough-protein-the-protein-myth for protein
# http://www.heartandstroke.on.ca/site/c.pvI3IeNWJwE/b.3581947/k.D7AE/Healthy_Living__Dietary_fats_oils_and__cholesterol.htm for chol
# http://www.cbsnews.com/news/world-health-organization-lowers-sugar-intake-recommendations/ for sugars
# http://healthyeating.sfgate.com/recommended-daily-serving-fiber-4262.html for fiber


#Formula for recommendation calories for adults per day
## activity mass varies from 20 to 40 depending on how much the person moves/acts per day
## and we can ask users for typing activity value. For instance, 
## 20 - minimum active mass
## 30 - average active mass
## 40 - high active mass



#Have a complete data frame
# recommendationDF <- as.data.frame(recommendationDF)

# tb <- select(dat, day, calories, carbs, fat, 
#              protein, cholest, sodium, sugars, fiber)


shinyServer(
    function(input, output) {
        ######## DATA 
        z <- eventReactive(input$sub, {
                scrappal(username = input$username,
                        fromDate = input$fromDate,
                        toDate = input$toDate,
                        includeDailyCal = TRUE,
                        verbose=TRUE)
        })
        
        ######### Reccomendations

        recommendationDF <- reactive({ 
            # browser()
            recomCalories <- as.numeric(input$activity) * (as.numeric(input$weight) / 2.2046)

            rec<-c()
            rec$carbs <- 292 #
            rec$fat <- ((recomCalories) / 7.7) * 0.35 ## with formula
            rec$protein <- as.numeric(input$weight) * 0.36 ## with formula 
            rec$cholest <- 300 #
            rec$sodium <- 2300 #
            # Recommendation for male is 36g and for female is 24g (can we figure out the gender of users?)
            rec$sugars <- ((recomCalories / 7.7)) * 0.1 ## with formula 
            # Recommendation for male is 38g and for female is 25g
            rec$fiber <- 38 #

            rec$calories <- round(recomCalories, 2)

            rec
        })



        output$dailyIntakePlot <- renderPlot({
                dailySummaryPlot(dataTable = z()$food,
                                 outcome = as.character(input$Input1),
                                 alsoMeal = as.logical(input$mealBreak),
                                 recommend = unlist(recommendationDF()[input$Input1]))
        })
        
        output$dailyExercisePlot <- renderPlot({
            dailySummaryPlot(dataTable = z()$exercise,
                 outcome = as.character(input$exerciseChoice),
                 alsoMeal = FALSE,
                 title=paste('Exercise: ',as.character(input$exerciseChoice),'per day'))
        })

        #Need to display this plot... doen't work..
        output$trendsPlot <- renderPlot({
            # browser()
            mutate(z()$food,
                outcomeVar = get(input$Input1, envir=as.environment(z()$food))) %>%
                group_by(day)%>%
                summarize(totalNutri=sum(outcomeVar)) %>%
            ggplot(data=.)+geom_line(aes(y=totalNutri,x=day))+
                labs(x = "Time period", y = input$Input1) +
                expand_limits(y = unlist(recommendationDF()[input$Input1])) + 
                geom_abline(intercept = unlist(recommendationDF()[input$Input1]),slope=0, col='darkgreen', lty=2, lwd=.7)

        })
    }
)
