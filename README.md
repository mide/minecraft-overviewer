# Minecraft Overviewer Docker Image

[![Docker](https://img.shields.io/docker/pulls/mide/minecraft-overviewer.svg)](https://hub.docker.com/r/mide/minecraft-overviewer/) [![Docker](https://img.shields.io/docker/stars/mide/minecraft-overviewer.svg)](https://hub.docker.com/r/mide/minecraft-overviewer/) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/mide/minecraft-overviewer/master/LICENSE) [![GitHub issues](https://img.shields.io/github/issues/mide/minecraft-overviewer.svg)](https://github.com/mide/minecraft-overviewer/issues)

Docker Image to Run [Minecraft Overviewer](https://overviewer.org/). Overviewer is a render that produces a Google Maps render of a [Minecraft](https://minecraft.net/en/) world.

## Goals

The goal of this image is to easily run [Minecraft Overviewer](https://overviewer.org/). Now you don't need to worry about the dependencies.

## Running Minecraft Overviewer

```
docker run \
  --rm \
  -e MINECRAFT_VERSION=1.11.2 \
  -v /home/user/minecraft/:/home/minecraft/server/:ro \
  -v /srv/http/minecraft/:/home/minecraft/render/:rw \
  mide/minecraft-overviewer:latest
```
