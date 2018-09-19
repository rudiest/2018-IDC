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
    
    case 'ajx_getInstansi' : $module =& $SM_siteManager->loadModule("guest_guestBook");
                            die($module->getInstansi());
                            break;
    
    case 'ajx_goCheckout' : $module =& $SM_siteManager->loadModule("guest_guestBook");
                            die($module->goCheckout());
                            break;
    
    case 'ajx_guestCheckOut' : $module =& $SM_siteManager->loadModule("guest_guestBook");
                               die($module->guestCheckout());
                               break;
                          
    case 'ajx_guestView' : $module =& $SM_siteManager->loadModule("guest_guestBook");
                           die($module->guestView());
                           break;
                          
    case 'ajx_bukuTamu' : $module =& $SM_siteManager->loadModule("guest_guestBook");
                          $module->buildGrid();
                          die('stop');
                          break;                                            

    default : $layout1 =& $SM_siteManager->rootTemplate("guest_welcomePage");
              $module =& $SM_siteManager->loadModule("guest_guestBook");
              $layout1->addText($module->buildGrid(),'guestBookList');
              $layout1->addText($module->run(),'guestBookForm');
              $layout1->addText($module->getTataTertib(),'guestBookTataTertib');
              break;

}

// finish display
$SM_siteManager->completePage();


?>