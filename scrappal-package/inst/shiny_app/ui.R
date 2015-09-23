# init
library(shiny)
require(scrappal)

# readHelpTabHTML<- paste0(readLines('help_tab.html'),collapse='') #will be converted to a the welcome (help) page 

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
        # tabPanel("Instructions",
          # HTML(paste(readHelpTabHTML,collapse=''))),
        tabPanel("Instructions",
          br(),
          p("The Scrappal Application provides an interface
            for users of the 'My Fitness Pal' application
            to get a summary report of their fitness
            progress based on the inputs they provide to the
            'My Fitness Pal' app. These inputs are scrapped
            from the users' Fitness Diary."),
          br(),
          p("Once the input is retrieved, the Scrappal R package
            organizes the data into 3 tables: food, exercise,
            calories per day. It uses this information to display 3
            plots for each user:"),
          p(strong("* Weekly intake 'selected-nutrition' per day")),
          p(strong("* Weekly trends")),
          p(strong("* Weekly 'selected-nutrition' burned in exercise")),
          br(),
          p("The Scrappal app takes the following inputs:"),
          p(strong("Username: "), ("registered username of 'My Fitness
Pal' user")),
          p(strong("Password: "), ("password for the 'My Fitness Pal'
app for above user")),
          em("Note: If password field is empty, the Scrappal app tries
             to find if given username has a public dairy in 'My Fitness
             Pal'. If not, an error is shown that dairy for user cannot
             be accessed without the correct password."),
          p(strong("Start date: "), ("start date from which to pull
records from 'My Fitness Pal' for current analysis.")),
          p(strong("End date: "), ("end date to pull records from 'My
Fitness Pal' for current analysis.")),
          br(),
          p("The weekly intake tab takes the following additional inputs:")

          ),


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