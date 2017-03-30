library(shiny)
library(shinyjs)
library(shinyBS)
#library(plotly)
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
            h3("About this website"),
            p("This website presents results from a project that used longitudinal web archives data to study format technology evolution and model the 
               diffusion of formats over time using the Bass model. The website contains all generated diagrams, provides a bit of background on the 
               data sets and workflow, and lets you play around with the figures.  To make sense of these results, please refer to the article that 
               discusses the methodology and its findings!")
          ),
          box (
            width=12,
            h3("Format Technology Lifecycle Analysis"),
            p(span(id="bass", "Bass Diffusion Model", style="color: blue;"), span("is a well known mathematical model used to analyse and predict the diffusion 
            life-cycle of various products. It was originally developed in 1960s with the main focus on durable goods (e.g. cars and refrigerators). Over the 
            years its use has expanded, and it has been applied for modelling life-cycles of various products and services. The model (Equation 1.) expresses 
            that adoption rate at a specific time (S(t)) is dependent on three parameters : p (influence of innovators), q (influence of imitators) and m (total 
            market potential of a product). Adoption rate is often defined as a total number of units sold in a certain time period (e.g. month, or a year). 
            However, other ways of defining adoption rate are possible.")),
            div(div(img(src="bass.png", width=300)), div("Equation 1. Bass Diffusion Model"),style="text-align: center;"), br(), br(),
            p("The article describes how we have mapped these concepts to file format technologies and used the Bass model to describe how the use of formats 
               evolves on the web. Here’s one example discussed in the article - PDF 1.3 on the UK web."),
            div(div(img(src="pdf.png", width=500, height=300)), div("Figure 1. Bass Diffusion Model applied to PDF version 1.3"), style="text-align: center;")
            ),
          bsTooltip(id = "bass", title = "Frank M. Bass, A New Product Growth for Model Consumer Durables, Management Science,15(5), 215–227. , 1969, doi:10.1287/mnsc.15.5.215", 
                    placement = "top", trigger = "hover"),
          box (
            width = 12,
            h3("Sources"), 
            infoBox("Preprint Version", 
              p("A detailed overview of the whole analysis workflow and as well detailed overview of results and discussion is published 
                in the article.", style="font-size:8pt;margin;margin:0;"), 
                    icon=icon("file-pdf-o"), fill = FALSE, href = "http://hdl.handle.net/1807/75891"),
            infoBox("Source code", p("The source code of the analysis workflow (done in R language).",style="font-size:8pt;margin;margin:0;"), 
                    icon=icon("github"), fill = FALSE, href="https://github.com/datascience/FormatAnalysis"),
            infoBox("Dataset", p("All the data used as the input for the analysis workflow and as well generated during the analysis 
                                 process has been published and can be retrieved from Figshare.", style="font-size:8pt;margin;margin:0;"),  
                    icon=icon("database"), fill= FALSE, href="https://dx.doi.org/10.6084/m9.figshare.c.3258991")
          # HTML("<p> A detailed overview of the whole analysis workflow and as well detailed overview of results and discussion have been published in a separate article. 
          #       <br><a href=\"http://hdl.handle.net/1807/75891\">Preprint version of the article</a></p>
          #      <p> The source code of the analysis workflow (done in R language) can be found on <a href=\"https://github.com/datascience/FormatAnalysis\">Github</a></p>
          #     <p> All the data used as the input for the analysis workflow and as well generated during the analysis process has been published and can be retrieved from
          #            <a href=\"https://dx.doi.org/10.6084/m9.figshare.c.3258991\">Figshare</a></p>
          #       ")
          ),
          box (
            width = 12,
            h3("How to use the material and properly cite it ?"),
            p(span("The material on this website is available under a Creative Commons license:"), 
               a(href="https://creativecommons.org/licenses/by-nc-sa/3.0/","Attribution-NonCommercial-ShareAlike 3.0 (CC BY-NC-SA 3.0)"), span(". You can use it free of charge for educational and research purposes. 
            Please cite the following paper in your work:")),
            h4("Paper"),
            p(strong("Duretec, Kresimir; Becker, Christoph (2017):"), "Format Technology Lifecycle Analysis. Journal of the Association for Information Science and Technology, 
              doi:10.1002/asi.23881 (accepted for publication), Preprint: ", a(href="http://hdl.handle.net/1807/75891", "http://hdl.handle.net/1807/75891")),
            h4("Dataset"),
            p(strong("Duretec, Kresimir; Becker, Christoph (2016):"), "BenchmarkDP - Format technology lifecycle analysis based on the UK 
              Web Archive Format Profile dataset. doi:10.6084/m9.figshare.c.3258991")
          ),
          box (
            width = 12,
            h3("Authors and Acknowledgements"),
            div(
            div(div(img(src="duretec.jpeg", width=150, height=200), style=""), div(a(href="http://ifs.tuwien.ac.at/~duretec/", "Kresimir Duretec"), width=150, style=""), width=200, 
                style="display:inline-block;margin-right:40px;"),
            div(div(img(src="Christoph-Becker.jpeg", width=150, height=200), style=""), div(a(href="http://dci.ischool.utoronto.ca/about-the-dci/christoph-becker/", "Christoph Becker"), width=150, style=""), width=200, 
                style="float:center; display:inline-block;"),
            style="text-align:center;"
            ), br(),br(),
            #img(src='Christoph-Becker.jpeg',width=100, height=140), br(),br(),
            p("Part  of  this  work  was  supported  by  WWTF  through  BenchmarkDP  (ICT12-046)  and  by  NSERC  through  RGPIN-2016-06640.", style="text-align:center;")
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