" requirements for some
"  - jq
"  - shpotify
"  - marked2
"  - pgfmt
"  - dialyzer
"  - gsed
"  - neovim
"  - ripgrep
"  - fzf
"  - vim-surround

" *=================================================*
" *------------------|Commands|---------------------*
" *=================================================*

command! Src source ~/.vimrc
command! CurlFmt call FormatCurl()
command! SqlArgs call SqlArgs()
command! Mk silent! !open -a "/Applications/Marked 2.app" "%:p"
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

" *=================================================*
" *-----------------|Functions|---------------------*
" *=================================================*

" Strip trailing whitespace on save
"function! StripTrailingWs()
"    %s/\s\+$//e
"endfunction

" Format curl commands with proper line breaks
function! FormatCurl()
  %s/ -H/ \\\r  -H/g
endfunction

" Convert list to SQL IN clause arguments
function! SqlArgs()
  %s/^/'/g
  %s/$/'/g
  %s/\n/,\r/g
  normal Gdd$xA)
  normal ggI(
endfunction

" Convert JSON to Elixir map format (requires jq)
function! MapFromJson()
  LintJson
  %s/"//g
  %s/null/nil/g
  %s/\(\d\+-\d\+-\d\+T.*\),/"\1",/g
endfunction

" *=================================================*
" *---------------|Auto-commands|-------------------*
" *=================================================*

" Filetype-specific comment strings
autocmd FileType sql set commentstring=--%s

" Read plist files
autocmd BufWritePost,FileWritePost *.plist !plutil -convert binary1 <afile>

" Normalize comment keywords across all filetypes
autocmd Syntax * syntax keyword Todo OPTIMIZE FIXME TODO TBD NOTE containedin=.*Comment

" Strip trailing whitespace on save
"autocmd BufWritePre * call StripTrailingWs()

" Filetype detection for various extensions
autocmd BufRead,BufNewFile *.phtml set filetype=html
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufRead,BufNewFile markdown set filetype=markdown
autocmd BufNewFile,BufRead *.scpt set filetype=applescript
