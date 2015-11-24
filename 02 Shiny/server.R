# server.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)
require(shinydashboard)
require(leaflet)
require(DT)

shinyServer(function(input, output) {
        
      KPI_Low_Max_value <- reactive({input$KPI1})     
      KPI_Medium_Max_value <- reactive({input$KPI2})
      rv <- reactiveValues(alpha = 0.50)
      observeEvent(input$light, { rv$alpha <- 0.50 })
      observeEvent(input$dark, { rv$alpha <- 0.75 })
    
      df1 <- eventReactive(input$clicks1, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
"select Age, Decade, Count
From BirthsByAge1
order by Decade, Age;"
')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_vc7674', PASS='orcl_vc7674', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON', verbose = TRUE))))
      })
      output$distPlot1 <- renderPlot({             
            plot <- ggplot() + 
              coord_cartesian() +
              scale_x_discrete() +
              scale_y_discrete() +
              labs(x=paste("AGE"), y=paste("DECADE")) +
              layer(data=df1(), 
                    mapping=aes(x=AGE, y=DECADE, label=COUNT), 
                    stat="identity", 
                    stat_params=list(), 
                    geom="text",
                    geom_params=list(colour="black", size = 3), 
                    position=position_identity()
              ) +
              theme(axis.text.x = element_text(angle = 90, hjust = 1)
              ) +
              layer(data=df1(), 
                    mapping=aes(x=AGE, y=DECADE, fill=DECADE), 
                    stat="identity", 
                    stat_params=list(), 
                    geom="tile",
                    geom_params=list(alpha=rv$alpha), 
                    position=position_identity()
              )
              plot
      }) 

      observeEvent(input$clicks, {
            print(as.numeric(input$clicks))
      })

# Begin code for Second Tab:

      df2 <- eventReactive(input$clicks2, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
"select Year,Age,Count
from BirthsByAge;"
')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_vc7674', PASS='orcl_vc7674', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON', verbose = TRUE))))
        })

      output$distPlot2 <- renderPlot(height=750, width=1500, {
            plot1 <- ggplot() + 
              coord_cartesian() + 
              scale_x_continuous() +
              scale_y_continuous() +
              labs(title='Births Over History - By Age') +
              labs(x="YEAR", y=paste("COUNT")) +
              layer(data=df2(), 
                    mapping=aes(x=as.numeric(as.character(YEAR)), y=COUNT, color=AGE), 
                    stat_params=list(), 
                    geom="point",
                    geom_params=list(), 
                    #position=position_identity()
                    position=position_jitter(width=0.3, height=0)
              )
              plot1
      })

# Begin code for Third Tab:

      df3 <- eventReactive(input$clicks3, {df1 <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
"SELECT Age, SUM(Count) As Count
FROM BirthsByAge
GROUP BY Age;;"
')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_vc7674', PASS='orcl_vc7674', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON', verbose = TRUE))))
      })
      output$distPlot3 <- renderPlot(height=750, width=1500, {
            plot3 <- ggplot() + 
              coord_cartesian() + 
              scale_x_discrete() +
              scale_y_continuous(breaks=seq(0,7000000,1000000)) +
              labs(title='Births Cumulative - By Age') +
              labs(x=paste("AGE"), y=paste("COUNT")) +
              layer(data=df3(), 
                    mapping=aes(x=AGE, y=COUNT), 
                    stat = "identity",
                    stat_params=list(), 
                    geom="bar",
                    geom_params=list(),
                    position=position_identity()
              )
              plot3
      })
})
