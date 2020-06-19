#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(janeaustenr)
library(tidytext)
library(tidyverse)
library(shinythemes)
library(shiny)

book_words <- austen_books() %>%
    unnest_tokens(word, text) %>%
    count(book, word, sort = TRUE)

total_words <- book_words %>% 
    group_by(book) %>% 
    summarize(total = sum(n))

book_words <- left_join(book_words, total_words)

freq_by_rank <- book_words %>% 
    group_by(book) %>% 
    mutate(rank = row_number(), 
           `term frequency` = n/total)

# Define UI for application that draws a histogram
ui <- fluidPage(
    #shinythemes::themeSelector(),
    theme = shinytheme('readable'),
    titlePanel('Analyzing word and document frequency'),
    sidebarLayout(
        sidebarPanel(p('A central question in text mining and NLP is how
                     to quantify what a document is about'),
        p('Here, as an a example we will be considering'),
        h3('jane Austen novels'),
        img(src= 'jane.jpg',heigth = 200, width = 150 ),
        br(),
        br(),
        code('by Omar')
    ),
        mainPanel(
            tabsetPanel(
                tabPanel('Goal',
                         br(),
                         br(),
                         h4('Some other options are:'),
                         p(strong('term frequency : '),
                           'How frequently a word occurs in a document.'),
                         p(strong('Inverse document frequency:')),
                           'Decreases the weight for commonly used words and
                            increases those not soo much used.',
                         p('The statistic ', em('tf-idf'), 'is an word 
                           importance measure'),
                         p('The inverse document frequency for any given term
                            is defined as:'),
                         withMathJax("$$ idf(\\text{term})=
                                     \\ln{\\left(\\frac{n_{\\text{documents}}}
                                     {n_{\\text{documents containing term}}}\\right)}  $$")
                         ),
                tabPanel('Data',
                         h4('Summary'),
                         verbatimTextOutput('Summary'),
                         fluidRow(
                             column(7,
                                    h4('Table'),
                                    tableOutput('Table')),
                             column(3,
                                    br(),
                                    br(),
                                    br(),
                                    p(strong('n'), 'the times a word is being used in a given book'),
                                    p(strong('Total'), 'Total number of word in a book.'),
                                    )
                         )),
                tabPanel('Term Frequency Plots ',
                         plotOutput('Plot_tf')),
                tabPanel('Zipfs Law',
                         tableOutput('table_rank'),
                         plotOutput('Plot_zipf'),
                            sliderInput('Rank',
                                         "Number of bins:",
                                         min = 1,
                                         max = 500,
                                         value = c(10,500)),
                         withMathJax('$$ $$')
                             ),
                tabPanel('TF-IDF',
                         plotOutput('Plot_tfidf'),
                         sliderInput('Nwords',
                                     "Number of words:",
                                     min = 1,
                                     max = 30,
                                     value = 10))
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$Summary <- renderPrint({
        summary(austen_books())
    })
    output$Table <- renderTable({
        head(book_words,7)
    })
    output$Plot_tf <- renderPlot({
        ggplot(book_words, aes(n/total, fill = book, alpha = 0.85)) + 
            scale_fill_brewer(palette = 'Spectral') +
            geom_histogram(show.legend = FALSE) +
            xlim(NA, 0.0009) +
            facet_wrap(~book, ncol = 2, scales = "free_y") + 
            theme_minimal()
    })
    output$table_rank <- renderTable({
        head(freq_by_rank)
    })
    rank_subset <- reactive({
        freq_by_rank %>%
            filter(rank < input$Rank[2],
                   rank > input$Rank[1])
    })
    output$Plot_zipf <- renderPlot({
        fitvals <- lm(log10(`term frequency`) ~ log10(rank), data = rank_subset())
        freq_by_rank %>% 
            ggplot(aes(rank, `term frequency`, color = book)) + 
            geom_abline(intercept = fitvals$coefficients[1],
                        slope = fitvals$coefficients[2], color = "gray50", linetype = 2) +
            geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) + 
            geom_vline(xintercept = c(input$Rank[1],input$Rank[2]),
                       color = c("blue", "red")) +
            scale_x_log10() +
            scale_y_log10()
    })
    output$Plot_tfidf <- renderPlot({
        book_words <- book_words %>%
            bind_tf_idf(word, book, n)
        
        book_words %>%
            select(-total) %>%
            arrange(desc(tf_idf))
        
        book_words %>%
            arrange(desc(tf_idf)) %>%
            mutate(word = factor(word, levels = rev(unique(word)))) %>% 
            group_by(book) %>% 
            top_n(input$Nwords) %>% 
            ungroup() %>%
            ggplot(aes(word, tf_idf, fill = book)) +
            geom_col(show.legend = FALSE) +
            labs(x = NULL, y = "tf-idf") +
            facet_wrap(~book, ncol = 2, scales = "free") +
            coord_flip()
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
