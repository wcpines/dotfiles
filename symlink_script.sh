#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=dotfiles                    # dotfiles directory
olddir=dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc ctags gitignore"    # list of files/folders to symlink in homedir
packages="Brewfile"

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

# link Brewfile as a non-hidden file
for package_list in $packages; do
    echo "Moving any existing package lists from ~ to $olddir"
    mv ~/$package_list ~/dotfiles_old/
    echo "Creating symlink to $package_list in home directory."
    ln -s $dir/$package_list ~/$package_list
done
