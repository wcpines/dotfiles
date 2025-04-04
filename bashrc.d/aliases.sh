#===========================#
#----------Aliases----------#
#===========================#

if [[ -n $(which bat) ]]; then
	alias cat="bat"
fi

# alias rg="rg --hidden"
alias ....="cd ../.."
alias ..="cd .."
alias :q="exit"
alias :qa="exit"
alias ah="ls -gFash"
alias als="nvim $HOME/dotfiles/bashrc.d/aliases.sh"
alias blog="cd $HOME/Tresorit/Colby/blog/"
alias bp="nvim $HOME/dotfiles/bashrc.d"
alias brs="bin/rspec"
alias dbh="nvim $HOME/dotfiles/bashrc.d/db.sh"
alias dbl="db_local"
alias dc="docker-compose"
alias desk="cd $HOME/Desktop"
alias dot="cd $HOME/dotfiles"
alias dt="desc_table"
alias e="nvim"
alias eenv="nvim $HOME/.env"
alias esf="edit_searched_files"
alias fc="find_columns"
alias o="open"
alias fo="fzf_file_opener"
alias focus="mix test --only focus"
alias focux="iex -S mix test --trace --only focus"
alias ft="find_tables"
alias funcs="nvim $HOME/dotfiles/bashrc.d/functions.sh"
alias gashd="git stash drop"
alias gcmn="git commit --amend --no-edit"
alias gcrb="git_current_branch"
alias gdi="git diff --ignore-all-space"
alias gdno="git diff --name-only"
alias gdnd="git diff --name-only develop"
alias gdm="gd $(echo get_master)"
alias gdmn="gdm --name-only"
alias gds="git diff --staged"
alias get="resource_by_id"
alias gforce="git push --force-with-lease origin HEAD"
alias go="git-open"
alias gpld="git pull origin develop"
alias gplm="git pull origin master"
alias gpoh="git push origin HEAD"
alias groh="git_reset_on_origin_hard"
alias hg="history_rg"
alias imes="iex -S mix ecto.seed"
alias imps="iex -S mix phx.server"
alias imt="iex -S mix test --trace"
alias ip="IPython3"
alias ism="iex -S mix"
alias json="scratch json"
alias mdg="mix deps.get"
alias mem="mix ecto.migrate"
alias mer="mix ecto.reset"
alias mes="mix ecto.seed"
alias mf="mix format"
alias mk="open -a Marked\ 2.app"$1
alias mps="mix phx.server"
alias mt="mix test"
alias mtf="mix test --failed"
alias myip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*'"
alias phx="mix phx.server"
alias rgf="rip_grep_files"
alias rgg="rip_grep_glob_search"
alias rgi="rip_grep_ignore_case"
alias rgl="rip_grep_glob_search_list"
alias rgm="rip_grep_migrations"
alias rm="rm -i"
alias sba="source $HOME/dotfiles/bashrc.d/aliases.sh"
alias sbp="source $HOME/.bash_profile"
alias ssu="spotify share url"
alias tresor="cd $HOME/Tresorit/Colby"
alias stk="set_theme_kanagawa"
alias xe="xargs nvim"
alias ya="yarn add"
alias yi="yarn install"
alias yrp="yarn run publish"
alias yrs="yarn run serve"
alias yrt="yarn run test"
alias ys="yarn start"
alias z="fuzzy_find_clipboard"
