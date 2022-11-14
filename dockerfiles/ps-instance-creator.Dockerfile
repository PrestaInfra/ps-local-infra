FROM php:8.1-apache

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

ENV DEBIAN_FRONTEND=nointeractive

RUN echo '# 1 - INSTALL DEPENDENCIES'

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y \
  curl \
  git \
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
  opcache \
  xsl \
  zip \
  sockets

WORKDIR /var/www/html
EXPOSE 80/tcp




