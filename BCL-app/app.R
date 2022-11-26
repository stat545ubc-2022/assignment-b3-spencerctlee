library(shiny)
library(tidyverse) 
library(DT)

bcl <- read_csv("bcl-data.csv")

# Define UI for application that outputs a DT table, number of products filtered, and download to csv button.
ui <- fluidPage(
  titlePanel("BC Liquor Data Table"),   # title panel
  
  sliderInput("priceInput", "Price",   #slider to filter prices
             0, 100,                  # Allows max price of 100 and min of 0.
             value = c(10,40), pre ="$"), # default at 10 and 40 for sliders
  
 textOutput("nrows"), 
  
  mainPanel(
      DT::dataTableOutput("bcltable")
            ),
  # Download table
   downloadButton("downloadcsv", "Download .csv Here")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  # This renders the table as an interactive DT data table.
    output$bcltable <- DT::renderDataTable({bcl %>%
        filter(Price > input$priceInput[1] &
                 Price < input$priceInput[2])
      # This filters the table with the filtering parameters priceInput in UI     
       })
       # Shows how many rows are filtered, and returns we found n products.
       output$nrows <- renderText({paste("We found", nrow(bcl %>%
              filter(Price > input$priceInput[1] &
              Price < input$priceInput[2])), "products.")
       })
       # This function names the csv file and outputs the filtered products with price
       output$downloadcsv <- downloadHandler(
            filename = function() {
              paste(Sys.Date(), '-bcl', '.csv', sep = '') # parameters for naming file (yyyy-mm-dd-bcl.csv)
            }, 
            content = function(file) { # This filters based on slider input and writes file with write.csv
              write.csv((bcl %>%
                  filter(Price > input$priceInput[1] &
                  Price < input$priceInput[2])), file) 
            }
            )
}

shinyApp(ui = ui, server = server)
