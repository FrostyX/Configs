let b:did_ftplugin = 1
map <F9>:cd %:h<CR> :!latex %<CR>
imap <F9> <Esc>:cd %:h<CR> :!latex %<CR>

set spell
set wrap
set linebreak
imap <LocalLeader>pp <?php<Esc>o?><Esc>ko
