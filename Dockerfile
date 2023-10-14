#
# Sneaker WebGCI Dockerfile.
#
#
FROM ghcr.io/linuxserver/baseimage-alpine:3.18
LABEL maintainer="Aterfax"

COPY docker_src/s6-src/branding /etc/s6-overlay/s6-rc.d/init-adduser/branding

COPY docker_src/s6-src/s6-services/s6-init-sneaker-webgci /etc/s6-overlay/s6-rc.d/init-sneaker-webgci
RUN touch etc/s6-overlay/s6-rc.d/user/contents.d/init-sneaker-webgci

# Note that folder user and group ownership is handled in the s6 init script for Sneaker start up.
# See docker_src\s6-src\s6-services\s6-init-sneaker-webgci\run

COPY build/sneaker-linux-386 /app/sneaker-linux
RUN chmod +x -R /app/

# No user config file will result in the default being present.
COPY docker_src/sneaker-cfg/ /config/