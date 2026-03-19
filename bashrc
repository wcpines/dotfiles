# Use $HOME/dotfiles/bashrc.d

export PATH=/opt/homebrew/bin:$PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Exit early for non-interactive shells (e.g. Claude Code, scripts)
[[ $- == *i* ]] || return

eval "$(starship init bash)"
trap '' SIGINT  # Prevent Ctrl-C from killing the shell at the prompt

for file in ${HOME}/dotfiles/bashrc.d/*.sh; do
	source $file
done

if [[ -f ~/.env.sh ]]; then
	set -a
	source ~/.env.sh
	set +a
fi



eval "$(direnv hook bash)"
