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
        value = "2015-07-15",
        min = "2015-01-01",
        max = "2015-12-31"),
      actionButton("sub", "Submit"),

      br(),
      br(),
      br(),
      strong("For nutrition\nrecommendations:"),
      br(),
      br(),
       selectInput("Input1", "Choose which nutri to view",
            choices = c('calories' = 'calories', 
            'carbs' = 'carbs',
            'fat' = 'fat',
            'protein' = 'protein',
            'cholest' = 'cholest',
            'sodium' = 'sodium',
            'sugars' = 'sugars',
            'fiber' = 'fiber')),
        numericInput(inputId='weight', label='weight (lbs)', value = 150, min = 70, max=300),
        numericInput(inputId='activity', label='activity', value = 30, min=20, max=40)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Instructions",
          "contents"),
        tabPanel("Weekly Nutrition",
          plotOutput("dailyIntakePlot"),
          selectInput('mealBreak','Break nutrition down by meal',
            choices = c('yes' = 'TRUE', 
            'no' = 'FALSE'), selected = 'FALSE'
            )
        ),
        tabPanel("Weekly Exercise",
           plotOutput("dailyExercisePlot"),
           selectInput("exerciseChoice", "Choose which exercise metric to view",
            choices = c('calories burned' = 'calories', 
            'minutes' = 'minutes',
            'sets' = 'sets',
            'reps' = 'reps'))
           ),
        tabPanel("Trends",
           plotOutput("trendsPlot"))
  )
)
)
)
)