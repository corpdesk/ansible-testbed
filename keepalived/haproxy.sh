#!/usr/bin/env bash

networkId="192.168.1"
# first id can be used to compute a serial of hosts
firstHostId="10" 
floatingIp="$networkId.241"
mysqlNodePort="30772"
mysqlClusterName="mycluster"
nic="eth1" # This may be eth0 if lxd or eth1 if vagrant...confirm in any case

# BEGIN ########################################################################
echo -e "-- ---------- --\n"
echo -e "-- BEGIN ${HOSTNAME} --\n"
echo -e "-- ---------- --\n"
 
# VARIABLES ####################################################################
echo -e "-- Setting global variables\n"
SYSCTL_CONFIG=/etc/sysctl.conf
 
# BOX ##########################################################################
echo -e "-- Updating packages list\n"
apt-get update -y -qq
 
# HAPROXY ######################################################################
echo -e "-- Installing HAProxy\n"
apt-get install -y haproxy > /dev/null 2>&1
 
echo -e "-- Enabling HAProxy as a start-up deamon\n"
cat > /etc/default/haproxy <<EOF
ENABLED=1
EOF
 
echo -e "-- Configuring HAProxy\n"
cat > /etc/haproxy/haproxy.cfg <<EOF
global
    log 127.0.0.1 local0
    log 127.0.0.1 local1 notice
    daemon
    maxconn 2000
 
defaults
    log global
    mode tcp
    option dontlognull
    retries 3
    option redispatch
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms
 
frontend mysql-request
    bind *:$mysqlNodePort
    mode tcpmycluster
    default_backend nodeports

backend nodeports
    balance roundrobin
    server $mysqlClusterName-0 $networkId.10:$mysqlNodePort check
    server $mysqlClusterName-1 $networkId.11:$mysqlNodePort check
    server $mysqlClusterName-2 $networkId.12:$mysqlNodePort check
EOF
 
echo -e "-- Validating HAProxy configuration\n"
haproxy -f /etc/haproxy/haproxy.cfg -c
 
echo -e "-- Starting HAProxy\n"
service haproxy start
 
# KEEPALIVED ###################################################################
echo -e "-- Installing Keepalived\n"
apt-get install -y keepalived > /dev/null 2>&1
 
echo -e "-- Allowing HAProxy to bind to the virtual IP address\n"
grep -q "net.ipv4.ip_nonlocal_bind=1" "${SYSCTL_CONFIG}" || echo "net.ipv4.ip_nonlocal_bind=1" >> "${SYSCTL_CONFIG}"
 
echo -e "-- Enabling virtual IP binding\n"
sysctl -p
 
echo -e "-- Configuring Keepalived\n"
cat > /etc/keepalived/keepalived.conf <<EOF
vrrp_script chk_haproxy {
    script "killall -0 haproxy"
    interval 2
    weight 2
}
vrrp_instance VI_1 {
    interface $nic
    state MASTER
    virtual_router_id 51
    priority ${PRIORITY}
    virtual_ipaddress {
        $floatingIp
    }
    track_script {
        chk_haproxy
    }
}
EOF
 
echo -e "-- Starting Keepalived\n"
service keepalived start
 
# END ##########################################################################
echo -e "-- -------- --"
echo -e "-- END ${HOSTNAME} --"
echo -e "-- -------- --"
