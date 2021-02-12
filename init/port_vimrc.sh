cd $HOME

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	apt update && apt -y install vim-gtk
elif [[ "$OSTYPE" == "darwin"* ]]; then
	if [[ -z $(which brew) ]]; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	brew install vim
fi

curl "https://raw.githubusercontent.com/wcpines/dotfiles/master/vimrc.d/portable_vimrc.vim" >$HOME/.vimrc
