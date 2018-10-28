<?php

class refJenisKejadian extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refJenisKejadian');
        $this->useTemplate('defTpt2','/ref2015/refJenisKejadian_form');

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
    /*Tab 1*/
    function buildGrid($tmp = '') {

        $SQL  = " select   *,
                           jnskej_id as id,
                           case when ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible
                  from     ref_kejadian_jenis
                  order by jnskej_id
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Jenis Kejadian Pada Aset';
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
        	'jnskej_id' => 'ID',
            'jnskej_label' => 'Label',
            'jnskej_kode' => 'Kode',
            'status_visible' => 'Tampil?',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'jnskej_id' => '50',
            'jnskej_kode' => '100',
            'status_visible' => '100',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			'jnskej_id' => 'numeric',
        );

        $sgkMod->directive['grid_fields_format'] = array(
			'jnskej_id' => 'numeric',
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

            $SQL = " select * from ref_kejadian_jenis where jnskej_id = '".$this->getVar('rNum')."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
        }
        else {

        }

        $form->add('jnskej_id','ID Data (!)','kendoNumeric',true,$rr['jnskej_id'],array('extraAttributes'=>' style="width:100px;" '));
        $form->add('jnskej_label','Label (!)','text',true,$rr['jnskej_label'],array('extraAttributes'=>' style="width:250px;" '));
        $form->add('jnskej_kode','Kode (5 karakter)','text',false,$rr['jnskej_kode'],array('extraAttributes'=>' style="width:100px;" maxlength="5" '));

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

           $jnskej_id = $functDB->encap_numeric($form->getVar('jnskej_id'));
           $jnskej_label = $functDB->encap_string($form->getVar('jnskej_label'),1);
           $jnskej_kode = $functDB->encap_string($form->getVar('jnskej_kode'));
           $ref_stat_visible = $functDB->encap_numeric($form->getVar('ref_stat_visible'));

           $form_aksi = $functDB->encap_numeric($form->getVar('form_aksi'));

           if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '1')) {

	            // check duplikasi id
	            if (($jnskej_id != $rr['jnskej_id']) && ($jnskej_id > 0)) {

		            $SQLCekID = " select * from ref_kejadian_jenis where jnskej_id = '".$jnskej_id."' ";
		            $rhCekID  = $this->dbH->query($SQLCekID);
		            $functDB->dberror_show($rhCekID);
		            $rrCekID = $rhCekID->fetch();

		            if ($rrCekID['jnskej_id'] > 0) {
			            die('<SCRIPT LANGUAGE="JavaScript">alert("ID Data telah digunakan oleh '.$rrCekID['jnskej_label'].'. Gunakan ID lainnya"); window.location.href = "'.$url_grid.'";</SCRIPT>');
		            }
	            }

                $arrData = array (  'jnskej_id' => $jnskej_id,
                                    'jnskej_label' => $jnskej_label,
                                    'jnskej_kode' => $jnskej_kode,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_lastchange_by' => $member['idxNum'],
                                    'ref_stat_lastchange_time' => 'now()',
                                    );
                $functDB->dbupd("ref_kejadian_jenis",$arrData,"jnskej_id = ".$this->getVar('rNum'));

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            elseif (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '9')) {

                // allowed to delete
                $functDB->dbdelete("ref_kejadian_jenis","jnskej_id = ".$this->getVar('rNum'),'');
                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            else {

                 $arrData = array ( 'jnskej_id' => $jnskej_id,
                                    'jnskej_label' => $jnskej_label,
                                    'jnskej_kode' => $jnskej_kode,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_input_by' => $member['idxNum'],
                                    'ref_stat_input_time' => 'now()',
                                    );
                 $functDB->dbins('ref_kejadian_jenis',$arrData);

                 die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }

        }
        else {

            return ($form->output());
        }
    }

}


?>
