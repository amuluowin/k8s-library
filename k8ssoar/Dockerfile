FROM python:alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
      && apk update && apk --no-cache add --virtual build-dependencies\
      build-base \
      git \
      wget \
      gcc \
      musl-dev \
      libc-dev \
      libffi-dev \
      mariadb-dev \
	libxslt-dev \
      && apk add curl\
      && git clone https://github.com/xiyangxixian/soar-web.git \
      && cd /soar-web/soar && rm -f soar.linux-amd64\
      && wget https://github.com/XiaoMi/soar/releases/download/0.9.0/soar.linux-amd64 -O soar.linux-amd64 && chmod a+x soar.linux-amd64 \
      && cd ../ \
      && pip3 install -r requirement.txt -i https://pypi.douban.com/simple/\
      && rm -rf .cache/pip3 \
      && mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 \
      && apk del build-dependencies

WORKDIR /soar-web
EXPOSE 5077
CMD sh /soar-web/run.sh
