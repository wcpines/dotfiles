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

# Bash prompt
# \e[ = Start color scheme
# \e[m = Stop color scheme.

PS1="\[\e[\$GREEN m\]\h\[\]@\[\e[\$GREEN m\]\u\[\e[m\].\[\e[\$YELLOW m\]\w\[\e[m\].\[\e[\$CYAN m\]$ \[\e[m\]"

[ -f ~/.passwords ] && source ~/.passwords 

# from BEWD course, using rbenv: https://gist.github.com/bobbytables/dcd589bf911c1cff9851 
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

#-------------End Color Aliases------------

#Other Get the aliases and functions


#alias myip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*"
alias aa="ll -ha"
alias ah="ll -h"
alias al="aptible login"
alias api="aptible ssh --app dangerzone bundle exec script/management-console"
alias atg="cd /Users/colby/code/aptible/aptible-tech-guide"
alias bp='gvim ~/.bashrc'
alias cg="curlget"
alias cs="cd ~/Desktop/Back_up_docs/CS Learning/"
alias desk="cd ~/Desktop"
alias dm="docker-machine"
alias docs="cd /Users/colby/code/aptible/support/source/topics"
alias gforce="git push --force origin master"
alias ghc="cd /Users/colby/code/aptible"
alias gpom="git push origin master"
alias grebase="git rebase -i HEAD~"
alias grep='grep --color=auto'
alias hg='history|grep' $1
alias ls='ls -GFaSh'
alias lsf="ls -lad */" # List the directories only       
alias misc='cd ~/Desktop/Misc'
alias no='echo "https://www.youtube.com/watch?v=WOE1-2Fza5Q&t=2m20s"'
alias rc="rails console"
alias rm='rm -i'
alias rs="rails server"
alias sbp='source ~/.bash_profile'
alias sf="mdfind"
alias tam="cd /Users/colby/code/aptible/aptible-tam-guide"
alias wh="say -v Whisper"
# aptible-staging() {
#  remote=$(git remote -v | grep staging | head -n 1)
#  app=$(echo ${remote} | sed 's/.*aptible-staging\.com:\(.*\)\.git.*/\1/')

#  if [ "$#" -eq 0 ] || [ "$1" = "help" ] || [ "$1" = "version" ]; then
#   aptible $@
#  elif [ -z "$app" ] || [ "$1" = "login" ] || [ "$1" = "apps:create" ] || \
  #     [[ "$1" =~ "db" ]]; then
#   APTIBLE_AUTH_ROOT_URL=https://auth.aptible-staging.com \
  #   APTIBLE_API_ROOT_URL=https://api.aptible-staging.com \
  #   aptible $@
#  else
#   APTIBLE_AUTH_ROOT_URL=https://auth.aptible-staging.com \
  #   APTIBLE_API_ROOT_URL=https://api.aptible-staging.com \
  #   aptible $@ --app $app
#  fi
# }

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
  echo "Usage: aptible-clone APP_ID"
  return 1
fi

GIT_INSTANCE=beta.aptible.com  # aptible-production master1

repo="app-$1"
shift

# file:// protocol is necessary for --depth clones, but for cloning all
# objects (including those not on any branch), we need to clone the path
# directly
if [ -z "$@" ]; then
  url=/mnt/primetime/git/$repo
else
  url=file:///mnt/primetime/git/$repo
fi

ssh -p 2222 $GIT_INSTANCE rm -rf $repo
ssh -p 2222 $GIT_INSTANCE sudo git clone $url $@ && \
  ssh -p 2222 $GIT_INSTANCE sudo chown -R \$USER:opsworks $repo && \
  rsync -az --progress -e "ssh -p 2222" $GIT_INSTANCE:$repo .
ssh -p 2222 $GIT_INSTANCE rm -rf $repo
}

opsworks-ssh() {
if [[ "$1" =~ ":" ]]; then
  IFS=':' read -a stackhost <<< "$1"
  stack=${stackhost[0]}
  host=${stackhost[1]}
  shift
  ssh -o ProxyCommand="ssh -p 2222 bastion-layer-$stack.aptible.in nc $host 2222" \
    $stack-$host $@ 2> /dev/null || \
    ssh -o ProxyCommand="ssh -p 2222 bastion-layer-$stack.aptible.in nc $host 22" \
    $stack-$host $@
else
  stack=$1
  shift
  ssh -p 2222 bastion-layer-$stack.aptible.in $@
fi
}

#docker-machine configuration?

# eval "$(docker-machine env default)"

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

# this doesn't work yet :( :( 
function curlput(){
curl -u $ZENDESK_USER/token:$ZENDESK_TOKEN https://$ZENDESK_SUBDOMAIN.zendesk.com/api/v2/$1/$2.json -H "Content-Type: application/json" -v -X PUT -d $3
}
