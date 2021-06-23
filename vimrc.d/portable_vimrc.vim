set belloff=all
syntax on                                               " Enable syntax highlighting
filetype plugin indent on                               " Filetype detection[ON] plugin[ON] indent[ON].This command will use indentation scripts located in the indent folder of your vim installation.
set path+=**                                            " Search into subfolders
set bs=2                                                " Backspace with this value allows you to use the backspace character for moving the cursor over automatically inserted indentation and over the start/end of line.
set expandtab                                           " Use spaces when tab is hit
set gcr=n:blinkon0                                      " Turn off cursor blink
set hidden                                              " Switch buffers and preserve changes w/o saving
set ignorecase                                          " Ignore case for search patterns
set incsearch                                           " Dynamic search (search and refine as you type)
set laststatus=2                                        " Show current mode, file name, file status, ruler, etc.
set modelines=0                                         " Ignore modelines set in files (which would otherwise set custom setting son a per file basis.  The line numbers vim would check to look for options would be set here)
set mouse=a                                             " Enable mouse (NB: SIMBL + MouseTerm enabled for teminal vim--deprecated in later macosx?)
set noerrorbells visualbell t_vb=                       " No visual bell, no error bell sounds
set nohlsearch                                          " Do not highlight all matches (you can toggle this as needed with command below)
set noswapfile                                          " I don't think these have ever been useful
set nowrap                                              " Do not wrap lines of text by default
set number                                              " Set line numbering
set ruler                                               " Always show line/column info at bottom
set shiftwidth=2                                        " Number of characters for indentation made in normal mode ('>)
set showmatch                                           " Highlight search match as you type
set smartcase                                           " Respect cases in search when mixed case detected
set smartindent                                         " Changes indent based on file extension
set softtabstop=2                                       " Determines number of spaces to be inserted for tabs.  Also, backspace key treats space like a tab (so deletes all spaces)
set splitbelow                                          " default horizontal split below
set splitright                                          " default vertical split right
set tabstop=2                                           " Set number of columns inserted with tab key
set tags=./tags,tags;$HOME                              " Vim to search for Ctags file in current file's directory, moving up the directory structure until found/home is hit
set textwidth=0                                         " Controls the wrap width you would like to use (character length).  Setting it to default: disabled
set wildignore+=*Zend*,.git,*bundles*                   " Wildmenu ignores these filetypes and extensions
set wildmenu                                            " Make use of the status line to show possible completions of command line commands, file names, and more. Allows to cycle forward and backward though the list. This is called the wild menu.
set wildmode=list:longest                               " On the first tab: a list of completions will be shown and the command will be completed to the longest common command

" comma as mod key
let mapleader = ","

" easy escape (dvorak)
imap hh <Esc>

" Prevent vim from moving cursor after returning to normal mode
imap <esc> <esc>l

nmap <leader>s :w<CR>
map <leader>l :set hlsearch!<CR>
map <leader>v :tabe ~/.vimrc<CR>
map <leader>e :tabe ~/.env<CR>
map <leader>w :set wrap!<CR>:set linebreak<CR>
nmap Y y$
nmap <C-b> <C-^>

"Autocenter file jumps
nmap G Gzz
nmap * *zz
nmap # #zz
nmap <C-o> <C-o>zz
nmap <C-i> <C-i>zz

" sane wrapped-line navigation
map j gj
map k gk

" Spell checking
map <leader>z :setlocal spell!<CR>
map <leader>= z=
map <leader>] ]s

" unmap unused crap
nnoremap q; q:
nmap q: <nop>
nmap Q: <nop>
nmap Q <nop>

" highlight/replace word--repeatable
noremap <C-n> viw<C-n>
vnoremap <C-n> y/<C-R>"<CR>Ngn<C-g>
vnoremap . :normal .<CR>

" select-all
nmap <leader>a gg<S-v>G<CR>

" copy/paste all lines matching last search pattern
nmap <leader>y :let @a=""<CR>:g/<C-r>//y A<CR><C-o>
nmap <leader>D :let @a=""<CR>:g/<C-r>//d A<CR><C-o>
nmap <leader>p "Ap

" Open netrw like nerd tree
nmap <leader>n :Vex 20<CR>
let g:netrw_winsize=0
let g:netrw_preview=1    " preview opened filen in v-split
let g:netrw_browse_split = 0

" select a block
nmap <leader>V ^V$%

" easily toggle find/replace
nmap S :%s//g<LEFT><LEFT>

" remove all instance of  last searched pattern
map <leader>/ :%s///g<CR>
"
" get file path (requires gnu sed!)
nmap <silent> cp :!echo %:p
      \\|gsed -E 's/\/Users\/colbyp?\/development\/\w*-*\w*\/
      \\|\/Users\/colbyp?
      \\///g'
      \\|tr -d '\n'
      \\|pbcopy<CR>

" Get full file path
nmap <silent> cf :let @* = expand("%:p")<CR>


" -----------------
" Quick formatting
" -----------------

" barfing brackets
nmap <leader>( f(x$p
nmap <leader>) f)x$p
nmap <leader>{ f{x$p
nmap <leader>} f}x$p

nmap <leader>S vip:sort u<cr>

" convert elixir module attribute to variable
nmap <leader>@ xea<space>=<esc>

" convert elixir named function to assigned anonymous function
nmap <leader>- ^dwf(ds)i<space>=<space>fn<space><esc>$ciw-><esc>=ip

" wrap in an elixir map
nmap <leader>% i%{<esc>A}<esc>

" git conflict nav
nmap ]x /^<<<<<<<<CR>zz
nmap [x /^>>>>>>><CR>zz
nmap ]= /^=======<CR>zz


" remove debuggers
nmap <leader>` :g/
      \^\s*binding.pry\s*$
      \\\|.*require "pry".*binding.pry$
      \\\|^\s*byebug\s*$
      \\\|^.*debugger.*$
      \\\|^\s*.*require IEx.*\s*$
      \\\|^\s*.*IEx.pry().*\s*$
      \\\|^\s*require IEx; IEx.pry\s*$
      \\\|^\s*embed()\s*$
      \/d<CR><C-o>


" fold and unfold everything but current func (elixir/js)
nmap <leader>HT V$%zf
nmap <leader>HE $%jzfGk$%kzfgg

" increment/decrement vis selected nums
vnoremap <C-a> :s/\%V-\=\d\+/\=submatch(0)+1/g<CR>
vnoremap <C-x> :s/\%V-\=\d\+/\=submatch(0)-1/g<CR>

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

" -------- -------- ----
" windows, buffers, tabs
" -------- -------- ----

" https://stackoverflow.com/questions/4298910/vim-close-buffer-but-not-split-window
nmap <leader>d :bn<bar>bd#<CR>:clo<CR>

nmap <leader>F :bd!<CR>
nmap <leader>W :Windows<CR>

nmap L gt
nmap H gT

" split nav
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

nnoremap <leader><right> <C-w>L
nnoremap <leader><left> <C-w>H
nnoremap <leader><down> <C-w>J
nnoremap <leader><up> <C-w>K
noremap <leader>h :clo<CR>

nmap <leader>. <C-w>=

imap <C-S-n> <Nop>
imap <C-N> <Nop>

autocmd FileType sql set commentstring=--%s

" open quickfix item in vert split
autocmd! FileType qf nnoremap <buffer> <leader><Enter> <C-w><Enter><C-w>L:cclo<CR>

command! Src source $MYVIMRC

" Read plist files
autocmd BufWritePost,FileWritePost *.plist !plutil -convert binary1 <afile>

" Normalize comment keywords across all filetypes
autocmd Syntax * syntax keyword Todo OPTIMIZE FIXME TODO TBD NOTE containedin=.*Comment

" kill trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif


" read correct filetype from file extension
autocmd BufNewFile,BufRead *.jbuilder set filetype=ruby
autocmd BufRead,BufNewFile *_spec.rb set filetype=ruby
autocmd BufRead,BufNewFile *_spec.rb set syntax=rspec
autocmd BufNewFile,BufRead Gemfile set filetype=ruby
autocmd BufRead,BufNewFile *.phtml set filetype=html
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufRead,BufNewFile markdown set filetype=markdown

" https://vi.stackexchange.com/a/13351
function! NetrwOpenMultiTab(current_line,...) range
  " Get the number of lines.
  let n_lines =  a:lastline - a:firstline + 1

  " This is the command to be built up.
  let command = "normal "

  " Iterator.
  let i = 1

  " Virtually iterate over each line and build the command.
  while i < n_lines
    let command .= "tgT:" . ( a:firstline + i ) . "\<CR>:+tabmove\<CR>"
    let i += 1
  endwhile
  let command .= "tgT"

  " Restore the Explore tab position.
  if i != 1
    let command .= ":tabmove -" . ( n_lines - 1 ) . "\<CR>"
  endif

  " Restore the previous cursor line.
  let command .= ":" . a:current_line  . "\<CR>"

  " Check function arguments
  if a:0 > 0
    if a:1 > 0 && a:1 <= n_lines
      " The current tab is for the nth file.
      let command .= ( tabpagenr() + a:1 ) . "gt"
    else
      " The current tab is for the last selected file.
      let command .= (tabpagenr() + n_lines) . "gt"
    endif
  endif
  " The current tab is for the Explore tab by default.

  " Execute the custom command.
  execute command
endfunction

" Define mappings.
augroup NetrwOpenMultiTabGroup
  autocmd!
  autocmd Filetype netrw vnoremap <buffer> <silent> <expr> t ":call NetrwOpenMultiTab(" . line(".") . "," . "v:count)\<CR>"
  autocmd Filetype netrw vnoremap <buffer> <silent> <expr> T ":call NetrwOpenMultiTab(" . line(".") . "," . (( v:count == 0) ? '' : v:count) . ")\<CR>"
augroup END

" transform clipboard contents to only lowercase alpha for use with fuzzy file finder(s)
command! Fuz silent! !echo -n $(pbpaste) | gsed "s/[^[:alpha:]]//g" | tr '[:upper:]' '[:lower:]' | pbcopy
nmap <leader>Z :Fuz<CR><leader>g
