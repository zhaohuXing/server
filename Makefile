SHELL := /bin/bash

.PHONY: help
help:
	@echo "Please use \`make <target>\` where <target> is one of"
	@echo "  generate          to generate all"

.PHONY: generate
generate: generate-raft-pb format

.PHONY: format
format: 
	@echo "Formatting packages using gofmt..."
	@find . -path "*/vendor/*" -o -path "*/tmp/*" -prune -o -name '*.go' -type f -exec gofmt -s -w {} \;
	@echo "Done"

.PHONY: generate-raft-pb
generate-raft-pb:
	@echo "Generating raftpb code..."
	@if [[ ! -f "$$(which protoc)" ]]; then \
		echo "ERROR: Command \"protoc\" not found."; exit 1; \
	 fi
	@protoc \
		-I=. \
		-I=$(GOPATH)/src \
		-I=$(GOPATH)/src/github.com/gogo/protobuf/protobuf \
		--gogo_out=. \
		raft/raftpb/raft.proto
	@echo "Done"
