#!/bin/sh

# To load virtual environment run:
#
# . scripts/shell.sh

VENV='.venv'
printf "Loading virtual enviroment %s\n" "$VENV"

# shellcheck disable=SC1091
. $VENV/bin/activate
# shellcheck disable=SC1091
. scripts/load_env.sh
