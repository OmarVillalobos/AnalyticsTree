
# https://www.tidymodels.org/
#https://shiny.rstudio.com/images/shiny-cheatsheet.pdf
library(shiny)
library(tidymodels)

overviews_keys <- c("tidymodels","rsample","parsnip","recipes","workflows","tune",
                    "yardstick","broom","dials")

# Define UI for application
ui <- fluidPage(
    navbarPage(
        #theme = shinytheme(),
        # theme = "cerulean",  # <--- To use a theme, uncomment this
        # p("Tidymodels", style="color:firebrick"),
        a("Tidymodels", style="color:firebrick", href="https://www.tidymodels.org/"),
        tabPanel("Installation",
                 fluidRow(
                     column(5, img(src = "tidymodels.png", hight=300, width = 300),
                            br(), br(),
                            h3('Omar Villalobos', align = 'Left')),
                     column(3,
                            h3("TIDYMODELS"), br(),
                            p("The tidymodels framework is a collection of packages for modeling 
                            and machine learning using", strong("tidyverse"),"principles."), 
                            p("Install tidymodels with:"),
                            br(),br(), code("install.packages(\"tidymodels\")"), br(),br(),
                            p("Run", em("library(tidymodels)"), "to load the core packages and make 
                              them available in your current R session"))
                 )
                ),
        tabPanel("Packages", 
                 h3("CORE TIDYMODELS"),
                 uiOutput(outputId = "logo"),
                 p("The core tidymodels packages work together to enable a wide variety of modeling approaches."),
                 selectInput("state", "Choose a tidymodel library:",
                             list(`package` = overviews_keys) # hacer una lista limpia con los paquetes principales
                             ),
                 # verbatimTextOutput("result"),
                 htmlOutput('descr'),
                 #htmlOutput("result")
                 
                 ),
        tabPanel("Learn", "This panel is intentionally left blank",
                     tabsetPanel(
                         tabPanel("Perform Statistical Analysis",
                                  h4("Table"),
                                  tableOutput("table"),
                                  h4("Verbatim text output"),
                                  verbatimTextOutput("txtout"),
                                  h1("Header 1"),
                                  h2("Header 2"),
                                  h3("Header 3"),
                                  h4("Header 4"),
                                  h5("Header 5")
                         ),
                         tabPanel("Tab 2", "This panel is intentionally left blank"),
                         tabPanel("Tab 3", "This panel is intentionally left blank")
                     )
                 
                 )
    )

)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    output$txtout <- renderText({
        paste(input$txt, input$slider, format(input$date), sep = ", ")
    })
    output$table <- renderTable({
        head(cars, 4)
    })
    # output$result <- renderText({
    #     paste(overviews_descriptions[input$state])
        #HTML(overviews_descriptions[input$state])
    # })
    output$logo <- renderUI({
        tags$img(src = paste0("./", input$state, ".png"), hight = 100, width = 100)
    })
    output$descr <- renderUI({
        tmp <- tags$div(includeHTML(paste0("https://", input$state ,".tidymodels.org/")))
        print(tmp)
        # tags$div(class = "rmd-class",
        #          includeHTML(paste0("https://", input$state ,".tidymodels.org/")))
    })
}

# Run the application 
shinyApp(ui, server)
