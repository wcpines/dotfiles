# !/bin/bash

# WORK IN PROGRESS
# Goal: Easily set-up new mac, little manual installs and (re-)config

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until setup has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

COMPUTER_NAME="colby"
MY_EMAIL="wcpines@gmail.com"

# Name computer
echo "Naming comp"

sudo scutil --set ComputerName "$COMPUTER_NAME"
sudo scutil --set HostName "$COMPUTER_NAME"
sudo scutil --set LocalHostName "$COMPUTER_NAME"

# Create SSH keypair
# echo "creating your SSH keys"
# ssh-keygen -f "$HOME/.ssh/id_rsa" -t rsa -b 4096 -C "$MY_EMAIL"

# move to home dir
cd

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

# Install Homebrew bundler to use Brewfile
echo "Adding Brew Bundler..."
brew tap Homebrew/bundle

# Install mas-cli for mac app store apps
echo "Install mas-cli..."
brew install mas

# Sign into the app store
printf "Sign into the Mac App Store\n\n ===>"
mas signin wcpines@gmail.com

# run symlink script
echo "Running symlinker!"
sh ~/dotfiles/symlink_script.sh

# install apps and tools in Brewfile
brew bundle

# create nvim config
# https://neovim.io/doc/user/nvim.html#nvim-from-vim
[[ -d ~/.config/nvim/ ]] || mkdir ~/.config/nvim
[[ -f ~/.config/nvim/init.vim ]] || touch ~/.config/nvim/init.vim
echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" >> ~/.config/nvim/init.vim
echo "let &packpath = &runtimepath" >> ~/.config/nvim/init.vim
echo "source ~/.vimrc" >> ~/.config/nvim/init.vim

# Setting OSX defaults
sh ~/dotfiles/macos

# download solarized
wget -O $HOME/Downloads/solarized.zip "http://ethanschoonover.com/solarized/files/solarized.zip"

# Final setup message:

echo "
You should be all set.  Manual steps remaining:
1) Dropbox and 1password sync
2) Change battery% display and dark theme 
3) Setup terminal colors
4) Install vim plugins
"
