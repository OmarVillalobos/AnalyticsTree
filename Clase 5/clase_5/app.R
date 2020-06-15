#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel('Title goes here'),
    sidebarLayout(
        sidebarPanel('this is a sidebar panel'),
        mainPanel(position = 'Right',
            h1('Main', align = 'Center'), 
            h2('Sub Main'),
            h3('Sub sub main', 
               strong('negritas'),
               em('italica'),
               code('codigo <- 1')),
            p('texto en color ', style = 'color:red' )
        )
    )

)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)
