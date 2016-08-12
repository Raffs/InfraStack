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

# Desabilitar SELINUX
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# Preparando o repositório oficial do Zabbix 3.
yum -y install wget
wget http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm -O /tmp/zabbix-release-3.0-1.el7.noarch.rpm
rpm -ivh /tmp/zabbix-release-3.0-1.el7.noarch.rpm

# Instalando o zabbix_server com suporte a PostgreSQL
yum -y install zabbix-server-pgsql postgresql
gunzip /usr/share/doc/zabbix-server-pgsql-3.0.4/create.sql.gz
PGPASSWORD=123456789 psql -Uzabbix -h 192.168.50.2 zabbixdb < /usr/share/doc/zabbix-server-pgsql-3.0.4/create.sql
mv -fv ${VAGRANT_HOME}/conf/zabbix_server.conf /etc/zabbix
mv -fv ${VAGRANT_HOME}/conf/hosts /etc/hosts
sed -i "s/MAQUINA/$(hostname)/g" /etc/hosts

# Iniciando zabbix_server
systemctl restart zabbix-server
systemctl enable zabbix-server
