
SHELL := bash
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.SHELLFLAGS := -eu -o pipefail -c

PYTHON := python3.8
CODEDIR := .
VENV := .venv
INVENV := source $(VENV)/bin/activate &&
RUN := $(INVENV) dotenv run --
ENVNAME := `basename $(PWD)`

.PHONY: allchecks
allchecks: stylecheck lint typecheck test ## Run all code checks

.PHONY: dev
dev: .venv dependencies .git/hooks/pre-commit ## Setup dev environment

.PHONY: test
test: ## Run tests
	$(RUN) pytest -x --ff -v --color=yes --doctest-modules --durations=20 --cov=$(CODEDIR) --ignore=$(OPTIMDIR) $(CODEDIR)

.PHONY: coverage
coverage: ## Prepare code test coverage report
	$(RUN) pytest -v --color=yes --doctest-modules --cov-report html --cov=$(CODEDIR) $(CODEDIR)

.PHONY: lint
lint: ## Run linter
	$(RUN) flake8 --config setup.cfg $(CODEDIR)

.PHONY: stylecheck
stylecheck: ## Run style checks
	$(RUN) isort --settings-path pyproject.toml --check $(CODEDIR)
	$(RUN) black --config pyproject.toml --check $(CODEDIR)

.PHONY: stylefix
stylefix: ## Autoformat the code
	$(RUN) isort --settings-path pyproject.toml $(CODEDIR)
	$(RUN) black --config pyproject.toml $(CODEDIR)

.PHONY: typecheck
typecheck: ## Check types in the code
	$(RUN) mypy --config-file pyproject.toml $(CODEDIR)

.PHONY: dependencies
dependencies: ## Install python dependencies
	$(INVENV) pip install --upgrade pip
	$(INVENV) pip install -r requirements-dev.txt
	$(INVENV) pip install -r requirements.txt

.venv: ## Setup venv virtual environment
	@ printf "Using %s (%s) to setup virtual environment\n" "$(shell $(PYTHON) --version)" "$(shell which $(PYTHON))"
	$(PYTHON) -m venv $(VENV) --prompt $(ENVNAME)

.git: ## Init git
	git init

.git/hooks/pre-commit: .git ## Install pre-commit hooks
	pre-commit install

.PHONY: clean
clean: ## Clean after tests
	rm -rfv ./tmp*
	rm -rfv ./.mypy_cache ./python/.mypy_cache
	rm -rfv ./.pytest_cache ./python/.pytest_cache
	rm -rfv ./.coverage*

.PHONY: help
help: ## Print help
	@ grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'