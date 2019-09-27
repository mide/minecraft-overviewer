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

ENV CONFIG_LOCATION /home/minecraft/config.py

RUN apt-get update && \
    apt-get install -y wget gnupg cron && \
    echo "deb http://overviewer.org/debian ./" >> /etc/apt/sources.list && \
    wget -O - https://overviewer.org/debian/overviewer.gpg.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y minecraft-overviewer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    useradd -m minecraft && \
    mkdir -p /home/minecraft/render /home/minecraft/server

# Allow the minecraft user ton run cron
RUN usermod -a -G crontab minecraft
RUN chmod g+rw /var/run
RUN chmod gu+s /usr/sbin/cron

COPY config/config.py /home/minecraft/config.py
COPY scripts/* /home/minecraft/
RUN chmod +x /home/minecraft/render.sh
COPY download_url.py /home/minecraft/download_url.py

RUN chown minecraft:minecraft -R /home/minecraft/

WORKDIR /home/minecraft/

USER minecraft

CMD ["bash", "/home/minecraft/entrypoint.sh"]
