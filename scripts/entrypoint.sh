#!/bin/bash
set -o errexit

# Require MINECRAFT_VERSION environment variable to be set (no default assumed)
if [ -z "$MINECRAFT_VERSION" ]; then
  echo "Expecting environment variable MINECRAFT_VERSION to be set to non-empty string. Exiting."
  exit 1
fi

# Download Minecraft client .jar (Contains textures used by Minecraft Overviewer)
CLIENT_URL=$(python3 /home/minecraft/download_url.py "$MINECRAFT_VERSION")
echo "Using Client URL $CLIENT_URL."
wget -N "${CLIENT_URL}" -O "${MINECRAFT_VERSION}.jar" -P /home/minecraft/.minecraft/versions/${MINECRAFT_VERSION}/

# Schedule render
if [ ! -z "$CRONTAB" ]; then
  # Make environment variables accessible in crontab
  declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /home/minecraft/container.env
  sed -i "s#replacement_string#${CRONTAB}#" /home/minecraft/overviewer_cron
  crontab /home/minecraft/overviewer_cron
  echo "Running cron in the foreground"
  cron -f
# Render immediately
else
  bash /home/minecraft/render.sh
fi
