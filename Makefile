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

test-render:
	@make build
	# TODO get test-data into this directory.
	rm -rvf test-data-output/
	docker run --rm -it \
		-e MINECRAFT_VERSION="1.15.2" \
		-v "$(shell pwd)/test-data:/home/minecraft/server/:ro" \
		-v "$(shell pwd)/test-data-output:/home/minecraft/render/:rw" \
		mide/minecraft-overviewer:latest

test-image:
	@make build
	bundle exec rspec

push:
	@make build
	echo "${DOCKER_HUB_PASSWORD}" | docker login -u "${DOCKER_HUB_USERNAME}" --password-stdin
	docker push "mide/minecraft-overviewer:latest"
	docker push "mide/minecraft-overviewer:${TRAVIS_COMMIT}"
	docker push "mide/minecraft-overviewer:$(shell date +%Y-%m)"
