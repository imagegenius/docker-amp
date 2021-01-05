## Alpine Edge fork of [MitchTalmadge/AMP-dockerized](https://github.com/MitchTalmadge/AMP-dockerized/)
[AMP](https://cubecoders.com/AMP) is short for Application Management Panel. It's CubeCoders next-generation server administration software built for both users, and service providers. It supports both Windows and Linux based servers and allows you to manage all your game servers from a single web interface.

[![docker hub](https://img.shields.io/badge/docker_hub-link-blue?style=for-the-badge&logo=docker)](https://hub.docker.com/repository/docker/vcxpz/amp) ![docker image size](https://img.shields.io/docker/image-size/vcxpz/amp?style=for-the-badge&logo=docker) [![auto build](https://img.shields.io/badge/auto_build-disabled-grey?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-amp/actions?query=workflow%3A%22Cron+Update+CI%22)

## Version Information
![alpine](https://img.shields.io/badge/alpine-edge-0D597F?style=for-the-badge&logo=alpine-linux) ![s6 overlay](https://img.shields.io/badge/s6_overlay-2.1.0.2-blue?style=for-the-badge) ![amp](https://img.shields.io/badge/amp-2.0.9.0-blue?style=for-the-badge)

## Usage
```
docker run -d \
  _name=amp \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Australia/Melbourne \
  -p 8080:8080 \
  -e USERNAME= `#webui username` \
  -e PASSWORD= `#webui password` \
  -e LICENCE= `#see below` \
  -e MODULE= `#see below` \
  -v <path to appdata>:/config \
  _mac-address=xx:xx:xx:xx:xx:xx `#see below` \
  _restart unless-stopped \
  vcxpz/amp
```
On Unraid? There's a [template](https://github.com/hydazz/docker-templates/blob/main/hydaz/redis.xml)

See [here](https://github.com/MitchTalmadge/AMP-dockerized#environment-variables) for help setting the `LICENCE` and `MODULE` environment variables. To easily generate a MAC address for the `mac-address` variable, you can use:

**Linux**

    echo $RANDOM | md5sum | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/'

**MacOS**

    echo $RANDOM | md5 | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/'

**Windows**

    Get a new OS (https://miniwebtool.com/mac-address-generator)

## Todo
* test steamcmd
* [create an apk containing i386 libs](https://github.com/hydazz/alpine-packages/blob/edge/steamcmd)
