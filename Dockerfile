# syntax=docker/dockerfile:1

FROM ghcr.io/imagegenius/baseimage-alpine-glibc:latest

# set version label
ARG BUILD_DATE
ARG AMP_VERSION
ARG VERSION
LABEL build_version="ImageGenius Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydazz"

# environment settings
ENV AMP_VERSION=${AMP_VERSION} \
  HOME=/config \
  USERNAME=admin \
  PASSWORD=admin \
  MODULE=ADS \
  AMP_SUPPORT_LEVEL=UNSUPPORTED \
  AMP_SUPPORT_TAGS="nosupport docker community unofficial" \
  AMP_SUPPORT_URL="https://github.com/imagegenius/docker-amp/" \
  S6_SERVICES_GRACETIME=60000

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    ca-certificates-mono \
    git \
    icu-libs \
    iputils \
    jq \
    libstdc++ \
    procps \
    socat \
    tmux \
    unzip && \
  echo "**** ensure abc has a shell ****" && \
  usermod -d /config -m -s /bin/bash abc && \
  echo "**** download ampinstmgr.zip ****" && \
  curl -o \
    /tmp/ampinstmgr.tgz -L \
    "https://repo.cubecoders.com/ampinstmgr-latest.tgz" && \
  echo "**** unzip ampinstmgr and make symlinks ****" && \
  tar xf \
    /tmp/ampinstmgr.tgz -C \
    /tmp --strip-components=1 && \
  mv /tmp/cubecoders/amp /app/ && \
  ln -s /app/amp/ampinstmgr /usr/bin/ampinstmgr && \
  echo "**** download AMP ****" && \
  if [ -z ${AMP_VERSION} ]; then \
    AMP_VERSION=$(curl -sL "https://downloads.cubecoders.com/AMP/manifest.json" | \
      jq -r '.streams.Mainline.versions | max_by(.latestBuildTimestamp) | .version'); \
  fi && \
  LATEST_BUILD=$(curl -sL "https://downloads.cubecoders.com/AMP/manifest.json" | \
    jq -r --arg version "${AMP_VERSION}" --arg platform "x86_64" \
    '.streams.Mainline.versions[] | select(.version == $version and .platform == $platform) | .latestBuild') && \
  curl -o \
    /app/amp/AMP-x86_64-${LATEST_BUILD}.zip -L \
    "https://downloads.cubecoders.com/AMP/Mainline/${LATEST_BUILD}/AMP_x86_64.zip" && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config
