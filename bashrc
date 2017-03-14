# PATH=$PATH:$HOME/bin:/usr/local/git/bin/

export PATH

export EDITOR='gvim'
export FLATIRON_VERSION='1.1.1'
export GIT_MERGE_AUTOEDIT='no'
# export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"
export SVN_EDITOR="gvim"
export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin"
export VISUAL="gvim"
export PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH"

export FLASK_APP=chappy/app.py
export FLASK_DEBUG=1

# info from `brew info nvm`
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# http://docs.python-guide.org/en/latest/writing/gotchas/
# export PYTHONDONTWRITEBYTECODE=1

# export PATH="/Users/colby/.pyenv/bin:$PATH"

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

source /usr/local/opt/chruby/share/chruby/chruby.sh
# chruby ruby-2.1.3
chruby ruby-2.3.1

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi


# if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
#   . /usr/local/bin/virtualenvwrapper.sh
# fi


[ -f ~/.passwords ] && source ~/.passwords


##################################
#----------Color Aliases----------
##################################

CK="0;30"
GREEN="0;32"
CYAN="0;36"
RED="0;31"
YELLOW="1;33"
BROWN="0;33"
BLUE="0;34"
RED="0;31"


LITEGREEN="1;32"
LITECYAN="1;36"
LITERED="1;31"
LITEPURPLE="1;35"
LITEBROWN="1;34"
LITEBLUE="1;34"

export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
export CLICOLOR=2

####################################
#----------Prompt settings----------
####################################
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1="\\[\e[\$GREEN m\]\h\[\]@\[\e[\$GREEN m\]\u\[\e[m\].\[\e[\$YELLOW m\]\w\[\e[m\]\[\e[\$BROWN m\] \$(parse_git_branch)\n\[\e[\$CYAN m\]== $ \[\e[m\]"


eval "$(thefuck --alias "fuck")"

#-------------End Color Aliases------------

#Other Get the aliases and functions

alias ah="ls -lah"
alias aliases="list_aliases"
alias be="bundle exec"
alias blog="cd ~/Desktop/Blog/"
alias bp="gvim ~/.bashrc"
alias burp="java -Xmx2g -jar ~/burpsuite_free_v1.6.32.jar"
alias cbp="cat ~/.bashrc"
alias code="cd ~/development/code"
alias crun="PYTHONPATH=. python chappy/app.py"
alias desk="cd ~/Desktop"
alias dmop="docker-machine stop default"
alias dms="docker-machine status default"
alias dmst="docker-machine start default"
alias gforce="git push --force origin master"
alias go="git open"
alias gpom="git push origin master"
alias grebase="git rebase -i head~"
alias grep="grep --color=auto"
alias gsa="git stash apply"
alias gsl="git stash list"
alias hg="history|grep" $1
alias lff="learn --fail-fast"
alias ls="ls -gfaSh"
alias lsf="ls -lad */" # list the directories only
alias lyn="yarn learnyounode"
alias lynp="yarn learnyounode print"
alias lynv="yarn learnyounode verify program.js"
alias misc="cd ~/desktop/misc"
alias mk="open -a Marked\ 2.app"$1
alias myip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*"
alias no="echo 'https://www.youtube.com/watch?v=woe1-2fza5q&t=2m20s'"
alias pac="pyenv activate chappy"
alias pys="python_server"
alias rake="bundle exec rake"
alias rc="rails console"
alias rebuild_index="c --rebuild"
alias rm="rm -i"
alias rs="rails server"
alias sbp="source ~/.bashrc"
alias sf="mdfind"
alias sq="sqlite3 chappy.db" $1
alias ssu="spotify share url"
alias wh="say -v whisper"
alias ya="yarn add"
alias yi="yarn install"
alias yrb="yarn run bundle"
alias yrt="yarn run test"
alias ys="yarn start"
alias ip="IPython"

# make gvim always open files in existing instance with a buffer
# function gvim () {
#   command gvim --remote-silent "$@" || command gvim "$@";
# }

function lbp(){
  lsof -wni tcp:$@
}

# NR is number of record i.e. row

function kbp(){
  lsof -wni tcp:$@ | awk 'NR!=1 {print $2}' | xargs kill
}


function ber(){
  bundle exec rake $@
}


function scratch(){
  gvim ~/scratch.$1
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

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

# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

[ -s "/Users/colby/.scm_breeze/scm_breeze.sh" ] && source "/Users/colby/.scm_breeze/scm_breeze.sh"


