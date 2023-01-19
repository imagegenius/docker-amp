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
  S6_SERVICES_GRACETIME=60000

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    git \
    iputils \
    ca-certificates-mono \
    procps \
    jq \
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
  echo "**** download AMPCache.zip ****" && \
  if [ -z ${AMP_VERSION} ]; then \
    AMP_VERSION=$(curl -sL https://cubecoders.com/AMPVersions.json | \
      jq -r '.AMPCore'); \
  fi && \
  curl -o \
    /app/amp/AMPCache-${AMP_VERSION//./}.zip -L \
    "http://cubecoders.com/Downloads/AMP_Latest.zip" && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config
