library(shiny)
library(ggplot2)
library(plotly)
# Define server logic required to draw a histogram

formatData <- readRDS("data/AllExperimentsCombined.rds")

dfPoints <- data.frame()
dfModels <- data.frame()
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
  upperPrediction <- unlist(formatData[i,"upperPrediction"])
  lowerPrediction <- unlist(formatData[i,"lowerPrediction"])
  
  dfModelsTemp <- data.frame(ID=rep(ID,length(interval)),
                             title=rep(title,length(interval)), 
                             modelID=rep(modelID,length(interval)), 
                             releaseYear=rep(releaseYear,length(interval)),
                             interval=interval, 
                             model=model,
                             lower=lower,
                             upper=upper, 
                             lowerPrediction=lowerPrediction,
                             upperPrediction=upperPrediction)
  dfPointsTemp <- data.frame(ID=rep(ID,length(ages)),
                             title=rep(title,length(ages)), 
                             modelID=rep(modelID,length(ages)),
                             releaseYear=rep(releaseYear,length(ages)),
                             ages=ages, 
                             aRate=aRate,
                             sARate=sARate)
  
  if (nrow(dfModels)==0) {
    dfModels <- dfModelsTemp
  } else {
    dfModels <- rbind(dfModels, dfModelsTemp)
  }
  if (nrow(dfPoints)==0) {
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
  
  output$mainPlot <- renderPlot( {
    tmpModels <- dfModels[dfModels$ID %in% input$selectedElements,]
    tmpPoints <- dfPoints[dfPoints$ID %in% input$selectedElements,]
    
    if (input$xAxis==2) {
      tmpModels$interval <- tmpModels$interval + tmpModels$releaseYear
      tmpPoints$ages <- tmpPoints$ages + tmpPoints$releaseYear
    }
    yMax <- 1.1*max(c(tmpModels$model, tmpPoints$aRate, tmpPoints$sARate))
    mPlot <- ggplot()
    
    if (input$predBand==TRUE) {
      mPlot <- mPlot + geom_ribbon(data=tmpModels, aes(x=interval, ymin=lowerPrediction, ymax=upperPrediction, fill=title), 
                                   alpha=0.15)
    }
    
    if (input$confBand==TRUE) {
      mPlot <- mPlot + geom_ribbon(data=tmpModels, aes(x=interval, ymin=lower, ymax=upper, fill=title), 
      alpha=0.25)
    }
    mPlot <-  mPlot + geom_line(data=tmpModels, aes(x=interval, y=model, color=title)) 
    
    if (input$adptRt==TRUE) {
      mPlot <- mPlot + geom_point(data=tmpPoints, aes(x=ages, y=aRate, color=title), shape=19)
    }
    if (input$smthRt==TRUE) {
      mPlot <- mPlot + geom_point(data=tmpPoints, aes(x=ages, y=sARate, color=title), shape=17)
    }
      mPlot <- mPlot + 
      scale_x_continuous(expand = c(0,0)) +
      scale_y_continuous(expand = c(0,0)) +
      #scale_y_continuous(limits = c(0,yMax), expand = c(0,0)) + 
      theme(legend.position="bottom")
    return (mPlot)
  }
  )
  
  
})