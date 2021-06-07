FROM php:7.4-apache

RUN apt update && apt install -yqq --no-install-recommends \
    git \
    curl \
    imagemagick \
    zip \
    pwgen \
    default-mysql-client \
    unzip \
    libpng-dev \
    libxslt-dev \
    ffmpeg \
    libzip-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install \
    gd mysqli pdo pdo_mysql  soap  xsl  sockets zip \
    && a2enmod rewrite \
    expires \
    headers

EXPOSE 80 443

COPY ilias.ini /usr/local/etc/php/conf.d/ilias.ini
COPY ILIAS-7.1.tar.gz /var/www/html/ilias.tar.gz
COPY minimal-config.json /var/www/html/

RUN tar -xzf ilias.tar.gz --strip-components=1 \
    && rm ilias.tar.gz \
    && chown -R www-data:www-data /var/www

ADD start-script.sh /start-script.sh
RUN chmod 755 /start-script.sh
CMD ["/start-script.sh"]
