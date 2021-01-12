FROM vcxpz/baseimage-alpine-glibc

# set version label
ARG BUILD_DATE
ARG AMP_RELEASE
LABEL build_version="AMP version:- ${AMP_RELEASE} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydaz"

# environment settings
ENV \
   AMP_RELEASE=${AMP_RELEASE} \
   HOME=/home/abc \
   USERNAME=admin \
   PASSWORD=password \
   MODULE=ADS \
   S6_SERVICES_GRACETIME=60000

RUN set -x && \
   echo "**** install build packages ****" && \
   apk add --no-cache --virtual=build-dependencies \
      ca-certificates-mono && \
   echo "**** install runtime packages ****" && \
   apk add --no-cache --upgrade \
      curl \
      git \
      iputils \
      procps \
      socat \
      openjdk11-jre-headless \
      tmux \
      unzip && \
   echo "**** ensure abc has a shell ****" && \
   usermod -d /home/abc -m -s /bin/bash abc && \
   mkdir -p \
      /app/amp/ \
      /home/abc && \
   chown abc:abc /home/abc && \
   echo "**** download ampinstmgr.zip ****" && \
   curl -o \
      /tmp/ampinstmgr.zip -L \
      "http://cubecoders.com/Downloads/ampinstmgr.zip" && \
   echo "**** unzip ampinstmgr and make symlinks ****" && \
   unzip \
      /tmp/ampinstmgr.zip -d \
      /app/amp/ && \
   ln -s /app/amp/ampinstmgr /usr/bin/ampinstmgr && \
   echo "**** download AMPCache-${AMP_RELEASE//.}.zip ****" && \
   curl -o \
      /app/amp/AMPCache-${AMP_RELEASE//.}.zip -L \
      "http://cubecoders.com/Downloads/AMP_Latest.zip" && \
   echo "**** cleanup ****" && \
   apk del --purge \
      build-dependencies && \
   rm -rf \
      /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config
