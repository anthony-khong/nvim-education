DOCKERNAME=kaixhin/torch

dock:
	docker run --rm \
		-v $(PWD):/root/nvim-education \
		-w /root/nvim-education\
		-it kaixhin/torch \
		/bin/bash

th:
	docker run --rm \
		-v $(PWD):/root/nvim-education \
		-w /root/nvim-education\
		-it kaixhin/torch \
		th
