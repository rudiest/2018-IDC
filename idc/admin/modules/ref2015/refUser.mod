<?php

class refUser extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refUser');
        $this->useTemplate('defTpt2','/ref2015/refIP_form');

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
        elseif ( $this->getVar('popMode') == 'formData' ) {

            $defTpt =& $this->getResource('defTpt2');
            $defTpt->addText($this->formAddData(),'sma_formcontent');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option'),'url_batal');
        }
        else {

            $functDB =& $this->loadModule('functionDB');

            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=formData','popUrl_modifyData');
            
            $defTpt->addtext($this->buildGrid(),'sma_tabGrid');
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
    function buildGrid($tmp = '') {

        $SQL  = " select   *,
        				   idxNum as id,
                           case when statvisible = 1 then 'Aktif' else 'Tidak' end as status_visible,
                           case when idlevel = 1 then 'Admin' else 'User' end as status_level
                  from     members
                  order by userName
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'User Akses Sistem';
        $sgkMod->directive['sm_function'] = 'buildGrid';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

        $sgkMod->directive['element_add_formtechnique'] = 'jsf';
        $sgkMod->directive['element_add_jsf'] = 'addNewData()';
        $sgkMod->directive['sgk_reload_jsf'] = 'gridReload()';
        $sgkMod->directive['grid_btnDetail'] = false;
        $sgkMod->directive['grid_btnEdit'] = true;
        $sgkMod->directive['grid_btnEdit_useDefault'] = false;
        $sgkMod->directive['grid_btnEdit_jsfCustom'] = 'editGrid';
        $sgkMod->directive['grid_btnDelete'] = false;
        $sgkMod->directive['grid_btnDelete_useDefault'] = false;
        $sgkMod->directive['grid_btnDelete_jsfCustom'] = '';

        $sgkMod->directive['wrapper_useDefault'] = false;

        $sgkMod->directive['inw3x3_headleft'] = array('add');
        $sgkMod->directive['inw3x3_headright'] = array('search');
        $sgkMod->directive['inw3x3_footright'] = array('');
        
        $sgkMod->directive['grid_isgroupable'] = false;
        $sgkMod->directive['grid_isselectable'] = true;
        $sgkMod->directive['grid_columnmenu'] = false;
        $sgkMod->directive['grid_isfilterable'] = false;
        $sgkMod->directive['grid_isresize'] = false;
        $sgkMod->directive['grid_isreorder'] = false;

        $sgkMod->directive['grid_fields'] = array(
        	'idxNum' => 'ID',
        	'userName' => 'Username',
        	'firstName' => 'Nama Lengkap',
        	'status_level' => 'Level',
            'status_visible' => 'Aktif?',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'idxNum' => '75',
        	'userName' => '150',
        	'status_level' => '100',
            'status_visible' => '100',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			'idxNum' => 'numeric',
        );

        $sgkMod->directive['grid_fields_format'] = array(
			'idxNum' => 'numeric',
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }

    function formAddData() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $form =& $this->newSmartForm();
        
        $form->directive['formParams'] = ' role="form" ';
        $form->directive['formClassTag'] = 'form-horizontal';
        
        if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit')) {

            $SQL = " select * from members where idxNum = '".$this->getVar('rNum')."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
        }
        else {

        }

        $form->add('idxNum','ID Data','kendoNumeric',false,$rr['idxNum'],array('extraAttributes'=>' style="width:100px;" '));

        $form->add('userName','User ID (!)','text',true,$rr['userName'],array('extraAttributes'=>' style="width:150px;" maxlength="20" '));

        $tmp =& $form->add('passWord','Password','text',false,'',array('extraAttributes'=>' style="width:150px;" maxlength="20" '));
        $tmp->addDirective('passWord',true);

        $form->add('firstName','Nama Lengkap','text',false,$rr['firstName'],array('extraAttributes'=>' style="width:250px;" maxlength="255" '));

        $selEnt =& $form->add('idlevel','Level User (!)','kendoCombo',true,$rr['idlevel'],array('extraAttributes'=>' style="width:250px;" '));
        $selEnt->addOption('Admin Sistem Inventaris','1');
        $selEnt->addOption('User Sistem Inventaris','2');

        $selEnt =& $form->add('statvisible','Status Aktif ? (!)','kendoCombo',true,$rr['statvisible'],array('extraAttributes'=>' style="width:250px;" '));
        $selEnt->addOption('Aktif','1');
        $selEnt->addOption('Tidak Aktif','2');

        if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit')) {

            $select =& $form->add('form_aksi','Ubah/Hapus?','kendoCombo',true,1,array('extraAttributes'=>' style="width:150px;" onchange="if (this.value==9) { if (window.confirm(\'Yakin akan menghapus?\')) { } else { var combobox = $(\'#form_aksi\').data(\'kendoComboBox\'); combobox.value(\'1\'); } } " '));
            $select->addOption('Ubah Data','1');
            $select->addOption('Hapus','9');
        }

        $form->addHidden('markForm','formSatu');

        $form->add('submit','','submit',false,'Save',array('extraAttributes'=>' value="Save" '));

        $form->runForm();
        
        $url_grid = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

        if ($form->dataVerified() && ($_POST['markForm'] == 'formSatu')) {
            
           $idxNum = $functDB->encap_numeric($form->getVar('idxNum'));
           $idlevel = $functDB->encap_numeric($form->getVar('idlevel'));

           $userName = $functDB->encap_string($form->getVar('userName'));
           $passWord = $functDB->encap_string($form->getVar('passWord'));
           $firstName = $functDB->encap_string($form->getVar('firstName'),1);

           $statvisible = $functDB->encap_numeric($form->getVar('statvisible'));
           $form_aksi = $functDB->encap_numeric($form->getVar('form_aksi'));

           if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '1')) {

	            // check duplikasi id
	            if (($idxNum != $rr['idxNum']) && ($idxNum > 0)) {

		            $SQLCekID = " select * from members where idxNum = '".$idxNum."' ";
		            $rhCekID  = $this->dbH->query($SQLCekID);
		            $functDB->dberror_show($rhCekID);
		            $rrCekID = $rhCekID->fetch();

		            if ($rrCekID['idxNum'] > 0) {
			            die('<SCRIPT LANGUAGE="JavaScript">alert("ID Data telah digunakan oleh '.$rrCekID['userName'].'. Gunakan ID lainnya"); window.location.href = "'.$url_grid.'";</SCRIPT>');
		            }
	            }

                $arrData = array (  'idxNum' => $idxNum,
                					'uID' => $userName,
                                    'userName' => $userName,
                                    'firstName' => $firstName,
                                    'statvisible' => $statvisible,
                                    'idlevel' => $idlevel,
                                    );
                $functDB->dbupd("members",$arrData,"idxNum = ".$this->getVar('rNum'));

                if (strlen(trim($form->getVar('passWord'))) > 2) {
	                $arrData = array (  'passWord' => ' password('.$passWord.')'
	                                    );
	                $functDB->dbupd("members",$arrData,"idxNum = ".$this->getVar('rNum'));
                }

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            elseif (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '9')) {

                $functDB->dbdelete("members","idxNum = ".$this->getVar('rNum'),'');
                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            else {

                 $arrData = array ( 'idxNum' => $idxNum,
                 					'uID' => $userName,
                                    'userName' => $userName,
                                    'passWord' => ' password('.$passWord.')',
                                    'firstName' => $firstName,
                                    'idlevel' => $idlevel,
                                    'statvisible' => $statvisible,
                                    'dateCreated' => 'now()',
                                    );
                 $functDB->dbins('members',$arrData);

                 die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }

        }
        else {

            return ($form->output());
        }
    }



}


?>
