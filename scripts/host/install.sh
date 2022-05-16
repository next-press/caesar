#!/usr/bin/env bash
set -x

# Check if network exists
docker network ls | grep caesar

# Create the main network
docker network create -d bridge caesar_supervisor
