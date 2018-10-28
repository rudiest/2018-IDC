<?php

class refDomain extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refDomain');
        $this->useTemplate('defTpt2','/ref2015/refDomain_form');

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
            
            $ajx_baseUrl = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajxcall';
            
            if (($this->getVar('sType') == 'edit') && ($this->getVar('rNum') > 0)) {
                $defTpt->addText('js_id_domain = '.$this->getVar('rNum').';','sma_js_id_domain');
            }
            else {
                $defTpt->addText('display: none;','sma_hide_div');
            }
            
            $defTpt->addText($ajx_baseUrl.'&aswid=rbi_ref_ip','url_ajxGetIP');
            $defTpt->addText($ajx_baseUrl.'&aswid=ajx_saveIP','url_ajxSaveIP');
            $defTpt->addText($ajx_baseUrl.'&aswid=ajx_delIP','url_removeAssetIP');
            $defTpt->addText($ajx_baseUrl.'&aswid=ajx_getAstIP','url_getAssetIP');
            
        }
        else {

            $functDB =& $this->loadModule('functionDB');

            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=formData','popUrl_modifyData');
            
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid=findServer','ajaxurl_detailGrid');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=r2_refAset&sType=viewServer','url_findServer');

            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=domainPdf','popUrl_cetakPdf');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=domainExcel','popUrl_cetakExcel');
            
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
    
    function rbi_ref_ip() {

        $arrayData = array();

        $whereClause = "";
        if (strlen(trim($_GET['filter']['filters']['0']['value']))>0) {
            $fil = $_GET['filter']['filters']['0']['value'];
            $whereClause = " and ( (lower(concat(ip_number,' ( ',coalesce(ast_label,''),' )')) like '%".$fil."%')
                                    )";
        }

		// map_a.map_ip_id is null
        $SQL = " select ip_id as id, 
                        case when ast_id is not null then 
                          concat(ip_number,' ( ',ast_label,' )')
                        else 
                          ip_number
                        end as value 
                 from   ref_ip 
                         left join ref_domain_ipmap map_a on map_a.map_id_ip = ip_id
                         left join ref_aset_ipmap map_b on map_b.map_id_ip = ip_id
                         left join ref_aset on map_b.map_id_aset = ast_id
                 where  ip_id is not null ".$whereClause."
                 order  by INET_ATON(ip_number)
                 limit  50
                 ";
        $rh  = $this->dbH->query($SQL);
        while ($rr = $rh->fetch()) {
            $arrayData[] = $rr;
        };

        die(json_encode($arrayData));
    }
    
    function ajx_saveIp() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        if (($this->getVar('rNum') > 0) && ($this->getVar('rNum2') > 0)) {
            
            $arrData = array ( 'map_id_domain' => $functDB->encap_numeric($this->getVar('rNum')),
                               'map_id_ip' => $functDB->encap_numeric($this->getVar('rNum2')),
                               'stat_inp_by' => $member['idxNum'],
                               'stat_inp_time' => 'now()',
                               );
            $functDB->dbins('ref_domain_ipmap',$arrData);
            
            $lastInsertId = $this->dbH->lastInsertId();
            
            $SQLaset = "select   *
                        from     ref_domain
                        where    ref_domain.domain_id = '".$this->getVar('rNum')."'
                        ";
            $rhAset  = $this->dbH->query($SQLaset);
            $functDB->dberror_show($rhAset);
            $rrAset = $rhAset->fetch();
            
            $SQLprev = "select   *
                        from     ref_domain_ipmap
                          			left join ref_ip on map_id_ip = ip_id
                        where    map_ip_id = '".$lastInsertId."'
                        ";
            $rhprev  = $this->dbH->query($SQLprev);
            $functDB->dberror_show($rhprev);
            $rrprev = $rhprev->fetch();
            
            $logubah_catatan = '[AUTO] Pemetaan IP '.$rrprev['ip_number'].' kepada domain "'.$rrAset['domain_label'];
            $arrData2 = array ( 'logubah_id_aset' => $this->getVar('rNum'),
            				    'logubah_catatan' => $functDB->encap_string($logubah_catatan),
            				    'logubah_tanggal' => 'now()',
            				    'logubah_waktu' => 'now()',
            				    'logubah_oleh' => $functDB->encap_string($member['firstName']),
            				    'trx_stat_input_by' => $member['idxNum'],
                                'trx_stat_input_time' => 'now()',
                                );
            $functDB->dbins("log_perubahan",$arrData2);
            
        }
        
        die();
        
    }
    
    function ajx_delIP() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $SQLaset = "select   *
                    from     ref_domain
                    where    ref_domain.domain_id = '".$this->getVar('rNum2')."'
                    ";
        $rhAset  = $this->dbH->query($SQLaset);
        $functDB->dberror_show($rhAset);
        $rrAset = $rhAset->fetch();
        
        $SQLprev = "select   *
                    from     ref_domain_ipmap
                      			left join ref_ip on map_id_ip = ip_id
                    where    map_ip_id = '".$this->getVar('rNum')."'
                    ";
        $rhprev  = $this->dbH->query($SQLprev);
        $functDB->dberror_show($rhprev);
        $rrprev = $rhprev->fetch();
        
        $logubah_catatan = '[AUTO] Penghapusan Pemetaan IP '.$rrprev['ip_number'].' dari domain "'.$rrAset['domain_label'];
        $arrData2 = array ( 'logubah_id_aset' => $this->getVar('rNum2'),
        				    'logubah_catatan' => $functDB->encap_string($logubah_catatan),
        				    'logubah_tanggal' => 'now()',
        				    'logubah_waktu' => 'now()',
        				    'logubah_oleh' => $functDB->encap_string($member['firstName']),
        				    'trx_stat_input_by' => $member['idxNum'],
                            'trx_stat_input_time' => 'now()',
                            );
        $functDB->dbins("log_perubahan",$arrData2);
        
        $functDB->dbdelete("ref_domain_ipmap","map_id_domain = ".$this->getVar('rNum2')." and map_ip_id = ".$this->getVar('rNum'),'');
        die();
    }
    
    function ajx_getAstIP() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $div_listOfIP = '<ul class="list-group">';
        $SQLlist = " select ref_ip.*,
                            ref_domain_ipmap.*,
                            ref_aset.*
                     from   ref_domain_ipmap, 
                            ref_ip 
                                left join ref_aset_ipmap map2 on map2.map_id_ip = ip_id
                                left join ref_aset on map2.map_id_aset = ast_id
                     where  ref_domain_ipmap.map_id_domain = '".$this->getVar('rNum')."' and 
                            ip_id = ref_domain_ipmap.map_id_ip 
                     order by 
                            INET_ATON(ip_number) 
                     ";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rowCount = 0;
        while ($rrlist = $rhlist->fetch()) {
            $rowCount++;
            $extraInfo = '';
            if ($rrlist['ast_id'] > 0) {
                $extraInfo = '<BR>('.$rrlist['ast_label'].')';
            }
            $div_listOfIP .= '<li class="list-group-item"><span class="badge"><a href="javascript:;" onclick="remove_ip('.$rrlist['map_ip_id'].')" style="color:white;">Hapus</a></span> '.$rrlist['ip_number'].' '.$extraInfo.'</li>';
        }
        if ($rowCount == 0) {
            $div_listOfIP .= '* belum ada pemetaan IP Address';
        }
        $div_listOfIP .= '</ul>';
        
        if (($this->getVar('popMode') == 'ajxcall') && ($this->getVar('aswid') == 'ajx_getAstIP')) {
            die($div_listOfIP);
        }
        else {
            return $div_listOfIP;
        }
    }

    /* 02: place other php function here */
    function findServer() {

	    $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

	    if ($_GET['id_domain'] > 0) {

		    $SQL = " select * from ref_domain where domain_id = '".$_GET['id_domain']."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();

            if (strlen(trim($rr['domain_refaset_id']))>0) {
                
                die($rr2['domain_refaset_id'].'');
            }
            else {

	            die('Data server dari domain '.$rr['domain_label'].' tidak ditemukan');
            }

	    }
	    else {

		    die('Error! misslink ID');
	    }

    }

    function buildGrid($tmp = '') {

        $SQL  = " select   ref_domain.*,
                           domain_id as id,
                           case when ref_domain.ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                           jnszona_label,
                           jnszona_kode,
                           pngjwb_label as tanggungjawab,
                           pngjwb_telp,
                           ref_satker_label,
                           get_domain_ip(domain_id) as ip_adr,
                           get_domain_aset2(domain_id) as aset
                  from     ref_domain
                  			 left join ref_zona on jnszona_id = domain_id_zona
                  			 left join ref_penanggungjawab on pngjwb_id = domain_tanggungjawab_id
                  			 left join ref_satker on ref_satker_id = pngjwb_id_satker
                             left join ref_aset on domain_refaset_id = ast_id
                  order by domain_label
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Domain KOMINFO';
        $sgkMod->directive['sm_function'] = 'buildGrid';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

        $sgkMod->directive['element_add_formtechnique'] = 'jsf';
        $sgkMod->directive['element_add_jsf'] = 'addNewData()';
        $sgkMod->directive['sgk_reload_jsf'] = 'gridReload()';
        $sgkMod->directive['grid_btnDetail'] = false;
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
        $sgkMod->directive['inw3x3_footright'] = array('print','download');
        
        $sgkMod->directive['grid_isgroupable'] = false;
        $sgkMod->directive['grid_isselectable'] = true;
        $sgkMod->directive['grid_columnmenu'] = false;
        $sgkMod->directive['grid_isfilterable'] = false;
        $sgkMod->directive['grid_isresize'] = false;
        $sgkMod->directive['grid_isreorder'] = false;

        $sgkMod->directive['grid_fields'] = array(
        	'jnszona_label' => 'Zona',
        	'domain_label' => 'Domain',
            'ip_adr' => 'IP',
            'aset' => 'Aset',
            'domain_peruntukan' => 'Peruntukan',
            'domain_keterangan' => 'Keterangan',
            'ref_satker_label' => 'Satuan Kerja',
            'tanggungjawab' => 'Penanggung Jawab',
            
        );

        $sgkMod->directive['grid_fields_width'] = array(
        	'jnszona_label' => '150',
        	'domain_label' => '150',
            'ip_adr' => '150',
            'aset' => '150',
            'tanggungjawab' => '150',
            'status_visible' => '100',
        );

        $sgkMod->directive['grid_fields_type'] = array(
        );

        $sgkMod->directive['grid_fields_format'] = array(
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
            'ip_adr' => true,
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

            $SQL = " select * from ref_domain where domain_id = '".$this->getVar('rNum')."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
        }
        else {

        }

        $select =& $form->add('domain_id_zona','Zona Domain','kendoDbCombo',true,$rr['domain_id_zona']);
        $select->configure(array(
                    'tableName'           => "ref_zona",
                    'dataField'           => "jnszona_id",
                    'viewField'           => "jnszona_label",
                    'whereClause'         => "ref_stat_visible = 1 ",
                    'addNoOption'         => false,
                    'noOptionDisplay'     => "Pilih Zona",
                    'extraAttributes'     => "style='width:250px;' ",
        ));

        $form->add('domain_label','Domain (!)','text',true,$rr['domain_label'],array('extraAttributes'=>' style="width:250px;" '));

        // $form->add('domain_ip','IP','text',false,$rr['domain_ip'],array('extraAttributes'=>' style="width:150px;" '));

        $select =& $form->add('domain_tanggungjawab','Penanggung Jawab','kendoDbCombo',false,$rr['domain_tanggungjawab_id']);
        $select->configure(array(
                    'tableName'           => "ref_penanggungjawab",
                    'dataField'           => "pngjwb_id",
                    'viewField'           => "pngjwb_label",
                    'whereClause'         => "ref_stat_visible = 1 ",
                    'addNoOption'         => true,
                    'noOptionDisplay'     => "Pilih Penanggung Jawab",
                    'extraAttributes'     => "style='width:250px;' ",
        ));
        
        $form->add('domain_peruntukan','Peruntukan','text',false,$rr['domain_peruntukan'],array('extraAttributes'=>' style="width:250px;" '));
        
        $form->add('domain_keterangan','Keterangan','text',false,$rr['domain_keterangan'],array('extraAttributes'=>' style="width:250px;" '));
        
                
        /*
        $select =& $form->add('domain_refaset_id','Referensi Server','kendoDbCombo',false,$rr['domain_refaset_id']);
        $select->configure(array(
                    'tableName'           => "ref_aset",
                    'dataField'           => "ast_id",
                    'viewField'           => "ast_label",
                    'whereClause'         => "ref_stat_visible = 1",
                    'addNoOption'         => true,
                    'noOptionDisplay'     => "Pilih Server",
                    'extraAttributes'     => "style='width:250px;' ",
        ));
        */
        
        $selEnt =& $form->add('ref_stat_visible','Status Tampil (!)','kendoCombo',true,$rr['ref_stat_visible'],array('extraAttributes'=>' style="width:250px;" '));
        $selEnt->addOption('Tampil pada daftar pilihan','1');
        $selEnt->addOption('Sembunyikan pada daftar pilihan','2');

        if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit')) {

            $select =& $form->add('form_aksi','Ubah/Hapus?','kendoCombo',true,1,array('extraAttributes'=>' style="width:150px;" onchange="if (this.value==9) { if (window.confirm(\'Yakin akan menghapus?\')) { } else { var combobox = $(\'#form_aksi\').data(\'kendoComboBox\'); combobox.value(\'1\'); } } " '));
            $select->addOption('Ubah Data','1');
            $select->addOption('Hapus','9');
        }

        $form->add('submit','','submit',false,'Save',array('extraAttributes'=>' value="Save" '));

        $form->runForm();

        if ($form->dataVerified()) {

           $domain_id_zona = $functDB->encap_numeric($form->getVar('domain_id_zona'));
           $domain_label = $functDB->encap_string($form->getVar('domain_label'),1);
           $domain_peruntukan = $functDB->encap_string($form->getVar('domain_peruntukan'),1);
           $domain_tanggungjawab = $functDB->encap_string($form->getVar('domain_tanggungjawab'),1);
           $domain_kontakperson = $functDB->encap_string($form->getVar('domain_kontakperson'),1);
           $domain_keterangan = $functDB->encap_string($form->getVar('domain_keterangan'),1);
           
           $ref_stat_visible = $functDB->encap_numeric($form->getVar('ref_stat_visible'));
           $form_aksi = $functDB->encap_numeric($form->getVar('form_aksi'));
           
           // $domain_refaset_id = $functDB->encap_string($form->getVar('domain_refaset_id'));
           // $domain_ip = $functDB->encap_string($form->getVar('domain_ip'));
           $domain_ip = 'null';
           $domain_refaset_id = 'null';
           
           $url_grid = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

           if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '1')) {

	            $arrData = array (  'domain_id_zona' => $domain_id_zona,
                                    'domain_label' => $domain_label,
                                    'domain_peruntukan' => $domain_peruntukan,
                                    'domain_tanggungjawab_id' => $domain_tanggungjawab,
                                    'domain_kontakperson' => $domain_kontakperson,
                                    'domain_keterangan' => $domain_keterangan,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_lastchange_by' => $member['idxNum'],
                                    'ref_stat_lastchange_time' => 'now()',
                                    );
                $functDB->dbupd("ref_domain",$arrData,"domain_id = ".$this->getVar('rNum'));

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            elseif (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '9')) {

                // allowed to delete
                $functDB->dbdelete("ref_domain_ipmap","map_id_domain = ".$this->getVar('rNum'),'');
                $functDB->dbdelete("ref_domain","domain_id = ".$this->getVar('rNum'),'');
                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            else {

                 $arrData = array ( 'domain_id_zona' => $domain_id_zona,
                                    'domain_label' => $domain_label,
                                    'domain_peruntukan' => $domain_peruntukan,
                                    'domain_tanggungjawab_id' => $domain_tanggungjawab,
                                    'domain_kontakperson' => $domain_kontakperson,
                                    'domain_keterangan' => $domain_keterangan,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_input_by' => $member['idxNum'],
                                    'ref_stat_input_time' => 'now()',
                                    );

                 $functDB->dbins('ref_domain',$arrData);
                 
                 $lastInsertId = $this->dbH->lastInsertId();
                 $url_form = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=formData&sType=edit&rNum='.$lastInsertId;

                 die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_form.'";</SCRIPT>');
            }

        }
        else {

            return ($form->output());
        }
    }

}


?>
