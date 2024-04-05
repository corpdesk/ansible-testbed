#!/bin/bash

# preceed this procedure with the following to avoid password prompt
# ssh-copy-id emp-07@emp-07

# Define variables
REMOTE_HOST="emp-07@emp-07"
REMOTE_PATH="/home/emp-07/temp"
LOCAL_FILE="/home/emp-06/snap/mysql-workbench-community/13/dumps/Dump20240404.sql"

# Use SCP to transfer the file
scp "$LOCAL_FILE" "$REMOTE_HOST":"$REMOTE_PATH"
