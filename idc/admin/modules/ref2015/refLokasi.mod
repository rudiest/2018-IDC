<?php

class refLokasi extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refLokasi');
        $this->useTemplate('defTpt2','/ref2015/refLokasi_form');

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
            
            if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit')) {

    	        $imgHtml = '';
        	    if ($this->getVar('rNum') > 0) {
        		    $pngFiles = './tmpImage/invastqrc2_'.$this->getVar('rNum').'.png';
        		    if (file_exists($pngFiles) && (strlen(trim($pngFiles))>0)) {
        			    $imgHtml = '<a href="#" onclick="openToPrint(\''.$pngFiles.'\')"><img src="'.$pngFiles.'?time='.time().'"></a><BR><BR><input type="button" value="Print QR Code" onclick="openToPrint(\''.$pngFiles.'\')">';
        		    }
        		    else {
        			    $imgHtml = 'Buat Ulang QRCode Dengan Menekan Tombol Save (disamping)';
        		    }
        	    }

                $defTpt->addText($imgHtml,'sma_formcontent2');
            }
        }
        elseif ( $this->getVar('popMode') == 'reGenQRlokasi' ) {

            $defTpt->addText($this->regenAllQr(),'popContent');
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

        $SQL  = " select   ref_aset_lokasi.*,
                           loc_id as id,
                           case when ref_aset_lokasi.ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                           jnsloc_label,
                           jnsloc_kode
                  from     ref_aset_lokasi
                  			 left join ref_lokasi_jenis on loc_id_jenislokasi = jnsloc_id
                  order by jnsloc_label, loc_label
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Lokasi Aset';
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
        	'loc_id' => 'ID',
            'jnsloc_label' => 'Jenis Lokasi',
            'loc_label' => 'Seri Lokasi',
            'loc_kode' => 'Kode Lokasi',
            'status_visible' => 'Tampil?',
        );

        $sgkMod->directive['grid_fields_width'] = array(
        	'loc_id' => '50',
            'loc_label' => '250',
            'loc_kode' => '100',
            'status_visible' => '100',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			'loc_id' => 'numeric',
        );

        $sgkMod->directive['grid_fields_format'] = array(
			'loc_id' => 'numeric',
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }

    function formGabungan() {

	    $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $fTpt =& $this->loadTemplate('/reference/refLokasiPopup');

        $fTpt->addText($this->formAddData(),'sma_form');

        if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit')) {

	        $imgHtml = '';
		    if ($this->getVar('rNum') > 0) {
			    $pngFiles = './tmpImage/invastqrc2_'.$this->getVar('rNum').'.png';
			    if (file_exists($pngFiles) && (strlen(trim($pngFiles))>0)) {
				    $imgHtml = '<a href="#" onclick="openToPrint(\''.$pngFiles.'\')"><img src="'.$pngFiles.'?time='.time().'"></a><BR><BR><input type="button" value="Print QR Code" onclick="openToPrint(\''.$pngFiles.'\')">';
			    }
			    else {

				    $imgHtml = 'Buat Ulang QRCode Dengan Menekan Tombol Save (disamping)';
			    }
		    }

		    $fTpt->addText($imgHtml,'sma_image');
        }

        return $fTpt->run();

    }

    function formAddData() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $form =& $this->newSmartForm();
        
        $form->directive['formParams'] = ' role="form" ';
        $form->directive['formClassTag'] = 'form-horizontal';

        if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit')) {

            $SQL = " select * from ref_aset_lokasi where loc_id = '".$this->getVar('rNum')."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
        }
        else {

        }

        $form->add('loc_id','ID Data (!)','kendoNumeric',true,$rr['loc_id'],array('extraAttributes'=>' style="width:100px;" '));

        $select =& $form->add('loc_id_jenislokasi','Jenis Lokasi','kendoDbCombo',true,$rr['loc_id_jenislokasi']);
        $select->configure(array(
                    'tableName'           => "ref_lokasi_jenis",
                    'dataField'           => "jnsloc_id",
                    'viewField'           => "jnsloc_label, jnsloc_kode",
                    'addNoOption'         => false,
                    'extraAttributes'     => "style='width:250px;' ",
        ));

        $form->add('loc_label','Seri / Label Lokasi (!)','text',true,$rr['loc_label'],array('extraAttributes'=>' style="width:250px;" '));
        $form->add('loc_kode','Kode (5 karakter)','text',false,$rr['loc_kode'],array('extraAttributes'=>' style="width:100px;" maxlength="5" '));

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

           $loc_id = $functDB->encap_numeric($form->getVar('loc_id'));
           $loc_id_jenislokasi = $functDB->encap_numeric($form->getVar('loc_id_jenislokasi'));
           $loc_label = $functDB->encap_string($form->getVar('loc_label'),1);
           $loc_kode = $functDB->encap_string($form->getVar('loc_kode'));
           $ref_stat_visible = $functDB->encap_numeric($form->getVar('ref_stat_visible'));

           $form_aksi = $functDB->encap_numeric($form->getVar('form_aksi'));

           if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '1')) {

	            // check duplikasi id
	            if (($ref_prov_id != $rr['ref_prov_id']) && ($ref_prov_id > 0)) {

		            $SQLCekID = " select * from ref_aset_lokasi where loc_id = '".$loc_id."' ";
		            $rhCekID  = $this->dbH->query($SQLCekID);
		            $functDB->dberror_show($rhCekID);
		            $rrCekID = $rhCekID->fetch();

		            if ($rrCekID['loc_id'] > 0) {
			            die('<SCRIPT LANGUAGE="JavaScript">alert("ID Data telah digunakan oleh '.$rrCekID['loc_label'].'. Gunakan ID lainnya"); window.location.href = "'.$url_grid.'";</SCRIPT>');
		            }
	            }

                $arrData = array (  'loc_id' => $loc_id,
                                    'loc_label' => $loc_label,
                                    'loc_kode' => $loc_kode,
                                    'loc_id_jenislokasi' => $loc_id_jenislokasi,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_lastchange_by' => $member['idxNum'],
                                    'ref_stat_lastchange_time' => 'now()',
                                    'astlok_refercode' => "sha(encode(".$this->getVar('rNum').",'(^_^)'))",
                                    );
                $functDB->dbupd("ref_aset_lokasi",$arrData,"loc_id = ".$this->getVar('rNum'));

                include('./qrcode/qrlib.php');

                $SQLGlobal = " select * from ref_global order by global_datetime desc limit 1 ";
	            $rhGlobal  = $this->dbH->query($SQLGlobal);
	            $functDB->dberror_show($rhGlobal);
	            $rrGlobal = $rhGlobal->fetch();

	            $SQLtoqr = " select * from ref_aset_lokasi where loc_id = '".$this->getVar('rNum')."' ";
	            $rhtoqr  = $this->dbH->query($SQLtoqr);
	            $functDB->dberror_show($rhtoqr);
	            $rrtoqr = $rhtoqr->fetch();

	            if (strlen(trim($rrtoqr['astlok_refercode']))>0) {
					$pngFiles = './tmpImage/invastqrc2_'.$loc_id.'.png';
					$codeToWrite = $rrGlobal['global_akses'].'/home/inq2.php?id='.$rrtoqr['astlok_refercode'];
					QRcode::png($codeToWrite, $pngFiles);
				}

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            elseif (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '9')) {

                // allowed to delete
                $functDB->dbdelete("ref_aset_lokasi","loc_id = ".$this->getVar('rNum'),'');
                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            else {

                 $arrData = array ( 'loc_id' => $loc_id,
                                    'loc_label' => $loc_label,
                                    'loc_kode' => $loc_kode,
                                    'loc_id_jenislokasi' => $loc_id_jenislokasi,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_input_by' => $member['idxNum'],
                                    'ref_stat_input_time' => 'now()',
                                    );
                 $functDB->dbins('ref_aset_lokasi',$arrData);

                 $lastInsertId = $this->dbH->lastInsertId();

                 $arrData = array ( 'astlok_refercode' => "sha(encode(".$lastInsertId.",'(^_^)'))",
                                    );
                 $functDB->dbupd("ref_aset_lokasi",$arrData,"loc_id = ".$lastInsertId);

                 include('./qrcode/qrlib.php');

                 $SQLGlobal = " select * from ref_global order by global_datetime desc limit 1 ";
	             $rhGlobal  = $this->dbH->query($SQLGlobal);
	             $functDB->dberror_show($rhGlobal);
	             $rrGlobal = $rhGlobal->fetch();

	             $SQLtoqr = " select * from ref_aset_lokasi where loc_id = '".$lastInsertId."' ";
	             $rhtoqr  = $this->dbH->query($SQLtoqr);
	             $functDB->dberror_show($rhtoqr);
	             $rrtoqr = $rhtoqr->fetch();

	             if (strlen(trim($rrtoqr['astlok_refercode']))>0) {
				 	$pngFiles = './tmpImage/invastqrc2_'.$lastInsertId.'.png';
				 	$codeToWrite = $rrGlobal['global_akses'].'/home/inq2.php?id='.$rrtoqr['astlok_refercode'];
				 	QRcode::png($codeToWrite, $pngFiles);
				 }

				 // $pngFiles = './tmpImage/invastqrc2_'.$lastInsertId.'.png';
				 // $codeToWrite = $rrGlobal['global_akses'].'/home/inq2.php?id='.$lastInsertId;
				 // QRcode::png($codeToWrite, $pngFiles);

                 die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }

        }
        else {

            return ($form->output());
        }
    }

    function regenAllQr() {

	    $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        include('./qrcode/qrlib.php');

        $SQLGlobal = " select * from ref_global order by global_datetime desc limit 1 ";
        $rhGlobal  = $this->dbH->query($SQLGlobal);
        $functDB->dberror_show($rhGlobal);
        $rrGlobal = $rhGlobal->fetch();

	    $SQL = " select * from ref_aset_lokasi ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);

        $html = '<table cellpadding="5" border="1">';
        $html .= '<tr>';
        $html .= ' <td>No</td>';
        $html .= ' <td>Aset</td>';
        $html .= ' <td>QR</td>';
        $html .= '</tr>';
        $htmlCounter = 0;
        while ($rr = $rh->fetch()) {

	        $arrData = array ( 'astlok_refercode' => "sha(encode(".$rr['loc_id'].",'(^_^)'))" );
            $functDB->dbupd("ref_aset_lokasi",$arrData,"loc_id = ".$rr['loc_id']);

            $SQLtoqr = " select * from ref_aset_lokasi where loc_id = '".$rr['loc_id']."' ";
            $rhtoqr  = $this->dbH->query($SQLtoqr);
            $functDB->dberror_show($rhtoqr);
            $rrtoqr = $rhtoqr->fetch();

            if (strlen(trim($rrtoqr['astlok_refercode']))>0) {
				$pngFiles = './tmpImage/invastqrc2_'.$rr['loc_id'].'.png';
				$codeToWrite = $rrGlobal['global_akses'].'/home/inq2.php?id='.$rrtoqr['astlok_refercode'];
				QRcode::png($codeToWrite, $pngFiles);
			}

        }

        return $html;
    }

}


?>
