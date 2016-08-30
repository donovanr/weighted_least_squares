library(shiny)

shinyServer(function(input, output) {
  
  observeEvent(input$formula, { # rerun if input formula gets resubmitted
  
    formula <- reactive({
      user_text_formula <- input$formula
      user_formula <- as.formula(user_text_formula)
    })
    
    coefs <- reactive({
      formula_vars <- all.vars(formula())
      coefs <- setdiff(formula_vars,c('x','y'))
    })
    
    starting_vals <- reactive({
      L <- list()
      for (coef in coefs()) {
        L[coef] = 1
      }
      L
    })
    
    lower_limits <- reactive({
      L <- list()
      for (coef in coefs()) {
        L[coef] = 0
      }
      L
    })
    
    output$formula_text <- renderText({
      deparse(formula())
    })
    
    data <- reactive({
      
      if (is.null(input$file1))
        return(NULL)
      
      df <- read.csv(input$file1$datapath, header=input$header, sep=input$sep,
                     quote='"')
      colnames(df) <- c('x','y','w')
      df
    })
    
    fit_data <- reactive({
      
      if (is.null(input$file1))
        return(NULL)
      
      df_data <- data()
      
      # fit data
      nls(formula(),
          data = df_data,
          weights = w,
          start = starting_vals(),
          lower = lower_limits(),
          # algorithm = "port",
          control=nls.control(maxiter=1000)
          )
    })
    
    output$contents <- renderTable({
      
      if (is.null(input$file1))
        return(NULL)
      
      data()
      
    })
    
    # read input file and generate nonlinear least squares fit
    output$distPlot <- renderPlot({
      
      if (is.null(input$file1))
        return(NULL)
      
      # dataframe from input
      df_data <- data()
      
      # fit data
      fit <- fit_data()
      
      # make a dense grid for plotting
      x_grid <- data.frame(x=seq(min(df_data$x),max(df_data$x),len=1000))
      df_grid <- data.frame(
        x=x_grid,
        y=predict(fit, newdata = x_grid)
      )
      
      # simple plot
      plot(df_data$x,df_data$y, frame.plot = FALSE, xlab="x", ylab="y", cex.lab=2, cex.axis=1.5)
      lines(df_grid$x,df_grid$y, lwd=3, col='steelblue3')
    })
    
    output$coefficients <- renderTable({
      
      if (is.null(input$file1))
        return(NULL)
      
      fit <- fit_data()
      summary(fit)$coefficients
    })
  
  }) # rerun if input formula gets resubmitted
  
})
