# To load environment variables from the .env file run:
#
# . load_env.sh [PATH]

if [[ $# -gt 0 ]]; then
    ENVFILE="$1"
else
    ENVFILE="$(pwd)/.env"
fi

printf "Loading environment variables from the %s file:\n" "$ENVFILE"

while read -r line; do
    # ignore comments
    comment='\s*#.*'
    if [[ ! $line =~ $comment ]] ; then
        # make sure to expand the variables rather than providing them as strings
        variable="$(eval echo "$line")"
        echo "$variable"

        # shellcheck disable=SC2163,SC2086
        export "$variable"
    fi
done < "$ENVFILE"
