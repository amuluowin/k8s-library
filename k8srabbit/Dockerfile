FROM php:7.4-cli-alpine

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

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
    libxml2-dev \
    pcre-dev \
    perl-dev \
    openssl-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    libmcrypt-dev \
    cifs-utils \
    poppler-utils \
    poppler-data \
    gmp-dev \

    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone \

    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) soap pdo_mysql bcmath opcache sockets zip gmp gd && pecl install msgpack yaml inotify igbinary xlswriter \

    && wget https://github.com/swoole/swoole-src/archive/v4.5.8.tar.gz -O swoole.tar.gz \
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
    
    && wget https://github.com/swoole/sdebug/archive/sdebug_2_9-beta.tar.gz -O sdebug.tar.gz \
    && mkdir -p sdebug \
    && tar -xf sdebug.tar.gz -C sdebug --strip-components=1 \
    && rm -f sdebug.tar.gz \
    && (\
        cd sdebug \
        && phpize \
        && ./configure --enable-xdebug \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -rf sdebug \

    && git clone https://github.com/amuluowin/php-ext-snowflake.git \
    && (\
        cd php-ext-snowflake \
        && phpize \
        && ./configure --enable-snowflake\
        && make -j \
        && make install \
    ) \
    && rm -rf php-ext-snowflake \
    
    && git clone https://github.com/amuluowin/SeasClick.git \
    && (\
        cd SeasClick && git submodule update --init \
        && phpize \
        && ./configure --enable-swoole \
        && make -j \
        && make install \
        && echo "extension=SeasClick.so">/usr/local/etc/php/conf.d/docker-php-ext-zseasclick.ini \
    ) \
    && rm -rf SeasClick \
    
    && git clone https://github.com/amuluowin/php-rdkafka.git \
    && (\
        cd php-rdkafka && git submodule update --init \
        && cd lib/librdkafka \
        && ./configure --install-deps \
        && cd ../../ \
        && phpize \
        && ./configure \
        && make -j \
        && make install \
        && echo "extension=rdkafka.so">/usr/local/etc/php/conf.d/docker-php-ext-zrdkafka.ini \
    ) \
    && rm -rf php-rdkafka \
    
    && git clone https://github.com/amuluowin/ext-orm.git \
    && (\
        cd ext-orm \
        && phpize \
        && ./configure \
        && make -j \
        && make install \
    ) \
    && rm -rf ext-orm \
    
    && docker-php-ext-enable msgpack yaml inotify xlswriter igbinary swoole_orm snowflake swoole \

    && pecl clear-cache \

    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && mkdir -p /data && chmod a+x /usr/bin/composer

WORKDIR /data

EXPOSE 80

CMD ["php", "bin/rabbit", "server","start"]
