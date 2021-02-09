FROM php:7-cli-alpine

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN apk update && apk add --no-cache --virtual .build-deps \
    g++ \
    gcc \
    make \
    cmake \
    autoconf \
    libmcrypt-dev \
    libc-dev \
    linux-headers \
    libaio-dev \
    zlib-dev \
    tzdata \
    bash \
    && apk add --no-cache \
    boost-dev \
    libcurl \
    icu-dev \
    git \
    curl-dev \
    yaml-dev \
    # libxml2-dev \
    openssl-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    libmcrypt-dev \
    gmp-dev \

    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone \

    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) pdo_mysql bcmath opcache sockets zip gmp gd \
    && pecl install msgpack inotify igbinary yaml raphf propro xlswriter \
    && docker-php-ext-enable raphf propro \
    && pecl install pecl_http \
    && echo -e "extension=http.so" >> /usr/local/etc/php/conf.d/docker-php-ext-zhttp.ini \

    && wget https://github.com/swoole/swoole-src/archive/v4.6.3.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm -f swoole.tar.gz \
    && ( \
        cd swoole \
        && sh make.sh cmake \
    ) \
    && rm -rf swoole \
    
    && wget https://github.com/swoole/yasd/archive/v0.3.7.tar.gz -O yasd.tar.gz \
    && mkdir -p yasd \
    && tar -xf yasd.tar.gz -C yasd --strip-components=1 \
    && rm -f yasd.tar.gz \
    && (\
        cd yasd \
        && phpize \
        && ./configure \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -rf yasd \

    && git clone https://github.com/amuluowin/php-ext-snowflake.git \
    && (\
        cd php-ext-snowflake \
        && phpize \
        && ./configure --enable-snowflake\
        && make -j \
        && make install \
    ) \
    && rm -rf php-ext-snowflake \
    
    && docker-php-ext-enable opcache msgpack yaml inotify xlswriter igbinary snowflake swoole \
    && echo -e "opcache.enable=1\nopcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \

    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /tmp/pear/* \
    && mkdir -p /data && chmod a+x /usr/bin/composer

WORKDIR /data

EXPOSE 80

CMD ["php", "bin/rabbit", "async:server","start"]
