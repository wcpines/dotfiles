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
  nvim "$HOME/Tresorit/Colby/weight_room/scratch.$1"
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
  read -p ">>> " user_input
  if [[ $user_input == "yes" ]]; then
    echo "Killing Messages processes..."
    osascript -e 'quit app "Messages"' 2>/dev/null
    killall imagent 2>/dev/null

    echo "Deleting chat history..."
    rm -rf "$HOME/Library/Messages/chat.db"*
    rm -rf "$HOME/Library/Messages/Archive/"
    rm -rf "$HOME/Library/Messages/Attachments/"
    rm -rf "$HOME/Library/Messages/SyncedDrafts/"
    rm -rf "$HOME/Library/Messages/Transfers/"

    echo "Done."
  else
    echo "Canceling"
  fi
}

git_int() {
  git stash --message "brb"
  git checkout master
}

mov2gif() {
  if [ $# -eq 0 ]; then
    echo "Usage: mov2gif <input_video>"
    echo "Converts video to GIF in the same directory"
    return 1
  fi

  input="$1"
  dirname=$(dirname "$input")
  filename=$(basename "$input")
  filename_noext="${filename%.*}"
  output="$dirname/${filename_noext}.gif"
  palette="/tmp/palette.png"

  # Create palette for better quality
  ffmpeg \
    -i "$input" \
    -vf "fps=10,scale=480:-1:flags=lanczos,palettegen" \
    "$palette" &&
    ffmpeg \
      -i "$input" \
      -i "$palette" \
      -filter_complex "fps=10,scale=480:-1:flags=lanczos[x];[x][1:v]paletteuse" \
      "$output" &&
    rm "$palette"

  echo "Converted $input to $output"
}

jira_to_claude() {
  # Full details:    jira_to_claude EPIC-1154 EPIC-1152
  # Planning mode:   jira_to_claude EPIC-1154 EPIC-1152 --plan
  # Brief mode:      jira_to_claude EPIC-1152 --brief
  # Specific issues: jira_to_claude --issue EPIC-8920 EPIC-8921
  # Filter status:   jira_to_claude EPIC-1152 --status "In Progress"
  # Output to file:  jira_to_claude EPIC-1152 --plan --output context.md

  "$HOME/Developer/agent-config/scripts/jira-to-claude.sh" "$@"
}

alias jtc="jira_to_claude"

iterm_title() {
  echo -ne "\033]0;$*\007"
}

alias it="iterm_title"

# Fetch failed test details from CircleCI.
#
# Requires CIRCLECI_TOKEN env var.
#
# Usage:
#   ci_failures <circleci-url>  # paste a job or workflow URL
#
# Supported URL formats:
#   .../workflows/<id>/jobs/<num>  → fetch failures for that job
#   .../workflows/<id>             → fetch failures for all failed jobs in workflow
#
ci_failures() {
  local url="$1"

  if [[ -z "$CIRCLECI_TOKEN" ]]; then
    echo "Error: CIRCLECI_TOKEN is not set" >&2
    return 1
  fi

  if [[ -z "$url" ]]; then
    echo "Usage: ci_failures <circleci-url>" >&2
    return 1
  fi

  local api="https://circleci.com/api/v2"
  local auth=(-H "Circle-Token: $CIRCLECI_TOKEN")

  # Parse URL: .../pipelines/github/Org/Repo/.../workflows/<id>[/jobs/<num>]
  local vcs org repo workflow_id job_number slug

  if [[ "$url" =~ pipelines/([^/]+)/([^/]+)/([^/]+)/[^/]+/workflows/([^/]+)(/jobs/([^/]+))? ]]; then
    vcs="${BASH_REMATCH[1]}"
    org="${BASH_REMATCH[2]}"
    repo="${BASH_REMATCH[3]}"
    workflow_id="${BASH_REMATCH[4]}"
    job_number="${BASH_REMATCH[6]}"
  else
    echo "Error: could not parse CircleCI URL" >&2
    echo "Expected: https://app.circleci.com/pipelines/{vcs}/{org}/{repo}/.../workflows/{id}[/jobs/{num}]" >&2
    return 1
  fi

  # Map vcs name to slug prefix (github → gh, bitbucket → bb)
  case "$vcs" in
  github) slug="gh/$org/$repo" ;;
  bitbucket) slug="bb/$org/$repo" ;;
  *) slug="$vcs/$org/$repo" ;;
  esac

  if [[ -n "$job_number" ]]; then
    _ci_fetch_tests "$api" "${auth[@]}" "$slug" "$job_number"
  else
    local jobs
    jobs=$(curl -s "${auth[@]}" "$api/workflow/$workflow_id/job" |
      jq -r '.items[] | select(.status == "failed") | "\(.job_number)\t\(.name)"')

    if [[ -z "$jobs" ]]; then
      echo "No failed jobs in workflow $workflow_id"
      return 0
    fi

    while IFS=$'\t' read -r num name; do
      echo "=== $name (job $num) ==="
      _ci_fetch_tests "$api" "${auth[@]}" "$slug" "$num"
      echo
    done <<<"$jobs"
  fi
}

_ci_fetch_tests() {
  local api="$1"
  shift
  local auth=("$1" "$2")
  shift 2
  local slug="$1"
  local job_number="$2"

  curl -s "${auth[@]}" "$api/project/$slug/$job_number/tests" |
    jq -r '
      [.items[] | select(.result == "failure")] |
      if length == 0 then "  No test failures (job may have failed for another reason)"
      else .[] |
        (.message | capture("(?<file>\\S+_test\\.\\w+:\\d+)") // {file: "unknown"}) as $loc |
        "  \($loc.file) :: \(.name)\n    \(.message | split("\n") | first)"
      end'
}

fi-ls() {
  local bid="${1:?Usage: fi-ls <business_id> [--recursive]}"
  shift
  aws s3 ls "s3://blvd-prod-secure-data-imports/uploads/${bid}/" "$@"
}
