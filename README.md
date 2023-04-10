<!-- DO NOT EDIT THIS FILE MANUALLY  -->

# [imagegenius/amp](https://github.com/imagegenius/docker-amp)

[![GitHub Release](https://img.shields.io/github/release/imagegenius/docker-amp.svg?color=007EC6&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/imagegenius/docker-amp/releases)
[![GitHub Package Repository](https://shields.io/badge/GitHub%20Package-blue?logo=github&logoColor=ffffff&style=for-the-badge)](https://github.com/imagegenius/docker-amp/packages)
[![Jenkins Build](https://img.shields.io/jenkins/build?labelColor=555555&logoColor=ffffff&style=for-the-badge&jobUrl=https%3A%2F%2Fci.imagegenius.io%2Fjob%2FDocker-Pipeline-Builders%2Fjob%2Fdocker-amp%2Fjob%2Fmain%2F&logo=jenkins)](https://ci.imagegenius.io/job/Docker-Pipeline-Builders/job/docker-amp/job/main/)

[AMP](https://cubecoders.com/AMP) (Application Management Panel) is a simple to use and easy to install control panel and management system for hosting game servers. It runs on both Windows and Linux and requires no command line knowledge to get started. Everything is taken care of by its clear and intuitive web interface, making it a breeze to use.

[![amp](https://cubecoders.com/Content/images/LogoColor.png)](https://cubecoders.com/AMP)

## Supported Architectures

We use Docker manifest for cross-platform compatibility. More details can be found on [Docker's website](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list).

To obtain the appropriate image for your architecture, simply pull `ghcr.io/imagegenius/amp:latest`. Alternatively, you can also obtain specific architecture images by using tags.

This image supports the following architectures:

| Architecture | Available | Tag |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ❌ | |
| armhf | ❌ | |

## Version Tags

This image offers different versions via tags. Be cautious when using unstable or development tags, and read their descriptions carefully.

| Tag | Available | Description |
| :----: | :----: |--- |
| latest | ✅ | Latest AMP Release with an Alpine base, tiny image but only java servers will work |
| ubuntu | ✅ | Latest AMP release with an Ubuntu Base, limited to java servers at this time |
## Application Setup

As it takes more than 10 seconds (the default timeout for Docker) for AMP to do a graceful shutdown, make sure you have no running modules. Stopping your container via Docker while you have running modules may cause corruption as Docker will kill the container.

**Java is not installed by default, see [here](https://github.com/imagegenius/docker-amp#java-versions) for more information**

## Supported Modules

**Will Work:**

- Java applications such as Minecraft Java, Minecraft Bedrock + others

**Won't Work:**

- [Everything Else](https://github.com/CubeCoders/AMP/wiki/Supported-Applications-Compatibility)

## MAC Address (Important)

AMP is designed to detect hardware changes and will de-activate all instances when something significant changes. This is to stop people from sharing pre-activated instances and bypassing the licencing server. One way of detecting changes is to look at the MAC address of the host's network card. A change here will de-activate instances.

By default, Docker assigns a new MAC address to a container every time it is restarted. Therefore, unless you want to painstakingly re-activate all your instances on every server reboot, you need to assign a permanent MAC address.

For most people, this can be accomplished by generating a random MAC address in Docker's acceptable range. The instructions to do so are as follows:

- Visit this page: https://miniwebtool.com/mac-address-generator/
- Put `02:42:AC` in as the prefix
- Choose the format with colons `:`
- Generate

- Copy the generated MAC and use it when starting the container.

  - For `docker run`, use the following flag: (Substitute your generated MAC)

    `--mac-address="02:42:AC:XX:XX:XX"`

  - For Docker Compose, use the following key next to `image`:

    `mac_address: 02:42:AC:XX:XX:XX`

If you have a unique network situation, a random MAC may not work for you. In that case you will need to come up with your own solution to prevent address conflicts.

If you need help with any of this, please make an issue.

## Ports

Here's a rough (and potentially incorrect) list of default ports for the various modules. Each module also exposes port 8080 for the Web UI (can be changed with environment variables). If you find an inaccuracy, open an issue!

| Module Name | Default Ports                           |
| ----------- | --------------------------------------- |
| `ADS`       | No additional ports.                    |
| `McMyAdmin` | TCP 25565                               |
| `Minecraft` | TCP 25565 (Java) or UDP 19132 (Bedrock) |

Just a quick note about ports: some games use TCP, some games use UDP. Make sure you are using the right protocol. Don't fall into the trap of accidentally mapping a TCP port for a UDP game -- you won't be able to connect.

## Environment Variables

###  Java Versions

| Name | Description | Default Value |
| -------- | ---------------------------------------------------------------- | ------------- |
| `JAVA_VERSIONS` | Set this to the java versions you need, java is not installed by default and must be set here. Supported java versions range from 7-17, you can have multiple versions specified, seperated by a comma. Example: `7,9,13`... | `None` |

### Module

| Name     | Description                                                      | Default Value |
| -------- | ---------------------------------------------------------------- | ------------- |
| `MODULE` | Which Module to use for the main instance created by this image. | `ADS`         |

To run multiple game servers under this image, use the default value of `ADS` (Application Deployment Service) which allows you to create various modules from the web ui.

To be clear, this Docker image creates ONE instance by default. If you want to create more, use `ADS` as the first instance, and create the rest with the web UI. Otherwise, you can pick any other module from the list.

Here are the accepted values for the `MODULE` variable:

| Module Name | Description                                                                                                   |
| ----------- | ------------------------------------------------------------------------------------------------------------- |
| `ADS`       | Application Deployment Service. Used to manage multiple modules. Need multiple game servers? Pick this.       |
| `McMyAdmin` | If you have a McMyAdmin Licence, this will be picked for you no matter what. It is equivalent to `Minecraft`. |
| `Minecraft` | Includes Java (Spigot, Bukkit, Paper, etc.) and Bedrock servers.                                              |

## Usage

Example snippets to start creating a container:

### Docker Compose

```yaml
---
version: "2.1"
services:
  amp:
    image: ghcr.io/imagegenius/amp:latest
    container_name: amp
    mac_address: 00:00:00:00:00:00
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - USERNAME=admin
      - PASSWORD=admin
      - LICENCE=000-000-000-000
      - JAVA_VERSIONS=7,9,13 #optional
      - MODULE=ADS #optional
    volumes:
      - <path to data>:/config
    ports:
      - 8080:8080
      - 25565:25565 #optional
    restart: unless-stopped
```

### Docker CLI ([Click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=amp \
  --mac-address=00:00:00:00:00:00 \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e USERNAME=admin \
  -e PASSWORD=admin \
  -e LICENCE=000-000-000-000 \
  -e JAVA_VERSIONS=7,9,13 `#optional` \
  -e MODULE=ADS `#optional` \
  -p 8080:8080 \
  -p 25565:25565 `#optional` \
  -v <path to data>:/config \
  --restart unless-stopped \
  ghcr.io/imagegenius/amp:latest

```

## Variables

To configure the container, pass variables at runtime using the format `<external>:<internal>`. For instance, `-p 8080:80` exposes port `80` inside the container, making it accessible outside the container via the host's IP on port `8080`.

| Variable | Description |
| :----: | --- |
| `--mac-address=` | Set the mac_address for the license check. |
| `-p 8080` | WebUI Port |
| `-p 25565` | placeholder minecraft port (add more as required) |
| `-e PUID=1000` | UID for permissions - see below for explanation |
| `-e PGID=1000` | GID for permissions - see below for explanation |
| `-e TZ=Etc/UTC` | Specify a timezone to use, see this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List). |
| `-e USERNAME=admin` | Specify a username for the webUI |
| `-e PASSWORD=admin` | Specify a password for the webUI |
| `-e LICENCE=000-000-000-000` | Specify a valid license for AMP |
| `-e JAVA_VERSIONS=7,9,13` | (Alpine only) you can have multiple versions specified seperated by a comma |
| `-e MODULE=ADS` | Which Module to use for the main instance created by this image |
| `-v /config` | Appdata Path |

## Umask for running applications

All of our images allow overriding the default umask setting for services started within the containers using the optional -e UMASK=022 option. Note that umask works differently than chmod and subtracts permissions based on its value, not adding. For more information, please refer to the Wikipedia article on umask [here](https://en.wikipedia.org/wiki/Umask).

## User / Group Identifiers

To avoid permissions issues when using volumes (`-v` flags) between the host OS and the container, you can specify the user (`PUID`) and group (`PGID`). Make sure that the volume directories on the host are owned by the same user you specify, and the issues will disappear.

Example: `PUID=1000` and `PGID=1000`. To find your PUID and PGID, run `id user`.

```bash
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## Updating the Container

Most of our images are static, versioned, and require an image update and container recreation to update the app. We do not recommend or support updating apps inside the container. Check the [Application Setup](#application-setup) section for recommendations for the specific image.

Instructions for updating containers:

### Via Docker Compose

* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull amp`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d amp`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Run

* Update the image: `docker pull ghcr.io/imagegenius/amp:latest`
* Stop the running container: `docker stop amp`
* Delete the container: `docker rm amp`
* Recreate a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* You can also remove the old dangling images: `docker image prune`

## Versions

* **24.01.23:** - Fix services starting prematurely
* **02.01.23:** - Initial Release.
