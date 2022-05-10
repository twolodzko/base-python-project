
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
allchecks: stylecheck lint typecheck test ## Run all the code checks

.PHONY: dev
dev: .venv/bin/% .git/hooks/pre-commit ## Setup dev environment

.PHONY: update
update: dependencies ## Update the dependencies and pre-commit
	$(RUN) pre-commit autoupdate

.PHONY: dependencies
dependencies: .venv ## Install or update the dependencies
	$(INVENV) pip install -U pip
	$(INVENV) pip install -U -r requirements-dev.txt
	$(INVENV) pip install -U -r requirements.txt

.PHONY: test
test: .venv/bin/pytest ## Run tests
	$(RUN) pytest -x --ff -v --color=yes --doctest-modules --durations=20 --cov=$(CODEDIR) $(CODEDIR)

.PHONY: coverage
coverage: .venv/bin/pytest ## Prepare code test coverage report
	$(RUN) pytest -v --color=yes --doctest-modules --cov-report html --cov=$(CODEDIR) $(CODEDIR)

.PHONY: lint
lint: .venv/bin/flake8 ## Run linter
	$(RUN) flake8 --config setup.cfg $(CODEDIR)

.PHONY: stylecheck
stylecheck: .venv/bin/isort .venv/bin/black ## Run style checks
	$(RUN) isort --settings-path pyproject.toml --check $(CODEDIR)
	$(RUN) black --config pyproject.toml --check $(CODEDIR)

.PHONY: stylefix
stylefix: .venv/bin/isort .venv/bin/black ## Autoformat the code
	$(RUN) isort --settings-path pyproject.toml $(CODEDIR)
	$(RUN) black --config pyproject.toml $(CODEDIR)

.PHONY: typecheck
typecheck: .venv/bin/mypy ## Check types in the code
	$(RUN) mypy --config-file pyproject.toml $(CODEDIR)

.venv/bin/%: .venv dependencies

.venv:
	@ printf "Using %s (%s) to setup the virtual environment\n" "$(shell $(PYTHON) --version)" "$(shell which $(PYTHON))"
	$(PYTHON) -m venv $(VENV) --prompt $(ENVNAME)

.git:
	git init

.git/hooks/pre-commit: .git .venv/bin/pre-commit
	$(RUN) pre-commit install

.PHONY: precommit
precommit: .venv/bin/pre-commit ## Run pre-commit for all the files
	$(RUN) pre-commit run --all-files

.PHONY: clean
clean: ## Clean after the tests
	rm -rfv ./tmp*
	rm -rfv ./.mypy_cache
	rm -rfv ./.pytest_cache
	rm -rfv ./.coverage*

.PHONY: help
help: ## Print help
	@ grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
