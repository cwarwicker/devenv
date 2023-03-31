FROM ubuntu:latest

# Make everything non-interactive.
ENV DEBIAN_FRONTEND=noninteractive

# Run apt update and upgrade.
RUN apt-get update && apt-get -y upgrade

# Add required repositories.
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:ondrej/php

# Install required packages.
RUN apt-get -y install apache2 curl nano git \
    php8.1-common php8.1-cli php8.1-mbstring php8.1-mysql php8.1-xdebug php8.1-curl php8.1-gd php8.1-zip php8.1-xml \
    phpunit libapache2-mod-php8.1

# Enable PHP and Apache rewrite module.
RUN a2enmod php8.1
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
ADD php.ini /etc/php/8.1/apache2/conf.d/99-custom.ini

# Install Composer.
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND
