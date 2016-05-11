FROM postgres:9.5.1

RUN apt-get -qq update && apt-get install -y -qq apache2 libapache2-mod-php5 curl build-essential libpq-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src
RUN curl -L -o pgpool-II-3.5.2.tar.gz http://www.pgpool.net/download.php?f=pgpool-II-3.5.2.tar.gz
RUN tar zxf pgpool-II-3.5.2.tar.gz
WORKDIR /usr/local/src/pgpool-II-3.5.2
RUN ./configure && make && make install && ldconfig
#RUN rm -rf /usr/local/src

WORKDIR /usr/local/src
RUN curl -L -o pgpoolAdmin-3.5.2.tar.gz http://www.pgpool.net/download.php?f=pgpoolAdmin-3.5.2.tar.gz
RUN tar xzf pgpoolAdmin-3.5.2.tar.gz
RUN rm -rf /var/www/html
RUN mv pgpoolAdmin-3.5.2 /var/www/html
ADD .environment env_file

RUN mkdir /var/log/pgpool2
WORKDIR /var/www
ADD ./pgmgt.conf.php /var/www/conf/
ADD ./pool_hba.conf /usr/local/etc/
EXPOSE 80
EXPOSE 9999
ADD entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
