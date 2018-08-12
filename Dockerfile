# musl-cross-toolchain/Dockerfile

FROM alpine

ARG VERSION="0.9.7"
ARG TARGET="x86_64-linux-musl"
ARG OUTPUT="/opt/cross"
ARG DL_CMD="curl -C- -Lo"

ENV VERSION="${VERSION}" TARGET="${TARGET}" OUTPUT="${OUTPUT}" DL_CMD="${DL_CMD}"

RUN set -euvx \
  && cd "$(mktemp -d)" \
  && apk --no-cache add build-base curl \
  && curl -sLO "https://github.com/richfelker/musl-cross-make/archive/v${VERSION}.tar.gz" \
  && tar -xf "v${VERSION}.tar.gz" \
  && echo "TARGET := ${TARGET}" >>"musl-cross-make-${VERSION}/config.mak" \
  && echo "OUTPUT := ${OUTPUT}" >>"musl-cross-make-${VERSION}/config.mak" \
  && echo "DL_CMD := ${DL_CMD}" >>"musl-cross-make-${VERSION}/config.mak" \
  && make -C"musl-cross-make-${VERSION}" -j"$(getconf _NPROCESSORS_ONLN)" install \
  && rm -rf "${PWD}"
