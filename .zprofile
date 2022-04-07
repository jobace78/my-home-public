# ~/.zprofile

# shellcheck disable=SC2123

if [ -d '/Applications/Parallels Desktop.app/Contents/MacOS' ]; then
  PATH="/Applications/Parallels Desktop.app/Contents/MacOS${PATH+:${PATH}}"
fi

if [ -d "${HOME:?}/.bin" ]; then
  PATH="${HOME:?}/.bin${PATH+:${PATH}}"
fi

if [ -d "${PYENV_ROOT:=${HOME:?}/.pyenv}/bin" ]; then
  PATH="${PYENV_ROOT}/bin${PATH+:${PATH}}"
fi

if [ "${commands[pyenv]}" ]; then
  eval "$(pyenv init --path)"
fi

if [ -d "${DOTNET_ROOT:=/opt/dotnet}" ]; then
  PATH="${DOTNET_ROOT}${PATH+:${PATH}}"
fi

if [ -d /opt/homebrew/bin ]; then
  PATH="/opt/homebrew/bin${PATH+:${PATH}}"
fi

if [ -d /opt/homebrew/sbin ]; then
  PATH="/opt/homebrew/sbin${PATH+:${PATH}}"
fi

if [ -d /opt/powershell ]; then
  PATH="/opt/powershell${PATH+:${PATH}}"
fi

if [ -d /usr/local/sbin ]; then
  PATH="/usr/local/sbin${PATH+:${PATH}}"
fi

export PATH

# include(s)

if [ -s "${HOME:?}"/.zprofile.inc ]; then
  . "${HOME:?}"/.zprofile.inc
fi
