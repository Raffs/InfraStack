#!/bin/bash

if [ -e "/vagrant" ]; then

        VAGRANT_HOME="/vagrant"

elif [ -e "/home/vagrant/sync" ]; then

        VAGRANT_HOME="/home/vagrant/sync"

else

        echo "Not sync folder"
        exit 1

fi

# Add DNS google.com: 8.8.8.8 and 8.8.4.4
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

# Preparando o repositório oficial do Zabbix 3.
wget http://repo.zabbix.com/zabbix/3.0/debian/pool/main/z/zabbix-release/zabbix-release_3.0-1+jessie_all.deb -O /tmp/zabbix-release_3.0-1+jessie_all.deb
dpkg -i /tmp/zabbix-release_3.0-1+jessie_all.deb
apt-get update

# Instalando o zabbix_server com suporte a PostgreSQL
apt-get -y install zabbix-server-pgsql
gunzip /usr/share/doc/zabbix-server-pgsql/create.sql.gz
PGPASSWORD=123456789 psql -Uzabbix -h 192.168.50.2 zabbixdb < /usr/share/doc/zabbix-server-pgsql/create.sql
mv -fv ${VAGRANT_HOME}/conf/zabbix_server.conf /etc/zabbix
mv -fv ${VAGRANT_HOME}/conf/hosts /etc/hosts
sed -i "s/MAQUINA/$(hostname)/g" /etc/hosts

# Iniciando zabbix_server
systemctl restart zabbix-server.service
