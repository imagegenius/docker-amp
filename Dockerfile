# get required libraries from ubuntu
FROM steamcmd/steamcmd:ubuntu-18 as builder

RUN set -x && \
   apt-get update && \
   apt-get install -y --no-install-recommends \
      libncurses5:i386 \
      libtcmalloc-minimal4:i386 && \
   mkdir -p \
      /out/lib/ \
      /out/usr/lib/ && \
   cp /lib/i386-linux-gnu/* /out/lib/ && \
   cp -r /usr/lib/i386-linux-gnu/* /out/usr/lib/ && \
   echo "**** done preparing libraries ****"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# runtime stage
FROM vcxpz/baseimage-alpine-glibc

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="AMP version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydaz"

# environment settings
ENV \
   AMP_VERSION=${VERSION} \
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
