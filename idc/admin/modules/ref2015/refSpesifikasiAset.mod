<?php

class refSpesifikasiAset extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refSpesifikasiAset');
        $this->useTemplate('defTpt2','/ref2015/refSpesifikasiAset_form');
        $this->useTemplate('defTpt3','/ref2015/refSpesifikasiAset_form2');
        
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
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=refSpesifikasi&rNum='.$this->getVar('rNum'),'url_batal');
            
        }
        elseif ( $this->getVar('popMode') == 'formCopyData' ) {

            $defTpt =& $this->getResource('defTpt3');
            $defTpt->addText($this->formCopyData(),'sma_formcontent');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=refSpesifikasi&rNum='.$this->getVar('rNum'),'url_batal');
        }
        else {

            $functDB =& $this->loadModule('functionDB');
            
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=formData&rNum='.$this->getVar('rNum'),'popUrl_modifyData');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=formCopyData&rNum='.$this->getVar('rNum'),'popUrl_copyData');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=refJenisAset','popUrl_bactToJenis');
            
            $defTpt->addtext($this->infoGrupAset($this->getVar('rNum')),'sma_info');
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
    function infoGrupAset($id = 0) {

	    $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

	    $html  = '';
	    $html .= '<table width="100%" border="0" cellspacing="0" cellpadding="4">';

		$SQL = " select * from ref_aset_grup where astgrp_id = '".$id."' ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);
        $rr = $rh->fetch();

        $html .= '<tr>';
        $html .= ' <td align="left" width="150">Grup Aset</td>';
        $html .= ' <td align="left" >'.$rr['astgrp_label'].'</td>';
        $html .= ' <td align="left" valign="top" width="150"><button class="btn btn-default" onclick="backToJenis()">Kembali Ke Jenis</button></td>';
        $html .= '</tr>';
        $html .= '<tr>';
        $html .= ' <td align="left" width="150">Kode Aset</td>';
        $html .= ' <td align="left" >'.$rr['astgrp_kode'].'</td>';
        $html .= ' <td align="left" valign="bottom" rowspan="2" width="150"><button class="btn btn-default" onclick="copyData()">Salin Spesifikasi</button></td>';
        $html .= '</tr>';
        $html .= '<tr>';
        $html .= ' <td align="left" width="150">Penjelasan</td>';
        $html .= ' <td align="left" >'.$rr['astgrp_desc'].'</td>';
        $html .= '</tr>';

	    $html .= '</table>';
	    return $html;

    }

    function buildGrid($tmp = '') {

        $SQL  = " select   *,
                           astgrpspek_id as id,
                           case when astgrpspek_isangka = 1 then 'Angka' else 'Teks' end as tipe_nilai,
                           case when ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible
                  from     ref_aset_grup_spek
                  where    astgrpspek_id_grup = '".$this->getVar('rNum')."'
                  order by astgrpspek_urutan
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Spesifikasi Aset';
        $sgkMod->directive['sm_function'] = 'buildGrid';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&rNum='.$this->getVar('rNum');
        $sgkMod->directive['ds_pageSize'] = '50';

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
            'astgrpspek_label' => 'Spesifikasi',
            'astgrpspek_kode' => 'Kode',
            'astgrpspek_keterangan' => 'Penjelasan',
            'tipe_nilai' => 'Tipe',
            'astgrpspek_satuan' => 'Satuan',
            'astgrpspek_urutan' => 'Urutan',
            'status_visible' => 'Tampil?',
        );

        $sgkMod->directive['grid_fields_width'] = array(
        	'astgrpspek_label' => '250',
            'astgrpspek_kode' => '50',
            'tipe_nilai' => '50',
            'astgrpspek_satuan' => '100',
            'astgrpspek_urutan' => '50',
            'status_visible' => '100',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			'astgrpspek_urutan' => 'numeric',
        );

        $sgkMod->directive['grid_fields_format'] = array(
			'astgrpspek_urutan' => 'numeric',
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }

	function formCopyData() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $form =& $this->newSmartForm();
        
        $form->directive['formParams'] = ' role="form" ';
        $form->directive['formClassTag'] = 'form-horizontal';
        

        $SQL = " select * from ref_aset_grup where astgrp_id = '".$this->getVar('rNum')."' ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);
        $rr = $rh->fetch();

        $select =& $form->add('idGrup','Grup Yang Akan Disalin','kendoDbCombo',false,'');
        $select->configure(array(
                    'tableName'           => "ref_aset_grup",
                    'dataField'           => "astgrp_id",
                    'viewField'           => "astgrp_label",
                    'whereClause'         => "astgrp_id <> '".$this->getVar('rNum')."' and ref_stat_visible = 1 ",
                    'addNoOption'         => true,
                    'noOptionDisplay'     => "Pilih Grup",
                    'extraAttributes'     => "style='width:250px;' ",
        ));

        $form->add('submit','','submit',false,'Save',array('extraAttributes'=>' value="Save" '));

        $form->runForm();

        if ($form->dataVerified()) {
            
           $url_grid = $this->sessionH->uLink('m2.php').'&option=refSpesifikasi&rNum='.$this->getVar('rNum');

           $idGrup = $functDB->encap_numeric($form->getVar('idGrup'));

           $SQL2 = " select * from ref_aset_grup_spek where astgrpspek_id_grup = '".$idGrup."' order by astgrpspek_urutan";
	       $rh2  = $this->dbH->query($SQL2);
	       $functDB->dberror_show($rh2);
	       while ($rr2 = $rh2->fetch()) {

		        $astgrpspek_label = $functDB->encap_string($rr2['astgrpspek_label'],1);
	            $astgrpspek_kode = $functDB->encap_string($rr2['astgrpspek_kode']);
	            $astgrpspek_keterangan = $functDB->encap_string($rr2['astgrpspek_keterangan'],1);
	            $astgrpspek_satuan = $functDB->encap_string($rr2['astgrpspek_satuan']);
	            $astgrpspek_isangka = $functDB->encap_numeric($rr2['astgrpspek_isangka']);
	            $ref_stat_visible = $functDB->encap_numeric($rr2['ref_stat_visible']);

		        $SQLCekID = " select max(astgrpspek_urutan) as maks from ref_aset_grup_spek where astgrpspek_id_grup = '".$this->getVar('rNum')."' ";
		        $rhCekID  = $this->dbH->query($SQLCekID);
		        $functDB->dberror_show($rhCekID);
		        $rrCekID = $rhCekID->fetch();

		        $astgrpspek_urutan = $rrCekID['maks'] + 1;

                $arrData = array ( 'astgrpspek_id_grup' => $this->getVar('rNum'),
                                   'astgrpspek_label' => $astgrpspek_label,
                                   'astgrpspek_kode' => $astgrpspek_kode,
                                   'astgrpspek_isangka' => $astgrpspek_isangka,
                                   'astgrpspek_satuan' => $astgrpspek_satuan,
                                   'astgrpspek_keterangan' => $astgrpspek_keterangan,
                                   'astgrpspek_urutan' => $astgrpspek_urutan,
                                   'ref_stat_visible' => $ref_stat_visible,
                                   'ref_stat_input_by' => $member['idxNum'],
                                   'ref_stat_input_time' => 'now()',
                                   );
                $functDB->dbins('ref_aset_grup_spek',$arrData);

	       }

           die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');

        }
        else {

            return ($form->output());
        }
    }

    function formAddData() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $form =& $this->newSmartForm();
        
        $form->directive['formParams'] = ' role="form" ';
        $form->directive['formClassTag'] = 'form-horizontal';
        

        if (($this->getVar('rNum2') > 0) && ($this->getVar('sType') == 'edit')) {

            $SQL = " select * from ref_aset_grup_spek where astgrpspek_id = '".$this->getVar('rNum2')."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
        }
        else {

        }

        $form->add('astgrpspek_id','ID Data','kendoNumeric',false,$rr['astgrpspek_id'],array('extraAttributes'=>' style="width:100px;" '));
        $form->add('astgrpspek_label','Label (!)','text',true,$rr['astgrpspek_label'],array('extraAttributes'=>' style="width:350px;" '));
        $form->add('astgrpspek_kode','Kode (5 karakter)','text',false,$rr['astgrpspek_kode'],array('extraAttributes'=>' style="width:100px;" maxlength="5" '));

        $form->add('astgrpspek_keterangan','Penjelasan','textArea',false,$rr['astgrpspek_keterangan'],array('extraAttributes'=>' style="width:350px; height:100px;" '));

        $selEnt =& $form->add('astgrpspek_isangka','Tipe Nilai','kendoCombo',true,$rr['astgrpspek_isangka'],array('extraAttributes'=>' style="width:250px;" '));
        $selEnt->addOption('Angka','1');
        $selEnt->addOption('Teks','2');

        $form->add('astgrpspek_satuan','Satuan','text',false,$rr['astgrpspek_satuan'],array('extraAttributes'=>' style="width:100px;" maxlength="5" '));
        $form->add('astgrpspek_urutan','Urutan Tampil','kendoNumeric',false,$rr['astgrpspek_urutan'],array('extraAttributes'=>' style="width:100px;" maxlength="5" '));

        $selEnt =& $form->add('ref_stat_visible','Status Tampil (!)','kendoCombo',true,$rr['ref_stat_visible'],array('extraAttributes'=>' style="width:250px;" '));
        $selEnt->addOption('Tampil pada daftar pilihan','1');
        $selEnt->addOption('Sembunyikan pada daftar pilihan','2');

        if (($this->getVar('rNum2') > 0) && ($this->getVar('sType') == 'edit')) {

            $select =& $form->add('form_aksi','Ubah/Hapus?','kendoCombo',true,1,array('extraAttributes'=>' style="width:150px;'));
            $select->addOption('Ubah Data','1');
            $select->addOption('Hapus','9');
        }

        $form->add('submit','','submit',false,'Save',array('extraAttributes'=>' value="Save" '));

        $form->runForm();

        if ($form->dataVerified()) {
            
           $url_grid = $this->sessionH->uLink('m2.php').'&option=refSpesifikasi&rNum='.$this->getVar('rNum');

           $astgrpspek_id = $functDB->encap_numeric($form->getVar('astgrpspek_id'));
           $astgrpspek_label = $functDB->encap_string($form->getVar('astgrpspek_label'),1);
           $astgrpspek_kode = $functDB->encap_string($form->getVar('astgrpspek_kode'));
           $astgrpspek_keterangan = $functDB->encap_string($form->getVar('astgrpspek_keterangan'),1);
           $astgrpspek_satuan = $functDB->encap_string($form->getVar('astgrpspek_satuan'));

           $astgrpspek_urutan = $functDB->encap_numeric($form->getVar('astgrpspek_urutan'));
           $astgrpspek_isangka = $functDB->encap_numeric($form->getVar('astgrpspek_isangka'));
           $ref_stat_visible = $functDB->encap_numeric($form->getVar('ref_stat_visible'));

           $form_aksi = $functDB->encap_numeric($form->getVar('form_aksi'));

           if (($this->getVar('rNum2') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '1')) {

	            // check duplikasi id
	            if (($ref_prov_id != $rr['ref_prov_id']) && ($ref_prov_id > 0)) {

		            $SQLCekID = " select * from ref_aset_grup_spek where astgrpspek_id = '".$astgrpspek_id."' ";
		            $rhCekID  = $this->dbH->query($SQLCekID);
		            $functDB->dberror_show($rhCekID);
		            $rrCekID = $rhCekID->fetch();

		            if ($rrCekID['ref_prov_id'] > 0) {
			            die('<SCRIPT LANGUAGE="JavaScript">alert("ID Data telah digunakan oleh '.$rrCekID['astgrpspek_label'].'. Gunakan ID lainnya"); window.location.href = "'.$url_grid.'";</SCRIPT>');
		            }
	            }

                $arrData = array (  'astgrpspek_id' => $astgrpspek_id,
                                    'astgrpspek_label' => $astgrpspek_label,
                                    'astgrpspek_kode' => $astgrpspek_kode,
                                    'astgrpspek_isangka' => $astgrpspek_isangka,
                                    'astgrpspek_satuan' => $astgrpspek_satuan,
                                    'astgrpspek_keterangan' => $astgrpspek_keterangan,
                                    'astgrpspek_urutan' => $astgrpspek_urutan,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_lastchange_by' => $member['idxNum'],
                                    'ref_stat_lastchange_time' => 'now()',
                                    );
                $functDB->dbupd("ref_aset_grup_spek",$arrData,"astgrpspek_id = ".$this->getVar('rNum2'));

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            elseif (($this->getVar('rNum2') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '9')) {

                // allowed to delete
                $functDB->dbdelete("ref_aset_grup_spek","astgrpspek_id = ".$this->getVar('rNum2'),'');
                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            else {

	            if (!($astgrpspek_urutan > 0)) {

		            $SQLCekID = " select max(astgrpspek_urutan) as maks from ref_aset_grup_spek where astgrpspek_id_grup = '".$this->getVar('rNum')."' ";
		            $rhCekID  = $this->dbH->query($SQLCekID);
		            $functDB->dberror_show($rhCekID);
		            $rrCekID = $rhCekID->fetch();

		            $astgrpspek_urutan = $rrCekID['maks'] + 1;
	            }

                $arrData = array ( 'astgrpspek_id_grup' => $this->getVar('rNum'),
                                   'astgrpspek_label' => $astgrpspek_label,
                                   'astgrpspek_kode' => $astgrpspek_kode,
                                   'astgrpspek_isangka' => $astgrpspek_isangka,
                                   'astgrpspek_satuan' => $astgrpspek_satuan,
                                   'astgrpspek_keterangan' => $astgrpspek_keterangan,
                                   'astgrpspek_urutan' => $astgrpspek_urutan,
                                   'ref_stat_visible' => $ref_stat_visible,
                                   'ref_stat_input_by' => $member['idxNum'],
                                   'ref_stat_input_time' => 'now()',
                                   );
                $functDB->dbins('ref_aset_grup_spek',$arrData);

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }

        }
        else {

            return ($form->output());
        }
    }

}


?>
