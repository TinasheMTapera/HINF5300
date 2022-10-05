#' Read in a CSV of accelerometer data produced by datalogger
#'
#' @param inputpath the path to the DataLogger input file.
#' @return A dataframe of accelerometer data.
#' @export

read_datalogger_file <- function(inputpath) {

  assertthat::is.readable(inputpath)

  readr::read_csv(inputpath, col_names=FALSE) %>%
    dplyr::transmute(timestamp = X1, X = X2, Y = X3, Z = X4) %>%
    dplyr::mutate(timestamp = lubridate::as_datetime(timestamp/1000000000))

}

#' @export
pivot_and_plot <- function(.data, not_pivoted) {

  .data %>%
    tidyr::pivot_longer(cols = -!!rlang::ensym(not_pivoted)) %>%
    ggplot2::ggplot(aes(x=timestamp, y=value)) +
    ggplot2::geom_line(aes(color=name)) +
    NULL
}

#' @export
filter_signal <- function(
    vec,
    low_pass=0.8,
    high_pass=3.5,
    order=3,
    sampling_rate=100
) {

  b_filt <- signal::butter(
    order,
    c(
      low_pass / ( 0.5 * sampling_rate ),
      high_pass / ( 0.5 * sampling_rate )),
    type="pass")


  signal::filter(b_filt, vec)

}

#' @export
smooth_signal <- function(vec, window_size=5, type="median") {

  if(type=="median") {
    if(window_size %% 2 != 1) {
      window_size = window_size + 1
    }
    output <- zoo::rollmedian(vec, window_size, fill=NA)

  }

  if(type=="mean") {
    output <- zoo::rollmean(vec, window_size, fill=NA)
  }

  if(type=="ewma") {
    output <- pracma::movavg(vec, window_size, type="e")
  }

  output

}

#' @export
detect_steps <- function(
    input_file,
    low_pass=0.1,
    high_pass=1.5,
    smoothing_window_size=5,
    smoothing_type="median",
    detection_type="zero_crossings") {

  if(!(detection_type %in% c("zero_crossings", "peak_detection"))){

    stop("Please select a peak detection algorithm from the
following:\n\n\"peak_detection\"\n\"zero_crossings\"\n")
  }

  if(!(smoothing_type %in% c("median", "mean", "ewma"))){

    stop("Please select a smoothing algorithm from the
following:\n\n\"mean\"\n\"median\"\n\"ewma\"\n")
  }

  clean_data <- read_datalogger_file(input_file) %>%
    dplyr::mutate(mag = sqrt((X^2 + Y^2 + Z^2))) %>%
    dplyr::mutate(clean_signal = mag %>%
             filter_signal(low_pass, high_pass) %>%
             smooth_signal(smoothing_window_size, smoothing_type))

  if(detection_type == "zero_crossings") {
    output <- clean_data %>%
      dplyr::summarise(steps = modelbased::zero_crossings(clean_signal) %>% as.integer()) %>%
      dplyr::pull(steps)
  } else if(detection_type == "peak_detection") {
    output <- clean_data %>%
      dplyr::summarise(steps = quantmod::findPeaks(clean_signal, thresh = 0)  %>% as.integer()) %>%
      dplyr::pull(steps)
  }

  clean_data$step <- NA
  clean_data$step[output] <- TRUE

  clean_data %>%
    mutate(step = ifelse(step, timestamp, NA) %>%
             lubridate::as_datetime())

}
