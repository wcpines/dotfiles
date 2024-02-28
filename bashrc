# Use $HOME/dotfiles/bashrc.d

export PATH=/opt/homebrew/bin:$PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

eval "$(starship init bash)"

for file in ${HOME}/dotfiles/bashrc.d/*.sh; do
	source $file
done

if [[ -f ~/.env ]]; then
	set -a
	source ~/.env
	set +a
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

[ -s "/Users/colby/.scm_breeze/scm_breeze.sh" ] && source "/Users/colby/.scm_breeze/scm_breeze.sh"


eval "$(direnv hook bash)"
