FROM ruby:3.2.0

RUN apt-get update -yq \
  && apt-get upgrade -yq \
  #ESSENTIALS
  && apt-get install -y -qq --no-install-recommends build-essential curl git-core vim passwd unzip cron gcc wget netcat \
  # RAILS PACKAGES NEEDED
  && apt-get update \
  && apt-get install -y --no-install-recommends imagemagick postgresql-client libvips \
  # INSTALL NODE
  && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install -y --no-install-recommends nodejs \
  # INSTALL YARN
  && npm install -g yarn

# Clean cache and temp files, fix permissions
RUN apt-get clean -qy \
  && rm -rf /var/lib/apt/lists/*

ARG WWWGROUP

RUN groupadd --force -g $WWWGROUP rails
RUN useradd -ms /bin/bash --no-user-group -g $WWWGROUP -u 1337 rails
RUN usermod -u ${WWWGROUP} rails

RUN mkdir /app

RUN mkdir /bundle

RUN chown -R rails:rails /app

RUN chown -R rails:rails /bundle

WORKDIR /app

RUN yarn add esbuild

# install specific version of bundler
RUN gem install bundler -v 2.2.32

ENV BUNDLE_GEMFILE=/app/Gemfile \
  BUNDLE_JOBS=20 \
  BUNDLE_PATH=/bundle \
  BUNDLE_BIN=/bundle/bin \
  GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

USER rails

CMD ["bash"]
