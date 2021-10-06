OUT_DIR=bin

all: build

build:
	@echo "Building fred in $(shell pwd)"
	@mkdir -p $(OUT_DIR)
	@crystal build -o $(OUT_DIR)/fred src/fred.cr

run:
	$(OUT_DIR)/fred

install: build
	mkdir -p $(PREFIX)/bin
	cp ./bin/fred $(PREFIX)/bin

clean:
	rm -rf  bin/fred* docs tmp *.dwarf *.tmp

clean_all:
	rm -rf  $(OUT_DIR) .crystal .shards lib docs tmp *.dwarf *.tmp

run_coverage:
	@bin/crystal-coverage spec/spec_all.cr

run_spec:
	@crystal spec

release:
	@echo "you should execute: crelease x.x.x"
