library(shiny)
library(shinyjs)
library(ggplot2)
#library(plotly)
# Define server logic required to draw a histogram

formatData <- readRDS("data/allExperimentsCombined.rds")
formatData$qualityFit <- tolower(formatData$qualityFit)
experimentData <- read.table("data/allExperiments.tsv", header=TRUE, sep="\t")
experimentData$type <- tolower(experimentData$type)
experimentData$qualityFit <- tolower(experimentData$qualityFit)
qualityFit <- unique(experimentData$qualityFit)
type <- unique(experimentData$type)
marketFiles <- read.table("data/markets.tsv", header=TRUE, sep="\t")

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
  
  
  ####################
  ### FORMAT MARKETS #
  ####################
  output$chooseMarketTable <- renderUI(
    {
      selectInput("selectedMarketTable", "Choose a market", as.list(marketFiles$market))
    }
  )
  output$marketTable <- DT::renderDataTable( 
    {
      file <- marketFiles[marketFiles$market==input$selectedMarketTable,]$file
      table <- read.table(paste("data/", file, sep=""), header=TRUE, sep="\t")
      table <- table[,names(table)!="comments"]
      colnames(table)[which(names(table) == "release.year")] <- "release year"
      table
    }, 
    options = function() { 
      pL <- 10
      if (input$selectedMarketTable=="DISTILLER")
        pL <- 4
      list(lengthChange = FALSE, dom="tp", pageLength=pL) 
      },
    rownames = FALSE
  )
  
  
  
  
  
  output$xSlider <- renderUI(
    {
      mx <-0 
      mxx <- 30 
      xs <- 0
      xe <- 30
      if (input$xAxis==2) {
        mx <- 1970
        mxx <- 2040
        xs <- 1980
        xe <- 2030
      }
      sliderInput(
        "slider", label = "", min = mx, 
                  max = mxx, value = c(xs, xe)
        )
    }
  )
  
  output$chooseMarket <- renderUI({
    selectInput("selectedMarket", "Choose a market", as.list(markets))
  })
  
  output$chooseElement <- renderUI({
    if (is.null(input$selectedMarket)) {
     return()
    }
    elements <- as.list(formatData[formatData$market==input$selectedMarket,]$ID)
    names(elements) <- formatData[formatData$market==input$selectedMarket,]$name
    # checkboxGroupInput("selectedElements", "Choose Elements", 
    #                    choices = elements
    # )
    selectInput("selectedElements", "Choose Elements", as.list(elements), multiple=TRUE,
                selectize = TRUE)
     
  })
  
  output$selModels <- renderText( {
    paste("Market elements to plot are", input$selectedElements)
  })
  
  ####################
  ### MAIN TABLE #####
  ####################
  output$mainTable <- DT::renderDataTable(
    {
      tmpModelsTab <- formatData[formatData$ID %in% input$selectedElements,]
      tmpModelsTab <- tmpModelsTab[,names(tmpModelsTab) %in% c("ID", "name", "release.year", "p", "q", "m", "qualityFit")]
      tmpModelsTab$p <- round(tmpModelsTab$p, 3)
      tmpModelsTab$q <- round(tmpModelsTab$q, 3)
      tmpModelsTab$m <- round(tmpModelsTab$m, 3)
      colnames(tmpModelsTab)[which(names(tmpModelsTab) == "release.year")] <- "release year"
      colnames(tmpModelsTab)[which(names(tmpModelsTab) == "qualityFit")] <- "quality of fit"
      tmpModelsTab
    },
    options = list(lengthChange = FALSE, dom="tp"),
    rownames = FALSE
  )

  ####################
  ### MAIN PLOT  #####
  ####################
  output$mainPlot <- renderPlot( {
    tmpModels <- dfModels[dfModels$ID %in% input$selectedElements,]
    tmpPoints <- dfPoints[dfPoints$ID %in% input$selectedElements,]
    xLabl = "age"
    if (input$xAxis==2) {
      tmpModels$interval <- tmpModels$interval + tmpModels$releaseYear
      tmpPoints$ages <- tmpPoints$ages + tmpPoints$releaseYear
      xLabl = "year"
    }
    yMax <- 1.1*max(c(tmpModels$model, tmpPoints$aRate, tmpPoints$sARate))
    mPlot <- ggplot()
    if (nrow(tmpModels)>0) { 
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
        mPlot <- mPlot + geom_point(data=tmpPoints, aes(x=ages, y=aRate, color=title), shape=19, size=2)
      }
      if (input$smthRt==TRUE) {
        mPlot <- mPlot + geom_point(data=tmpPoints, aes(x=ages, y=sARate, color=title), shape=17, size=2)
      }
       
    }
    mPlot <- mPlot + 
      scale_x_continuous(expand = c(0,0), limits = c(input$slider[1], input$slider[2])) +
      #scale_y_continuous(expand = c(0,0)) +
      #scale_y_continuous(limits = c(0,yMax), expand = c(0,0)) + 
      labs(x=xLabl, y="adoption rate")  +
      theme_bw() + 
      theme(legend.position="bottom",
            legend.title=element_blank(),
            legend.key=element_blank(),
            legend.text=element_text(size=12)) +
      guides(color=guide_legend(ncol=3, byrow = FALSE),
             fill=guide_legend(ncol=3, byrow = FALSE))
    
    return (mPlot)
  }
  )
  
  
  
  ####################
  ## PARAMETERS SEC. #
  ####################
  output$qualityFit <- renderUI (
    {
      checkboxGroupInput("selectedQuality", "Quality of Fit", choices = qualityFit, 
                         selected = qualityFit)
    }
  )
  output$type <- renderUI (
    {
      checkboxGroupInput("selectedType", "Type", choices = type,
                         selected = type)
    }
  )
  
  
  
  ####################
  #### PQ PLOT #######
  ####################
  output$pqPlot <- renderPlot( {
    
    pqPlot <- ggplot()
    pqPlot <- pqPlot + geom_point(data=experimentData[experimentData$type %in% input$selectedType & experimentData$qualityFit %in% input$selectedQuality,], 
                                  aes(x=q, y=p, color=type), size=2) +
      theme_bw() +
      theme(legend.position="bottom",
            legend.title=element_blank(),
            legend.key=element_blank(),
            legend.text=element_text(size=12))
    
    return (pqPlot)
  }
    
  )
  
  ####################
  #### TTP PLOT  #####
  ####################
  output$ttpPlot <- renderPlot( {
  
    ttpPlot <- ggplot()
    ttpPlot <- ttpPlot + geom_point(data=experimentData[experimentData$TTP>0 & experimentData$type %in% input$selectedType & 
                                                          experimentData$qualityFit %in% input$selectedQuality,], 
                                    aes(x=release.year, y=TTP, color=type, size=peak)) +
      labs(x="release year", y="time to peak") +
      theme_bw() +
      theme(legend.position="bottom",
            legend.title=element_blank(),
            legend.key=element_blank(),
            legend.text=element_text(size=12))
    
    return (ttpPlot)
  }
    
  )
  
  
})