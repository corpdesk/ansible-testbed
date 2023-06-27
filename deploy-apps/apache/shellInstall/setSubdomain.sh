#!/bin/bash

# Ref: https://dev.to/tikam02/configuring-domains-and-sub-domains-in-apache-webserver-1bl1
# subDomain="\/mnt\/glusterfs"
subDomain="/home/emp-06/sites"
subDomainEsc="\/home\/emp-06\/sites"


# cat /etc/apache2/sites-available/000-default.conf
# sed -i 's/\/var\/www\/html/\/mnt\/glusterfs/g' /etc/apache2/sites-available/000-default.conf
# cat /etc/apache2/sites-available/000-default.conf
# cat /etc/apache2/apache2.conf
# sed -i 's/\/var\/www/\/mnt\/glusterfs/g' /etc/apache2/apache2.conf
# cat /etc/apache2/apache2.conf
# adduser ubuntu www-data
# chown -R www-data:www-data /mnt/glusterfs
# chmod -R g+rw /mnt/glusterfs
# chmod -R 755 /mnt/glusterfs
# echo -e "-- Restarting Apache web server\n"
# service apache2 restart

cat /etc/apache2/sites-available/000-default.conf
sed -i "s/\/var\/www\/html/$subDomainEsc/g" /etc/apache2/sites-available/000-default.conf
cat /etc/apache2/sites-available/000-default.conf
cat /etc/apache2/apache2.conf
sed -i "s/\/var\/www/$subDomainEsc/g" /etc/apache2/apache2.conf
cat /etc/apache2/apache2.conf
adduser ubuntu www-data
chown -R www-data:www-data $subDomain
chmod -R g+rw $subDomain
chmod -R 755 $subDomain
echo -e "-- Restarting Apache web server\n"
service apache2 restart

