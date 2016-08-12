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

# Configurando o repositório oficial do Nginx
cp -fv ${VAGRANT_HOME}/conf/nginx.repo /etc/yum.repos.d/nginx.repo

# Desabilitar SELINUX
unalias -a
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# Instalando o Nginx
yum -y install nginx

# Configurando o balanceamento de carga no Nginx
mv -fv ${VAGRANT_HOME}/conf/balancer.conf /etc/nginx/conf.d/
mv -fv ${VAGRANT_HOME}/conf/hosts /etc/hosts
sed -i "s/MAQUINA/$(hostname)/g" /etc/hosts

# Subindo o serviço Nginx
systemctl restart nginx
systemctl enable nginx
