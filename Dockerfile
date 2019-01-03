FROM nginx:1.15.8

ENV NGINX_VERSION     "1.15.8"
ENV NGINX_VTS_VERSION "0.1.18"

RUN apt-get update \
  && apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl dpkg-dev \
  && echo "deb-src https://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list \
  && apt-get update \
  && mkdir -p /opt/rebuildnginx \
  && chmod 0777 /opt/rebuildnginx \
  && cd /opt/rebuildnginx \
  && apt-get source nginx \
  && apt-get build-dep -y nginx=${NGINX_VERSION} \
  && cd /opt \
  && curl -sL https://github.com/vozlt/nginx-module-vts/archive/v${NGINX_VTS_VERSION}.tar.gz | tar -xz \
  && sed -i -r -e "s/\.\/configure(.*)/.\/configure\1 --add-module=\/opt\/nginx-module-vts-${NGINX_VTS_VERSION}/" /opt/rebuildnginx/nginx-${NGINX_VERSION}/debian/rules \
  && cd /opt/rebuildnginx/nginx-${NGINX_VERSION} \
  && dpkg-buildpackage -b \
  && cd /opt/rebuildnginx \
  && dpkg --install nginx_${NGINX_VERSION}-1~stretch_amd64.deb \
  && apt-get remove --purge -y apt-transport-https ca-certificates curl dpkg-dev \
  && apt-get -y --purge autoremove \
  && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list

CMD ["nginx", "-g", "daemon off;"]
