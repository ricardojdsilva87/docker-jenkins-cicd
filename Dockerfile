FROM jenkins/jnlp-slave:latest-jdk11

# Required Environment variables
ENV CHROME_BIN /usr/bin/chromium
ENV CHROMIUM_BIN /usr/bin/chromium
ENV CHROMEDRIVER_BIN /usr/bin/chromedriver

# Upgrade permissions
USER root

# Update references to various repositories ( NodeJS 8.x, Yarn, etc. )
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install required packages
##############################

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Maven
    maven \
    # NodeJS + NPM + Yarn
    nodejs \
    yarn \
    # Chromium + Chrome driver
    chromium \
    chromium-driver \
    # cypress dependencies
    xvfb libgtk2.0-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 \
    # SVN
    git-svn \
    subversion \
    # Utilities
    zip \
    unzip \
    curl \
    rsync \
    jq \
    # AWS CLI requirement
    python \
    python-setuptools \
    python-wheel \
    python-pip \
    # Source code building ( node-gyp, etc. )
    build-essential \
    # Cloudfoundry CLI
    && curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&source=github" | tar -zx \
    && mv cf /usr/local/bin \
    && chmod +x /usr/local/bin/cf \
    # Akamai CLI
    && curl -L "https://github.com/akamai/cli/releases/download/1.0.2/akamai-1.0.2-linuxamd64" -o /usr/local/bin/akamai \
    && chmod +x /usr/local/bin/akamai \
    # Akamai purge CLI
    && curl -L "https://github.com/akamai/cli-purge/releases/download/1.0.0/akamai-purge-1.0.0-linuxamd64" -o /usr/local/bin/akamai-purge \
    && chmod +x /usr/local/bin/akamai-purge \
    # Move to the root home directory
    && cd \
    # Install AWS CLI
    && pip install --no-cache-dir awscli

# Cleanup
#########

RUN find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    && rm -rf /var/lib/apt/lists/*

# Downgrade permissions
USER jenkins
