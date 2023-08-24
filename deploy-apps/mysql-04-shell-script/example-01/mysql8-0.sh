#!/usr/bin/env bash

# uninstall existing mysql 8
sudo service mysql stop
sudo apt remove --purge mysql-common -y # Remove data directories? <Yes>
sudo apt remove --purge mysql-community* -y
sudo apt remove --purge mysql-apt-config -y
sudo rm -rf /var/lib/mysql
sudo rm -rf /var/log/mysql
sudo rm -rf /etc/mysql
sudo apt autoremove -y && sudo apt autoclean

# install from debian package
mysql_apt_deb=mysql-apt-config_0.8.34_all.deb
wget –c "https://dev.mysql.com/get/${mysql_apt_deb}"
# When prompted, select 8.0 (if default, arrow-down to OK and press Enter)
sudo dpkg -i $mysql_apt_deb
rm $mysql_apt_deb
sudo apt update

# install mysql-server
# should be version 8.x
sudo apt install mysql-server -y

# download script mysql.server.sh
wget -c "https://raw.githubusercontent.com/mysql/mysql-server/8.0/support-files/mysql.server.sh"
# change lines basedir=/usr and datadir=/var/lib/mysql

# move the script renamed as mysql ( /etc/init.d/mysql )
sudo mv mysql.server.sh /etc/init.d/mysql
# make sure it is executable
sudo chmod +x /etc/init.d/mysql

# Add the path to the mysql-installation-directory to the basedir variable
# If you change base dir, you must also change datadir, like:
#[mysqld]
# basedir=/usr
# datadir=/var/lib/mysql
# in configuration file /etc/mysql/my.cnf
# for now let's change only basedir=/usr
printf "
[mysqld]
basedir=/usr
" | sudo tee -a /etc/mysql/my.cnf

# got error after reinstalling: mysqld_safe Directory '/var/run/mysqld' for UNIX socket file don't exists
# so check if exists and if not make it
if [ ! -d "/var/run/mysqld" ]; then
  sudo mkdir -p /var/run/mysqld
  sudo chown mysql:mysql /var/run/mysqld
 fi

# start mysql server
sudo service mysql start
