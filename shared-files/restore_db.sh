#!/bin/bash

# use ssh to copy backup to destination server
# lxc exec cd-db-91 -- mkdir -p /home/devops/temp
# scp /home/emp-06/snap/mysql-workbench-community/13/dumps/Dump20240404.sql devops@cd-db-91:/home/devops/temp

# MySQL login credentials
MYSQL_USER="devops"
MYSQL_PASSWORD="yU0B14NC1PdE.#"
MYSQL_DATABASE="cd1213"

# Path to the MySQL backup file
BACKUP_FILE="/temp/Dump20240404.sql"

# Name of the new schema to create
NEW_SCHEMA="cd1213"

# Log in to MySQL and create a new schema
mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" << EOF
CREATE DATABASE $NEW_SCHEMA;
EOF

echo "Schema '$NEW_SCHEMA' created successfully."

# Check if the backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file not found: $BACKUP_FILE"
    exit 1
fi

# Restore the backup file
echo "Restoring MySQL backup file: $BACKUP_FILE"
mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < "$BACKUP_FILE"

echo "Backup file restored successfully."
