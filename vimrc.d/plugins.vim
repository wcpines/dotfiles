" *=============================*
" *----------|Plugins|----------*
" *=============================*

" Install the plugin manager if it doesn't exist
filetype off
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" -- Syntax, languages, & frameworks

Plug 'MaxMEllon/vim-jsx-pretty', { 'for': 'javascript'}
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'chrisbra/csv.vim', { 'for': ['tsv', 'csv' ]}
Plug 'darfink/vim-plist', { 'for': 'xml'}
Plug 'dewyze/vim-ruby-block-helpers'
Plug 'dzeban/vim-log-syntax'
Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
Plug 'elixir-editors/vim-elixir', { 'for': ['elixir', 'markdown', 'eelixir']}
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'hallison/vim-ruby-sinatra', { 'for': 'ruby' }
Plug 'hdima/python-syntax', { 'for': 'python' }
Plug 'ianks/vim-tsx'
Plug 'joker1007/vim-markdown-quote-syntax', { 'for': 'markdown' }
Plug 'joker1007/vim-ruby-heredoc-syntax', { 'for': ['rspec', 'ruby'] }
Plug 'keith/rspec.vim' , { 'for': ['rspec', 'ruby'] }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'lepture/vim-jinja', { 'for': 'jinja.html' }
Plug 'lmeijvogel/vim-yaml-helper', { 'for': 'yaml' }
Plug 'mhinz/vim-mix-format', { 'for': ['elixir', 'eelixir'] }
Plug 'mogelbrod/vim-jsonpath', { 'for': 'json' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ngmy/vim-rubocop', { 'for': ['rspec', 'ruby'] }
Plug 'pangloss/vim-javascript', { 'for': ['html', 'javascript', 'javascript.jsx']}
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'psf/black', { 'for': 'python' }
Plug 'rhysd/vim-crystal', { 'for': 'crystal' }
Plug 'ruby-formatter/rufo-vim', { 'for': 'ruby' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'slashmili/alchemist.vim', { 'for': ['elixir', 'eelixir'] }
Plug 'sunaku/vim-ruby-minitest', { 'for': 'ruby' }
Plug 'tarekbecker/vim-yaml-formatter'
Plug 'towolf/vim-helm'
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'tpope/vim-rake', { 'for': 'ruby' }
Plug 'vim-scripts/Jinja', { 'for': ['python', 'jinja.html'] }
Plug 'vim-scripts/applescript.vim', { 'for': 'applescript' }
Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }
Plug 'vim-scripts/sql_iabbr.vim', { 'for': 'sql' }
Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }

" -- Text objects

Plug 'andyl/vim-textobj-elixir', { 'for': ['elixir', 'eelixir'] }
Plug 'bps/vim-textobj-python', { 'for': 'python' }
Plug 'coderifous/textobj-word-column.vim'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-user'
Plug 'michaeljsmith/vim-indent-object'
Plug 'vim-scripts/Align'
Plug 'vim-scripts/textobj-rubyblock', { 'for': ['rspec', 'ruby'] }

" -- Search & file nav

" Plug 'andyl/vim-projectionist-elixir', { 'for': ['elixir', 'eelixir'] }
" Plug 'tpope/vim-projectionist'
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-localorie'
Plug 'danro/rename.vim'
Plug 'henrik/vim-indexed-search'
Plug 'jesseleite/vim-agriculture'
Plug 'mhinz/vim-grepper'
Plug 'nelstrom/vim-visual-star-search'

" -- Display


" Plug 'ap/vim-css-color', { 'for': ['css', 'scss'] }
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/seoul256.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'vim-scripts/restore_view.vim'

" -- Misc Enhancements

Plug 'AndrewRadev/splitjoin.vim'
Plug 'dhruvasagar/vim-table-mode', { 'for': ['tsv', 'csv', 'sql']}
Plug 'gioele/vim-autoswap'
Plug 'godlygeek/tabular'
Plug 'janko-m/vim-test'
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
Plug 'kassio/neoterm'
Plug 'machakann/vim-highlightedyank'
Plug 'mattn/webapi-vim'
Plug 'mcasper/vim-infer-debugger'
Plug 'mzlogin/vim-markdown-toc', { 'for': 'markdown' }
Plug 'pbrisbin/vim-mkdir'
Plug 'rizzatti/dash.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'tmhedberg/matchit'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-bundler', { 'for': 'ruby' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'troydm/zoomwintab.vim'
Plug 'vimlab/split-term.vim'
Plug 'wellle/targets.vim'
Plug 'yggdroot/indentline'

call plug#end()

