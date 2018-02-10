FROM selenium/standalone-chrome:3.4.0

USER root

# =========================================================================
# Install NodeJS
# gpg keys listed at https://github.com/nodejs/node
# =========================================================================

RUN set -ex \
&& for key in \
94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
FD3A5288F042B6850C66B31F09FE44734EB7990E \
71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
B9AE9905FFD7803F25714661B63B535A4C206CA9 \
56730D5401028683275BD23C23EFEFE93C4CFFFE \
; do \
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
done

ENV NPM_CONFIG_LOGLEVEL warn
ENV NODE_VERSION 6.11.2

RUN apt-get update && \
    apt-get install -y --force-yes --no-install-recommends \
    curl \
    build-essential \
    rsync \
    ruby \
    ruby-dev \
    ruby-sass \
    netcat-openbsd && \
    curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" && \
    curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" && \
    gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc && \
    grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - && \
    tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 && \
    rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt

# =========================================================================
# Install Ruby Gems
# =========================================================================
RUN gem install bundler --no-ri --no-rdoc

RUN apt-get autoremove -y --purge ruby-dev  && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*
    
# Expose ports.
EXPOSE 5901

CMD ["/opt/bin/entry_point.sh"]
