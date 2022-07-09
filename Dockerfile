# To use this Docker image, make sure you set up the mounts properly.
#
# The Minecraft server files are expected at
#     /home/minecraft/server
#
# The Minecraft-Overviewer render will be output at
#     /home/minecraft/render

FROM debian:stretch

# -------------------- #
# BUILD-TIME ARGUMENTS #
# -------------------- #

ARG GITHUB_REF
ARG GITHUB_REPOSITORY
ARG GITHUB_SHA

LABEL maintainer='Mark Ide Jr (https://www.mide.io)'

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
ENV UID 1000
ENV GID 1000

# ---------------------------- #
# INSTALL & CONFIGURE DEFAULTS #
# ---------------------------- #

WORKDIR /home/minecraft/

RUN apt-get update && \
    apt-cache madison \
        build-essential \
        ca-certificates \
        curl \
        git \
        jq \
        optipng \
        python3-dev \
        python3-numpy \
        python3-pil \
        python3 \
        wget && \
    apt-get install -y --no-install-recommends \
        build-essential=12.3 \
        ca-certificates=20200601~deb9u2 \
        curl=7.52.1-5+deb9u16 \
        git=1:2.11.0-3+deb9u7 \
        jq=1.5+dfsg-1.3 \
        optipng=0.7.6-1+deb9u1 \
        python3-dev=3.5.3-1 \
        python3-numpy=1:1.12.1-3 \
        python3-pil=4.0.0-4+deb9u4 \
        python3=3.5.3-1 \
        wget=1.18-5+deb9u3 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    groupadd minecraft -g 1000 && \
    useradd -m minecraft -u 1000 -g 1000 && \
    mkdir -p /home/minecraft/render /home/minecraft/server

RUN git clone --depth=1 https://github.com/overviewer/Minecraft-Overviewer.git

WORKDIR /home/minecraft/Minecraft-Overviewer/
RUN python3 setup.py build && \
    python3 setup.py install

WORKDIR /home/minecraft/

COPY config/config.py /home/minecraft/config.py
COPY entrypoint.sh /home/minecraft/entrypoint.sh
COPY download_url.py /home/minecraft/download_url.py

# Add some timestamps / build information into the image
RUN printf "GITHUB_REF=%s\nGITHUB_REPOSITORY=%s\nGITHUB_SHA=%s\nBUILD_DATE=$(date -u)\n" "$GITHUB_REF" "$GITHUB_REPOSITORY" "$GITHUB_SHA" > /home/minecraft/build-details.txt

RUN chown minecraft:minecraft -R /home/minecraft/

CMD ["bash", "/home/minecraft/entrypoint.sh"]
