#!/bin/bash

# Ref: https://gist.github.com/soubrunorocha/ec30b7704d737a1797b0281e97967834

bash -c '#update and install some dependencies 
sudo apt-get update && apt-get upgrade -y;
sudo apt-get install -y debconf-utils zsh htop libaio1;

#apt congig file:
mysqlAptConfig="mysql-apt-config_0.8.26-1_all.deb"

#set the root password
DEFAULTPASS="yU0B14NC1PdE"

#set some config to avoid prompting
sudo debconf-set-selections <<EOF
mysql-apt-config mysql-apt-config/select-server select mysql-8.0
mysql-community-server mysql-community-server/root-pass password $DEFAULTPASS
mysql-community-server mysql-community-server/re-root-pass password $DEFAULTPASS
EOF

#get the mysql repository via wget
wget --user-agent="Mozilla" -O /tmp/$mysqlAptConfig https://dev.mysql.com/get/$mysqlAptConfig;

#set debian frontend to not prompt
export DEBIAN_FRONTEND="noninteractive";

#config the package
sudo -E dpkg -i /tmp/$mysqlAptConfig;

#update apt to get mysql repository
sudo apt-get update

#install mysql according to previous config
sudo -E apt-get install mysql-server mysql-client mysql-shell --assume-yes --force-yes'

# W: --force-yes is deprecated, use one of the options starting with --allow instead.