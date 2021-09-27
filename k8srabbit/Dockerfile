FROM alpine as builder
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add wget build-base cmake linux-headers
RUN cd / && wget https://github.com/microsoft/mimalloc/archive/refs/tags/v2.0.2.tar.gz && tar -zxvf v2.0.2.tar.gz && cd mimalloc-2.0.2 && mkdir build && cd build && cmake .. && make -j$(nproc) && make install

FROM php:7-cli-alpine

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=builder /mimalloc-2.0.2/build/*.so.* /lib
RUN ln -s /lib/libmimalloc.so.* /lib/libmimalloc.so
ENV LD_PRELOAD=/lib/libmimalloc.so
ENV MIMALLOC_LARGE_OS_PAGES=1

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
    c-ares-dev \
    libcurl \
    icu-dev \
    git \
    wget \
    curl-dev \
    yaml-dev \
    libxml2-dev \
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

    && wget https://github.com/humanmade/alpine-v8/releases/download/7.5.288.23/v8.tar && tar -xvf v8.tar -C /usr && rm -f v8.tar \

    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) pdo_mysql bcmath opcache sockets zip gmp gd \
    && pecl install msgpack inotify igbinary yaml raphf propro xlswriter redis v8js \
    && docker-php-ext-enable raphf propro \
    && pecl install pecl_http-3.2.4 \
    && echo -e "extension=http.so" >> /usr/local/etc/php/conf.d/docker-php-ext-zhttp.ini \

    && wget https://github.com/swoole/swoole-src/archive/v4.7.1.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm -f swoole.tar.gz \
    && ( \
        cd swoole \
        && phpize && ./configure --enable-openssl --enable-sockets --enable-mysqlnd --enable-http2 --enable-swoole-json --enable-swoole-curl --enable-cares\
        && make -j$(nproc) && make install \
    ) \
    && rm -rf swoole \

    && git clone https://github.com/yitter/IdGenerator.git \
    && (\
        cd ./IdGenerator/PHP \
        && phpize \
        && ./configure \
        && make -j \
        && make install \
    )  && rm -rf IdGenerator \

    && git clone https://github.com/crazyxman/simdjson_php.git \
    && (\
        cd ./simdjson_php \
        && phpize \
        && ./configure \
        && make -j \
        && make install \
    )  && rm -rf simdjson_php \

    && mkdir -p /data \
    
    && docker-php-ext-enable opcache msgpack yaml inotify xlswriter igbinary snowdrift swoole http redis v8js simdjson\
    && echo -e "opcache.enable=1\nopcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo -e "snowdrift.WorkerIdNum=63\nsnowdrift.SeqBitLength=10\nsnowdrift.TopOverCostCount=10000\nsnowdrift.Lock=1\nsnowdrift.Multi=1" >> /usr/local/etc/php/conf.d/docker-php-ext-snowdrift.ini \

    && apk del .build-deps \
    && pecl clear-cache && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /tmp/pear/*
    

WORKDIR /data

EXPOSE 80

CMD ["php", "bin/rabbit", "async:server","start"]
