#!/usr/bin/env bash

[ -z "$PCP_USER" ] && echo "You need to set PCP_USER in .environment file}" && exit 1
[ -z "$PCP_PASS" ] && echo "You need to set PCP_PASS in .environment file}" && exit 1
[ -z "$PG_REPL_USER" ] && echo "You need to set PG_REPL_USER in .environment file}" && exit 1
[ -z "$PG_REPL_PASS" ] && echo "You need to set PG_REPL_PASS in .environment file}" && exit 1
[ -z "$APACHE_SERVER_NAME" ] && echo "You need to set APACHE_SERVER_NAME in .environment file}" && exit 1

echo "ServerName ${APACHE_SERVER_NAME}" >> /etc/apache2/apache2.conf

chown -R www-data /var/log/pgpool
chmod 755 /usr/local/bin/pgpool
chmod 755 /usr/local/bin/pcp_*

chown www-data /var/www/html/admin-tool/conf/pgmgt.conf.php
chmod 644 /var/www/html/admin-tool/conf/pgmgt.conf.php
chmod 777 /var/www/html/admin-tool/templates_c

# If config files are not present, generate default ones
if [ ! -f /usr/local/etc/pcp.conf ]; then
  cp /usr/local/etc.original/pcp.conf.sample /usr/local/etc/pcp.conf
  echo ${PCP_USER}:`pg_md5 ${PCP_PASS}` >> /usr/local/etc/pcp.conf
  chown www-data /usr/local/etc/pcp.conf
fi

if [ ! -f /usr/local/etc/pgpool.conf ]; then
  cp /usr/local/etc.original/pgpool.conf.sample-stream /usr/local/etc/pgpool.conf
  chown www-data /usr/local/etc/pgpool.conf
fi

if [ ! -f /usr/local/etc/pool_hba.conf ]; then
  cp /usr/local/etc.original/pool_hba.conf.sample /usr/local/etc/pool_hba.conf
  chown www-data /usr/local/etc/pool_hba.conf
fi

if [ ! -f /usr/local/etc/pool_passwd ]; then
  cd /usr/local/etc
  pg_md5 -m -u ${PG_REPL_USER} ${PG_REPL_PASS}
fi

rm /var/run/pgpool/pgpool.pid
rm /var/run/pgpool/.s.*
rm /tmp/.s.*
chown www-data /var/run/pgpool

/etc/init.d/apache2 start
exec /usr/local/bin/pgpool -f /usr/local/etc/pgpool.conf -a /usr/local/etc/pool_hba.conf -F /usr/local/etc/pcp.conf -d -n

