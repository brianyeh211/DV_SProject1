#ui.R

require(shiny)
require(shinydashboard)
require(leaflet)

dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Crosstab", tabName = "crosstab", icon = icon("dashboard")),
      menuItem("Scatterplot", tabName = "scatterplot", icon = icon("th")),
      menuItem("Barchart", tabName = "barchart", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "crosstab",
        actionButton(inputId = "light", label = "Light"),
        actionButton(inputId = "dark", label = "Dark"),
        sliderInput("KPI1", "KPI_Low_Max_value:", 
                    min = 1, max = 4750,  value = 4750),
        sliderInput("KPI2", "KPI_Medium_Max_value:", 
                    min = 4750, max = 5000,  value = 5000),
        textInput(inputId = "title", 
                  label = "Crosstab Title",
                  value = "Birth By Age"),
        actionButton(inputId = "clicks1",  label = "Click me"),
        plotOutput("distPlot1")
      ),
      
      # Second tab content
      tabItem(tabName = "scatterplot",
        actionButton(inputId = "clicks2",  label = "Click me"),
        plotOutput("distPlot2")
      ),
      
      # Third tab content
      tabItem(tabName = "barchart",
        actionButton(inputId = "clicks3",  label = "Click me"),
        plotOutput("distPlot3")
      )
    )
  )
)
  