# build libetebase
FROM mcr.microsoft.com/vscode/devcontainers/rust:latest as libetebase-build
ARG LIBETEBASE_TAG

RUN git clone https://github.com/etesync/libetebase.git -b "$LIBETEBASE_TAG" /src/libetebase
WORKDIR /src/libetebase
RUN make
RUN make install DESTDIR=/build
RUN ln -s libetebase.so /build/usr/lib/libetebase.so.0

# build etebase server

# create final image
FROM skycoder42/devcontainers-flutter:latest

# install minisign
ADD https://github.com/jedisct1/minisign/releases/download/0.11/minisign-0.11-linux.tar.gz /tmp/minisign-linux.tar.gz
RUN tar -C /tmp -xvf /tmp/minisign-linux.tar.gz &&\
  mv /tmp/minisign-linux/$(uname -m)/minisign /usr/local/bin/ &&\
  rm -rf /tmp/minisign-linux.tar.gz /tmp/minisign-linux

# install etebase server
ARG ETEBASE_SERVER_TAG
ADD etebase-server.sh /usr/local/bin/etebase-server
RUN apt-get update &&\
  apt-get upgrade -y &&\
  apt-get install -y python3-pip python3-virtualenv
RUN git clone https://github.com/etesync/server.git -b "$ETEBASE_SERVER_TAG" /opt/etebase
RUN cd /opt/etebase &&\
  virtualenv -p python3 .venv &&\
  . .venv/bin/activate &&\
  mkdir -p /var/opt/etebase/static &&\
  mkdir -p /var/opt/etebase/media &&\
  pip3 install -r requirements.txt &&\
  mv etebase-server.ini.example etebase-server.ini &&\
  sed -e '/ETEBASE_CREATE_USER_FUNC/s/^#*/#/g' -i "etebase_server/settings.py" &&\
  sed -e "s#static_root = /path/to/static#static_root = /var/opt/etebase/static#g" -i "etebase-server.ini" &&\
  sed -e "s#media_root = /path/to/media#media_root = /var/opt/etebase/media#g" -i "etebase-server.ini" &&\
  sed -e "s#allowed_host1 = example.com#allowed_host1 = *#g" -i "etebase-server.ini" &&\
  sed -e "s#name = db.sqlite3#name = /var/opt/etebase/db.sqlite3#g" -i "etebase-server.ini" &&\
  ./manage.py migrate

# add in libetebase binaries
COPY --from=libetebase-build /build /
