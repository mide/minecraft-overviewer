#!/bin/bash
set -o errexit

if [ -z "$MINECRAFT_VERSION" ]; then
  echo "Expecting environment variable MINECRAFT_VERSION to be set to non-empty string. Exiting."
  exit 1
fi

wget https://s3.amazonaws.com/Minecraft.Download/versions/${MINECRAFT_VERSION}/${MINECRAFT_VERSION}.jar -P /home/minecraft/.minecraft/versions/${MINECRAFT_VERSION}/

overviewer.py --config /home/minecraft/config.py
overviewer.py --config /home/minecraft/config.py --genpoi
