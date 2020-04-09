#!/bin/bash
set -o errexit

# Require MINECRAFT_VERSION environment variable to be set (no default assumed)
if [ -z "$MINECRAFT_VERSION" ]; then
  echo "Expecting environment variable MINECRAFT_VERSION to be set to non-empty string. Exiting."
  exit 1
fi

# Download Minecraft client .jar (Contains textures used by Minecraft Overviewer)
# We only download if the client doesn't exist. In most cases, it won't exist
# because the directory isn't a volume and the Docker container will be a fresh
# slate. This check enables power-users to mount the /home/minecraft/.minecraft/
# directory and prevent downloading if the file exists.
if [ -f "/home/minecraft/.minecraft/versions/${MINECRAFT_VERSION}/${MINECRAFT_VERSION}.jar" ]; then
    echo "Minecraft client ${MINECRAFT_VERSION}.jar exists! Skipping download."
else
    CLIENT_URL=$(python3 /home/minecraft/download_url.py "${MINECRAFT_VERSION}")
    echo "Using Client URL ${CLIENT_URL} to download ${MINECRAFT_VERSION}.jar."
    mkdir -p "/home/minecraft/.minecraft/versions/${MINECRAFT_VERSION}/"
    wget "${CLIENT_URL}" -O "/home/minecraft/.minecraft/versions/${MINECRAFT_VERSION}/${MINECRAFT_VERSION}.jar"
fi

# Render the Map
if [ "$RENDER_MAP" == "true" ]; then
  overviewer.py --config "$CONFIG_LOCATION" $ADDITIONAL_ARGS
fi

# Render the POI
if [ "$RENDER_POI" == "true" ]; then
  overviewer.py --config "$CONFIG_LOCATION" --genpoi $ADDITIONAL_ARGS_POI
fi
