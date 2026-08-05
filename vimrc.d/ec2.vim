" Standalone Vim config for basic remote machines such as EC2 instances.
" Use with: vim -u ~/dotfiles/vimrc.d/ec2.vim
" Or include from ~/.vimrc with: source ~/dotfiles/vimrc.d/ec2.vim
"
" This file avoids:
" - Neovim-only settings
" - plugin commands
" - macOS-only commands
" - system clipboard registers, which are often unavailable over SSH

set nocompatible

syntax enable
filetype plugin indent on
silent! runtime macros/matchit.vim

" -----------------
" Base settings
" -----------------

if exists('&belloff')
  set belloff=all
endif

set backspace=indent,eol,start
set conceallevel=0
set expandtab
set hidden
set ignorecase
set incsearch
set laststatus=2
set modelines=0
set mouse=a
set noerrorbells visualbell t_vb=
set nohlsearch
set noswapfile
set nowrap
set number
set ruler
set shiftwidth=2
set showmatch
set matchtime=3
set smartcase
set smartindent
set softtabstop=2
set splitbelow
set splitright
set tabstop=2
set tags=./tags,tags;$HOME
set textwidth=0
set wildignore+=*Zend*,.git,*bundles*
set wildmenu
set wildmode=list:longest

if exists('&matchpairs')
  set matchpairs=(:),{:},[:],<:>
endif

" Do not set 'clipboard'. Basic Vim on EC2 often has no system clipboard.
" Use normal Vim registers instead: yy, p, "ay, "ap, etc.

" -----------------
" Leader and mappings
" -----------------

let mapleader = ","

" easy escape, matching the local minimal config
inoremap hh <Esc>
inoremap <Esc> <Esc>l

" saving
nnoremap <leader>s :w<CR>
vnoremap <leader>s <Esc>:w<CR>

" toggles
nnoremap <leader>l :set hlsearch!<CR>
nnoremap <leader>w :set wrap!<CR>:set linebreak<CR>
nnoremap <leader>z :setlocal spell!<CR>
nnoremap <leader>= z=
nnoremap <leader>] ]s

" open this config
nnoremap <leader>v :tabe ~/.vimrc<CR>

" useful defaults
nnoremap Y y$
nnoremap G Gzz
nnoremap * *zz
nnoremap # #zz
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz
nnoremap j gj
nnoremap k gk
vnoremap . :normal .<CR>
noremap <leader>a ggVG
nnoremap <leader>y :%yank<CR>

" copy/paste all lines matching last search pattern to register a
nnoremap <leader>Y :let @a=""<CR>:g/<C-r>//yank A<CR><C-o>
nnoremap <leader>P "Ap

" netrw file browser, included with Vim
nnoremap <leader>n :Vex 20<CR>
let g:netrw_winsize=0
let g:netrw_preview=1
let g:netrw_browse_split=0

" path helpers that do not need a system clipboard
nnoremap <silent> cp :let @" = expand('%') =~ '^/' ? substitute(expand('%'), '^' . $HOME . '/[^/]\+/', '', '') : expand('%')<CR>:echo @"<CR>
nnoremap <silent> cf :let @" = expand('%:p')<CR>:echo @"<CR>

" select a block
nnoremap <leader>V $V%

" easily toggle find/replace
nnoremap S :%s//g<Left><Left>

" remove all instances of last searched pattern
nnoremap <leader>/ :%s///g<CR>

" unmap unused keys
nnoremap q; q:
nnoremap q: <Nop>
nnoremap Q: <Nop>
nnoremap Q <Nop>

" quick formatting
nnoremap <leader>S vip:sort u<CR>
nnoremap <leader>@ xea =<Esc>
nnoremap <leader>- ^dwf(ds)i = fn <Esc>$ciw-><Esc>=ip

" remove common debugger lines
nnoremap <leader>` :g/^\s*binding\.pry\s*$\|^\s*byebug\s*$\|^\s*debugger\s*$\|^\s*require IEx; IEx\.pry\s*$\|^\s*IEx\.pry()\s*$\|^\s*embed()\s*$\|^\s*IO\.inspect.*$/d<CR><C-o>

" increment/decrement visually selected numbers
vnoremap <C-a> :s/\%V-\=\d\+/\=submatch(0)+1/g<CR>
vnoremap <C-x> :s/\%V-\=\d\+/\=submatch(0)-1/g<CR>

" inserting blank lines
nnoremap [<Space> O<Esc>
nnoremap ]<Space> o<Esc>

" windows, buffers, tabs
nnoremap <leader>d :bnext<Bar>bdelete #<CR>
nnoremap <leader>F :bdelete!<CR>
nnoremap L gt
nnoremap H gT
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>h :close<CR>

inoremap <C-S-n> <Nop>
inoremap <C-N> <Nop>

" abbreviations
iabbrev ivalid invalid
iabbrev Ivalid Invalid
inoreabbrev appoinment appointment
inoreabbrev appoitnment appointment
inoreabbrev tf @tag :focus
inoreabbrev ions \|> IO.inspect(label: "<LABEL>")
inoreabbrev pp \|>
inoreabbrev ioins \|>IO.inspect(label: "#{__MODULE__}.[func] -- ")
inoreabbrev cdl console.log("")
inoreabbrev appointmetns appointments

" -----------------
" Commands and helpers
" -----------------

command! Src source ~/.vimrc
command! CurlFmt call FormatCurl()
command! SqlArgs call SqlArgs()
command! Ts execute "tabe ~/scratch/scratch.ts"
command! Json execute "tabe ~/scratch/scratch.json"
command! Sql execute "tabe ~/scratch/scratch.sql"
command! Exs execute "tabe ~/scratch/scratch.exs"
command! Gql execute "tabe ~/scratch/scratch.gql"
command! Html execute "tabe ~/scratch/scratch.html"
command! Shell execute "tabe ~/scratch/scratch.sh"
command! -range=% LintJson execute "<line1>,<line2>!jq '.'" | set ft=json
command! -range=% Pgfmt execute "<line1>,<line2>!pg_format --comma-end --keyword-case 2 --function-case 2 --spaces 2"
command! -nargs=1 RgCSV execute '!(head -n1 % && grep -n ' . shellescape(<args>) . ' %) > temp.csv && mv temp.csv %'

function! StripTrailingWs()
  %s/\s\+$//e
endfunction

function! FormatCurl()
  %s/ -H/ \\\r  -H/g
endfunction

function! SqlArgs()
  %s/^/'/g
  %s/$/'/g
  %s/\n/,\r/g
  normal Gdd$xA)
  normal ggI(
endfunction

function! MapFromJson()
  LintJson
  %s/"//g
  %s/null/nil/g
  %s/\(\d\+-\d\+-\d\+T.*\),/"\1",/g
endfunction

" -----------------
" Autocommands
" -----------------

augroup ec2_vimrc
  autocmd!
  autocmd FileType sql setlocal commentstring=--%s
  autocmd Syntax * syntax keyword Todo OPTIMIZE FIXME TODO TBD NOTE containedin=.*Comment
  autocmd BufWritePre * call StripTrailingWs()
  autocmd BufRead,BufNewFile *.phtml setlocal filetype=html
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
  autocmd BufRead,BufNewFile markdown setlocal filetype=markdown
augroup END
