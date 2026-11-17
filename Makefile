# The playhold version this SDK is built for: its wire code comes from that version's proto, and its tests run against a
# server on that version. testserver/go.mod must require the same one; make pin checks it.
PLAYHOLD_VERSION := v0.3.0

BUF_VERSION := v1.75.0
BUF := go run github.com/bufbuild/buf/cmd/buf@$(BUF_VERSION)
PROTO := https://github.com/ny4rl4th0t3p/playhold.git\#tag=$(PLAYHOLD_VERSION),subdir=proto

.DEFAULT_GOAL := help

.PHONY: help check web server pin gen tidy

help: ## Show the available targets
	@awk 'BEGIN {FS = ":.*## "} /^[a-z]+:.*## / {printf "  %-6s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check: web server pin ## Run every check

web: node_modules ## Type-check the SDK and run its tests, which build and start the test server
	npm run check

node_modules: package-lock.json
	npm ci
	touch node_modules

server: ## Build and vet the test server
	cd testserver && go build -o /dev/null . # a single main package: without -o, go build would write the binary here
	cd testserver && go vet ./...

pin: ## Check testserver/go.mod requires PLAYHOLD_VERSION
	@got=$$(cd testserver && go list -m -f '{{.Version}}' github.com/ny4rl4th0t3p/playhold); \
	if [ "$$got" != "$(PLAYHOLD_VERSION)" ]; then \
		echo "testserver/go.mod requires playhold $$got, but PLAYHOLD_VERSION is $(PLAYHOLD_VERSION)"; exit 1; \
	fi

gen: node_modules ## Generate the wire code from playhold's proto at PLAYHOLD_VERSION
	$(BUF) generate '$(PROTO)' --path playhold/v1/frames.proto

tidy: ## Tidy the test server's module
	cd testserver && go mod tidy