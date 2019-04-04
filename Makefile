.PHONY: build deploy remove help echo
default: build

BRANCH = $(shell git symbolic-ref --short HEAD | cut -c1-10)
TICKET_NUMBER = $(shell echo $(BRANCH) | cut -c7- )

ifeq ($(BRANCH),master)
	STAGE = prod
	PREFIX = hello-prod
else ifeq ($(BRANCH),release)
	STAGE = qa
	PREFIX = hello-qa
else ifeq ($(BRANCH),develop)
	STAGE = develop
	PREFIX = hello-dev
else
	STAGE = dev
	PREFIX = "hello-$(TICKET_NUMBER)"
endif


help:  ## Prints the names and descriptions of available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build:
	npm install

deploy: build ## Deploy Serverless Service
	serverless deploy \
		--verbose \
		--stage $(STAGE) \
		--prefix $(PREFIX) 

remove: build ## Remove resources
	serverless remove \
		--verbose \
		--stage $(STAGE) \
		--prefix $(PREFIX)

echo: ## Helpful way to see the makefile variables
	@printf "Stage: $(STAGE)\n"
	@printf "Prefix: $(PREFIX)\n"
	@printf "Branch: $(BRANCH)\n"
	@printf "Ticket Number: $(TICKET_NUMBER)\n"