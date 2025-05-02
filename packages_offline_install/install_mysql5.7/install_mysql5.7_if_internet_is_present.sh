#!/bin/sh

# tested on docker ubuntu 20.04

apt update
apt install wget -y || exit 1
wget https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb
apt install lsb-release -y || exit 1
apt install gnupg -y || exit 1
dpkg -i mysql-apt-config_0.8.12-1_all.deb
# select ubuntu bionic
# select mysql-5.7
apt update
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29
apt update
apt-cache policy mysql-server
apt install -f \
  mysql-client=5.7* \
  mysql-community-server=5.7* \
  mysql-server=5.7* -y
printf "\n[mysqld]\nlower_case_table_names = 1\n" >>/etc/mysql/my.cnf
service mysql start
mysql -u root -p --execute "SELECT @@LOWER_CASE_TABLE_NAMES;"
mysql -u root -p --execute "SELECT user FROM mysql.user;"
mysql_secure_installation

# do the following if you want
# CREATE USER 'username'@'localhost' IDENTIFIED BY 'user_password';
# GRANT CREATE, SELECT ON *.* TO 'username'@'localhost';
# SELECT user FROM mysql.user;
