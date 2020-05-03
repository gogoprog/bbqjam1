compile:
	haxe build.hxml

retail:
	rm -rf build
	rm -rf retail
	mkdir -p retail/build
	mkdir -p retail/src
	mkdir -p retail/deps/whiplash/deps
	haxe build.hxml
	cp data -r retail/
	cp src/index.html -r retail/src/
	cp deps/whiplash/deps/phaser.min.js retail/deps/whiplash/deps/
	cp deps/whiplash/deps/jquery-3.3.1.min.js retail/deps/whiplash/deps/
	uglifyjs --compress --mangle -- build/generated.js > retail/build/generated.js

zip: retail
	rm -f retail.zip
	cd retail && zip -r ../retail.zip ./*

.PHONY: retail
