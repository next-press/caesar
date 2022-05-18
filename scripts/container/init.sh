#!/usr/bin/env bash
# set -x

export DOMAIN_NAME=$1
export INSTALL_TYPE=$2

bash /scripts/install-wp.sh
