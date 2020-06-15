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

models <- list('Log' = geom_smooth() , 'Linear' = geom_smooth(method = lm, formula = y ~ x))



# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Ejercicio Shiny App"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(position = 'right',
        sidebarPanel(
            selectInput("model", label = h4("Data model"), choices = names(models))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           h2('House Prices', align = 'Center'),
           plotOutput("house")
        )
    ),
    sidebarLayout(position = 'right',
                  sidebarPanel(
                      sliderInput("bins",
                                  "Number of bins:",
                                  min = 1,
                                  max = 50,
                                  value = 30)
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
        # draw the histogram with the specified number of bins
        ggplot(house_prices, aes(x = grade, y =price)) +
            geom_point() +
            models[[input$model]]
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
