library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Format Analysis"), 
  
  sidebarLayout(position="left",
    sidebarPanel(
      
      uiOutput("chooseMarket"),
      
      uiOutput("chooseElement")
    ),
    mainPanel(
      textOutput("selModels"),
      
      plotOutput("mainPlot")
    )
  )
))
