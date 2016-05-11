# docker-pgpool2

Builds a Docker container running pgpool-II and pgpoolAdmin, versions 3.5.2. Based off of the [postgres docker image](https://hub.docker.com/_/postgres/).
Configuration is persisted vi host-mounted files in ./config, logs are in ./logs.

## Usage: 
* Edit .environment to set usernames & passwords, and web server hostname.
* Edit docker-compose.yml if you want port mappings other than 8000 -> 80, 9999 -> 9999, or other locations for host mounted directories.
* Edit config/pgmgt.conf.php if you want a language other than English.
* Run `docker-compose build` to build the image.
* Run `docker-compose up -d` to run the container.
* Visit http://yourhostname:8000 to login and configure pgpool-II. 
* In the "pgpool.conf Setting" tab, set the socket file locations to /var/run/pgpool.

### References:
* [pgpool-II user manual](http://www.pgpool.net/docs/latest/pgpool-en.html)
* [pgpool-II setup tutorial](http://www.pgpool.net/docs/latest/tutorial-en.html)
* [pgpoolAdmin web page](http://www.pgpool.net/docs/pgpoolAdmin/index_en.html)

