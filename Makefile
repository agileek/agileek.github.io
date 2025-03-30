test:
	@hugo server -D

build:
	@echo "Building site"
	@hugo build

deploy: build
	@scp -r public/* server.local.bitard.fr:~/blog/