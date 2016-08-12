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

# Configurando o repositório oficial do zabbix 3
unalias -a
yum -y install wget
wget http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm -O /tmp/zabbix-release-3.0-1.el7.noarch.rpm
rpm -ivh /tmp/zabbix-release-3.0-1.el7.noarch.rpm

# Instalando o frontend do zabbix
yum -y install zabbix-web-pgsql
mv -fv ${VAGRANT_HOME}/conf/apache.conf /etc/httpd/conf.d/zabbix.conf
mv -fv ${VAGRANT_HOME}/conf/zabbix.conf.php /etc/zabbix/web/zabbix.conf.php
mv -fv ${VAGRANT_HOME}/sync/conf/hosts /etc/hosts
sed -i "s/MAQUINA/$(hostname)/g" /etc/hosts
sed -i "s/node.linuxsysadmin.com.br/$(hostname).linuxsysadmin.com.br/" /etc/httpd/conf.d/zabbix.conf

# Iniciando o apache2
systemctl restart httpd
systemctl enable httpd
