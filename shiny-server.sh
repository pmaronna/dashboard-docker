#!/bin/sh

# Make sure the directory for individual app logs exists
mkdir -p /var/log/shiny-server
mkdir -p /var/log/ui
chown shiny.shiny /var/log/shiny-server
chown shiny.shiny /var/log/ui

/usr/bin/Rscript /srv/services/objectives.R & 
/usr/bin/Rscript /srv/services/sales_yesterday.R &
/usr/bin/Rscript /srv/services/sales_last_week.R &
/usr/bin/Rscript /srv/services/sales_today.R &
exec shiny-server >> /var/log/shiny-server.log 2>&1
