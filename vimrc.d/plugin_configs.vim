" *====================================*
" *----------|Plugin Configs|----------*
" *====================================*

" --- Mappings ---
" ________________

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

nnoremap gR :Rg <C-r><C-w><CR>
nnoremap gF :call fzf#vim#files('.', {'options':'--query '.expand('<cword>')})<CR><C-a>

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
nnoremap <silent> <leader>tf :Tclose!<cr>
nnoremap <silent> <leader>tk :Tkill<CR>
nnoremap <silent> <leader>tl :TREPLSendLine<cr>
nnoremap <silent> <leader>to :call neoterm#open()<cr>
vnoremap <silent> <leader>ts :TREPLSendSelection<cr>
nmap <leader>tC :T clear<CR>
nmap <leader>tb :T iex#break<CR>
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
let test#project_root = '$HOME/development/procore'
let test#strategy='neoterm'
let test#ruby#rspec#executable = 'bin/rspec'
let test#filename_modifier = ':p'

let g:neoterm_default_mod='below'
let g:neoterm_automap_keys=',tt'
let g:neoterm_repl_ruby='pry'
let g:neoterm_repl_python='ipython'

let g:mix_format_on_save = 0
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
    LintJson
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
    YAMLFormat
  elseif &ft == 'yml'
    YAMLFormat
  elseif &ft == 'helm'
    YAMLFormat
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


" --- Display Settings ---
" ________________________

set encoding=UTF-8
silent! colorscheme solarized

let g:split_term_vertical=1
let g:vim_json_syntax_conceal=0
let g:vim_markdown_conceal=0
let g:vim_markdown_folding_disabled = 1
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


lua << EOF
  local lualine = require('lualine')
  lualine.extensions = { 'fzf' }
  lualine.sections.lualine_a = { 'mode',}
  lualine.sections.lualine_b = { 'branch', 'diff', 'filetype' }
  lualine.sections.lualine_x = { 'encoding', { 'diagnostics', sources = { 'coc' }} }
  lualine.options.section_separators = {'', ''}
  lualine.options.component_separators = {'', ''}
  lualine.options.theme = 'gruvbox'
  lualine.status()
EOF

if $ITERM_PROFILE == 'cpd'
  set background=dark
else
  set background=light
endif

" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#tab_min_count = 2
" let g:airline#extensions#tabline#show_splits = 0
" let g:airline#extensions#tabline#fnamemod = ':t:'
" let g:airline#extensions#tabline#alt_sep = 1
" let g:airline#extensions#tabline#show_buffers = 0

" let g:airline_theme='solarized'
" let g:airline_powerline_fonts = 1
" let g:webdevicons_enable_airline_tabline = 1 " default
" let g:webdevicons_enable_airline_statusline=1 " default

" if $ITERM_PROFILE == 'cpd'
"   set background=dark
"   let g:airline_solarized_bg='dark'
"   call airline#themes#solarized#refresh()
" else
"   set background=light
"   let g:airline_solarized_bg='light'
"   call airline#themes#solarized#refresh()
" endif

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
