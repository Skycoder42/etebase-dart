FROM mcr.microsoft.com/vscode/devcontainers/rust:latest as libetebase-build
ARG TAG

RUN git clone https://github.com/etesync/libetebase.git -b "$TAG" /src/libetebase
WORKDIR /src/libetebase
RUN make
RUN make install DESTDIR=/build

FROM skycoder42/devcontainers-flutter:latest
COPY --from=libetebase-build /build /

ADD https://github.com/jedisct1/minisign/releases/download/0.11/minisign-0.11-linux.tar.gz /tmp/minisign-linux.tar.gz
RUN tar -C /tmp -xvf /tmp/minisign-linux.tar.gz &&\
  mv /tmp/minisign-linux/$(uname -m)/minisign /usr/local/bin/ &&\
  rm -rf /tmp/minisign-linux.tar.gz /tmp/minisign-linux
