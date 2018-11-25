# redisSky
FROM node:6 AS build-dev

RUN apt-get update \
    && apt-get install -y wget;

RUN mkdir /app

WORKDIR /app

RUN wget https://www.golangtc.com/static/go/1.9.2/go1.9.2.linux-amd64.tar.gz \
    && tar zxvf go1.9.2.linux-amd64.tar.gz -C /usr/local \
    && mkdir -p /app/go/src \
    && mkdir /app/go/pkg \
    && mkdir /app/go/bin;

ENV GOPATH=/app/go
ENV GOROOT=/usr/local/go
ENV GOBIN=/usr/local/go/bin/
ENV PATH=$PATH:$GOBIN:/app/go/bin


RUN mkdir -p /app/go/src/github.com/prettyyjnic

WORKDIR /app/go/src/github.com/prettyyjnic
RUN git clone https://gitee.com/stuinfer/redisSky.git && sed -i "s#Vue.use(VueWebsocket, 'ws://:8089/'#Vue.use(VueWebsocket, 'ws://:80/'#g" ./redisSky/frontend/src/main.js

RUN cd /app/go/src/github.com/prettyyjnic/redisSky/frontend \
    && npm install \
    && npm run build \
    && rm -rf node_modules;

RUN cd /app/go/src/github.com/prettyyjnic/redisSky/backend/bin \
    && go build start.go;

FROM alpine

RUN apk update && apk add --no-cache tzdata && mkdir -p /redisSky && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

COPY --from=build-dev /app/go/src/github.com/prettyyjnic/redisSky/frontend /redisSky/frontend

COPY --from=build-dev /app/go/src/github.com/prettyyjnic/redisSky/backend/bin/start /redisSky/backend/bin/start

EXPOSE 8089

WORKDIR /redisSky/backend/bin

CMD ["./start"]



