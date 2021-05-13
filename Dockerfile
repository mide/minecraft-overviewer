# To use this Docker image, make sure you set up the mounts properly.
#
# The Minecraft server files are expected at
#     /home/minecraft/server
#
# The Minecraft-Overviewer render will be output at
#     /home/minecraft/render

FROM debian:stretch

LABEL MAINTAINER='Mark Ide Jr (https://www.mide.io)'

# --------------- #
# OPTION DEFAULTS #
# --------------- #

# See README.md for description of these options
ENV CONFIG_LOCATION /home/minecraft/config.py
ENV RENDER_MAP "true"
ENV RENDER_POI "true"
ENV RENDER_SIGNS_FILTER "-- RENDER --"
ENV RENDER_SIGNS_HIDE_FILTER "false"
ENV RENDER_SIGNS_JOINER "<br />"

# ---------------------------- #
# INSTALL & CONFIGURE DEFAULTS #
# ---------------------------- #

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates wget optipng python3 build-essential git python3-dev python3-numpy python3-pillow && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    groupadd minecraft -g 1000 && \
    useradd -m minecraft -u 1000 -g 1000 && \
    mkdir -p /home/minecraft/render /home/minecraft/server

WORKDIR /home/minecraft/

RUN git clone --depth=1 git://github.com/overviewer/Minecraft-Overviewer.git && \
    cd Minecraft-Overviewer/ && \
    python3 setup.py build && \
    python3 setup.py install

COPY config/config.py /home/minecraft/config.py
COPY entrypoint.sh /home/minecraft/entrypoint.sh
COPY download_url.py /home/minecraft/download_url.py

RUN chown minecraft:minecraft -R /home/minecraft/

USER minecraft

CMD ["bash", "/home/minecraft/entrypoint.sh"]
