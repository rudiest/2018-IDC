<?php

class refSatker extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refSatker');
        $this->useTemplate('defTpt2','/ref2015/refSatker_form');

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
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option'),'url_batal');
            $defTpt->addText($this->formAddData(),'sma_formcontent');
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
    /*Tab 1*/
    function buildGrid($tmp = '') {

        $SQL  = " select   *,
                           ref_satker_id as id,
                           case when ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible
                  from     ref_satker
                  order by ref_satker_label
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Satuan Kerja Kominfo';
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
        	'ref_satker_id' => 'ID',
            'ref_satker_label' => 'Label',
            'ref_satker_kode' => 'Kode',
            'status_visible' => 'Tampil?',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'ref_satker_id' => '50',
            'ref_satker_kode' => '100',
            'status_visible' => '100',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			'ref_satker_id' => 'numeric',
        );

        $sgkMod->directive['grid_fields_format'] = array(
			'ref_satker_id' => 'numeric',
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

            $SQL = " select * from ref_satker where ref_satker_id = '".$this->getVar('rNum')."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
            
            $form->add('ref_satker_id','ID Data (!)','kendoNumeric',true,$rr['ref_satker_id'],array('extraAttributes'=>' style="width:100px;" '));
        }
        else {

            $form->add('ref_satker_id','ID Data','kendoNumeric',false,$rr['ref_satker_id'],array('extraAttributes'=>' style="width:100px;" '));
        }

        $form->add('ref_satker_label','Label (!)','text',true,$rr['ref_satker_label'],array('extraAttributes'=>' style="width:250px;" '));
        $form->add('ref_satker_kode','Kode (10 karakter)','text',false,$rr['ref_satker_kode'],array('extraAttributes'=>' style="width:100px;" maxlength="10" '));

        $selEnt =& $form->add('ref_stat_visible','Status Tampil (!)','kendoCombo',true,$rr['ref_stat_visible'],array('extraAttributes'=>' style="width:250px;" '));
        $selEnt->addOption('Tampil pada daftar pilihan','1');
        $selEnt->addOption('Sembunyikan pada daftar pilihan','2');

        if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit')) {

            $select =& $form->add('form_aksi','Ubah/Hapus?','kendoCombo',true,1,array('extraAttributes'=>' style="width:150px;'));
            $select->addOption('Ubah Data','1');
            $select->addOption('Hapus','9');
        }

        $form->add('submit','','submit',false,'Save',array('extraAttributes'=>' value="Save" '));

        $form->runForm();

        if ($form->dataVerified()) {
            
        $url_grid = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

           $ref_satker_id = $functDB->encap_numeric($form->getVar('ref_satker_id'));
           $ref_satker_label = $functDB->encap_string($form->getVar('ref_satker_label'),1);
           $ref_satker_kode = $functDB->encap_string($form->getVar('ref_satker_kode'));
           $ref_stat_visible = $functDB->encap_numeric($form->getVar('ref_stat_visible'));

           $form_aksi = $functDB->encap_numeric($form->getVar('form_aksi'));

           if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '1')) {

	            // check duplikasi id
	            if (($ref_satker_id != $rr['ref_satker_id']) && ($ref_satker_id > 0)) {

		            $SQLCekID = " select * from ref_satker where ref_satker_id = '".$ref_satker_id."' ";
		            $rhCekID  = $this->dbH->query($SQLCekID);
		            $functDB->dberror_show($rhCekID);
		            $rrCekID = $rhCekID->fetch();

		            if ($rrCekID['ref_satker_id'] > 0) {
			            die('<SCRIPT LANGUAGE="JavaScript">alert("ID Data telah digunakan oleh '.$rrCekID['ref_satker_label'].'. Gunakan ID lainnya"); window.location.href = "'.$url_grid.'";</SCRIPT>');
		            }
	            }

                $arrData = array (  'ref_satker_id' => $ref_satker_id,
                                    'ref_satker_label' => $ref_satker_label,
                                    'ref_satker_kode' => $ref_satker_kode,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_inp_by' => $member['idxNum'],
                                    'ref_stat_inp_time' => 'now()',
                                    );
                $functDB->dbupd("ref_satker",$arrData,"ref_satker_id = ".$this->getVar('rNum'));

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            elseif (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '9')) {

                // allowed to delete
                $functDB->dbdelete("ref_satker","ref_satker_id = ".$this->getVar('rNum'),'');
                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            else {

                 if ($ref_satker_id > 0) {
                     $arrData = array ( 'ref_satker_id' => $ref_satker_id,
                                        'ref_satker_label' => $ref_satker_label,
                                        'ref_satker_kode' => $ref_satker_kode,
                                        'ref_stat_visible' => $ref_stat_visible,
                                        'ref_stat_inp_by' => $member['idxNum'],
                                        'ref_stat_inp_time' => 'now()',
                                        );
                 }
                 else {
                     $arrData = array ( 'ref_satker_label' => $ref_satker_label,
                                        'ref_satker_kode' => $ref_satker_kode,
                                        'ref_stat_visible' => $ref_stat_visible,
                                        'ref_stat_inp_by' => $member['idxNum'],
                                        'ref_stat_inp_time' => 'now()',
                                        );
                 }
                 $functDB->dbins('ref_satker',$arrData);

                 die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }

        }
        else {

            return ($form->output());
        }
    }

}


?>
