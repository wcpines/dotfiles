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

[ -f ~/.passwords ] && source ~/.passwords 



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
alias grep='grep --color=auto'
alias hg='history|grep' $1
alias wh="say -v Whisper"
alias no='echo "https://www.youtube.com/watch?v=WOE1-2Fza5Q&t=2m20s"'
alias cs="cd ~/Desktop/Back_up_docs/CS Learning/"
alias desk="cd ~/Desktop"
alias ghc="cd /Users/colby/code/aptible"
alias docs="cd /Users/colby/code/aptible/support/source/topics"
alias atg="cd /Users/colby/code/aptible/aptible-tech-guide"
alias api="aptible ssh --app api.aptible.com bundle exec script/management-console"
alias auth="aptible ssh --app auth.aptible.com bundle exec rails console"
alias tu="cat ~/thumb.txt"
alias aa="ll -ha"
alias ah="ll -h"
alias gpom="git push origin master"
alias cg="curlget"
alias wheres="find . -name *$1*"

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

db-launch() {
 container=$(head -c 32 /dev/urandom | md5)
 image="$1"
 shift

 docker create --name $container $image
 docker run --volumes-from $container \
  -e USERNAME=aptible -e PASSPHRASE=foobar -e DB=db $image --initialize
 docker run $@ --volumes-from $container $image
}

###########################
#*---Aptible Specifics---*#
###########################

aptible-clone() {
  if [ -z "$1" ]; then
    echo "Usage: aptible-clone APP_HANDLE"
    return 1
  fi

  GIT_INSTANCE=54.85.132.36  # aptible-production master1

  ssh -p 2222 $GIT_INSTANCE rm -rf $1
  ssh -p 2222 $GIT_INSTANCE sudo git clone /mnt/primetime/git/$1.git && \
    ssh -p 2222 $GIT_INSTANCE sudo chown -R \$USER:opsworks $1 && \
    rsync -az --progress -e "ssh -p 2222" $GIT_INSTANCE:$1 .
  ssh -p 2222 $GIT_INSTANCE rm -rf $1
}

opsworks-ssh() {
  if [ "$#" -gt 1 ]; then
    STACK=$1
    shift
    HOST=$1
    shift
    ssh -o ProxyCommand="ssh -p 2222 $STACK.ssh.aptible.com nc $HOST 2222" \
      $STACK-$HOST $@ 2> /dev/null || \
    ssh -o ProxyCommand="ssh -p 2222 $STACK.ssh.aptible.com nc $HOST 22" \
      $STACK-$HOST $@
  elif [ "$#" -eq 1 ]; then
    ssh -p 2222 $1.ssh.aptible.com
  else
    echo "Usage: opsworks-ssh STACK [HOST] [CMD ...]"
    return 1
  fi
}
#*---Docker Settings---*#

export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/colby/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1
source /usr/local/etc/bash_completion.d/docker

if [ -f $(brew --prefix)/etc/bash_completion ]; then
 . $(brew --prefix)/etc/bash_completion
fi

#*---Zendesk API Nonsense---*#

alias zdesk="cd /Users/colby/.gem/ruby/2.1.3/gems/zendesk_api-1.9.3"

function zd-auth(){
echo "USING: curl -u USER/TOKEN https://aptible.zendesk.com/api/v2/users/me.json";
curl -u $ZENDESK_USER/token:$ZENDESK_TOKEN 'https://aptible.zendesk.com/api/v2/users/me.json'| jq .
}

function curlget(){
echo "USING: curl https://$ZENDESK_SUBDOMAIN.zendesk.com/api/v2/$1/$2.json";
curl -u $ZENDESK_USER/token:$ZENDESK_TOKEN https://$ZENDESK_SUBDOMAIN.zendesk.com/api/v2/$1/$2.json| jq .
}

