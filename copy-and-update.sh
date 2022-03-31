#!/usr/bin/env bash

### BASH BASE [V2] BEGIN ###

if [ -n "${BASH_VERSINFO[*]}" ]; then
  if [ "${BASH_VERSINFO[0]}" -ge 4 ] && [ "${BASH_VERSINFO[1]}" -ge 4 ]; then
    :
  elif [ "${BASH_VERSINFO[0]}" -ge 5 ]; then
    :
  else
    exit 1
  fi
else
  exit 1
fi

if [ "${SCRIPT_DEBUG}" = 'true' ]; then
  echo 'Script debugging is enabled, allowing bash commands and their arguments to be printed as they are executed.'
  set -x
fi

# Notes:
#   - https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
#   - https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
#   - https://en.wikipedia.org/wiki/Umask
#
BASH_COMPAT=44
export BASH_COMPAT
set -e -o pipefail
shopt -s dotglob extglob
umask "${UMASK:-0007}"

### BASH BASE [V2] END ###

# _copy
# _help

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
