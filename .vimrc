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

" Disable folding
set nofoldenable

"Tab completion
set wildmenu
set wildmode=longest:full,full

"Přemapování pitomého helpu
imap <F1> <Esc>
map <F1> <Esc>

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
nmap <C-V> l"+gP
imap <C-V> <ESC><C-V>i
map <C-C> "+y
vmap <C-C> "+y

""Zavření tabu
map <C-w> :q<CR>
imap <C-w> <Esc>:q<CR>i


""Programovani
map ,t :silent !urxvt -cd `pwd` &<CR>
map <F9> :make<CR>
imap <F9> <Esc>:make<CR>
"imap ,pp <Esc>:r !xclip -o<CR>
"imap <C-v> <Esc>!xclip -o<CR>

"Git
nmap ,ga :GitAdd<CR>
nmap ,gc :GitCommit<CR>
nmap ,gp :GitPush<CR>

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

set backspace=indent,eol,start

"Zruseni zalamovani radku
set nowrap

"Automatická změna pracovního adresáře na ten v němž je editovaný soubor
set autochdir

"Graficka verze VIMu -----------------------------------------------"
"Vyskakovaci menu na pravem tlacitku mysi
set mousemodel=popup

"colorscheme zellner
"colorscheme wombat
colorscheme darkmirror

"Ignorovani velkych a malych pismen pri vyhledavani
set ignorecase

"Zobrazeni cisel radku
set number

"Zvýraznění aktuálního řádku
set cursorline

"Ukladani prubeznych zaloh
set backupdir=~/.vim/tmp
set directory=~/.vim/swp

let maplocalleader = ","

"Nastaveni jazyku pro kontrolu pravopisu
set spelllang=cs
set encoding=utf-8

" Sessions
set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds



imap ,dd $

"Delete whitespace on save
"http://vim.wikia.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
autocmd BufWritePre * :%s/\s\+$//e

"GUI specific settings
if has("gui_running")
	colorscheme wombat
	set guioptions-=T  "No toolbar
	set guioptions-=r  "No scrollbar

	"Invisible characters - http://vimcasts.org/episodes/show-invisibles/
	set list                            "Show invisible characters
	set listchars=tab:▸\ ,eol:¬,trail:· "Specify what display instead of invisible space
	highlight NonText guifg=#4a4a59     "EOL character color
	highlight SpecialKey guifg=#4a4a59  "Tab and space character color
end

" If I forgot to sudo vim a file, do that with :w!!
cmap w!! %!sudo tee > /dev/null %
