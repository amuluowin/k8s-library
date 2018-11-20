# requiring Docker 17.05 or higher on the daemon and client
# see https://docs.docker.com/develop/develop-images/multistage-build/
# BUILD COMMAND :
# docker --build-arg RELEASE_VERSION=v1.0.0 -t infra/wayne:v1.0.0 .

# build ui
FROM 360cloud/wayne-ui-builder:v1.0.0 as frontend

ARG RAVEN_DSN

RUN mkdir -p /workspace \
    && cd /workspace && git clone https://github.com/Qihoo360/wayne.git \
    && sed -i  "s~__ravenDsn__~${RAVEN_DSN}~g" /workspace/wayne/src/frontend/src/environments/environment.prod.ts \
    && cd /workspace/wayne/src/frontend \
    && npm install  \
    && npm run build
       

# build server
FROM 360cloud/wayne-server-builder:v1.0.0 as backend

COPY --from=frontend /workspace/wayne/src/vendor /go/src/github.com/Qihoo360/wayne/src/vendor

COPY --from=frontend /workspace/wayne/src/backend /go/src/github.com/Qihoo360/wayne/src/backend

RUN rm -rf /go/src/github.com/Qihoo360/wayne/src/backend/static

COPY --from=frontend /workspace/wayne/src/frontend/dist/ /go/src/github.com/Qihoo360/wayne/src/backend/static/

COPY --from=frontend /workspace/wayne/src/frontend/dist/index.html /go/src/github.com/Qihoo360/wayne/src/backend/views/

RUN cd /go/src/github.com/Qihoo360/wayne/src/backend && bee generate docs && bee pack -o /_build

# build release image
FROM alpine

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

COPY --from=backend /_build/backend.tar.gz /opt/wayne/src/backend/

WORKDIR /opt/wayne/src/backend/

RUN tar -xzvf backend.tar.gz && rm -f backend.tar.gz

CMD ["./backend"]
