#!/usr/bin/env bash
# set -x

# Create the main network
docker network ls | grep -q caesar_supervisor || docker network create -d bridge caesar_supervisor
