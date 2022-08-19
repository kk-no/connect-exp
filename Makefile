BIN := $(CURDIR)/.bin
PATH := $(BIN):${PATH}
UNAME_OS := $(shell uname -s)
UNAME_ARCH := $(shell uname -m)

$(BIN):
	mkdir -p $(BIN)

BUF := $(BIN)/buf
$(BUF): | $(BIN)
	@go install github.com/bufbuild/buf/cmd/buf@latest

PROTOC_GEN_GO := $(BIN)/protoc-gen-go
$(PROTOC_GEN_GO): | $(BIN)
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

PROTOC_GEN_CONNECT_GO := $(BIN)/protoc-gen-connect-go
$(PROTOC_GEN_CONNECT_GO): | $(BIN)
	@go install github.com/bufbuild/connect-go/cmd/protoc-gen-connect-go@latest

.PHONY: lint
lint: | $(BUF) $(PROTOC_GEN_GO) $(PROTOC_GEN_CONNECT_GO)
	@$(BUF) lint

.PHONY: gen
gen: | $(BUF) $(PROTOC_GEN_GO) $(PROTOC_GEN_CONNECT_GO)
	@$(BUF) generate
