.PHONY: deploy remove help echo
default: deploy

BRANCH = $(shell git symbolic-ref --short HEAD | cut -c1-30)
TICKET_NUMBER = $(shell echo $(BRANCH) | cut -c7-10 )

ifeq ($(BRANCH),master)
	STAGE = prod
else ifeq ($(BRANCH),develop)
	STAGE = dev
else
	STAGE = "$(TICKET_NUMBER)"
endif

deploy: echo ## Deploy Api Gateway Cloudformation Template
	serverless deploy \
		--verbose \
		--stage $(STAGE) \

remove: echo ## Remove Api Gateway Cloudformation Template
	serverless remove \
		--verbose \
		--stage $(STAGE) \

echo: ## Helpful way to see the makefile variables
	@printf "Stage: $(STAGE)\n"
	@printf "Branch: $(BRANCH)\n"
	@printf "Ticket Number: $(TICKET_NUMBER)\n"

help:  ## Prints the names and descriptions of available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'