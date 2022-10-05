
<!-- README.md is generated from README.Rmd. Please edit that file -->

# HINF5300

<!-- badges: start -->
<!-- badges: end -->

This package documents any code and assignments for the
HealthInformatics5300 course at Northeastern University.

## Installation

You can install the development version of HINF5300 from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("TinasheMTapera/HINF5300")
```

## Assignment 1: Step Detection

This assignment was demonstrating how to detect steps from an
accelerometer embedded in a mobile device. The notebook for the
assignment is located at `vignette("assignment1")`:

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
