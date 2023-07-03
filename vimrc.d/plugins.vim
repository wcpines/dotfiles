" -- Install the plugin manager if it doesn't exist

filetype off
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

" -- Syntax, languages, & frameworks

Plug 'chrisbra/csv.vim', { 'for': ['tsv', 'csv' ]}
Plug 'elixir-editors/vim-elixir', { 'for': ['elixir', 'eelixir']}
Plug 'hashivim/vim-terraform'
Plug 'lmeijvogel/vim-yaml-helper', { 'for': 'yaml' }
Plug 'mhinz/vim-mix-format', { 'for': ['elixir', 'eelixir']}
Plug 'ngmy/vim-rubocop', { 'for': ['rspec', 'ruby'] }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'pantharshit00/vim-prisma'
Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html', 'graphql'] }
Plug 'sheerun/vim-polyglot'
Plug 'vim-scripts/sql_iabbr.vim', { 'for': 'sql' }
Plug 'darfink/vim-plist', { 'for': 'plist' }
Plug 'z0mbix/vim-shfmt', { 'for': ['sh', 'Dockerfile'] }

" -- LSP

" LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'

"  Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

Plug 'VonHeikemen/lsp-zero.nvim'

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

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'andyl/vim-projectionist-elixir', { 'for': ['elixir', 'eelixir'] }
Plug 'henrik/vim-indexed-search'
Plug 'mhinz/vim-grepper'
Plug 'nelstrom/vim-visual-star-search'
Plug 'tpope/vim-projectionist', { 'for': ['elixir', 'eelixir', 'ruby', 'rspec'] }
" Plug 'ggandor/lightspeed.nvim'

" -- Display

Plug 'altercation/vim-colors-solarized'
Plug 'hoob3rt/lualine.nvim'
Plug 'junegunn/seoul256.vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'vim-scripts/restore_view.vim'

" -- Misc Enhancements

Plug 'AndrewRadev/splitjoin.vim'
Plug 'andymass/vim-matchup'
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
Plug 'wellle/targets.vim'
Plug 'yggdroot/indentline'

call plug#end()
