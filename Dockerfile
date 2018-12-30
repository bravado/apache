FROM ubuntu:12.04

# add newrelic repository
RUN echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' > /etc/apt/sources.list.d/newrelic.list

# trust in newrelic key
ADD https://download.newrelic.com/548C16BF.gpg /tmp/newrelic.gpg
RUN apt-key add /tmp/newrelic.gpg

# Update the package lists and install everything
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  \
    apache2 \
    libapache2-mod-php5 \
    php5-mysqlnd \
    php5-mcrypt \
    php5-memcache \
    php5-curl \
    php5-gd \
    php5-imagick \
    php5-intl \
    php5-imap \
    php5 \
    php-pear \
    php-apc \
    supervisor \
    unzip \
    curl \
    ssmtp \
    && cd /opt && apt-get download newrelic-daemon newrelic-php5 newrelic-php5-common \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/*.log

# Configure timezone and locale
# Set the default timezone in cli and fpm configs
# Setup logging to stderr
# Enable apache modules
RUN echo "America/Sao_Paulo" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata && \
    sed -ie 's/\;date\.timezone\ \=/date\.timezone\ \=\ America\/Sao_Paulo/g' /etc/php5/cli/php.ini && \
    sed -ie 's/\;date\.timezone\ \=/date\.timezone\ \=\ America\/Sao_Paulo/g' /etc/php5/apache2/php.ini && \
    sed -ie 's/${APACHE_LOG_DIR}\/error.log/\/proc\/self\/fd\/2/' /etc/apache2/apache2.conf && \
    a2enmod actions && \
    a2enmod expires && \
    a2enmod headers && \
    a2enmod rewrite

# container parameters that may be set at runtime
ENV NR_APP_NAME ""
ENV NR_INSTALL_KEY ""

ENV PUID 1000
ENV PGID 1000

# Apache vars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_CONF_DIR /etc/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_DOCUMENT_ROOT /var/www/html

# PHP vars
ENV PHP_MEMORY_LIMIT 128M
ENV PHP_SESSION_SAVE_HANDLER files
ENV PHP_SESSION_SAVE_PATH /var/lib/php5/sessions
ENV PHP_UPLOAD_MAX_FILESIZE 50M
ENV PHP_POST_MAX_SIZE 50M
ENV PHP_SHORT_OPEN_TAG On
ENV PHP_MAX_EXECUTION_TIME 30
ENV PHP_REGISTER_GLOBALS Off

ENV APC_ENABLED 1
ENV APC_SHM_SIZE 32M
ENV APC_NUM_FILES_HINT 1000
ENV APC_TTL 60
ENV APC_USER_TTL 300
ENV APC_GC_TTL 3600
# end of parameters

EXPOSE 80

ADD etc /etc

RUN chmod +x /etc/entrypoint.sh && mkdir /var/run/apache2 && mkdir /var/www/html

ENTRYPOINT '/etc/entrypoint.sh'
