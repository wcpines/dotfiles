" *==================================*
" *----------|Base Configs|----------*
" *==================================*

set belloff=all
syntax on                                               " Enable syntax highlighting
filetype plugin indent on                               " Filetype detection[ON] plugin[ON] indent[ON].This command will use indentation scripts located in the indent folder of your vim installation.

set conceallevel=0                                      " always show syntax for concealable text
set path+=**                                            " Search into subfolders
set bs=2                                                " Backspace with this value allows you to use the backspace character for moving the cursor over automatically inserted indentation and over the start/end of line.
set clipboard^=unnamed,unnamedplus                      " Use system clipboard as the yank register
set expandtab                                           " Use spaces when tab is hit
set gcr=n:blinkon0                                      " Turn off cursor blink
set hidden                                              " Switch buffers and preserve changes w/o saving
set ignorecase                                          " Ignore case for search patterns
set incsearch                                           " Dynamic search (search and refine as you type)
set laststatus=2                                        " Show current mode, file name, file status, ruler, etc.
set modelines=0                                         " Ignore modelines set in files (which would otherwise set custom setting son a per file basis.  The line numbers vim would check to look for options would be set here)
set mouse=a                                             " Enable mouse (NB: SIMBL + MouseTerm enabled for teminal vim--deprecated in later macosx?)
set noerrorbells visualbell t_vb=                       " No visual bell, no error bell sounds
set nohlsearch                                          " Do not highlight all matches (you can toggle this as needed with command below)
set noswapfile                                          " I don't think these have ever been useful
set nowrap                                              " Do not wrap lines of text by default
set number                                              " Set line numbering
set rtp+=/usr/local/opt/fzf                             " FZF
set ruler                                               " Always show line/column info at bottom
set shiftwidth=2                                        " Number of characters for indentation made in normal mode ('>)
set showmatch                                           " Highlight search match as you type
set smartcase                                           " Respect cases in search when mixed case detected
set smartindent                                         " Changes indent based on file extension
set softtabstop=2                                       " Determines number of spaces to be inserted for tabs.  Also, backspace key treats space like a tab (so deletes all spaces)
set splitbelow                                          " default horizontal split below
set splitright                                          " default vertical split right
set tabstop=2                                           " Set number of columns inserted with tab key
set tags=./tags,tags;$HOME                              " Vim to search for Ctags file in current file's directory, moving up the directory structure until found/home is hit
set textwidth=0                                         " Controls the wrap width you would like to use (character length).  Setting it to default: disabled
set wildignore+=*Zend*,.git,*bundles*                   " Wildmenu ignores these filetypes and extensions
set wildmenu                                            " Make use of the status line to show possible completions of command line commands, file names, and more. Allows to cycle forward and backward though the list. This is called the wild menu.
set wildmode=list:longest                               " On the first tab: a list of completions will be shown and the command will be completed to the longest common command
set complete-=t                                         " don't check tags for word completion?
set complete-=i
