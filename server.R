

library(shiny)
library(nortest)

library(htmlwidgets)


shinyServer(function(input, output) {
 
  rgam<- function(n)
    {
    rgamma(n,shape=5)
    ####Generate sample from gamma distribution with shape=5 and scale=1
  }
  
  rbern<- function(n)
  {
    rbinom(n,size=1,prob=0.5)
  }
  
  rpoision<- function(n)
  {
    rpois(n,lambda=1)
  }
  
 res <- reactive({
    
    distn <- switch(input$distribution,
                   d1 = runif,
                   d2 = rnorm,
                   d3 = rexp,
                   d4 = rgam,
                   d5 = rbern,
                   d6 = rpoision)
    mean <- switch(input$distribution,
                    d1 = 0.5,
                    d2 = 0,
                    d3 = 1,
                    d4 = 5,
                    d5 = 0.5,
                    d6 = 1)
    variance <- switch(input$distribution,
                    d1 = 1/12,
                    d2 = 1,
                    d3 = 1,
                    d4 = 5,
                    d5 = 0.25,
                    d6 = 1)
    
    xbar<- NULL
    cc<-1
    while (cc<=500) {
    xdata<- distn(input$N)  
    xbar<- c(xbar,mean(xdata))
    cc<- cc+1
    } 
     mxbar<- mean(xbar)
     sxbar<- sqrt(var(xbar))
     gofout<- ad.test(xbar)
     adts<- gofout$statistic
     adpval<- gofout$p.value
    return(list("mxbar"=mxbar,"sxbar"=sxbar,"xdata"=xdata, "xbar"=xbar, "adts"=adts, "adpval"=adpval,
                "mm"=mean, "sd"=sqrt(variance)))
  })
  
 
 output$plot1 <- renderPlot({
   bins <- seq(min(res()$xdata), max(res()$xdata), length.out = input$binsx + 1)
   hist(res()$xdata, main="Histogram of x", xlab="x", breaks=bins)
   
 })
 output$plot2 <- renderPlot({
   bins <- seq(min(res()$xbar), max(res()$xbar), length.out = input$binsxbar + 1)
   hist(res()$xbar, main="Histogram of sample averages", xlab="xbar", breaks=bins)
 })
 
 output$summary <- renderText({
   #paste("Chisquare Statistic:", res()$x2, "Chisquare p-value:", res()$x2pval, 
   #     "Z2 statistic", res()$crc, "Z2 p-value", res()$crcpval, "Concordance-discordance statistic", res()$cd, 
   #    "Concordance-discordance p-value", res()$cdpval, sep='\n') 
   
   paste("population mean:", round(res()$mm,4), "population standard deviation:", round(res()$sd,4),
     "mean of xbar:", round(res()$mxbar,4), "s.d. of xbar:", round(res()$sxbar,4), 
         "Anderson Darling", round(res()$adts,4),  "Anderson Darling p-value", round(res()$adpval,4),  sep='\n') 
   
   
 })
 
})

