# To load virtual environment run:
#
# . scripts/shell.sh

VENV='.venv'
printf "Loading virtual enviroment %s\n" "$VENV"

. "$VENV/bin/activate"
. scripts/load_env.sh
