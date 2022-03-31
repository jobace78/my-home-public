# ~/.zshrc

# alias

alias clear='clear && printf "\e[3J"'
alias df='df -P -h'
alias grep='grep --color=auto'
alias history='fc -E -l 1'
alias la='ls -A -G'
alias ll='ls -G -h -l'
alias ls='ls -G'

# completion

for d in \
"$(brew --prefix 2> /dev/null)"/share/zsh/site-functions \
"${HOME:?}"/.local/share/zsh/site-functions; do
  if [ -d "${d}" ]; then
    fpath+=("${d}")
  fi
done

autoload -U +X compinit && \
compinit

# FIXME BEGIN

autoload -U +X bashcompinit && \
bashcompinit

# FIXME END

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' special-dirs true

# configuration

AWS_CONFIG_FILE="${HOME:?}"/Desktop/aws_config_file.txt
BAT_PAGER=''
CPPFLAGS='-I/usr/local/opt/openssl/include -I/usr/local/opt/sqlite/include'
DOTNET_ROOT=/opt/dotnet
HISTCONTROL=ignoreboth
HISTFILE="${HOME:?}"/.zsh_history
HISTSIZE=5000
KUBECONFIG="${HOME:?}"/Desktop/kubeconfig.yaml
LDFLAGS='-L/usr/local/opt/openssl/lib -L/usr/local/opt/sqlite/lib'
NVM_DIR="${HOME:?}"/.nvm
PIP_REQUIRE_VIRTUALENV=Y
PKG_CONFIG_PATH='/usr/local/opt/openssl/lib/pkgconfig /usr/local/opt/sqlite/lib/pkgconfig'
SAVEHIST=5000
SDKMAN_DIR="${HOME:?}"/.sdkman

export AWS_CONFIG_FILE BAT_PAGER CPPFLAGS DOTNET_ROOT HISTCONTROL HISTFILE HISTSIZE KUBECONFIG LDFLAGS NVM_DIR PIP_REQUIRE_VIRTUALENV PKG_CONFIG_PATH PYENV_ROOT SAVEHIST SDKMAN_DIR

setopt extended_history hist_expire_dups_first hist_ignore_dups inc_append_history interactive_comments noautomenu nullglob promptsubst shwordsplit

# prompt

function _update_ps1() {
  if [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh ]; then
    GIT_PS1_SHOWCOLORHINTS=Y
    GIT_PS1_SHOWDIRTYSTATE=Y
    GIT_PS1_SHOWSTASHSTATE=Y
    GIT_PS1_SHOWUNTRACKEDFILES=Y
    GIT_PS1_SHOWUPSTREAM=verbose
    . /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
    PS1='%n %~ $(__git_ps1 "(%s) ")%# '
  else
    PS1='%n %~ %# '
  fi
}

function _install_update_ps1() {
  for i in "${precmd_functions[@]}"; do
    if [ "${i}" = "_update_ps1" ]; then
      return
    fi
  done
  precmd_functions+=(_update_ps1)
}

if [ -d "${HOME:?}"/.powerlevel10k ]; then
  . "${HOME:?}"/.powerlevel10k/powerlevel10k.zsh-theme
  . "${HOME:?}"/.powerlevel10k/config/p10k-lean.zsh
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH='100%'
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=25
  typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=('*pre*' PRE '*pro*' PRO '*' DEFAULT)
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=003
  typeset -g POWERLEVEL9K_KUBECONTEXT_PRE_FOREGROUND=002
  typeset -g POWERLEVEL9K_KUBECONTEXT_PRO_FOREGROUND=001
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv terraform kubecontext dir vcs newline prompt_char)
  typeset -g POWERLEVEL9K_MODE=powerline
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%244F╭─ '
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%244F╰─ '
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX='%244F├─ '
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$'\ue0a0 '
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER}'
  unset POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND
else
  if [ "${TERM}" != "linux" ]; then
    _install_update_ps1
  fi
fi

if [ -s "${NVM_DIR}"/nvm.sh ]; then
  . "${NVM_DIR}"/nvm.sh
fi

if [ "${commands[pyenv]}" ]; then
  eval "$(pyenv init -)"
fi

if [ -s "${SDKMAN_DIR}"/bin/sdkman-init.sh ]; then
  . "${SDKMAN_DIR}"/bin/sdkman-init.sh
fi
