# To use this Docker image, make sure you set up the mounts properly.
#
# The Minecraft server files are expected at
#     /home/minecraft/server
#
# The Minecraft-Overviewer render will be output at
#     /home/minecraft/render

FROM debian:jessie

MAINTAINER Mark Ide Jr (https://www.mide.io)

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget gnupg && \
    echo "deb http://overviewer.org/debian ./" >> /etc/apt/sources.list && \
    wget -O - https://overviewer.org/debian/overviewer.gpg.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y --no-install-recommends minecraft-overviewer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    useradd -m minecraft && \
    mkdir -p /home/minecraft/render /home/minecraft/server

COPY config/config.py /home/minecraft/config.py
COPY entrypoint.sh /home/minecraft/entrypoint.sh

RUN chown minecraft:minecraft -R /home/minecraft/

WORKDIR /home/minecraft/

USER minecraft

CMD ["bash", "/home/minecraft/entrypoint.sh"]
