#!/bin/bash
set -o errexit

# Require MINECRAFT_VERSION environment variable to be set (no default assumed)
if [ -z "$MINECRAFT_VERSION" ]; then
  echo "Expecting environment variable MINECRAFT_VERSION to be set to non-empty string. Exiting."
  exit 1
fi

# Download Minecraft client .jar (Contains textures used by Minecraft Overviewer)
wget -N https://s3.amazonaws.com/Minecraft.Download/versions/${MINECRAFT_VERSION}/${MINECRAFT_VERSION}.jar -P /home/minecraft/.minecraft/versions/${MINECRAFT_VERSION}/

# Run the world renders (One pass to make map, one to generate points of interests)
overviewer.py --config /home/minecraft/config.py
overviewer.py --config /home/minecraft/config.py --genpoi

# Add Google Maps API key if the GOOGLE_MAPS_API_KEY environment variable is set
if [ "$GOOGLE_MAPS_API_KEY" ]; then
  sed -i "s|https://maps.google.com/maps/api/js|&?key=${GOOGLE_MAPS_API_KEY}|g" /home/minecraft/render/index.html
fi
