""""""""""""""""
" use xdg dirs
" inspiration: https://blog.joren.ga/vim-xdg
""""""""""""""""

if empty($MYVIMRC) | let $MYVIMRC = expand('<sfile>:p') | endif

if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME  = $HOME."/.cache"       | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME = $HOME."/.config"      | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME   = $HOME."/.local/share" | endif
if empty($XDG_STATE_HOME)  | let $XDG_STATE_HOME  = $HOME."/.local/state" | endif

set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after

set packpath^=$XDG_DATA_HOME/vim
set packpath+=$XDG_DATA_HOME/vim/after

let g:netrw_home = $XDG_DATA_HOME."/vim"

call mkdir($XDG_DATA_HOME."/vim/spell", 'p', 0700)

set backupdir=$XDG_STATE_HOME/vim/backup | call mkdir(&backupdir, 'p', 0700)
set directory=$XDG_STATE_HOME/vim/swap   | call mkdir(&directory, 'p', 0700) " this is the directory where .swp files are made, by default in workdir
set undodir=$XDG_STATE_HOME/vim/undo     | call mkdir(&undodir,   'p', 0700) " saves undo history

if !has('nvim') " Neovim has its own location which already complies with XDG specification
  set viminfofile=$XDG_STATE_HOME/vim/viminfo                                " saves global session state
endif

set viewdir=$XDG_DATA_HOME/vim/view | call mkdir(&viewdir, 'p', 0700)

let $actualvimrcfile = expand('<sfile>:p:h').'/vimrc'
source $actualvimrcfile
