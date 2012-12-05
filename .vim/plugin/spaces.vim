function! SpaceDots()
	set conceallevel=2 concealcursor=nciv
	syntax match spaceDots " " conceal cchar=.
	hi clear Conceal
	hi Conceal ctermfg=4a4a59 ctermbg=233
	"hi Conceal ctermfg=244 ctermbg=233
endfunction

augroup spacedots
"	autocmd!
"	autocmd Syntax * call SpaceDots()
augroup END
