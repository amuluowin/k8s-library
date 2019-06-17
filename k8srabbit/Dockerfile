FROM php:7.3-cli-alpine

MAINTAINER albert <63851587@qq.com>

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN apk update && apk add --no-cache --virtual .build-deps \
    g++ \
    gcc \
    autoconf \
    make \
    libmcrypt-dev \
    gmp-dev \
    icu-dev \
    zlib-dev \
    libc-dev \
    linux-headers \
    libaio-dev \
    && apk add --no-cache \
    runit \
    libcurl \
    libxml2-dev \
    yaml-dev \
    tzdata \
    pcre-dev \
    perl-dev \
    openssl-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libmcrypt-dev \

    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone \

    && docker-php-ext-install pdo_mysql bcmath opcache sockets && pecl install seaslog msgpack yaml inotify\
    && docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) soap \

    && wget https://github.com/swoole/swoole-src/archive/v4.3.5.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm swoole.tar.gz \
    && ( \
        cd swoole \
        && phpize \
        && ./configure --enable-mysqlnd --enable-openssl --enable-http2 \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r swoole \
    && docker-php-ext-enable swoole seaslog msgpack yaml inotify && pecl clear-cache\

    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && mkdir -p /data && chmod a+x /usr/bin/composer

WORKDIR /data

EXPOSE 80

CMD ["php", "bin/rabbit", "http:server","start"]
