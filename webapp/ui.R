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
  dashboardHeader(title = "Format Technology Lifecycle Analysis", titleWidth = 400),
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
        fluidRow( 
          box (
            width=12,
            h3("Format Analysis"),
            p("Bass Difusion model is a well known mathematical model used to analyse and predict life-cycles of various products. 
              It was orignially developed in 1960s with the main focus on durable goods such as (e.g. cars and refrigerators). Over the years its use has been widen and has 
              been applied for modelling the life-cycles of various products and services."),
            p("This website demonstrates how the Bass model can be used for modelling the life-cycle of various format technologies (file formats families, format versions, 
              or software used to create specific file formats). We see this as an important step towards a better understadning of format obsolescence, an important 
              aspect in digital preservation which still needs better understanding based on quantative analysis."),
            div(img(src="pdf.png", width=500, height=300), style="text-align: center;")
            ),
          box (
            width = 12,
            h3("Sources"), 
            HTML("<a href=\"http://hdl.handle.net/1807/75891\">Preprint version of the article</a>")
          ),
          box (
            width = 12,
            h3("How to use the material and properly cite it ?")
          ),
          box (
            width = 12,
            h3("Authors and Acknowledgements"),
            div(div(img(src="duretec.jpeg", width=100, height=140), style=""), div(p("Kresimir Duretec"), width=180, style=""), width=300, 
                style="text-align: left;"), br(),br(),
            div(div(img(src="Christoph-Becker.jpeg", width=100, height=140), style=""), div(p("Christoph Becker"), width=180, style=""), width=300, 
                style="text-align: left;"), br(),br(),
            #img(src='Christoph-Becker.jpeg',width=100, height=140), br(),br(),
            p("Part  of  this  work  was  supported  by  WWTF  through  BenchmarkDP  (ICT12-046)  and  by  NSERC  through  RGPIN-2016-06640.")
          )  
        )
      ),
      tabItem(
        tabName = "dataset",
        box (
          width=12,
          h3("UK Web Archive Format Profile dataset"),
          HTML("<p>Currently used dataset is the <a href=\"http://data.webarchive.org.uk/opendata/ukwa.ds.2/fmt/\">UK Web Archive Format Profile dataset</a>
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