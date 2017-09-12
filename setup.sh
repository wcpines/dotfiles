# WORK IN PROGRESS
# Goal: Easily set-up new mac, little manual installs and (re-)config

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

echo "Adding Brew Bundler..."
brew tap Homebrew/bundle

# mas-cli for mac app store apps

echo "Install mas-cli..."
brew install mas

# run symlink script
sh symlink_script.sh

# install Brewfile
brew bundle

# create nvim config:
# https://neovim.io/doc/user/nvim.html#nvim-from-vim
# To start the transition, create ~/.config/nvim/init.vim with these contents:

#     set runtimepath^=~/.vim runtimepath+=~/.vim/after
#     let &packpath = &runtimepath
#     source ~/.vimrc

# ^ plugins should automatically install

# download solarized
wget -O $HOME/Downloads/solarized.zip "http://ethanschoonover.com/solarized/files/solarized.zip"

# gitconfig?
# add SSH keys to github!
