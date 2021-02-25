#!/bin/bash
set -e

# yarn install --check-files

bundle install

if [ $RAILS_ENV = "production" ] || [ $RAILS_ENV = "staging" ]; then
  rails assets:precompile
fi

# bundle exec rake db:create
bundle exec rake db:migrate

rm -f tmp/pids/server.pid

exec "$@"