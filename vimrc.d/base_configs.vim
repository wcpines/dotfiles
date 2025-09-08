" *==================================*
" *----------|Base Configs|----------*
" *==================================*

set belloff=all                                         " Disable all bell sounds (error, visual, and audio)
syntax on                                               " Enable syntax highlighting
filetype plugin indent on                               " Filetype detection[ON] plugin[ON] indent[ON].This command will use indentation scripts located in the indent folder of your vim installation.

set conceallevel=0                                      " always show syntax for concealable text
set path+=**                                            " Add all subdirectories to path for :find command
set bs=2                                                " Allow backspace over auto-indent, line breaks, and start of insert
set clipboard^=unnamed,unnamedplus                      " Use system clipboard as the yank register
set expandtab                                           " Use spaces when tab is hit
set gcr=n:blinkon0                                      " Turn off cursor blink in normal mode
set hidden                                              " Switch buffers and preserve changes w/o saving
set ignorecase                                          " Ignore case for search patterns
set incsearch                                           " Dynamic search (search and refine as you type)
set laststatus=2                                        " Show current mode, file name, file status, ruler, etc.
set modelines=0                                         " Ignore modelines set in files (which would otherwise set custom setting son a per file basis.  The line numbers vim would check to look for options would be set here)
set mouse=a                                             " Enable mouse in all modes (a=all)
set noerrorbells visualbell t_vb=                       " No visual bell, no error bell sounds
set nohlsearch                                          " Do not highlight all matches (you can toggle this as needed with command below)
set noswapfile                                          " I don't think these have ever been useful
set nowrap                                              " Do not wrap lines of text by default
set number                                              " Set line numbering
set rtp+=/usr/local/opt/fzf                             " Add FZF to runtime path for fuzzy finder integration
set ruler                                               " Always show line/column info at bottom
set shiftwidth=2                                        " Number of characters for indentation made in normal mode ('>)
set showmatch                                           " Briefly highlight matching bracket when cursor is on one
set smartcase                                           " Respect cases in search when mixed case detected
set smartindent                                         " Changes indent based on file extension
set softtabstop=2                                       " Number of spaces that feel like a tab when editing (backspace deletes 2 spaces)
set splitbelow                                          " default horizontal split below
set splitright                                          " default vertical split right
set tabstop=2                                           " Set number of columns inserted with tab key
set tags=./tags,tags;$HOME                              " Search for tags file in current dir, then parent dirs, then $HOME
set textwidth=0                                         " Controls the wrap width you would like to use (character length).  Setting it to default: disabled
set wildignore+=*Zend*,.git,*bundles*                   " Wildmenu ignores these directories and patterns
set wildmenu                                            " Make use of the status line to show possible completions of command line commands, file names, and more. Allows to cycle forward and backward though the list. This is called the wild menu.
set wildmode=list:longest                               " On the first tab: a list of completions will be shown and the command will be completed to the longest common command
" set lazyredraw                                          " Don't redraw during macro execution