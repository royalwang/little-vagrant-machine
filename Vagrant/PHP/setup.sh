#!/bin/bash
#
# Setup LAPP
#
# @copyright   (C) 2015 Rain Lee <raincious@gmail.com>
# @see         LICENSE for license

CERT_SRL=10001

# Install and configure PHP
apt-get install -y php5 php5-fpm php5-cli php5-common php5-curl php5-gd php5-mcrypt php5-xdebug php5-pgsql php5-mysql php5-sqlite php5-memcached

if [[ "$?" > 0 ]]; then
    exit $?
fi

service php5-fpm stop

# Config modules
php /vagrant/PHP/ModifyPHPModuleConfig.php "/etc/php5/mods-available" "/vagrant/PHP"

echo "PHP5 has been installed." >> "/tmp/vagrant-info.log"



# Install and configure PostgreSQL
apt-get install -y postgresql postgresql-contrib

if [[ "$?" > 0 ]]; then
    exit $?
fi

PG_HDA_CONTENT="$(cat '/etc/postgresql/9.4/main/pg_hba.conf')"
echo "local all \"dev\" md5" > "/etc/postgresql/9.4/main/pg_hba.conf"
echo "host all \"dev\" samenet md5" >> "/etc/postgresql/9.4/main/pg_hba.conf"
echo "" >> "/etc/postgresql/9.4/main/pg_hba.conf"
echo "${PG_HDA_CONTENT}" >> "/etc/postgresql/9.4/main/pg_hba.conf"

echo "" >> "/etc/postgresql/9.4/main/postgresql.conf"
echo "listen_addresses = '*'" >> "/etc/postgresql/9.4/main/postgresql.conf"

service postgresql restart

# Add 'dev' user with password 'dev'
sudo -u postgres psql -c "CREATE ROLE \"dev\" LOGIN PASSWORD 'dev' INHERIT CREATEDB NOSUPERUSER NOCREATEROLE NOREPLICATION;"
sudo -u postgres psql -c "CREATE DATABASE \"dev\" ENCODING 'UTF8' OWNER \"dev\";"

echo "PostgreSQL has been installed. Please use dev:dev to login." >> "/tmp/vagrant-info.log"



# Install and configure Memcached
apt-get install memcached


# Install and configure Apache
apt-get install -y apache2 libapache2-mod-php5

if [[ "$?" > 0 ]]; then
    exit $?
fi

echo "Apache is installed." >> "/tmp/vagrant-info.log"

service apache2 stop
php /vagrant/PHP/ApacheModifyConf.php
mkdir /etc/apache2/ssl -p
cp /vagrant/CA.crt /etc/apache2/ssl -f
cp /vagrant/CA.key /etc/apache2/ssl -f

if [ ! -d "/var/www/default" ]; then
    mkdir "/var/www/default" -p
fi

if [ ! -d "/var/www/tool" ]; then
    mkdir "/var/www/tool" -p
fi

if [ ! -d "/var/www/test" ]; then
    mkdir "/var/www/test" -p
fi

if [ ! -d "/var/www/default/index.php" ]; then
    echo "<?php phpinfo(); ?>" > "/var/www/default/index.php"
fi

php /vagrant/PHP/ApacheModifyDefaultSites.php "${HOST_NAME}"
chmod +x /vagrant/Misc/build_cert.sh
/vagrant/Misc/build_cert.sh "${HOST_NAME}" "/etc/apache2/ssl" "/vagrant" "$((CERT_SRL = CERT_SRL + 1))"
/vagrant/Misc/build_cert.sh "tool.${HOST_NAME}" "/etc/apache2/ssl" "/vagrant" "$((CERT_SRL = CERT_SRL + 1))"
/vagrant/Misc/build_cert.sh "test.${HOST_NAME}" "/etc/apache2/ssl" "/vagrant" "$((CERT_SRL = CERT_SRL + 1))"
a2ensite "000-tool"
a2ensite "000-test"
echo "Site enabled: ${HOST_NAME}" >> "/tmp/vagrant-info.log"
echo "Site enabled: tool.${HOST_NAME}" >> "/tmp/vagrant-info.log"
echo "Site enabled: test.${HOST_NAME}" >> "/tmp/vagrant-info.log"

if [ ! -d "/var/www/project" ]; then
    mkdir /var/www/project -p
fi

while read -r FolderName
do
    ProjectHost=$(php /vagrant/PHP/ApacheAddProjectSite.php "${FolderName}" "${HOST_NAME}")

    /vagrant/Misc/build_cert.sh "${ProjectHost}" "/etc/apache2/ssl" "/vagrant" "$((CERT_SRL = CERT_SRL + 1))"
    a2ensite "${FolderName}"
    echo "Site enabled: ${ProjectHost}" >> "/tmp/vagrant-info.log"
done <<< "$(php /vagrant/PHP/SubFolders.php '/var/www/project')"

a2enmod ssl
a2enmod rewrite
service apache2 start
