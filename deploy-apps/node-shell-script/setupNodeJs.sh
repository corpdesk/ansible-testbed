#!/bin/bash

sudo apt update
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
su $USER
nvm install --lts