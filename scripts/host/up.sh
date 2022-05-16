#!/usr/bin/env bash
# set -Eeuo pipefail

. ${LIB_PATH}/scripts/lib/func.sh

# make down
rm -rf "$CWD_PATH/certs"

echo "Starting..."
echo $LIB_PATH

export DOMAIN_NAME=$1

docker compose \
  -f ${LIB_PATH}/docker-compose.yaml \
  down --remove-orphans

docker compose \
  -f ${LIB_PATH}/docker-compose.yaml \
  up -d --remove-orphans \
  # --build

# cp "${LIB_PATH}/config/wp-config.php"

bash ${LIB_PATH}/scripts/lib/update-hosts.sh $1

#
# Init inside the container
#
touch "$CWD_PATH/.status"

cat "$CWD_PATH/.status" | grep -q INSTALLED

if [ $? -eq 0 ]; then

  echo "WordPress already installed. Skiping..."

else 

  docker exec -u root wordpress bash /scripts/init.sh $1

  echo "INSTALLED" >> $CWD_PATH/.status

fi
#
# End Check for Installatation.
#

## You create a directory to store your mkcert certificates
sudo rm -rf ~/Documents/root-ca

mkdir ~/Documents/root-ca

touch "$CWD_PATH/.status"

cat "$CWD_PATH/.status" | grep -q TRUSTED

if [ $? -eq 0 ]; then

  echo "Root Certificated already trusted. Skiping..."

else 

  ## You copy your mkcert keys from your docker container to your localhost
  docker cp mkcert:/root/.local/share/mkcert ~/Documents/root-ca

  ## Make MacOS trust the certificates
  sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/Documents/root-ca/mkcert/rootCA.pem

  echo "TRUSTED" >> $CWD_PATH/.status

fi

echo "Done!"
