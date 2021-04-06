TEST             ?= $$(go list ./...)
GO_FILES         ?= $$(find . -name '*.go')
CLOUDFLARE_EMAIL ?= example@example.com
CLOUDFLARE_KEY   ?= aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
VERSION          ?= dev+$$(git rev-parse --short HEAD)
HASHICORP_CHECKPOINT_TIMEMOUT ?= 30000

build:
	@go build \
		-gcflags=all=-trimpath=$(GOPATH) \
		-asmflags=all=-trimpath=$(GOPATH) \
		-ldflags="-X github.com/cloudflare/cf-terraforming/internal/app/cf-terraforming/cmd.versionString=$(VERSION)" \
		-o cf-terraforming cmd/cf-terraforming/main.go

test:
	@CI=true \
		USE_STATIC_RESOURCE_IDS=true \
		CHECKPOINT_TIMEOUT=$(HASHICORP_CHECKPOINT_TIMEMOUT) \
		CLOUDFLARE_EMAIL="$(CLOUDFLARE_EMAIL)" \
		CLOUDFLARE_KEY="$(CLOUDFLARE_KEY)" \
		go test $(TEST) -v $(TESTARGS)

fmt:
	gofmt -w $(GO_FILES)

.PHONY: build test fmt
