#' Read in a CSV of accelerometer data produced by datalogger
#'
#' @param inputpath the path to the DataLogger input file.
#' @return A dataframe of accelerometer data.

read_datalogger_file <- function(inputpath, ...) {

  assertthat::is.readable(inputpath)

  readr::read_csv(inputpath, col_names=FALSE) %>%
    transmute(timestamp = X1, X = X2, Y = X3, Z = X4) %>%
    mutate(timestamp = lubridate::as_datetime(timestamp/1000000000))

}

pivot_and_plot <- function(.data, not_pivoted) {

  .data %>%
    pivot_longer(cols = -!!rlang::ensym(not_pivoted)) %>%
    ggplot(aes(x=timestamp, y=value)) +
    geom_line(aes(color=name)) +
    NULL
}
