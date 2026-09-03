syntax on

set nu
filetype plugin indent on

" turn relative line numbers on
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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" color
Plug 'morhetz/gruvbox'

" surround
Plug 'tpope/vim-surround'

" status bar
Plug 'vim-airline/vim-airline'

" complete code
Plug 'Valloric/youcompleteme', {'do': './install.py --all'}

" unix command
Plug 'tpope/vim-eunuch'

" Platform io recomendded plugin
" Async Language Server Protocol 
Plug 'prabirshrestha/vim-lsp'

" vim comment
Plug 'preservim/nerdcommenter' 

call plug#end()

" maping key
map <F2> :NERDTreeToggle<CR> 
map <C-e> :tabnext<CR>
map <C-q> :tabprevious<CR>
map <C-w> :tabclose<CR>
 "map <C-e> :tabprevious<CR>
map <C-t> :tabnew<CR>

" configure
let g:ycm_server_python_interpreter = '/usr/bin/python3'

" set colorscheme
set background=dark    " Setting dark mode
autocmd vimenter * ++nested colorscheme gruvbox

" ussing rg instead
" set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow

" fzf shortcut
nnoremap <silent> <Leader>f :Rg<CR>
nmap <C-p> :Files <CR>

command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Turn off caplock when go into normal mode
function TurnOffCaps()  
    let capsState = matchstr(system('xset -q'), '00: Caps Lock:\s\+\zs\(on\|off\)\ze')
    if capsState == 'on'
        silent! execute ':!xdotool key Caps_Lock'
    endif
endfunction
au InsertLeave * call TurnOffCaps()
ino <C-c> <Esc>

" toggle parse
set pastetoggle=<F3>

set foldmethod=indent
set nofoldenable
set foldnestmax=1
"set foldcolumn=2
"highlight FoldColumn guibg=darkgrey guifg=white
"highlight Folded guifg=PeachPuff4
