# build jackett for musl
FROM steamcmd/steamcmd:ubuntu-18 as builder

# Install prerequisites
RUN apt-get update && \
   apt-get install -y --no-install-recommends \
      curl \
      libtcmalloc-minimal4:i386 \
      tar && \
   curl --silent -o \
      /tmp/steamcmd.tar.gz -L \
      "http://media.steampowered.com/installer/steamcmd_linux.tar.gz" && \
   tar xzf \
      /tmp/steamcmd.tar.gz -C \
      /tmp/ && \
   mkdir -p \
      /out/lib/ && \
   cp /lib/i386-linux-gnu/* /out/lib/ && \
   cp /tmp/linux32/libstdc++.so.6 /out/lib/

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# runtime stage
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
      git \
      iputils \
      procps \
      socat \
      tmux \
      unzip && \
   userdel -rf abc || true && \
   useradd -u 911 -U -d /home/abc -m -s /bin/bash abc && \
   usermod -G users abc && \
   mkdir -p \
      /app/amp/ && \
   echo "**** download ampinstmgr.zip ****" && \
   curl -o \
      /tmp/ampinstmgr.zip -L \
      "http://cubecoders.com/Downloads/ampinstmgr.zip" && \
   echo "**** unzip ampinstmgr and make symlinks ****" && \
   unzip \
      /tmp/ampinstmgr.zip -d \
      /app/amp/ && \
   ln -s /app/amp/ampinstmgr /usr/bin/ampinstmgr && \
   echo "**** download AMPCache-${VERSION//.}.zip ****" && \
   curl -o \
      /app/amp/AMPCache-${VERSION//.}.zip -L \
      "http://cubecoders.com/Downloads/AMP_Latest.zip" && \
   apk del --purge \
      build-dependencies && \
   echo "**** cleanup ****" && \
   rm -rf \
      /tmp/*

# copy files from builder
COPY --from=builder /out /

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config
