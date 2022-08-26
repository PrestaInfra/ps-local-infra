FROM php:7.4-apache

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

ENV DEBIAN_FRONTEND=nointeractive

RUN echo '# 1 - INSTALL DEPENDENCIES'

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y \
  curl \
  git \
  nodejs \
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
  pgsql \
  redis \
  soap \
  xsl \
  zip \
  xdebug \
  sockets \
  apt-transport-https \
  build-essential \
  ca-certificates \
  libssl-dev \
  python \
  rsync \
  software-properties-common \
  devscripts \
  autoconf \
  ssl-cert \
  zsh


RUN echo '# 3 - INSTALL COMPOSER'

RUN install-php-extensions @composer-1
RUN composer --version # confirm installation

RUN echo '# 4 - INIT ENTRYPOINTS'

COPY entrypoints /home/entrypoints
RUN chmod -R +x /home/entrypoints/* 
WORKDIR /var/www/html
EXPOSE 80/tcp
ENTRYPOINT /home/entrypoints/prestashop/setup.sh && /bin/bash




