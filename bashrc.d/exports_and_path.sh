#============================================#
#----------Setup, Exports, and Path----------#
#============================================#


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[[ -s $HOME/.scm_breeze/scm_breeze.sh ]] &&
  source "$HOME/.scm_breeze/scm_breeze.sh"

[[ -r ~/.fzf.bash ]] &&
  source ~/.fzf.bash

[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] &&
  source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

# asdf — disabled in favor of mise (kept commented so it's easy to revert)
# [[ -r $HOMEBREW_PREFIX/opt/asdf/asdf.sh ]] &&
#   source $HOMEBREW_PREFIX/opt/asdf/asdf.sh
# [[ -r $HOME/.asdf/completions/asdf.bash ]] &&
#   source $HOME/.asdf/completions/asdf.bash

# mise — drop-in replacement for asdf; reads .tool-versions natively
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

if [[ -n $NVIM_LISTEN_ADDRESS ]]; then
  export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
elif [[ -x $(which nvim) ]]; then
  export VISUAL="nvim"
  export EDITOR="nvim"
else
  export VISUAL='vim'
  export EDITOR="vim"
fi


export BASH_SILENCE_DEPRECATION_WARNING=1 # macos catalina uses zsh

export STARSHIP_CONFIG="$HOME/.starship.toml"

export GIT_MERGE_AUTOEDIT='no'
export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin"

# export PATH="$HOME/.asdf/shims:$PATH"  # disabled: mise activate handles shims
export PATH="/Users/cpines/.okta/bin:$PATH"
export PATH="/Users/cpines/.okta/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
PATH="/opt/homebrew/opt/curl/bin:$PATH"


# Makes man page reader vim instead of less
export MANPAGER='col -bx | nvim -c ":set ft=man nonu nolist" -c ":IndentLinesDisable" -R -'

# Elixir iex history
export ERL_AFLAGS="-kernel shell_history enabled"

export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTTIMEFORMAT="%d/%m/%y %T "

# Avoid duplicates in hisotry
export HISTIGNORE='&:[ ]*'

export ERLANG_OPENSSL_PATH="/usr/bin/openssl"

# Enable colored ls output
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

export BAT_THEME_DARK='Solarized (dark)'
export BAT_THEME_LIGHT='Solarized (light)'

