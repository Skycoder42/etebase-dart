FROM mcr.microsoft.com/vscode/devcontainers/rust:latest as libetebase-build
ARG TAG

RUN git clone https://github.com/etesync/libetebase.git -b "$TAG" /src/libetebase
WORKDIR /src/libetebase
RUN make
RUN make install DESTDIR=/build

FROM skycoder42/devcontainers-flutter:latest
COPY --from=libetebase-build /build /
