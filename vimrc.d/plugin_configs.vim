" *====================================*
" *----------|Plugin Configs|----------*
" *====================================*

" --- Mappings ---
" ________________
" netrw-gx seems to be busted?
" https://github.com/vim/vim/issues/4738
nmap gx yiW:!open <cWORD><CR> <C-r>" & <CR><CR>
let g:netrw_liststyle = 3

nmap <leader>M :call CodeFmt()<cr>
map <leader>; :History:<CR>
map <leader>b :Buffers<CR>
map <leader>f :ProjectFiles<CR>
map <leader>g :GFiles<CR>
map <leader>m :History<CR>
nnoremap <leader>T :BTags<CR>

" coc.vim tags
map <leader>cd :CocDisable<cr>
map <leader>ce :CocEnable<cr>
nmap <leader>cl <Plug>(coc-codelens-action)

nmap [\ <Plug>(coc-diagnostic-next)zz
nmap ]\ <Plug>(coc-diagnostic-prev)zz

function! s:GoToDefinition()
  if CocAction('jumpDefinition')
    return v:true
  endif

  let ret = execute("silent! normal \<C-]>")
  if ret =~ "Error" || ret =~ "错误"
    call searchdecl(expand('<cword>'))
  endif
endfunction

nmap <silent> gd :call <SID>GoToDefinition()<CR>
"
" ctags
nnoremap <leader>g<C-]> :Tags <C-R><C-W> <CR>
nnoremap <leader><C-]> <C-w><C-]><C-w>T
nnoremap <C-]> <C-]>zz

vnoremap gR y:Rg <C-r>"<CR>
nnoremap gR :Rg <C-r><C-w><CR>
nnoremap gF :call fzf#vim#files('.', {'options':'--query '.expand('<cword>')})<CR><C-a>
let g:fzf_buffers_jump = 1

" https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

map <leader>o :ZoomWinTabToggle<CR>


nnoremap gy :YamlGoToParent<CR>

nmap dU :call AddDebugger("O")<cr>
nmap du :call AddDebugger("o")<cr>

nnoremap <silent> <leader>tc :Tclear<CR>
nnoremap <silent> <leader>tf :TREPLSendFile<cr>
nnoremap <silent> <leader>th :Tclose<cr>
nnoremap <silent> <leader>tk :Tkill<CR>
nnoremap <silent> <leader>tl :TREPLSendLine<cr>
nnoremap <silent> <leader>to :call neoterm#open()<cr>
vnoremap <silent> <leader>ts :TREPLSendSelection<cr>
nmap <leader>tC :T clear<CR><C-l>A<C-h><C-h>
nmap <leader>tb :T iex#break<CR> " iex
nmap <leader>tr :T rsql<CR><C-l>AG<C-h><C-h>
nmap <leader>tq :T q<cr>

if has('nvim')
  tnoremap <a-a> <esc>a
  tnoremap <a-b> <esc>b
  tnoremap <a-d> <esc>d
  tnoremap <a-f> <esc>f
endif

if has('nvim')
  tmap <C-h> <C-\><C-n>
  nmap <leader>\ :vert Tnew<CR>
endif


function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()

" ------------
" --- DBUI ---
" ------------
let g:db_ui_use_nerd_fonts=1
"--------------------
" --- Projections ---
"--------------------

let g:projectionist_heuristics = {}

let g:projectionist_heuristics['mix.exs'] = {
            \     'apps/*/mix.exs': { 'type': 'app' },
            \     'lib/*.ex': {
            \       'type': 'lib',
            \       'alternate': [
            \         'test/{}_test.exs',
            \         'test/lib/{}_test.exs',
            \       ],
            \       'template': ['defmodule {camelcase|capitalize|dot} do', 'end'],
            \     },
            \     'test/*_test.exs': {
            \       'type': 'test',
            \       'alternate': ['lib/{}.ex', '{}.ex'],
            \       'template': [
            \           'defmodule {camelcase|capitalize|dot}Test do',
            \           '  use ExUnit.Case',
            \           '',
            \           '  alias {camelcase|capitalize|dot}, as: Subject',
            \           '',
            \           '  doctest Subject',
            \           'end'
            \       ],
            \     },
            \     'mix.exs': { 'type': 'mix' },
            \     'config/*.exs': { 'type': 'config' },
            \ }

let g:projectionist_heuristics['package.json'] = {
            \   '*.js': {
            \     'alternate': [
            \       '{dirname}/{basename}.test.js',
            \       '{dirname}/__tests__/{basename}.test.js',
            \     ],
            \     'type': 'source',
            \     'make': 'yarn',
            \   },
            \   '*.test.js': {
            \     'alternate': [
            \       '{dirname}/{basename}.js',
            \       '{dirname}/../{basename}.js',
            \     ],
            \     'type': 'test',
            \   },
            \   '*.ts': {
            \     'alternate': [
            \       '{dirname}/{basename}.test.ts',
            \       '{dirname}/{basename}.test.tsx',
            \       '{dirname}/__tests__/{basename}.test.ts',
            \       '{dirname}/__tests__/{basename}.test.tsx',
            \     ],
            \     'type': 'source',
            \   },
            \   '*.test.ts': {
            \     'alternate': [
            \       '{dirname}/{basename}.ts',
            \       '{dirname}/{basename}.tsx',
            \       '{dirname}/../{basename}.ts',
            \       '{dirname}/../{basename}.tsx',
            \     ],
            \     'type': 'test',
            \   },
            \   '*.tsx': {
            \     'alternate': [
            \       '{dirname}/{basename}.test.ts',
            \       '{dirname}/{basename}.test.tsx',
            \       '{dirname}/__tests__/{basename}.test.ts',
            \       '{dirname}/__tests__/{basename}.test.tsx',
            \     ],
            \     'type': 'source',
            \   },
            \   '*.test.tsx': {
            \     'alternate': [
            \       '{dirname}/{basename}.ts',
            \       '{dirname}/{basename}.tsx',
            \       '{dirname}/../{basename}.ts',
            \       '{dirname}/../{basename}.tsx',
            \     ],
            \     'type': 'test',
            \   },
            \   'package.json': { 'type': 'package' }
            \ }

" ----------------------------------------------------- }}}"
"
"
"
" --- Options ---
"________________

set diffopt+=vertical
set diffopt+=iwhite

let g:sparkupExecuteMapping='<c-g>'

let g:rust_clip_command = 'pbcopy'

let g:jsx_ext_required=0
let g:vim_jsx_pretty_enable_jsx_highlight=1
let g:vim_jsx_pretty_colorful_config=0
let g:prettier#config#single_quote = 'true'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#jsx_bracket_same_line = 'false'
let g:prettier#config#arrow_parens = 'avoid'
let g:prettier#config#trailing_comma = 'es5'
let g:prettier#config#parser = 'babylon'

let g:vim_yaml_helper#auto_display_path = 1
let g:vim_yaml_helper#always_get_root = 1

let g:indexed_search_mappings = 1
let g:indexed_search_center = 1

let g:highlightedyank_highlight_duration=250

nnoremap tT :TestNearest<cr>
let test#strategy='neoterm'
let test#ruby#rspec#executable = 'bin/rspec'
let test#filename_modifier = ':p'

let g:neoterm_default_mod='below'
let g:neoterm_automap_keys=',tt'
let g:neoterm_repl_ruby='pry'
let g:neoterm_repl_python='ipython'

let g:mix_format_on_save = 1
let g:rufo_auto_formatting = 0

function! CodeFmt ()
  if &ft == 'crystal'
    CrystalFormat
  elseif &ft == 'elixir'
    MixFormat
  elseif &ft == 'typescript'
    Prettier
  elseif &ft == 'javascript'
    Prettier
  elseif &ft == 'python'
    Black
  elseif &ft == 'json'
    Prettier
  elseif &ft ==  'sh'
    Shfmt
  elseif &ft == 'html'
    Prettier
  elseif &ft == 'ruby'
    RuboCop -a
  elseif &ft == 'rspec.ruby'
    RuboCop -a
  elseif &ft == 'rspec'
    AsyncRun RuboCop -a
  elseif &ft == 'rust'
    write
    RustFmt
  elseif &ft == 'sql'
    Pgfmt
  elseif &ft == 'xml'
    %!xmllint --format -
  elseif &ft == 'yaml'
    Prettier
  elseif &ft == 'yml'
    Prettier
  elseif &ft == 'helm'
    Prettier
  elseif &ft == 'scss'
    Prettier
  elseif &ft == 'graphql'
    Prettier
  else
    echom "No formatter found for given filetype"
  endif
endfunction

let g:user_debugger_dictionary = {
      \ '\.rb':             'binding.pry',
      \ '\.rake':           'binding.pry',
      \ '\.erb':            '<% binding.pry %>',
        \ '\.ts$':          'debugger;',
      \ }


set encoding=UTF-8
silent! colorscheme solarized

let g:split_term_vertical=1
let g:vim_json_syntax_conceal=0
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1


function! Prose ()
  set conceallevel=0
  Goyo 100
  set linebreak
endfunction

command! Prose call Prose ()

" au FileType markdown Prose

let g:vim_markdown_new_list_item_indent=0

" Indent guides like sublime
let g:indentLine_fileTypeExclude = ['text', 'help', 'vim']
let g:indentLine_char = '┊'


let g:fzf_colors =
      \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }


if $ITERM_PROFILE == 'cpd'
  set background=dark
else
  set background=light
endif

highlight htmlArg cterm=italic
highlight Comment cterm=italic

let g:solarized_contrast="high"    "default value is normal
let g:solarized_visibility="high"  "default value is normal
let g:solarized_termcolors=16
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=1

" Workaround some broken plugins which set guicursor indiscriminately.
set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50

if has('gvim')
  set termguicolors
endif

if !has('nvim')
  set ttymouse=xterm2
endif


lua <<EOF
 require("lualine").setup {
    options = {
      theme = 'gruvbox',
      section_separators = {'', ''},
      component_separators = {'', ''},
      icons_enabled = true
    },
    sections = {
      lualine_a = { {'mode', upper=true } },
      lualine_b = { {'branch', icon = ''}, {'diff', colored = true} },
      lualine_c = { {'filetype'}, {'filename', file_status = true, path=1 } },
      lualine_x = { 'encoding', 'fileformat' },
      lualine_y = { 'progress' },
      lualine_z = { 'location'  },
    },
    inactive_sections = {
      lualine_a = {  },
      lualine_b = {  },
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {  },
      lualine_z = {  },
    },
    extensions = { 'fzf' },
    }
EOF

" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set showtabline=1
    highlight link TabNum Special
endif
