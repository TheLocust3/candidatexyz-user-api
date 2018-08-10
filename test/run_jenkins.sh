#!/bin/bash

set -e

echo Setting up

mkdir ~/.bundle
touch ~/.bundle/config
echo BUNDLE_PATH: vendor/bundle > ~/.bundle/config

gem install bundler

cd common/
bundle install --path vendor/bundle

cd ../

bundle config --local local.candidatexyz-common common/
bundle install --path vendor/bundle

bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:seed

echo Running tests

bundle exec rails test
