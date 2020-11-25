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
  sudo dnf install -y pam_yubico htop pwgen git nano nmap nc traceroute
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
  sudo setsebool -P authlogin_yubikey on
  sudo systemctl restart sshd
  # Docker CE (latest)
  sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
  sudo dnf install -y docker-ce
  sudo systemctl enable docker && sudo systemctl start docker
  # Docker Compose
  sudo dnf install -y python3-pip
  sudo pip3 install docker-compose
fi

###
### Autoconf instance (Debian)
###

# - RSA
# - Yubikey
# - Docker CE

if [ -f /etc/debian_version ]; then
  # Modify repo (stable non-free at Debian 10)
  sudo sed -i 's/buster/stable/g' /etc/apt/sources.list
  sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
  # Update & Upgrade
  sudo apt update && sudo apt upgrade -y
  # Dependencies
  sudo apt install -y libpam-yubico htop pwgen git nano nmap netcat traceroute apt-transport-https ca-certificates curl gnupg-agent software-properties-common net-tools 
  echo '' >> ~/.bashrc
  echo '#Custom Alias' >> ~/.bashrc
  echo 'alias top="htop"' >> ~/.bashrc
  echo 'alias pwgen="pwgen -syn 18"' >> ~/.bashrc
  source ~/.bashrc
  # RSA & Yubikey
  sudo mv ~/.ssh/authorized_keys ~/.ssh/authorized_keys.old && sudo curl -o ~/.ssh/authorized_keys https://raw.githubusercontent.com/fjmz/tools/master/conf/auhtorized_keys
  sudo curl -o /etc/yubikey_mappings https://raw.githubusercontent.com/fjmz/tools/master/conf/yubikey_mappings
  sudo mv /etc/ssh/sshd_config /etc/sshd_config.old && sudo curl -o /etc/ssh/sshd_config https://raw.githubusercontent.com/fjmz/tools/master/conf/sshd_config
  sudo sed  -i '2iauth sufficient pam_yubico.so id=16 debug authfile=/etc/yubikey_mappings mode=client' /etc/pam.d/sshd
  sudo systemctl restart sshd
  # Docker CE (latest)
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
  sudo apt install -y docker-ce docker-ce-cli containerd.io
  sudo systemctl enable docker && sudo systemctl start docker
  # Docker Compose
  sudo apt install -y docker-compose
fi
