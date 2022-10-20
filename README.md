
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HINF5300

<!-- badges: start -->
<!-- badges: end -->

This package documents any code and assignments for the
HealthInformatics5300 course at Northeastern University.

You can view the website for this package on
[GitHub](https://tinashemtapera.github.io/HINF5300/) for more detailed
instructions and details.

## Installation

You can install the development version of HINF5300 from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("TinasheMTapera/HINF5300")
```

Docker installation instructions coming soon…

## Assignment 1: Step Detection

This assignment was demonstrating how to detect steps from an
accelerometer embedded in a mobile device. The notebook for the
assignment is located at `vignette("assignment1")` (online), or locally
[here](./articles/assignment1.html) (with source code located in
`./vignettes/assignment1.Rmd`)

Assignment 1 can be run quickly R like so:

``` r
library(HINF5300)
library(dplyr)
## basic example code

steps_df <- detect_steps(system.file("extdata", "acce.csv", package = "HINF5300"))
steps_df %>%
  summarise(n_steps = sum(!is.na(step)))
#> # A tibble: 1 × 1
#>   n_steps
#>     <int>
#> 1      47
```
