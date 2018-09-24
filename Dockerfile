FROM jenkins/slave:alpine

# Install required packages
##############################

RUN apk --update add --no-cache \
    # Maven
    maven \
    # NodeJS + NPM
    nodejs \
    npm \
    # Chromium + Chrome driver
    chromium \
    chromium-chromedriver \
    # SVN
    git-svn \
    subversion \
    # Utilities
    zip \
    unzip \
    curl \
    # AWS CLI requirement
    py2-pip \
    # Cloudfoundry CLI
    && curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&source=github" | tar -zx \
    && mv cf /usr/local/bin \
    && pip install awscli

# Cleanup
#########

RUN find /usr/local \
      \( -type d -a -name test -o -name tests \) \
      -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
      -exec rm -rf '{}' + \
    && rm -rf /var/cache/apk/*
