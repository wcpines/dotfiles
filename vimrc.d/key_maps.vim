" *=====================================*
" *----------|Custom Mappings|----------*
" *=====================================*

" comma as mod key
let mapleader = ","

" easy escape (dvorak)
imap hh <Esc>

" Prevent vim from moving cursor after returning to normal mode
imap <esc> <esc>l

vmap <leader>s <esc>:w<CR>
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

" highlight/repeatable
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
let g:netrw_browse_split=0

" select a block
nmap <leader>V ^V$%

" easily toggle find/replace
nmap R :%s//g<LEFT><LEFT>
vmap R :s//g<LEFT><LEFT>

nmap <leader>N :%normal<space>

" remove all instance of  last searched pattern
map <leader>/ :%s///g<CR>
"
" get file path (requires gnu sed!)
nmap <silent> cp :!echo %:p
      \\|gsed -E 's/\/Users\/colby(pines)?\/development\/(\w*-*\w*)*\/
      \\|\/Users\/colby(pines)?\/(\w*-*\w*)*\/
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
nmap <leader>{ a{}<left><cr><esc>O
nmap <leader>} a{}<left>

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

nmap <leader>HT V$%zf

" increment/decrement vis selected nums
vnoremap <C-a> :s/\%V-\=\d\+/\=submatch(0)+1/g<CR>
vnoremap <C-x> :s/\%V-\=\d\+/\=submatch(0)-1/g<CR>

" inserting blank lines
nmap [<space> O<esc>
nmap ]<space> o<esc>


" -------- -------- ----
" windows, buffers, tabs
" -------- -------- ----

" https://stackoverflow.com/questions/4298910/vim-close-buffer-but-not-split-window
nmap <leader>d :bn<bar>bd#<CR>

nmap <leader>F :bd!<CR>
nmap <leader>W :Windows<CR>

nnoremap <leader>g<C-]> :Tags <C-R><C-W> <CR>
nnoremap <leader><C-]> <C-w><C-]><C-w>T
nnoremap <C-]> <C-]>zz

nmap L gt
nmap H gT

" split nav
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

nnoremap <leader><right> <C-w>L
nnoremap <leader><left> <C-w>H
nnoremap <leader><down> <C-w>J
nnoremap <leader><up> <C-w>K
noremap <leader>h :clo<CR>

nmap <leader>. <C-w>=

imap <C-S-n> <Nop>
imap <C-N> <Nop>

iabbrev ivalid invalid
iabbrev Ivalid Invalid
inoreabbrev  appoinment appointment
inoreabbrev  tf @tag :focus
inoreabbrev  ions \|> IO.inspect(label: "<LABEL>")
inoreabbrev  pp \|>
inoreabbrev  ioins \|>IO.inspect(label: "#{__MODULE__}.[func] -- ")
