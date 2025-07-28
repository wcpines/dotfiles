" @wcpines vimrc
" Née ~Jan 2015

if filereadable(expand("~/dotfiles/vimrc.d/base_configs.vim"))
  source ~/dotfiles/vimrc.d/base_configs.vim
endif

if filereadable(expand("~/dotfiles/vimrc.d/functions.vim"))
  source ~/dotfiles/vimrc.d/functions.vim
endif

if filereadable(expand("~/dotfiles/vimrc.d/key_maps.vim"))
  source ~/dotfiles/vimrc.d/key_maps.vim
endif

" Load lazy.nvim
if filereadable(expand("~/dotfiles/vimrc.d/lazy.lua"))
  luafile ~/dotfiles/vimrc.d/lazy.lua
endif

if filereadable(expand("~/dotfiles/vimrc.d/plugin_configs.vim"))
  source ~/dotfiles/vimrc.d/plugin_configs.vim
endif

if filereadable(expand("~/dotfiles/vimrc.d/init.lua"))
  luafile ~/dotfiles/vimrc.d/init.lua
endif
