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
unalias -a
yum -y install wget
wget https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm -O /tmp/postgresql-repo.rpm
rpm -ivh /tmp/postgresql-repo.rpm
 
# Instalando o PostgreSQL 9.5 e o Replication Manager
yum -y install postgresql95-server repmgr95
/usr/pgsql-9.5/bin/postgresql95-setup initdb
systemctl enable postgresql-9.5

# Preparando o cenário dos PostgreSQL Slaves
systemctl start postgresql-9.5
mv -fv ${VAGRANT_HOME}/conf/postgresql.conf /var/lib/pgsql/9.5/data/
mv -fv ${VAGRANT_HOME}/conf/pg_hba.conf /var/lib/pgsql/9.5/data/
mv -fv ${VAGRANT_HOME}/conf/repmgr.conf /etc/repmgr/9.5/
mv -fv ${VAGRANT_HOME}/conf/hosts /etc/hosts
chown -R postgres. /var/lib/pgsql/9.5/data/
chmod 644 /var/lib/pgsql/9.5/data/postgresql.conf
chmod 600 /var/lib/pgsql/9.5/data/pg_hba.conf

	case ${HOSTNAME} in
                srvpgsql02)
			sed -i "s/MAQUINA/$(hostname)/g" /etc/hosts
			sed -i "s/NUMERO/2/g" /etc/repmgr/9.5/repmgr.conf
			sed -i "s/NOME/$(hostname)/g" /etc/repmgr/9.5/repmgr.conf
			sed -i "s/192.168.50.IP/192.168.50.3/g" /etc/repmgr/9.5/repmgr.conf
			;;
            
	    	srvpgsql03)
			sed -i "s/MAQUINA/$(hostname)/g" /etc/hosts
			sed -i "s/NUMERO/3/g" /etc/repmgr/9.5/repmgr.conf
			sed -i "s/NOME/$(hostname)/g" /etc/repmgr/9.5/repmgr.conf
			sed -i "s/192.168.50.IP/192.168.50.4/g" /etc/repmgr/9.5/repmgr.conf
			;;
		*)
			 echo "Hostname desconhecido"
                        ;;
        esac

# Fazendo o clone do PostgreSQL Master.
rm -rvf /var/lib/pgsql/9.5/data/
su - postgres -c "/usr/pgsql-9.5/bin/repmgr -f /etc/repmgr/9.5/repmgr.conf -D /var/lib/pgsql/9.5/data/ -d repmgr  -U repmgr --verbose --ignore-external-config-files standby clone -h 192.168.50.2"
mkdir /var/run/postgresql/9.5-main.pg_stat_tmp
chown -R postgres. /var/run/postgresql/9.5-main.pg_stat_tmp

# Iniciando o postgreSQL
systemctl restart postgresql-9.5

# Cadastrando o PostgreSQL no Cluster
sleep 10
su - postgres -c "/usr/pgsql-9.5/bin/repmgr -f /etc/repmgr/9.5/repmgr.conf standby register"
