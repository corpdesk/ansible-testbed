#!/bin/bash

echo "----------------------------------------------------"
echo "CLEAN"
echo "----------------------------------------------------"
lxc stop cd-db-91
lxc delete cd-db-91
lxc profile delete 
lxc profile delete routed_91
echo "----------------------------------------------------"
echo "CREATE CONTAINER WITH INITIAL RESOURCES AND USER"
echo "----------------------------------------------------"
projDir="$HOME/ansible-testbed"
name="cd-db"
networkId="192.168.0"
hostId="91"
parentBridge="eno1"
nic="eth0" 
lxc_image="ubuntu:22.04"

sh routed-lxc-container.sh \
   $name \
   $networkId \
   $hostId \
   $parentBridge \
   $nic \
   $lxc_image \
   $projDir
   
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
MYSQL_PASSWORD="yU0B14NC1PdE."

# MySQL database and user details
NEW_USERNAME="devops"
NEW_PASSWORD="yU0B14NC1PdE."
DATABASE_NAME="database_name"

# Log in to MySQL and create a new user with grant all privileges
mysql -u "$MYSQL_USER" -p "$MYSQL_PASSWORD" << EOF
CREATE USER '$NEW_USERNAME'@'localhost' IDENTIFIED BY '$NEW_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'devops'@'%';;
FLUSH PRIVILEGES;
EOF

echo "User '$NEW_USERNAME' created with grant all privileges."
echo "----------------------------------------------------"

