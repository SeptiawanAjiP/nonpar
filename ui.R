library(shiny)

shinyUI(fluidPage(
  titlePanel("Kelompok 4 - Perluasan Median"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file","Upload file"),
      helpText("Maksimal ukuran file 5 MB"),
      tags$hr(),
      h5(helpText("Jadikan baris pertama sebagai heade")),
      checkboxInput(inputId = "header", label = "Ya", value = FALSE),
      br(),
      radioButtons(inputId = 'sep', label = 'Separator', choices = c(Comma=',',Semicolon=';',Tab='\t',Space=' '), selected = ',')
    ),
    mainPanel(
      uiOutput("tb")
    )
  )
))