FROM php:7.0-apache

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    imagemagick \
    libav-tools \
    libpng-dev \
    libxslt-dev \
    mysql-client \
    pwgen \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install \
    gd \
    mysqli \
    pdo \
    pdo_mysql \
    soap \
    xsl \
    zip \
    sockets

RUN a2enmod \
    expires \
    headers \
    rewrite \
    ssl

EXPOSE 80 443

ENV ILIAS_WWW_PATH=/var/www/html
ENV ILIAS_DATA_PATH=/var/www/html/data
ENV ILIAS_ILIASDATA_PATH=/var/iliasdata/ilias

RUN mkdir -p ${ILIAS_ILIASDATA_PATH} \
    && chown www-data:root ${ILIAS_ILIASDATA_PATH} \
    && chmod 775 ${ILIAS_ILIASDATA_PATH}
VOLUME ${ILIAS_ILIASDATA_PATH}

RUN mkdir ${ILIAS_DATA_PATH} \
    && chown www-data:root ${ILIAS_DATA_PATH} \
    && chmod 775 ${ILIAS_DATA_PATH}
VOLUME ${ILIAS_DATA_PATH}

COPY docker-ilias-entrypoint /usr/local/bin/
COPY install-ilias /usr/local/bin/

ENTRYPOINT ["docker-ilias-entrypoint"]
CMD ["apache2-foreground"]

ENV ILIAS_VERSION=5.3.6
ENV ILIAS_SHA1=0aa554d32d3a5ea9fafd378637b76f2c864e23c2

COPY ILIAS-${ILIAS_VERSION}.tar.gz ilias.tar.gz

RUN echo "$ILIAS_SHA1 *ilias.tar.gz" | sha1sum -c - \
    && tar -xzf ilias.tar.gz --strip-components=1 \
    && rm ilias.tar.gz
