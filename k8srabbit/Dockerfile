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
    icu-dev \
    zlib-dev \
    libc-dev \
    linux-headers \
    libaio-dev \
    tzdata \
    git \
    && apk add --no-cache \
    libcurl \
    yaml-dev \
    pcre-dev \
    perl-dev \
    openssl-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    libmcrypt-dev \
    gmp-dev \

    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone \

    && docker-php-ext-install pdo_mysql bcmath opcache sockets zip gmp && pecl install msgpack yaml seaslog inotify\
    && docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir \
    && docker-php-ext-install -j$(nproc) gd \

    && wget https://github.com/swoole/swoole-src/archive/v4.4.7.tar.gz -O swoole.tar.gz \
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
    
    && wget https://github.com/mabu233/sdebug/archive/sdebug_2_7-beta.tar.gz -O sdebug.tar.gz \
    && mkdir -p sdebug \
    && tar -xf sdebug.tar.gz -C sdebug --strip-components=1 \
    && rm sdebug.tar.gz \
    && (\
        cd sdebug \
        && phpize \
        && ./configure --enable-xdebug \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r sdebug \
    
    && git clone https://github.com/osgochina/donkeyid.git \
    && (\
        cd donkeyid/donkeyid \
        && phpize \
        && ./configure \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r donkeyid \
    
    && docker-php-ext-enable swoole msgpack yaml inotify donkeyid && pecl clear-cache\

    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && mkdir -p /data && chmod a+x /usr/bin/composer

WORKDIR /data

EXPOSE 80

CMD ["php", "bin/rabbit", "server","start"]