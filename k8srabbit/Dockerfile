FROM php:8-cli-bullseye

RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

RUN sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

COPY --from=composer /usr/bin/composer /usr/bin/composer
# COPY --from=stesie/libv8-7.9 /opt/libv8-7.9 /opt/libv8

RUN apt-get update -y --fix-missing && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    wget \
    zlib1g-dev \
    libc-ares-dev \
    libcurl4-openssl-dev \
    libyaml-dev \
    libxml2-dev \
    libssl-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libmcrypt-dev \
    libgmp-dev \
    libffi-dev \
    libjemalloc-dev \

    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone \
    && chmod a+x /usr/bin/composer \

    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) pdo_mysql bcmath opcache sockets zip gmp gd \
    && pecl install msgpack inotify igbinary yaml raphf xlswriter redis yac\
    && docker-php-ext-enable raphf \
    && pecl install pecl_http \
    && echo -e "extension=http.so" >> /usr/local/etc/php/conf.d/docker-php-ext-zhttp.ini \

    && wget https://github.com/swoole/swoole-src/archive/v4.8.2.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm -f swoole.tar.gz \
    && ( \
        cd swoole \
        && phpize && ./configure --enable-openssl --enable-sockets --enable-mysqlnd --enable-http2 --enable-swoole-json --enable-swoole-curl --enable-cares\
        && make -j$(nproc) && make install \
    ) \
    && rm -rf swoole \

    && git clone https://github.com/yitter/IdGenerator.git \
    && (\
        cd ./IdGenerator/PHP \
        && phpize \
        && ./configure --with-v8js=\
        && make -j$(nproc) \
        && make install \
    )  && rm -rf IdGenerator \

    # && git clone https://github.com/amuluowin/v8js.git \
    # && (\
    #     cd v8js \
    #     && phpize \
    #     && ./configure --with-v8js=/opt/libv8 LDFLAGS="-lstdc++" CPPFLAGS="-DV8_COMPRESS_POINTERS" \
    #     && make -j$(nproc) \
    #     && make install \
    # )  && rm -rf v8js \

    && git clone https://github.com/crazyxman/simdjson_php.git \
    && (\
        cd ./simdjson_php \
        && phpize \
        && ./configure \
        && make -j \
        && make install \
    )  && rm -rf simdjson_php \

    && mkdir -p /data \
    
    && docker-php-ext-enable opcache yaml igbinary xlswriter snowdrift swoole msgpack http redis simdjson yac\
    && echo -e "opcache.enable=1\nopcache.enable_cli=1\nopcache.jit=1205\nopcache.jit_buffer_size=128M" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo -e "snowdrift.WorkerIdNum=63\nsnowdrift.SeqBitLength=10\nsnowdrift.TopOverCostCount=10000\nsnowdrift.Lock=1\nsnowdrift.Multi=1" >> /usr/local/etc/php/conf.d/docker-php-ext-snowdrift.ini \
    && echo -e "yac.enable_cli=1\nyac.serializer=igbinary" >> /usr/local/etc/php/conf.d/docker-php-ext-yac.ini \

    && pecl clear-cache && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /tmp/pear/* /var/lib/apt/lists/* \
    && apt-get remove build-essential git wget -y \
    && apt-get autoremove -y \
    && echo "/usr/lib/x86_64-linux-gnu/libjemalloc.so" > /etc/ld.so.preload && chmod 0644 /etc/ld.so.preload

WORKDIR /data

EXPOSE 80

ENV LD_PRELOAD='/usr/lib/x86_64-linux-gnu/libjemalloc.so' USE_ZEND_ALLOC=0 MALLOC_CONF='background_thread:true,dirty_decay_ms:0,muzzy_decay_ms:0'

CMD ["php", "bin/rabbit", "async:server","start"]
