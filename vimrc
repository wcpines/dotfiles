                                                                                    "#########################"
                                                                                    "*---Startup Settings---*"
                                                                                    "#########################"
                                                                                    
set nocompatible                                        " get rid of Vi compatibility mode. SET FIRST!
syntax on                                               " enable syntax highlighting
filetype off                                             " filetype detection[OFF] 
filetype plugin indent on                               " filetype detection[ON] plugin[ON] indent[ON].This command will use indentation scripts located in the indent folder of your vim installation.

"  --  PLUGIN MANAGER --
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive' 
call vundle#end()            

set modelines=0                                         " Ignore modelines set in files (which would otherwise set custom setting son a per file basis.  The line numbers vim would check to look for options would be set here)
set ruler                                               " Always show line/column info at bottom
set number                                              " Set line numbering
set mouse=a                                             " Mouse scroll
set showmatch                                           " Highlight search match as you type
set nohlsearch                                          " Do not highlight all matches (you can toggle this as needed with command below)
set incsearch                                           " Dynamic search (search and refine as you type)
set autoindent                                          " Copy indent of previous line
set smartindent                                         " Changes indent based on file extension         
set tabstop=4                                           " Set number of columns inserted with tab key
set softtabstop=4                                       " Determines number of spaces to be inserted for tabs.  Also, backspace key treats four space like a tab (so deletes all spaces)
set shiftwidth=4                                        " Number of characters for indentation made in normal mode ('>)
set expandtab                                           " Use spaces when tab is hit 
set ignorecase                                           " Ignore case for search patterns
set nowrap                                              " Do not wrap lines of text by default
set ttyfast                                             " Set fast scroll
set textwidth=0                                         " Controls the wrap width you would like to use (character length).  Setting it to default: disabled
set bs=2                                                " Backspace with this value allows to use the backspace character for moving the cursor over automatically inserted indentation and over the start/end of line.
set wildmenu                                            " Make use of the status line to show possible completions of command line commands, file names, and more. Allows to cycle forward and backward though the list. This is called the wild menu.
set wildmode=list:longest                               " On the first tab: a list of completions will be shown and the command will be completed to the longest common command
set wildignore+=*Zend*,.git,*bundles*                   " Wildmenu ignores these filetypes and extensions
set laststatus=2                                        " Show current mode, file name, file status, ruler, etc.
"set statusline=%<\ [%n]:%F\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%) 

                                                                                    "####################"
                                                                                    "*---My Mappings*---*"
                                                                                    "####################"

let mapleader = ","
nnoremap ; :
nnoremap <CR> <C-^> 
nnoremap <leader>' viw<esc>a"<esc>hbi"<esc>lel
"fix crappy copy due to clipboard absence (only works on local)
map <leader>c :%w !pbcopy<CR>
map <leader>cl :set cursorline!<CR>
map <leader>l :set hlsearch!<CR>  
"fix crappy paste due to clipboard absence (only works on local)
map <leader>ll :read !pbpaste<CR>
map <leader>m :set mouse=a\|:se nu<CR>
map <leader>mm :set mouse-=a\|:se nonu<CR>
map <leader>n :set number!<CR>
map <leader>o :only<CR>
map <leader>p :set paste!<CR>
map <leader>w :set wrap!<CR>:set linebreak<CR>
map <leader>s :w<CR>
map <leader>v :e ~/.vimrc<CR>
map <leader>z :setlocal spell!<CR>
map <leader>= <c-w>=
map <leader>/ /<C-p>
map <leader>bbb /{"bid_request.*}}<CR>:v//d<CR>:noh<CR>
map <leader>ccc :%s/,/\r/g<CR>                              
map <leader>nnn :%s/\n/,/g<CR>
map <leader>rrr :%s/\r/\r/g<CR>
nmap S :%s//g<LEFT><LEFT>
imap hh <Esc>
vmap hh <Esc>
vmap // y/<C-R>"<CR> 
"Note that the following meta commands for these don't work with Terminal.app due to existing application shortcuts
vmap <D-j> gj
vmap <D-k> gk
vmap <D-4> g$
vmap <D-6> g^
vmap <D-0> g^
nmap <D-j> gj
nmap <D-k> gk
nmap <D-4> g$
nmap <D-6> g^
map <D-0> g^
nmap <D-Up> ddkP
nmap <D-Down> ddp
imap <C-d> <esc>ddi

                                                                                    "################################"
                                                                                    "*---Easier splits navigation---*"
                                                                                    "################################"
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
let g:sparkupExecuteMapping='<c-g>'

" Custom HL and colors for spellcheck and cursorline
autocmd BufRead,BufNewFile *.phtml set filetype=html
autocmd BufRead,BufNewFile markdown set filetype=markdown
highlight Pmenu guibg=brown gui=bold
hi CursorLine   cterm=NONE ctermbg=darkgray guibg=darkgray guifg=white 
hi clear SpellBad "clear spelling default highlight
hi SpellBad cterm=underline ctermfg=brown           
"Change autocomplete color
:highlight Pmenu ctermbg=238 gui=bold

" Source upon save
if has("autocmd")
      autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Markdown
autocmd BufNewFile,BufRead *.md set filetype=markdown

" Airline Settings


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
                                                                                    "########################
                                                                                    "*---Custom Commands---*"
                                                                                    "########################

" used for opening markdown files in Mark2
command! Marked silent! !open -a "/Applications/Marked 2.app" "%:p" 
