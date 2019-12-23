FROM openjdk:8-alpine

WORKDIR /opt

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN apk update && apk add --no-cache --virtual .build-deps tzdata wget tar gzip dos2unix \
    && apk add --no-cache python-dev py-pip pyhton3-dev sudo && pip install --upgrade pip && pip install kazoo && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone
    
RUN wget https://dist.apache.org/repos/dist/dev/incubator/dolphinscheduler/1.2.0/apache-dolphinscheduler-incubating-1.2.0-dolphinscheduler-backend-bin.tar.gz

RUN mkdir -p dolphinscheduler && tar -zxvf apache-dolphinscheduler-incubating-1.2.0-dolphinscheduler-backend-bin.tar.gz -C dolphinscheduler --strip-components=1 \
    && rm -f apache-dolphinscheduler-incubating-1.2.0-dolphinscheduler-backend-bin.tar.gz \
    && chmod -R 777 dolphinscheduler/bin \
    && dos2unix dolphinscheduler/bin/* \
    && dos2unix /usr/local/bin/docker-entrypoint.sh \
    && apk del .build-deps && rm -rf /var/cache/apk/* /tmp/* /usr/share/man

EXPOSE 5566 7788 50051 7789

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["help"]