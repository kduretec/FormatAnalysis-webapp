library(shiny)
library(shinyjs)
library(shinyBS)
library(plotly)
library(shinydashboard)
library(DT)

# Define UI for application that draws a histogram

label.help <- function(label,id){
  HTML(paste0(label,actionLink(id,label=NULL,icon=icon('question-circle'))))
}


dashboardPage(
  dashboardHeader(title = "Format Analysis"),
  dashboardSidebar(
    sidebarMenu(
      id="tabs",
      menuItem("About", tabName = "about", icon = icon("cog")),
      menuItem("Dataset", tabName = "dataset", icon = icon("cog")),
      menuItem("Format Markets", tabName = "markets", icon = icon("cog")),
      menuItem("Model Analysis", tabName = "models", icon = icon("cog")),
      menuItem("Parameters Analysis", tabName = "parameters", icon = icon("cog"))  
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "about",
        box (
          width=12,
          h3("Format Analysis"),
          p("This is the demonstration of applying Bass Difusion model to file formats lifecycles"),
          h4("Authors"),
          h4("How to cite us")
        )
        
      ),
      tabItem(
        tabName = "dataset",
        box (
          width=12,
          h3("UK Web Archive Format Profile dataset"),
          HTML("<p>Currently used dataset is the <a href=\"https://www.webarchive.org.uk/ukwa/visualisation/ukwa.ds.2/fmt\">UK Web Archive Format Profile dataset</a>
               </p>"),
          div(img(src="ukwa.png", width=600), style="text-align: center;")
        )
      ),
      tabItem(
        tabName = "markets",
        box (
          width=12,
          h3("Format Markets"),
          uiOutput("chooseMarketTable"),
          DT::dataTableOutput("marketTable")
        )
      ),
      tabItem(
        tabName = "models",
        fluidRow(
          column(
            width = 3,
            box(
              width = 12,
              title = "Plot Settings",
              strong("Points"%>%label.help("lbl_points")),
              fluidRow(
                column (
                  width = 6,
                  checkboxInput("adptRt", label = "Real", value = TRUE)
                ),
                column(
                  width = 6,
                  checkboxInput("smthRt", label = "Smoothed", value = FALSE)
                )
              ),
              strong("Bands"%>%label.help("lbl_bands")),
              fluidRow(
                column (
                  width = 6,
                  checkboxInput("confBand", label = "Confidence", value = FALSE)
                ),
                column(
                  width = 6,
                  checkboxInput("predBand", label = "Prediction", value = FALSE)
                )
              ),
              radioButtons("xAxis", label = "X axis"%>%label.help("lbl_xaxis"), choices = list("Ages" = 1, "Years" = 2), 
                          selected = 1, inline=TRUE),
             # checkboxInput("enableSlider", label="Custom X axis", value=TRUE),
             # uiOutput("xSlider"),
              bsTooltip(id = "lbl_points", title = "Which points to diplay", 
                       placement = "right", trigger = "hover"),
              bsTooltip(id = "lbl_bands", title = "Which band to display", 
                       placement = "right", trigger = "hover"),
              bsTooltip(id = "lbl_xaxis", title = "Which axis to use", 
                        placement = "right", trigger = "hover")
            ),
            box(
              width = 12,
              fluidRow(
                column(
                  12,
                  uiOutput("chooseMarket"),
                  uiOutput("chooseElement")
                )
              )
            )
          ),
          tabBox(
            width = 9,
            tabPanel(
              title="Graphs",
              plotOutput("mainPlot")
            ),
            tabPanel(
              title="Models",
              DT::dataTableOutput('mainTable')
            )
            
          )
        )
      ),
      tabItem(
        tabName = "parameters",
        fluidRow( 
          box(
            width=3,
            title="Plot Settings", 
            fluidRow( 
              column( 
                width=6, 
                uiOutput("qualityFit")
              ),
              column(
                width=6,
                uiOutput("type")
              )
            )
          ),
          tabBox(
            width = 9,
            tabPanel(
              title="p/q",
              plotOutput("pqPlot")
            ),
            tabPanel(
              title="time to peak",
              plotOutput("ttpPlot")
            )
            
          )
        )
      )
    )
  )
)