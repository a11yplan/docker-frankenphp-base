FROM dunglas/frankenphp:1-php8.3-alpine AS base

RUN apk --no-cache add \
    nodejs \
    npm \
    git \
    bash \
    nano \
    mariadb-client \
    supervisor

RUN install-php-extensions \
    redis \
    pdo_mysql \
    pcntl \
    intl \
    opcache \
    bcmath \
    imap \
    gd \
    zip

RUN npm install -g bun
