#============================================#
#----------Setup, Exports, and Path----------#
#============================================#

[[ -s $HOME/.scm_breeze/scm_breeze.sh ]] &&
	source "$HOME/.scm_breeze/scm_breeze.sh"

[[ -f ~/.fzf.bash ]] &&
	source ~/.fzf.bash

[[ -f $HOMEBREW_PREFIX/etc/bash_completion ]] &&
	source $HOMEBREW_PREFIX/etc/bash_completion

[[ -f $HOMEBREW_PREFIX/opt/asdf/asdf.sh ]] &&
	source $HOMEBREW_PREFIX/opt/asdf/asdf.sh

[[ -f $HOME/.asdf/completions/asdf.bash ]] &&
	source $HOME/.asdf/completions/asdf.bash

if [[ -n $NVIM_LISTEN_ADDRESS ]]; then
	export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
elif [[ -x /opt/homebrew/bin//nvim ]]; then
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
export PATH="$HOME/.asdf/shims:$PATH"
export PATH="/Users/cpines/.okta/bin:$PATH"
export PATH="/Users/cpines/.okta/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

# Makes man page reader vim instead of less
export MANPAGER='col -bx | nvim -c ":set ft=man nonu nolist" -c ":IndentLinesDisable" -R -'

# Elixir iex history
export ERL_AFLAGS="-kernel shell_history enabled"
# export KERL_CONFIGURE_OPTIONS="--with-ssl=$(brew --prefix openssl@1.1)"

export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTTIMEFORMAT="%d/%m/%y %T "

# Avoid duplicates in hisotry
export HISTIGNORE='&:[ ]*'

export ERLANG_OPENSSL_PATH="/usr/bin/openssl"
