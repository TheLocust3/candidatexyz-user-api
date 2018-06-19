#!/bin/bash

set -e

cd /home/ubuntu

sudo apt-get update

sudo apt-get install libpq-dev # pg gem dependency

# install updated version of ruby build
sudo apt-get install -y rbenv ruby-build autoconf bison
mkdir -p ~/.rbenv/plugins
cd ~/.rbenv/plugins
rm -rf ruby-build/
git clone https://github.com/sstephenson/ruby-build.git # update ruby-build definitions

# setup nginx + passenger
sudo apt-get install -y nginx
