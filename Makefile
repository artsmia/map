galleries.json:
	phantomjs walk_galleries.coffee walk > galleries.json

gallery-thumbs:
	phantomjs walk_galleries.coffee snap
	du -hs galleries
	optipng -quiet galleries/*
	echo $$(du -hs galleries) -- after
