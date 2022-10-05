#' Run an example algorithm from the class
#'
#' @param example Which example to run
#' @return NULL
#' @export

runExample <- function(example) {

  fpath <- system.file("rmd", "step_detection", "step_detection.Rmd", package = "HINF5300")
  if(example == "assignment1") {
    rmarkdown::knit_params_ask(fpath)
  }

  browseURL(file.path(dirname(fpath), "step_detection.html"))

}
