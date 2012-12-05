let b:did_ftplugin = 1

""HTML
"HTML znacky
imap <LocalLeader>< &lt;
imap <LocalLeader>> &gt;
imap <LocalLeader>& &amp;

"XHTML prikazy
imap <LocalLeader>aa <a href="" title=""></a><Esc>3hi
imap <LocalLeader>ii <img src="" alt="" /><Esc>10hi
imap <LocalLeader>di <div id=""></div><Esc>7hi
imap <LocalLeader>dc <div class=""></div><Esc>7hi

"PHP prikazy
imap <LocalLeader>pp <?php<Esc>o?><Esc>ko<Tab>
