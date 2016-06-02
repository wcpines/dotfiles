PATH=$PATH:$HOME/bin:/usr/local/git/bin/

export PATH
export EDITOR=vim
export VIMRUNTIME=/usr/share/vim/vim73

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby ruby-2.1.3


[ -s "/Users/colby/.scm_breeze/scm_breeze.sh" ] && source "/Users/colby/.scm_breeze/scm_breeze.sh"

#docker-machine configuration?

eval "$(docker-machine env default)"

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

parse_aptible_token() {
  if [[ -n "$APTIBLE_ACCESS_TOKEN" ]]; then
    echo "(IMPERSONATING) "
  fi
}

PS1="\$(parse_aptible_token)\[\e[\$GREEN m\]\h\[\]@\[\e[\$GREEN m\]\u\[\e[m\].\[\e[\$YELLOW m\]\w\[\e[m\].\[\e[\$CYAN m\]$ \[\e[m\]"

[ -f ~/.passwords ] && source ~/.passwords 

# from BEWD course, using rbenv: https://gist.github.com/bobbytables/dcd589bf911c1cff9851 
# if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

#-------------End Color Aliases------------

#Other Get the aliases and functions


#alias myip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*"
alias ah="ls -lah"
alias al="aptible login"
alias api="aptible ssh --app dangerzone bundle exec script/management-console"
alias atg="cd /users/colby/code/aptible/aptible-tech-guide"
alias bp="gvim ~/.bashrc"
alias burp="java -Xmx2g -jar ~/burpsuite_free_v1.6.32.jar"
alias cg="curlget"
alias cs="cd ~/desktop/back_up_docs/cs learning/"
alias desk="cd ~/desktop"
alias dms="docker-machine status default"
alias dmst="docker-machine start default"
alias dmop="docker-machine stop default"
alias docs="cd /users/colby/code/aptible/support/source/topics"
alias gforce="git push --force origin master"
alias ghc="cd /users/colby/code/aptible"
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
alias sbp="source ~/.bash_profile"
alias sf="mdfind"
alias tam="cd /users/colby/code/aptible/aptible-tam-guide"
alias wh="say -v whisper"



###########################
#*---Aptible Specifics---*#
###########################

# Go to segment warehouse

warehouse() {
  aws:aptible pancake stack:ssh production --layer bastion sudo docker run -i -t quay.io/aptible/postgresql:9.4 --client $1
}


# opsworks-ssh aptible-production
# opsworks-ssh aptible-production:10.0.1.195 sudo restart cron
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

# Opens multiple terminal tabs, one for each argument
# opsworks-ssh-multi shared staging redox ...
opsworks-ssh-multi() {
  for host in $@ ; do
    newtab opsworks-ssh $host
    sleep 0.5
  done
}

# aptible-clone APP_ID
# Clones Aptible app locally, from beta.aptible.com
# e.g. aptible-clone 1422

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


# db-launch IMAGE [OPTIONS]
# Launches a container from standardized database container, with username
# "aptible" and password "foobar" by default. Options are passed directly to
# `docker run`.
db-launch() {
  container=$(head -c 32 /dev/urandom | md5)
  passphrase=${PASSPHRASE:-foobar}
  image="${@: -1}"

  docker create --name $container $image
  docker run --volumes-from $container \
    -e USERNAME=aptible -e PASSPHRASE=$passphrase -e DB=db $@ --initialize
  docker run --volumes-from $container $@
}

if [ -f $(brew --prefix)/etc/bash_completion ]; then
 . $(brew --prefix)/etc/bash_completion
fi

function aws:aptible () {
  (
    eval $(aws-creds env default)
    "$@"
  )
}

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

