-include .env

# BuildKit enables higher performance docker builds and caching possibility
# to decrease build times and increase productivity for free.
# https://docs.docker.com/compose/environment-variables/envvars/
export DOCKER_BUILDKIT ?= 1

ifeq ($(COMPOSE_PROJECT_NAME),)
	COMPOSE_PROJECT_NAME=ss
endif

# Docker binary to use, when executing docker tasks
DOCKER ?= docker

# Binary to use, when executing docker-compose tasks
DOCKER_COMPOSE ?= $(DOCKER) compose

# Support image with all needed binaries, like envsubst, mkcert, wait4x
SUPPORT_IMAGE ?= wayofdev/build-deps:alpine-latest

BUILDER_PARAMS ?= $(DOCKER) run --rm -i \
	--env-file ./.env \
	--env COMPOSE_PROJECT_NAME=$(COMPOSE_PROJECT_NAME) \
	--env SHARED_DOMAIN_SEGMENT="$(SHARED_DOMAIN_SEGMENT)"

BUILDER ?= $(BUILDER_PARAMS) $(SUPPORT_IMAGE)
BUILDER_WIRED ?= $(BUILDER_PARAMS) --network project.$(COMPOSE_PROJECT_NAME) $(SUPPORT_IMAGE)

# Shorthand envsubst command, executed through build-deps
ENVSUBST ?= $(BUILDER) envsubst

# Yamllint docker image
YAML_LINT_RUNNER ?= $(DOCKER) run --rm $$(tty -s && echo "-it" || echo) \
	-v $(PWD):/data \
	cytopia/yamllint:latest \
	-c ./.github/.yamllint.yaml \
	-f colored .

ACTION_LINT_RUNNER ?= $(DOCKER) run --rm $$(tty -s && echo "-it" || echo) \
	-v $(shell pwd):/repo \
	 --workdir /repo \
	 rhysd/actionlint:latest \
	 -color

MARKDOWN_LINT_RUNNER ?= $(DOCKER) run --rm $$(tty -s && echo "-it" || echo) \
	-v $(shell pwd):/app \
	--workdir /app \
	davidanson/markdownlint-cli2-rules:latest \
	--config ".github/.markdownlint.json"

EXPORT_VARS = '\
	$${SHARED_DOMAIN_SEGMENT} \
	$${COMPOSE_PROJECT_NAME}'

#
# Self documenting Makefile code
# ------------------------------------------------------------------------------------
ifneq ($(TERM),)
	BLACK := $(shell tput setaf 0)
	RED := $(shell tput setaf 1)
	GREEN := $(shell tput setaf 2)
	YELLOW := $(shell tput setaf 3)
	LIGHTPURPLE := $(shell tput setaf 4)
	PURPLE := $(shell tput setaf 5)
	BLUE := $(shell tput setaf 6)
	WHITE := $(shell tput setaf 7)
	RST := $(shell tput sgr0)
else
	BLACK := ""
	RED := ""
	GREEN := ""
	YELLOW := ""
	LIGHTPURPLE := ""
	PURPLE := ""
	BLUE := ""
	WHITE := ""
	RST := ""
endif
MAKE_LOGFILE = /tmp/wayofdev-docker-shared-services.log
MAKE_CMD_COLOR := $(BLUE)

default: all

help:
	@echo 'Management commands for project:'
	@echo 'Usage:'
	@echo '    ${MAKE_CMD_COLOR}make${RST}                       Creates containers, spins up project'
	@grep -E '^[a-zA-Z_0-9%-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "    ${MAKE_CMD_COLOR}make %-21s${RST} %s\n", $$1, $$2}'
	@echo
	@echo '    📑 Logs are stored in      $(MAKE_LOGFILE)'
	@echo
	@echo '    📦 Package                 docker-shared-services (https://github.com/wayofdev/docker-shared-services)'
	@echo '    🤠 Author                  Andrij Orlenko (https://github.com/lotyp)'
	@echo '    🏢 ${YELLOW}Org                     wayofdev (https://github.com/wayofdev)${RST}'
	@echo
.PHONY: help

.EXPORT_ALL_VARIABLES:

#
# Default action
# Defines default command when `make` is executed without additional parameters
# ------------------------------------------------------------------------------------
all: hooks env up
PHONY: all


# System Actions
# ------------------------------------------------------------------------------------
env: ## Generate .env file from example, use `make env force=true`, to force re-create file
ifeq ($(FORCE),true)
	@echo "${YELLOW}Force re-creating .env file from example...${RST}"
	$(ENVSUBST) $(EXPORT_VARS) < ./.env.example > ./.env
else ifneq ("$(wildcard ./.env)","")
	@echo ""
	@echo "${YELLOW}The .env file already exists! Use FORCE=true to re-create.${RST}"
else
	@echo "Creating .env file from example"
	$(ENVSUBST) $(EXPORT_VARS) < ./.env.example > ./.env
endif
.PHONY: env

override-create: ## Generate override file from dist
	cp -v docker-compose.override.yaml.dist docker-compose.override.yaml
.PHONY: override-create

cert-install: ## Run mkcert to install CA into system storage and generate default certs for traefik
	mkcert -install
	bash mkcert.sh
.PHONY: cert-install

#
# Docker Actions
# ------------------------------------------------------------------------------------
up: ## Fire up project
	$(DOCKER_COMPOSE) up --remove-orphans -d
.PHONY: up

down: ## Stops and destroys running containers
	$(DOCKER_COMPOSE) down --remove-orphans
.PHONY: down

stop: ## Stops all containers, without removing them
	$(DOCKER_COMPOSE) stop
.PHONY: stop

restart: down up ## Restart all containers, running in this project
.PHONY: restart

logs: ## Show logs for running containers in this project
	$(DOCKER_COMPOSE) logs -f
.PHONY: logs

ps: ## List running containers in this project
	$(DOCKER_COMPOSE) ps
.PHONY: ps

pull: ## Pull upstream images, specified in docker-compose.yml file
	$(DOCKER_COMPOSE) pull
.PHONY: pull

clean:
	# $(DOCKER_COMPOSE) down -v
	$(DOCKER_COMPOSE) rm --force --stop
.PHONY: clean

#
# Code Quality, Git, Linting
# ------------------------------------------------------------------------------------
hooks: ## Install git hooks from pre-commit-config
	pre-commit install
	pre-commit install --hook-type commit-msg
	pre-commit autoupdate
.PHONY: hooks

lint: lint-yaml lint-actions lint-md ## Lint all files in project
.PHONY: lint

lint-yaml: ## Lints yaml files inside project
	@$(YAML_LINT_RUNNER) | tee -a $(MAKE_LOGFILE)
.PHONY: lint-yaml

lint-actions: ## Lint all github actions
	@$(ACTION_LINT_RUNNER) | tee -a $(MAKE_LOGFILE)
.PHONY: lint-actions

lint-md: ## Lint all markdown files using markdownlint-cli2
	@$(MARKDOWN_LINT_RUNNER) --fix "**/*.md" "!CHANGELOG.md" | tee -a $(MAKE_LOGFILE)
.PHONY: lint-md

lint-md-dry: ## Lint all markdown files using markdownlint-cli2 in dry-run mode
	@$(MARKDOWN_LINT_RUNNER) "**/*.md" "!CHANGELOG.md" | tee -a $(MAKE_LOGFILE)
.PHONY: lint-md-dry

#
# Testing
# ------------------------------------------------------------------------------------
# dcgoss binary is used for testing
# README: https://github.com/aelsabbahy/goss/tree/master/extras/dcgoss
# macOS install: https://github.com/goss-org/goss/tree/master/extras/dgoss#mac-osx
#
test: ## Run self-tests using dcgoss
	dcgoss run router
.PHONY: test

#
# Release
# ------------------------------------------------------------------------------------
commit:
	czg commit --config="./.github/.cz.config.js"
.PHONY: commit
