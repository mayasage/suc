#!/bin/sh

# tested on docker ubuntu 20.04
# if command -v docker; then
#   echo "docker found"
# else
#   echo "Installing docker in 10 seconds (Exit to install manually)..."
#   sleep 10
#   curl -fsSL https://get.docker.com -o install-docker.sh
#   sudo sh install-docker.sh
# fi
# docker container run -itd --name ubuntu2004 --volume /home/kratikal/one/mysql:/mysql ubuntu:20.04
# docker container exec -it ubuntu2004 sh
# Locate to the shared file.
# It must container these 4 scripts:
# download_mysql5.7_packages.sh
# downlaod_other_mysql5.7_dependencies.sh
# install_mysql5.7_if_internet_is_present.sh
# install_mysql5.7_packages.sh

mkdir mysql5.7
cd mysql5.7 || exit 1

apt update
apt install lsb-release -y || exit 1
apt install wget -y || exit 1
apt install gnupg -y || exit 1
wget https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb
dpkg -i mysql-apt-config_0.8.12-1_all.deb
apt update
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29
apt update
apt-cache policy mysql-server

# Download mysql-client
apt install -f --download-only mysql-client=5.7* -y
mkdir mysql-client-5.7
cd mysql-client-5.7 || exit 1
mv /var/cache/apt/archives/lib* .
mv /var/cache/apt/archives/mysql* .
cd .. || exit 1

# Download mysql-community-server
apt install -f mysql-client=5.7* -y || exit 1
apt install -f --download-only mysql-community-server=5.7* -y || exit 1
mkdir mysql-community-server-5.7
cd mysql-community-server-5.7 || exit 1
mv /var/cache/apt/archives/lib* .
mv /var/cache/apt/archives/perl* .
mv /var/cache/apt/archives/netbase* .
mv /var/cache/apt/archives/psmisc* .
mv /var/cache/apt/archives/mysql* .
cd .. || exit 1

# Download mysql-community-server
apt install -f mysql-community-server=5.7* -y || exit 1
apt install -f --download-only mysql-server=5.7* -y || exit 1
mkdir mysql-server-5.7
cd mysql-server-5.7 || exit 1
mv /var/cache/apt/archives/mysql* .
cd .. || exit 1

# Download other-dependencies
cp ../*.sh .
apt install apt-rdepends -y || exit 1
# This one is required for mysql-community-server
sh download_other_mysql5.7_dependencies.sh

# Download Extra Packages If Needed
sh download_package_dependencies.sh mysql-community-server

# Archive
cd .. || exit 1
tar -czvf mysql5.7.tar.gz mysql5.7
rm -rf mysql5.7
