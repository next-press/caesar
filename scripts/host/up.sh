#!/usr/bin/env bash
# set -Eeuo pipefail
# set -x

. ${LIB_PATH}/scripts/lib/func.sh

# make down
rm -rf "$CWD_PATH/certs"

echo "Starting..."
# echo $LIB_PATH

if [ -n "$1" ]; then
    DM=$1
else
    . "$CWD_PATH/.env"
    DM="$DOMAIN_NAME"
fi

if ! [ -n "$DM" ]; then
  echo "Invalid folder"
  exit 1;
fi

export DOMAIN_NAME=$DM

THE_SLUG=$(${LIB_PATH}/scripts/lib/slugify $1)

export SLUG="$THE_SLUG"

touch "$CWD_PATH/.env"

mkdir "$CWD_PATH/.vscode" 2> /dev/null

cp "$LIB_PATH/launch.json" "$CWD_PATH/.vscode/launch.json"

${LIB_PATH}/scripts/lib/add-or-replace "$CWD_PATH/.env" "SLUG" $THE_SLUG
${LIB_PATH}/scripts/lib/add-or-replace "$CWD_PATH/.env" "DOMAIN_NAME" $1

bash ${LIB_PATH}/scripts/host/install.sh $1

# docker network prune > /dev/null 2>&1

export COMPOSE_IGNORE_ORPHANS=True

docker network ls | grep -q "caesar_$THE_SLUG" || docker network create -d bridge "caesar_$THE_SLUG"

export COMPOSE_PROJECT_NAME=caesar

docker compose \
  -f ${LIB_PATH}/docker-compose-caesar-supervisor.yaml \
  up -d \
  # --build

export COMPOSE_PROJECT_NAME="caesar-$THE_SLUG"

docker compose \
  -f ${LIB_PATH}/docker-compose.yaml \
  up -d \
  # --build

# cp "${LIB_PATH}/config/wp-config.php"

bash ${LIB_PATH}/scripts/lib/update-hosts.sh $1

#
# Init inside the container
#
touch "$CWD_PATH/.env"

cat "$CWD_PATH/.env" | grep -q INSTALLED

if [ $? -eq 0 ]; then

  echo "WordPress already installed. Skiping..."

else 

  docker exec -u root "caesar-${SLUG}-wordpress" bash /scripts/init.sh $1

  echo "INSTALLED=1" >> $CWD_PATH/.env

fi
#
# End Check for Installatation.
#

## You create a directory to store your mkcert certificates
sudo rm -rf ~/Documents/root-ca

mkdir ~/Documents/root-ca 2> /dev/null

# touch "$CWD_PATH/.status"

# cat "$CWD_PATH/.status" | grep -q "TRUSTED=$DOMAIN_NAME"

# if [ $? -eq 0 ]; then

#   echo "Root Certificated already trusted. Skiping..."

# else

  while :
    do

    if docker container ls | grep "caesar-$THE_SLUG-cert" &> /dev/null; then
      echo "Waiting for certificates to be ready..."
      sleep 3
    else 
      echo "Almost there..."
      sleep 5
      break
    fi

  done

  ## You copy your mkcert keys from your docker container to your localhost
  docker cp "caesar-$THE_SLUG-cert:/root/.local/share/mkcert" ~/Documents/root-ca

  ## Make MacOS trust the certificates
  sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/Documents/root-ca/mkcert/rootCA.pem

#   echo "TRUSTED=$DOMAIN_NAME" >> $CWD_PATH/.status

# fi

echo "Done!"
