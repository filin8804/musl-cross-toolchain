# musl-cross-toolchain/Dockerfile

FROM ubuntu

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
LABEL \
  org.label-schema.schema-version="1.0" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.vcs-ref="${VCS_REF}" \
  org.label-schema.vcs-url="${VCS_URL}" \
  maintainer="nroza@rethinkrobotics.com"

ARG MUSL_CROSS_MAKE_VERSION="0.9.7"
ARG TARGET="x86_64-linux-musl"
ARG OUTPUT="/opt/musl-cross/"
ARG DL_CMD="curl -C- -Lo"

ENV \
  DEBCONF_NONINTERACTIVE_SEEN=true \
  DEBIAN_FRONTEND=noninteractive \
  MUSL_CROSS_MAKE_VERSION="${MUSL_CROSS_MAKE_VERSION}" \
  TARGET="${TARGET}" \
  OUTPUT="${OUTPUT}" \
  DL_CMD="${DL_CMD}"

RUN set -euvx \
  && cd "$(mktemp -d)" \
  && apt-get -y update \
  && apt-get -y --no-install-recommends install build-essential ca-certificates curl \
  && curl -sLO "https://github.com/richfelker/musl-cross-make/archive/v${MUSL_CROSS_MAKE_VERSION}.tar.gz" \
  && tar -xf "v${MUSL_CROSS_MAKE_VERSION}.tar.gz" \
  && echo "TARGET := ${TARGET}" >>"musl-cross-make-${MUSL_CROSS_MAKE_VERSION}/config.mak" \
  && echo "OUTPUT := ${OUTPUT}" >>"musl-cross-make-${MUSL_CROSS_MAKE_VERSION}/config.mak" \
  && echo "DL_CMD := ${DL_CMD}" >>"musl-cross-make-${MUSL_CROSS_MAKE_VERSION}/config.mak" \
  && make -C"musl-cross-make-${MUSL_CROSS_MAKE_VERSION}" -j"$(getconf _NPROCESSORS_ONLN)" install \
  && apt-get -y purge build-essential ca-certificates curl \
  && apt-get -y autoremove \
  && apt-get -y autoclean \
  && rm -rf "${PWD}"
