FROM alpine:latest
MAINTAINER albert <63851587@qq.com>

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
# install nginx runit curl
RUN apk --update --no-cache add nginx curl runit bash

ADD ./consul-template /usr/local/bin/consul-template
RUN chmod a+x /usr/local/bin/consul-template

ADD ./nginx.service /etc/service/nginx/run
RUN chmod a+x /etc/service/nginx/run
ADD ./consul-template.service /etc/service/consul-template/run
RUN chmod a+x /etc/service/consul-template/run

RUN rm -v /etc/nginx/conf.d/*
RUN mkdir -p /run/nginx/
ADD nginx.conf.ctmpl /etc/consul-templates/nginx.conf.ctmpl

CMD ["runsvdir", "/etc/service"]
