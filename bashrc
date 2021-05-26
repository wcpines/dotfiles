# Use $HOME/dotfiles/bashrc.d

for file in ${HOME}/dotfiles/bashrc.d/*.sh; do
	source $file
done

if [[ -f ~/.env ]]; then
	set -a
	source ~/.env
	set +a
fi

eval "$(starship init bash)"
