" *====================================*
" *----------|Plugin Configs|----------*
" *====================================*

" --- Mappings ---
" ________________

let g:netrw_liststyle = 4

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END

function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles lua require('fzf-lua').files({cwd = vim.fn.system('git rev-parse --show-toplevel 2> /dev/null'):gsub('\n', '')})

" Note: Replaced by conform.nvim. Kinda does the same thing
"nmap <leader>M :call CodeFmt()<cr>
"
map <leader>; :lua require('fzf-lua').command_history()<CR>
map <leader>b :lua require('fzf-lua').buffers()<CR>
map <leader>f :ProjectFiles<CR>
map <leader>g :lua require('fzf-lua').git_files()<CR>
map <leader>m :lua require('fzf-lua').oldfiles()<CR>
nnoremap <leader>T :lua require('fzf-lua').lsp_document_symbols()<CR>

vnoremap gR y:lua require('fzf-lua').grep({search = vim.fn.getreg('"')})<CR>
nnoremap gR :lua require('fzf-lua').grep({search = vim.fn.expand('<cword>')})<CR>
nnoremap gF :lua require('fzf-lua').files({query = vim.fn.expand('<cword>')})<CR>
" Removed fzf.vim config

" https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813

command! BD lua require('fzf-lua').buffers({actions = {['ctrl-d'] = {fn = require('fzf-lua.actions').buf_del, reload = true}}})


map <leader>o :ZoomWinTabToggle<CR>

nmap dU :call AddDebugger("O")<cr>
nmap du :call AddDebugger("o")<cr>

" --- Options ---
"________________

set diffopt+=vertical
set diffopt+=iwhite

let g:sparkupExecuteMapping='<c-g>'

let g:indexed_search_mappings = 1
let g:indexed_search_center = 1

let g:terraform_align = 1
let g:terraform_fmt_on_save = 1

let g:user_debugger_dictionary = {
      \ '\.rb':             'binding.pry',
      \ '\.rake':           'binding.pry',
      \ '\.erb':            '<% binding.pry %>',
        \ '\.ts$':          'debugger;',
      \ }


set encoding=UTF-8
" let g:vim_json_syntax_conceal=0
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1

command! Tt :call Toggle_theme()

function! Toggle_theme ()
  if &background=='light'
    set background=dark
  else
    set background=light
  endif
endfunction


set termguicolors

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
