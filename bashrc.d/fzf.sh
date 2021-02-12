[[ -f $HOME/.fzf.bash ]] && source $HOME/.fzf.bash

# https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
#   --files: List files that would be searched but do not search
#   --no-ignore: Do not respect .gitignore, etc...
#   --hidden: Search hidden files and folders
#   --follow: Follow symlinks
#   --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)

export FZF_DEFAULT_COMMAND="rg --ignore-case --files --hidden --follow --glob '!.git/*' --glob '!*.beam*', --glob '!*_build/*'"
export FZF_DEFAULT_OPTS="-i"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# https://github.com/junegunn/fzf/wiki/examples#opening-files
fzf_file_opener() {
	local out file key
	IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
	key=$(head -1 <<<"$out")
	file=$(head -2 <<<"$out" | tail -1)
	if [ -n "$file" ]; then
		[ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-nvim} "$file"
	fi
}

fuzzy_find_clipboard() {
	echo -n $(pbpaste) | gsed "s/[^[:alpha:]]//g" | pbcopy
	fzf_file_opener $(pbpaste)
}
