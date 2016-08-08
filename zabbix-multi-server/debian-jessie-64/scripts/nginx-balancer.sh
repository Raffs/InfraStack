#!/bin/bash

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
mv -fv /vagrant/balancer.conf /etc/nginx/conf.d/
mv -fv /vagrant/hosts /etc/hosts
sed -i "s/MAQUINA/$(hostname)/g" /etc/hosts

# Subindo o serviço Nginx
systemctl restart nginx
