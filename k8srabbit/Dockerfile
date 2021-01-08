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
    bash \
    && apk add --no-cache \
    libcurl \
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
    && wget https://github.com/FriendsOfPHP/pickle/releases/download/v0.6.0/pickle.phar && chmod +x pickle.phar && mv pickle.phar /usr/local/bin/pickle \

    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) pdo_mysql bcmath opcache sockets zip gmp gd raphf http \
    && pickle install msgpack \
    && pickle install inotify \
    && pickle install igbinary \
    && pickle install yaml \

    && wget https://github.com/swoole/swoole-src/archive/v4.6.0.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm -f swoole.tar.gz \
    && ( \
        cd swoole \
        && phpize \
        && ./configure --enable-openssl --enable-http2 --enable-swoole-curl \
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

    && git clone https://github.com/viest/php-ext-excel-export \
    && (\
        cd php-ext-excel-export &&  git submodule update --init \
        && phpize \
        && ./configure --enable-reader \
        && make -j \
        && make install \
    ) \
    && rm -rf php-ext-excel-export \
    
    && docker-php-ext-enable opcache msgpack yaml inotify xlswriter igbinary snowflake swoole \
    && echo -e "opcache.enable=1\nopcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \

    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && mkdir -p /data && chmod a+x /usr/bin/composer

WORKDIR /data

EXPOSE 80

CMD ["php", "bin/rabbit", "async:server","start"]
