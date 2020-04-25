# To use this Docker image, make sure you set up the mounts properly.
#
# The Minecraft server files are expected at
#     /home/minecraft/server
#
# The Minecraft-Overviewer render will be output at
#     /home/minecraft/render

FROM debian:stretch

LABEL MAINTAINER = 'Mark Ide Jr (https://www.mide.io)'

# Default to do both render Map + POI
ENV RENDER_MAP true
ENV RENDER_POI true

# Only render signs including this string, leave blank to render all signs
ENV RENDER_SIGNS_FILTER "-- RENDER --"

# Hide the filter string from the render
ENV RENDER_SIGNS_HIDE_FILTER "false"

# What to join the lines of the sign with when rendering POI
ENV RENDER_SIGNS_JOINER "<br />"

ENV CONFIG_LOCATION /home/minecraft/config.py

# Install rcon-cli (https://github.com/itzg/rcon-cli). Perform a checksum check
# to make sure it hasn't changed from underneath us.
ENV RCON_CLI_URL "https://github.com/itzg/rcon-cli/releases/download/1.4.7/rcon-cli_1.4.7_linux_amd64.tar.gz"
ENV RCON_CLI_SHA256 "cae03daceb3c463f0979ed0586778fb236cfbb83585413a9a06b1e83bceefa20"
ENV RCON_CLI_ARGS_PRE_RENDER ""
ENV RCON_CLI_ARGS_POST_RENDER ""

RUN apt-get update && \
    apt-get install -y wget gnupg optipng && \
    echo "deb http://overviewer.org/debian ./" >> /etc/apt/sources.list && \
    wget -O - https://overviewer.org/debian/overviewer.gpg.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y minecraft-overviewer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    useradd -m minecraft && \
    mkdir -p /home/minecraft/render /home/minecraft/server

# Install rcon-cli to support issuing RCON commands before/after the render
RUN wget "${RCON_CLI_URL}" -O "/tmp/rcon-cli.tgz" && \
    echo "${RCON_CLI_SHA256}  /tmp/rcon-cli.tgz" | sha256sum -c - && \
    tar -xf /tmp/rcon-cli.tgz -C /usr/local/bin rcon-cli && \
    rm /tmp/rcon-cli.tgz

COPY config/config.py /home/minecraft/config.py
COPY entrypoint.sh /home/minecraft/entrypoint.sh
COPY download_url.py /home/minecraft/download_url.py

RUN chown minecraft:minecraft -R /home/minecraft/

WORKDIR /home/minecraft/

USER minecraft

CMD ["bash", "/home/minecraft/entrypoint.sh"]
