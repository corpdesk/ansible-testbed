    # variables:
    # inventory array or subnet specification nfs, shared dir: /var/nfs/p-key
    sudo apt update
    sudo apt install nfs-kernel-server
    sudo mkdir /var/nfs/p-key -p
    sudo chown nobody:nogroup /var/nfs/p-key
    # nfs config
    # NB: replace client_ip with valid ip or subnet based on target inventory
    echo '/var/nfs/p-key    client_ip(rw,sync,no_subtree_check)' >> /etc/exports
    sudo systemctl restart nfs-kernel-server
    # firewall setting
    # NB: replace client_ip with valid ip or subnet based on target inventory
    sudo ufw allow from client_ip to any port nfs


