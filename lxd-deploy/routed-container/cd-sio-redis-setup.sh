lxc exec cd-sio-93 -- sudo -H -u devops bash -c '
echo "----------------------------------------------------"
echo "INSTALL REDIS"
echo "----------------------------------------------------"
sudo apt install redis -y

echo "----------------------------------------------------"
echo "ALLOW REMOTE CONNECTION"
echo "----------------------------------------------------"
# Path to the REDIS configuration file
REDIS_CONF_FILE="/etc/redis/redis.conf"

# Replace "127.0.0.1" with "0.0.0.0" in the REDIS configuration file
sed -i 's/127.0.0.1/0.0.0.0/g' "$REDIS_CONF_FILE"

echo "Replacement complete."

sudo systemctl restart redis-server
'