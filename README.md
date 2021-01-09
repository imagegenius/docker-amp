JRE

## docker-amp
[![docker hub](https://img.shields.io/badge/docker_hub-link-blue?style=for-the-badge&logo=docker)](https://hub.docker.com/repository/docker/vcxpz/amp) ![docker image size](https://img.shields.io/docker/image-size/vcxpz/amp?style=for-the-badge&logo=docker) [![auto build](https://img.shields.io/badge/docker_builds-automated-blue?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-amp/actions?query=workflow%3A"Auto+Builder+CI")

Fork of [MitchTalmadge/AMP-dockerized](https://github.com/MitchTalmadge/AMP-dockerized/)

[AMP](https://cubecoders.com/AMP) is short for Application Management Panel. It's CubeCoders next-generation server administration software built for both users, and service providers. It supports both Windows and Linux based servers and allows you to manage all your game servers from a single web interface.

## Version Information
![alpine](https://img.shields.io/badge/alpine-edge-0D597F?style=for-the-badge&logo=alpine-linux) ![s6 overlay](https://img.shields.io/badge/s6_overlay-2.1.0.2-blue?style=for-the-badge) ![amp](https://img.shields.io/badge/amp-2.0.9.0-blue?style=for-the-badge)

**[See here for a list of packages](https://github.com/hydazz/docker-amp/blob/main/package_versions.txt)**

## Usage
```
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
  -e JDK_VERSIONS= `#see below` \
  -v <path to appdata>:/config \
  --mac-address=xx:xx:xx:xx:xx:xx `#see below` \
  --restart unless-stopped \
  vcxpz/amp
```
[![template](https://img.shields.io/badge/unraid_template-ff8c2f?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-templates/blob/main/hydaz/amp.xml)

## Please Note
As it takes more than 10 seconds (the default timeout for Docker) for AMP to do a graceful shutdown, make sure you have no running modules. Stopping your container via Docker while you have running modules may cause corruption as Docker will kill the container. The easiest way to do a graceful shutdown is to open a console to the container and executing `amp stop`. This command basically does `s6-svc -to /var/run/s6/services/amp`. Which sends a SIGTERM to AMP then tells `s6` not to restart AMP after the service it is terminated.

## Supported Modules
**Tested and Working:**
- Minecraft Java Edition
- Minecraft Bedrock Edition

**Untested:**
- [Everything Else](https://github.com/CubeCoders/AMP/wiki/Supported-Applications-Compatibility)

From what i've tested srcds does not work.  I get this error message:

    segfault at 0 ip 0000000029af3e13 sp 00000000ff8e8a80 error 6 in engine_srv.so[2992b000+2d3000]

so if anyone knows how to fix this open an issue!

If you are able to get an untested module working, please make an issue about it so we can add it to the tested list and create an example

If you are *not* able to get a module working, make an issue and we can work together to figure out a solution!

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

- Visit this page: https://miniwebtool.com/mac-address-generator/
- Put `02:42:AC` in as the prefix
- Choose the format with colons `:`
- Generate

###

- Copy the generated MAC and use it when starting the container.
  - For `docker run`, use the following flag: (Substitute your generated MAC)

    `--mac-address="02:42:AC:XX:XX:XX"`
  - For Docker Compose, use the following key next to `image`:

    `mac_address: 02:42:AC:XX:XX:XX`

If you have a unique network situation, a random MAC may not work for you. In that case you will need to come up with your own solution to prevent address conflicts.

If you need help with any of this, please make an issue.

## Ports
Here's a rough (and potentially incorrect) list of default ports for the various modules. Each module also exposes port 8080 for the Web UI (can be changed with environment variables). If you find an inaccuracy, open an issue!

| Module Name | Default Ports |
|-|-|
| `ADS` | No additional ports. |
| `ARK` | UDP 27015 & UDP 7777 & UDP 7778 ([Guide](https://ark.gamepedia.com/Dedicated_Server_Setup)) |
| `Arma3` | UDP 2302 to UDP 2306 ([Guide](https://community.bistudio.com/wiki/Arma_3_Dedicated_Server)) |
| `Factorio` | UDP 34197 ([Guide](https://wiki.factorio.com/Multiplayer)) |
| `FiveM` | UDP 30120 & TCP 30120 ([Guide](https://docs.fivem.net/docs/server-manual/setting-up-a-server/)) |
| `Generic` | Completely depends on what you do with it. |
| `JC2MP` | UDP 27015 & UDP 7777 & UDP 7778 (Unconfirmed!) |
| `McMyAdmin` | TCP 25565 |
| `Minecraft` | TCP 25565 (Java) or UDP 19132 (Bedrock) |
| `Rust` | UDP 28015 ([Guide](https://developer.valvesoftware.com/wiki/Rust_Dedicated_Server)) |
| `SevenDays` | UDP 26900 to UDP 26902 & TCP 26900 ([Guide](https://developer.valvesoftware.com/wiki/7_Days_to_Die_Dedicated_Server)) |
| `srcds` | Depends on the game. Usually UDP 27015. ([List of games under srcds](https://github.com/CubeCoders/AMP/wiki/Supported-Applications-Compatibility#applications-running-under-the-srcds-module)) |
| `StarBound` | TCP 21025 ([Guide](https://starbounder.org/Guide:Setting_Up_Multiplayer)) |

Just a quick note about ports: some games use TCP, some games use UDP. Make sure you are using the right protocol. Don't fall into the trap of accidentally mapping a TCP port for a UDP game -- you won't be able to connect.

## Environment Variables
### JRE Versions
| Name | Description | Default Value |
|-|-|-|
| `JRE_VERSIONS` | Space separated list JRE Versions to be installed. JRE is required by Minecraft. If you plan to not use Minecraft then leave this blank. Supported versions: `9`, `10`, `11`, `12`, `13`, `14`, `15` | No Default. Leaving this blank will not install JRE |

**Example:**
- If you need JRE 9, 11 and 13 installed, set `JRE_VERSIONS="9 11 13"`

### Debug
| Name | Description | Default Value |
|-|-|-|
| `DEBUG` | Set `true` to show AMP startup output in the docker log | `false` |

### Module
| Name | Description | Default Value |
|-|-|-|
| `MODULE` | Which Module to use for the main instance created by this image. | `ADS` |

To run multiple game servers under this image, use the default value of `ADS` (Application Deployment Service) which allows you to create various modules from the web ui.

To be clear, this Docker image creates ONE instance by default. If you want to create more, use `ADS` as the first
  instance, and create the rest with the web UI. Otherwise, you can pick any other module from the list.

Here are the accepted values for the `MODULE` variable:

| Module Name | Description |
|-|-|
| `ADS` | Application Deployment Service. Used to manage multiple modules. Need multiple game servers? Pick this. |
| `ARK` |  |
| `Arma3` |  |
| `Factorio` |  |
| `FiveM` |  |
| `Generic` | For advanced users. You can craft your own module for any other game using this. You're on your own here. |
| `JC2MP` | Just Cause 2 |
| `McMyAdmin` | If you have a McMyAdmin Licence, this will be picked for you no matter what. It is equivalent to `Minecraft`. |
| `Minecraft` | Includes Java (Spigot, Bukkit, Paper, etc.) and Bedrock servers. |
| `Rust` |  |
| `SevenDays` | 7-Days To Die |
| `srcds` | Source-based games like TF2, GMod, etc. [Full List](https://github.com/CubeCoders/AMP/wiki/Supported-Applications-Compatibility#applications-running-under-the-srcds-module) |
| `StarBound` |  |

## Volumes
| Mount Point | Description |
|-|-|
| `/config` | **Required!** This volume contains everything AMP needs to run. This includes all your instances, all their game files, the web ui sign-in info, etc. Essentially, without creating this volume, AMP will be wiped on every boot. |

**See other variables on the official [README](https://github.com/MitchTalmadge/AMP-dockerized/)**

## Upgrading AMP
To upgrade, all you have to do is pull our latest Docker image. We automatically check for AMP updates daily so there may be some delay when an update is released to when the image is updated. To do a force upgrade, open a console to the container and executing `amp upgrade`. This will upgrade all modules to the latest version available.
