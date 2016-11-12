library(shiny)
library(ggplot2)
library(plotly)

# Define server logic required to draw a histogram

formatData <- readRDS("data/AllExperimentsCombined.rds")

dfPoints <- NA
dfModels <- NA
for (i in 1:nrow(formatData)) {
  title <- formatData[i,"name"] 
  ID <- formatData[i,"ID"]
  modelID <- formatData[i,"modelID"]
  releaseYear <- as.numeric(formatData[i,"release.year"])
  ages <- unlist(formatData[i,"ages"])
  aRate <- unlist(formatData[i,"adoptionRate"])
  sARate <- unlist(formatData[i,"smoothedAdoptionRate"])
  interval <- unlist(formatData[i,"interval"])
  model <- unlist(formatData[i,"model"])
  upper <- unlist(formatData[i,"upper"])
  lower <- unlist(formatData[i,"lower"])
  
  dfModelsTemp <- data.frame(ID=rep(ID,length(interval)),
                             title=rep(title,length(interval)), 
                             modelID=rep(modelID,length(interval)), 
                             releaseYear=rep(releaseYear,length(interval)),
                             interval=interval, 
                             model=model,
                             lower=lower,
                             upper=upper)
  dfPointsTemp <- data.frame(ID=rep(ID,length(ages)),
                             title=rep(title,length(ages)), 
                             modelID=rep(modelID,length(ages)),
                             releaseYear=rep(releaseYear,length(ages)),
                             ages=ages, 
                             aRate=aRate,
                             sARate=sARate)
  
  if (is.na(dfModels)) {
    dfModels <- dfModelsTemp
  } else {
    dfModels <- rbind(dfModels, dfModelsTemp)
  }
  if (is.na(dfPoints)) {
    dfPoints <- dfPointsTemp
  } else {
    dfPoints <- rbind(dfPoints, dfPointsTemp)
  }
}




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
  
  output$mainPlot <- renderPlotly( {
    tmpModels <- dfModels[dfModels$ID %in% input$selectedElements,]
    tmpPoints <- dfPoints[dfPoints$ID %in% input$selectedElements,]
    mPlot <- ggplot(tmpModels, aes(x=interval, y=model, color=title, 
                                   linetype=title)) + 
      geom_line() +
      geom_point(data=tmpPoints, aes(x=ages, y=aRate, color=title))
    return (mPlot)
  }
  )
  
  
})