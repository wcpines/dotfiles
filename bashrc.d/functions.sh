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
# Requires CIRCLECI_TOKEN and CIRCLECI_PROJECT_SLUG env vars
# (e.g. CIRCLECI_PROJECT_SLUG="gh/MyOrg/my-repo")
#
# Usage:
#   ci_failures                            # detect failures from current branch's PR
#   ci_failures <workflow-id>              # show failures from all failed jobs
#   ci_failures <workflow-id> <job-number> # show failures from a specific job
#
ci_failures() {
  local workflow_id="$1"
  local job_number="$2"

  if [[ -z "$CIRCLECI_TOKEN" ]]; then
    echo "Error: CIRCLECI_TOKEN is not set" >&2
    return 1
  fi

  if [[ -z "$CIRCLECI_PROJECT_SLUG" ]]; then
    echo "Error: CIRCLECI_PROJECT_SLUG is not set (e.g. gh/MyOrg/my-repo)" >&2
    return 1
  fi

  local api="https://circleci.com/api/v2"
  local auth=(-H "Circle-Token: $CIRCLECI_TOKEN")

  # No args: find workflow ID from current branch's PR via gh CLI
  if [[ -z "$workflow_id" ]]; then
    workflow_id=$(_ci_workflow_from_pr "$api" "${auth[@]}")
    if [[ -z "$workflow_id" ]]; then
      echo "Usage: ci_failures [workflow-id] [job-number]" >&2
      return 1
    fi
  fi

  if [[ -z "$job_number" ]]; then
    local jobs
    jobs=$(curl -s "${auth[@]}" "$api/workflow/$workflow_id/job" \
      | jq -r '.items[] | select(.status == "failed") | "\(.job_number)\t\(.name)"')

    if [[ -z "$jobs" ]]; then
      echo "No failed jobs in workflow $workflow_id"
      return 0
    fi

    while IFS=$'\t' read -r num name; do
      echo "=== $name (job $num) ==="
      _ci_fetch_tests "$api" "${auth[@]}" "$num"
      echo
    done <<< "$jobs"
  else
    _ci_fetch_tests "$api" "${auth[@]}" "$job_number"
  fi
}

# Find the workflow ID by looking at failed CircleCI checks on the current branch's PR.
# Goes: gh pr checks → failed ci/circleci job link → job number → CircleCI API → workflow ID
_ci_workflow_from_pr() {
  local api="$1"; shift
  local auth=("$1" "$2"); shift 2

  if ! command -v gh &>/dev/null; then
    echo "gh CLI not found" >&2
    return 1
  fi

  # Get the first failed CircleCI check's link (contains job number)
  local link
  link=$(gh pr checks --json name,bucket,link 2>/dev/null \
    | jq -r '[.[] | select(.bucket == "fail" and (.name | startswith("ci/circleci:")))] | first | .link // empty')

  if [[ -z "$link" ]]; then
    echo "No failed CircleCI checks on current PR" >&2
    return 1
  fi

  # Extract job number from link: https://circleci.com/gh/Org/Repo/12345
  local job_num="${link##*/}"

  # Look up the workflow ID from the job
  curl -s "${auth[@]}" "$api/project/$CIRCLECI_PROJECT_SLUG/job/$job_num" \
    | jq -r '.latest_workflow.id // empty'
}

_ci_fetch_tests() {
  local api="$1"; shift
  local auth=("$1" "$2"); shift 2
  local job_number="$1"

  curl -s "${auth[@]}" "$api/project/$CIRCLECI_PROJECT_SLUG/$job_number/tests" \
    | jq -r '
      [.items[] | select(.result == "failure")] |
      if length == 0 then "  No test failures (job may have failed for another reason)"
      else .[] |
        (.message | capture("(?<file>\\S+_test\\.\\w+:\\d+)") // {file: "unknown"}) as $loc |
        "  \($loc.file) :: \(.name)\n    \(.message | split("\n") | first)"
      end'
}
