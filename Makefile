DOCKERNAME=zeroonetechnology/nvim

build:
	docker build -f docker/Dockerfile -t $(DOCKERNAME):latest docker

bash: build
	docker run --rm \
		-v $(PWD):/root/nvim-education \
		-w /root/nvim-education\
		-it $(DOCKERNAME) \
		/bin/bash
