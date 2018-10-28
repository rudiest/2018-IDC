<?php

class gbRules extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/gbRules');

        // load default variable
        $this->addInVar('rNum',0);
        $this->addInVar('rNum2',0);
        $this->addInVar('rNum3','');
        $this->addInVar('rNum4','');
        $this->addInVar('rNum5','');
        $this->addInVar('rNum6','');
        $this->addInVar('option','');
        $this->addInVar('popMode','');
        $this->addInVar('sType','');
        $this->addInVar('wSQL','');
        $this->addInVar('swid','');
        $this->addInVar('aswid','');
        $this->addInVar('aswparam','');

        $this->addDirective('screenwidth', '100%');

    }

    function moduleThink() {

        $defTpt =& $this->getResource('defTpt');
        $member =  $this->sessionH->getMemberData();

        /* status type */
        if ( $this->getVar('popMode') == 'ajxcall' ) {

            if (strlen(trim($_GET['aswid']))>0) {
                eval('$this->'.$this->getVar('aswid').'('.$this->getVar('aswparam').');');
            }
            else {
                $this->ajxSwitch();
            }
        }
        else {

            $functDB =& $this->loadModule('functionDB');

            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid=ajx_simpanPeraturan','ajaxurl_simpan');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option'),'url_reloadPage');
            
            $SQL = " select * from ref_peraturan limit 1 ";
            $rh  = $this->dbHL['guestbook']->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
            
            $defTpt->addtext($rr['peraturan'],'sma_content');
        }

        $this->say($defTpt->run());
    }

    /* 01: must place ajaxSwitch here, directly after module think */
    function ajxSwitch() {

        $result = '';
        $swid   = '';
        $swid   = $_GET['swid'];
        switch ($swid) {

        }

        return $result;
    }

    function ajx_simpanPeraturan() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $peraturan = $functDB->encap_string($_POST['peraturan'],1);
        
        $SQL = "update ref_peraturan set peraturan = ".$peraturan." ";
        $act = $this->dbHL['guestbook']->query($SQL);
        
        die('1024');
    }

}


?>
