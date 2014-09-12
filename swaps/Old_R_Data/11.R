require(shiny)

shinyUI(pageWithSidebar(
  
  ###  Application title
  headerPanel("Italian population between 2002 and 2011"),
  
  ### Sidebar with sliders and HTML
  sidebarPanel(
    # Slider: choose class width
    sliderInput("ampiezza", "Class width (years):", min=1, max=10, value=5),
    # Slider: choose year
    sliderInput("anno", "Year:", min=2002, max=2011, value=2011, format = "0000", animate = TRUE), 
    # HTML info
    div(style = "margin-top: 30px; width: 200px; ", HTML("Developed by")),
    div(style = "margin-top: 10px; ", HTML("<a href='http://www.quantide.com'><img style='width: 150px;' src='http://www.quantide.com/images/quantide.png' /></a><img style='float: right; width: 150px;' src='http://www.nicolasturaro.name/logoWeb300.png' />")),
    div(style = "margin-top: 30px;", HTML("Source: <a href='http://demo.istat.it/'>ISTAT - Istituto Nazionale di Statistica</a>"))
  ),
  
  ### Main Panel
  mainPanel(
    # Show the plot
    plotOutput("pyramid", height="600px")
  )
))