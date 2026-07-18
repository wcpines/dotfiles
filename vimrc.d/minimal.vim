" Minimal standalone Neovim config.
" Use with: nvim -u ~/dotfiles/vimrc.d/minimal.vim
" This intentionally does not load lazy.nvim or plugin config.

set nocompatible

" Load one plugin that was already installed by lazy.nvim.
" Example: :Minload csv.vim
function! Minload(plugin_name)
  let l:plugin_dir = expand("~/.local/share/nvim/lazy/" . a:plugin_name)

  if !isdirectory(l:plugin_dir)
    echoerr "Plugin not found: " . l:plugin_dir
    return
  endif

  if index(split(&runtimepath, ','), l:plugin_dir) < 0
    execute "set runtimepath+=" . fnameescape(l:plugin_dir)
  endif

  " Load startup plugin files now. Neovim only auto-loads these during startup.
  execute "runtime! plugin/**/*.vim"
  execute "runtime! plugin/**/*.lua"

  " Load filetype detection, then re-run detection for the current buffer.
  execute "runtime! ftdetect/**/*.vim"
  execute "runtime! ftdetect/**/*.lua"
  filetype detect

  " Load ftplugin and syntax files for the current buffer's filetype.
  if &filetype !=# ""
    execute "runtime! ftplugin/" . &filetype . ".vim ftplugin/" . &filetype . "/*.vim"
    execute "runtime! syntax/" . &filetype . ".vim"
  endif

  echom "Loaded plugin: " . a:plugin_name
endfunction

command! -nargs=1 Minload call Minload(<q-args>)

if filereadable(expand("~/dotfiles/vimrc.d/base_configs.vim"))
  source ~/dotfiles/vimrc.d/base_configs.vim
endif

if filereadable(expand("~/dotfiles/vimrc.d/key_maps.vim"))
  source ~/dotfiles/vimrc.d/key_maps.vim
endif

" Plugin-independent commands and functions from functions.vim.
command! Src source ~/.vimrc
command! CurlFmt call FormatCurl()
command! SqlArgs call SqlArgs()
command! Mk silent! !open -a "/Applications/Marked.app" "%:p"
command! Ts execute "tabe ~/scratch/scratch.ts"
command! Json execute "tabe ~/scratch/scratch.json"
command! Sql execute "tabe ~/scratch/scratch.sql"
command! Exs execute "tabe ~/scratch/scratch.exs"
command! Gql execute "tabe ~/scratch/scratch.gql"
command! Html execute "tabe ~/scratch/scratch.html"
command! Shell execute "tabe ~/scratch/scratch.sh"
command! -range=% LintJson execute "<line1>,<line2>!jq '.'" | set ft=json
command! -range=% Pgfmt execute "<line1>,<line2>!pg_format --comma-end --keyword-case 2 --function-case 2 --spaces 2"
command! -nargs=1 RgCSV execute '!(head -n1 % && rg ' . shellescape(<args>) . ' %) > temp.csv && mv temp.csv %'

" Strip trailing whitespace on save.
function! StripTrailingWs()
    %s/\s\+$//e
endfunction

" Format curl commands with line breaks.
function! FormatCurl()
  %s/ -H/ \\\r  -H/g
endfunction

" Convert list to SQL IN clause arguments.
function! SqlArgs()
  %s/^/'/g
  %s/$/'/g
  %s/\n/,\r/g
  normal Gdd$xA)
  normal ggI(
endfunction

" Convert JSON to Elixir map format. Requires jq.
function! MapFromJson()
  LintJson
  %s/"//g
  %s/null/nil/g
  %s/\(\d\+-\d\+-\d\+T.*\),/"\1",/g
endfunction

" Filetype-specific comment strings.
autocmd FileType sql set commentstring=--%s

" Read plist files.
autocmd BufWritePost,FileWritePost *.plist !plutil -convert binary1 <afile>

" Normalize comment keywords across all filetypes.
autocmd Syntax * syntax keyword Todo OPTIMIZE FIXME TODO TBD NOTE containedin=.*Comment

" Strip trailing whitespace on save.
autocmd BufWritePre * call StripTrailingWs()

" Filetype detection for various extensions.
autocmd BufRead,BufNewFile *.phtml set filetype=html
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufRead,BufNewFile markdown set filetype=markdown
autocmd BufNewFile,BufRead *.scpt set filetype=applescript
