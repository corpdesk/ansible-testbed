[![Build Status](https://travis-ci.org/aeimer/ansible-role-install-virtualbox-vagrant.svg?branch=master)](https://travis-ci.org/aeimer/ansible-role-install-virtualbox-vagrant)
[![Ansible Galaxy](https://img.shields.io/badge/galaxy-install--virtualbox--vagrant-660198.svg)](https://galaxy.ansible.com/aeimer/install-virtualbox-vagrant/)


# Ansible playbook to install Virtualbox and Vagrant

Ansible Galaxy page: https://galaxy.ansible.com/aeimer/install-virtualbox-vagrant/

## Variables

| Name                       | Default Value | Description                                                 |
| -------------------------- | ------------- | ----------------------------------------------------------- |
| virtualbox_version         | `5.1`         | Sets the version number which should be installed           |
| virtualbox_apt_key_url     | ...           | The url of the VB apt key                                   |
| virtualbox_apt_key_url_old | ...           | The url of the VB apt key for older OS's                    |
| virtualbox_apt_repo_url    | ...           | The url of the VB repository                                |
| virtualbox_users           | `[]`          | An Array of usernames which should be added to the VB-Group |
| vagrant_version            | `1.9.8`       | Sets the version number which should be installed           |
| vagrant_deb_url            | ...           | The url to download the debian package                      |
| vagrant_deb_sha_url        | ...           | The url to download the sha256 of the debain package        |

## Example Playbook
```YAML
- hosts: localhost
  roles:
    - aeimer.install-virtualbox-vagrant
```

