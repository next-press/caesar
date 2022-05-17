#!/usr/bin/env bash

. "${CWD_PATH}/.env" > /dev/null 2>&1

if [ -n "$SLUG" ]; then
    
  docker container stop "caesar-${SLUG}-wordpress" > /dev/null 2>&1
  docker container stop "caesar-${SLUG}-cert" > /dev/null 2>&1
  docker container stop "caesar-${SLUG}-db" > /dev/null 2>&1

  docker container kill "caesar-${SLUG}-wordpress" > /dev/null 2>&1
  docker container kill "caesar-${SLUG}-cert" > /dev/null 2>&1
  docker container kill "caesar-${SLUG}-db" > /dev/null 2>&1

  docker container rm "caesar-${SLUG}-wordpress" > /dev/null 2>&1
  docker container rm "caesar-${SLUG}-cert" > /dev/null 2>&1
  docker container rm "caesar-${SLUG}-db" > /dev/null 2>&1

else

  docker container stop $(docker container ls -q) > /dev/null 2>&1

fi

echo "Shutting down..."