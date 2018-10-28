<?php

class refJenisAset extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refJenisAset');
        $this->useTemplate('defTpt2','/ref2015/refJenisAset_form');

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
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=refSpesifikasi','popUrl_detailData');

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
                           astgrp_id as id,
                           case when ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                           coalesce((select count(*) as jml from ref_aset_grup_spek where astgrpspek_id_grup = astgrp_id),0) as jmlspek
                  from     ref_aset_grup
                  order by astgrp_id
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Jenis Aset';
        $sgkMod->directive['sm_function'] = 'buildGrid';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

        $sgkMod->directive['element_add_formtechnique'] = 'jsf';
        $sgkMod->directive['element_add_jsf'] = 'addNewData()';
        $sgkMod->directive['sgk_reload_jsf'] = 'gridReload()';
        $sgkMod->directive['grid_btnDetail'] = true;
        $sgkMod->directive['grid_btnDetail_useDefault'] = false;
        $sgkMod->directive['grid_btnDetail_jsfCustom'] = 'detailGrid';
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
        	'astgrp_id' => 'ID',
            'astgrp_label' => 'Jenis',
            'astgrp_kode' => 'Kode',
            'status_visible' => 'Tampil?',
            'astgrp_desc' => 'Penjelasan',
            'jmlspek' => 'Spesifikasi',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'astgrp_id' => '50',
            'astgrp_label' => '200',
            'astgrp_kode' => '100',
            'status_visible' => '100',
            'jmlspek' => '50',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			'astgrp_id' => 'numeric',
			'jmlspek' => 'numeric',
        );

        $sgkMod->directive['grid_fields_format'] = array(
			'astgrp_id' => 'numeric',
			'jmlspek' => 'numeric',
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

            $SQL = " select * from ref_aset_grup where astgrp_id = '".$this->getVar('rNum')."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
        }
        else {

        }

        $form->add('astgrp_id','ID Data','kendoNumeric',false,$rr['astgrp_id'],array('extraAttributes'=>' style="width:100px;" '));
        $form->add('astgrp_label','Label (!)','text',true,$rr['astgrp_label'],array('extraAttributes'=>' style="width:250px;" '));
        $form->add('astgrp_kode','Kode (5 karakter)','text',false,$rr['astgrp_kode'],array('extraAttributes'=>' style="width:100px;" maxlength="5" '));

        $selEnt =& $form->add('ref_stat_visible','Status Tampil (!)','kendoCombo',true,$rr['ref_stat_visible'],array('extraAttributes'=>' style="width:250px;" '));
        $selEnt->addOption('Tampil pada daftar pilihan','1');
        $selEnt->addOption('Sembunyikan pada daftar pilihan','2');

        $form->add('astgrp_desc','Penjelasan','textArea',false,$rr['astgrp_desc'],array('extraAttributes'=>' style="width:250px; height:100px;" '));

        if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit')) {

            $select =& $form->add('form_aksi','Ubah/Hapus?','kendoCombo',true,1,array('extraAttributes'=>' style="width:150px;'));
            $select->addOption('Ubah Data','1');
            $select->addOption('Hapus','9');
        }

        $form->add('submit','','submit',false,'Save',array('extraAttributes'=>' value="Save" '));

        $form->runForm();

        if ($form->dataVerified()) {
            
           $url_grid = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

           $astgrp_id = $functDB->encap_numeric($form->getVar('astgrp_id'));
           $astgrp_label = $functDB->encap_string($form->getVar('astgrp_label'),1);
           $astgrp_kode = $functDB->encap_string($form->getVar('astgrp_kode'));
           $ref_stat_visible = $functDB->encap_numeric($form->getVar('ref_stat_visible'));
           $astgrp_desc = $functDB->encap_string($form->getVar('astgrp_desc'),1);

           $form_aksi = $functDB->encap_numeric($form->getVar('form_aksi'));

           if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '1')) {

	            // check duplikasi id
	            if (($ref_prov_id != $rr['ref_prov_id']) && ($ref_prov_id > 0)) {

		            $SQLCekID = " select * from ref_aset_grup where astgrp_id = '".$astgrp_id."' ";
		            $rhCekID  = $this->dbH->query($SQLCekID);
		            $functDB->dberror_show($rhCekID);
		            $rrCekID = $rhCekID->fetch();

		            if ($rrCekID['ref_prov_id'] > 0) {
			            die('<SCRIPT LANGUAGE="JavaScript">alert("ID Data telah digunakan oleh '.$rrCekID['astgrp_label'].'. Gunakan ID lainnya"); window.location.href = "'.$url_grid.'";</SCRIPT>');
		            }
	            }

                $arrData = array (  'astgrp_id' => $astgrp_id,
                                    'astgrp_label' => $astgrp_label,
                                    'astgrp_kode' => $astgrp_kode,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'astgrp_desc' => $astgrp_desc,
                                    'ref_stat_lastchange_by' => $member['idxNum'],
                                    'ref_stat_lastchange_time' => 'now()',
                                    );
                $functDB->dbupd("ref_aset_grup",$arrData,"astgrp_id = ".$this->getVar('rNum'));

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            elseif (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '9')) {

                // allowed to delete
                $functDB->dbdelete("ref_aset_grup","astgrp_id = ".$this->getVar('rNum'),'');
                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            else {

                $arrData = array ( 'astgrp_label' => $astgrp_label,
                                   'astgrp_kode' => $astgrp_kode,
                                   'ref_stat_visible' => $ref_stat_visible,
                                   'astgrp_desc' => $astgrp_desc,
                                   'ref_stat_input_by' => $member['idxNum'],
                                   'ref_stat_input_time' => 'now()',
                                   );
                if ($astgrp_id > 0) {
	                $arrData['astgrp_id'] = $astgrp_id;
                }
                $functDB->dbins('ref_aset_grup',$arrData);

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }

        }
        else {

            return ($form->output());
        }
    }

}


?>
