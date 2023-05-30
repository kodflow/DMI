LIB_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
include $(shell readlink -f $(LIB_DIR)/functions.mk)

############################
#╔════════════════════════╗#
#║ DEFAULT CONFIGURATION  ║#
#╚════════════════════════╝#
############################
.PHONY: help
.SILENT:

.DEFAULT_GOAL = help
ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

$(eval $(ARGS):;@:)
$(eval GWD=$(shell git rev-parse --show-toplevel 2>/dev/null ))
$(eval BNAME=$(shell basename $(GWD)))
$(shell git config core.hooksPath $(GWD)/.hooks 2>/dev/null || true)
$(shell chmod +x $(GWD)/.hooks/*)

help: #Pour générer automatiquement l'aide ## Display all commands available
	$(eval PADDING=$(shell grep -x -E '^[a-zA-Z_-]+:.*?##[\s]?.*$$' Makefile | awk '{ print length($$1)-1 }' | sort -n | tail -n 1))
	clear
	echo '╔──────────────────────────────────────────────────╗'
	echo '║ ██╗  ██╗███████╗██╗     ██████╗ ███████╗██████╗  ║'
	echo '║ ██║  ██║██╔════╝██║     ██╔══██╗██╔════╝██╔══██╗ ║'
	echo '║ ███████║█████╗  ██║     ██████╔╝█████╗  ██████╔╝ ║'
	echo '║ ██╔══██║██╔══╝  ██║     ██╔═══╝ ██╔══╝  ██╔══██╗ ║'
	echo '║ ██║  ██║███████╗███████╗██║     ███████╗██║  ██║ ║'
	echo '║ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝ ║'
	echo '╟──────────────────────────────────────────────────╝'
	@grep -E '^[a-zA-Z_-]+:.*?##[\s]?.*$$' Makefile | awk 'BEGIN {FS = ":.*?##"}; {gsub(/(^ +| +$$)/, "", $$2);printf "╟─[ \033[36m%-$(PADDING)s\033[0m %s\n", $$1, "] "$$2}'
	echo '╚──────────────────────────────────────────────────>'
	echo ''

build: ## Build all dockers images
	docker compose --profile kernel build
	docker compose --profile services build

publish: build ## Publish all dockers images
	docker compose --profile kernel push
	docker compose --profile services push

run: publish ## Run command
	docker run -ti --rm --pull=always kodmain/kernel:latest