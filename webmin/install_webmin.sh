#!/bin/bash


sudo apt update
sudo apt install curl
curl -fsSL https://download.webmin.com/jcameron-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/webmin.gpg
# delete existing similar config
sed -i '/download.webmin/d' /etc/apt/sources.list
# add line to /etc/apt/sources.list: 
sudo echo "deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
sudo apt update
sudo apt install webmin
