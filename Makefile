OUT_DIR=bin

all: build

build:
	@echo "Building fred in $(shell pwd)"
	@mkdir -p $(OUT_DIR)
	@crystal build -o $(OUT_DIR)/fred src/fred.cr

run:
	$(OUT_DIR)/fred

clean:
	rm -rf  $(OUT_DIR) .crystal .shards libs lib docs

link:
	@ln -s `pwd`/bin/fred /usr/local/bin/fred

force_link:
	@echo "Symlinking `pwd`/bin/fred to /usr/local/bin/fred"
	@ln -sf `pwd`/bin/fred /usr/local/bin/fred
