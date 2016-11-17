# PATH=$PATH:$HOME/bin:/usr/local/git/bin/

export PATH

##########
# Flatiron
##########

export EDITOR='gvim'
export FLATIRON_VERSION='1.1.1'
export GIT_MERGE_AUTOEDIT='no'
# export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"
export SVN_EDITOR="gvim"
export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin"
export VISUAL="gvim"
export PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH"


# info from `brew info nvm`
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# export VIMRUNTIME=/usr/share/vim/vim73


# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

source /usr/local/opt/chruby/share/chruby/chruby.sh
# chruby ruby-2.1.3
chruby ruby-2.3.1

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

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

[ -f ~/.passwords ] && source ~/.passwords 

#-------------End Color Aliases------------

#Other Get the aliases and functions


alias myip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*"
alias aliases="list_aliases"
alias ah="ls -lah"
alias bp="gvim ~/.bashrc"
alias cbp="cat ~/.bashrc"
alias burp="java -Xmx2g -jar ~/burpsuite_free_v1.6.32.jar"
alias cg="curlget"
alias desk="cd ~/Desktop"
alias dms="docker-machine status default"
alias dmst="docker-machine start default"
alias dmop="docker-machine stop default"
alias gforce="git push --force origin master"
alias gpom="git push origin master"
alias grebase="git rebase -i head~"
alias grep="grep --color=auto"
alias hg="history|grep" $1
alias ls="ls -gfaSh"
alias lsf="ls -lad */" # list the directories only       
alias misc="cd ~/desktop/misc"
alias no="echo 'https://www.youtube.com/watch?v=woe1-2fza5q&t=2m20s'"
alias rc="rails console"
alias rm="rm -i"
alias rs="rails server"
alias sbp="source ~/.bashrc"
alias sf="mdfind"
alias wh="say -v whisper"
alias mk="open -a Marked\ 2.app"$1

# since flatiron
alias sq="sqlite3 c.db" $1
alias lff="learn --fail-fast" 
alias go="git open" 
alias rake="bundle exec rake" 
alias be="bundle exec" 
alias code="cd ~/development/code"


function kbp {

lsof -wni tcp:$1

}

function ber {
  bundle exec rake $@
}


function dun {
  mv $1 ~/development/done
} 

[ -s "/Users/colby/.scm_breeze/scm_breeze.sh" ] && source "/Users/colby/.scm_breeze/scm_breeze.sh"


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

function green_light {

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

function clone_and_cd () {
  url=$(eval pbpaste)
  base=$(echo $url | awk -F '\/' '{print $2}')
  directory=$(echo $base | awk -F '\.' '{print $1}')
  git clone $url
  cd $directory
}
