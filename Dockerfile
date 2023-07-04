# Using openjdk as base image to support ARM builds
# FROM --platform=linux/arm64 openjdk:8-alpine
# FROM openjdk:8-alpine
FROM amazoncorretto:8

ENV SFS_VERSION 2_19_0
ENV SFS_PATCH 2.19.1

RUN wget -q -O - https://www.smartfoxserver.com/downloads/sfs2x/SFS2X_unix_${SFS_VERSION}.tar.gz | tar  -C /opt -xzvf - \
    # Swap out the java included with SFS with distro java
    # This allows for ARM builds.
    && rm -rf /opt/SmartFoxServer_2X/jre \
    && ln -s /usr/lib/jvm/default-jvm/jre /opt/SmartFoxServer_2X/jre

WORKDIR /opt/SmartFoxServer_2X

# RUN wget -q https://www.smartfoxserver.com/downloads/sfs2x/patches/SFS2X-Patch-${SFS_PATCH}.zip \
#     && unzip SFS2X-Patch-${SFS_PATCH}.zip \
#     && cd SFS2X-Patch-${SFS_PATCH} \
#     && ./install-linux.sh \
#     && cd .. \
#     && rm -rf SFS2X-Patch-${SFS_UPDATE}.zip SFS2X-Patch-${SFS_PATCH}

RUN wget -q https://www.smartfoxserver.com/downloads/sfs2x/patches/SFS2X-Patch-${SFS_PATCH}.zip \
    && echo "Downloaded the ZIP file" \
    && unzip SFS2X-Patch-${SFS_PATCH}.zip \
    && echo "Extracted the ZIP file" \
    && pwd \
    && ls -al \
    && cd SFS2X-Patch-${SFS_PATCH} \
    && echo "Changed directory to SFS2X-Patch-${SFS_PATCH}" \
    && pwd \
    && ls -al \
    && /usr/lib/jvm/default-jvm/jre/bin/java -version \
    && ./install-linux.sh \
    && echo "Executed install-linux.sh" \
    && cd .. \
    && echo "Changed back to the previous directory" \
    && rm -rf SFS2X-Patch-${SFS_UPDATE}.zip SFS2X-Patch-${SFS_PATCH} \
    && echo "Removed the ZIP file and extracted folder"


EXPOSE 8080 8443 9933 5000

WORKDIR /opt/SmartFoxServer_2X/SFS2X

CMD ["sh", "sfs2x.sh"]
