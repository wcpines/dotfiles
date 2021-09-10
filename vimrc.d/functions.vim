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

autocmd FileType sql set commentstring=--%s
autocmd FileType applescript set commentstring=#%s
autocmd FileType scpt set commentstring=#%s

" open quickfix item in vert split
autocmd! FileType qf nnoremap <buffer> <leader><Enter> <C-w><Enter><C-w>L:cclo<CR>

command! Src source  ~/.vimrc

" Read plist files
autocmd BufWritePost,FileWritePost *.plist !plutil -convert binary1 <afile>

" Normalize comment keywords across all filetypes
autocmd Syntax * syntax keyword Todo OPTIMIZE FIXME TODO TBD NOTE containedin=.*Comment

" strip trailing whitespace on save
function! StripTrailingWs()
    %s/\s\+$//e
endfunction

autocmd BufWritePre * call StripTrailingWs()


function! FoldMethodDefinitions()
  g/def\s.*$/normal zfam
  go
endfunction

command! FoldDef call FoldMethodDefinitions()

" requires pgfmt
function! FormatTestSql()
  %s/ NULLS LAST$//g
  %s/$1/'04-20-2019'/g
  %s/$2/'04-20-2019'/g
  %s/$3/7/g
  %s/$4/7/g
  %s/$5/20/g
  Pgfmt
  %s/',)/')/g
  %s/STRING/TEXT/g
endfunction

" requires jq
function! FormatTestJson()
	LintJson
	g/null,/d
	%s/\(.*\),\n.*null$/\1/g
	w
endfunction

" requires jq
function! MapFromJson ()
  LintJson
  %s/"//g
  %s/null/nil/g
  %s/\(\d\+-\d\+-\d\+T.*\),/"\1",/g
endfunction


function! Dialyze ()
	setlocal makeprg=mix\ dialyzer\ --quiet\ --format\ short
	make
	copen
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

command! Mk silent! !open -a "/Applications/Marked 2.app" "%:p"
command! Json execute "tabe ~/Tresors/Colby/weight_room/scratch.json"
command! Sql execute "tabe ~/Tresors/Colby/weight_room/scratch.sql"
command! Exs execute "tabe ~/Tresors/Colby/weight_room/scratch.exs"
command! Gql execute "tabe ~/Tresors/Colby/weight_room/scratch.gql"
command! Dialyze call Dialyze()
command! -range=% LintJson execute "<line1>,<line2>!jq '.'" | set ft=json
command! -range=% LintYml execute "<line1>,<line2>!oq -i yaml -o yaml" | set ft=yaml
command! -range=% Pgfmt execute "<line1>,<line2>!pg_format --comma-end --keyword-case 2 --function-case 2 --spaces 2"
command! Play silent! !spotify play
command! Pause silent! !spotify pause
command! Share !spotify share url

au FileType sql setl formatprg=Pgfmt

