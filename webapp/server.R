library(shiny)
library(ggplot2)
# Define server logic required to draw a histogram

formatData <- readRDS("data/AllExperimentsCombined.rds")

markets <- unique(formatData$market)

shinyServer(function(input, output) {
  
  output$chooseMarket <- renderUI({
    selectInput("selectedMarket", "Choose market", as.list(markets))
  })
  
  output$chooseElement <- renderUI({
    if (is.null(input$selectedMarket)) {
     return()
    }
    elements <- as.list(formatData[formatData$market==input$selectedMarket,]$ID)
    names(elements) <- formatData[formatData$market==input$selectedMarket,]$name
    checkboxGroupInput("selectedElements", "Choose Elements", 
                       choices = elements
    )
     
  })
  
  output$selModels <- renderText( {
    paste("Market elements to plot are", input$selectedElements)
  })
  
  output$mainPlot <- renderPlot(
    tmpData <- formatData[formatData$ID %in% input$selectedElements,]
   # mPlot <- ggplot(tmpData, aes(x=ages, y=adoptionRate, color=))
  )
  
})