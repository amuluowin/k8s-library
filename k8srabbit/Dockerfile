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
    && chmod a+x /usr/bin/composer \

    && wget https://github.com/humanmade/alpine-v8/releases/download/8.0.426.27/v8.tar && tar -xvf v8.tar -C /usr && rm -f v8.tar \

    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) pdo_mysql bcmath opcache sockets zip gmp gd \
    && pecl install msgpack inotify igbinary yaml raphf propro xlswriter redis v8js \
    && docker-php-ext-enable raphf propro \
    && pecl install pecl_http-3.2.4 \
    && echo -e "extension=http.so" >> /usr/local/etc/php/conf.d/docker-php-ext-zhttp.ini \

    && wget https://github.com/swoole/swoole-src/archive/v4.6.7.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm -f swoole.tar.gz \
    && ( \
        cd swoole \
        && phpize && ./configure --enable-openssl --enable-sockets --enable-mysqlnd --enable-http2 --enable-swoole-json --enable-swoole-curl \
        && make -j$(nproc) && make install \
    ) \
    && rm -rf swoole \

    && git clone https://gitee.com/laoyaosu/idgenerator.git \
    && (\
        cd ./idgenerator/PHP \
        && phpize \
        && ./configure \
        && make -j \
        && make install \
    )  && rm -rf idgenerator \

    && mkdir -p /data \
    
    && docker-php-ext-enable opcache msgpack yaml inotify xlswriter igbinary snowdrift swoole http redis v8js\
    && echo -e "opcache.enable=1\nopcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \

    && apk del .build-deps \
    && pecl clear-cache && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /tmp/pear/*
    

WORKDIR /data

EXPOSE 80

CMD ["php", "bin/rabbit", "async:server","start"]
