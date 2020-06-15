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
ui <- fluidPage(positions = 'Left',
    titlePanel('The Earth'), 
    sidebarLayout(
        sidebarPanel(
            h3('Alternate Names'),
            p('Terra, Tellus, Gaia, Gaea, the World, the Globe'),
            img(src ='sunrise-1756274_1920.jpg', height = 130, width = 230, ),
            br(),
            'Sunrise',
            ),
        mainPanel(
           h1('Earth'),
           p('Earth is the third planet from the Sun and the only astronomical object known to harbor life. 
             According to radiometric dating estimation and other evidence, Earth formed over 4.5 billion years ago. 
             Earths gravity interacts with other objects in space, especially the Sun and the Moon, which is Earths 
             only natural satellite. Earth orbits around the Sun in 365.256 solar days, a period known as an Earth sidereal year. 
             During this time, Earth rotates about its axis 366.256 times, that is, a sidereal year has 366.256 sidereal days '),
           p(strong('The link is:')),
           a('IERS',
           href = ' https://www.iers.org/IERS/EN/Home/home_node.html')
        )
    )

)

# Define server logic required to draw a histogram
server <- function(input, output) {


}

# Run the application 
shinyApp(ui = ui, server = server)
