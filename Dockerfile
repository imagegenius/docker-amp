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
   echo "**** install build packages ****" && \
   apk add --no-cache --virtual=build-dependencies \
      ca-certificates-mono && \
   echo "**** install runtime packages ****" && \
   apk add --no-cache --upgrade \
      curl \
      # dependencies for amp:
      git \
      iputils \
      procps \
      socat \
      unzip \
      tmux \
      # dependencies for minecraft:
      openjdk11-jre-headless \
      # dependencies for srcds
      bzip2 \
      gcc \
      libcurl \
      libstdc++6 \
      ncurses5-libs \
      sdl2 \
      zlib && \
   userdel -rf abc || true && \
   useradd -u 911 -U -d /home/abc -m -s /bin/bash abc && \
   usermod -G users abc && \
   mkdir -p \
      /app/amp/ && \
   echo "**** download ampinstmgr.zip ****" && \
   curl --silent -o \
      /tmp/ampinstmgr.zip -L \
      "http://cubecoders.com/Downloads/ampinstmgr.zip" && \
   echo "**** unzip ampinstmgr and make symlinks ****" && \
   unzip -q \
      /tmp/ampinstmgr.zip -d \
      /app/amp/ && \
   ln -s /app/amp/ampinstmgr /usr/bin/ampinstmgr && \
   echo "**** download AMPCache-${VERSION//.}.zip ****" && \
   curl --silent -o \
      /app/amp/AMPCache-${VERSION//.}.zip -L \
      "http://cubecoders.com/Downloads/AMP_Latest.zip" && \
   apk del --purge \
      build-dependencies && \
   echo "**** cleanup ****" && \
   rm -rf \
      /tmp/* \

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config
