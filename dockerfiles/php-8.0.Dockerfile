FROM php:8.0-apache

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

ENV DEBIAN_FRONTEND=nointeractive

RUN echo '# 1 - INSTALL DEPENDENCIES'

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y \
  curl \
  git \
  wget \
  nano \
  nodejs \
  default-mysql-client \
  zip unzip \
  apt-utils mailutils


RUN echo '# 2 - INSTALL EXTENSIONS'

RUN install-php-extensions \
  bcmath \
  bz2 \
  calendar \
  imap \
  exif \
  gd \
  intl \
  ldap \
  memcached \
  mysqli \
  opcache \
  pdo_mysql \
  pdo_pgsql \
  redis \
  soap \
  xsl \
  zip \
  xdebug \
  sockets


RUN echo '# 3 - INSTALL COMPOSER'

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version # confirm installation

RUN echo '# 4 - INIT ENTRYPOINTS'

COPY entrypoints/ps-container-template /home/ps-container-template
RUN chmod -R +x /home/ps-container-template/*
WORKDIR /var/www
EXPOSE 80/tcp
ENTRYPOINT /home/ps-container-template/setup.sh && /bin/bash




