# Minecraft Overviewer Docker Image

[![Docker](https://img.shields.io/docker/pulls/mide/minecraft-overviewer.svg)](https://hub.docker.com/r/mide/minecraft-overviewer/)
[![Docker](https://img.shields.io/docker/stars/mide/minecraft-overviewer.svg)](https://hub.docker.com/r/mide/minecraft-overviewer/)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/mide/minecraft-overviewer/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/mide/minecraft-overviewer.svg)](https://github.com/mide/minecraft-overviewer/issues)

Docker Image to Run [Minecraft Overviewer](https://overviewer.org/). Overviewer is a render that produces a render of a [Minecraft](https://minecraft.net/en/) world. The goal of this image is to easily run the Overviewer project without having to worry about dependencies, and to provide sane default configurations.

:warning: **This project is not official nor affiliated with the wonderful [Minecraft Overviewer](https://overviewer.org/) project**.

This project's code is hosted on [GitHub](https://github.com/mide/minecraft-overviewer), and the resulting Docker image is hosted on [Docker Hub](https://hub.docker.com/r/mide/minecraft-overviewer). Feel free to open [an issue on GitHub](https://github.com/mide/minecraft-overviewer/issues?q=is%3Aopen) if you're having problems.

## :construction: Maintenance Status :construction:

As of [April 5, 2023](https://github.com/overviewer/Minecraft-Overviewer/commit/13c1bddaf65dfaaf6c4c7a396c94db75bed4c089), the upstream Minecraft-Overviewer project is no longer being maintained. For more information on the matter, please check the project's [Official GitHub](https://github.com/overviewer/Minecraft-Overviewer).

## Running Minecraft Overviewer

In the below example, `minecraft-overviewer` will read input in from `/home/user/path_to_minecraft_files/` and write the output to `/home/user/path_to_write_overviewer_output/`. It will run once and exit.

```shell
docker pull mide/minecraft-overviewer:latest
docker run \
  --rm \
  -e MINECRAFT_VERSION="1.19.4" \
  -v /home/user/path_to_minecraft_files/:/home/minecraft/server/:ro \
  -v /home/user/path_to_write_overviewer_output/:/home/minecraft/render/:rw \
  mide/minecraft-overviewer:latest
```

_Note:_ The `latest` Docker tag is rebuilt daily. If there are changes to the [upstream project](https://github.com/overviewer/Minecraft-Overviewer/), it may take up to 24 hours for the new image to contain them.

## Environment Variables

### Required

- `MINECRAFT_VERSION`
  Set to the version of Minecraft the world is based from (Like `1.17`). Used for textures. You can also use the special version `latest` or `latest_snapshot` to just use the latest version (stable or snapshot, respectively).

### Optional

- `ADDITIONAL_ARGS`
  Default Value: _null_. Set to contain any additional arguments you'd like to pass into `overviewer.py`.

- `ADDITIONAL_ARGS_POI`
  Default Value: _null_. Set to contain any additional arguments you'd like to pass into `overviewer.py --genpoi`.

- `CONFIG_LOCATION`
  Default Value: `/home/minecraft/config.py`. Set to a different path to override the provided configuration. This only makes sense if you have a different configuration in a volume.

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

## Mapped Directories / Volumes

The following directories are read from within the context of the container. You'll want to modify your commands to ensure that the expected files end up in the correct locations inside the container.

- `/home/minecraft/server/` _(Read Only)_ This is the expected directory for the Minecraft server files.
- `/home/minecraft/render/` _(Read & Write)_ This is where Minecraft Overviewer will write the files. If you want to have it directly write to a webserver's directory, make sure you mount the output location correctly.

In the example above, `-v /home/user/path_to_minecraft_files/:/home/minecraft/server/:ro` will use `/home/user/path_to_minecraft_files/` as the source of the Minecraft server files. The line `-v /home/user/path_to_write_overviewer_output/:/home/minecraft/render/:rw` tells the Docker contianer to write out to `/home/user/path_to_write_overviewer_output/`.

For more information, check out the [Docker documentation on `docker run`](https://docs.docker.com/engine/reference/commandline/run/#volume).
