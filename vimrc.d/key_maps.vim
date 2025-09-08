" *=====================================*
" *----------|Custom Mappings|----------*
" *=====================================*

" comma as mod key
let mapleader = ","

" easy escape (dvorak)
imap hh <Esc>

" Prevent vim from moving cursor after returning to normal mode
imap <esc> <esc>l

" easy saving
nmap <leader>s :w<CR>

" save from visual mode
vmap <leader>s <esc>:w<CR>

" toggle hlsearch
map <leader>l :set hlsearch!<CR>

" open vimrc in new tab
map <leader>v :tabe ~/.vimrc<CR>

" toggle wrap
map <leader>w :set wrap!<CR>:set linebreak<CR>

" copy to end of line
nmap Y y$

" center jumps movements in file
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

" unmap unused keys
nnoremap q; q:
nmap q: <nop>
nmap Q: <nop>
nmap Q <nop>

" repeatable actions on visual selection
vnoremap . :normal .<CR>

" select-all
noremap <leader>a gg<S-v>G

" copy entire file
nmap <leader>y :%y<CR>

" copy/paste all lines matching last search pattern to register a
nmap <leader>Y :let @a=""<CR>:g/<C-r>//y A<CR><C-o>
nmap <leader>P "Ap

" Open netrw like nerd tree
nmap <leader>n :Vex 20<CR>
let g:netrw_winsize=0
let g:netrw_preview=1    " preview opened file in v-split
let g:netrw_browse_split=0

" open file with default program
nmap <leader>O :!open %<cr>
" select a block
nmap <leader>V $V%

" easily toggle find/replace
nmap S :%s//g<LEFT><LEFT>

" remove all instance of  last searched pattern
map <leader>/ :%s///g<CR>

" get file path
nmap <silent> cp :let @+ = expand('%') =~ '^/' ? substitute(expand('%'), '^' . $HOME . '/[^/]\+/', '', '') : expand('%')<CR>
" Get full file path
nmap <silent> cf :let @* = expand("%:p")<CR>

" -----------------
" Quick formatting
" -----------------

" sort unique of block
nmap <leader>S vip:sort u<cr>

" convert elixir module attribute to variable
nmap <leader>@ xea<space>=<esc>

" convert elixir named function to assigned anonymous function
nmap <leader>- ^dwf(ds)i<space>=<space>fn<space><esc>$ciw-><esc>=ip

" git conflict nav
"  TBD: use fugitive mappings instead
"  nmap ]x /^<<<<<<<<CR>zz
"  nmap [x /^>>>>>>><CR>zz
"  nmap ]= /^=======<CR>zz


" remove debuggers
nmap <leader>` :g/
      \^\s*binding\.pry\s*$
      \\\|^\s*byebug\s*$
      \\\|^\s*debugger\s*$
      \\\|^\s*require IEx; IEx\.pry\s*$
      \\\|^\s*IEx\.pry()\s*$
      \\\|^\s*embed()\s*$
      \\\|^\s*IO\.inspect.*$
      \/d<CR><C-o>

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

nmap L gt
nmap H gT

" split nav
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

noremap <leader>h :clo<CR>

imap <C-S-n> <Nop>
imap <C-N> <Nop>

iabbrev ivalid invalid
iabbrev Ivalid Invalid
inoreabbrev  appoinment appointment
inoreabbrev  appoitnment appointment
inoreabbrev  tf @tag :focus
inoreabbrev  ions \|> IO.inspect(label: "<LABEL>")
inoreabbrev  pp \|>
inoreabbrev  ioins \|>IO.inspect(label: "#{__MODULE__}.[func] -- ")
inoreabbrev  cdl console.log("")
inoreabbrev appointmetns appointments
