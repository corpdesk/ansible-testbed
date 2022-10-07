    # variable input:
    # host_ip, server shared dir:  /var/nfs/p-key, local mounting point: /nfs/p-key
    sudo apt update -y
    sudo apt install nfs-common -y
    sudo mkdir -p /nfs/p-key
    sudo mount host_ip:/var/nfs/p-key /nfs/p-key

