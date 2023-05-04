-include .env

ifeq ($(COMPOSE_PROJECT_NAME),)
	COMPOSE_PROJECT_NAME=ss
endif

export DOCKER_BUILDKIT ?= 1
export COMPOSE_PROJECT_NAME_SLUG = $(subst $e.,-,$(COMPOSE_PROJECT_NAME))
export COMPOSE_PROJECT_NAME_SAFE = $(subst $e.,_,$(COMPOSE_PROJECT_NAME))

DOCKER ?= docker
DOCKER_COMPOSE ?= docker compose -p $(COMPOSE_PROJECT_NAME_SAFE)
BUILDER_IMAGE ?= wayofdev/build-deps:alpine-latest

EXPORT_VARS = '\
	$${SHARED_DOMAIN_SEGMENT} \
	$${COMPOSE_PROJECT_NAME_SLUG} \
	$${COMPOSE_PROJECT_NAME_SAFE}'

.EXPORT_ALL_VARIABLES:

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
MAKE_LOGFILE = /tmp/docker-shared-services.log
MAKE_CMD_COLOR := $(BLUE)

default: all

help:
	@echo 'Management commands for package:'
	@echo 'Usage:'
	@echo '    ${MAKE_CMD_COLOR}make${RST}                       Creates containers, spins up project'
	@grep -E '^[a-zA-Z_0-9%-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "    ${MAKE_CMD_COLOR}make %-21s${RST} %s\n", $$1, $$2}'
	@echo
	@echo '    📑 Logs are stored in      $(MAKE_LOGFILE)'
	@echo
	@echo '    📦 Package                 docker-shared-services (github.com/wayofdev/docker-shared-services)'
	@echo '    🤠 Author                  Andrij Orlenko (github.com/lotyp)'
	@echo '    🏢 ${YELLOW}Org                     wayofdev (github.com/wayofdev)${RST}'
.PHONY: help

all: hooks env up
PHONY: all


# System Actions
# ------------------------------------------------------------------------------------
override-create: ## Generate override file from dist
	cp -v docker-compose.override.yaml.dist docker-compose.override.yaml
.PHONY: override-create

env: ## Generate .env file from example
	cp -f .env.example .env
.PHONY: env

cert-install: ## Run mkcert to install CA into system storage and generate default certs for traefik
	mkcert -install
	bash mkcert.sh
.PHONY: cert-install


# Docker and Docker compose Actions
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

restart: ## Restart all containers, running in this project
	$(DOCKER_COMPOSE) restart
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


# Testing
# ------------------------------------------------------------------------------------
# dcgoss binary is used for testing — https://github.com/aelsabbahy/goss/tree/master/extras/dcgoss
test: ## Run self-tests using dcgoss
	dcgoss run router
.PHONY: test


# Git Actions
# ------------------------------------------------------------------------------------
hooks: ## Install git hooks from pre-commit-config
	pre-commit install
	pre-commit autoupdate
.PHONY: hooks


# Yaml Actions
# ------------------------------------------------------------------------------------
lint: ## Lints yaml files inside project
	yamllint .
.PHONY: lint
