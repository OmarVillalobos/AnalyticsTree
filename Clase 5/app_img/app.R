#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# library(shiny)
# 
# # Define UI for application that draws a histogram
# ui <- fluidPage(
#     titlePanel('Title goes here'), 
#     sidebarLayout(
#         sidebarPanel(),
#         mainPanel(
#             img(src ='sunrise-1756274_1920.jpg', height = 200, width = 350),
#             h2('Table like'),
#             fluidRow(
#                 column(3, 'test1'))
#         )
#     )
# 
# )
# 
# # Define server logic required to draw a histogram
# server <- function(input, output) {
# 
# }
# 
# # Run the application 
# shinyApp(ui = ui, server = server)

data <- data.frame(murder = USArrests$Murder, state = tolower(rownames(USArrests))) 
map <- map_data("state") 
l <- ggplot(data, aes(x = murder))
l + geom_map(aes(map_id = state), map = map) + 
    expand_limits(x = map$long, y = map$lat)