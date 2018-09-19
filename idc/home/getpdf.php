<?php
$f=urldecode($_GET['f']);
if (!file_exists($f)) die('File does not exist');
Header('Content-Type: application/pdf');
Header('Content-Length: '.filesize($f));
readfile($f);
exit();
?>