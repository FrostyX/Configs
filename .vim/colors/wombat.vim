" Maintainer:	Lars H. Nielsen (dengmao@gmail.com)
" Last Change:	January 22 2007

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "wombat"


" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine guibg=#2d2d2d
  hi CursorColumn guibg=#2d2d2d
  hi MatchParen guifg=#f6f3e8 guibg=#857b6f gui=bold
  hi Pmenu 		guifg=#f6f3e8 guibg=#444444
  hi PmenuSel 	guifg=#000000 guibg=#cae682
endif

" General colors
hi Cursor 		guifg=NONE    guibg=#b0a7ab gui=none
hi Normal 		guifg=#f6f3e8 guibg=#242424 gui=none
hi NonText 		guifg=#ff3b77 guibg=#242424 gui=none
"hi NonText 		guifg=#808080 guibg=#303030 gui=none
"hi LineNr 		guifg=#857b6f guibg=#000000 gui=none
hi LineNr 		guifg=#857b6f guibg=#242424 gui=none
hi StatusLine 	guifg=#f6f3e8 guibg=#92b00b gui=italic
hi StatusLineNC guifg=#857b6f guibg=#92b00b gui=none
hi VertSplit 	guifg=#444444 guibg=#92b00b gui=none
hi Folded 		guibg=#384048 guifg=#a0a8b0 gui=none
hi Title		guifg=#f6f3e8 guibg=NONE	gui=bold
hi Visual		guifg=#f6f3e8 guibg=#444444 gui=none
hi SpecialKey	guifg=#808080 guibg=#242424 gui=none

" Syntax highlighting
hi Comment 		guifg=#808080 gui=italic
hi Todo 		guifg=#8f8f8f gui=italic
hi Constant 		guifg=#cdff00 gui=none
hi String 		guifg=#95e454 gui=italic
hi Identifier 		guifg=#cae682 gui=none
hi Function 		guifg=#77b4c7 gui=none
hi Type 		guifg=#cae682 gui=none
hi Statement 		guifg=#8ac6f2 gui=none
hi Keyword		guifg=#8ac6f2 gui=none
hi PreProc 		guifg=#fecf35 gui=none
hi Number		guifg=#ff3b77 gui=none
hi Special		guifg=#def778 gui=none


