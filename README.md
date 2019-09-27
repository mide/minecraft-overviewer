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
  -e MINECRAFT_VERSION="1.14" \
  -v /home/user/minecraft/:/home/minecraft/server/:ro \
  -v /srv/http/minecraft/:/home/minecraft/render/:rw \
  mide/minecraft-overviewer:latest
```

## Environment Variables

### Required

- `MINECRAFT_VERSION`
  Set to the version of Minecraft the world is based from (Like `1.14`). Used for textures.

### Optional

- `ADDITIONAL_ARGS`
  Default Value: _null_. Set to contain any additional arguments you'd like to pass into `overviewer.py`.

- `CONFIG_LOCATION`
  Default Value: `/home/minecraft/config.py`. Set to a different path to override the provided configuration. This only makes sense if you have a different configuration in a volume.

- `RENDER_MAP`
  Default Value: `true`. Set to `false` if you do not want to render the map. This is useful for POI only-updates.

- `RENDER_POI`
  Default Value: `true`. Set to `false` to disable rendering of POI (points of interest).

- `CRONTAB`
  Default Value: _null_. Set to a crontab expression to schedule the render. For instance, use `CRONTAB="* */2 * * *"` to render every 2 hours.
