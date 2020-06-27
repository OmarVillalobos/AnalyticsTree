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

weather <- weather
weather$origin <- as.factor(weather$origin)
weather$wind_dir <- as.factor(weather$wind_dir)
weather <- weather %>% drop_na(wind_dir)

models <- list('Log' = geom_smooth() , 'Linear' = geom_smooth(method = lm, formula = y ~ x))
factors <- list('Drive' = mpg$drv, 'Cyl' = mpg$cyl)
times <- list('Month' = as.factor(as.integer(weather$month)), 'Visibility' = as.factor(as.integer(weather$visib)))

# Define UI for application that draws a histogram
ui <- fluidPage(
    navbarPage(a('Ejercicio Shiny App'),
               tabPanel('House Prices',
                        sidebarLayout(
                          position = 'right',
                          sidebarPanel(selectInput(
                            "model",
                            label = h4("Data model"),
                            choices = names(models)
                          )),
                          
                          # Show a plot of the generated distribution
                          mainPanel(h2('House Prices', align = 'Center'),
                                    plotOutput("house"))
                        )),
               tabPanel('Cars',
                        sidebarLayout(
                          position = 'right',
                          sidebarPanel(selectInput(
                            'factor',
                            label = h4('Only factors'),
                            choices = names(factors)
                          )),
                          
                          # Show a plot of the generated distribution
                          mainPanel(h2('Cars', align = 'Center'),
                                    plotOutput("Cars"))
                        )),
               tabPanel("Weather",
                        sidebarLayout(
                          position = 'right',
                          sidebarPanel(selectInput(
                            'time',
                            label = h4('Options'),
                            choices = names(times)
                          )),
                          
                          # Show a plot of the generated distribution
                          mainPanel(h2('Weather', align = 'Center'),
                                    plotOutput("Time"))
                        ))
    ) 
    # Sidebar with a slider input for number of bins 

)
# Define server logic required to draw a histogram
server <- function(input, output) {

    output$house <- renderPlot({
        ggplot(house_prices, aes(x = as.integer(grade), y =price)) +
        geom_point() +
        models[[input$model]]
    })
    output$Cars <- renderPlot({
      g <- ggplot(mpg, aes(manufacturer))
      g + geom_bar(aes(fill=as.factor(factors[[input$factor]])), width = 0.5) +
        theme(axis.text.x = element_text(angle=65, vjust=0.7)) +
        labs(title="Histogram on Categorical Variable",
             subtitle="Manufacturer across Vehicle Classes")
    })
    output$Time <- renderPlot({
      ggplot(weather, aes(x = wind_dir, fill  = times[[input$time]])) + 
        geom_bar() + 
        coord_polar(theta = "x")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
