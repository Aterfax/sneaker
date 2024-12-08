#
# Sneaker WebGCI Dockerfile.
#
#
FROM golang:alpine3.19 AS build-env
#
# Copy source from repo submodules
COPY ./ /sneaker_build

#
# Install pre-reqs
RUN apk --no-cache add build-base git gcc ca-certificates nodejs-current yarn npm
#
# Make the app dir so the binaries have somewhere to go
RUN mkdir /app
#
# Build Sneaker
WORKDIR /sneaker_build
RUN go install github.com/josephspurrier/goversioninfo/cmd/goversioninfo@latest 
RUN yarn && yarn build
RUN go generate && env GOOS=linux GOARCH=386 go build -o ./sneaker cmd/sneaker-server/main.go && chmod +x sneaker && mv sneaker /app/sneaker

FROM ghcr.io/linuxserver/baseimage-alpine:3.20
LABEL maintainer="Aterfax"

COPY docker_src/s6-src/branding /etc/s6-overlay/s6-rc.d/init-adduser/branding

COPY docker_src/s6-src/s6-services/s6-init-sneaker-webgci /etc/s6-overlay/s6-rc.d/init-sneaker-webgci
RUN touch etc/s6-overlay/s6-rc.d/user/contents.d/init-sneaker-webgci

# Note that folder user and group ownership is handled in the s6 init script for Sneaker start up.
# See docker_src\s6-src\s6-services\s6-init-sneaker-webgci\run

COPY --from=build-env /app/sneaker /app/sneaker-linux
RUN chmod +x -R /app/

# No user config file will result in the default being present.
COPY docker_src/sneaker-cfg/ /config/
