# requiring Docker 17.05 or higher on the daemon and client
# see https://docs.docker.com/develop/develop-images/multistage-build/
# BUILD COMMAND :
# docker --build-arg RELEASE_VERSION=v1.0.0 -t infra/wayne:v1.0.0 .

# build ui
FROM 360cloud/wayne-ui-builder:v1.0.0 as frontend

ARG RAVEN_DSN

RUN sed -i  "s~__ravenDsn__~${RAVEN_DSN}~g" /workspace/src/environments/environment.prod.ts \
    && git clone https://gitee.com/mirrors/Wayne.git \
    && mkdir -p /workspace \
    && cp -rf /Wayne/src/frontend /workspace

RUN cd /workspace && \
       npm config set registry https://registry.npm.taobao.org && \
       npm install && \
       npm run build

# build server
FROM 360cloud/wayne-server-builder:v1.0.0 as backend

COPY --from=frontend /Wayne/src/vendor /go/src/github.com/Qihoo360/wayne/src/vendor

COPY --from=frontend /Wayne/src/backend /go/src/github.com/Qihoo360/wayne/src/backend

RUN rm -rf /go/src/github.com/Qihoo360/wayne/src/backend/static

COPY --from=frontend /workspace/dist/ /go/src/github.com/Qihoo360/wayne/src/backend/static/

COPY --from=frontend /workspace/dist/index.html /go/src/github.com/Qihoo360/wayne/src/backend/views/

RUN cd /go/src/github.com/Qihoo360/wayne/src/backend && bee generate docs && bee pack -o /_build

# build release image
FROM alpine

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

COPY --from=backend /_build/backend.tar.gz /opt/wayne/src/backend/

WORKDIR /opt/wayne/src/backend/

RUN tar -xzvf backend.tar.gz && rm -f backend.tar.gz

CMD ["./backend"]
