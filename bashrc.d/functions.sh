#=============================#
#----------Functions----------#
#=============================#

list_by_port() {
	# list processes by port number
	lsof -wni :$1
}

ps_by_port() {
	lsof -wni :$1 | awk 'NR!=1 {print $2}' | xargs ps -p
}

kill_nine_by_port() {
	# kill processes by port number
	lsof -wni :$1 | awk 'NR!=1 {print $2}' | xargs kill -9
}

scratch() {
	nvim "$HOME/Tresors/Colby/weight_room/scratch.$1"
}

git_repos() {
	curl -L \
		-H "Authorization: token $GITHUB_SECRET" \
		-H "Content-Type: application/json" \
		https://api.github.com/users/wcpines/repos |
		jq .[].full_name
}

git_repo_delete() {
	curl -L \
		-H "Authorization: token $GITHUB_SECRET" \
		-H "Content-Type: application/json" \
		-X DELETE https://api.github.com/repos/$1 |
		jq .
}

git_repo_unwatch() {
	owner_repo=$1 # format: owner/repo
	curl -vL \
		-H "Authorization: token $GITHUB_SECRET" \
		-H "Content-Type: application/json" \
		-X DELETE https://api.github.com/repos/$owner_repo/subscription |
		jq .
}

teleport() {
	last_command=$(fc -ln | tail -2 | head -1)
	cd $($last_command | awk -F '\/' '{OFS="\/"; $NF=""; print $0}')
}

# quickly run exercism tests
es_test() {
	dir=$(pwd)
	if [[ $dir != *"exercism"* ]]; then
		echo "You're not in your exercism dir"
	elif [[ $dir == *"ruby"* ]]; then
		ruby *_test.rb
	elif [[ $dir == *"elixir"* ]]; then
		elixir *_test.exs
	fi
}

remove_line() {
	line_number=$1
	file=$2
	gsed -ie "'"$line_number"d'" $file
}

path() {
	# prints more readable path
	echo $PATH | gsed -e 's/:/\n/g'
}

sum_column() {
	file=$1

	cat $file | paste -sd+ - | bc
}

mydiff() {
  diff-tree develop | tee >(pbcopy)
}

edit_previously_commited_files() {
	nvim $(git show --pretty="" --name-only)
}

edit_working_files() {
	nvim $(git status --porcelain | awk '{print $2}')
}

edit_searched_files() {
	search=$1

	rg -l $search | xargs nvim
}

stop_and_frisk() {
	git status --porcelain | awk '{print $2}' | xargs rubocop -a
}

#---Rails Dev---#

bes() {
	bundle exec rspec $@
}

ber() {
	bundle exec rake $@
}

migrate_version() {
	bundle exec rake db:migrate:up VERSION=$1
}

bi() {
	bundle install
}

rubo_files() {
	git diff --name-only $1 | grep .*rb | xargs rubocop -a
}

symlink_pre_commit_hook() {
	lang=$1
	ln -s $HOME/dotfiles/commit_hooks/$lang-pre-commit-hook .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
}

lowercase() {
	tr '[:upper:]' '[:lower:]'
}

dash_timestamp() {
	date +"%Y-%m-%d-%H-%M-%S"
}

my_branch() {
	gb --show-current | tee >(pbcopy)
}

get_current() {
	b=$(get_master)
	git checkout $b
	git pull origin $b
	git checkout -
	git rebase -
}

get_master() {
	branches=$(git branch -l)
	if [[ " ${branches[*]} " == *" main "* ]]; then
		printf main
	elif [[ " ${branches[*]} " == *" master "* ]]; then
		printf master
	else
		echo "I dunno, maybe your org is too woke for a canonical branch"
    exit
	fi
}

sql_func_def() {
	func=$1
	query "\sf $func" | pygmentize -lsql
}

check_logs() {
	pbpaste | nvim -c 'set ft=messages'
}

kib_start() {
	$(asdf which elasticsearch) -p /tmp/elasticsearch-pid -d
	echo "[STARTED] Elasticsearch $(asdf current elasticsearch)"
	nohup $(echo $(asdf which kibana) --log-file $(asdf where kibana)/kibana.log) >/dev/null &
	echo "[STARTED] Kibana $(asdf current kibana)"
}

kib_stop() {
	kill -SIGTERM $(cat /tmp/elasticsearch-pid | sed 's/%//')
	echo "[STOPPED] Elasticsearch $(asdf current elasticsearch)"

	kill $(ps aux | grep "$(asdf where kibana)" | awk '{print $2}')
	echo "[STOPPED] Kibana $(asdf current kibana)"
}

to_csv() {
	query "\\copy ($@) TO '~/Desktop/data.csv' WITH CSV HEADER;"
}

find_failing_migration() {
	pbpaste | rg -C 10 failed | rg -i shard
}

rand() {
	local length=${1:-8}
	local count=${2:-1}
	pwgen -s $length $count
}

git_current_branch() {
	git rev-parse --abbrev-ref HEAD
}

git_reset_on_origin_hard() {
	current_branch=$(git_current_branch)
	git reset "origin/$current_branch" --hard
}

remove_chat_history_for_good() {
	printf "Are you sure? (type: 'yes' to proceed)\n"
	read -p "$1>>> " user_input
	if [[ $user_input == "yes" ]]; then
		echo "Deleting chat history"
		rm -rf $HOME/Library/Messages/chat.db*
		rm -rf $HOME/Library/Messages/Archive/
		rm -rf $HOME/Library/Messages/Attachments/
	else
		echo "Canceling"
	fi
}

# edit() {
# 	file_input=$1
# 	file_name=$(echo $file_input | awk -F ':' '{print $1}')
# 	line_number=$(echo $file_input | awk -F ':' '{print $2}')

# 	nvim +"$line_number" "$file_name"

# }

use_ytop() {
	if [[ -n $(which ytop) ]]; then
		ytop -c solarized-dark
	else
		top
	fi
}

git_int(){
	git stash --message "brb"
	git checkout master
}
