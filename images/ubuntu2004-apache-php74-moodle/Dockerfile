FROM ubuntu:latest

# Run apt update and upgrade.
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive

# Add required repositories.
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:ondrej/php

# Install required packages.
RUN apt-get -y install \
    php7.4 php7.4-common php7.4-mbstring php7.4-mysql php7.4-xdebug php7.4-curl php7.4-zip php7.4-gd php7.4-intl \
    php7.4-xmlrpc php7.4-soap php7.4-xml \
    apache2 phpunit libapache2-mod-php7.4 curl nano git

# Enable PHP and Apache rewrite module.
RUN a2enmod php7.4
RUN a2enmod rewrite

# Set some envionrment variables.
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Expose port 80 to run apache on.
EXPOSE 80

# Copy over some config files to the container.
ADD apache.conf /etc/apache2/sites-enabled/000-default.conf
ADD php.ini /etc/php/7.4/apache2/conf.d/99-custom.ini

# Install Composer.
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Make data directory for Moodle to use.
RUN mkdir -m 0777 /var/www/sitedata

# Start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND