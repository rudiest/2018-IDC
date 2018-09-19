<?php

class refPngJawab extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refPngJawab');
        $this->useTemplate('defTpt2','/ref2015/refPngJawab_form');

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

            $$functDB =& $this->loadModule('functionDB');

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

        $SQL  = " select   ref_penanggungjawab.*,
                           pngjwb_id as id,
                           case when ref_penanggungjawab.ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                           ref_satker_label
                  from     ref_penanggungjawab
                              left join ref_satker on pngjwb_id_satker = ref_satker_id
                  order by pngjwb_id
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Penanggung Jawab Aset';
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
        	'pngjwb_id' => 'ID',
            'pngjwb_label' => 'Label',
            'pngjwb_kode' => 'Kode',
            'pngjwb_telp' => 'Telp',
            'pngjwb_email' => 'Email',
            'ref_satker_label' => 'Satker',
            'pngjwb_keterangan' => 'Keterangan',
            'status_visible' => 'Tampil?',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'pngjwb_id' => '50',
            'pngjwb_label' => '200',
            'pngjwb_kode' => '100',
            'pngjwb_telp' => '100',
            'pngjwb_email' => '100',
            'ref_satker_label' => '150',
            'status_visible' => '100',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			'jnsfungsi_id' => 'pngjwb_id',
        );

        $sgkMod->directive['grid_fields_format'] = array(
			'jnsfungsi_id' => 'pngjwb_id',
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

            $SQL = " select * from ref_penanggungjawab where pngjwb_id = '".$this->getVar('rNum')."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
        }
        else {

        }

        $form->add('pngjwb_id','ID Data','kendoNumeric',false,$rr['pngjwb_id'],array('extraAttributes'=>' style="width:100px;" '));
        $form->add('pngjwb_label','Label (!)','text',true,$rr['pngjwb_label'],array('extraAttributes'=>' style="width:250px;" '));
        $form->add('pngjwb_kode','Kode (5 karakter)','text',false,$rr['pngjwb_kode'],array('extraAttributes'=>' style="width:100px;" maxlength="5" '));

        $form->add('pngjwb_telp','Telp.','text',false,$rr['pngjwb_telp'],array('extraAttributes'=>' style="width:250px;" '));
        $form->add('pngjwb_email','Email','text',false,$rr['pngjwb_email'],array('extraAttributes'=>' style="width:250px;" '));
        
        $select =& $form->add('pngjwb_id_satker','Satuan Kerja','kendoDbCombo',false,$rr['pngjwb_id_satker']);
        $select->configure(array(
                    'tableName'           => "ref_satker",
                    'dataField'           => "ref_satker_id",
                    'viewField'           => "ref_satker_label",
                    'whereClause'         => "ref_stat_visible = 1 ",
                    'addNoOption'         => true,
                    'placeholder'         => 'Pilih Satker',
                    'extraAttributes'     => "style='width:100%;' ",
        ));

        $selEnt =& $form->add('ref_stat_visible','Status Tampil (!)','kendoCombo',true,$rr['ref_stat_visible'],array('extraAttributes'=>' style="width:250px;" '));
        $selEnt->addOption('Tampil pada daftar pilihan','1');
        $selEnt->addOption('Sembunyikan pada daftar pilihan','2');

        $form->add('pngjwb_keterangan','Keterangan','textArea',false,$rr['pngjwb_keterangan'],array('extraAttributes'=>' style="width:250px; height:75px;" '));

        if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit')) {

            $select =& $form->add('form_aksi','Ubah/Hapus?','kendoCombo',true,1,array('extraAttributes'=>' style="width:150px;'));
            $select->addOption('Ubah Data','1');
            $select->addOption('Hapus','9');
        }

        $form->add('submit','','submit',false,'Save',array('extraAttributes'=>' value="Save" '));

        $form->runForm();

        if ($form->dataVerified()) {
            
           $url_grid = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

           $pngjwb_id = $functDB->encap_numeric($form->getVar('pngjwb_id'));
           $pngjwb_id_satker = $functDB->encap_numeric($form->getVar('pngjwb_id_satker'));
           $pngjwb_label = $functDB->encap_string($form->getVar('pngjwb_label'),1);
           $pngjwb_kode = $functDB->encap_string($form->getVar('pngjwb_kode'));
           $pngjwb_telp = $functDB->encap_string($form->getVar('pngjwb_telp'));
           $pngjwb_email = $functDB->encap_string($form->getVar('pngjwb_email'));
           $pngjwb_keterangan = $functDB->encap_string($form->getVar('pngjwb_keterangan'),1);

           $ref_stat_visible = $functDB->encap_numeric($form->getVar('ref_stat_visible'));

           $form_aksi = $functDB->encap_numeric($form->getVar('form_aksi'));

           if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '1')) {

	            // check duplikasi id
	            if (($pngjwb_id != $rr['pngjwb_id']) && ($pngjwb_id > 0)) {

		            $SQLCekID = " select * from ref_penanggungjawab where pngjwb_id = '".$pngjwb_id."' ";
		            $rhCekID  = $this->dbH->query($SQLCekID);
		            $functDB->dberror_show($rhCekID);
		            $rrCekID = $rhCekID->fetch();

		            if ($rrCekID['pngjwb_id'] > 0) {
			            die('<SCRIPT LANGUAGE="JavaScript">alert("ID Data telah digunakan oleh '.$rrCekID['pngjwb_label'].'. Gunakan ID lainnya"); window.location.href = "'.$url_grid.'";</SCRIPT>');
		            }
	            }

                $arrData = array (  'pngjwb_id' => $pngjwb_id,
                                    'pngjwb_label' => $pngjwb_label,
                                    'pngjwb_kode' => $pngjwb_kode,
                                    'pngjwb_telp' => $pngjwb_telp,
                                    'pngjwb_email' => $pngjwb_email,
                                    'pngjwb_id_satker' => $pngjwb_id_satker,
                                    'pngjwb_keterangan' => $pngjwb_keterangan,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_lastchange_by' => $member['idxNum'],
                                    'ref_stat_lastchange_time' => 'now()',
                                    );
                $functDB->dbupd("ref_penanggungjawab",$arrData,"pngjwb_id = ".$this->getVar('rNum'));

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            elseif (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '9')) {

                // allowed to delete
                $functDB->dbdelete("ref_penanggungjawab","pngjwb_id = ".$this->getVar('rNum'),'');
                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            else {

                 $arrData = array ( 'pngjwb_label' => $pngjwb_label,
                                    'pngjwb_kode' => $pngjwb_kode,
                                    'pngjwb_telp' => $pngjwb_telp,
                                    'pngjwb_email' => $pngjwb_email,
                                    'pngjwb_id_satker' => $pngjwb_id_satker,
                                    'pngjwb_keterangan' => $pngjwb_keterangan,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_input_by' => $member['idxNum'],
                                    'ref_stat_input_time' => 'now()',
                                    );

                 if ($pngjwb_id > 0) {
	                 $arrData['pngjwb_id'] = $pngjwb_id;
                 }

                 $functDB->dbins('ref_penanggungjawab',$arrData);

                 die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }

        }
        else {

            return ($form->output());
        }
    }

}


?>
