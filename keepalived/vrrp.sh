#!/usr/bin/env bash

# vrrd.sh Usage:
# $1 - priority
# $2 - nic
# $3 - networkId
# $4 - fId : floating ip hostId
# $5 - targetPort
priority=$1
nic=$2 # This may be eth0 if lxd or eth1 if vagrant...confirm in any case
networkId=$3
fId=$4
targetPort=$5
mode=$6
nodes=$(cat /tmp/nodes.data)


floatingIp="$networkId.$fId"

hn=$(hostname)
# BEGIN ########################################################################
echo -e "-- ---------- --\n"
echo -e "-- BEGIN $hn --\n"
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
    mode $mode
    option dontlognull
    retries 3
    option redispatch
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend vrrp-request
    bind *:$targetPort
    mode $mode
    default_backend nodes

backend nodes
    balance roundrobin
    $nodes
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
    priority $priority
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
echo -e "-- END $hn --"
echo -e "-- -------- --"
