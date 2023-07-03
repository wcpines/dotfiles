# !/bin/bash


# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until setup has finished
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

chsh -s /bin/bash

ENV_VARS_FILE=$HOME/env_vars.sh
source $ENV_VARS_FILE

echo "Retreiving your dotfiles from github"

mkdir $HOME/dotfiles
cd $HOME/dotfiles
git init
git pull https://$GITHUB_ACCESS_TOKEN@github.com/wcpines/dotfiles.git

echo "Running symlinker for your dotfiles"

eval $(grep "files=" ./init/symlink_script.sh)
echo "grabbing $files"

cd
sh $HOME/dotfiles/init/symlink_script.sh

echo "Installing Homebrew"

if [[ -z $(which brew) ]]; then
	echo "curling https://raw.githubusercontent.com/Homebrew/install/master/install"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "Already installed ✅"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

echo "installing apps and tools in Brewfile"
brew bundle -v --file= $HOME/dotfiles/Brewfile

echo "Setting OSX defaults"
echo "This may take a moment"

sh $HOME/dotfiles/init/macos

echo "Adding asdf plugins"

asdf plugin-add erlang &&
	asdf plugin-add elixir &&
	asdf plugin-add postgres &&
	asdf plugin-add python &&
	asdf plugin-add nodejs &&
	asdf plugin-add yarn &&
	asdf install


echo "Installing SCM_Breeze"

git clone https://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze
~/.scm_breeze/install.sh
source ~/.bashrc


echo "Creating a .bash_profile"
echo "This will source your bashrc/settings for each new shell session"

touch $HOME/.bash_profile
echo "[[ -f ~/.bashrc ]] && source ~/.bashrc" >$HOME/.bash_profile

echo "Bash profile says...
$(cat $HOME/.bash_profile)"

echo "Enabling terminal/iterm italics & colors"

TERMINFO=$HOME/.terminfo
rm -rf "$TERMINFO"

tmp=$(mktemp)

cat >"$tmp" <<EOF
xterm-256color|xterm with 256 colors and italic,
    kbs=\177,
    sitm=\E[3m, ritm=\E[23m,
    use=xterm-256color,
tmux-256color|tmux with 256 colors and italic,
    kbs=\177,
    sitm=\E[3m, ritm=\E[23m,
    smso=\E[7m, rmso=\E[27m,
    use=screen-256color,
EOF

tic -x "$tmp"

echo "Getting solarized theme"

echo "retrieving zip file"
wget -O $HOME/Downloads/solarized.zip "http://ethanschoonover.com/solarized/files/solarized.zip"

echo "unzipping"
cd $HOME/Downloads
unzip $HOME/Downloads/solarized.zip
rm -f solarized.zip
cd

echo "Adding git-open"
npm install --global git-open

echo "Installing neovim extras"

gem install neovim
pip3 install neovim
npm install neovim

echo "updating neovim config file"
[[ -f $HOME/.config/nvim/init.vim ]] || touch $HOME/.config/nvim/init.vim

echo "writing config"
echo "source ~/.vimrc" >> $HOME/.config/nvim/init.vim

echo "installing fzf shortcuts"
$(brew --prefix)/opt/fzf/install


echo "Manual steps remaining:
1) Cloud storage and 1password sync
2) Install Vim plugins
4) Import program settings from cloud sync
	- alfred
	- btt
	- dash
	- karibiner
  - iterm2
5) Set SSH keys
6) Pull desired repos
7) Edit solarized spellcheck colors:
  exe "hi! SpellBad"       .s:fmt_curl   .s:fg_red    .s:bg_base02    .s:sp_red
"
echo "It's now recommended you restart your computer"
echo "Done!🎆"
