#!/bin/sh

service mysql stop
killall -KILL mysql mysqld_safe mysqld
apt-get purge 'mysql*' -y
# apt-get remove --purge \
#   'mysql*' \
#   mysql-server \
#   mysql-client \
#   mysql-common \
#   'mysql-server-core-*' \
#   'mysql-client-core-*' -y
apt-get autoremove --purge -y
apt-get autoclean
apt-get remove dbconfig-mysql
rm -rf /etc/mysql /var/lib/mysql
apt-get autoremove && apt-get autoclean
deluser --remove-home mysql
delgroup mysql
rm -rf \
  /etc/apparmor.d/abstractions/mysql \
  /etc/apparmor.d/cache/usr.sbin.mysqld \
  /etc/mysql \
  /var/lib/mysql \
  '/var/log/mysql*' \
  '/var/log/upstart/mysql.log*' \
  /var/run/mysqld \
  ~/.mysql_history
updatedb
# Remove all logs
# awk -F : '{ print($6 "/.mysql_history"); }' /etc/passwd | xargs -r -d '\n' -- rm -f --
# find / -name .mysql_history -delete
# add-apt-repository --remove ppa:theppayouused/ppa
