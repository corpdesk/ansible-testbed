#!/bin/bash

sudo apt update
sudo apt install haproxy -y
sudo systemctl enable haproxy
