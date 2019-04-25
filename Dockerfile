FROM ubuntu

WORKDIR /usr/local/src/RedShL
COPY . .
VOLUME ./src/tracking/:./src/tracking/
WORKDIR /usr/local/src/RedShL/src