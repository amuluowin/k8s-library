FROM php:7.1.20-cli-alpine

MAINTAINER albert <63851587@qq.com>

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps \
    g++ \
    gcc \
    autoconf \
    make \
    libmcrypt-dev \
    gmp-dev \
    icu-dev \
    zlib-dev \
    musl \
    libc-dev \
    linux-headers \
    libaio-dev \
    && apk add --no-cache --virtual .deps \
    libcurl \
    ca-certificates \
    tzdata \
    nghttp2-dev \
    hiredis-dev \
    openssl-dev \
    pcre-dev \
    perl-dev \

    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone \

    && docker-php-ext-install pdo_mysql bcmath sockets\

    && wget https://github.com/swoole/swoole-src/archive/v4.0.4.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm swoole.tar.gz \
    && ( \
        cd swoole \
        && phpize \
        && ./configure --enable-async-redis --enable-mysqlnd --enable-coroutine --enable-openssl --enable-http2 \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r swoole \
    && docker-php-ext-enable swoole \

    && apk del .build-deps \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && mkdir -p /data/wwwroot \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update --clean-backups \
    && composer install --no-dev \
          && composer dump-autoload -o \
          && composer clearcache

#ADD . /data/wwwroot/yiisw
#
#WORKDIR /data/wwwroot/yiisw

EXPOSE 80

CMD ["php", "/data/wwwroot/yiisw", "swoole/websocket","start"]