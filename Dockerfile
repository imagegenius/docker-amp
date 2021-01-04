FROM vcxpz/baseimage-glibc

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="AMP version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Alex Hyde"

# environment settings
ENV \
   AMP_VERSION=$VERSION \
   HOME=/home/abc \
   USERNAME=admin \
   PASSWORD=password \
   MODULE=ADS

RUN \
   echo "**** install runtime packages ****" && \
   apk add --no-cache --upgrade \
      curl \
      # Dependencies for AMP:
      tmux \
      git \
      socat \
      unzip \
      iputils \
      procps \
      # Dependencies for Minecraft:
      openjdk11-jre-headless \
      # Most dependencies for srcds (TF2, GMod, ...)
      libcurl \
      gcc \
      libstdc++6 && \
   userdel -rf abc || true && \
   useradd -u 911 -U -d /home/abc -m -s /bin/bash abc && \
   usermod -G users abc && \
   mkdir -p \
      /app/amp/ && \
   echo "**** downloading ampinstmgr.zip ****" && \
   curl --silent -o \
      /tmp/ampinstmgr.zip -L \
      "http://cubecoders.com/Downloads/ampinstmgr.zip" && \
   echo "**** unziping ampinstmgr and making symlinks ****" && \
   unzip -q \
      /tmp/ampinstmgr.zip -d \
      /app/amp/ && \
   echo "**** downloading AMPCache-${VERSION//.}.zip ****" && \
   curl --silent -o \
      /app/amp/AMPCache-${VERSION//.}.zip -L \
      "http://cubecoders.com/Downloads/AMP_Latest.zip" && \
   ln -s /app/amp/ampinstmgr /usr/bin/ampinstmgr && \
   curl --silent -o \
      /tmp/cacert.pem -L \
      "https://curl.haxx.se/ca/cacert.pem" && \
   cert-sync /tmp/cacert.pem && \
   echo "**** cleanup ****" && \
   rm -rf \
      /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config
