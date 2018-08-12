# musl-cross-toolchain/Dockerfile

FROM alpine

ARG BUILD_DATE
ARG VCS_REF

LABEL \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.vcs-url="https://github.com/rethink-neil/musl-cross-toolchain.git" \
  org.label-schema.vcs-ref="${VCS_REF}" \
  org.label-schema.schema-version="1.0.0-rc1"

ARG MUSL_CROSS_MAKE_VERSION="0.9.7"
ARG TARGET="x86_64-linux-musl"
ARG OUTPUT="/opt/cross"
ARG DL_CMD="curl -C- -Lo"

ENV \
  MUSL_CROSS_MAKE_VERSION="${MUSL_CROSS_MAKE_VERSION}" \
  TARGET="${TARGET}" \
  OUTPUT="${OUTPUT}" \
  DL_CMD="${DL_CMD}"

RUN set -euvx \
  && cd "$(mktemp -d)" \
  && apk --no-cache add build-base curl \
  && curl -sLO "https://github.com/richfelker/musl-cross-make/archive/v${MUSL_CROSS_MAKE_VERSION}.tar.gz" \
  && tar -xf "v${MUSL_CROSS_MAKE_VERSION}.tar.gz" \
  && echo "TARGET := ${TARGET}" >>"musl-cross-make-${MUSL_CROSS_MAKE_VERSION}/config.mak" \
  && echo "OUTPUT := ${OUTPUT}" >>"musl-cross-make-${MUSL_CROSS_MAKE_VERSION}/config.mak" \
  && echo "DL_CMD := ${DL_CMD}" >>"musl-cross-make-${MUSL_CROSS_MAKE_VERSION}/config.mak" \
  && make -C"musl-cross-make-${MUSL_CROSS_MAKE_VERSION}" -j"$(getconf _NPROCESSORS_ONLN)" install \
  && apk --no-cache del build-base curl \
  && rm -rf "${PWD}"
