FROM pierexmachina/alpine:3.7

ARG NODE_VER=8.9.3
ARG NPM_VER=3
ARG CORES_BUILD
ARG NODE_CONFIG="--fully-static \
                 --prefix=/usr"
ARG NODE_GPG="9554F04D7259F04124DE6B476D5A82AC7E37093B \
            94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
            0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
            FD3A5288F042B6850C66B31F09FE44734EB7990E \
            71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
            DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
            C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
            56730D5401028683275BD23C23EFEFE93C4CFFFE \
            B9AE9905FFD7803F25714661B63B535A4C206CA9 \
            77984A986EBC2AA786BC0F66B01FBB92821C587A"

LABEL description="nodejs based on alpine" \
      tags="lts 8.9.3 8.9 8" \
      maintainer="pierexmachina <https://github.com/pierexmachina>" \
      build_ver="2017120901"

ENV UID=991 \
    GID=991

RUN export BUILD_DEPS="git \
                wget \
                make \
                gcc \
                g++ \
                python \
                linux-headers \
                paxctl \
                binutils-gold \
                gnupg" \
    && apk add -U libgcc \
                libstdc++ \
                su-exec \
                tini \
                ${BUILD_DEPS} \
    && wget https://nodejs.org/dist/v${NODE_VER}/node-v${NODE_VER}.tar.gz -O /tmp/node-v${NODE_VER}.tar.gz \
    && wget https://nodejs.org/dist/v${NODE_VER}/SHASUMS256.txt.asc -O /tmp/SHASUMS256.txt.asc \
    && cd /tmp \
    && gpg --keyserver pool.sks-keyservers.net --recv-keys ${NODE_GPG} \
    && gpg --verify SHASUMS256.txt.asc \
    && grep node-v${NODE_VER}.tar.gz SHASUMS256.txt.asc | sha256sum -c - \
    && tar xf /tmp/node-v${NODE_VER}.tar.gz \
    && cd /tmp/node-v${NODE_VER} \
    && NB_CORES=${CORES_BUILD-$(grep -c ^processor /proc/cpuinfo 2> /dev/null || 1)} \
    && ./configure --prefix=/usr \
    && make -j ${NB_CORES} \
    && make install && paxctl -cm /usr/bin/node \
    && npm install -g npm@${NPM_VER} \
    && find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf \
    && strip -s /usr/bin/node \
    && cd / \
    && apk del ${BUILD_DEPS} \
    && rm -rf /tmp/* \
        /var/cache/apk/* \
        /root/.npm \
        /root/.node-gyp \
        /usr/lib/node_modules/npm/man \
        /usr/lib/node_modules/npm/doc \
        /usr/lib/node_modules/npm/html \
        /usr/share/man

COPY startup /usr/local/bin/startup
RUN chmod +x /usr/local/bin/startup

ENTRYPOINT ["/usr/local/bin/startup"]
CMD ["node", "-v"]
