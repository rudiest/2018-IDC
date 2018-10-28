<?php

/* prevent browser caching page  */
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

// include site configuration file, which includes siteManager libs
require('../admin/common.inc');

$option = $_GET['opt'];
switch ($option) {

    default : $layout =& $SM_siteManager->rootTemplate("guest_mobile");
              $module =& $SM_siteManager->loadModule("guest_inquery");
              $layout->addText($module->run(),'sma_mobileContent');
              break;

}

// finish display
$SM_siteManager->completePage();

?>