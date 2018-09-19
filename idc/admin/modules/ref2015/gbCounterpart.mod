<?php

class gbCounterpart extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/gbCounterpart');
        $this->useTemplate('defTpt2','/ref2015/gbCounterpart_form');

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

        $SQL  = " select   ref_pendamping.*,
                           pdp_id as id
                  from     ref_pendamping
                  order by pdp_nama
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');
        
        $sgkMod->directive['dbconn'] = 'guestbook';

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Pendamping Tamu IDC Kominfo';
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
        	'pdp_nama' => 'Nama Pendamping',
        );

        $sgkMod->directive['grid_fields_width'] = array(
        );

        $sgkMod->directive['grid_fields_type'] = array(
        );

        $sgkMod->directive['grid_fields_format'] = array(
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

            $SQL = " select * from ref_pendamping where pdp_id = '".$this->getVar('rNum')."' ";
            $rh  = $this->dbHL['guestbook']->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
        }
        else {

        }

        $form->add('pdp_nama','Nama (!)','text',true,$rr['pdp_nama'],array('extraAttributes'=>' style="width:250px;" '));

        if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit')) {

            $select =& $form->add('form_aksi','Ubah/Hapus?','kendoCombo',true,1,array('extraAttributes'=>' style="width:150px;" onchange="if (this.value==9) { if (window.confirm(\'Yakin akan menghapus?\')) { } else { var combobox = $(\'#form_aksi\').data(\'kendoComboBox\'); combobox.value(\'1\'); } } " '));
            $select->addOption('Ubah Data','1');
            $select->addOption('Hapus','9');
        }

        $form->add('submit','','submit',false,'Save',array('extraAttributes'=>' value="Save" '));

        $form->runForm();

        if ($form->dataVerified()) {

           $pdp_nama = $functDB->encap_string($form->getVar('pdp_nama'));
           $form_aksi = $functDB->encap_numeric($form->getVar('form_aksi'));
           
           $url_grid = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

           if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '1')) {

                $SQLDel = " update ref_pendamping set pdp_nama = ".$pdp_nama." where pdp_id = '".$this->getVar('rNum')."' ";
                $act    = $this->dbHL['guestbook']->query($SQLDel);

	            die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            elseif (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '9')) {

                $SQLDel = " delete from ref_pendamping where pdp_id = '".$this->getVar('rNum')."' ";
                $act    = $this->dbHL['guestbook']->query($SQLDel);

	            die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            else {

                $SQLDel = " insert into ref_pendamping(pdp_nama) values (".$pdp_nama.") ";
                $act    = $this->dbHL['guestbook']->query($SQLDel);

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }

        }
        else {

            return ($form->output());
        }
    }

}


?>
