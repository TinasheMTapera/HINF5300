FROM rocker/rstudio:4.2.1

# update libz-dev for httpuv
RUN apt update && apt install --yes --force-yes \
  libz-dev zlib1g zlib1g-dev libfontconfig1-dev

ENV RENV_VERSION 0.16.0
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

WORKDIR /project
COPY . .

ENV RENV_PATHS_LIBRARY renv/library

RUN R -e "renv::restore()"

RUN R -e "devtools::build()"
