# Use $HOME/dotfiles/bashrc.d

export PATH=/opt/homebrew/bin:$PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

eval "$(starship init bash)"

for file in ${HOME}/dotfiles/bashrc.d/*.sh; do
	source $file
done

if [[ -f ~/.env.sh ]]; then
	set -a
	source ~/.env.sh
	set +a
fi



eval "$(direnv hook bash)"
