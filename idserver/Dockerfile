FROM php:8-cli-alpine

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

ADD ./swow /data/swow

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
    git \
    openssl-dev \
    gmp-dev \
    libffi-dev \

    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone \
    && chmod a+x /usr/bin/composer \

    && docker-php-ext-install -j$(nproc) opcache pcntl gmp \

    && git clone https://gitee.com/laoyaosu/idgenerator.git \
    && (\
        cd ./idgenerator/PHP \
        && phpize \
        && ./configure \
        && make -j \
        && make install \
        && echo -e "snowdrift.WorkerIdNum=63\nsnowdrift.SeqBitLength=10\nsnowdrift.TopOverCostCount=10000\nsnowdrift.Lock=1" >> /usr/local/etc/php/conf.d/docker-php-ext-snowdrift.ini \
        && cd /data && composer require swow/swow dev-develop -o && ./vendor/bin/swow-builder \
    )  && rm -rf idgenerator \

    && docker-php-ext-enable opcache snowdrift swow \
    && echo -e "opcache.enable=1\nopcache.enable_cli=1\nopcache.jit=1205\nopcache.jit_buffer_size=128M" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \

    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /tmp/pear/* \
    && chmod +x /data/swow

WORKDIR /data

EXPOSE 8099

CMD ["./swow"]
