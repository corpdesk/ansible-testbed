#!/usr/bin/env bash
 
# BEGIN ########################################################################
echo -e "-- ---------- --\n"
echo -e "-- BEGIN $(hostname) --\n"
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
    mode http
    option httplog
    option dontlognull
    retries 3
    option redispatch
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms
 
frontend http-in
    bind *:8080
    default_backend webservers
 
backend webservers
    mode http
    stats enable
    stats auth admin:admin
    stats uri /haproxy?stats
    balance roundrobin
    option httpchk
    option forwardfor
    option http-server-close
    server routed-94 192.168.0.94:80 maxconn 32 check
    server routed-104 192.168.0.104:80 maxconn 32 check
    server routed-114 192.168.0.114:80 maxconn 32 check
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
    interface eno1            # confirm the interface name
    state MASTER
    virtual_router_id 51
    priority 101
    virtual_ipaddress {
        192.168.0.8
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
echo -e "-- END $(hostname) --"
echo -e "-- -------- --"
