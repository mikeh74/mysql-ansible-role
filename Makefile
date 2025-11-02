.PHONY: help install lint test clean

help: ## Show this help message
	@echo 'Usage: make [target] ...'
	@echo ''
	@echo 'Targets:'
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install development dependencies
	pip install -r requirements.txt
	ansible-galaxy collection install community.mysql

lint: ## Run linting tools
	yamllint .
	ansible-lint

test: ## Run molecule tests
	molecule test

converge: ## Run molecule converge
	molecule converge

verify: ## Run molecule verify
	molecule verify

destroy: ## Destroy molecule instances
	molecule destroy

clean: ## Clean up molecule temporary files
	molecule reset

deps: ## Show dependency tree
	pip show molecule molecule-plugins ansible-core

check-docker: ## Check if Docker is running
	@docker version >/dev/null 2>&1 && echo "✅ Docker is running" || echo "❌ Docker is not running - please start Docker"