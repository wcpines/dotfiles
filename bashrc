# Use $HOME/dotfiles/bashrc.d

for file in ${HOME}/dotfiles/bashrc.d/*.sh; do
  source $file
done

if [[ -f ~/.env ]]; then
  set -a
  source ~/.env
  set +a
fi

if [[ -f $LOCAL_TOOLS ]]; then
  source $LOCAL_TOOLS
fi

[ -s "/Users/colby/.scm_breeze/scm_breeze.sh" ] && source "/Users/colby/.scm_breeze/scm_breeze.sh"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(starship init bash)"
