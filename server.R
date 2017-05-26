library(shiny)
library(RVAideMemoire)
library(psych)
shinyServer(function(input,output){
    datanya <- reactive({
      inFile <- input$file
      if (is.null(inFile))
        return(NULL)
      read.csv(inFile$datapath, header = input$header)
    })
    
    output$filedf <- renderTable({
      if(is.null(data())){return ()}
      input$file
    })
    output$summary <- renderTable({
      if(is.null(data())){return ()}
      summary(datanya())
    })
    output$table <- renderTable({
      if(is.null(data())){return()}
      datanya()
    })
    output$manual <- renderTable({
      getPValue()
    })
    
    output$package <- renderTable({
      packageOlah()
    })
    
    output$tb <- renderUI({
      if(is.null(data()))
        h5("Powered by", tags$img(src='D:/Data/Kuliah/shinny/www/android.png', height=200, width=200))
      else
        tabsetPanel(tabPanel("About file", tableOutput("filedf")), tabPanel("Data", tableOutput("table")),tabPanel("Summary", tableOutput("summary")),tabPanel("Package", tableOutput("package")),tabPanel("Manual", tableOutput("manual")))
    })
    
    packageOlah <- function(){
      hasil <- as.data.frame(mood.medtest(datanya()[,2]~datanya()[,1])$p.value)
      return(hasil)
    }
    
    getList <- function(...){
      dataf <- datanya()
      parse <- levels(dataf[1,1])
      mylist <- list()
      for(i in 1:length(parse)){
        nilai <- c()
        for(j in 1:length(dataf[,1])){
          if(dataf[j,1]==parse[i]){
            nilai <- c(nilai,dataf[j,2])
          }
        }
        mylist[[i]] <- nilai
      }
      return(mylist)
    }
    
    getMedian <- function(){
      med <- median(unlist(getList()))
      return(med)
    }
    
    getPerlakuanMedian <- function(){
      var1 <- c()
      for(i in 1:length(getList())){
        a <- 0
        b <- 0
        for(j in 1:length(getList()[[i]])){
          if( getList()[[i]][[j]] > getMedian()){
            a <- a+1
          }else{
            b <- b+1
          }
        }
        var1 <- c(var1,a,b)
      }
      return(matrix(var1, byrow = TRUE, length(getList()),2 ))
    }
    
    getPValue <- function(){
      hasil <- as.data.frame(chisq.test(getPerlakuanMedian())$p.value)
      return(hasil)
    }
})