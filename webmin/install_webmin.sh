#!/bin/bash

sudo apt update
curl -fsSL https://download.webmin.com/jcameron-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/webmin.gpg
# add line to /etc/apt/sources.list: 
sudo echo "deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge con" >> /etc/apt/sources.list
sudo apt update
sudo apt install webmin