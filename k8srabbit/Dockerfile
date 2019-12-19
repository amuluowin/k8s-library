FROM php:7.3-cli-alpine

MAINTAINER albert <63851587@qq.com>

COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN apk update && apk add --no-cache --virtual .build-deps \
    g++ \
    gcc \
    make \
    autoconf \
    libmcrypt-dev \
    icu-dev \
    libc-dev \
    linux-headers \
    libaio-dev \
    zlib-dev \
    tzdata \
    git \
    rapidjson-dev \
    bash \
    && apk add --no-cache cyrus-sasl-dev lz4-dev zstd-dev \
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

    && docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir \
    && docker-php-ext-install pdo_mysql bcmath opcache sockets zip gmp gd && pecl install msgpack yaml inotify igbinary \

    && wget https://github.com/swoole/swoole-src/archive/v4.4.13.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm -f swoole.tar.gz \
    && ( \
        cd swoole \
        && phpize \
        && ./configure --enable-mysqlnd --enable-openssl --enable-http2 --enable-sockets \
        && make -j \
        && make install \
    ) \
    && rm -rf swoole \
    
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
    && rm -rf sdebug \

    && git clone https://github.com/viest/php-ext-excel-export \
    && (\
        cd php-ext-excel-export \
        && git submodule update --init \
        && phpize \
        && ./configure --enable-reader \
        && make -j \
        && make install \
    ) \
    && rm -rf php-ext-excel-export \

    && git clone https://github.com/osgochina/donkeyid.git \
    && (\
        cd donkeyid/donkeyid \
        && phpize \
        && ./configure \
        && make -j \
        && make install \
    ) \
    && rm -rf donkeyid \
    
    && git clone https://github.com/amuluowin/SeasClick.git \
    && (\
        cd SeasClick \
        && phpize \
        && ./configure --enable-swoole \
        && make -j \
        && make install \
        && echo "extension=SeasClick.so">/usr/local/etc/php/conf.d/docker-php-ext-zseasclick.ini \
    ) \
    && rm -rf SeasClick \
    
    && git clone https://github.com/amuluowin/php-rdkafka.git \
    && (\
        chmod -R 777 php-rdkafka \
        && cd php-rdkafka/lib/librdkafka \
        && ./configure --install-deps \
        && cd ../../ \
        && phpize \
        && ./configure \
        && make -j \
        && make install \
        && echo "extension=rdkafka.so">/usr/local/etc/php/conf.d/docker-php-ext-zrdkafka.ini \
    ) \
    && rm -rf php-rdkafka \
    
    && docker-php-ext-enable swoole msgpack yaml inotify donkeyid xlswriter igbinary && pecl clear-cache\

    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && mkdir -p /data && chmod a+x /usr/bin/composer

WORKDIR /data

EXPOSE 80

CMD ["php", "bin/rabbit", "server","start"]
