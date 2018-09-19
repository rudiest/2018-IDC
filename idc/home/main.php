<?php

/*
 MPV Web v2, using sm4 and php5
*/

/* prevent browser caching page  */
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

// include site configuration file, which includes siteManager libs
require('../admin/common.inc');

// create root template. notice, returns a reference!!
$SM_siteManager->rootTemplate("adminWebPage.cpt");

// finish display
$SM_siteManager->completePage();


?>