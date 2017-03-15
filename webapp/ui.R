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
            h3("Format Technology Lifecycle Analysis"),
            p(span(id="bass", "Bass Difusion Model", style="color: blue;"), span("is a well known mathematical model used to analyse and predict life-cycles of various products. 
              It was orignially developed in 1960s with the main focus on durable goods (e.g. cars and refrigerators). Over the years its use has been widen and has 
              been applied for modelling life-cycles of various products and services.")),
            div(img(src="bass.png", width=200), style="text-align: center;"), br(), br(),
            p("Format obsolescence is an important aspect and driver of many activities in digital preservation. As obsolescence is the final stage of every products 
              life-cycle an important step towards gaining better understanding of format obsolescence is by getting better understanding of format technology life-cycles. This work 
              provides initial quantative analysis of format technology life-cycles. The analysis is based on the Bass Difusion Model. We hope that this is a positive step towards 
              generating rigorous quantative data for better understanding of format technology evolution and which risks that evolution raises towards digital preservation."),
            div(img(src="pdf.png", width=500, height=300), style="text-align: center;")
            ),
          bsTooltip(id = "bass", title = "Frank M. Bass, A New Product Growth for Model Consumer Durables, Management Science,15(5), 215–227. , 1969, doi:10.1287/mnsc.15.5.215", 
                    placement = "top", trigger = "hover"),
          box (
            width = 12,
            h3("Sources"), 
            HTML("<p> A detailed overview of the whole analysis workflow and as well detailed overview of results and discussion have been published in a separate article. 
                 <br><a href=\"http://hdl.handle.net/1807/75891\">Preprint version of the article</a></p>
                 <p> The source code of the analysis workflow (done in R language) can be found on <a href=\"https://github.com/datascience/FormatAnalysis\">Github</a></p>
                 <p> All the data used as the input for the analysis workflow and as well generated during the analysis process has been published and can be retrieved from
                      <a href=\"https://dx.doi.org/10.6084/m9.figshare.c.3258991\">Figshare</a></p>
                 ")
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