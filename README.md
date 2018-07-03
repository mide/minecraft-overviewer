# Minecraft Overviewer Docker Image

[![Docker](https://img.shields.io/docker/pulls/mide/minecraft-overviewer.svg)](https://hub.docker.com/r/mide/minecraft-overviewer/) [![Docker](https://img.shields.io/docker/stars/mide/minecraft-overviewer.svg)](https://hub.docker.com/r/mide/minecraft-overviewer/) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/mide/minecraft-overviewer/master/LICENSE) [![GitHub issues](https://img.shields.io/github/issues/mide/minecraft-overviewer.svg)](https://github.com/mide/minecraft-overviewer/issues) [![Build Status](https://travis-ci.org/mide/minecraft-overviewer.svg?branch=master)](https://travis-ci.org/mide/minecraft-overviewer)

Docker Image to Run [Minecraft Overviewer](https://overviewer.org/). Overviewer is a render that produces a render of a [Minecraft](https://minecraft.net/en/) world.

## Goals

The goal of this image is to easily run [Minecraft Overviewer](https://overviewer.org/). Now you don't need to worry about the dependencies.

## Running Minecraft Overviewer

```
docker pull mide/minecraft-overviewer:latest
docker run \
  --rm \
  -e MINECRAFT_VERSION="1.11.2" \
  -v /home/user/minecraft/:/home/minecraft/server/:ro \
  -v /srv/http/minecraft/:/home/minecraft/render/:rw \
  mide/minecraft-overviewer:latest
```

## Environment Variables

### `ADDITIONAL_ARGS`
Default Value: _null_. Set to contain any additional arguments you'd like to pass into `overviewer.py`.

### `RENDER_MAP`
Default Value: `true`. Set to `false` if you do not want to render the map. This is useful for POI only-updates.

### `RENDER_POI`
Default Value: `true`. Set to `false` to disable rendering of POI (points of interest).
