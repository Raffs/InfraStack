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
systemctl stop postgresql

# Preparando o cenário dos PostgreSQL Slaves
chown postgres. ${VAGRANT_HOME}/conf/postgresql.conf ${VAGRANT_HOME}/conf/pg_hba.conf
mv -fv ${VAGRANT_HOME}/conf/postgresql.conf /etc/postgresql/9.5/main/
mv -fv ${VAGRANT_HOME}/conf/pg_hba.conf /etc/postgresql/9.5/main/
mv -fv ${VAGRANT_HOME}/conf/repmgr.conf /etc/
mv -fv ${VAGRANT_HOME}/conf/hosts /etc/

	case ${HOSTNAME} in
		srvpgsql02)
			sed -i "s/MAQUINA/$(hostname)/g" /etc/hosts
			sed -i "s/NUMERO/2/g" /etc/repmgr.conf
			sed -i "s/NOME/$(hostname)/g" /etc/repmgr.conf
			sed -i "s/192.168.50.IP/192.168.50.3/g" /etc/repmgr.conf
			;;
	
		srvpgsql03)
			sed -i "s/MAQUINA/$(hostname)/g" /etc/hosts
			sed -i "s/NUMERO/3/g" /etc/repmgr.conf
			sed -i "s/NOME/$(hostname)/g" /etc/repmgr.conf
			sed -i "s/192.168.50.IP/192.168.50.4/g" /etc/repmgr.conf
			;;

		*)
			echo "Hostname desconhecido"
			;;
	esac

# Fazendo o clone do PostgreSQL Master.
rm -rvf /var/lib/postgresql/9.5/main/*
su - postgres -c "repmgr -f /etc/repmgr.conf -D /var/lib/postgresql/9.5/main/ -d repmgr  -U repmgr --verbose --ignore-external-config-files standby clone -h 192.168.50.2"
cp -v /etc/postgresql/9.5/main/postgresql.conf /var/lib/postgresql/9.5/main/
cp -v /etc/postgresql/9.5/main/pg_hba.conf /var/lib/postgresql/9.5/main/
chown -R postgres. /var/lib/postgresql/9.5/main/
chown -R postgres. /etc/postgresql/9.5/main/

	if [ ! -e "/var/run/postgresql/9.5-main.pg_stat_tmp" ]; then

		mkdir /var/run/postgresql/9.5-main.pg_stat_tmp

	fi

chown -R postgres. /var/run/postgresql/9.5-main.pg_stat_tmp

# Iniciando o postgreSQL
su - postgres -c "/usr/lib/postgresql/9.5/bin/pg_ctl -D /var/lib/postgresql/9.5/main/ start"

# Cadastrando o PostgreSQL no Cluster
sleep 10
su - postgres -c "repmgr -f /etc/repmgr.conf  standby register"
