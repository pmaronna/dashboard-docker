FROM r-base:latest

MAINTAINER Pablo Maronna "pablo.maronna@gmail.com"

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libmysqld-dev \
    libxml2 \
    libxml2-dev \
    libxt-dev \
    mysql-client \
    xml2

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

RUN R -e "install.packages(c('shiny', 'rmarkdown', 'tm', 'wordcloud', 'memoise', 'RMySQL', 'shinydashboard', 'dplyr', 'devtools', 'DBI', 'RCurl', 'DT'), repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('highcharter')"

RUN mkdir -p /srv/data/
RUN chown -R shiny.shiny /srv/data
RUN mkdir -p /srv/ui/
RUN mkdir -p /srv/services/
RUN mkdir -p /etc/shiny-server/

EXPOSE 80

CMD ["/usr/bin/shiny-server.sh"]
