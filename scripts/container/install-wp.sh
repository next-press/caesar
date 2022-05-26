#!/usr/bin/env bash

function tap_wp_config {

  if [ "$INSTALL_TYPE" == "single" ]; then
    return
  fi

  cat wp-config.php | grep 

  if [ "$INSTALL_TYPE" == "subdomain" ]; then

    pwd;

  elif [ "$INSTALL_TYPE" == "subdomain" ]; then

    pwd

  fi

}

{

  if wp core is-installed --allow-root &> /dev/null; then
    
    wp config set 
    
  fi

  while :
    do
    if ! [ -s /var/www/html/wp-config.php ]; then
      sleep 3s
    else 
      sleep 3s
      break
    fi

  done

  touch /var/www/html/install.log

  mv "/var/www/html/.htaccess-$INSTALL_TYPE" /var/www/html/.htaccess

  if [ "$INSTALL_TYPE" == "subdomain" ]; then

    wp core multisite-install \
    --subdomains --url="$DOMAIN_NAME" \
    --title="NextPress Sites" \
    --admin_user=admin \
    --admin_password=admin \
    --admin_email=admin@nextpress.dev \
    --allow-root

  elif [ "$INSTALL_TYPE" == "single" ]; then

    wp core install \
    --url="$DOMAIN_NAME" \
    --title="NextPress Sites" \
    --admin_user=admin \
    --admin_password=admin \
    --admin_email=admin@nextpress.dev\
    --allow-root

  else

    wp core multisite-install \
    --url="$DOMAIN_NAME" \
    --title="NextPress Sites" \
    --admin_user=admin \
    --admin_password=admin \
    --admin_email=admin@nextpress.dev \
    --allow-root

  fi

  rm /var/www/html/wp-content/plugins/index.php
  rm /var/www/html/wp-content/plugins/hello.php
  rm -rf /var/www/html/wp-content/plugins/akismet

  wp plugin install query-monitor \
    --allow-root \
    --activate-network
    
  wp plugin install debug-bar-slow-actions \
    --allow-root \
    --activate-network

} &> /var/www/html/install.log
