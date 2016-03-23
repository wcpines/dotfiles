"#######################"
"*---Custom Plugins---*"
"#######################"

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'bronson/vim-visual-star-search'
Plugin 'elzr/vim-json'
Plugin 'ervandew/supertab'
Plugin 'kien/ctrlp.vim'
Plugin 'gmarik/Vundle.vim'
Plugin 'godlygeek/tabular'
Plugin 'joker1007/vim-markdown-quote-syntax'
Plugin 'nelstrom/vim-markdown-folding'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tmhedberg/matchit'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive' 
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/ZoomWin'
Plugin 'vim-scripts/visSum.vim'
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
set cursorline                                          " Show cursor line 
set expandtab                                           " Use spaces when tab is hit 
set hidden                                              " Switch buffers and preserve changes w/o saving
set ignorecase                                          " Ignore case for search patterns
set incsearch                                           " Dynamic search (search and refine as you type)
set laststatus=2                                        " Show current mode, file name, file status, ruler, etc.
set lcs=tab:>>,trail:_                                  " Show trailing ws
set modelines=0                                         " Ignore modelines set in files (which would otherwise set custom setting son a per file basis.  The line numbers vim would check to look for options would be set here)
set mouse=a                                             " Mouse scroll
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
set t_vb=
"set statusline=%<\ [%n]:%F\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%) 

"#####################"
"*---My Mappings*---*"
"#####################"

let mapleader = ","
nnoremap ; :

" ** Buffer management ** 

nnoremap <CR> :bn<CR>
nnoremap <S-CR> :bp<CR>
map <leader>b :CtrlPBuffer<CR>

" easy buffer closing, and force closing
map <leader>d :bd<CR>
map <leader>f :bd!<CR>

let g:NERDSpaceDelims=1

" Ignoring shit with CtrlP
let g:ctrlp_custom_ignore = {
                       \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                       \ 'file': '\.pyc$\|\.pyo$\|\.rbc$|\.rbo$\|\.class$\|\.o$\|\~$\',
                       \ }

" If ag is available use it as filename list generator instead of 'find'
if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor
    let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --ignore ''.git'' --ignore ''.DS_Store'' --ignore ''node_modules'' --hidden -g ""'
endif

" ** Window/workspace management **

" Enable standard tab navigation
imap <D-t> <esc>:tabnew<CR>
map <D-t> :tabnew<CR>
map <D-w> :clo<CR>
map <C-Tab> gt
imap <C-Tab> <esc>gt
map <C-S-Tab> gT
imap <C-S-Tab> <esc>gT
map <leader>o :only<CR>
map <leader>bt :bufdo tab split<CR>

" Window splits convenience
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>\ :vnew<CR>
set splitbelow
set splitright

" ** Project workflow ** 
map <leader>m :CtrlPMRUFiles<CR>
map <leader>n :NERDTreeToggle<CR>

" Misc

" Set movement to be intuitive for wrapped lines
map j gj
map k gk

" Prevent vim from moving cursor after returning to normal mode
imap <esc> <esc>l
imap <S-LEFT> <esc>v<LEFT>
imap <S-RIGHT> <esc>v<RIGHT>
imap hh <Esc>
imap <leader>s <Esc>:w<CR>
imap <D-s> <Esc>:w<CR>  
map <D-s> :w<CR>  
map <D-a> gg<S-v>G<CR>  
map <leader>l :set hlsearch!<CR>  
map <leader>v :e ~/.vimrc<CR>
map <leader>w :set wrap!<CR>:set linebreak<CR>
map <C-S-space> O<esc>
map <S-space> o<esc>
vmap // y/<C-R>"<CR> 
map <leader>/ :%s/<C-R>///g<CR>
nmap S :%s//g<LEFT><LEFT>
nnoremap Q <nop>

" Spell checking
map <leader>z :setlocal spell!<CR>
map <leader>= z=
map <leader>] ]s 

" Easy copy/paste of entire files
map <leader>ll :read !pbpaste<CR>
map <leader>c :%w !pbcopy<CR>

" Quick formatting 
map <leader>ccc :%s/,/\r/g<CR>                              
map <leader>nnn :%s/\n/,/g<CR>
map <leader>rrr :%s/\\n/\r/g<CR>
map <leader>k :%s/\s\+$//e
map <leader>ttt :%s/\|/ /g<CR>                             

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


" Enable standard mac commands for copy/paste 
imap <D-v> <C-r>+
map <D-v> "+P
vmap <D-c> "+y

" Easily shift line positions
nmap <D-Up> ddkP
nmap <D-Down> ddp
imap <C-d> <esc>ddi


let g:sparkupExecuteMapping='<c-g>'

" Move between windows and tabs.  Function at bottom
nnoremap mt :call MoveToNextTab()<CR><C-w>H  
nnoremap mT :call MoveToPrevTab()<CR><C-w>H  

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
hi SpellBad cterm=underline ctermfg=brown           
"Change autocomplete color
:highlight Pmenu ctermbg=238 gui=bold

" highlight stuff after 80 chacters
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

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


" .md as markdown
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

"GUI settings
if has('gui_running')
  colorscheme solarized
  set guifont=Menlo:h18
  let g:solarized_contrast="high"    "default value is normal 
  let g:solarized_visibility="high"    "default value is normal 
  set background=dark
end

" Stop the beeping
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

" Source .vimrc on each write 
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" Markdown
autocmd BufNewFile,BufRead *.md set filetype=markdown
let g:vim_markdown_folding_disabled = 1


" Used for opening markdown files in Marked2
command! Mk silent! !open -a "/Applications/Marked 2.app" "%:p" 
