up:
	export WP_VERSION="latest"
	export WP_DOCKER_IMAGE="wordpress:5.9"
	WP_DOCKER_IMAGE="wordpress:5.9" docker compose -f docker-compose-site.yaml down --remove-orphans
	WP_DOCKER_IMAGE="wordpress:5.9" docker compose -f docker-compose-caesar-supervisor.yaml down --remove-orphans
	# docker kill $(docker container ls -q)
	WP_DOCKER_IMAGE="wordpress:5.9" docker compose -f docker-compose-caesar-supervisor.yaml up -d
	WP_DOCKER_IMAGE="wordpress:5.9" docker compose -f docker-compose-site.yaml up -d