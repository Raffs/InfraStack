#!/bin/bash

# Configurando o repositório oficial do zabbix 3
wget http://repo.zabbix.com/zabbix/3.0/debian/pool/main/z/zabbix-release/zabbix-release_3.0-1+jessie_all.deb -O /tmp/zabbix-release_3.0-1+jessie_all.deb
dpkg -i /tmp/zabbix-release_3.0-1+jessie_all.deb
apt-get update

# Instalando o frontend do zabbix
apt-get -y install zabbix-frontend-php php5-pgsql
mv -fv /vagrant/apache.conf /etc/apache2/conf-enabled/zabbix.conf
mv -fv /vagrant/zabbix.conf.php /usr/share/zabbix/conf/zabbix.conf.php
mv -fv /vagrant/hosts /etc/hosts
sed -i "s/MAQUINA/$(hostname)/g" /etc/hosts
sed -i "s/node.linuxsysadmin.com.br/$(hostname).linuxsysadmin.com.br/" /etc/apache2/conf-enabled/zabbix.conf

# Iniciando o apache2
systemctl restart apache2
