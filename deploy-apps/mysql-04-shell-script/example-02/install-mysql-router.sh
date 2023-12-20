#!/bin/bash

# Ref: https://gist.github.com/soubrunorocha/ec30b7704d737a1797b0281e97967834

bash -c '#update and install some dependencies 
sudo apt-get update && apt-get upgrade -y;
sudo apt-get install -y debconf-utils zsh htop libaio1;

#apt congig file:
mysqlAptConfig="mysql-apt-config_0.8.26-1_all.deb"

#get the mysql repository via wget
wget --user-agent="Mozilla" -O /tmp/$mysqlAptConfig https://dev.mysql.com/get/$mysqlAptConfig;

#set debian frontend to not prompt
export DEBIAN_FRONTEND="noninteractive";

#config the package
sudo -E dpkg -i /tmp/$mysqlAptConfig;

#update apt to get mysql repository
sudo apt-get update

#install mysql according to previous config
sudo apt install mysql-client mysql-shell mysql-router -y'

# W: --force-yes is deprecated, use one of the options starting with --allow instead.