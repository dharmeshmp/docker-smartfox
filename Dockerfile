# Using openjdk as base image to support ARM builds
FROM bellsoft/liberica-openjdk-alpine:11

ENV SFS_VERSION 2_19_0
ENV SFS_PATCH 2.20.1

RUN wget -q -O - https://www.smartfoxserver.com/downloads/sfs2x/SFS2X_unix_${SFS_VERSION}.tar.gz \
    | tar -xvzf - -C /opt \
    && rm -rf /opt/SmartFoxServer_2X/jre \
    && mkdir -p /opt/SmartFoxServer_2X/jre/bin \
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
