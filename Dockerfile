FROM node:7-slim
USER root

# =========================================================================
# Install NodeJS
# gpg keys listed at https://github.com/nodejs/node
# =========================================================================

RUN apt-get update && \
    apt-get install -y --force-yes --no-install-recommends \
    curl \
    build-essential \
    ruby \
    netcat-openbsd && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

# =========================================================================
# Install NPM modules
# =========================================================================

ENV PHANTOMJS_VERSION 1.9.8

RUN npm install -g phantomjs-prebuilt

# =========================================================================
# Install Ruby Gems
# =========================================================================

RUN gem install sass

CMD ["/bin/bash"]

# Expose ports.
EXPOSE 5901
