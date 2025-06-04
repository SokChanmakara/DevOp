FROM php:8.3-fpm

VOLUME [ "/var/www/html" ]
# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    git \
    nano \
    libpq-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    libsqlite3-dev \
    cron \
    gnupg2 \
    ca-certificates \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip \
    opcache \
    curl \
    xml
RUN apt-get install -y git
# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install Node.js (for Laravel Mix or Vite)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

RUN mkdir -p /var/www/html/production/public
RUN mkdir -p /var/www/html/staging/public
RUN mkdir -p /etc/nginx/sites-enabled
COPY gici4d2025.com.conf /etc/nginx/sites-available/gici4d2025.com.conf
RUN ln -s /etc/nginx/sites-available/gici4d2025.com.conf /etc/nginx/sites-enabled/
COPY gici4d2025.staging.conf /etc/nginx/sites-available/gici4d2025.staging.conf
RUN ln -s /etc/nginx/sites-available/gici4d2025.staging.conf /etc/nginx/sites-enabled/
RUN apt-get install -y openssh-server
RUN echo "root:P@ssw0rd1" | chpasswd

EXPOSE 80
EXPOSE 22
CMD ["/bin/bash", "-c", "service nginx start && php-fpm & service ssh start && tail -f /dev/null"]