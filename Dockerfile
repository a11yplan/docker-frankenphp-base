FROM --platform=$BUILDPLATFORM dunglas/frankenphp:1-php8.3-alpine AS base

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

# Use buildplatform for the build stage
FROM --platform=$BUILDPLATFORM base AS builder
WORKDIR /app
COPY . .
ARG TARGETOS TARGETARCH

# Final stage using the target platform
FROM --platform=$TARGETPLATFORM base AS final
WORKDIR /app
COPY --from=builder /app .
CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]
