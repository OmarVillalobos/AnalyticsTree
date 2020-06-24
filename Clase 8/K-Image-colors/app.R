#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidymodels)
library(tidyverse)
library(imager)

#file <- "www/autumn_drawing_walking_82963_320x480.jpg"

#im <- load.image(file)
get_k_colors <- function(i, n) { 
    tmp <- as.data.frame(i, wide="c")
    tmp <- kmeans(tmp[,c(3,4,5)], centers = n)
    return (rgb(tmp$centers))
}


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            fileInput("file", "Select Image :",
                      accept = c('image/png', 'image/jpeg','image/jpg')),
            textInput("url", "URL", "")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           imageOutput(outputId = "img"),
           htmlOutput('url_img')
        )
    ),
    sidebarLayout(
        sidebarPanel(
            sliderInput("clusters",
                        "Number of Colors:",
                        min = 1,
                        max = 15,
                        value = 3)
        ),
        mainPanel(
            plotOutput("kcolors")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    tmp <- reactive({
        if (is.na(input$file$datapath)) {
            return (input$url)
        } else {
            return (gsub("\\\\", "/", input$file$datapath))
        }
    })
    
    output$url_img <-renderText({c('<img src="',input$url,'",width="200" height="100">')})
    
    output$img <- renderImage({
        list(src = tmp(),
             width = '25%')
        
    },deleteFile = FALSE)
    output$kcolors <- renderPlot({
        im <- load.image(gsub("\\\\", "/", input$file$datapath))
        tmp <- get_k_colors(im,input$clusters)
        ggplot(as.data.frame(tmp), aes(x = tmp)) +
            geom_bar(size = 25,  fill = tmp)

        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
