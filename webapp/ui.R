library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  titlePanel("Format Analysis"), 
  
  plotOutput("mainPlot"), 
  
  hr(),
  
  fluidRow(
    column (4, h4("Points"),
            checkboxInput("adptRt", label = "Adoption Rate", value = TRUE),
            checkboxInput("smthRt", label = "Smoothed Adoption Rate", value = FALSE)
    ),
    column (4, h4("Bands"),
            checkboxInput("confBand", label = "Confidence Band", value = FALSE),
            checkboxInput("predBand", label = "Prediction Band", value = FALSE)
            ), 
    column(4,
           radioButtons("xAxis", label="X axis", choices = list("Ages"=1, "Years"=2), 
                        selected = 1)
           )
  ), 
  
  fluidRow( 
    column(12, 
           uiOutput("chooseMarket"),
           uiOutput("chooseElement")
           )
    )
      
      
))
