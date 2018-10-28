<?php

class refPrefix extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refPrefix');
        $this->useTemplate('defPop','popSingleForm');

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

            $defTpt->addtext($this->getDirective('screenwidth'),'sma_subScreenWidth');
            $defTpt->addtext($this->formAddData(),'sma_tabGrid');
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

    /* 02: place other php function here */
    /*Tab 1*/
    function formAddData() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $form =& $this->newSmartForm();
        
        $form->directive['formParams'] = ' role="form" ';
        $form->directive['formClassTag'] = 'form-horizontal';

        $SQL = " select * from ref_global limit 1 ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);
        $rr = $rh->fetch();

        $form->add('global_akses','Akses','text',true,$rr['global_akses'],array('extraAttributes'=>' style="width:300px;" '));
        
        $form->add('submit','','submit',false,'Save',array('extraAttributes'=>' value="Save" '));

        $form->runForm();

        if ($form->dataVerified()) {

	       $global_akses = $functDB->encap_string($form->getVar('global_akses'));

           $arrData = array ('global_akses' => $global_akses,
                             'global_datetime' => "'".date('Y-m-d H:m:i')."'",
                             );
           $functDB->dbupd("ref_global",$arrData," true ");

           $url = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');
           die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url.'";</SCRIPT>');
        }
        else {

           return ($form->output());
        }
    }

}


?>
