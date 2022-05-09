# Basic python project setup

This project assumes using Unix-like operating system with Python, git and GNU Make installed. It assumes using
Python 3.8 version, this can be changed by setting the `PYTHON` variable in Makefile to something else. To setup
a project, copy all the files to desired directory and run `make dev`.

It assumes the following dev environment:

- [Makefile] is used for automation of the dev workflow. The `make` command runs all the code checks.
- Git is used for version control, if it is not initialized, `make dev` will run `git init`.
- [Python's venv] + pip manage the [virtual environments] and dependencies.
  The environment can be loaded using the `. scripts/shell.sh` command.
- The .env file holds [environment variables], and is loaded using [python-dotenv].
- [pre-commit] runs [pre-commit-hooks] for validating each commit.
- [pytest] is used for running the unit tests. It is set up to fail fast and run the previously failed tests first.
  [pytest-cov] generates the test coverage report.
- The code is auto-formatted using [black] and [isort].
- [flake8] is used as code linter, but it ignores the stylistic issues that are fixed by Black.
- [mypy] is used for static code analysis and type checking.
- Each of the steps is configured to *fail fast* in case of any error.


 [Python's venv]: https://docs.python.org/3/library/venv.html
 [virtual environments]: https://realpython.com/python-virtual-environments-a-primer/
 [environment variables]: https://twolodzko.github.io/env
 [python-dotenv]: https://pypi.org/project/python-dotenv/
 [Makefile]: https://twolodzko.github.io/makefiles.html
 [pre-commit]: https://pre-commit.com/
 [pre-commit-hooks]: https://github.com/pre-commit/pre-commit-hooks
 [pytest]: https://realpython.com/pytest-python-testing/
 [pytest-cov]: https://pypi.org/project/pytest-cov/
 [black]: https://black.readthedocs.io/en/stable/
 [isort]: https://pycqa.github.io/isort/
 [flake8]: https://flake8.pycqa.org/en/latest/
 [mypy]: http://mypy-lang.org/
