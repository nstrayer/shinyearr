#
# A small demo app for the shinyearr package
#

library(shiny)
library(shinyearr)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(
  h1("shinyearr demo"),
  p("Click on the button below to record the a sound. After your recording is done a plot will display your results in terms of the fourier transformed sound signal decomposed into 256 sequential frequencies."),
  shinyearrUI("my_recorder"),
  plotOutput("frequencyPlot")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  recorder <- callModule(shinyearr, "my_recorder")

  observeEvent(recorder(), {
    my_recording <- recorder()

    # Generate a plot of the recording we just made
    output$frequencyPlot <- renderPlot({

      data_frame(value = my_recording, frequency = 1:256) %>%
        ggplot(aes(x = frequency, y = value)) +
        geom_line() +
        labs(title = "Frequency bins from recording")
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)
