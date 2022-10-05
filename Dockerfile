FROM rocker/rstudio:4.2.1

# Get and install system dependencies
RUN apt update && apt install --yes --force-yes \
  libz-dev zlib1g zlib1g-dev libfontconfig1-dev \
  libharfbuzz-dev libfribidi-dev \
  libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev

ENV RENV_VERSION 0.16.0
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')" \
  && R -e "install.packages('devtools', repos = c(CRAN = 'https://cloud.r-project.org'))"
  && R -e "devtools::install_github('r-hub/sysreqs')"

WORKDIR /project
COPY . .

RUN sudo apt update \
 && R -e "system(sysreqs::sysreq_commands('DESCRIPTION', 'linux-x86_64-ubuntu-gcc'))"

ENV RENV_PATHS_LIBRARY renv/library

RUN R -e "renv::restore()"

RUN R -e "devtools::build()"
