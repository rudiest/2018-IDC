<?php

class userProfil extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/userProfil');
        
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

            $member =  $this->sessionH->getMemberData();
            $functDB =& $this->loadModule('functionDB');
            
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=gantiPass','url_gantiPassword');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=logLogin','url_logLogin');
            
            $defTpt->addtext($member['idxNum'],'sma_user_dbid');
            $defTpt->addtext($member['firstName'],'sma_user_nama');
            $defTpt->addtext($member['userName'],'sma_user_username');
            
            $level = 'User (non-admin)';
            if ($member['idlevel'] == 1) {
                $level = 'Admin IDC';
            }
            $defTpt->addtext($level,'sma_user_level');
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

}


?>
