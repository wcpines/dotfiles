# !/bin/bash

# WORK IN PROGRESS
# Goal: Easily set-up new mac, with few manual installs or configuration

# Borrowed heavily form @MikeMcQuaid's strap script and others:
# https://github.com/MikeMcQuaid/strap/blob/master/bin/strap.sh

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until setup has finished
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

RED='\033[1;31m'
NC='\033[0m' # No Color
GREEN='\033[1;32m'

print_header_line() {
	length=$1
	printf "==="
	for i in $(seq 0 $length); do printf %s "="; done
	printf "==="
}

print_script_step() {
	step="#---$1---#"
	print_header_line ${#step}
	echo
	echo "   $step"
	print_header_line ${#step}
	echo
}

log_line() {
	message=$1
	echo -e "--> $message"
}

check_status() {
	last_command_status=$?
	if [[ last_command_status -eq 0 ]]; then
		log_line "${GREEN}SUCCESS"
	else
		echo '!!!                  !!!'
		log_line "${RED}COMMAND FAILED${NC}"
		echo '!!!                  !!!'
		echo
		echo "Failing Command:"
		printf "$(fc -ln -1)"
	fi
}

# ENV_VARS_FILE=$HOME/env_vars.sh
# source $ENV_VARS_FILE
# 
# print_script_step "Naming your computer"
# 
# log_line "setting comp name"
# sudo scutil --set ComputerName "$COMPUTER_NAME"
# check_status
# 
# log_line "settng host name"
# sudo scutil --set HostName "$HOST_NAME"
# check_status
# 
# log_line "setting localhost name"
# sudo scutil --set LocalHostName "$HOST_NAME"
# check_status
# 
# print_script_step "Creating SSH keypair"
# log_line "using ssh-keygen"
# log_line "using address: $EMAIL_ADDRESS.  You can correct this later if needed."
# ssh-keygen -f "$HOME/.ssh/testkey" -t rsa -b 4096 -C "$EMAIL_ADDRESS"
# check_status
# 
# print_script_step "Setting up FileVault"
# status=$(fdesetup status)
# if [[ $status =~ On ]]; then
# 	log_line "Already enabled ✅"
# else
# 	log_line "FileVault not enabled. Enabling now..."
# 	sudo fdesetup enable -user "$USER" | tee $HOME/Desktop/"fv_recovery_key.txt"
# fi
# check_status
# 
# print_script_step "Setting up xcode cli tools"
# if type xcode-select >&- && xpath=$(xcode-select --print-path) &&
# 	[[ -d ${xpath} ]] && [[ -x ${xpath} ]]; then
# 	log_line "Already installed ✅"
# else
# 	cd
# 	# https://apple.stackexchange.com/a/195963
# 	touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
# 	PROD=$(softwareupdate -l |
# 		grep "\*.*Command Line" |
# 		head -n 1 | awk -F"*" '{print $2}' |
# 		sed -e 's/^ *//' |
# 		tr -d '\n')
# 	softwareupdate -i "$PROD" --verbose
# 	check_status
# fi
# 
# print_script_step "Retreiving your dotfiles from github"
# mkdir $HOME/$GITHUB_DOTFILES_REPO_NAME
# cd $HOME/$GITHUB_DOTFILES_REPO_NAME
# git init
# git pull https://$GITHUB_ACCESS_TOKEN@github.com/$GITHUB_USERNAME/$GITHUB_DOTFILES_REPO_NAME.git
# 
print_script_step "Running symlinker for your dotfiles"
eval $(grep "files=" ./init/symlink_script.sh)
log_line "grabbing $files"
cd
sh ~/dotfiles/init/symlink_script.sh
check_status

print_script_step "Installing Homebrew"

if [[ -z $(which brew) ]]; then
	log_line "curling https://raw.githubusercontent.com/Homebrew/install/master/install"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	log_line "Already installed ✅"
fi
check_status

# Update homebrew recipes
log_line "Updating homebrew..."
brew update
check_status

# Install mas-cli for mac app store apps
log_line "Installing mas-cli for purchased apps..."
brew install mas
check_status

# NOTE: This might be extraneous; new macs usually require you to sign in
# before this script would be run
mas signin $APPLE_ID "$APPLE_ID_PASSWORD"

log_line "installing apps and tools in Brewfile"
brew bundle -v --file=$HOME/dotfiles/Brewfile

log_line "configuring diff-so-fancy for global use"
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"

print_script_step "Setting OSX defaults"
log_line "this may take a moment"
sh ~/dotfiles/init/macos

check_status() print_script_step() "Adding asdf plugins"

asdf plugin-add erlang &&
	asdf plugin-add elixir &&
	asdf plugin-add postgres &&
	asdf plugin-add python &&
	asdf plugin-add ruby

asdf install
check_status
print_script_step "Setting neovim config"

gem install neovim
pip3 install neovim

log_line "creating config dir"
[[ -d $HOME/.config/nvim ]] || mkdir -p $HOME/.config/nvim
check_status

log_line "creating config file"
[[ -f $HOME/.config/nvim/init.vim ]] || touch ~/.config/nvim/init.vim
check_status

log_line "writing config"
echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" >>~/.config/nvim/init.vim
echo "let &packpath = &runtimepath" >>~/.config/nvim/init.vim
echo "source ~/.vimrc" >>~/.config/nvim/init.vim
check_status

print_script_step "Installing SCM_Breeze"
git clone git://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze
~/.scm_breeze/install.sh
source ~/.bashrc

print_script_step "Creating a .bash_profile"
log_line "This will source your bashrc/settings for each new shell session"
touch $HOME/.bash_profile
echo "[[ -f ~/.bashrc ]] && source ~/.bashrc" >$HOME/.bash_profile
check_status
log_line "bash profile says...
$(cat $HOME/.bash_profile)"

print_script_step "Enabling iterminal/iterm italics"

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

print_script_step "Getting solarized theme"

log_line "retrieving zip file"
wget -O $HOME/Downloads/solarized.zip "http://ethanschoonover.com/solarized/files/solarized.zip"
check_status

log_line "unzipping"
cd $HOME/Downloads
unzip $HOME/Downloads/solarized.zip
check_status
rm -f solarized.zip
cd

print_script_step "Adding git-open"
npm install --global git-open

print_script_step "installing python packages"
pip install glances matplotlib numpy pandas scikit-learn scipy

log_line " You should be all set.  Some likely manual steps remaining:
1) Dropbox and 1password sync
2) Install Vim plugins
4) Import iterm2, karibiner, dash, and alfred settings from dropbox
5) Add private key to github, and re-pull dotfiles
6) Pull desired repos
7) $(brew --prefix)/opt/fzf/install
8) Update solarized spellcheck (vim):
exe "hi! SpellBad"       .s:fmt_curl   .s:fg_red    .s:bg_base02    .s:sp_red

"
print_script_step "It's now recommended you restart your computer"
print_script_step "Done!🎆"
