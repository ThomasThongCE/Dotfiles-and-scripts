syntax on
colorscheme desert
set nu
filetype plugin indent on

" turn relative line numbers on
:set relativenumber
:set rnu

" make tab width 4 space
set tabstop=4

" when indenting with '>', make 4 space width
set shiftwidth=4

" On pressing tab, insert 4 space
set expandtab

" vimplug
call plug#begin('~/.vim/plugged')

" colection of language pack
Plug 'sheerun/vim-polyglot'

" tree, file
Plug 'junegunn/fzf'
Plug 'scrooloose/nerdtree'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" surround
Plug 'tpope/vim-surround'

" status bar
Plug 'vim-airline/vim-airline'

" complete code
Plug 'valloric/youcompleteme'

" unix command
Plug 'tpope/vim-eunuch'

call plug#end()

" maping key
map <F2> :NERDTreeToggle<CR> 
map <C-e> :tabnext<CR>
" map <C-e> :tabprevious<CR>
map <C-t> :tabnew<CR>

" configure
let g:ycm_server_python_interpreter = '/usr/bin/python'
