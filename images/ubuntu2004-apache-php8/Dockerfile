FROM ubuntu:latest

# Run apt update and upgrade.
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive

# Add required repositories.
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:ondrej/php

# Install required packages.
RUN apt-get -y install \
    apache2 php8.0 php8.0-mbstring php8.0-mysql php8.0-xdebug phpunit libapache2-mod-php8.0 curl nano git

# Enable PHP and Apache rewrite module.
RUN a2enmod php8.0
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
ADD php.ini /etc/php/8.0/apache2/conf.d/99-custom.ini

# Install Composer.
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND