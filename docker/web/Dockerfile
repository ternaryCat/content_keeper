FROM ruby:3.0.0-slim

ENV LANG C.UTF-8

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev curl\
                            && rm -rf /var/lib/apt/lists/*

# for a JS runtime
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# for yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn

COPY docker/web/dpkg /etc/logrotate.d/
RUN chmod 644 /etc/logrotate.d/dpkg

RUN useradd -ms /bin/bash dockeruser
RUN usermod -aG sudo dockeruser
USER dockeruser
WORKDIR /home/dockeruser/project

RUN gem install bundler -v 2.1.4

COPY docker/web/docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
