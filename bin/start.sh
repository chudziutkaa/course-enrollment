#!/bin/bash

bundle check || bundle install

if [ -f tmp/pids/server.pid ]; then
  rm -f tmp/pids/server.pid
fi

bundle exec rails server -p ${PORT:-3000} -e ${RAILS_ENV:development} -b 0.0.0.0
