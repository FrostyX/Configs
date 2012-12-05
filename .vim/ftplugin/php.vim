let b:did_ftplugin = 1

"Spuštění
map <F9> <Esc>:!./%<CR>
imap <F9> <Esc>:!./%<CR>


""PHP
"HTML znacky
imap <LocalLeader>< &lt;
imap <LocalLeader>> &gt;
imap <LocalLeader>& &amp;

"XHTML prikazy
imap <LocalLeader>ll <a href="" title=""></a><Esc>3hi
imap <LocalLeader>ii <img src="" alt="" /><Esc>10hi
imap <LocalLeader>di <div id=""></div><Esc>7hi
imap <LocalLeader>dc <div class=""></div><Esc>7hi

"PHP prikazy
imap <LocalLeader>pp <?php<Esc>o?><Esc>ko

"Modifikátory přístupu
imap <LocalLeader>pv public $
imap <LocalLeader>rv private $
imap <LocalLeader>ov protected $

"Funkce
imap <LocalLeader>ff function<Enter>{<Enter>}<Esc>2kA ()<Esc>bi
imap <LocalLeader>fc public function __construct<Enter>{<Enter>}<Esc>2kA()<Esc>i
imap <LocalLeader>pf public function<Enter>{<Enter>}<Esc>2kA ()<Esc>bi
imap <LocalLeader>rf private function<Enter>{<Enter>}<Esc>2kA ()<Esc>bi
imap <LocalLeader>of protected function<Enter>{<Enter>}<Esc>2kA ()<Esc>bi

""Get & Set
imap <LocalLeader>get public function vrat<Enter>{<Enter>return $this->;<Enter>}<Esc>3kA()<Esc>bi
imap <LocalLeader>set public function nastav<Enter>{<Enter>$this-> = $;<Enter>}<Esc>3kA($)<Esc>bi

"Třídy
imap <LocalLeader>cc class<Enter>{<Enter>}<Esc>2kA
imap <LocalLeader>aa ->
imap <LocalLeader>tt $this->


"Komentáře
imap <LocalLeader>doc /*<Enter><backspace>/<Esc>kA
imap <LocalLeader>docc /**<Enter><backspace>/<Esc>kA

""Nefunguje v nich odsazení
"imap <LocalLeader>doc /**<Enter><backspace>/<Esc>kA
"imap <LocalLeader>docc /**<Enter><backspace>/<Esc>kA
"imap <LocalLeader>docf /**<Enter>@return<Enter><backspace>/<Esc>2kA
"imap <LocalLeader>docv /**<Enter>@var<Enter><backspace>/<Esc>2kA


"DB příkazy
imap <LocalLeader>s $sql = "";<Esc>ba
imap <LocalLeader>q $query = mysql_query($sql);<Enter>
imap <LocalLeader>fa $result = mysql_fetch_array($query);<Enter>
imap <LocalLeader>fo $result = mysql_fetch_object($query);<Enter>
