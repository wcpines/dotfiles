PATH=$PATH:$HOME/bin:/usr/local/git/bin/
export PATH
export EDITOR=vim
export VIMRUNTIME=/usr/share/vim/vim73
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby ruby-2.1.3
[ -s "/Users/colby/.scm_breeze/scm_breeze.sh" ] && source "/Users/colby/.scm_breeze/scm_breeze.sh"

#------------Start Color Aliases------------
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

PS1="\[\e[\$GREEN m\]\h\[\]@\[\e[\$GREEN m\]\u\[\e[m\].\[\e[\$YELLOW m\]\w\[\e[m\].\[\e[\$CYAN m\]$ \[\e[m\]"
PS2="\[\e[\$LITEGREEN m\]continue->"


 [ -f ~/.passwords ] && source ~/.passwords #&&&



#-------------End Color Aliases------------

#Other Get the aliases and functions
alias lsf="ls -ad */" # List the directories only              
alias e="vim"
alias see="declare -f "
alias apt="mysql --i-am-a-dummy --prompt 'cpines APTIBLE> ' -u $MYSQL_USERNAME --password=$MYSQL_PASS -h $MYSQL_HOST_PINES_DB"    
alias rm='rm -i'
alias misc='cd ~/Desktop/Misc'
alias vrc='vim ~/.vimrc'
alias nb='ipython notebook --pylab=inline'
alias bp='vim ~/.bashrc'
alias sbp='source ~/.bash_profile'
alias cbp='cat ~/.bash_profile'
alias ls='ls -GFaSh'
alias hg='history|grep' $1
alias wh="say -v Whisper"
alias no='echo "https://www.youtube.com/watch?v=WOE1-2Fza5Q&t=2m20s"'
alias cs="cd ~/Desktop/Back_up_docs/CS Learning/"
alias desk="cd ~/Desktop"
alias ghc="cd /Users/colby/code/aptible"
alias docs="cd /Users/colby/code/aptible/support/source/topics"
alias dangerzone="aptible ssh --app api.aptible.com bundle exec script/management-console"
alias auth="aptible ssh --app auth.aptible.com bundle exec rails console"
alias tu="cat ~/thumb.txt"
alias aa="ll -a"
alias d="docker"

aptible-staging() {
  remote=$(git remote -v | grep staging | head -n 1)
  app=$(echo ${remote} | sed 's/.*aptible-staging\.com:\(.*\)\.git.*/\1/')

  if [ "$#" -eq 0 ] || [ "$1" = "help" ] || [ "$1" = "version" ]; then
    aptible $@
  elif [ -z "$app" ] || [ "$1" = "login" ] || [ "$1" = "apps:create" ] || \
       [[ "$1" =~ "db" ]]; then
    APTIBLE_AUTH_ROOT_URL=https://auth.aptible-staging.com \
    APTIBLE_API_ROOT_URL=https://api.aptible-staging.com \
    aptible $@
  else
    APTIBLE_AUTH_ROOT_URL=https://auth.aptible-staging.com \
    APTIBLE_API_ROOT_URL=https://api.aptible-staging.com \
    aptible $@ --app $app
  fi
}

#########################
#*---Docker Settings---*#
#########################
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/colby/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

