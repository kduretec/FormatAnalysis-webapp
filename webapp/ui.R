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
      menuItem("Models", tabName = "models", icon = icon("cog")),
      menuItem("Parameters", tabName = "parameters", icon = icon("cog"))  
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "about",
        h2("About")
      ),
      tabItem(
        tabName = "dataset",
        h2("Dataset")
      ),
      tabItem(
        tabName = "markets",
        h2("Format Markets")
      ),
      tabItem(
        tabName = "models",
        fluidRow(
          column(
            width = 3,
            box(
              width = 12,
              title = "Plot Settings",
              h4("Points"),
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
              h4("Bands"),
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
        h2("Model Paramaters")
      )
    )
  )
)