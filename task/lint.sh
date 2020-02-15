#!/bin/bash
set -uo pipefail
set +e

FAILURE=false

echo "pipenv check"
pipenv check  # Not reporting failure here, because sometimes this fails due to API request limit

echo "pylint"
pipenv run pylint src training || FAILURE=true

echo "pycodestyle"
pipenv run pycodestyle src training || FAILURE=true

# echo "pydocstyle"
# pipenv run pydocstyle pandagrader projects lambda_deployment || FAILURE=true

echo "mypy"
pipenv run mypy src training || FAILURE=true

echo "bandit"
pipenv run bandit -ll -r {src,training} || FAILURE=true

echo "shellcheck"
shellcheck tasks/*.sh || FAILURE=true

if [ "$FAILURE" = true ]; then
  echo "Linting failed"
  exit 1
fi
echo "Linting passed"
exit 0
