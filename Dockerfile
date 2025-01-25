# Specify the base image with explicit platform
FROM --platform=$BUILDPLATFORM dunglas/frankenphp:1-php8.3-alpine AS base

# Install dependencies
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

# Build stage
FROM base AS builder
WORKDIR /app
COPY . .

# Final stage
FROM dunglas/frankenphp:1-php8.3-alpine AS final
WORKDIR /app

# Install the same dependencies in the final stage
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

# Copy from builder
COPY --from=builder /app .

CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]
