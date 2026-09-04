#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_REPOSITORY="wcpines/dotfiles"

# Ask for the administrator password upfront.
sudo -v

# Keep the sudo credential valid until setup finishes.
while true; do
	sudo -n true || exit
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

install_homebrew() {
	if ! command -v brew >/dev/null 2>&1; then
		echo "Installing Homebrew"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	if [[ -x /opt/homebrew/bin/brew ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [[ -x /usr/local/bin/brew ]]; then
		eval "$(/usr/local/bin/brew shellenv)"
	else
		echo "Homebrew was not installed successfully." >&2
		exit 1
	fi
}

install_homebrew

if [[ "${SHELL:-}" != "/bin/bash" ]]; then
	chsh -s /bin/bash
fi

if [[ -d "$DOTFILES_DIR/.git" ]]; then
	echo "Updating existing dotfiles checkout"
	git -C "$DOTFILES_DIR" pull --ff-only
else
	if [[ -e "$DOTFILES_DIR" ]]; then
		echo "$DOTFILES_DIR exists but is not a Git checkout. Move it aside and run setup again." >&2
		exit 1
	fi

	echo "Sign in to GitHub to clone your private dotfiles repository."
	brew install gh
	gh auth status --hostname github.com >/dev/null 2>&1 || gh auth login --hostname github.com --git-protocol ssh --web
	gh repo clone "$DOTFILES_REPOSITORY" "$DOTFILES_DIR"
fi

echo "Linking dotfiles"
bash "$DOTFILES_DIR/init/symlink_script.sh"

echo "Installing apps and tools from Brewfile"
brew bundle --verbose --file="$DOTFILES_DIR/Brewfile"

echo "Preparing Rectangle configuration"
bash "$DOTFILES_DIR/init/prepare_rectangle_config.sh"

echo "Applying macOS defaults"
bash "$DOTFILES_DIR/init/macos"

echo "Installing Mise-managed tools, including Node and Pi"
mise trust "$DOTFILES_DIR/mise.toml"
mise install --yes

echo "Installing SCM Breeze"
if [[ ! -d "$HOME/.scm_breeze/.git" ]]; then
	git clone https://github.com/scmbreeze/scm_breeze.git "$HOME/.scm_breeze"
	"$HOME/.scm_breeze/install.sh"
fi

echo "Creating a Bash profile when needed"
if [[ ! -e "$HOME/.bash_profile" ]]; then
	printf '%s\n' '[[ -f ~/.bashrc ]] && source ~/.bashrc' >"$HOME/.bash_profile"
fi

echo "Enabling terminal italics and colors"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
cat >"$tmp" <<'EOF'
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

mkdir -p "$HOME/.config/nvim"
if [[ ! -f "$HOME/.config/nvim/init.vim" ]]; then
	printf '%s\n' 'source ~/.vimrc' >"$HOME/.config/nvim/init.vim"
fi

echo "Installing fzf key bindings without modifying shell configuration files"
"$(brew --prefix)/opt/fzf/install" --all --no-update-rc

echo "Manual steps remaining:
1) Sync cloud storage and 1Password
2) Install Vim plugins
3) Import app settings from cloud sync:
   - Alfred
   - Dash
   - iTerm2
4) Launch Rectangle and select Apply when it asks to apply the prepared configuration
5) Set up SSH keys if GitHub did not create one during login
6) Pull desired repositories"
echo "Restart your computer to apply all macOS settings."
echo "Done!"
