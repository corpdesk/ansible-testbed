#!/bin/bash

# preceed this procedure with the following to avoid password prompt
# ssh-copy-id username@remote_host

# Define variables
REMOTE_HOST="username@remote_host"
REMOTE_PATH="/remote/path/to/destination"
LOCAL_FILE="/local/path/to/file"

# Use SCP to transfer the file
scp "$LOCAL_FILE" "$REMOTE_HOST":"$REMOTE_PATH"
