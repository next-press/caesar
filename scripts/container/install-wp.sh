#!/usr/bin/env bash
# set +x
# env

cd /var/www/html && mv ".htaccess-$INSTALL_TYPE" .htaccess

if wp core is-installed --allow-root &> /dev/null; then
  echo "WordPress already installed... Skipping..."
  exit
fi

while :
do

  if ! wp core version --allow-root &> /dev/null; then
    # echo "Waiting for WordPress image to boot up..."
    sleep 3s
  else 
    # echo "Almost there..."
    sleep 10s
    break
  fi

done

# echo "Installing WordPress..."

if [ "$INSTALL_TYPE" == "subdomain" ]; then

  wp core multisite-install --subdomains --url="$DOMAIN_NAME" --title="NextPress Sites" --admin_user=admin --admin_password=admin --admin_email=admin@nextpress.dev --allow-root

elif [ "$INSTALL_TYPE" == "single" ]; then

  wp core install --url="$DOMAIN_NAME" --title="NextPress Sites" --admin_user=admin --admin_password=admin --admin_email=admin@nextpress.dev --allow-root

else

  wp core multisite-install --url="$DOMAIN_NAME" --title="NextPress Sites" --admin_user=admin --admin_password=admin --admin_email=admin@nextpress.dev --allow-root

fi

# Install plugins
wp plugin install query-monitor --allow-root --activate-network
wp plugin install debug-bar-slow-actions --allow-root