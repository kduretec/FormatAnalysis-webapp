library(shiny)
library(plotly)
library(shinydashboard)

# Define UI for application that draws a histogram

dashboardPage(
  dashboardHeader(title = "Format Analysis"),
  dashboardSidebar(
    menuItem("Dataset", tabName = "dataset"),
    menuItem("Format Markets", tabName = "markets"),
    menuItem("Models", tabName = "models"),
    menuItem("Parameters", tabName = "parameters")
  ),
  dashboardBody(
    tabItems(
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
        column(
          width=3, 
          box(
            width=12,
            title = "Settings", 
            fluidRow(
              column (
                4,
                h4("Points"),
                checkboxInput("adptRt", label = "Adoption Rate", value = TRUE),
                checkboxInput("smthRt", label = "Smoothed Adoption Rate", value = FALSE)
              ),
              column (
                4,
                h4("Bands"),
                checkboxInput("confBand", label = "Confidence Band", value = FALSE),
                checkboxInput("predBand", label = "Prediction Band", value = FALSE)
              ),
              column(
                4,
                radioButtons(
                  "xAxis",
                  label = "X axis",
                  choices = list("Ages" = 1, "Years" = 2),
                  selected = 1
                )
              )
            )
          ),
          box(
            width=12,
            fluidRow(column(
              12,
              uiOutput("chooseMarket"),
              uiOutput("chooseElement")
            ))
          ) 
        ),
        box(
          width=9, 
          plotOutput("mainPlot")
        )
      )
  ))
)