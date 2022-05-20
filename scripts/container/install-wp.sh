#!/usr/bin/env bash
{

  if wp core is-installed --allow-root &> /dev/null; then
    exit
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

  wp plugin install query-monitor \
    --allow-root \
    --activate-network
    
  wp plugin install debug-bar-slow-actions \
    --allow-root

} &> /var/www/html/install.log
