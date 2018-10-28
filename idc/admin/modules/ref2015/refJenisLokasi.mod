<?php

class refJenisLokasi extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refJenisLokasi');
        $this->useTemplate('defTpt2','/ref2015/refJenisLokasi_form');

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
                           jnsloc_id as id,
                           case when ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible
                  from     ref_lokasi_jenis
                  order by jnsloc_id
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Jenis Lokasi Aset';
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
        	'jnsloc_id' => 'ID',
            'jnsloc_label' => 'Label',
            'jnsloc_kode' => 'Kode',
            'status_visible' => 'Tampil?',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'jnsloc_id' => '50',
            'jnsloc_kode' => '100',
            'status_visible' => '100',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			'jnsloc_id' => 'numeric',
        );

        $sgkMod->directive['grid_fields_format'] = array(
			'jnsloc_id' => 'numeric',
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

            $SQL = " select * from ref_lokasi_jenis where jnsloc_id = '".$this->getVar('rNum')."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
        }
        else {

        }

        $form->add('jnsloc_id','ID Data (!)','kendoNumeric',true,$rr['jnsloc_id'],array('extraAttributes'=>' style="width:100px;" '));
        $form->add('jnsloc_label','Label (!)','text',true,$rr['jnsloc_label'],array('extraAttributes'=>' style="width:250px;" '));
        $form->add('jnsloc_kode','Kode (5 karakter)','text',false,$rr['jnsloc_kode'],array('extraAttributes'=>' style="width:100px;" maxlength="5" '));

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

           $jnsloc_id = $functDB->encap_numeric($form->getVar('jnsloc_id'));
           $jnsloc_label = $functDB->encap_string($form->getVar('jnsloc_label'),1);
           $jnsloc_kode = $functDB->encap_string($form->getVar('jnsloc_kode'));
           $ref_stat_visible = $functDB->encap_numeric($form->getVar('ref_stat_visible'));

           $form_aksi = $functDB->encap_numeric($form->getVar('form_aksi'));

           if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '1')) {

	            // check duplikasi id
	            if (($ref_prov_id != $rr['ref_prov_id']) && ($ref_prov_id > 0)) {

		            $SQLCekID = " select * from ref_lokasi_jenis where jnsloc_id = '".$jnsloc_id."' ";
		            $rhCekID  = $this->dbH->query($SQLCekID);
		            $functDB->dberror_show($rhCekID);
		            $rrCekID = $rhCekID->fetch();

		            if ($rrCekID['ref_prov_id'] > 0) {
			            die('<SCRIPT LANGUAGE="JavaScript">alert("ID Data telah digunakan oleh '.$rrCekID['jnsloc_label'].'. Gunakan ID lainnya"); window.location.href = "'.$url_grid.'";</SCRIPT>');
		            }
	            }

                $arrData = array (  'jnsloc_id' => $jnsloc_id,
                                    'jnsloc_label' => $jnsloc_label,
                                    'jnsloc_kode' => $jnsloc_kode,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_lastchange_by' => $member['idxNum'],
                                    'ref_stat_lastchange_time' => 'now()',
                                    );
                $functDB->dbupd("ref_lokasi_jenis",$arrData,"jnsloc_id = ".$this->getVar('rNum'));

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            elseif (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '9')) {

                // allowed to delete
                $functDB->dbdelete("ref_lokasi_jenis","jnsloc_id = ".$this->getVar('rNum'),'');
                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            else {

                 $arrData = array ( 'jnsloc_id' => $jnsloc_id,
                                    'jnsloc_label' => $jnsloc_label,
                                    'jnsloc_kode' => $jnsloc_kode,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_input_by' => $member['idxNum'],
                                    'ref_stat_input_time' => 'now()',
                                    );
                 $functDB->dbins('ref_lokasi_jenis',$arrData);

                 die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }

        }
        else {

            return ($form->output());
        }
    }

}


?>
