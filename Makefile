up:
	docker compose -f docker-compose-caesar-supervisor.yaml down
	# docker kill $(docker container ls -q)
	docker compose -f docker-compose-caesar-supervisor.yaml up -d