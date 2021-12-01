#============================================#
#----------Setup, Exports, and Path----------#
#============================================#

export BASH_SILENCE_DEPRECATION_WARNING=1 # macos catalina uses zsh


if [[ -n $NVIM_LISTEN_ADDRESS ]]; then
	export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
elif [[ -x /usr/local/bin/nvim ]]; then
	export VISUAL="nvim"
	export EDITOR="nvim"
else
	export VISUAL='vim'
	export EDITOR="vim"
fi


export GIT_MERGE_AUTOEDIT='no'
export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin"
export PATH="$HOME/.asdf/shims:$PATH"
export PATH="$HOME/.asdf/bin:$PATH"
export ANDROID_SDK="$HOME/Library/Android/sdk"
export ANDROID_NDK="$HOME/Library/Android/ndk"
export PATH="$ANDROID_SDK/platform-tools:$PATH"


# http://docs.python-guide.org/en/latest/writing/gotchas/
export PYTHONDONTWRITEBYTECODE=1

# Makes man page reader vim instead of less
export MANPAGER='col -bx | nvim -c ":set ft=man nonu nolist" -c ":IndentLinesDisable" -R -'

# pspg for psql
# export PAGER="pspg -s 18 --force-uniborder --quit-if-one-screen"

# Weird icu4c/charlock_holmes issue
# https://stackoverflow.com/a/45873419
PATH="/usr/local/opt/icu4c-58/bin:$PATH"
PATH="/usr/local/opt/icu4c-58/sbin:$PATH"
GEM_PATH="~/development/gollum/"


[[ -s $HOME/.scm_breeze/scm_breeze.sh ]] &&
	source "$HOME/.scm_breeze/scm_breeze.sh"

[ -f ~/.fzf.bash ] &&
	source ~/.fzf.bash

[[ -f $(brew --prefix)/etc/bash_completion ]] &&
	source "$(brew --prefix)/etc/bash_completion"

[[ -f $HOME/.config/exercism/exercism_completion.bash ]] &&
	source "$HOME/.config/exercism/exercism_completion.bash"

[[ -f /usr/local/opt/asdf/asdf.sh ]] &&
	source /usr/local/opt/asdf/asdf.sh

[[ -f /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash ]] &&
	source /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash

[[ -f $HOME/.asdf/asdf.sh ]] &&
	source $HOME/.asdf/asdf.sh

[[ -f $HOME/.asdf/completions/asdf.bash ]] &&
	source $HOME/.asdf/completions/asdf.bash

# Elixir iex history
export ERL_AFLAGS="-kernel shell_history enabled"
export KERL_CONFIGURE_OPTIONS="--with-ssl=$(brew --prefix openssl@1.1)"

export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTTIMEFORMAT="%d/%m/%y %T "
# Avoid duplicates in hisotry
export HISTIGNORE='&:[ ]*'

export STARSHIP_CONFIG="$HOME/.starship.toml"
