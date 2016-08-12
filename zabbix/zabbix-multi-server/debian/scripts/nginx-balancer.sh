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
wget http://nginx.org/keys/nginx_signing.key -O /tmp/nginx_signing.key
apt-key add /tmp/nginx_signing.key
echo "deb http://nginx.org/packages/debian/ jessie nginx" > /etc/apt/sources.list.d/nginx.list
echo "deb-src http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list.d/nginx.list
apt-get update

# Instalando o Nginx
apt-get -y install nginx
rm -fv /etc/nginx/conf.d/default.conf

# Configurando o balanceamento de carga no Nginx
mv -fv ${VAGRANT_HOME}/conf/balancer.conf /etc/nginx/conf.d/
mv -fv ${VAGRANT_HOME}/hosts /etc/hosts
sed -i "s/MAQUINA/$(hostname)/g" /etc/hosts

# Subindo o serviço Nginx
systemctl restart nginx
