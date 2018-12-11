library(shiny)
library(choroplethr)
library(choroplethrAdmin1)
library(choroplethrMaps)
library(choroplethrZip)
library(tidyverse)
library(here)

library(rsconnect)

ui <- fluidPage(
  
  # Application title
  
  tags$h3("Explore luminosity over time by Tunisian governorates"),
  tags$h5("For a GIF version of the original NASA satellite imagery used,"),
  tags$head(tags$style("#number{
                       display:inline
                       }")), h5('please visit:',style="display:inline"), a(href= "https://github.com/mariemayadi/data/blob/master/luminosityOverTimeTunisia.gif", "Luminosity GIF"),

  
  plotOutput('mapLum'),
  
  hr(),
  
  fluidRow(
    column(3),
    column(4, offset = 1,
           sliderInput("years",
                       "Choose a year:",
                       min = 1992,
                       max = 2013,
                       value = 1,
                       sep = "")
    ),
    column(4)
  ),
  hr(),
  plotOutput('dotplot')
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$dotplot <- renderPlot({

      lumData <- read.csv(url("https://raw.githubusercontent.com/mariemayadi/data/master/tun_lum_governorate_93_13_tidy.csv"))
      lumData2013 <- lumData[lumData$year == input$years,]
      
      ggplot(lumData2013, aes(x = mean, y = fct_reorder(NAME_1, mean))) +
        geom_point(color = "black") + ylab("") +
        ggtitle("Ranking of governorates by luminosity",
                subtitle = "Country: Tunisia") +
        labs(x="Mean Luminosity (watts/cm\u00b2)", caption = "Source: L'Institut National de la Statistique (INS)") +
        theme(plot.title = element_text(face = "bold")) +
        theme(plot.subtitle = element_text(face = "bold", color = "grey35")) +
        theme(plot.caption = element_text(color = "grey68"))

   })
   
   output$mapLum <- renderPlot({
     lumData <- read.csv(url("https://raw.githubusercontent.com/mariemayadi/data/master/tun_lum_governorate_93_13_tidy.csv"))
     lumData2013 <- lumData[lumData$year == input$years,]
     
     tidyLum13 <- lumData2013 %>% select(NAME_1, mean)
     tidyLum13 <- filter(tidyLum13, !NAME_1 %in% c("Ariana"))
     tidyLum13$NAME_1 <- c("gouvernorat de kebili","gouvernorat de kef","gouvernorat de mahdia","gouvernorat de la manouba","gouvernorat de medenine","gouvernorat de monastir","gouvernorat de nabeul","gouvernorat de sfax","gouvernorat de sidi bou zid","gouvernorat de siliana","gouvernorat de sousse","gouvernorat de beja","gouvernorat de tataouine","gouvernorat de tozeur","gouvernorat de tunis","gouvernorat de zaghouan","gouvernorat de ben arous","gouvernorat de bizerte","gouvernorat de gabes","gouvernorat de gafsa","gouvernorat de jendouba","gouvernorat de kairouan","gouvernorat de kasserine")
     
     df = data.frame(region=tidyLum13$NAME_1, value=as.numeric(as.character(tidyLum13$mean)))
     
     admin1_region_choropleth(df, legend = "Mean luminosity (watts/cm\u00b2)") +
       ggtitle("Map of luminosity by Governorates",
               subtitle = "Country: Tunisia") +
       labs(caption = "Source: L'Institut National de la Statistique (INS)") +
       theme(plot.title = element_text(face = "bold")) +
       theme(plot.subtitle = element_text(face = "bold", color = "grey35")) +
       theme(plot.caption = element_text(color = "grey68"))
     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

