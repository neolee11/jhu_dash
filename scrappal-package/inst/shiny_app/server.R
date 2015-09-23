library(shiny)
library(scrappal)
library(ggplot2)
library(httr)

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
                        includeDailyCal = TRUE)
        })
        
        ######### Reccomendations

        recommendationDF <- reactive({ 
            rec<-c()
            rec$carbs <- 292 #
            rec$fat <- ((recomCalories) / 7.7) * 0.35 ## with formula
            rec$protein <- input$weight * 0.36 ## with formula 
            rec$cholest <- 300 #
            rec$sodium <- 2300 #
            # Recommendation for male is 36g and for female is 24g (can we figure out the gender of users?)
            rec$sugars <- ((recomCalories / 7.7)) * 0.1 ## with formula 
            # Recommendation for male is 38g and for female is 25g
            rec$fiber <- 38 #

            recomCalories <- input$activity * (input$weight / 2.2046)
            rec$calories <- round(recomCalories, 2)
        })



        output$dailyIntakePlot <- renderPlot({
                dailySummaryPlot(dataTable = z()$food,
                                 outcome = as.character(input$Input1),
                                 alsoMeal = TRUE)
        })
        
        output$plot3 <- renderPlot({
                dailySummaryPlot(dataTable = z()$exercise,
                                 outcome = as.character(input$Input1),
                                 alsoMeal = FALSE,
                                 title=paste('Exercise: ',as.character(input$Input1),' per day'))
        })

        #Need to display this plot... doen't work..
        output$dailyExercisePlot <- renderPlot({
            total <- tapply(z()[input$Input1], z()["day"], sum)
            plot(unique(z()$day), total, type = "l",
               xlab = "Time period", ylab = "Amount")
            abline(h = recommendationDF()[input$Input1], col = "red")
        })
    }
)
