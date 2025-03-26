""" Automatic install vim-plug -------------
" See more: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
" NOTE: After add new vim packages please use :scriptnames to view loaded
" plugins, if it's missing use `:PlugInstall --sync` to install it

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

""" Basic Settings -------------------------
" Show a few lines of context around the cursor
set scrolloff=5

" Do incremental searching
set incsearch

" Highlight search results
set hlsearch

" Show line numbers
set nu
set relativenumber

" Show current mode
set showmode

" Use system clipboard
" set clipboard+=unnamedplus

" Don't use Ex mode, use Q for formatting
map Q gq

""" Plugin Installation -------------------------
" Install Vim-Plug first: https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged') 

" Highlight copied text
Plug 'machakann/vim-highlightedyank'

" Commentary plugin
Plug 'tpope/vim-commentary'

" Surround plugin for brackets and quotes
Plug 'tpope/vim-surround'

" Plugin for handling text as parameters
Plug 'vim-scripts/argtextobj.vim'

" Plugin for selecting entire file
" NOTE: (doesn't work with legacy vim)
" Plug 'kana/vim-textobj-entire' 

" Plugin for replacing with register
Plug 'vim-scripts/ReplaceWithRegister'

" Plugin for exchanging text
Plug 'tommcdo/vim-exchange'

" Multiple cursors plugin
Plug 'mg979/vim-visual-multi'

" Better Matching Pair plugin
Plug 'andymass/vim-matchup'

call plug#end()

""" Plugin Settings -------------------------
let g:argtextobj_pairs="[:],(:),<:>"

""" Keyboard Mappings -------------------------
let mapleader=" "

" Better indent handling
vmap > >gv
vmap < <gv

" Move text up and down
vnoremap J :m .+1<CR>==
vnoremap K :m .-2<CR>==
xnoremap K :move '<-2<CR>gv
xnoremap J :move '>+1<CR>gv

" Delete without losing clipboard
vmap <leader>d "_d
vmap <leader>c "_c
xmap <leader>p "_dP
vmap <leader>p "_dP

" Copy to clipboard
nmap <leader>y "*y
vmap <leader>y "*y
nmap <leader>Y "*Y

" Clear search highlighting after pressing Esc
nmap <Esc> :nohlsearch<CR>

" Show registers
map <leader>" :registers<CR>

" Make file executable
map <leader>X :!chmod +x %<CR>

" Code folding (standard Vim commands)
" zc - fold current section
" zo - expand current section
" zM - fold all
" zR - expand all

" hack on delete surrounding function
nmap dsf :normal ](<CR>:normal ds(<CR>:normal h<CR>:normal vB"_d<CR>
