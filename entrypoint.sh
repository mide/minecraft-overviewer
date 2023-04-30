#!/bin/bash
set -o errexit

render_map() {
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
}

# Require MINECRAFT_VERSION environment variable to be set (no default assumed)
if [ -z "$MINECRAFT_VERSION" ]; then
  echo "Expecting environment variable MINECRAFT_VERSION to be set to non-empty string. Exiting."
  exit 1
fi

export MANIFEST_URL="https://launchermeta.mojang.com/mc/game/version_manifest.json"

if [ "$MINECRAFT_VERSION" == "latest" ]; then
  MINECRAFT_VERSION=$(curl -s "$MANIFEST_URL" | jq -r ".latest.release")
  echo "User specified \$MINECRAFT_VERSION=\"latest\". Substituting with \"$MINECRAFT_VERSION\"."
elif [ "$MINECRAFT_VERSION" == "latest_snapshot" ]; then
  MINECRAFT_VERSION=$(curl -s "$MANIFEST_URL" | jq -r ".latest.snapshot")
  echo "User specified \$MINECRAFT_VERSION=\"latest_snapshot\". Substituting with \"$MINECRAFT_VERSION\"."
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

# Render the map, either once if REFRESH_DURATION is 0, or every REFRESH_DURATION seconds
if [ $REFRESH_DURATION -gt 0 ]; then
  while true; do
    render_map
    sleep $REFRESH_DURATION
  done
else
  render_map
fi