" wcpines' vimrc
" Née ~Jan 2015

" sections:

" 1. Basic Settings
" 2. Vanilla Mappings
" 3. Autocmds & Functions
" 4. Plugins
" 5. Plugin Settings & Mappings
" 6. Display Settings

" *====================================*
" *----------|Basic Settings|----------*
" *====================================*

syntax on                                               " Enable syntax highlighting
filetype off                                            " Filetype detection[OFF]
filetype plugin indent on                               " Filetype detection[ON] plugin[ON] indent[ON].This command will use indentation scripts located in the indent folder of your vim installation.

set autochdir                                           " Set working dir to current file
set autoindent                                          " Copy indent of previous line
set bs=2                                                " Backspace with this value allows you to use the backspace character for moving the cursor over automatically inserted indentation and over the start/end of line.
set clipboard^=unnamed,unnamedplus                      " Use system clipboard as the yank register
set expandtab                                           " Use spaces when tab is hit
set gcr=n:blinkon0                                      " Turn off cursor blink
set hidden                                              " Switch buffers and preserve changes w/o saving
set ignorecase                                          " Ignore case for search patterns
set incsearch                                           " Dynamic search (search and refine as you type)
set laststatus=2                                        " Show current mode, file name, file status, ruler, etc.
set modelines=0                                         " Ignore modelines set in files (which would otherwise set custom setting son a per file basis.  The line numbers vim would check to look for options would be set here)
set mouse=a                                             " Enable mouse (NB: SIMBL + MouseTerm enabled for teminal vim)
set nocompatible                                        " Get rid of Vi compatibility mode. SET FIRST!
set nohlsearch                                          " Do not highlight all matches (you can toggle this as needed with command below)
set nowrap                                              " Do not wrap lines of text by default
set number                                              " Set line numbering
set ruler                                               " Always show line/column info at bottom
set shiftwidth=2                                        " Number of characters for indentation made in normal mode ('>)
set showmatch                                           " Highlight search match as you type
set smartcase                                           " Respect cases in search when mixed case detected
set smartindent                                         " Changes indent based on file extension
set softtabstop=2                                       " Determines number of spaces to be inserted for tabs.  Also, backspace key treats four space like a tab (so deletes all spaces)
set splitbelow                                          " default horizontal split below
set splitright                                          " default vertical split right
set t_vb=                                               " No visual bell
set tabstop=2                                           " Set number of columns inserted with tab key
set tags=./tags,tags;$HOME                              " Vim to search for Ctags file in current file's directory, moving up the directory structure until found/home is hit
set textwidth=0                                         " Controls the wrap width you would like to use (character length).  Setting it to default: disabled
set ttyfast                                             " Set fast scroll
set wildignore+=*Zend*,.git,*bundles*                   " Wildmenu ignores these filetypes and extensions
set wildmenu                                            " Make use of the status line to show possible completions of command line commands, file names, and more. Allows to cycle forward and backward though the list. This is called the wild menu.
set wildmode=list:longest                               " On the first tab: a list of completions will be shown and the command will be completed to the longest common command


" *=======================================*
" *----------|Portable Mappings|----------*
" *=======================================*


" comma as mod key
let mapleader = ","


" escape (dvorak)
imap hh <Esc>

" Prevent vim from moving cursor after returning to normal mode
imap <esc> <esc>l

nnoremap Q: <nop>
nmap <leader>s :w<CR>
map <leader>l :set hlsearch!<CR>
map <leader>v :tabe ~/.vimrc<CR>
map <leader>w :set wrap!<CR>:set linebreak<CR>
vmap // y/<C-R>"<CR>
nmap <leader>L ^y$
nmap <leader>a gg<S-v>G<CR>
nmap <leader>A ggyG
inoremap <C-a> <esc>I
inoremap <C-e> <esc>A
map j gj
map k gk

"Autocenter file jumps
nmap G Gzz
nmap n nzz
nmap N Nzz
nmap * *zz
nmap <C-o> <C-o>zz
nmap <C-i> <C-i>zz


" Spell checking
map <leader>z :setlocal spell!<CR>
map <leader>= z=
map <leader>] ]s

" Quick formatting, searching, and common replacements
nmap S :%s//g<LEFT><LEFT>
map <leader>C :%s/,/\r/g<CR>
map <leader>N :%s/\n/,/g<CR>
map <leader>R :%s/\\n/\r/g<CR>
map <leader>" :%s/^\(.*\)$/'\1'/g<CR>
vmap <leader>gu :s/\<./\u&/g<CR>
map <leader>/ :%s/<C-R>///g<CR>
nmap <leader>f /\cfunction\s\{1\}
nmap <leader>` :g/^\s*binding.pry\s*$\\|^\s*byebug\s*$\\|^\s*debugger\s*$\\|^\s*embed()\s*$/d<CR><C-o>
nmap <leader>Z V$%zf

" inserting blank lines
nmap [<space> O<esc>
nmap ]<space> o<esc>


" Autosurround stuff
inoremap [] []<esc>i
inoremap {} {}<esc>i
inoremap () ()<esc>i
inoremap "" ""<esc>i
inoremap '' ''<esc>i
inoremap <% <%<space>%><esc>hhi
inoremap <%= <%=<space>%><esc>hhi
inoremap {% {%<space>%}<esc>hhi
inoremap {{ {{<space>}}<esc>hhi

" --- windows, buffers, tabs ---
nmap <leader>d :bd<CR>
nmap <leader>F :bd!<CR>

nmap L gt
nmap H gT

nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

nnoremap <leader><right> <C-w>L
nnoremap <leader><left> <C-w>H
nnoremap <leader><down> <C-w>J
nnoremap <leader><up> <C-w>K
noremap <leader>h :clo<CR>
noremap <leader>e :tabe<CR>

nmap <leader>. <C-w>=
nmap <leader>\ :Term<CR>

" Open all buffers in tabs
map <leader><tab> :bufdo tab split<CR>

imap <C-S-n> <Nop>
imap <C-N> <Nop>

" *=================================================*
" *----------|Auto-commands and functions|----------*
" *=================================================*

" kill trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Stop the beeping
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

" Source .vimrc on save
augroup reload_vimrc
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" Markdown for `.md` file extensions
autocmd BufNewFile,BufRead *.md set filetype=markdown

" On save, preserve folds and cursor positions

" TODO: Make this conditional on being a writeable file
set viewoptions=cursor,folds
autocmd BufWinLeave *.* mkview! " NOTE -- this breaks with fugitive Glog
autocmd BufWinEnter *.* silent loadview

" disable auto-comment (#) insertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" *=============================*
" *----------|Plugins|----------*
" *=============================*

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Enable Vundle
Plugin 'gmarik/Vundle.vim'

" -- Syntax, languages, & frameworks
Plugin 'asux/vim-capybara'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'elzr/vim-json'
Plugin 'hallison/vim-ruby-sinatra'
Plugin 'hdima/python-syntax'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'joker1007/vim-markdown-quote-syntax'
Plugin 'leafgarland/typescript-vim'
Plugin 'lepture/vim-jinja'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'mxw/vim-jsx'
Plugin 'nelstrom/vim-markdown-folding'
Plugin 'nvie/vim-flake8'
Plugin 'plasticboy/vim-markdown'
Plugin 'thoughtbot/vim-rspec'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rake'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/Jinja'
Plugin 'vim-scripts/applescript.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'vim-scripts/sql_iabbr.vim'
Plugin 'vim-scripts/sqlcomplete.vim'
Plugin 'vim-syntastic/syntastic'

" -- Text objects
Plugin 'bps/vim-textobj-python'
Plugin 'coderifous/textobj-word-column.vim'
Plugin 'kana/vim-textobj-function'
" Plugin 'kana/vim-textobj-line'
Plugin 'kana/vim-textobj-user'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'poetic/vim-textobj-javascript'
Plugin 'thinca/vim-textobj-function-javascript'
Plugin 'vim-scripts/textobj-rubyblock'

" -- Search & file nav
Plugin 'bronson/vim-visual-star-search'
Plugin 'chun-yang/vim-action-ag'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'henrik/vim-indexed-search'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/SearchComplete'

" -- Display
Plugin 'altercation/vim-colors-solarized'
Plugin 'ap/vim-css-color'
Plugin 'lifepillar/vim-solarized8'
Plugin 'luochen1990/rainbow'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" -- Misc Enhancements
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'ervandew/supertab'
Plugin 'gioele/vim-autoswap'
Plugin 'godlygeek/tabular'
Plugin 'junegunn/goyo.vim'
Plugin 'mattn/emmet-vim'
Plugin 'mkomitee/vim-gf-python'
Plugin 'mzlogin/vim-markdown-toc'
Plugin 'olical/vim-enmasse'
Plugin 'scrooloose/nerdcommenter'
Plugin 'sjl/gundo.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tmhedberg/matchit'
Plugin 'tommcdo/vim-exchange'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/ZoomWin'
Plugin 'vim-scripts/zoom.vim'
Plugin 'vimlab/split-term.vim'
Plugin 'wellle/targets.vim'
Plugin 'yggdroot/indentline'

call vundle#end()

" *==========================================================*
" *----------|Plugin-dependent Settings & Mappings|----------*
" *==========================================================*

" user_emmet_leader_key
map <leader>y <C-y>,
map <leader>o :ZoomWin<CR>
nmap <leader>r :RainbowToggle<CR>
nmap <leader>n :NERDTreeFind<CR>
nmap <leader>c :CtrlPClearCache<CR>

"  (The following settings depend on plugins, or macOS

let g:NERDSpaceDelims=1
let g:multi_cursor_prev_key='<C-S-p>'
let g:multi_cursor_quit_key='<Esc>'
let g:multi_cursor_skip_key='<C-x>'
let g:mustache_abbreviations = 1
let g:sparkupExecuteMapping='<c-g>'
let g:split_term_vertical=1
let g:vim_json_syntax_conceal=1
let g:vim_markdown_conceal=0
let g:vim_markdown_folding_disabled = 0
let g:vim_markdown_new_list_item_indent=0

" *--- Syntastic ---*
let g:syntastic_javascript_checkers = ['eslint']
let g:jsx_ext_required = 1 " Allow JSX in normal JS files
let g:syntastic_python_checkers = ['python']
let python_highlight_all = 1
let g:syntastic_python_python_exec = '/Users/colby/.pyenv/shims/python3.6'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" *--- Rainbow Parens ---*
let g:syntastic_javascript_checkers = ['eslint']
let g:rainbow_active = 0

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \]

" *--- CtrlP ---*

map <leader>b :CtrlPBuffer<CR>
map <leader>m :CtrlPMRUFiles<CR>
nnoremap <leader>t :CtrlPBufTag<CR>

" Prevent indexing $HOME dir:
nnoremap <leader>p :call RunCtrlP()<CR>

fun! RunCtrlP()
  lcd %:p:h
  if (getcwd() == $HOME)
    echo "Can't run in \$HOME"
    return
  endif
  CtrlP
endfunc

" Ignoring files for CtrlP
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.git$\|\.hg$\|\.svn$\|/Users/colby$\|\',
      \ 'file': '\.pyc$\|\.pyo$\|\.so$\|\.dll$\|\.png$\|\.jpg\|\.jpeg\|\.svg$\|\.rbc$\|\.rbo$\|\.class$\|\.o$\|\.swp$\',
      \ }

" If ag is available use it as filename list generator instead of 'find'

if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --ignore ''.git'' --ignore ''.DS_Store'' --ignore ''node_modules'' --hidden -g ""'
else
  " Fall back to using git ls-files if Ag is not available
  let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']
endif


" configure ag.vim to always start searching project root instead of the cwd
let g:ag_working_path_mode="r"

" Close buffer via <C-@> using CtrlP // source: https://gist.github.com/rainerborene/8074898
let g:ctrlp_buffer_func = { 'enter': 'CtrlPMappings' }

function! CtrlPMappings()
  nnoremap <buffer> <silent> <C-@> :call <sid>DeleteBuffer()<cr>
endfunction

function! s:DeleteBuffer()
  let path = fnamemodify(getline('.')[2:], ':p')
  let bufn = matchstr(path, '\v\d+\ze\*No Name')
  exec "bd" bufn ==# "" ? path : bufn
  exec "norm \<F5>"
endfunction

" *======================================*
" *----------|Display Settings|----------*
" *======================================*

" cursor shape should look good in terminal vim
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

autocmd BufRead,BufNewFile *.phtml set filetype=html
autocmd BufRead,BufNewFile markdown set filetype=markdown
autocmd BufNewFile,BufRead Gemfile set filetype=ruby

" Spelling
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
hi SpellBad cterm=undercurl


" Indent guides like subl
let g:indentLine_fileTypeExclude = ['text', 'help', 'vim']
let g:indentLine_char = '┊'

" *--- Airline Settings ---*

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 0

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme='dark'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'


" *======================================*
" *----------|Breakable|----------*
" *======================================*
" These settings likely to break on remote machines

colorscheme solarized
set background=dark

let g:solarized_contrast="high"    "default value is normal
let g:solarized_visibility="high"  "default value is normal
let g:solarized_termcolors=16
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=1
highlight Comment cterm=italic

" Easily open files with other apps
nmap <leader>- :! open -a Terminal.app .<CR><CR>
nmap <leader>_ :! open .<CR><CR>
nmap <leader>% :! open %<CR><CR>
command! Mk silent! !open -a "/Applications/Marked 2.app" "%:p"
command! Helpme !subl "%:p"
command! LintJS execute "%!python -m json.tool"

tnoremap <C-h> <space><C-\><C-n>?==\$<CR>g_
