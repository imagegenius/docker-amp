## docker-amp

[![docker hub](https://img.shields.io/badge/docker_hub-link-blue?style=for-the-badge&logo=docker)](https://hub.docker.com/r/vcxpz/amp) ![docker image size](https://img.shields.io/docker/image-size/vcxpz/amp?style=for-the-badge&logo=docker) [![auto build](https://img.shields.io/badge/docker_builds-automated-blue?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-amp/actions?query=workflow%3A"Auto+Builder+CI") [![codacy branch grade](https://img.shields.io/codacy/grade/b5ce6e0b1d3742bca4b1a41ac4ab7068/main?style=for-the-badge&logo=codacy)](https://app.codacy.com/gh/hydazz/docker-amp)

Fork of [MitchTalmadge/AMP-dockerized](https://github.com/MitchTalmadge/AMP-dockerized/)

[AMP](https://cubecoders.com/AMP) is short for Application Management Panel. It's CubeCoders next-generation server administration software built for both users, and service providers. It supports both Windows and Linux based servers and allows you to manage all your game servers from a single web interface.

## Version Information

![alpine](https://img.shields.io/badge/alpine-edge-0D597F?style=for-the-badge&logo=alpine-linux) ![amp](https://img.shields.io/badge/amp-2.0.9.0-blue?style=for-the-badge)

See [package_versions.txt](package_versions.txt) for a full list of the packages and package versions used in this image

## Usage

    docker run -d \
      --name=amp \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ=Australia/Melbourne \
      -p 8080:8080 \
      -e USERNAME= `#webui username` \
      -e PASSWORD= `#webui password` \
      -e LICENCE= `#see below` \
      -e MODULE= `#see below` \
      -v <path to appdata>:/config \
      --mac-address=xx:xx:xx:xx:xx:xx `#see below` \
      --restart unless-stopped \
      vcxpz/amp

[![template](https://img.shields.io/badge/unraid_template-ff8c2f?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-templates/blob/main/hydaz/amp.xml)

## Please Note

As it takes more than 10 seconds (the default timeout for Docker) for AMP to do a graceful shutdown, make sure you have no running modules. Stopping your container via Docker while you have running modules may cause corruption as Docker will kill the container. The easiest way to do a graceful shutdown is to open a console to the container and execute `amp stop`. This command basically does `s6-svc -to /var/run/s6/services/amp`. Which sends a SIGTERM to AMP then tells `s6` not to restart AMP after the service it is terminated.

## Supported Modules

**Will Work:**

-   Java applications such as Minecraft Java, Minecraft Bedrock + others

**Won't Work:**

-   [Everything Else](https://github.com/CubeCoders/AMP/wiki/Supported-Applications-Compatibility)

## MAC Address (Important)

AMP is designed to detect hardware changes and will de-activate all instances when something significant changes.
This is to stop people from sharing pre-activated instances and bypassing the licencing server. One way of detecting
changes is to look at the MAC address of the host's network card. A change here will de-activate instances.

By default, Docker assigns a new MAC address to a container every time it is restarted. Therefore, unless you want to
painstakingly re-activate all your instances on every server reboot, you need to assign a permanent MAC address.

For most people, this can be accomplished by generating a random MAC address in Docker's acceptable range.
The instructions to do so are as follows:

**Linux**

    echo $RANDOM | md5sum | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/'

**MacOS**

    echo $RANDOM | md5 | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/'

**Windows**

-   Visit this page:
-   Put `02:42:AC` in as the prefix
-   Choose the format with colons `:`
-   Generate

###

-   Copy the generated MAC and use it when starting the container.

    -   For `docker run`, use the following flag: (Substitute your generated MAC)

        `--mac-address="02:42:AC:XX:XX:XX"`

    -   For Docker Compose, use the following key next to `image`:

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

### Module

| Name     | Description                                                      | Default Value |
| -------- | ---------------------------------------------------------------- | ------------- |
| `MODULE` | Which Module to use for the main instance created by this image. | `ADS`         |

To run multiple game servers under this image, use the default value of `ADS` (Application Deployment Service) which allows you to create various modules from the web ui.

To be clear, this Docker image creates ONE instance by default. If you want to create more, use `ADS` as the first
  instance, and create the rest with the web UI. Otherwise, you can pick any other module from the list.

Here are the accepted values for the `MODULE` variable:

| Module Name | Description                                                                                                   |
| ----------- | ------------------------------------------------------------------------------------------------------------- |
| `ADS`       | Application Deployment Service. Used to manage multiple modules. Need multiple game servers? Pick this.       |
| `McMyAdmin` | If you have a McMyAdmin Licence, this will be picked for you no matter what. It is equivalent to `Minecraft`. |
| `Minecraft` | Includes Java (Spigot, Bukkit, Paper, etc.) and Bedrock servers.                                              |

## Volumes

| Mount Point | Description                                                                                                                                                                                                                       |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/config`   | **Required!** This volume contains everything AMP needs to run. This includes all your instances, all their game files, the web ui sign-in info, etc. Essentially, without creating this volume, AMP will be wiped on every boot. |

**See other variables on the official [README](https://github.com/MitchTalmadge/AMP-dockerized/)**

## Upgrading AMP

To upgrade, all you have to do is pull the latest Docker image. We automatically check for AMP updates daily so there may be some delay when an update is released to when the image is updated. To do a force upgrade, open a console to the container and executing `amp upgrade`. This will upgrade all modules to the latest version available.
