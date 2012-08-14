"Nastaveni VI
set nocompatible

"Rozpoznavani typu souboru (php, C, C++, ...)
"filetype plugin indent on
"filetype plugin on

"Obarveni
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

"Automaticke ukladani pri spusteni externich prikazu (make, ..)
set autowrite

"Misto selhani - dialog
set confirm

"Automaticke vyhledavani v prubehu psani retezce
set incsearch

" Enable filetype plugin
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

"Tab completion
"set wildchar=<A-Tab>
set wildmenu
set wildmode=longest:full,full

"Mapovani zkratek
""Běžné ovládání
"""Ukládání
map <C-S> :w<CR>
imap <C-S> <ESC>:w<CR>i

"""Select all
map <C-a> ggVG<CR>
imap <C-a> <ESC>ggVG<CR>i

"""Copy/Paste
"http://www.linuxquestions.org/questions/linux-newbie-8/gvim-cut-copy-paste-374760/#post1916306
nmap <C-V> "+gP
imap <C-V> <ESC><C-V>i
map <C-C> "+y
vmap <C-C> "+y


""Programovani
map <F9> :make<CR>
imap <F9> <Esc>:make<CR>
"imap ,pp <Esc>:r !xclip -o<CR>
"imap <C-v> <Esc>!xclip -o<CR>



"vmap <F6> :!xclip -f -sel clip<CR>
"imap <C-v> :-1r !xclip -o -sel clip<CR>
"imap <C-v> <Esc>:-1r !xclip -o -sel clip<CR>i
"map <C-v> <Esc>:-1r !xclip -o -sel clip<CR>

"Zobrazeni odpovidajici zavorky
set showmatch

"Nastaveni titulku
set title
set titlestring=VIM\ -\ %t

"Zobrazeny pocet radku kolem kurzoru
set scrolloff=5

"Odsazovani
set autoindent
set smartindent
"set expandtab "Nahrazeni TABu mezerami
"set shiftwidth=4

set backspace=indent,eol,start

"Zruseni zalamovani radku
set nowrap

"Graficka verze VIMu -----------------------------------------------"
"Vyskakovaci menu na pravem tlacitku mysi
set mousemodel=popup

"colorscheme zellner
colorscheme wombat

"Ignorovani velkych a malych pismen pri vyhledavani
set ignorecase

"Zobrazeni cisel radku
set number

"Ukladani prubeznych zaloh
set directory=~/.vim/swp

let maplocalleader = ","

"Sablony
"autocmd BufNewFile  *.c     0r ~/.vim/templates/template.php
source ~/.vim/scripts/root.cz_skel.vim

"Nastaveni jazyku pro kontrolu pravopisu
set spelllang=cs
set encoding=utf-8

"Slušné ovládání při vizuálním zalamování
"Ještě dopsat Home/End
map <Up>   gk
map <Down> gj
imap <Up> <C-o>gk
imap <Down> <C-o>gj

let g:tex_flavor='latex'
"filetype plugin indent on


"Neviditelné znaky
"http://vimcasts.org/episodes/show-invisibles/
set list
set listchars=tab:▸\ ,eol:¬,trail:·
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59
"highlight SpecialKey guifg=#4a4a59

map <C-k> dd2kp

"Delete whitespace on save
"http://vim.wikia.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
autocmd BufWritePre * :%s/\s\+$//e
