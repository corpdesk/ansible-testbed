#!/bin/bash

sudo add-apt-repository ppa:vbernat/haproxy-2.6 -y
sudo apt update
sudo apt install haproxy=2.6.\* -y
sudo systemctl enable haproxy
