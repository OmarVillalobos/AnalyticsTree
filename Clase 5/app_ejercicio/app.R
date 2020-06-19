#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(moderndive)
library(colourpicker)
library(patchwork)

# Data
house_prices <- house_prices %>% mutate(
    log10_price = log10(price), log10_size = log10(sqft_living))

mpg <- mpg

models <- list('Log' = geom_smooth() , 'Linear' = geom_smooth(method = lm, formula = y ~ x))

fators <- list('Condition' = condition, 'Bedrooms' = bedrooms)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Ejercicio Shiny App"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(position = 'right',
        sidebarPanel(
            selectInput("model", label = h4("Data model"), choices = names(models)
                        )
        ),

        # Show a plot of the generated distribution
        mainPanel(
           h2('House Prices', align = 'Center'),
           plotOutput("house")
        )
    ),
    sidebarLayout(position = 'right',
                  sidebarPanel(
                      selectInput('factor', label = h4('Only factors'), choices = names(factors)
                                  )
                      
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
          h2('House Prices', align = 'Center'),
          plotOutput("distPlot2")
      )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$house <- renderPlot({
        ggplot(house_prices, aes(x = as.integer(grade), y =price)) +
        geom_point() +
        models[[input$model]]
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
