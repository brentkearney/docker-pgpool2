#!/usr/bin/env bash

export `cat /usr/local/src/env_file`
rm -rf /usr/local/src/*

[ -z "$PCP_USER" ] && echo "You need to set PCP_USER in .environment file}" && exit 1
[ -z "$PCP_PASS" ] && echo "You need to set PCP_PASS in .environment file}" && exit 1
[ -z "$PG_REPL_USER" ] && echo "You need to set PG_REPL_USER in .environment file}" && exit 1
[ -z "$PG_REPL_PASS" ] && echo "You need to set PG_REPL_PASS in .environment file}" && exit 1
[ -z "$APACHE_SERVER_NAME" ] && echo "You need to set APACHE_SERVER_NAME in .environment file}" && exit 1

echo "ServerName ${APACHE_SERVER_NAME}" >> /etc/apache2/apache2.conf

chown -R www-data /var/log/pgpool2
chmod 755 /usr/local/bin/pgpool
chmod 755 /usr/local/bin/pcp_*

chown www-data /var/www/html/admin-tool/conf/pgmgt.conf.php
chmod 644 /var/www/html/admin-tool/conf/pgmgt.conf.php
chmod 777 /var/www/html/admin-tool/templates_c

cp /usr/local/etc/pgpool.conf.sample /usr/local/etc/pgpool.conf
chown www-data /usr/local/etc/pgpool.conf
chmod 644 /usr/local/etc/pgpool.conf

cp /usr/local/etc/pcp.conf.sample /usr/local/etc/pcp.conf
echo ${PCP_USER}:`pg_md5 ${PCP_PASS}` >> /usr/local/etc/pcp.conf
chown www-data /usr/local/etc/pcp.conf
chmod 644 /usr/local/etc/pcp.conf

mkdir /var/run/pgpool
chown www-data /var/run/pgpool

cd /usr/local/etc
pg_md5 -m -u ${PG_REPL_USER} ${PG_REPL_PASS}
chown www-data pool_passwd

source /etc/apache2/envvars
exec /usr/sbin/apache2 -DFOREGROUND
