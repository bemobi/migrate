TESTFLAGS?=
DCR=docker-compose run --rm
GOTEST=go test $(TESTFLAGS) `go list  ./... | grep -v "/vendor/"`

.PHONY: clean test build release run
all: release

clean:
	rm -f migrate

fmt:
	@gofmt -s -w `go list -f {{.Dir}} ./... | grep -v "/vendor/"`

test: fmt
	$(DCR) go-test

go-test: fmt
	@$(GOTEST)

build:
	@go build -o migrate

release: test build 
