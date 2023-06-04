# syntax=docker/dockerfile:1

FROM ghcr.io/imagegenius/baseimage-ubuntu:jammy

# set version label
ARG BUILD_DATE
ARG VERSION
ARG AMP_VERSION
LABEL build_version="ImageGenius Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydazz"

# environment settings
ENV AMP_VERSION=${AMP_VERSION} \
  HOME=/config \
  USERNAME=admin \
  PASSWORD=password \
  MODULE=ADS \
  AMP_SUPPORT_LEVEL=UNSUPPORTED \
  AMP_SUPPORT_TAGS="nosupport docker community unofficial" \
  AMP_SUPPORT_URL="https://github.com/imagegenius/docker-amp/" \
  S6_SERVICES_GRACETIME=60000

RUN \
  echo "**** add mono reps ****" && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
  echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" >/etc/apt/sources.list.d/mono.list && \
  echo "**** install runtime packages ****" && \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    ca-certificates-mono \
    git \
    iputils-ping \
    lib32gcc-s1 \
    lib32stdc++6 \
    lib32z1 \
    libbz2-1.0:i386 \
    libcurl3-gnutls:i386 \
    libcurl4 \
    libncurses5:i386 \
    libsdl2-2.0-0 \
    libsdl2-2.0-0:i386 \
    libtinfo5:i386 \
    openjdk-11-jdk-headless \
    procps \
    socat \
    tmux \
    unzip \
    wget \
    xz-utils && \
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
  mkdir -p /app/amp/ && \
  curl -o \
    /app/amp/AMPCache-Mainline-${AMP_VERSION/./}.zip -L \
    "http://cubecoders.com/Downloads/AMP_Latest.zip" && \
  echo "**** cleanup ****" && \
  apt-get autoremove -y && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config
