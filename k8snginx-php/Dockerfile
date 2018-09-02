FROM php:7.1.20-fpm-alpine

MAINTAINER albert <63851587@qq.com>

ENV TIMEZONE Asia/Shanghai

#基础依赖
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk update && \
    apk add tzdata runit nginx && \
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /usr/local/etc/php-fpm.conf && \
    sed -i -e "s/listen\s*=\s*127.0.0.1:9000/listen = 9000/g" /usr/local/etc/php-fpm.d/www.conf && \
    docker-php-ext-install pdo_mysql bcmath sockets opcache &&\
    mkdir -p /run/nginx && \
    rm -rf /var/cache/apk/*

ADD ./nginx.service /etc/service/nginx/run
RUN chmod a+x /etc/service/nginx/run
ADD ./fpm.service /etc/service/fpm/run
RUN chmod a+x /etc/service/fpm/run
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["runsvdir", "/etc/service"]