" *=================================================*
" *----------|Auto-commands and functions|----------*
" *=================================================*
"
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

autocmd FileType sql set commentstring=--%s
autocmd FileType applescript set commentstring=#%s
autocmd FileType scpt set commentstring=#%s
"
" Read plist files
autocmd BufWritePost,FileWritePost *.plist !plutil -convert binary1 <afile>

" Normalize comment keywords across all filetypes
autocmd Syntax * syntax keyword Todo OPTIMIZE FIXME TODO TBD NOTE containedin=.*Comment


command! Src source  ~/.vimrc
"
" strip trailing whitespace on save
function! StripTrailingWs()
    %s/\s\+$//e
endfunction

autocmd BufWritePre * call StripTrailingWs()

function! SqlArgs()
  %s/^/'/g
  %s/$/'/g
  %s/\n/,\r/g
  normal Gdd$xA)
  normal ggI(
endfunction

" requires jq
function! MapFromJson ()
  LintJson
  %s/"//g
  %s/null/nil/g
  %s/\(\d\+-\d\+-\d\+T.*\),/"\1",/g
endfunction

" read correct filetype from file extension
autocmd BufNewFile,BufRead *.jbuilder set filetype=ruby
autocmd BufRead,BufNewFile *_spec.rb set filetype=ruby
autocmd BufRead,BufNewFile *_spec.rb set syntax=rspec
autocmd BufNewFile,BufRead Gemfile set filetype=ruby
autocmd BufRead,BufNewFile *.phtml set filetype=html
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufRead,BufNewFile markdown set filetype=markdown
autocmd BufNewFile,BufRead *.scpt set filetype=applescript

command! Mk silent! !open -a "/Applications/Marked 2.app" "%:p"
command! Json execute "tabe ~/Tresors/Colby/weight_room/scratch.json"
command! Sql execute "tabe ~/Tresors/Colby/weight_room/scratch.sql"
command! Exs execute "tabe ~/Tresors/Colby/weight_room/scratch.exs"
command! Gql execute "tabe ~/Tresors/Colby/weight_room/scratch.gql"
command! -range=% LintJson execute "<line1>,<line2>!jq '.'" | set ft=json
command! -range=% LintYml execute "<line1>,<line2>!oq -i yaml -o yaml" | set ft=yaml
command! -range=% Pgfmt execute "<line1>,<line2>!pg_format --comma-end --keyword-case 2 --function-case 2 --spaces 2"

au FileType sql setl formatprg=/usr/local/bin/pg_format\ -
