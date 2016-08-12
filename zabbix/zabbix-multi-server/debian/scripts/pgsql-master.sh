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

# Criando o repositório do PostgreSQL
wget https://www.postgresql.org/media/keys/ACCC4CF8.asc -O /tmp/ACCC4CF8.asc
apt-key add /tmp/ACCC4CF8.asc
echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/postgresql.list
apt-get update

# Instalando o PostgreSQL 9.5 e o Replication Manager
apt-get -y install postgresql-9.5 postgresql-9.5-repmgr

# Preparando o cenário dos PostgreSQL Master
echo -e "CREATE USER zabbix WITH PASSWORD '123456789'; \nCREATE DATABASE zabbixdb OWNER zabbix;" > /tmp/sql
su - postgres -c "psql < /tmp/sql"
rm -f /tmp/sql
su - postgres -c "createuser -s repmgr"
su - postgres -c "createdb repmgr -O repmgr"
su - postgres -c "psql -f /usr/share/postgresql/9.5/contrib/repmgr_funcs.sql repmgr"
systemctl stop postgresql
mv -fv ${VAGRANT_HOME}/conf/postgresql.conf /etc/postgresql/9.5/main/
mv -fv ${VAGRANT_HOME}/conf/pg_hba.conf /etc/postgresql/9.5/main/
mv -fv ${VAGRANT_HOME}/conf/repmgr.conf /etc/
mv -fv ${VAGRANT_HOME}/conf/hosts /etc/hosts
sed -i "s/MAQUINA/$(hostname)/g" /etc/hosts
sed -i "s/NUMERO/1/g" /etc/repmgr.conf
sed -i "s/NOME/$(hostname)/g" /etc/repmgr.conf
sed -i "s/192.168.50.IP/192.168.50.2/g" /etc/repmgr.conf
chown -R postgres. /etc/postgresql/9.5/main/
systemctl start postgresql

# Cadastrando o PostgreSQL no Cluster
su - postgres -c "repmgr -f /etc/repmgr.conf master register"
su - postgres -c "repmgr -f /etc/repmgr.conf cluster show"
