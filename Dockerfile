# Using openjdk as base image to support ARM builds
# FROM openjdk:8-alpine
# FROM --platform=linux/amd64 amazoncorretto:11-alpine
FROM bellsoft/liberica-openjdk-alpine:11

ENV SFS_VERSION 2_19_0
ENV SFS_PATCH 2.20.3

# Install required utilities
RUN apk add --no-cache bash unzip wget coreutils

RUN wget -q -O - https://www.smartfoxserver.com/downloads/sfs2x/SFS2X_unix_${SFS_VERSION}.tar.gz | tar  -C /opt -xzvf - \
    # Swap out the java included with SFS with distro java
    # This allows for ARM builds.
    rm -rf /opt/SmartFoxServer_2X/jre \
    && REAL_JAVA=$(readlink -f $(which java)) \
    && ln -s "$REAL_JAVA" /opt/SmartFoxServer_2X/jre/bin/java


WORKDIR /opt/SmartFoxServer_2X

RUN wget -q https://www.smartfoxserver.com/downloads/sfs2x/patches/SFS2X-Patch-${SFS_PATCH}.zip \
    && unzip SFS2X-Patch-${SFS_PATCH}.zip \
    && cd SFS2X-Patch-${SFS_PATCH} \
    && ./install-linux.sh \
    && cd .. \
    && rm -rf SFS2X-Patch-${SFS_UPDATE}.zip SFS2X-Patch-${SFS_PATCH}

EXPOSE 8080 8443 9933 9933/udp 5000

WORKDIR /opt/SmartFoxServer_2X/SFS2X

# CMD ["sh", "sfs2x.sh"]
CMD ["/opt/SmartFoxServer_2X/SFS2X/sfs2x-service", "run"]
