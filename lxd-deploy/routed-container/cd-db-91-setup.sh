#!/bin/bash

echo "----------------------------------------------------" 
echo "INSTALL AND HARDEN MYSQL "
echo "----------------------------------------------------"

   
sudo apt install mysql-server
sudo systemctl start mysql.service
ROOT_PASSWORD="yU0B14NC1PdE."
mysql -u root <<EOF
SET PASSWORD FOR root@localhost = "${ROOT_PASSWORD}";
FLUSH PRIVILEGES;
EOF

mysql_secure_installation -u root --password="${ROOT_PASSWORD}" --use-default


echo "----------------------------------------------------"
echo "ALLOW REMOTE CONNECTION"
echo "----------------------------------------------------"
# Path to the MySQL configuration file
MYSQL_CONF_FILE="/etc/mysql/mysql.conf.d/mysqld.cnf"

# Replace "127.0.0.1" with "0.0.0.0" in the MySQL configuration file
sed -i 's/127.0.0.1/0.0.0.0/g' "$MYSQL_CONF_FILE"

echo "Replacement complete."

sudo service mysql restart

echo "----------------------------------------------------"
echo "CREATE DEVOPS USER WITH PRIVILLAGES"
echo "----------------------------------------------------"


# MySQL login credentials
MYSQL_USER="root"
rootpasswd="yU0B14NC1PdE."

# MySQL database and user details
NEW_USERNAME="devops"
NEW_PASSWORD="yU0B14NC1PdE.#"
mysql -uroot -p${rootpasswd} -e "CREATE USER '$NEW_USERNAME'@'%' IDENTIFIED BY '$NEW_PASSWORD'; GRANT ALL PRIVILEGES ON *.* TO '${NEW_USERNAME}'@'%';"


echo "User '$NEW_USERNAME' created with grant all privileges."
echo "----------------------------------------------------"