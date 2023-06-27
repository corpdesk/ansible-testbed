#!/bin/bash

# Ref: https://dev.to/tikam02/configuring-domains-and-sub-domains-in-apache-webserver-1bl1

storDomain="stor-dom-000-1"
consToken="B0B3DA99-1859-A499-90F6-1E3F69575DCD"

# subdomain setup
tee -a /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
   DocumentRoot /mnt/glusterfs/$consToken
   ServerName $consToken.$storDomain
</VirtualHost>
EOF