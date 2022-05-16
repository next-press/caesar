#!/usr/bin/env bash

if wp core is-installed --network --allow-root &> /dev/null; then
  echo "WordPress already installed... Skipping..."
  exit
fi

while :
do

  if ! wp core version --allow-root &> /dev/null; then
    echo "Waiting for the core install to finish..."
    sleep 3s
  else 
    echo "Almost there..."
    sleep 10s
    break
  fi

done

echo "Installing Multisite..."

wp core multisite-install --url="$DOMAIN_NAME" --title="NextPress Sites" --admin_user=admin --admin_password=admin --admin_email=admin@nextpress.dev --allow-root