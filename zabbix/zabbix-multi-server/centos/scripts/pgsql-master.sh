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
systemctl start postgresql-9.5

# Preparando o cenário dos PostgreSQL Master
echo -e "CREATE USER zabbix WITH PASSWORD '123456789'; \nCREATE DATABASE zabbixdb OWNER zabbix;" > /tmp/sql
su - postgres -c "psql < /tmp/sql"
rm -f /tmp/sql
su - postgres -c "createuser -s repmgr"
su - postgres -c "createdb repmgr -O repmgr"
su - postgres -c "psql -f /usr/pgsql-9.5/share/contrib/repmgr_funcs.sql repmgr"
systemctl stop postgresql-9.5
mv -fv ${VAGRANT_HOME}/conf/postgresql.conf /var/lib/pgsql/9.5/data/
mv -fv ${VAGRANT_HOME}/conf/pg_hba.conf /var/lib/pgsql/9.5/data/
mv -fv ${VAGRANT_HOME}/conf/repmgr.conf /etc/repmgr/9.5/
mv -fv ${VAGRANT_HOME}/conf/hosts /etc/hosts
chown -R postgres. /var/lib/pgsql/9.5/data/
chmod 644 /var/lib/pgsql/9.5/data/postgresql.conf
chmod 600 /var/lib/pgsql/9.5/data/pg_hba.conf
sed -i "s/MAQUINA/$(hostname)/g" /etc/hosts
sed -i "s/NUMERO/1/g" /etc/repmgr/9.5/repmgr.conf
sed -i "s/NOME/$(hostname)/g" /etc/repmgr/9.5/repmgr.conf
sed -i "s/192.168.50.IP/192.168.50.2/g" /etc/repmgr/9.5/repmgr.conf
systemctl start postgresql-9.5

# Cadastrando o PostgreSQL no Cluster
su - postgres -c "/usr/pgsql-9.5/bin/repmgr -f /etc/repmgr/9.5/repmgr.conf master register"
su - postgres -c "/usr/pgsql-9.5/bin/repmgr -f /etc/repmgr/9.5/repmgr.conf cluster show"
