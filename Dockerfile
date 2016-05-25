FROM postgres:9.5.1

RUN apt-get -qq update && apt-get install -y -qq curl apache2 libapache2-mod-php5 php5-pgsql build-essential libpq-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src
RUN curl -L -o pgpool-II-3.5.2.tar.gz http://www.pgpool.net/download.php?f=pgpool-II-3.5.2.tar.gz
RUN tar zxf pgpool-II-3.5.2.tar.gz
WORKDIR /usr/local/src/pgpool-II-3.5.2
RUN ./configure --with-openssl && make && make install && ldconfig

WORKDIR /usr/local/src
RUN curl -L -o pgpoolAdmin-3.5.2.tar.gz http://www.pgpool.net/download.php?f=pgpoolAdmin-3.5.2.tar.gz
RUN tar xzf pgpoolAdmin-3.5.2.tar.gz
RUN mv pgpoolAdmin-3.5.2 /var/www/html/admin-tool
COPY index.html /var/www/html/
RUN rm -rf /var/www/html/admin-tool/install
RUN rm -rf /usr/local/src/*
RUN mv /usr/local/etc /usr/local/etc.original
RUN mkdir /var/log/pgpool && mkdir /var/run/pgpool

EXPOSE 80
EXPOSE 9999
ADD entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
