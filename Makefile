build:
	docker build -t mide/minecraft-overviewer:latest -f Dockerfile .
	docker tag "mide/minecraft-overviewer:latest" "mide/minecraft-overviewer:${TRAVIS_COMMIT}"
	docker tag "mide/minecraft-overviewer:latest" "mide/minecraft-overviewer:$(shell date +%Y-%m)"

test-dive:
	docker build -t mide/minecraft-overviewer:latest -f Dockerfile .
	docker run --rm -it \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e CI=true \
		wagoodman/dive:latest "mide/minecraft-overviewer:latest"
push:
	@make build
	echo "${DOCKER_HUB_PASSWORD}" | docker login -u "${DOCKER_HUB_USERNAME}" --password-stdin
	docker push "mide/minecraft-overviewer:latest"
	docker push "mide/minecraft-overviewer:${TRAVIS_COMMIT}"
	docker push "mide/minecraft-overviewer:$(shell date +%Y-%m)"
