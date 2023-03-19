config:
  user.network-config: |
    version: 1
    config:
      - type: physical
        name: eth0
        subnets:
          - type: dhcp
            ipv4: true
      - type: physical
        name: eth1
        subnets:
          - type: dhcp
            ipv4: true
description: LXD profile with private and public networks
devices:
  eth0:
    name: eth0
    nictype: bridged
    parent: lxdbr0
    type: nic
  eth1:
    name: eth1
    nictype: macvlan
    parent: enp0s31f6
    type: nic
  root:
    path: /
    pool: default
    type: disk
name: privatepublicnetwork
used_by: