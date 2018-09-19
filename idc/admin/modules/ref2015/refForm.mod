<?php

class refForm extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refForm');
        $this->useTemplate('defTpt2','/ref2015/refForm_form');

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
        
        if ($this->getVar('option') == 'refForm') {
            
            $SQL  = " select   *,
                               ref_form_id as id,
                               case when ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                               concat('<a href=\"',ref_form_file,'\" target=\"_blank\">View File</a>') as fileviewer
                      from     ref_formulir
                      order by ref_form_label
                      ";
        }
        else {
            
            $SQL  = " select   *,
                               ref_form_id as id,
                               concat('<a href=\"',ref_form_file,'\" target=\"_blank\">View File</a>') as fileviewer
                      from     ref_formulir
                      where    ref_stat_visible = 1
                      order by ref_form_label
                      ";
        }
        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Formulir Aset Kominfo';
        $sgkMod->directive['sm_function'] = 'buildGrid';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

        $sgkMod->directive['element_add_formtechnique'] = 'jsf';
        $sgkMod->directive['element_add_jsf'] = 'addNewData()';
        $sgkMod->directive['sgk_reload_jsf'] = 'gridReload()';
        
        if ($this->getVar('option') == 'refForm') {
            $sgkMod->directive['grid_btnDetail'] = false;
            $sgkMod->directive['grid_btnEdit'] = true;
            $sgkMod->directive['grid_btnEdit_useDefault'] = false;
            $sgkMod->directive['grid_btnEdit_jsfCustom'] = 'editGrid';
            $sgkMod->directive['grid_btnDelete'] = false;
            $sgkMod->directive['grid_btnDelete_useDefault'] = false;
            $sgkMod->directive['grid_btnDelete_jsfCustom'] = '';
            
            $sgkMod->directive['inw3x3_headleft'] = array('add');
        }
        else {
            $sgkMod->directive['grid_btnDetail'] = false;
            $sgkMod->directive['grid_btnEdit'] = false;
            $sgkMod->directive['grid_btnDelete'] = false;
            
            $sgkMod->directive['inw3x3_headleft'] = array('');
        }
        
        $sgkMod->directive['wrapper_useDefault'] = false;

        $sgkMod->directive['inw3x3_headright'] = array('search');
        $sgkMod->directive['inw3x3_footright'] = array('');
        
        $sgkMod->directive['grid_isgroupable'] = false;
        $sgkMod->directive['grid_isselectable'] = true;
        $sgkMod->directive['grid_columnmenu'] = false;
        $sgkMod->directive['grid_isfilterable'] = false;
        $sgkMod->directive['grid_isresize'] = false;
        $sgkMod->directive['grid_isreorder'] = false;

        if ($this->getVar('option') == 'refForm') {
            $sgkMod->directive['grid_fields'] = array(
            	'ref_form_id' => 'ID',
                'ref_form_label' => 'Label',
                'ref_form_kode' => 'Kode',
                'fileviewer' => 'File',
                'status_visible' => 'Tampil?',
            );
        }
        else {
            $sgkMod->directive['grid_fields'] = array(
            	'ref_form_label' => 'Label',
                'ref_form_kode' => 'Kode',
                'fileviewer' => 'File',
            );
        }
        
        $sgkMod->directive['grid_fields_width'] = array(
            'ref_satker_id' => '50',
            'ref_satker_kode' => '100',
            'fileviewer' => '100',
            'status_visible' => '100',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			'ref_satker_id' => 'numeric',
        );

        $sgkMod->directive['grid_fields_format'] = array(
			'ref_satker_id' => 'numeric',
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
            'fileviewer' => true,
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }


    function formAddData() {
        
        if ($this->getVar('option') != 'refForm') {
            die('Error! misslink module ID');
        }

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $form =& $this->newSmartForm();
        
        $form->directive['formParams'] = ' role="form" ';
        $form->directive['formClassTag'] = 'form-horizontal';

        if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit')) {

            $SQL = " select * from ref_formulir where ref_form_id = '".$this->getVar('rNum')."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
            
            $form->add('ref_form_id','ID Data (!)','kendoNumeric',true,$rr['ref_form_id'],array('extraAttributes'=>' style="width:100px;" '));
        }
        else {

            $form->add('ref_form_id','ID Data','kendoNumeric',false,$rr['ref_form_id'],array('extraAttributes'=>' style="width:100px;" '));
        }

        $form->add('ref_form_label','Label (!)','text',true,$rr['ref_form_label'],array('extraAttributes'=>' style="width:250px;" '));
        $form->add('ref_form_kode','Kode (10 karakter)','text',false,$rr['ref_form_kode'],array('extraAttributes'=>' style="width:100px;" maxlength="10" '));

        if ((file_exists($rr['ref_form_file'])) && (strlen(trim($rr['ref_form_file'])) > 0)) {
            $form->addText('<a class="btn btn-default" href="'.$rr['ref_form_file'].'" target="_blank">View File Formulir</a>');
            $form->add('ref_form_file_ctn','Upload Pengganti','kendoUpload',false,'',array('kendoJsExtra'=>'multiple: false, template: kendo.template($("#fileTemplate").html())', 'extraAttributes'=>' style="width:250px;" maxlength="250" '));
        }
        else {
            $form->add('ref_form_file_ctn','Upload Formulir (!)','kendoUpload',true,'',array('kendoJsExtra'=>'multiple: false, template: kendo.template($("#fileTemplate").html())', 'extraAttributes'=>' style="width:250px;" maxlength="250" '));
        }
        

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

           $ref_form_id = $functDB->encap_numeric($form->getVar('ref_form_id'));
           $ref_form_label = $functDB->encap_string($form->getVar('ref_form_label'),1);
           $ref_form_kode = $functDB->encap_string($form->getVar('ref_form_kode'));
           $ref_stat_visible = $functDB->encap_numeric($form->getVar('ref_stat_visible'));

           $form_aksi = $functDB->encap_numeric($form->getVar('form_aksi'));

           if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '1')) {

	            // check duplikasi id
	            if (($ref_form_id != $rr['ref_form_id']) && ($ref_form_id > 0)) {

		            $SQLCekID = " select * from ref_formulir where ref_form_id = '".$ref_form_id."' ";
		            $rhCekID  = $this->dbH->query($SQLCekID);
		            $functDB->dberror_show($rhCekID);
		            $rrCekID = $rhCekID->fetch();

		            if ($rrCekID['ref_form_id'] > 0) {
			            die('<SCRIPT LANGUAGE="JavaScript">alert("ID Data telah digunakan oleh '.$rrCekID['ref_form_label'].'. Gunakan ID lainnya"); window.location.href = "'.$url_grid.'";</SCRIPT>');
		            }
	            }

                $arrData = array (  'ref_form_id' => $ref_form_id,
                                    'ref_form_label' => $ref_form_label,
                                    'ref_form_kode' => $ref_form_kode,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_inp_by' => $member['idxNum'],
                                    'ref_stat_inp_time' => 'now()',
                                    );
                $functDB->dbupd("ref_formulir",$arrData,"ref_form_id = ".$this->getVar('rNum'));
                
                $this->processUpload($ref_form_id);

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            elseif (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '9')) {

                // allowed to delete
                $functDB->dbdelete("ref_formulir","ref_form_id = ".$this->getVar('rNum'),'');
                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            else {

                 if ($ref_satker_id > 0) {
                     $arrData = array ( 'ref_form_id' => $ref_form_id,
                                        'ref_form_label' => $ref_form_label,
                                        'ref_form_kode' => $ref_form_kode,
                                        'ref_stat_visible' => $ref_stat_visible,
                                        'ref_stat_inp_by' => $member['idxNum'],
                                        'ref_stat_inp_time' => 'now()',
                                        );
                     $functDB->dbins('ref_formulir',$arrData);                  
                     $this->processUpload($ref_form_id);                   
                 }
                 else {
                     $arrData = array ( 'ref_form_label' => $ref_form_label,
                                        'ref_form_kode' => $ref_form_kode,
                                        'ref_stat_visible' => $ref_stat_visible,
                                        'ref_stat_inp_by' => $member['idxNum'],
                                        'ref_stat_inp_time' => 'now()',
                                        );
                     $functDB->dbins('ref_formulir',$arrData);
                     $lastInsertId = $this->dbH->lastInsertId();                   
                     $this->processUpload($lastInsertId);  
                 }
                 

                 die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }

        }
        else {

            return ($form->output());
        }
    }
    
    function processUpload($id = 0) {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        if ($this->getVar('option') != 'refForm') {
            die('Error! misslink module ID');
        }
        
        if ($id > 0) {
            
            include_once('phplib/class.upload.php');
        
            $handle = new upload($_FILES['ref_form_file_ctn']);
            if ($handle->uploaded) {
                
                $fileName = 'formaset_'.$this->getVar('rNum').'_'.rand(10,99).date('ymdhis');
                
                $handle->file_new_name_body   = $fileName;
                $handle->image_resize         = false;
                
                $handle->process('./materials/');
                if ($handle->processed) {
                    
                    $arrData = array ('ref_form_file' => $functDB->encap_string($handle->file_dst_pathname));
                    $functDB->dbupd("ref_formulir",$arrData,"ref_form_id = ".$id);
                } 
                else {
                    die($handle->error);
                }
            }
        }
        else {
            die('Error! id misslink. Please contact admin.');
        }
        
        return true;
    }

}


?>
