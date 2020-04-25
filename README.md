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
  -e MINECRAFT_VERSION="1.14.1" \
  -v /home/user/minecraft/:/home/minecraft/server/:ro \
  -v /srv/http/minecraft/:/home/minecraft/render/:rw \
  mide/minecraft-overviewer:latest
```

## Environment Variables

### Required

- `MINECRAFT_VERSION`
  Set to the version of Minecraft the world is based from (Like `1.14.1`). Used for textures.

### Optional

- `ADDITIONAL_ARGS`
  Default Value: _null_. Set to contain any additional arguments you'd like to pass into `overviewer.py`.

- `ADDITIONAL_ARGS_POI`
  Default Value: _null_. Set to contain any additional arguments you'd like to pass into `overviewer.py --genpoi`.

- `CONFIG_LOCATION`
  Default Value: `/home/minecraft/config.py`. Set to a different path to override the provided configuration. This only makes sense if you have a different configuration in a volume.

- `RCON_CLI_ARGS_POST_RENDER`
  Default Value: _null_. Set to contain any [Minecraft RCON](https://wiki.vg/RCON) command you'd like to have run after the render completes. This uses [`itzg/rcon-cli`](https://github.com/itzg/rcon-cli), so please refer to that project for full list of available options. Could be used to issue `save on` to re-enable file writes once done rendering.

- `RCON_CLI_ARGS_PRE_RENDER`
  Default Value: _null_. Set to contain any [Minecraft RCON](https://wiki.vg/RCON) command you'd like to have run before the render starts. This uses [`itzg/rcon-cli`](https://github.com/itzg/rcon-cli), so please refer to that project for full list of available options. Could be used to issue `save off` to prevent file changes while rendering.

- `RENDER_MAP`
  Default Value: `true`. Set to `false` if you do not want to render the map. This is useful for POI only-updates.

- `RENDER_POI`
  Default Value: `true`. Set to `false` to disable rendering of POI (points of interest).

- `RENDER_SIGNS_FILTER`
  Default Value: `-- RENDER --`. Only signs with this case-sensitive string will be included in the POI (points of interest) render. Useful for allowing hidden bases or decluttering the render. Set to an empty string (`""`) to render all signs.

- `RENDER_SIGNS_HIDE_FILTER`
  Default Value: `false`. Set to `true` to prevent the sign filter string (Set via `RENDER_SIGNS_FILTER`) from appearing in the render. For example, if only signs with `-- RENDER --` are displayed, the string `-- RENDER --` would be hidden from the render.

- `RENDER_SIGNS_JOINER`
  Default Value: `<br />`. Set to the string that should be used to join the lines on the sign while rendering. Value of `"<br />"` will make each in-game line it's own line on the render. A value of `" "` will make all the in-game lines a single line on the render.
