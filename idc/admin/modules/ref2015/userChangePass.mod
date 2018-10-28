<?php

class userChangePass extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/userChangePass');
        
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
            
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid=ajxChPass','url_ajxChPass');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=logout','url_logout');
            
            $defTpt->addtext($member['idxNum'],'sma_user_dbid');
            $defTpt->addtext($member['firstName'],'sma_user_nama');
            $defTpt->addtext($member['userName'],'sma_user_username');
            
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
    
    function ajxChPass() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $old0 = $functDB->encap_string($_POST['oldPass'],1);
        $new1 = $functDB->encap_string($_POST['newPass1'],1);
        $new2 = $functDB->encap_string($_POST['newPass2'],1);
        
        $return = array();
        
        if (strlen(trim($old0)) > 0) {
            if (strlen(trim($new1)) > 2) {
                if ($new1 == $new2) {
                    $SQLCekID = " select * from members where idxNum = '".$member['idxNum']."' and passWord = password(".$old0.") ";
                    $rhCekID  = $this->dbH->query($SQLCekID);
                    $functDB->dberror_show($rhCekID);
                    $rrCekID = $rhCekID->fetch();
                    
                    if ($rrCekID['idxNum'] > 0) {
                        $arrData = array ('passWord' => ' password('.$new1.')'
	                                        );
	                    $functDB->dbupd("members",$arrData,"idxNum = ".$member['idxNum']);
                        $return['info'] = 'Password sudah diganti';
                    }
                    else {
                        $return['error'] = 'Error! Password lama salah';
                    }
                }
                else {
                    $return['error'] = 'Error! Password baru tidak sama';
                }
            }
            else {
                $return['error'] = 'Error! Password baru tidak boleh kosong';
            }
        }
        else {
            $return['error'] = 'Error! Password lama tidak boleh kosong';
        }
        
        
        die(json_encode($return));
        
    }

}


?>
