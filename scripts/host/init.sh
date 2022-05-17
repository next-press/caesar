#!/usr/bin/env bash
# set -x

# Name of the project.
NAME=$1

DOMAIN_NAME=$2

mkdir "$NAME"

cd "$NAME";

npm init -y

npm link caesar

caesar up $DOMAIN_NAME