#!/bin/bash
set -o errexit

# Require MINECRAFT_VERSION environment variable to be set (no default assumed)
if [ -z "$MINECRAFT_VERSION" ]; then
  echo "Expecting environment variable MINECRAFT_VERSION to be set to non-empty string. Exiting."
  exit 1
fi

# Download Minecraft client .jar (Contains textures used by Minecraft Overviewer)
CLIENT_URL=$(python /home/minecraft/download_url.py "$MINECRAFT_VERSION")
echo "Using Client URL $CLIENT_URL."
wget -N "${CLIENT_URL}" -O "${MINECRAFT_VERSION}.jar" -P /home/minecraft/.minecraft/versions/${MINECRAFT_VERSION}/

# Render the Map
if [ "$RENDER_MAP" == "true" ]; then
  overviewer.py --config /home/minecraft/config.py $ADDITIONAL_ARGS
fi

# Render the POI
if [ "$RENDER_POI" == "true" ]; then
  overviewer.py --config /home/minecraft/config.py --genpoi $ADDITIONAL_ARGS
fi
