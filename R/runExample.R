#' Run an example algorithm from the class
#'
#' @param example Which example to run
#' @return NULL
#' @export

runExample <- function(example, output_directory) {

  template <- system.file("rmd", "step_detection", "step_detection.Rmd", package = "HINF5300")

  output_file <- file.path(wd, "StepDetectionReport.html")

  print(output_file)
  if(example == "assignment1") {

    rmarkdown::render(template, params="ask", output_file = output_file)

  } else {
    stop("Please select and input an assignment from the following:
\n\n\"assignment1\"\n")
  }

  browseURL(output_file)

}
