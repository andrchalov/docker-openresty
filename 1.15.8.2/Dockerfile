#
# Openresty
#

FROM debian:stretch

ENV \
  DEBIAN_FRONTEND=noninteractive \
  TERM=xterm-color \
	OPENRESTY_VERSION=1.15.8.2 \
	NGX_CONFIG=/etc/nginx

RUN apt-get update && apt-get -y install \
  build-essential \
  curl \
  libreadline-dev \
  libncurses5-dev \
  libpcre3-dev \
  libssl1.0-dev \
  perl \
  wget \
	git \
  libpq-dev \
  luarocks \
  zlib1g-dev

RUN apt-get -y install \
	postgresql-client-9.6

# Compile openresty from source.
RUN \
  wget http://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz && \
  tar -xzvf openresty-*.tar.gz && \
  rm -f openresty-*.tar.gz && \
	git clone https://github.com/evanmiller/mod_zip.git && \
  git clone -b v1.2.5 https://github.com/slact/nchan.git && \
  git clone https://github.com/flant/nginx-http-rdns.git

RUN \
  cd openresty-* && \
  # change nginx version to fake
  sed -i -- 's/^#define NGINX_VER .*/#define NGINX_VER "nginx"/g' bundle/nginx-*/src/core/nginx.h && \
  ./configure --with-http_sub_module \
              --with-http_gzip_static_module \
              --with-http_stub_status_module \
              --with-http_iconv_module \
							--with-luajit \
              --with-http_postgres_module \
              --add-module=../mod_zip \
              --add-module=../nchan \
              --add-module=../nginx-http-rdns \
  && \
  make && \
  make install && \
  make clean && \
  cd .. && \
  rm -rf openresty-* && \
	rm -rf mod_zip && \
  rm -rf nchan && \
  ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/nginx && \
  ldconfig

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log
RUN ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log

RUN luarocks install pgmoon
RUN luarocks install luafilesystem
RUN luarocks install lua-resty-auto-ssl

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

COPY docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx"]
