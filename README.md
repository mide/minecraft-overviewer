# Minecraft Overviewer Docker Image

[![Docker](https://img.shields.io/docker/pulls/mide/minecraft-overviewer.svg)](https://hub.docker.com/r/mide/minecraft-overviewer/) [![Docker](https://img.shields.io/docker/stars/mide/minecraft-overviewer.svg)](https://hub.docker.com/r/mide/minecraft-overviewer/) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/mide/minecraft-overviewer/master/LICENSE) [![GitHub issues](https://img.shields.io/github/issues/mide/minecraft-overviewer.svg)](https://github.com/mide/minecraft-overviewer/issues) [![Build Status](https://travis-ci.org/mide/minecraft-overviewer.svg?branch=master)](https://travis-ci.org/mide/minecraft-overviewer) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/2cbd7097dc6942dbb0cd44c33cd3dc39)](https://www.codacy.com/app/mide/minecraft-overviewer?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=mide/minecraft-overviewer&amp;utm_campaign=Badge_Grade)

Docker Image to Run [Minecraft Overviewer](https://overviewer.org/). Overviewer is a render that produces a Google Maps render of a [Minecraft](https://minecraft.net/en/) world.

## Goals

The goal of this image is to easily run [Minecraft Overviewer](https://overviewer.org/). Now you don't need to worry about the dependencies.

## Running Minecraft Overviewer

```
docker run \
  --rm \
  -e MINECRAFT_VERSION=1.11.2 \
  -e GOOGLE_MAPS_API_KEY=<Google Maps API Key> \
  -e POI_ONLY=n \
  -e OVERVIEWER_PARAMS="--processes 2"\
  -v /home/user/minecraft/:/home/minecraft/server/:ro \
  -v /srv/http/minecraft/:/home/minecraft/render/:rw \
  mide/minecraft-overviewer:latest
```

## Environment Variables

### `POI_ONLY`
Only generate the points of interest and not the map tiles.

### `GOOGLE_MAPS_API_KEY`
Set the optional google maps api key.

### `OVERVIEWER_PARAMS`
Pass additional arguments to overviewer
