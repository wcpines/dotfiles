# Use $HOME/dotfiles/bashrc.d

export PATH=/opt/homebrew/bin:$PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

if [[ -f ~/.env.sh ]]; then
	set -a
	source ~/.env.sh
	set +a
fi

for file in ${HOME}/dotfiles/bashrc.d/*.sh; do
	source $file
done

# Exit early for non-interactive shells (e.g. Claude Code, scripts)
[[ $- == *i* ]] || return

eval "$(starship init bash)"
trap '' SIGINT  # Prevent Ctrl-C from killing the shell at the prompt

eval "$(direnv hook bash)"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init bash)"; fi
