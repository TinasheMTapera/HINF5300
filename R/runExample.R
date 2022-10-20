#' Run an example algorithm from the class
#'
#' @param example Which example to run
#' @return NULL
#' @export

runExample <- function(example, output_directory) {

  if(example == "assignment1") {

    template <- system.file("rmd", "step_detection", "step_detection.Rmd", package = "HINF5300")

    output_file <- file.path(wd, "StepDetectionReport.html")

    rmarkdown::render(template, params="ask", output_file = output_file)

    browseURL(output_file)

    return()

  } else {
    stop("Please select and input an assignment from the following:
\n\n\"assignment1\"\n")
  }

}
