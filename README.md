# Minecraft Overviewer Docker Container

Docker Container to Run [Minecraft Overviewer](https://overviewer.org/). Overviewer is a render that produces a Google Maps render of a [Minecraft](https://minecraft.net/en/) world.

## Goals

The goal of this container is to easily run [Minecraft Overviewer](https://overviewer.org/). Now you don't need to worry about the dependencies.

## Running Minecraft Overviewer

```
docker run \
  --rm \
  -e MINECRAFT_VERSION=1.11.2 \
  -v /home/user/minecraft/:/home/minecraft/server/:ro \
  -v /srv/http/minecraft/:/home/minecraft/render/:rw \
  mide/minecraft-overviewer:latest
```
