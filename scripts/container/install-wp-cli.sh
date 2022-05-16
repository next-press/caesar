#!/usr/bin/env bash
# set -Eeuo pipefail

if command -v wp &> /dev/null
then
    echo "WP CLI already installed. Skipping..."
    exit
fi

echo "WP CLI not found... Installing..."

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &> /dev/null
# php wp-cli.phar --info
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp --info &> /dev/null && echo "Installation completed!"