<?php

/* prevent browser caching page  */
date_default_timezone_set("Asia/Jakarta");

header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

// include site configuration file, which includes siteManager libs
require('../admin/common.inc');

$option = $_GET['opt'];
switch ($option) {

    default : $module =& $SM_siteManager->loadModule("get_nms");
              $module->run();
              break;

}

// finish display
$SM_siteManager->completePage();

?>