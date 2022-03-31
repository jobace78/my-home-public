# ~/.zprofile

# /Applications

if [ -d '/Applications/Parallels Desktop.app/Contents/MacOS' ]; then
  PATH="/Applications/Parallels Desktop.app/Contents/MacOS${PATH+:${PATH}}"
fi

# /Users

if [ -d "${HOME:?}/.bin" ]; then
  PATH="${HOME:?}/.bin${PATH+:${PATH}}"
fi

PYENV_ROOT="${HOME:?}"/.pyenv

if [ -d "${PYENV_ROOT}/bin" ]; then
  PATH="${PYENV_ROOT}/bin${PATH+:${PATH}}"
fi

if [ "${commands[pyenv]}" ]; then
  eval "$(pyenv init --path)"
fi

# /opt

if [ -d /opt/dotnet ]; then
  PATH="/opt/dotnet${PATH+:${PATH}}"
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

# /usr

if [ -d /usr/local/sbin ]; then
  PATH="/usr/local/sbin${PATH+:${PATH}}"
fi

export PATH
