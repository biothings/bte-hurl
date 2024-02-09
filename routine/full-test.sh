#!/usr/bin/env bash

# ensure script executes from script dir
cwd=$PWD
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# grab arguments
POSITIONAL_ARGS=()
RUN_ENV="local"

while [[ $# -gt 0 ]]; do
  case $1 in
    --local|--dev|--ci|--test|--prod) # give hurl a variable file
      RUN_ENV="${1:2}" # 1 refers to the variable $1
      shift
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

if [ "${POSITIONAL_ARGS[0]}" == "quick" ]; then
  hurl --variables-file="../env/$RUN_ENV" --test $(find . -name "*.hurl" ! -name '*creative*.hurl')
else
  hurl --variables-file="../env/$RUN_ENV" --test $(find . -name "*.hurl")
fi

# return to executor cwd
cd $cwd
