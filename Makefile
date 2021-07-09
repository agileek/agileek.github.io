JEKYLL = docker run -ti --rm -v "$(shell pwd):/srv/jekyll" -p 4000:4000 jekyll/jekyll:4.1.0

test:
	@${JEKYLL} jekyll serve --watch -H 0.0.0.0 --drafts

build:
	@echo "Building site"
	@${JEKYLL} jekyll build

update:
	@${JEKYLL} bundle update
