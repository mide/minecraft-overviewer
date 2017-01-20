# To use this Docker container, make sure you set up the mounts properly.
#
# The Minecraft server files are expected at
#     /home/minecraft/server
#
# The Minecraft-Overviewer render will be output at
#     /home/minecraft/render

FROM debian:latest

RUN echo "deb http://overviewer.org/debian ./" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y wget && \
    wget -O - https://overviewer.org/debian/overviewer.gpg.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y minecraft-overviewer && \
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
