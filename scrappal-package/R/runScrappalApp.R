#' Run interactive shiny app.
#' @import shiny
#' @export
#' @examples \dontrun{
#' runScrappalApp()
#'}
runScrappalApp <- function(){
# Code adapted from:
# http://www.r-bloggers.com/supplementing-your-r-package-with-a-shiny-app/
  appDir <- system.file("shiny_app", package = "scrappal")
  shiny::runApp(appDir, display.mode = "normal")
}