library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = "bootstrap.css",
  
  # Application title
  titlePanel("Nonlinear Regression"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      
      fileInput('file1', 'Upload CSV Data File:',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv')),
      h5("Format Requirements:"),
      p(a("CSV files", href="https://support.office.com/en-us/article/Import-or-export-text-txt-or-csv-files-5250ac4c-663c-47ce-937b-339e391393ba"),
        " are comma separated text files (you can use Excel to export a csv file)."),
      p("Your CSV data file should have three columns:",
        br(),
        "x values, y values, and weights."),
      h5("Format Options:"),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      checkboxInput('header', label="File includes header (column names)", value=TRUE),
    
      br(),
      
      textInput("formula", "Regression Formula:", "y ~ a + b*x + c*x^2"),
      p("Here x is the independent variable, is y the dependent variable, 
        and all others non-numeric terms are coefficients to be estimated.
        Must be a valid R formula (note: ~, not =)"),
      submitButton("Submit New Formula")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      withMathJax(),
      h2('Nonlinear weighted least squares fit using', align = "center"),
      h3(textOutput("formula_text"), align = "center"),
      
      plotOutput("distPlot"),
      hr(),
      
      fluidRow(
        column(6,
          h3('Estimates of Coefficients'),
          tableOutput('coefficients')      
        ),
        column(6,
          h3('Input Data'),
          tableOutput('contents')
        )
      )
    )
  )
))
