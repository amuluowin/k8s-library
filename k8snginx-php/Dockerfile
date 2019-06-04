FROM php:7.2-fpm-alpine

MAINTAINER albert <63851587@qq.com>

ENV TIMEZONE Asia/Shanghai

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

#基础依赖
RUN apk update \
    && apk add --no-cache --virtual .build-deps \
    autoconf \
    build-base \
    binutils \
    musl \
    linux-headers &&\
    apk add tzdata runit nginx freetype-dev gd-dev libjpeg-turbo-dev libpng-dev libmcrypt-dev libevent-dev git && \
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /usr/local/etc/php-fpm.conf && \
    sed -i -e "s/listen\s*=\s*127.0.0.1:9000/listen = 9000/g" /usr/local/etc/php-fpm.d/www.conf && \
    docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir &&\
    docker-php-ext-install -j$(nproc) gd &&\
    docker-php-ext-install pdo_mysql mysqli bcmath sockets opcache zip && pecl install seaslog &&\
    docker-php-ext-enable seaslog mysqli && pecl clear-cache &&\
    mkdir -p /run/nginx \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man

ADD ./nginx.service /etc/service/nginx/run
RUN chmod a+x /etc/service/nginx/run
ADD ./fpm.service /etc/service/fpm/run
RUN chmod a+x /etc/service/fpm/run
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./default.conf /etc/nginx/conf.d/default.conf
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN chmod a+x /usr/bin/composer

WORKDIR /data

EXPOSE 80
CMD ["runsvdir", "/etc/service"]