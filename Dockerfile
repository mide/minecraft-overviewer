# To use this Docker image, make sure you set up the mounts properly.
#
# The Minecraft server files are expected at
#     /home/minecraft/server
#
# The Minecraft-Overviewer render will be output at
#     /home/minecraft/render

FROM debian:stretch

LABEL MAINTAINER='Mark Ide Jr (https://www.mide.io)'

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

RUN apt-get update && \
    apt-get install -y -no-install-recommends wget gnupg optipng && \
    echo "deb http://overviewer.org/debian ./" >> /etc/apt/sources.list && \
    wget -O - https://overviewer.org/debian/overviewer.gpg.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y --no-install-recommends minecraft-overviewer && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    groupadd minecraft -g 1000 && \
    useradd -m minecraft -u 1000 -g 1000 && \
    mkdir -p /home/minecraft/render /home/minecraft/server

COPY config/config.py /home/minecraft/config.py
COPY entrypoint.sh /home/minecraft/entrypoint.sh
COPY download_url.py /home/minecraft/download_url.py

RUN chown minecraft:minecraft -R /home/minecraft/

WORKDIR /home/minecraft/

USER minecraft

CMD ["bash", "/home/minecraft/entrypoint.sh"]
