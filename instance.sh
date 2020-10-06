#!/bin/bash

###
### Autoconf instance (CentOS)
###

# - RSA
# - Yubikey
# - Docker CE

if [ -f /etc/redhat-release ]; then
  sudo dnf update -y
  # Dependencies
  sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
  sudo dnf install -y pam_yubico htop pwgen git nano
  echo '' >> ~/.bashrc
  echo '#Custom Alias' >> ~/.bashrc
  echo 'alias top="htop"' >> ~/.bashrc
  echo 'alias pwgen="pwgen -syn 18"' >> ~/.bashrc
  source ~/.bashrc
  # RSA & Yubikey
  sudo mv ~/.ssh/authorized_keys ~/.ssh/authorized_keys.old && sudo curl -o ~/.ssh/authorized_keys https://raw.githubusercontent.com/fjmz/tools/master/conf/auhtorized_keys
  sudo curl -o /etc/yubikey_mappings https://raw.githubusercontent.com/fjmz/tools/master/conf/yubikey_mappings
  sudo mv /etc/ssh/sshd_config /etc/sshd_config.old && sudo curl -o /etc/ssh/sshd_config https://raw.githubusercontent.com/fjmz/tools/master/conf/sshd_config
  sudo mv /etc/pam.d/sshd /etc/pam.d/sshd.old && sudo curl -o /etc/pam.d/sshd https://raw.githubusercontent.com/fjmz/tools/master/conf/pam_sshd
  sudo systemctl restart sshd
  # Docker CE (latest)
  sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
  sudo dnf install -y docker-ce
fi
