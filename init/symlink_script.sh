#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

set -euo pipefail

########## Variables

dir="$HOME/dotfiles"
olddir="$HOME/dotfiles_old"
files="bashrc vimrc ctags gitignore iex.exs psqlrc starship.toml ideavimrc"
config_dirs="ghostty"
config_files="mise.toml"
backup_timestamp="$(date +%Y%m%d%H%M%S)"

##########

backup_path_for() {
	local dest="$1"
	local name
	name="$(basename "$dest")"
	echo "$olddir/$name.$backup_timestamp"
}

symlink_if_needed() {
	local source="$1"
	local dest="$2"
	local backup_path

	if [[ -L "$dest" && "$(readlink "$dest")" == "$source" ]]; then
		echo "Already linked: $dest -> $source"
		return
	fi

	if [[ -e "$dest" || -L "$dest" ]]; then
		backup_path="$(backup_path_for "$dest")"
		echo "Moving existing $dest to $backup_path"
		mv "$dest" "$backup_path"
	fi

	echo "Creating symlink: $dest -> $source"
	ln -s "$source" "$dest"
}

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p "$olddir"
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd "$dir"
echo "...done"

# create symlinks for dotfiles that live directly in ~
for file in $files; do
	symlink_if_needed "$dir/$file" "$HOME/.$file"
done

# Symlink app configs that live under ~/.config instead of directly in ~.
mkdir -p "$HOME/.config"
for config_dir in $config_dirs; do
	symlink_if_needed "$dir/$config_dir" "$HOME/.config/$config_dir"
done

for config_file in $config_files; do
	mkdir -p "$HOME/.config/${config_file%.toml}"
	symlink_if_needed "$dir/$config_file" "$HOME/.config/${config_file%.toml}/config.toml"
done
