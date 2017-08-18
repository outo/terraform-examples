#!/usr/bin/env bash

set -e -x

# create directory to receive the whole bundle
sudo mkdir -p /bundle

# set access and ownership uniformly, use user argument ($1)
sudo chown $1:$1 /bundle -R
sudo chmod go-rwx /bundle -R

# copy bundle from tmp location
cp -r /tmp/bundle/** /bundle

# cleanup tmp location
rm -rf /tmp/bundle

sudo apt-get update
sudo apt-get install -y nginx
sudo service nginx start
