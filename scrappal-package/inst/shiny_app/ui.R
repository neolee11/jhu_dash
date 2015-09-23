# init
library(shiny)
require(scrappal)



shinyUI(fluidPage(
  titlePanel("Scrappal"),
  ("An app to explore data from "),
    a(href ="https://www.fitnesspal.com", "My Fitness Pall"),
  tags$hr(),
  sidebarLayout(
    sidebarPanel(
      strong("Instructions:"),
      p("Some text"),
      textInput(inputId = "username", label = "Username", value = "funchords"),
      # textInput(inputId = "password", label = "Password", value = ""),
      dateInput(inputId = "fromDate",
        label = "Start date",
        value = "2015-07-01",
        min = "2015-01-01",
        max = "2015-12-31"),
      dateInput(inputId = "toDate",
        label = "End date",
        value = "2015-09-01",
        min = "2015-01-01",
        max = "2015-12-31"),
      br(),
      actionButton("sub", "Submit")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Instructions",
          "contents"),
        tabPanel("Weekly Nutrition",
          plotOutput("dailyIntakePlot"),
             selectInput("Input1", "Choose which nutri you wanna see",
              choices = c('calories' = 'calories', 
              'carbs' = 'carbs',
              'fat' = 'fat',
              'protein' = 'protein',
              'cholest' = 'cholest',
              'sodium' = 'sodium',
              'sugars' = 'sugars',
              'fiber' = 'fiber')),
          textInput(inputId='weight', label='weight (lbs)', value = 150),
          textInput(inputId='activity', label='activity (?)', value = 3)
        ),
        tabPanel("Trends",
           plotOutput("plot2")),
        tabPanel("Weekly Exercise",
           plotOutput("dailyExercisePlot"))
  )
)
)
)
)