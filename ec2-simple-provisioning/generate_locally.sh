#!/usr/bin/env bash

set -e -x

cd bundle/

# This script will be executed locally, on the machine running terraform.
# Files and directories created under "bundle" directory
# will be uploaded to remote machine with the use of file provisioner.

# The contents will ultimately be available on the remote under "/bundle"

# Note the "bundle" directory already contains one script to be uploaded 'install_remotely.sh'
# which will be executed on the remote machine.




#example

rm -rf automatically_generated_dir

mkdir automatically_generated_dir
echo 'text' > automatically_generated_dir/file
