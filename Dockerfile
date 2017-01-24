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
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

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
