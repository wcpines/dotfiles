" -- Install the plugin manager if it doesn't exist

filetype off
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" -- Syntax, languages, & frameworks

Plug 'chrisbra/csv.vim', { 'for': ['tsv', 'csv' ]}
Plug 'elixir-editors/vim-elixir', { 'for': ['elixir', 'eelixir']}
Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
Plug 'lmeijvogel/vim-yaml-helper', { 'for': 'yaml' }
Plug 'mhinz/vim-mix-format', { 'for': ['elixir', 'eelixir']}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ngmy/vim-rubocop', { 'for': ['rspec', 'ruby'] }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'pantharshit00/vim-prisma'
Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html', 'graphql'] }
Plug 'sheerun/vim-polyglot'
Plug 'vim-scripts/sql_iabbr.vim', { 'for': 'sql' }
Plug 'z0mbix/vim-shfmt', { 'for': ['sh', 'Dockerfile'] }

" -- Text objects

Plug 'andyl/vim-textobj-elixir', { 'for': ['elixir', 'eelixir'] }
Plug 'bps/vim-textobj-python', { 'for': 'python' }
Plug 'coderifous/textobj-word-column.vim'
Plug 'dewyze/vim-ruby-block-helpers'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-user'
Plug 'michaeljsmith/vim-indent-object'
Plug 'vim-scripts/Align'
Plug 'vim-scripts/textobj-rubyblock', { 'for': ['rspec', 'ruby'] }

" -- Search & file nav

Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'andyl/vim-projectionist-elixir', { 'for': ['elixir', 'eelixir'] }
Plug 'henrik/vim-indexed-search'
Plug 'mhinz/vim-grepper'
Plug 'nelstrom/vim-visual-star-search'
Plug 'tpope/vim-projectionist', { 'for': ['elixir', 'eelixir', 'ruby', 'rspec'] }

" -- Display

Plug 'altercation/vim-colors-solarized'
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'vim-scripts/restore_view.vim'

" -- Misc Enhancements

Plug 'AndrewRadev/splitjoin.vim'
Plug 'RRethy/vim-illuminate'
Plug 'dhruvasagar/vim-table-mode', { 'for': ['tsv', 'csv', 'sql']}
Plug 'godlygeek/tabular'
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
Plug 'kassio/neoterm'
Plug 'machakann/vim-highlightedyank'
Plug 'mattn/webapi-vim'
Plug 'mcasper/vim-infer-debugger'
Plug 'mzlogin/vim-markdown-toc', { 'for': 'markdown' }
Plug 'pbrisbin/vim-mkdir'
Plug 'skywind3000/asyncrun.vim'
Plug 'tmhedberg/matchit'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-bundler', { 'for': 'ruby' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'troydm/zoomwintab.vim'
Plug 'tweekmonster/startuptime.vim'
Plug 'vim-test/vim-test'
Plug 'vimlab/split-term.vim'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'wellle/targets.vim'
Plug 'yggdroot/indentline'

call plug#end()
