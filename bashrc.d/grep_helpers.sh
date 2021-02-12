#==================================#
#----------Grep & Finders----------#
#==================================#

rip_grep_glob_search_list() {
	path_pattern=$1
	content_pattern=$2

	rip_grep_files $path_pattern | xargs rg -l $content_pattern
}

rip_grep_glob_search() {
	path_pattern=$1
	content_pattern=$2

	rip_grep_files $path_pattern | xargs rg -i $content_pattern
}

rip_grep_files() {
	pattern=$1
	rg --files | rg $pattern
}

rip_grep_no_spec() {
	pattern=$1
	rg --files |
		rg -v spec |
		xargs rg $pattern
}

rip_grep_migrations() {
	rg -g '*migrat*' "$1"
}

rip_grep_ignore_case() {
	rg -i $1
}

yank_last_list() {
	rg -l $1 | yank
}

todos() {
	rg "TODO|NOTE|TBD|FIXME|OPTIMIZE" .
}

todo() {
	# seach for only annotations I've signed
	rg "TODO.*(@?wcpines)|NOTE.*(@?wcpines)|TBD.*(@?wcpines)|FIXME.*(@?wcpines)|OPTIMIZE.*(@?wcpines)" .
}

action_todo() {
	# edit my TODOs
	all=$1
	if [[ $all == '-a' ]]; then
		rg -l "TODO.*|NOTE.*|TBD.*|FIXME.*|OPTIMIZE.*" . | xargs nvim
	else
		rg -l "TODO.*(@?wcpines)|NOTE.*(@?wcpines)|TBD.*(@?wcpines)|FIXME.*(@?wcpines)|OPTIMIZE.*(@?wcpines)" . | xargs nvim
	fi
}

litter() {
	use_files=$1
	litter_pattern=".*binding.pry.*$|^\s*debugger\s*;?$|.*\{debugger\}.*|.*IEx.pry.*$|.*require IEx.*$|.*IO.inspect.*|.*@tag :focus"
	if [[ -n $use_files ]]; then
		rg -l "$litter_pattern"
	else
		rg "$litter_pattern"
	fi
}

pickup_litter() {
	litter_pattern=".*binding.pry.*$|^\s*debugger\s*;?$|.*\{debugger\}.*|.*IEx.pry.*$|.*require IEx.*$|.*IO.inspect.*|.*@tag :focus"
	files=$(rg -l "$litter_pattern")

	if [[ $files == "" ]]; then
		printf "Looks like there's no litter!"
		return 1
	fi

	echo "removing instances of '$litter_pattern' in:"
	for line in $files; do
		printf "$line\n"
	done

	rg -l "$litter_pattern" | xargs gsed -Ei "/$litter_pattern/d"
}

see() {
	ls -gFash | rg -i $1
}

find_process() {
	ps aux | rg -i $@
}

find_replace() {
	set -f
	pattern=$1
	replacement=$2

	rg -l $pattern | xargs gsed -Ei "s/$pattern/$replacement/g"
}

history_rg() {
	history | rg $@
}