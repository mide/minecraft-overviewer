#!/bin/bash
set -o errexit

# Attempt to discover the latest version from the server logs
MINECRAFT_VERSION=$(zgrep -h ": Starting minecraft server version " /home/minecraft/server/logs/* | awk 'NF>1{print $NF}' | sort | tail -1)

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
    wget -q "${CLIENT_URL}" -O "/home/minecraft/.minecraft/versions/${MINECRAFT_VERSION}/${MINECRAFT_VERSION}.jar"
    echo "Download complete."
fi

# DEPRECATION WARNING - TODO: Remove this block on or around September 30, 2020.
if grep -q "texturepath" "${CONFIG_LOCATION}"; then
  NEW_LOCATION="/home/minecraft/.minecraft/versions/${MINECRAFT_VERSION}/${MINECRAFT_VERSION}.jar"
  OLD_LOCATION="/home/minecraft/${MINECRAFT_VERSION}.jar"
  echo "----------------------------------------------------------------------"
  echo "                         DEPRECATION WARNING!                         "
  echo "----------------------------------------------------------------------"
  echo "The texture file location has changed and 'texturepath' is set in your"
  echo "config.py! Either update your configuration to point to the new       "
  echo "location, or remove that line. On or around September 30, 2020, we    "
  echo "will remove these warnings.                                           "
  echo "Old Location: ${OLD_LOCATION}                                         "
  echo "New Location: ${NEW_LOCATION}                                         "
  echo "----------------------------------------------------------------------"
fi

# Render the Map
if [ "$RENDER_MAP" == "true" ]; then
  # (We disable to support passing multiple arguments)
  # shellcheck disable=SC2086
  overviewer.py --config "$CONFIG_LOCATION" $ADDITIONAL_ARGS
fi

# Render the POI
if [ "$RENDER_POI" == "true" ]; then
# (We disable to support passing multiple arguments)
  # shellcheck disable=SC2086
  overviewer.py --config "$CONFIG_LOCATION" --genpoi $ADDITIONAL_ARGS_POI
fi
