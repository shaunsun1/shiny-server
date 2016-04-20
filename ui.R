library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Central Limit Theorem Demonstrations"),
  
  # Sidebar with controls to select the random distribution type
  # and number of observations to generate. Note the use of the
  # br() element to introduce extra vertical spacing
  sidebarLayout(
    sidebarPanel(
      sliderInput("N", 
                  "Sample size:", 
                  value = 50,
                  min = 0, 
                  max = 200, step=5),
      
      br(),
      radioButtons("distribution", "Generating samples from:",
                   c("uniform" = "d1",
                     "normal" = "d2",
                     "exponential" = "d3",
                     "gamma(shape=5)" = "d4",
                     "bernoulli(p=0.5)" = "d5",
                     "poisson(mean=5)" = "d6"
                     )),
      br(),
      submitButton("Submit"),
      br(),
      sliderInput("binsx",
                  "Number of bins in x histogram:",
                  min = 5,
                  max = 20,
                  value = 10),
    br(),
    sliderInput("binsxbar",
                "Number of bins in xbar histogram:",
                min = 5,
                max = 20,
                value = 10)
    ),
    
    # Show a tabset that includes a plot, summary, and table view
    # of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("histogram x", plotOutput("plot1")), 
                  tabPanel("histogram xbar", plotOutput("plot2")), 
                  tabPanel("Summary", verbatimTextOutput("summary"))
      )
    )
  )
  )
)
