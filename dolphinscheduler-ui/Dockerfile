FROM nginx:alpine

WORKDIR /opt

COPY docker-entrypoint.sh /usr/local/bin/
COPY default.conf /etc/nginx/conf.d

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN apk update && apk add --no-cache --virtual .build-deps tzdata wget tar gzip dos2unix \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone

RUN wget https://dist.apache.org/repos/dist/dev/incubator/dolphinscheduler/1.2.0/apache-dolphinscheduler-incubating-1.2.0-dolphinscheduler-front-bin.tar.gz

RUN mkdir -p dolphinscheduler && tar -zxvf apache-dolphinscheduler-incubating-1.2.0-dolphinscheduler-front-bin.tar.gz -C dolphinscheduler --strip-components=1 \
    && rm -f apache-dolphinscheduler-incubating-1.2.0-dolphinscheduler-front-bin.tar.gz \
    && dos2unix /usr/local/bin/docker-entrypoint.sh \
    && apk del .build-deps && rm -rf /var/cache/apk/* /tmp/* /usr/share/man

EXPOSE 8888

ENTRYPOINT ["docker-entrypoint.sh"]