# COVER LETTER FOR RSTUDIO INTERNSHIP
library(shiny)
library(png)
source('SQL_Info.R') #source file with hidden SQL credentials

shinyApp(
    ui = fluidPage(
        titlePanel("Click below to generate the cover letter (can take up to 30 seconds)"),
        selectInput("reportFormat", "Choose Format",choices = c("No Sidebar Info","With Sidebar Info"),
                    selected="No Sidebar Info" ),
        downloadButton("report", "Generate Cover Letter"),
        titlePanel("This cover letter was made by Riccardo Esclapon for the RStudio 2019 summer internship position."),
        titlePanel(img(src = "RStudio.PNG",height = 245, width = 700)) 
    ),
    server = function(input, output) {
        output$report <- downloadHandler(
            filename = "RiccardoEsclaponCoverLetter.pdf",
            content = function(file) {
                if(input$reportFormat=="With Sidebar Info"){
                    tempReport <- file.path(tempdir(), "RStudioTwentySecondsFormat.Rmd")
                    file.copy("RStudioTwentySecondsFormat.Rmd", tempReport, overwrite = TRUE)
                } else if (input$reportFormat=="No Sidebar Info"){
                    tempReport <- file.path(tempdir(), "RStudioCoverLetter.Rmd")
                    file.copy("RStudioCoverLetter.Rmd", tempReport, overwrite = TRUE)
                }
                # Set up parameters to pass to Rmd document
                params <- list(date = Sys.Date())
                # Knit the document, passing in the `params` list, and eval it in a
                # child of the global environment (this isolates the code in the document
                # from the code in this app).
                rmarkdown::render(tempReport, output_file = file,
                                  params = params,
                                  envir = new.env(parent = globalenv())
                )
            }
        )
    }
)

