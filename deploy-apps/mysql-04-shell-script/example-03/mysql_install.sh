-----------------------------------------------
#!/bin/bash
sudo apt install mysql-server
sudo systemctl start mysql.service
ROOT_PASSWORD="yU0B14NC1PdE."
mysql -u root <<EOF
SET PASSWORD FOR root@localhost = '${ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

mysql_secure_installation -u root --password="${ROOT_PASSWORD}" --use-default
-----------------------------------------------

////////////////////////////////////////
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
bind-address            = 0.0.0.0
mysqlx-bind-address     = 0.0.0.0
-----------------------------------------------
#!/bin/bash

# Save the script with a filename, e.g., update_mysql_conf.sh, make it executable 
# (chmod +x update_mysql_conf.sh), and then run it (./update_mysql_conf.sh). 
# This script will replace all occurrences of "127.0.0.1" with "0.0.0.0" 
# in the MySQL configuration file specified by MYSQL_CONF_FILE.

# Path to the MySQL configuration file
MYSQL_CONF_FILE="/etc/mysql/mysql.conf.d/mysqld.cnf"

# Replace "127.0.0.1" with "0.0.0.0" in the MySQL configuration file
sed -i 's/127.0.0.1/0.0.0.0/g' "$MYSQL_CONF_FILE"

echo "Replacement complete."

sudo service mysql restart

-----------------------------------------------


/////////////////////////////////////
mysql -u root -p
CREATE USER 'devops'@'%' IDENTIFIED BY 'yU0B14NC1PdE.';
----------------------------------------
#!/bin/bash

# Save this script in a file, e.g., create_mysql_user.sh, make it executable 
# (chmod +x create_mysql_user.sh), and then run it (sh create_mysql_user.sh).

# MySQL login credentials
MYSQL_USER="root"
MYSQL_PASSWORD="yU0B14NC1PdE"

# MySQL database and user details
NEW_USERNAME="devops"
NEW_PASSWORD="yU0B14NC1PdE."
DATABASE_NAME="database_name"

# Log in to MySQL and create a new user with grant all privileges
mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" << EOF
CREATE USER '$NEW_USERNAME'@'localhost' IDENTIFIED BY '$NEW_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'devops'@'%';;
FLUSH PRIVILEGES;
EOF

echo "User '$NEW_USERNAME' created with grant all privileges."

-----------------------------------------------

