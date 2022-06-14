#!/usr/bin/env bash

# shellcheck source=.bin/bash44.conf
. "$(dirname "${0}")"/.bin/bash44.conf || exit 1
# shellcheck source=.bin/functions.conf
. "$(dirname "${0}")"/.bin/functions.conf

_copy() {
  # directories (init)
  #
  find . -not -path "*.git*" -type d | sort | xargs -I {} -n 1 mkdir -m 0755 -p "${HOME:?}"/{}
  # directories
  #
  find .bin -not -path "*.git*" -type f | sort | xargs -I {} -n 1 cp -f -p -v {} "${HOME:?}"/{}
  find .local -not -path "*.git*" -type f | sort | xargs -I {} -n 1 cp -f -p -v {} "${HOME:?}"/{}
  find .ssh -not -path "*.git*" -type f | sort | xargs -I {} -n 1 cp -f -p -v {} "${HOME:?}"/{}
  # files
  #
  find . \
  -maxdepth 1 \
  -not -path "*.iml" \
  -not -path "./.editorconfig" \
  -not -path "./.git" \
  -not -path "./.gitignore" \
  -not -path "./LICENSE" \
  -not -path "./README.md" \
  -not -path "./copy-and-update.sh" \
  -type f \
  | sort | xargs -I {} -n 1 cp -f -p -v {} "${HOME:?}"
}

_help() {
  # INFO : local variables
  local exit_code
  exit_code="${1:-1}"
  cat << EOT

  Usage: $(basename "${0}")

  Help options:
    -H Show this help message
    -U Display brief usage
    -V Print version

EOT
  exit "${exit_code}"
}

trap '_catch_all ${?}' ERR SIGHUP SIGINT SIGQUIT SIGTERM

cd "$(dirname "${0}")" || exit 1

OPTIND=1
while getopts 'HUV' ARGS; do
  case "${ARGS}" in
    H|U)
      _help 0
      ;;
    V)
      _exit 0 'v3'
      ;;
    ?)
      _help 1
      ;;
  esac
done
shift $(( OPTIND - 1 ))

_copy

if [ -x "${HOME:?}"/.bin/update ]; then
  "${HOME:?}"/.bin/update
else
  echo "'${HOME:?}/.bin/update' was NOT found, continuing."
fi
