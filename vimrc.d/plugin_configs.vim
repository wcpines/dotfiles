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

" Note: fzf-lua mappings replaced by snacks.nvim (see lazy.lua)

" New BD command using snacks picker for buffer deletion
" The buffers picker has built-in Ctrl+X and dd keymaps for buffer deletion
command! BD lua vim.schedule(function() require('snacks').picker.buffers() end)

" Rg command using snacks picker for ripgrep search with file filtering
command! -nargs=* Rg lua vim.schedule(function() require('snacks').picker.grep_word({search = <q-args>}) end)


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
