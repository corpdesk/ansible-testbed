#!/bin/bash

# MySQL login credentials
MYSQL_USER="your_mysql_user"
MYSQL_PASSWORD="your_mysql_password"
MYSQL_DATABASE="your_database_name"

# Path to the MySQL backup file
BACKUP_FILE="/path/to/your/backup_file.sql"

# Check if the backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file not found: $BACKUP_FILE"
    exit 1
fi

# Restore the backup file
echo "Restoring MySQL backup file: $BACKUP_FILE"
mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < "$BACKUP_FILE"

echo "Backup file restored successfully."
