#!/bin/sh

tar -xvf mysql5.7.tar.gz
cd mysql5.7 || exit 1

# Install mysql-client-5.7
cd mysql-client-5.7 || exit 1
dpkg -i \
  libaio1_0.3.112-5_amd64.deb \
  libnuma1_2.0.12-1_amd64.deb \
  libtinfo5_6.2-0ubuntu2.1_amd64.deb \
  mysql-common_5.8+1.0.5ubuntu2_all.deb \
  mysql-community-client_5.7.42-1ubuntu18.04_amd64.deb \
  mysql-client_5.7.42-1ubuntu18.04_amd64.deb

# Install mysql-community-server-5.7
printf '#!/bin/sh\nexit 0' >/usr/sbin/policy-rc.d

cd ../other-dependencies || exit 1
dpkg -i \
  libsasl2-modules-db_2.1.27+dfsg-2ubuntu0.1_amd64.deb \
  libsasl2-2_2.1.27+dfsg-2ubuntu0.1_amd64.deb

cd ../mysql-community-server || exit 1
dpkg -i \
  perl-base_5.30.0-9ubuntu0.5_amd64.deb

cd ../mysql-community-server-5.7 || exit 1
dpkg -i \
  libgdbm6_1.18.1-5_amd64.deb \
  libgdbm-compat4_1.18.1-5_amd64.deb \
  libmecab2_0.996-10build1_amd64.deb \
  perl-modules-5.30_5.30.0-9ubuntu0.5_all.deb \
  libperl5.30_5.30.0-9ubuntu0.5_amd64.deb \
  perl_5.30.0-9ubuntu0.5_amd64.deb \
  netbase_6.1_all.deb \
  psmisc_23.3-1_amd64.deb \
  mysql-community-server_5.7.42-1ubuntu18.04_amd64.deb

# Install mysql-server-5.7
cd ../mysql-server-5.7 || exit 1
dpkg -i \
  mysql-server_5.7.42-1ubuntu18.04_amd64.deb
cd .. || exit 1

# Post-install Scripting
printf "\n[mysqld]\nlower_case_table_names = 1\n" >>/etc/mysql/my.cnf
service mysql restart
mysql -u root -p --execute "SELECT @@LOWER_CASE_TABLE_NAMES;"
mysql -u root -p --execute "SELECT user FROM mysql.user;"
mysql_secure_installation

# Cleanup
cd .. || exit 1
rm -rf mysql5.7
