"#######################"
"*---Custom Plugins---*"
"#######################"


" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'bronson/vim-visual-star-search'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'elzr/vim-json'
Plugin 'ervandew/supertab'
Plugin 'gioele/vim-autoswap'
Plugin 'gmarik/Vundle.vim'
Plugin 'godlygeek/tabular'
Plugin 'joker1007/vim-markdown-quote-syntax'
Plugin 'kana/vim-textobj-user'
Plugin 'mattn/emmet-vim'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'mzlogin/vim-markdown-toc'
Plugin 'nelstrom/vim-markdown-folding'
Plugin 'rking/ag.vim'
Plugin 'ryanss/vim-hackernews'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tmhedberg/matchit'
Plugin 'tommcdo/vim-exchange'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-surround'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/ZoomWin'
Plugin 'vim-scripts/textobj-rubyblock'
Plugin 'vim-scripts/visSum.vim'
Plugin 'vim-scripts/zoom.vim'
Plugin 'yggdroot/indentline'
call vundle#end()
"#########################"
"*---Basic  Settings---*"
"#########################"

autocmd BufEnter * lcd %:p:h                            " Set working directory to that of the current file
syntax on                                               " Enable syntax highlighting
filetype off                                            " Filetype detection[OFF]
filetype plugin indent on                               " Filetype detection[ON] plugin[ON] indent[ON].This command will use indentation scripts located in the indent folder of your vim installation.
set autoindent                                          " Copy indent of previous line
set bs=2                                                " Backspace with this value allows to use the backspace character for moving the cursor over automatically inserted indentation and over the start/end of line.
set expandtab                                           " Use spaces when tab is hit
set hidden                                              " Switch buffers and preserve changes w/o saving
set gcr=n:blinkon0                                      " Turn off cursor blink
set ignorecase                                          " Ignore case for search patterns
set incsearch                                           " Dynamic search (search and refine as you type)
set laststatus=2                                        " Show current mode, file name, file status, ruler, etc.
set modelines=0                                         " Ignore modelines set in files (which would otherwise set custom setting son a per file basis.  The line numbers vim would check to look for options would be set here)
set mouse=a                                             " Enable mouse (NB: SIMBL + MouseTerm enabled for teminal vim)
set nohlsearch                                          " Do not highlight all matches (you can toggle this as needed with command below)
set nocompatible                                        " Get rid of Vi compatibility mode. SET FIRST!
set nowrap                                              " Do not wrap lines of text by default
set number                                              " Set line numbering
set ruler                                               " Always show line/column info at bottom
set shiftwidth=2                                        " Number of characters for indentation made in normal mode ('>)
set showmatch                                           " Highlight search match as you type
set smartindent                                         " Changes indent based on file extension
set softtabstop=2                                       " Determines number of spaces to be inserted for tabs.  Also, backspace key treats four space like a tab (so deletes all spaces)
set tabstop=2                                           " Set number of columns inserted with tab key
set textwidth=0                                         " Controls the wrap width you would like to use (character length).  Setting it to default: disabled
set ttyfast                                             " Set fast scroll
set wildignore+=*Zend*,.git,*bundles*                   " Wildmenu ignores these filetypes and extensions
set wildmenu                                            " Make use of the status line to show possible completions of command line commands, file names, and more. Allows to cycle forward and backward though the list. This is called the wild menu.
set wildmode=list:longest                               " On the first tab: a list of completions will be shown and the command will be completed to the longest common command
set t_vb=                                               " No visual bell
"set statusline=%<\ [%n]:%F\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)


"#####################"
"*---My Mappings*---*"
"#####################"

let mapleader = ","

nnoremap ; :

" ** Buffer management **
nnoremap <CR> :bp<CR>
nnoremap <S-CR> :bn<CR>
map <leader>d :bd<CR>
map <leader>f :bd!<CR>

let g:mustache_abbreviations = 1
let g:NERDSpaceDelims=1

" **CtrlP Settings**
map <leader>b :CtrlPBuffer<CR>
map <leader>m :CtrlPMRUFiles<CR>
map <leader>p :CtrlP<CR>
nnoremap <leader>t :CtrlPBufTag<CR>

imap <C-S-n> <Nop>
imap <C-N> <Nop>
" Ignoring files with CtrlP
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.git$\|\.hg$\|\.svn$\|/Users/colby$\|\',
      \ 'file': '\.pyc$\|\.pyo$\|\.so$\|\.dll$\|\.png$\|\.jpg\|\.jpeg\|\.svg$\|\.rbc$\|\.rbo$\|\.class$\|\.o$\|\~$\',
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



" user_emmet_leader_key
map <leader>y <C-y>,

" Search by filename
" Let g:ctrlp_by_filename = 1

" Close buffer via <C-@> using CtrlP SOURCE: https://gist.github.com/rainerborene/8074898
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

" configure ag.vim to always start searching project root instead of the cwd
let g:ag_working_path_mode="r"

map <leader>o :ZoomWin<CR>
map <leader><tab> :bufdo tab split<CR>

" Window splits convenience
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-l> <C-w>l
nnoremap <D-L> <C-w>L
nnoremap <D-H> <C-w>H
nnoremap <D-J> <C-w>J
nnoremap <D-K> <C-w>K

nmap <leader>- :! open -a Terminal.app .<CR>
nmap <leader>_ :! open .<CR>
nnoremap <leader>\ :vnew<CR>

set splitbelow
set splitright


" Set movement to be intuitive for wrapped lines
map j gj
map k gk

"###############################################
"*--Add standard key mappings to vim paradigm--*
"###############################################

" Shift enables visual select
imap <S-A-Left> <esc>vb
imap <S-A-Right> <esc>ve
imap <S-D-Left> <esc>v0
imap <S-D-Right> <esc>v$
imap <S-Down> <esc>v<Down>
imap <S-LEFT> <esc>v<LEFT>
imap <S-RIGHT> <esc>v<RIGHT>
imap <S-Up> <esc>v<Up>
nmap <S-A-Left> vb
nmap <S-A-Right> ve
nmap <S-D-Left> v0
nmap <S-D-Right> v$
nmap <S-Down> v<Down>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>
nmap <S-Up> v<Up>
smap <S-Down> <Down>
vmap <S-A-Left> b
vmap <S-A-Right> e
vmap <S-D-Left> 0
vmap <S-D-Right> $
vmap <S-Down> <Down>
vmap <S-Left> <Left>
vmap <S-Right> <Right>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
vmap <S-A-Up> {
vmap <S-A-Down> }
imap <S-A-Up> <esc>v{
imap <S-A-Down> <esc>v}
nmap <S-A-Up> v{
nmap <S-A-Down> v}
vmap <S-D-Up> gg
vmap <S-D-Down> G
imap <S-D-Up> <esc>vgg
imap <S-D-Down> <esc>vG
nmap <S-D-Up> vgg
nmap <S-D-Down> vG

"Standard save and select-all + appending, undoing

imap <C-a> <D-Left>
imap <C-e> <D-Right>
imap <D-z> <C-o>u
nmap <D-z> u
imap <D-Z> <C-o><C-r>
nmap <D-Z> <C-r>
map <D-s> :w<CR>
imap <D-s> <Esc>:w<CR>
map <D-a> gg<S-v>G<CR>
nmap <D-=> :ZoomIn<CR>
nmap <D-_> :ZoomOut<CR>

" Enable copy/paste
imap <D-v> <C-r>+
map <D-v> "+P
vmap <D-c> "+y
cnoremap <D-v> <C-r>+

" Enable standard tab navigation
imap <D-t> <esc>:tabnew<CR>
map <D-t> :tabnew<CR>
map <D-w> :clo<CR>
map <C-Tab> gt
imap <C-Tab> <esc>gt
map <C-S-Tab> gT
imap <C-S-Tab> <esc>gT

" Sublime text muscle memory
map <D-P> :

" Prevent vim from moving cursor after returning to normal mode
imap <esc> <esc>l

" Easy copy/paste of entire files (that preserves formatting)
map <leader>ll :read !pbpaste<CR>
map <leader>c :%w !pbcopy<CR>
imap hh <Esc>

map <leader>l :set hlsearch!<CR>
map <leader>q :set syntax=markdown<CR>
map <leader>v :e ~/.vimrc<CR>
map <leader>w :set wrap!<CR>:set linebreak<CR>
map <leader>s :w<CR>
nmap <C-S-space> O<esc>
nmap <S-space> o<esc>
imap <D-CR> <esc>o
nmap <D-CR> <esc>o
vmap // y/<C-R>"<CR>
map <leader>n :NERDTreeToggle<CR>

" Change indents from 2 to 4 spaces for python TODO: make less crappy?
nmap S :%s//g<LEFT><LEFT>
nnoremap Q <nop>

" Spell checking
map <leader>z :setlocal spell!<CR>
map <leader>= z=
map <leader>] ]s


" Quick formatting and common replacements
map <leader>ccc :%s/,/\r/g<CR>
map <leader>nnn :%s/\n/,/g<CR>
map <leader>rrr :%s/\\n/\r/g<CR>
map <leader>k :%s/\s\+$//e
map <leader>" :%s/^\(.*\)$/'\1'/g<CR>
vmap <leader>gu :s/\<./\u&/g<CR>
map <leader>/ :%s/<C-R>///g<CR>


" Autosurround stuff
imap [] []<Left>
imap {} {}<Left>
imap () ()<Left>
imap "" ""<Left>
imap <% <%<space>%><Left><Left><Left>
imap <%= <%=<space>%><Left><Left><Left>

"Autocenter file jumps
nmap G Gzz
nmap n nzz
nmap N Nzz

"Multi-cursor settings

let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" Easily shift line positions
nmap <D-Up> ddkP
nmap <D-Down> ddp
imap <C-d> <esc>ddi

let g:sparkupExecuteMapping='<c-g>'

"#########################"
"*---Display Settings---*"
"#########################"

" disable auto-comment (#) insertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Custom HL and colors for spellcheck and cursorline
autocmd BufRead,BufNewFile *.phtml set filetype=html
autocmd BufRead,BufNewFile markdown set filetype=markdown
autocmd BufNewFile,BufRead Gemfile set filetype=ruby
" highlight Pmenu guibg=brown gui=bold
hi CursorLine   cterm=NONE ctermbg=darkgray guibg=darkgray guifg=white
hi clear SpellBad "clear spelling default highlight
" hi SpellBad cterm=underline ctermfg=brown


" indent guides like subl
let g:indentLine_fileTypeExclude = ['text', 'sh', 'help']
let g:indentLine_char = '┊'

" ** Airline Settings **

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'


" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 0

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" .md as markdown
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

set guifont=Menlo:h13
if has('gui_running')
  colorscheme solarized
  let g:solarized_contrast="high"    "default value is normal
  let g:solarized_visibility="high"  "default value is normal
  set background=dark
endif

" Stop the beeping
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

" Source .vimrc on save
augroup reload_vimrc " {
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" Markdown for `.md` file extensions
autocmd BufNewFile,BufRead *.md set filetype=markdown

let g:vim_markdown_folding_disabled = 1


" Used for opening markdown files in Marked2
command! Mk silent! !open -a "/Applications/Marked 2.app" "%:p"

" On save, preserve folds and cursor positions 
set viewoptions=cursor,folds
autocmd BufWinLeave *.* mkview!
autocmd BufWinEnter *.* silent loadview
