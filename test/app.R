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
   
   # Application title
   titlePanel("Old Faithful Geyser Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("bins",
                     "Number of bins:",
                     min = 1992,
                     max = 2013,
                     value = 1)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      lumData <- read_csv("../data/final/tun_lum_governorate_93_13_tidy.csv")
      lumData2013 <- lumData[lumData$year == input$bins,]
      
      
      
      # x    <- faithful[, 2] 
      # bins <- seq(min(x), max(x), length.out = input$bins + 1)
      # 
      # # draw the histogram with the specified number of bins
      # hist(x, breaks = bins, col = 'darkgray', border = 'white')
      
      ggplot(lumData2013, aes(x = mean, y = fct_reorder(NAME_1, mean))) +
        geom_point(color = "blue") + ylab("") +
        ggtitle("Luminosity per Governovates in 2013 (mean)")
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

