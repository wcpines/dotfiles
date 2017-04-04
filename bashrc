export PATH
export EDITOR='vim'
export GIT_MERGE_AUTOEDIT='no'
# export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"
export SVN_EDITOR="vim"
export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin"
export PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH"

# info from `brew info nvm`
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

shopt -s cdspell;


source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby ruby-2.3.1

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

[ -f ~/.passwords ] && source ~/.passwords

# http://docs.python-guide.org/en/latest/writing/gotchas/
export PYTHONDONTWRITEBYTECODE=1

# export PATH="/Users/colby/.pyenv/bin:$PATH"

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
#   . /usr/local/bin/virtualenvwrapper.sh
# fi

#===================================#
#----------Prompt settings----------#
#===================================#

# -- credit -- :
# https://github.com/necolas/dotfiles/blob/master/shell/bash_prompt

prompt_git() {

  # +	Uncommitted changes in the index
  # !	Unstaged changes
  # ?	Untracked files
  # $	Stashed files

  local s=""
  local branchName=""

  # check if the current directory is in a git repository
  if [ $(git rev-parse --is-inside-work-tree &>/dev/null; printf "%s" $?) == 0 ]; then

    # check if the current directory is in .git before running git checks
    if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == "false" ]; then

      # ensure index is up to date
      git update-index --really-refresh  -q &>/dev/null

      # check for uncommitted changes in the index
      if ! $(git diff --quiet --ignore-submodules --cached); then
        s="$s+";
      fi

      # check for unstaged changes
      if ! $(git diff-files --quiet --ignore-submodules --); then
        s="$s!";
      fi

      # check for untracked files
      if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        s="$s?";
      fi

      # check for stashed files
      if $(git rev-parse --verify refs/stash &>/dev/null); then
        s="$s$";
      fi

    fi

    # get the short symbolic ref
    # if HEAD isn't a symbolic ref, get the short SHA
    # otherwise, just give up
    branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
      git rev-parse --short HEAD 2> /dev/null || \
      printf "(unknown)")"

    [ -n "$s" ] && s=" [$s]"

    printf "%s" "$1$branchName$s"
  else
    return
  fi
}

set_prompts() {
  local black=""
  local blue=""
  local bold=""
  local cyan=""
  local green=""
  local orange=""
  local purple=""
  local red=""
  local reset=""
  local white=""
  local yellow=""

  local hostStyle=""
  local userStyle=""

  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    tput sgr0 # reset colors

    bold=$(tput bold)
    reset=$(tput sgr0)

    # Solarized colors
    # (https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized#the-values)
    black=$(tput setaf 0)
    blue=$(tput setaf 33)
    blue=$(tput setaf 33)
    cyan=$(tput setaf 37)
    green=$(tput setaf 64)
    orange=$(tput setaf 166)
    purple=$(tput setaf 125)
    red=$(tput setaf 124)
    white=$(tput setaf 15)
    yellow=$(tput setaf 136)
  else
    bold=""
    reset="\e[0m"

    black="\e[1;30m"
    blue="\e[1;34m"
    brown="\e0;33"
    cyan="\e[1;36m"
    green="\e[1;32m"
    orange="\e[1;33m"
    purple="\e[1;35m"
    red="\e[1;31m"
    white="\e[1;37m"
    yellow="\e[1;33m"
  fi

  # build the prompt

  # logged in as root
  if [[ "$USER" == "root" ]]; then
    userStyle="\[$bold$red\]"
  else
    userStyle="\[$orange\]"
  fi

  # connected via ssh
  if [[ "$SSH_TTY" ]]; then
    hostStyle="\[$bold$red\]"
  else
    hostStyle="\[$yellow\]"
  fi

  # set the terminal title to the current working directory
  PS1="\[\033]0;\w\007\]"

  PS1+="\n" # newline
  PS1+="\[$userStyle\]\u" # username
  PS1+="\[$reset$white\]@"
  PS1+="\[$hostStyle\]\h" # host
  PS1+="\[$reset$white\]: "
  PS1+="\[$green\]\w" # working directory
  PS1+="\$(prompt_git \"$white || $cyan\")" # git repository details
  PS1+="\n"
  PS1+="\[$reset$blue\]==\$ \[$reset\]" # $ (and reset color)

  export PS1
}

set_prompts
unset set_prompts

export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
export CLICOLOR=1

#===========================#
#----------Aliases----------#
#===========================#

alias .....='cd ../../../..'
alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'
alias ah="ls -lah"
alias aliases="list_aliases"
alias be="bundle exec"
alias blog="cd ~/Desktop/Blog/"
alias bp="vim ~/.bashrc"
alias vrc="vim ~/.vimrc"
alias burp="java -Xmx2g -jar ~/burpsuite_free_v1.6.32.jar"
alias cbp="cat ~/.bashrc"
alias code="cd ~/development/code"
alias crun="PYTHONPATH=. python chappy/app.py"
alias desk="cd ~/Desktop"
alias dmop="docker-machine stop default"
alias dms="docker-machine status default"
alias dmst="docker-machine start default"
alias dotfiles="cd ~/dotfiles"
alias e="nvim"
alias gforce="git push --force origin master"
alias go="git open"
alias gpom="git push origin master"
alias grebase="git rebase -i HEAD~"
alias grep="grep --color=auto"
alias hg="history|grep" $1
alias ip="IPython"
alias lff="learn --fail-fast"
alias ls="ls -gfaSh"
alias lsf="ls -lad */" # list the directories only
alias misc="cd ~/desktop/misc"
alias mk="open -a Marked\ 2.app"$1
alias myip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*"
alias rake="bundle exec rake"
alias rc="rails console"
alias rebuild_index="c --rebuild"
alias rm="rm -i"
alias rs="rails server"
alias sbp="source ~/.bashrc"
alias sf="mdfind"
alias sq="sqlite3"
alias ssu="spotify share"
alias wh="say -v whisper"
alias ya="yarn add"
alias yi="yarn install"
alias yrb="yarn run bundle"
alias yrt="yarn run test"
alias ys="yarn start"


# https://github.com/nvbn/thefuck
eval "$(thefuck --alias "fuck")"

# alias lyn="yarn learnyounode"
# alias lynp="yarn learnyounode print"
# alias lynv="yarn learnyounode verify program.js"

#=============================#
#----------Functions----------#
#=============================#


# list processes by port number
function lbp(){
  lsof -wni tcp:$@
}

# Kill processes by port number
function kbp(){
  lsof -wni tcp:$@ | awk 'NR!=1 {print $2}' | xargs kill
}


function ber(){
  bundle exec rake $@
}


function scratch(){
  vim ~/scratch.$1
}


# flatiron learn platform
function green_light(){
  if [ ! -d ./node_modules/ ]; then
    yarn install;
  fi

  if [ -d ./test/ ]; then
    learn;
    learn submit;
  else
    mkdir ./test;
    touch ./test/test.js;
    learn;
    learn submit;
  fi
}

function run_project(){
  (cd /Users/colby/development/youragora/your-agora-api && exec rails server & ) && (cd /Users/colby/development/youragora/your-agora-fe && exec yarn start & )
}



function mwp(){
  curl -H "x-api-key: $mercury_api_key" "https://mercury.postlight.com/parser?url=$1"
}

function clone_and_cd(){
  url=$(eval pbpaste)
  base=$(echo $url | awk -F '\/' '{print $2}')
  directory=$(echo $base | awk -F '\.' '{print $1}')
  git clone $url && \
    cd $directory && \
    if [ -f ./package.json ] && [ ! -f Gemfile ]; then
      yarn install;
    elif [ -f Gemfile ] && [ ! -f ./package.json ]; then
      bundle install;
    else
      printf "\n(nothing to install...)\n"
    fi
  }


  function git_repo_delete(){
    curl -vL \
      -H "Authorization: token $GITHUB_SECRET" \
      -H "Content-Type: application/json" \
      -X DELETE https://api.github.com/repos/$1 \
      | jq .
  }

  function python_server(){
    python -m SimpleHTTPServer;
  }


  function get_dev_secret(){
    cat .passwords | grep $@ | awk -F '=' '{print $2}' | pbcopy
  }

  function get_pubkey(){
    cat ~/.ssh/id_rsa.pub | pbcopy
  }


  function git_get(){
    curl -vkl -H "Authorization: token $GITHUB_SECRET" https://api.github.com/$1 | jq .
  }

  function git_repo_delete(){
    curl -vL -H "Authorization: token $GITHUB_SECRET" -H "Content-Type: application/json" -X DELETE https://api.github.com/repos/$1 | jq .
  }

  function curlpost(){
    # e.g. curlpost /signup '{"username": "test"}'

    endpoint=$1
    json_content=$2

    if [ $endpoint = "/signup" ]; then
      header=''
    else
      header=${3--H Authorization: Bearer "'$DEFAULT_TOKEN'"}
    fi

    if [[ -z $endpoint ]] || [ -z $json_content ]; then
      echo "ERROR: a RESTful endpoint and JSON payload is required to post"
    fi

    cmd="curl -s -H 'Content-Type: application/json' $header -X POST -d '$json_content' http://127.0.0.1:5000$endpoint | jq ."
    printf "########\\nRUNNING:\\n########\\n$cmd\\n\\n"
    eval $cmd
  }

  function curlget(){
    endpoint=${1-}
    header=${2-"-H Authorization: Bearer '$DEFAULT_TOKEN'"}
    cmd="curl -s $header -H http://127.0.0.1:5000$endpoint | jq ."
    printf "########\\nRUNNING:\\n########\\n$cmd\\n\\n"
    eval $cmd
  }

  function testsocket(){
    java -jar ./tyrus-client-cli-1.1.jar
  }
  function plagiarize(){
    github_gist_url=$1
    output_file=$2
    curl $github_gist_url -o $output_file
  }

function teleport(){
  last_command=$(fc -ln | tail -2 | head -1)
  cd `$last_command | awk -F '\/' '{OFS="\/"; $NF=""; print $0}'`
}

# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

[ -s "/Users/colby/.scm_breeze/scm_breeze.sh" ] && source "/Users/colby/.scm_breeze/scm_breeze.sh"
