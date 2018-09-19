<?php

class refAset extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refAset');
        $this->useTemplate('defPop','popSingleForm');

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
        elseif ( $this->getVar('popMode') == 'ajx_buildGridPerLokasi' ) {
            die($this->buildGridPerLokasi());
        }
        elseif ( $this->getVar('popMode') == 'ajx_buildGridPerPenanggung' ) {
            die($this->buildGridPerPenanggung());
        }
        elseif ( $this->getVar('popMode') == 'ajx_buildGridPerSatker' ) {
            die($this->buildGridPerSatker());
        }
        else {

            $functDB =& $this->loadModule('functionDB');

            $defTpt->addtext($this->getDirective('screenwidth'),'sma_subScreenWidth');

            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=asetPdf','popUrl_cetakPdf');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=asetExcel','popUrl_cetakExcel');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=asetSpek','popUrl_cetakSpekAset');
            
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid=ajx_getDivView_aset','url_getDivView_aset');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajx_buildGridPerLokasi','urlajx_buildGridPerLokasi');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajx_buildGridPerPenanggung','urlajx_buildGridPerPenanggung');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajx_buildGridPerSatker','urlajx_buildGridPerSatker');
            
            $defTpt->addtext($this->buildGrid(),'sma_tabGrid');
            $defTpt->addtext($this->formAddData(),'sma_formAset');
            
            $defTpt->addtext($this->buildGrid_peristiwa(),'sma_tabGrid_peristiwa');
            $defTpt->addtext($this->buildGrid_perubahan(),'sma_tabGrid_perubahan');
            $defTpt->addtext($this->buildGrid_lokasi(),'sma_tabGrid_lokasi');
            
            $defTpt->addtext($this->formAddLokasi(),'sma_form_addloc');
            $defTpt->addtext($this->formAddEvent(),'sma_form_addevent');
            
            $defTpt->addtext($this->buildGridPerLokasi(),'sma_tabGrid_perlokasi');
            $defTpt->addtext($this->buildGridPerPenanggung(),'sma_tabGrid_penanggungjawab');
            $defTpt->addtext($this->buildGridPerSatker(),'sma_tabGrid_satker');
            
            
            if (($this->getVar('sType') == 'viewServer') && ($this->getVar('rNum') > 0)) {
                $extraJsViewServer = 'detailGrid('.$this->getVar('rNum').'); ';
                $defTpt->addtext($extraJsViewServer,'sma_extraJsViewServer');
            }
            
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

        $wSQL = '= 1';
        if ($this->directive['isadmin']) {
            $wSQL = 'is not null';
        }

        $SQL  = " select   ref_aset.*,
                           ast_id as id,
                           case when ref_aset.ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                           astgrp_label,
                           astgrp_kode,
                           astgrp_desc,
                           pngjwb_label,
                           pngjwb_kode,
                           pngjwb_telp,
                           pngjwb_email,
                           ref_satker_label,
                           (select loc_label from ref_aset_lokasi, trx_lokasi where loc_id = trxloc_id_lokasi_baru and trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1) as infolokasi,
                           (select get_ip_aset(ast_id)) as infoip,
                           (select get_domain_aset(ast_id)) as infodomain
                  from     ref_aset
                  			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                  			left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                            left join ref_satker on ref_satker_id = pngjwb_id_satker
                  where    ref_aset.ref_stat_visible ".$wSQL."
                  order by ast_id
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sgk_id'] = 'maintblaset';
        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Aset';
        $sgkMod->directive['sm_function'] = 'buildGrid';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');
        
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
        
        $sgkMod->directive['element_add_formtechnique'] = 'jsf';
        $sgkMod->directive['element_add_jsf'] = 'addNewData()';
        
        
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
        	'ast_id' => 'ID',
            'ast_label' => 'Nama Aset',
            'ast_kode_bmn' => 'No. BMN',
            'astgrp_label' => 'Jenis',
            'infolokasi' => 'Lokasi Terkini',
            'ref_satker_label' => 'Satuan Kerja',
            'pngjwb_label' => 'Penanggung Jawab',
            'infoip' => 'IP Address',
            'infodomain' => 'Domain'
        );

        $sgkMod->directive['grid_fields_width'] = array(
        	'ast_id' => '50',
            'ast_kode_bmn' => '100',
            'astgrp_label' => '100',
            'infolokasi' => '100',
            'pngjwb_label' => '100',
            'infoip' => '100',
            'infodomain' => '125'
        );

        $sgkMod->directive['grid_fields_type'] = array(
			'ast_id' => 'numeric',
        );

        $sgkMod->directive['grid_fields_format'] = array(
			'ast_id' => 'numeric',
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }
    
    function buildGrid_peristiwa($tmp = '') {

        $wSQL = '';
        if ($_GET['id_aset'] > 0) {
            $wSQL = "where trxkej_id_aset = '".$_GET['id_aset']."' ";
        }

        $SQL  = " select   trxkej_id,
                           trxkej_id as id,
                           concat ( coalesce(date_format(trxkej_tanggal,'%a<BR>%e %b %Y'),''), '<BR>',
                                    coalesce(date_format(trxkej_waktu,'%H:%i:%s'),'') ) as html_waktu,
                           concat ( coalesce(astgrp_label,''), '<BR><B>',
                                    coalesce(ast_label,''), '</B><BR>BMN: ',
                                    coalesce(ast_kode_bmn,'')
                                    ) as html_aset,
                           concat ( coalesce(jnskej_label,''), '<BR><B>',
                                    coalesce(trxkej_keterangan,''), '</B><BR>Oleh: ',
                                    coalesce(trxkej_oleh,'')
                                    ) as html_kejadian

                  from     trx_kejadian
                  			left join ref_aset on trxkej_id_aset = ast_id
                  			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                  			left join ref_kejadian_jenis on jnskej_id = trxkej_id_kej
                  ".$wSQL."            
                  order by trxkej_tanggal desc, trxkej_waktu desc
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Peristiwa Aset';
        $sgkMod->directive['sm_function'] = 'buildGrid_peristiwa';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');
        $sgkMod->directive['sgk_ds_extracode'] = ', id_aset: function() { return js_id_aset_view; } ';
        
        
        $sgkMod->directive['sgk_reload_jsf'] = 'gridReload_peristiwa()';
        $sgkMod->directive['grid_btnDetail'] = false;
        $sgkMod->directive['grid_btnEdit'] = false;
        $sgkMod->directive['grid_btnDelete'] = true;
        $sgkMod->directive['grid_btnDelete_useDefault'] = false;
        $sgkMod->directive['grid_btnDelete_jsfCustom'] = 'event_delete';
        
        $sgkMod->directive['element_add_formtechnique'] = 'jsf';
        $sgkMod->directive['element_add_jsf'] = 'addNewData()';
        
        
        $sgkMod->directive['wrapper_useDefault'] = false;
        $sgkMod->directive['innerwrapper_useDefault_type'] = '1rx2';

        $sgkMod->directive['inw3x3_headright'] = array('search');
        
        $sgkMod->directive['grid_isgroupable'] = false;
        $sgkMod->directive['grid_isselectable'] = true;
        $sgkMod->directive['grid_columnmenu'] = false;
        $sgkMod->directive['grid_isfilterable'] = false;
        $sgkMod->directive['grid_isresize'] = false;
        $sgkMod->directive['grid_isreorder'] = false;

        $sgkMod->directive['grid_fields'] = array(
        	'html_waktu' => 'Waktu',
            'html_aset' => 'Aset',
            'html_kejadian' => 'Peristiwa',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'html_waktu' => '115',
            'html_aset' => '200',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			
        );

        $sgkMod->directive['grid_fields_format'] = array(
			
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
            'html_waktu' => true,
            'html_aset' => true,
            'html_kejadian' => true,
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }
    
    function buildGrid_lokasi($tmp = '') {

        $wSQL = '';
        if ($_GET['id_aset'] > 0) {
            $wSQL = "where trxloc_id_aset = '".$_GET['id_aset']."' ";
        }

        $SQL  = " select   trxloc_id,
                           trxloc_id as id,
                           concat ( coalesce(date_format(trxloc_tanggal,'%a<BR>%e %b %Y'),''), '<BR>',
                                    coalesce(date_format(trxloc_waktu,'%H:%i:%s'),'') ) as html_waktu,
                           concat ( coalesce(astgrp_label,''), '<BR><B>',
                                    coalesce(ast_label,''), '</B><BR>BMN: ',
                                    coalesce(ast_kode_bmn,'')
                                    ) as html_aset,
                           concat ( coalesce((select loc_label from ref_aset_lokasi where loc_id = trxloc_id_lokasi_baru),''), '<BR>Oleh: ',
                                    coalesce(trxloc_oleh,''), '<BR>Alasan: ',
                                    coalesce(trxloc_alasan,'')
                                    ) as html_kejadian

                  from     trx_lokasi
                  			left join ref_aset on trxloc_id_aset = ast_id
                  			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                  ".$wSQL."            
                  order by trxloc_tanggal desc, trxloc_waktu desc
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Pemindahan Aset';
        $sgkMod->directive['sm_function'] = 'buildGrid_lokasi';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');
        $sgkMod->directive['sgk_ds_extracode'] = ', id_aset: function() { return js_id_aset_view; } ';
        
        
        $sgkMod->directive['sgk_reload_jsf'] = 'gridReload_lokasi()';
        $sgkMod->directive['grid_btnDetail'] = false;
        $sgkMod->directive['grid_btnEdit'] = false;
        $sgkMod->directive['grid_btnDelete'] = true;
        $sgkMod->directive['grid_btnDelete_useDefault'] = false;
        $sgkMod->directive['grid_btnDelete_jsfCustom'] = 'lokasi_delete';
        
        $sgkMod->directive['element_add_formtechnique'] = 'jsf';
        $sgkMod->directive['element_add_jsf'] = 'addNewData()';
        
        
        $sgkMod->directive['wrapper_useDefault'] = false;
        $sgkMod->directive['innerwrapper_useDefault_type'] = '1rx2';

        $sgkMod->directive['inw3x3_headright'] = array('search');
        
        $sgkMod->directive['grid_isgroupable'] = false;
        $sgkMod->directive['grid_isselectable'] = true;
        $sgkMod->directive['grid_columnmenu'] = false;
        $sgkMod->directive['grid_isfilterable'] = false;
        $sgkMod->directive['grid_isresize'] = false;
        $sgkMod->directive['grid_isreorder'] = false;

        $sgkMod->directive['grid_fields'] = array(
        	'html_waktu' => 'Waktu',
            'html_aset' => 'Aset',
            'html_kejadian' => 'Lokasi Baru',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'html_waktu' => '115',
            'html_aset' => '200',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			
        );

        $sgkMod->directive['grid_fields_format'] = array(
			
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
            'html_waktu' => true,
            'html_aset' => true,
            'html_kejadian' => true,
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }
    
    function buildGrid_perubahan($tmp = '') {

        $wSQL = '';
        if ($_GET['id_aset'] > 0) {
            $wSQL = "where logubah_id_aset = '".$_GET['id_aset']."' ";
        }

        $SQL  = " select   concat ( coalesce(date_format(logubah_tanggal,'%a<BR>%e %b %Y'),''), '<BR>',
                                    coalesce(date_format(logubah_waktu,'%H:%i:%s'),'') ) as html_waktu,
                           concat ( coalesce(astgrp_label,''), '<BR><B>',
                                    coalesce(ast_label,''), '</B><BR>BMN: ',
                                    coalesce(ast_kode_bmn,'')
                                    ) as html_aset,
                           concat ( coalesce(logubah_catatan,''), '<BR>Oleh: ',
                                    coalesce(logubah_oleh,'')
                                    ) as html_kejadian
                  from     log_perubahan
                  			left join ref_aset on logubah_id_aset = ast_id
                  			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                  ".$wSQL."            
                  order by logubah_tanggal desc, logubah_waktu desc
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Perubahan Spesifikasi Aset';
        $sgkMod->directive['sm_function'] = 'buildGrid_perubahan';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');
        $sgkMod->directive['sgk_ds_extracode'] = ', id_aset: function() { return js_id_aset_view; } ';
        
        
        $sgkMod->directive['sgk_reload_jsf'] = 'gridReload_perubahan()';
        $sgkMod->directive['grid_btnDetail'] = false;
        $sgkMod->directive['grid_btnEdit'] = true;
        $sgkMod->directive['grid_btnEdit_useDefault'] = false;
        $sgkMod->directive['grid_btnEdit_jsfCustom'] = 'editGrid_perubahan';
        $sgkMod->directive['grid_btnDelete'] = true;
        $sgkMod->directive['grid_btnDelete_useDefault'] = 'deleteGrid_perubahan';
        $sgkMod->directive['grid_btnDelete_jsfCustom'] = '';
        
        $sgkMod->directive['element_add_formtechnique'] = 'jsf';
        $sgkMod->directive['element_add_jsf'] = 'addNewData()';
        
        
        $sgkMod->directive['wrapper_useDefault'] = false;
        $sgkMod->directive['innerwrapper_useDefault_type'] = '1rx2';

        $sgkMod->directive['inw3x3_headright'] = array('search');
        
        $sgkMod->directive['grid_isgroupable'] = false;
        $sgkMod->directive['grid_isselectable'] = true;
        $sgkMod->directive['grid_columnmenu'] = false;
        $sgkMod->directive['grid_isfilterable'] = false;
        $sgkMod->directive['grid_isresize'] = false;
        $sgkMod->directive['grid_isreorder'] = false;

        $sgkMod->directive['grid_fields'] = array(
        	'html_waktu' => 'Waktu',
            'html_aset' => 'Aset',
            'html_kejadian' => 'Lokasi Baru',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'html_waktu' => '115',
            'html_aset' => '200',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			
        );

        $sgkMod->directive['grid_fields_format'] = array(
			
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
            'html_waktu' => true,
            'html_aset' => true,
            'html_kejadian' => true,
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }
    
    function formAddData() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $form =& $this->newSmartForm();
        
        $fTpt =& $form->loadTemplate('/ref2015/refAset_form');

        $form->add('new_label','Nama Aset (!)','text',false,$rr['ast_label'],array('extraAttributes'=>' style="width:100%;" '));
        
        $select =& $form->add('new_ast_id_grupaset','Jenis Aset','kendoDbCombo',false,$rr['ast_id_grupaset']);
        $select->configure(array(
                    'tableName'           => "ref_aset_grup",
                    'dataField'           => "astgrp_id",
                    'viewField'           => "astgrp_label",
                    'whereClause'         => "ref_stat_visible = 1 ",
                    'addNoOption'         => false,
                    'placeholder'         => 'Pilih Jenis Aset',
                    'extraAttributes'     => "style='width:100%;' ",
        ));
        
        $form->add('ast_label','Nama Aset (!)','text',false,$rr['ast_label'],array('extraAttributes'=>' style="width:100%;" '));
        $form->add('ast_kode_bmn','No. BMN','text',false,$rr['ast_kode_bmn'],array('extraAttributes'=>' style="width:100%;" '));

        $select =& $form->add('ast_id_grupaset','Jenis Aset','kendoDbCombo',false,$rr['ast_id_grupaset']);
        $select->configure(array(
                    'tableName'           => "ref_aset_grup",
                    'dataField'           => "astgrp_id",
                    'viewField'           => "astgrp_label",
                    'whereClause'         => "ref_stat_visible = 1 ",
                    'addNoOption'         => false,
                    'placeholder'         => 'Pilih Jenis Aset',
                    'extraAttributes'     => "style='width:100%;' ",
        ));

        $select =& $form->add('ast_id_pngjawab','Penanggung Jawab','kendoDbCombo',false,$rr['ast_id_pngjawab']);
        $select->configure(array(
                    'tableName'           => "ref_penanggungjawab",
                    'dataField'           => "pngjwb_id",
                    'viewField'           => "pngjwb_label",
                    'whereClause'         => "ref_stat_visible = 1 ",
                    'addNoOption'         => false,
                    'placeholder'         => 'Pilih Penanggung Jawab',
                    'extraAttributes'     => "style='width:100%;' ",
        ));
        
        $select =& $form->add('ast_id_lokasiaset','Lokasi Saat Ini','kendoDbCombo',false,$rr['ast_id_lokasiaset']);
        $select->configure(array(
                    'tableName'           => "ref_aset_lokasi",
                    'dataField'           => "loc_id",
                    'viewField'           => "loc_label",
                    'whereClause'         => "ref_stat_visible = 1 ",
                    'addNoOption'         => false,
                    'placeholder'         => 'Pilih Lokasi',
                    'extraAttributes'     => "style='width:100%;' ",
        ));
        
        $ajx_baseUrl = $this->sessionH->uLink('m2.php').'&option=r2_refAset&popMode=ajxcall';
        
        $conf =& $form->add('ref_aset_foto','Foto Perangkat','kendoUpload',false);
        $conf->addDirective('kendoJsExtra','
                                            async: {
                                                saveUrl: "'.$ajx_baseUrl.'&aswid=ajx_saveFoto",
                                            },
                                            upload: function (e) {
                                                e.data = { rNum: js_id_aset };
                                            },
                                            complete: onComplete_astFoto,
                                            error: onUploadError,
                                            multiple: false,
                                            showFileList: false
        ');
        
        $conf =& $form->add('ref_aset_dokumen','Dokumen Pengadaan','kendoUpload',false);
        $conf->addDirective('kendoJsExtra','
                                            async: {
                                                saveUrl: "'.$ajx_baseUrl.'&aswid=ajx_saveDok",
                                            },
                                            upload: function (e) {
                                                e.data = { rNum: js_id_aset };
                                            },
                                            complete: onComplete_astDoc,
                                            error: onUploadError,
                                            multiple: false,
                                            showFileList: false
        ');
        
        $conf =& $form->add('ref_aset_usermanual','Buku Panduan','kendoUpload',false);
        $conf->addDirective('kendoJsExtra','
                                            async: {
                                                saveUrl: "'.$ajx_baseUrl.'&aswid=ajx_saveManual",
                                            },
                                            upload: function (e) {
                                                e.data = { rNum: js_id_aset };
                                            },
                                            complete: onComplete_astManual,
                                            error: onUploadError,
                                            multiple: false,
                                            showFileList: false
        ');
        
        $selEnt =& $form->add('ref_stat_visible','Status Tampil (!)','kendoCombo',false,$rr['ref_stat_visible'],array('extraAttributes'=>' style="width:100%;" '));
        $selEnt->addOption('Tampil pada daftar pilihan','1');
        $selEnt->addOption('Sembunyikan pada daftar pilihan','2');

        $select =& $form->add('form_aksi','Ubah/Hapus?','kendoCombo',false,1,array('extraAttributes'=>' style="width:100%;" onchange="if (this.value==9) { if (window.confirm(\'Yakin akan menghapus?\')) { } else { var combobox = $(\'#form_aksi\').data(\'kendoComboBox\'); combobox.value(\'1\'); } } " '));
        $select->addOption('Ubah Data','1');
        $select->addOption('Hapus','9');

        $fTpt->addText($ajx_baseUrl.'&aswid=ajx_newFormSave','url_ajxSaveNewLabel');
        $fTpt->addText($ajx_baseUrl.'&aswid=ajx_getFormData','url_ajxGetFormData');
        
        $fTpt->addText($ajx_baseUrl.'&aswid=ajx_getAstFoto','url_getAssetFoto');
        $fTpt->addText($ajx_baseUrl.'&aswid=ajx_getAstDoc','url_getAssetDocument');
        $fTpt->addText($ajx_baseUrl.'&aswid=ajx_getAstManual','url_getAssetManual');
        $fTpt->addText($ajx_baseUrl.'&aswid=ajx_getAstIP','url_getAssetIP');
        
        $fTpt->addText($ajx_baseUrl.'&aswid=ajx_saveOldLabel','url_ajxSaveOldLabel');
        
        $fTpt->addText($ajx_baseUrl.'&aswid=ajx_delAstFoto','url_removeAssetFoto');
        $fTpt->addText($ajx_baseUrl.'&aswid=ajx_delAstDok','url_removeAssetDoc');
        $fTpt->addText($ajx_baseUrl.'&aswid=ajx_delManual','url_removeAssetManual');
        $fTpt->addText($ajx_baseUrl.'&aswid=ajx_delIP','url_removeAssetIP');
        
        $fTpt->addText($ajx_baseUrl.'&aswid=rbi_ref_ip','url_ajxGetIP');
        $fTpt->addText($ajx_baseUrl.'&aswid=ajx_saveIP','url_ajxSaveIP');
        
        
        return ($form->output());
        
    }
    
    function rbi_ref_ip() {

        $arrayData = array();

        $whereClause = "";
        if (strlen(trim($_GET['filter']['filters']['0']['value']))>0) {
            $fil = $_GET['filter']['filters']['0']['value'];
            $whereClause = " and (lower(ip_number) like '".$fil."%') ";
        }

        $SQL = " select ip_id as id, ip_number as value 
                 from   ref_ip left join ref_aset_ipmap on map_id_ip = ip_id
                 where  map_ip_id is null ".$whereClause."
                 order  by INET_ATON(ip_number)
                 limit  50
                 ";
        $rh  = $this->dbH->query($SQL);
        while ($rr = $rh->fetch()) {
            $arrayData[] = $rr;
        };

        die(json_encode($arrayData));
    }
    
    function ajx_saveOldLabel() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $ast_label = $functDB->encap_string($_POST['ast_label']);
        $ast_kode_bmn = $functDB->encap_string($_POST['ast_kode_bmn']);
        $ast_id_grupaset = $functDB->encap_numeric($_POST['ast_id_grupaset']);
        $ast_id_lokasiaset = $functDB->encap_numeric($_POST['ast_id_lokasiaset']);
        $ast_id_pngjawab = $functDB->encap_numeric($_POST['ast_id_pngjawab']);
        $ref_stat_visible = $functDB->encap_numeric($_POST['ref_stat_visible']);
        $form_aksi = $functDB->encap_numeric($_POST['form_aksi']);
        
        if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($_POST['form_aksi'] == 1)) {
            
            // get latest position if exist then update, if not then create
            if ($_POST['ast_id_lokasiaset'] > 0) {
                $SQLLokasi = "select *
                              from   trx_lokasi 
                              where  trxloc_id_aset = '".$this->getVar('rNum')."' 
                              order by trxloc_tanggal desc, trxloc_waktu desc
                              limit 1
                              ";
                $rhLokasi  = $this->dbH->query($SQLLokasi);
                $functDB->dberror_show($rhLokasi);
                $rrLokasi  = $rhLokasi->fetch();
                
                $trxloc_oleh = $functDB->encap_string($member['firstName']);
                $trxloc_id_aset = $functDB->encap_numeric($this->getVar('rNum'));
                
                if ($rrLokasi['trxloc_id'] > 0) {
                    
                    $arrData = array ( 'trxloc_id_lokasi_baru' => $ast_id_lokasiaset,
                                       'trxloc_oleh' => $trxloc_oleh,
                                       'trxloc_id_aset' => $trxloc_id_aset,
                                       'trx_stat_input_by' => $member['idxNum'],
                                       'trx_stat_input_time' => 'now()',
                                       );
                    $functDB->dbupd("trx_lokasi",$arrData,"trxloc_id = ".$rrLokasi['trxloc_id']);
                }
                else {
                    
                    $arrData = array ( 'trxloc_tanggal' => 'now()',
                                       'trxloc_waktu' => 'now()',
                                       'trxloc_id_lokasi_baru' => $ast_id_lokasiaset,
                                       'trxloc_alasan' => "'Penempatan Awal'",
                                       'trxloc_oleh' => $trxloc_oleh,
                                       'trxloc_id_aset' => $trxloc_id_aset,
                                       'trx_stat_input_by' => $member['idxNum'],
                                       'trx_stat_input_time' => 'now()',
                                       );
                    $functDB->dbins('trx_lokasi',$arrData);
                }
            }
            
            $arrData = array ('ast_label' => $ast_label,
                              'ast_kode_bmn' => $ast_kode_bmn,
                              'ast_refercode' => "sha(encode(ast_id,'(^_^)'))",
                              'ast_id_grupaset' => $ast_id_grupaset,
                              'ast_id_pngjawab' => $ast_id_pngjawab,
                              'ref_stat_visible' => $ref_stat_visible
                              );
            $functDB->dbupd("ref_aset",$arrData,"ast_id = ".$this->getVar('rNum'));
            
            $this->createQrCode($this->getVar('rNum'));
            
            // the spec
            $arr_spek = $_POST['arr_spek'];
            reset($arr_spek);
            while (list($key, $val) = each($arr_spek)) {
                
                $SQLCekSpek = "select * from ref_aset_spesifikasi left join ref_aset_grup_spek on astgrpspek_id = astspk_id_grup_spek where astspk_id_aset = ".$this->getVar('rNum')." and astspk_id_grup_spek = ".$key." ";
                $rhCekSpek  = $this->dbH->query($SQLCekSpek);
                $rrCekSpek  = $rhCekSpek->fetch();
                
                $astspk_value_text = $functDB->encap_string($val,1);
                $astspk_id_aset = $functDB->encap_numeric($this->getVar('rNum'));
                $astspk_id_grup_spek = $functDB->encap_numeric($key);
                
                if ($rrCekSpek['astspk_id'] > 0) {
                    
                    $arrData = array ( 'astspk_value_text' => $astspk_value_text,
	                                   'ref_stat_lastchange_by' => $member['idxNum'],
	                                   'ref_stat_lastchange_time' => 'now()',
	                                   );
	                $functDB->dbupd("ref_aset_spesifikasi",$arrData,"astspk_id = ".$rrCekSpek['astspk_id']);
                }
                else {
                
                    $arrData = array ( 'astspk_id_grup_spek' => $astspk_id_grup_spek,
			        				   'astspk_id_aset' => $astspk_id_aset,
                                       'astspk_value_text' => $astspk_value_text,
	                                   'ref_stat_input_by' => $member['idxNum'],
	                                   'ref_stat_input_time' => 'now()',
	                                   );
	                $functDB->dbins('ref_aset_spesifikasi',$arrData);
                }
                
                $oldVal = $rrCekSpek['astspk_value_text'];
                $newVal = $val;
                
                if (strtolower(trim($oldVal)) != strtolower(trim($newVal))) {
                    
                    $arrData2 = array ( 'trxspec_id_aset' => $astspk_id_aset,
                    				    'trxspec_id_spec' => $astspk_id_grup_spek,
                    				    'trxspec_nonangka_sebelumnya' => $functDB->encap_string($oldVal,1),
                    				    'trxspec_nonangka_perubahan' => $functDB->encap_string($newVal,1),
                    				    'trxspec_tanggal' => 'now()',
                    				    'trxspec_waktu' => 'now()',
                    				    'trxspec_catatan' => $functDB->encap_string('Autoinsert Log'),
                    				    'trxspec_oleh' => $functDB->encap_string($member['firstName']),
                    				    'trx_stat_input_by' => $member['idxNum'],
                                        'trx_stat_input_time' => 'now()',
                                        );
                    $functDB->dbins("trx_spesifikasi",$arrData2);
                    
                    $logubah_catatan = '[AUTO] Perubahan Spesifikasi '.strtoupper($rrCekSpek['astgrpspek_label']).', dari sebelumnya "'.$oldVal.'" menjadi "'.$newVal.'". ';

                    $arrData2 = array ( 'logubah_id_aset' => $astspk_id_aset,
                    				    'logubah_catatan' => $functDB->encap_string($logubah_catatan),
                    				    'logubah_tanggal' => 'now()',
                    				    'logubah_waktu' => 'now()',
                    				    'logubah_oleh' => $functDB->encap_string($member['firstName']),
                    				    'trx_stat_input_by' => $member['idxNum'],
                                        'trx_stat_input_time' => 'now()',
                                        );
                    $functDB->dbins("log_perubahan",$arrData2);
                }
            }
            
            if ($_POST['aftertype'] == 2) {
                die('1023');
            }
            else {
                die('1024');
            }
        }
        elseif (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($_POST['form_aksi'] == 9)) {
            
            $functDB->dbdelete("ref_aset_ipmap","map_id_aset = ".$this->getVar('rNum'),'');
            $functDB->dbdelete("ref_aset","ast_id = ".$this->getVar('rNum'),'');
            die('1025');
        }
        
        die('Error! expected variable missmatch');
        
    }
    
    function ajx_getAstFoto() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $div_listOfFoto = '<ul class="list-group">';
        $SQLlist = " select * from ref_aset_foto where foto_id_aset = '".$this->getVar('rNum')."' order by foto_id";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rowCount = 0;
        while ($rrlist = $rhlist->fetch()) {
            $rowCount++;
            $div_listOfFoto .= '<li class="list-group-item"><span class="badge"><a href="javascript:;" onclick="remove_foto('.$rrlist['foto_id'].')" style="color:white;">Hapus</a></span> <a href="javascript:;" onclick="view_foto(\''.$rrlist['foto_filename'].'\')"><img src="'.$rrlist['foto_filename'].'" width="150" class="thumbnail"></a></li>';
        }
        if ($rowCount == 0) {
            $div_listOfFoto .= '* belum ada foto';
        }
        $div_listOfFoto .= '</ul>';
        
        if (($this->getVar('popMode') == 'ajxcall') && ($this->getVar('aswid') == 'ajx_getAstFoto')) {
            die($div_listOfFoto);
        }
        else {
            return $div_listOfFoto;
        }
    }
    
    function ajx_getAstDoc() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $div_listOfDokumen = '<ul class="list-group">';
        $SQLlist = " select * from ref_aset_dokumen where file_id_aset = '".$this->getVar('rNum')."' order by file_id ";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rowCount = 0;
        while ($rrlist = $rhlist->fetch()) {
            $rowCount++;
            $div_listOfDokumen .= '<li class="list-group-item"><span class="badge"><a href="javascript:;" onclick="remove_doc('.$rrlist['file_id'].')" style="color:white;">Hapus</a></span> <a href="'.$rrlist['file_name'].'" target="_blank">'.$rrlist['file_label'].'</a></li>';
        }
        if ($rowCount == 0) {
            $div_listOfDokumen .= '* belum ada dokumen';
        }
        $div_listOfDokumen .= '</ul>';
        
        if (($this->getVar('popMode') == 'ajxcall') && ($this->getVar('aswid') == 'ajx_getAstDoc')) {
            die($div_listOfDokumen);
        }
        else {
            return $div_listOfDokumen;
        }
    }
    
    function ajx_getAstIP() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $div_listOfIP = '<ul class="list-group">';
        $SQLlist = " select * from ref_aset_ipmap, ref_ip where map_id_aset = '".$this->getVar('rNum')."' and ip_id = map_id_ip order by map_ip_id ";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rowCount = 0;
        while ($rrlist = $rhlist->fetch()) {
            $rowCount++;
            $div_listOfIP .= '<li class="list-group-item"><span class="badge"><a href="javascript:;" onclick="remove_ip('.$rrlist['map_ip_id'].')" style="color:white;">Hapus</a></span> '.$rrlist['ip_number'].'</li>';
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
    
    function ajx_getAstManual() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $div_listOfManual = '<ul class="list-group">';
        $SQLlist = " select * from ref_aset_usermanual where file_id_aset = '".$this->getVar('rNum')."' order by file_id ";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rowCount = 0;
        while ($rrlist = $rhlist->fetch()) {
            $rowCount++;
            $div_listOfManual .= '<li class="list-group-item"><span class="badge"><a href="javascript:;" onclick="remove_manual('.$rrlist['file_id'].')" style="color:white;">Hapus</a></span> <a href="'.$rrlist['file_name'].'" target="_blank">'.$rrlist['file_label'].'</a></li>';
        }
        if ($rowCount == 0) {
            $div_listOfManual .= '* belum ada panduan';
        }
        $div_listOfManual .= '</ul>';
        
        if (($this->getVar('popMode') == 'ajxcall') && ($this->getVar('aswid') == 'ajx_getAstManual')) {
            die($div_listOfManual);
        }
        else {
            return $div_listOfManual;
        }
    }
    
    function ajx_getFormData() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $return = array();
        
        if ($this->getVar('rNum') > 0) {
            
            $SQL = " select * from ref_aset where ast_id = '".$this->getVar('rNum')."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
            
            // get image
            $div_listOfFoto = $this->ajx_getAstFoto();
            
            // get dokumen
            $div_listOfDokumen = $this->ajx_getAstDoc();
            
            // get manual
            $div_listOfManual = $this->ajx_getAstManual();
            
            // get ip
            $div_listOfIP = $this->ajx_getAstIP();
            
            // get latest location 
            $SQLLokasi = "select *
                          from   trx_lokasi 
                          where  trxloc_id_aset = '".$this->getVar('rNum')."' 
                          order by trxloc_tanggal desc, trxloc_waktu desc
                          limit 1
                          ";
            $rhLokasi  = $this->dbH->query($SQLLokasi);
            $functDB->dberror_show($rhLokasi);
            $rrLokasi  = $rhLokasi->fetch();
            
            // get spesifikasi
            $rowCount = 0;
            $div_listOfSpec = '<ul class="list-group">';
            if ($rr['ast_id_grupaset'] > 0) {
                $SQLlist = "select * 
                            from   ref_aset_grup_spek left join ref_aset_spesifikasi on astgrpspek_id = astspk_id_grup_spek and astspk_id_aset = '".$this->getVar('rNum')."'
                            where  astgrpspek_id_grup = '".$rr['ast_id_grupaset']."' and
                                   ref_aset_grup_spek.ref_stat_visible = 1
                            order by astgrpspek_urutan
                            ";
                $rhlist  = $this->dbH->query($SQLlist);
                $functDB->dberror_show($rhlist);
                while ($rrlist = $rhlist->fetch()) {
                    $rowCount++;
                    $bgColor = '#F5F5F5;';
                    if (($rowCount % 2) == 0) {
                        $bgColor = '#F5F5F5;';
                    }
                    $satuan = '';
                    if (strlen(trim($rrlist['astgrpspek_satuan']))>0) {
                        $satuan = '('.$rrlist['astgrpspek_satuan'].')';    
                    }
                    $div_listOfSpec .= '<li class="list-group-item" style="background-color:'.$bgColor.'"><p><B>'.$rrlist['astgrpspek_label'].' '.$satuan.'</B></p>';
                    $div_listOfSpec .= '<input type="text" class="k-textbox ref_aset_spesifikasi" astgrpspek_id="'.$rrlist['astgrpspek_id'].'" value="'.$rrlist['astspk_value_text'].'" style="width:100%;" maxlength="9999999"><BR>';
                    $div_listOfSpec .= '<div class="popover-alwayshow"><div class="popover bottom"><div class="arrow"></div><p class="popover-title" style="background-color:#DFF0D8;">'.$rrlist['astgrpspek_keterangan'].'</p></div></div>';
                    $div_listOfSpec .= '</li>';
                }
            }
            if ($rowCount == 0) {
                $div_listOfSpec .= '* belum ada spesifikasi';
            }
            $div_listOfSpec .= '</ul>';
            $div_listOfSpec .= '<input type="button" class="k-button" value="Simpan" onclick="saveOldAsset(1)">&nbsp;&nbsp;<input type="button" class="k-button" value="Simpan & Tambah Baru" onclick="saveOldAsset(2)">';
            
            $rr['div_listOfFoto'] = $div_listOfFoto;
            $rr['div_listOfDokumen'] = $div_listOfDokumen;
            $rr['div_listOfManual'] = $div_listOfManual;
            $rr['div_listOfSpec'] = $div_listOfSpec;
            $rr['div_listOfIP'] = $div_listOfIP;
            
            $rr['ast_id_lokasiaset'] = $rrLokasi['trxloc_id_lokasi_baru'];
            
            $return = $rr;
            
        }
        else {
            $return['error'] = 'Error! expected value missmatch '.$this->getVar('rNum');
        }
        
        die(json_encode($return));
    }
    
    function ajx_newFormSave() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $return = array();
        
        $ast_label = $functDB->encap_string($_POST['new_label'],1);
        $ast_id_grupaset = $functDB->encap_numeric($_POST['new_jenis']);
        
        if (strlen(trim($ast_label))>0) {
            
            $arrData = array ( 'ast_label' => $ast_label,
                               'ast_id_grupaset' => $ast_id_grupaset,
                               'ref_stat_visible' => 1,
                               'ref_stat_input_by' => $member['idxNum'],
                               'ref_stat_input_time' => 'now()',
                               );
            $functDB->dbins('ref_aset',$arrData);

            $lastInsertId = $this->dbH->lastInsertId();
            
            $arrData = array ('ast_refercode' => "sha(encode(".$lastInsertId.",'(^_^)'))"
                              );
            $functDB->dbupd("ref_aset",$arrData,"ast_id = ".$lastInsertId);
            
            $logubah_catatan = '[AUTO] Pembuatan aset baru, '.$_POST['new_label'];
            $arrData2 = array ( 'logubah_id_aset' => $lastInsertId,
            				    'logubah_catatan' => $functDB->encap_string($logubah_catatan),
            				    'logubah_tanggal' => 'now()',
            				    'logubah_waktu' => 'now()',
            				    'logubah_oleh' => $functDB->encap_string($member['firstName']),
            				    'trx_stat_input_by' => $member['idxNum'],
                                'trx_stat_input_time' => 'now()',
                                );
            $functDB->dbins("log_perubahan",$arrData2);
            
            $this->createQrCode($lastInsertId);
            
            $return['id'] = $lastInsertId;
        }
        else {
            $return['error'] = 'Error! Nama label tidak boleh kosong.';
        }
        
        die(json_encode($return));
        
    }
    
    function ajx_saveFoto() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        include_once('phplib/class.upload.php');
        
        $handle = new upload($_FILES['ref_aset_foto']);
        if ($handle->uploaded) {
            
            $fileName = 'astimg_'.$this->getVar('rNum').'_'.rand(10,99).date('ymdhis');
            
            $handle->file_new_name_body   = $fileName;
            $handle->image_resize         = false;
            
            $handle->process('./materials/');
            if ($handle->processed) {
                
                $arrData = array ( 'foto_id_aset' => $functDB->encap_numeric($this->getVar('rNum')),
                                   'foto_filename' => $functDB->encap_string($handle->file_dst_pathname),
                                   'foto_label' => $functDB->encap_string('Foto Aset'),
                                   'foto_size' => $functDB->encap_numeric($handle->file_src_size),
                                   'stat_inp_by' => $member['idxNum'],
                                   'stat_inp_time' => 'now()',
                                   );
                $functDB->dbins('ref_aset_foto',$arrData);
                
                $SQLaset = "select   *
                            from     ref_aset
                              			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                              			left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                            where    ref_aset.ast_id = '".$this->getVar('rNum')."'
                            ";
                $rhAset  = $this->dbH->query($SQLaset);
                $functDB->dberror_show($rhAset);
                $rrAset = $rhAset->fetch();
                
                $logubah_catatan = '[AUTO] Penambahan foto '.$handle->file_dst_pathname.' kepada aset "'.$rrAset['ast_label'];
                $arrData2 = array ( 'logubah_id_aset' => $this->getVar('rNum'),
                				    'logubah_catatan' => $functDB->encap_string($logubah_catatan),
                				    'logubah_tanggal' => 'now()',
                				    'logubah_waktu' => 'now()',
                				    'logubah_oleh' => $functDB->encap_string($member['firstName']),
                				    'trx_stat_input_by' => $member['idxNum'],
                                    'trx_stat_input_time' => 'now()',
                                    );
                $functDB->dbins("log_perubahan",$arrData2);
                
                die('1024');
            } else {
                die($handle->error);
            }
        }
        else {
            die($handle->error);
        }
        die();
    }
    
    function ajx_delAstFoto() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $SQLlist = "select * from ref_aset_foto where foto_id = '".$this->getVar('rNum')."' and foto_id_aset = '".$this->getVar('rNum2')."' ";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rrlist = $rhlist->fetch();
        
        $SQLaset = "select   *
                    from     ref_aset
                      			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                      			left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                    where    ref_aset.ast_id = '".$this->getVar('rNum2')."'
                    ";
        $rhAset  = $this->dbH->query($SQLaset);
        $functDB->dberror_show($rhAset);
        $rrAset = $rhAset->fetch();
        
        $logubah_catatan = '[AUTO] Penghapusan foto '.$rrlist['foto_filename'].' dari aset "'.$rrAset['ast_label'];
        $arrData2 = array ( 'logubah_id_aset' => $this->getVar('rNum2'),
        				    'logubah_catatan' => $functDB->encap_string($logubah_catatan),
        				    'logubah_tanggal' => 'now()',
        				    'logubah_waktu' => 'now()',
        				    'logubah_oleh' => $functDB->encap_string($member['firstName']),
        				    'trx_stat_input_by' => $member['idxNum'],
                            'trx_stat_input_time' => 'now()',
                            );
        $functDB->dbins("log_perubahan",$arrData2);
        
        if ($rrlist['foto_id'] > 0) {
            $functDB->dbdelete("ref_aset_foto","foto_id = ".$this->getVar('rNum'),'');
            // unlink($rrlist['foto_filename']);
        }
        
        die();
    }
    
    function ajx_saveDok() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        include_once('phplib/class.upload.php');
        
        $handle = new upload($_FILES['ref_aset_dokumen']);
        if ($handle->uploaded) {
            
            $fileName = 'astdoc_'.$this->getVar('rNum').'_'.rand(10,99).date('ymdhis');
            
            $handle->file_new_name_body   = $fileName;
            $handle->image_resize         = false;
            
            $handle->process('./materials/');
            if ($handle->processed) {
                
                $arrData = array ( 'file_id_aset' => $functDB->encap_numeric($this->getVar('rNum')),
                                   'file_name' => $functDB->encap_string($handle->file_dst_pathname),
                                   'file_label' => $functDB->encap_string($handle->file_src_name_body),
                                   'file_size' => $functDB->encap_numeric($handle->file_src_size),
                                   'stat_inp_by' => $member['idxNum'],
                                   'stat_inp_time' => 'now()',
                                   );
                $functDB->dbins('ref_aset_dokumen',$arrData);
                
                $SQLaset = "select   *
                            from     ref_aset
                              			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                              			left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                            where    ref_aset.ast_id = '".$this->getVar('rNum')."'
                            ";
                $rhAset  = $this->dbH->query($SQLaset);
                $functDB->dberror_show($rhAset);
                $rrAset = $rhAset->fetch();
                
                $logubah_catatan = '[AUTO] Penambahan dokumen pengadaan '.$handle->file_src_name_body.' ('.$handle->file_dst_pathname.') kepada aset "'.$rrAset['ast_label'];
                $arrData2 = array ( 'logubah_id_aset' => $this->getVar('rNum'),
                				    'logubah_catatan' => $functDB->encap_string($logubah_catatan),
                				    'logubah_tanggal' => 'now()',
                				    'logubah_waktu' => 'now()',
                				    'logubah_oleh' => $functDB->encap_string($member['firstName']),
                				    'trx_stat_input_by' => $member['idxNum'],
                                    'trx_stat_input_time' => 'now()',
                                    );
                $functDB->dbins("log_perubahan",$arrData2);
                
                die('1024');
            } else {
                die($handle->error);
            }
        }
        else {
            die($handle->error);
        }
        die();
        
    }
    
    function ajx_delAstDok() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $SQLlist = "select * from ref_aset_dokumen where file_id = '".$this->getVar('rNum')."' and file_id_aset = '".$this->getVar('rNum2')."' ";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rrlist = $rhlist->fetch();
        
        $SQLaset = "select   *
                    from     ref_aset
                      			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                      			left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                    where    ref_aset.ast_id = '".$this->getVar('rNum2')."'
                    ";
        $rhAset  = $this->dbH->query($SQLaset);
        $functDB->dberror_show($rhAset);
        $rrAset = $rhAset->fetch();
        
        $logubah_catatan = '[AUTO] Penghapusan dokumen pengadaan '.$rrlist['file_label'].' ('.$rrlist['file_name'].') dari aset "'.$rrAset['ast_label'];
        $arrData2 = array ( 'logubah_id_aset' => $this->getVar('rNum2'),
        				    'logubah_catatan' => $functDB->encap_string($logubah_catatan),
        				    'logubah_tanggal' => 'now()',
        				    'logubah_waktu' => 'now()',
        				    'logubah_oleh' => $functDB->encap_string($member['firstName']),
        				    'trx_stat_input_by' => $member['idxNum'],
                            'trx_stat_input_time' => 'now()',
                            );
        $functDB->dbins("log_perubahan",$arrData2);
        
        if ($rrlist['file_id'] > 0) {
            $functDB->dbdelete("ref_aset_dokumen","file_id = ".$this->getVar('rNum'),'');
            // unlink($rrlist['file_name']);
        }
        
        die();
        
    }
    
    function ajx_saveManual() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        include_once('phplib/class.upload.php');
        
        $handle = new upload($_FILES['ref_aset_usermanual']);
        if ($handle->uploaded) {
            
            $fileName = 'astdoc_'.$this->getVar('rNum').'_'.rand(10,99).date('ymdhis');
            
            $handle->file_new_name_body   = $fileName;
            $handle->image_resize         = false;
            
            $handle->process('./materials/');
            if ($handle->processed) {
                
                $arrData = array ( 'file_id_aset' => $functDB->encap_numeric($this->getVar('rNum')),
                                   'file_name' => $functDB->encap_string($handle->file_dst_pathname),
                                   'file_label' => $functDB->encap_string($handle->file_src_name_body),
                                   'file_size' => $functDB->encap_numeric($handle->file_src_size),
                                   'stat_inp_by' => $member['idxNum'],
                                   'stat_inp_time' => 'now()',
                                   );
                $functDB->dbins('ref_aset_usermanual',$arrData);
                
                $SQLaset = "select   *
                            from     ref_aset
                              			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                              			left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                            where    ref_aset.ast_id = '".$this->getVar('rNum')."'
                            ";
                $rhAset  = $this->dbH->query($SQLaset);
                $functDB->dberror_show($rhAset);
                $rrAset = $rhAset->fetch();
                
                $logubah_catatan = '[AUTO] Penambahan dokumen manual '.$handle->file_src_name_body.' ('.$handle->file_dst_pathname.') kepada aset "'.$rrAset['ast_label'];
                $arrData2 = array ( 'logubah_id_aset' => $this->getVar('rNum'),
                				    'logubah_catatan' => $functDB->encap_string($logubah_catatan),
                				    'logubah_tanggal' => 'now()',
                				    'logubah_waktu' => 'now()',
                				    'logubah_oleh' => $functDB->encap_string($member['firstName']),
                				    'trx_stat_input_by' => $member['idxNum'],
                                    'trx_stat_input_time' => 'now()',
                                    );
                $functDB->dbins("log_perubahan",$arrData2);
                
                die('1024');
            } else {
                die($handle->error);
            }
        }
        else {
            die($handle->error);
        }
        die();
        
    }
    
    function ajx_delManual() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $SQLaset = "select   *
                    from     ref_aset
                      			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                      			left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                    where    ref_aset.ast_id = '".$this->getVar('rNum2')."'
                    ";
        $rhAset  = $this->dbH->query($SQLaset);
        $functDB->dberror_show($rhAset);
        $rrAset = $rhAset->fetch();
        
        $SQLlist = "select * from ref_aset_usermanual where file_id = '".$this->getVar('rNum')."' and file_id_aset = '".$this->getVar('rNum2')."' ";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rrlist = $rhlist->fetch();
        
        $logubah_catatan = '[AUTO] Penghapusan dokumen manual '.$rrlist['file_label'].' ('.$rrlist['file_name'].') dari aset "'.$rrAset['ast_label'];
        $arrData2 = array ( 'logubah_id_aset' => $this->getVar('rNum2'),
        				    'logubah_catatan' => $functDB->encap_string($logubah_catatan),
        				    'logubah_tanggal' => 'now()',
        				    'logubah_waktu' => 'now()',
        				    'logubah_oleh' => $functDB->encap_string($member['firstName']),
        				    'trx_stat_input_by' => $member['idxNum'],
                            'trx_stat_input_time' => 'now()',
                            );
        $functDB->dbins("log_perubahan",$arrData2);
        
        if ($rrlist['file_id'] > 0) {
            $functDB->dbdelete("ref_aset_usermanual","file_id = ".$this->getVar('rNum'),'');
            // unlink($rrlist['file_name']);
        }
        
        die();
        
    }
    
    function ajx_saveIp() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        if (($this->getVar('rNum') > 0) && ($this->getVar('rNum2') > 0)) {
            
            $arrData = array ( 'map_id_aset' => $functDB->encap_numeric($this->getVar('rNum')),
                               'map_id_ip' => $functDB->encap_numeric($this->getVar('rNum2')),
                               'stat_inp_by' => $member['idxNum'],
                               'stat_inp_time' => 'now()',
                               );
            $functDB->dbins('ref_aset_ipmap',$arrData);
            
            $lastInsertId = $this->dbH->lastInsertId();
            
            $SQLaset = "select   *
                        from     ref_aset
                          			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                          			left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                        where    ref_aset.ast_id = '".$this->getVar('rNum')."'
                        ";
            $rhAset  = $this->dbH->query($SQLaset);
            $functDB->dberror_show($rhAset);
            $rrAset = $rhAset->fetch();
            
            $SQLprev = "select   *
                        from     ref_aset_ipmap
                          			left join ref_ip on map_id_ip = ip_id
                        where    map_ip_id = '".$lastInsertId."'
                        ";
            $rhprev  = $this->dbH->query($SQLprev);
            $functDB->dberror_show($rhprev);
            $rrprev = $rhprev->fetch();
            
            $logubah_catatan = '[AUTO] Pemetaan IP '.$rrprev['ip_number'].' kepada aset "'.$rrAset['ast_label'];
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
                    from     ref_aset
                      			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                      			left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                    where    ref_aset.ast_id = '".$this->getVar('rNum2')."'
                    ";
        $rhAset  = $this->dbH->query($SQLaset);
        $functDB->dberror_show($rhAset);
        $rrAset = $rhAset->fetch();
        
        $SQLprev = "select   *
                    from     ref_aset_ipmap
                      			left join ref_ip on map_id_ip = ip_id
                    where    map_ip_id = '".$this->getVar('rNum')."'
                    ";
        $rhprev  = $this->dbH->query($SQLprev);
        $functDB->dberror_show($rhprev);
        $rrprev = $rhprev->fetch();
        
        $logubah_catatan = '[AUTO] Penghapusan Pemetaan IP '.$rrprev['ip_number'].' dari aset "'.$rrAset['ast_label'];
        $arrData2 = array ( 'logubah_id_aset' => $this->getVar('rNum2'),
        				    'logubah_catatan' => $functDB->encap_string($logubah_catatan),
        				    'logubah_tanggal' => 'now()',
        				    'logubah_waktu' => 'now()',
        				    'logubah_oleh' => $functDB->encap_string($member['firstName']),
        				    'trx_stat_input_by' => $member['idxNum'],
                            'trx_stat_input_time' => 'now()',
                            );
        $functDB->dbins("log_perubahan",$arrData2);
        
        $functDB->dbdelete("ref_aset_ipmap","map_id_aset = ".$this->getVar('rNum2')." and map_ip_id = ".$this->getVar('rNum'),'');
        die();
    }
    
    function ajx_getDivView_aset() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $SQLaset = "select   ref_aset.*,
                             ast_id as id,
                             case when ref_aset.ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                             astgrp_label,
                             astgrp_kode,
                             astgrp_desc,
                             pngjwb_label,
                             pngjwb_kode,
                             pngjwb_telp,
                             pngjwb_email,
                             (select loc_label from ref_aset_lokasi, trx_lokasi where loc_id = trxloc_id_lokasi_baru and trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1) as infolokasi
                    from     ref_aset
                      			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                      			left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                    where    ref_aset.ast_id = '".$this->getVar('rNum')."'
                    ";
        $rhAset  = $this->dbH->query($SQLaset);
        $functDB->dberror_show($rhAset);
        $rrAset = $rhAset->fetch();
        
        // ip
        $sma_ip = '<ul style="margin-left:15px; padding-left:0px;">';
        $SQLasetIP = "select   *
                      from     ref_aset_ipmap, ref_ip
                      where    map_id_aset = '".$this->getVar('rNum')."' and
                               map_id_ip = ip_id
                      order by ip_number
                      ";
        $rhAsetIP  = $this->dbH->query($SQLasetIP);
        $functDB->dberror_show($rhAsetIP);
        while ($rrAsetIP = $rhAsetIP->fetch()) {
            $sma_ip .= '<li>'.$rrAsetIP['ip_number'].'</li>';
        }
        $sma_ip .= '</ul>';
        
        // divview_badge
        $fTpt_badge = $this->loadTemplate('/ref2015/refAset_badge');
        $fTpt_badge->addText('<a href="./tmpImage/invastqrc_'.$this->getVar('rNum').'.png?tt='.time().'" target="_blank"><img src="./tmpImage/invastqrc_'.$this->getVar('rNum').'.png?tt='.time().'" class="img-thumbnail" style="width:90%"></a>','sma_image_qr');
        $fTpt_badge->addText($rrAset['ast_label'],'sma_nama');
        $fTpt_badge->addText($rrAset['astgrp_label'],'sma_jenis');
        $fTpt_badge->addText($rrAset['ast_kode_bmn'],'sma_bmn');
        $fTpt_badge->addText($rrAset['infolokasi'],'sma_lokasi');
        $fTpt_badge->addText($sma_ip,'sma_ip');
        $fTpt_badge->addText($rrAset['pngjwb_label'],'sma_png_nama');
        $fTpt_badge->addText($rrAset['pngjwb_telp'],'sma_png_telp');
        $fTpt_badge->addText('<a href="mailto:'.$rrAset['pngjwb_email'].'"><small>'.$rrAset['pngjwb_email'].'</small>','sma_png_email');
        
        // spesifikasi
        $divtab_spesifikasi = '<table class="table table-hover table-striped table-bordered">';
        $divtab_spesifikasi .= '<thead>';
        $divtab_spesifikasi .= ' <tr>';
        $divtab_spesifikasi .= '  <th>Spesifikasi</th>';
        // $divtab_spesifikasi .= '  <th>Keterangan</th>';
        $divtab_spesifikasi .= '  <th>Nilai</th>';
        $divtab_spesifikasi .= '  <th>Unit</th>';
        $divtab_spesifikasi .= ' </tr>';
        $divtab_spesifikasi .= '</thead>';
        $divtab_spesifikasi .= '<tbody>';
        $SQLlist = "select * 
                    from   ref_aset_grup_spek left join ref_aset_spesifikasi on astgrpspek_id = astspk_id_grup_spek and astspk_id_aset = '".$this->getVar('rNum')."'
                    where  astgrpspek_id_grup = '".$rrAset['ast_id_grupaset']."' and
                           ref_aset_grup_spek.ref_stat_visible = 1
                    order by astgrpspek_urutan
                    ";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        while ($rrlist = $rhlist->fetch()) {
            $rowCount++;
            $divtab_spesifikasi .= ' <tr>';
            $divtab_spesifikasi .= '  <td>'.$rrlist['astgrpspek_label'].'</td>';
            // $divtab_spesifikasi .= '  <td>'.$rrlist['astgrpspek_keterangan'].'</td>';
            $divtab_spesifikasi .= '  <td>'.$rrlist['astspk_value_text'].'</td>';
            $divtab_spesifikasi .= '  <td>'.$rrlist['astgrpspek_satuan'].'</td>';
            $divtab_spesifikasi .= ' </tr>';
        }
        $divtab_spesifikasi .= '</tbody>';
        $divtab_spesifikasi .= '</table>';
        
        $divtab_peristiwa_timeline = $this->ajx_getEventData();
        $divtab_lokasi_timeline = $this->ajx_getLokasiData();
        
        // divtab_perubahan_timeline
        $divtab_perubahan_timeline = '';
        $divtab_perubahan_timeline .= '<table border="0" cellpadding="0" cellspacing="0" width="100%">';
        $divtab_perubahan_timeline .= '<tr>';
        $divtab_perubahan_timeline .= '<td align="left" valign="top" width="75">&nbsp;</td>';
        $divtab_perubahan_timeline .= '<td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;"><img src="./images/vtl_node_now.png"></td>';
        $divtab_perubahan_timeline .= '<td align="right" valign="top" height="30"><button class="btn btn-default" onclick="show_divtab_perubahan_table()">Lihat Tabel</button></td>';
        $divtab_perubahan_timeline .= '</tr>';
        
        $SQLlist = "select *,
                            date_format(TIMESTAMP(logubah_tanggal,logubah_waktu), '%e %b %Y, %H:%i:%s') as waktu,
                            timestampdiff(day,TIMESTAMP(logubah_tanggal,logubah_waktu),now()) as diffday,
                            timestampdiff(hour,TIMESTAMP(logubah_tanggal,logubah_waktu),now()) as diffhour,
                            timestampdiff(minute,TIMESTAMP(logubah_tanggal,logubah_waktu),now()) as diffmin,
                            timestampdiff(second,TIMESTAMP(logubah_tanggal,logubah_waktu),now()) as diffsec
                     from   log_perubahan 
                     where  logubah_id_aset = '".$this->getVar('rNum')."' 
                     order by logubah_tanggal desc, logubah_waktu desc
                     ";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rowCounter = 0;
        while ($rrlist = $rhlist->fetch()) {
            $rowCounter++;
            if ($rowCounter <= 50) {
                
                $badgeTime = '';
                if ($rrlist['diffday'] > 0) {
                    $t_val1 = $rrlist['diffday'] * 24;
                    $t_val2 = $rrlist['diffhour'] - $t_val1;
                    if ($t_val2 > 0) {
                        $badgeTime = '- '.$rrlist['diffday'].' hari<BR>'.$t_val2.' jam';
                    }
                    else {
                        $badgeTime = '- '.$rrlist['diffday'].' hari';
                    }
                }
                elseif ($rrlist['diffhour'] > 0) {
                    $t_val1 = $rrlist['diffhour'] * 60;
                    $t_val2 = $rrlist['diffmin'] - $t_val1;
                    if ($t_val2 > 0) {
                        $badgeTime = '- '.$rrlist['diffhour'].' jam<BR>'.$t_val2.' menit';
                    }
                    else {
                        $badgeTime = '- '.$rrlist['diffhour'].' jam';
                    }
                }
                elseif ($rrlist['diffmin'] > 0) {
                    $t_val1 = $rrlist['diffmin'] * 60;
                    $t_val2 = $rrlist['diffsec'] - $t_val1;
                    if ($t_val2 > 0) {
                        $badgeTime = '- '.$rrlist['diffmin'].' menit<BR>'.$t_val2.' detik';
                    }
                    else {
                        $badgeTime = '- '.$rrlist['diffmin'].' menit';
                    }
                }
                elseif ($rrlist['diffsec'] > 0) {
                    $badgeTime = '- '.$rrlist['diffsec'].' detik';
                }
                
                $rowContent = '
                <span class="label label-default"><small><b>'.$rrlist['waktu'].'</b></small></span>
                <p style="margin-top:10px;">Telah dilakukan perubahan pada aset <B>'.$rrAset['ast_label'].'</B> dengan keterangan <B>'.$rrlist['logubah_catatan'].'</B>
                dilaporkan oleh <B>'.$rrlist['logubah_oleh'].'</B>
                </p>
                ';
                
                $divtab_perubahan_timeline .= '<tr>';
                $divtab_perubahan_timeline .= ' <td align="left" valign="top" width="75">&nbsp;</td>';
                $divtab_perubahan_timeline .= ' <td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;">&nbsp;</td>';
                $divtab_perubahan_timeline .= ' <td align="left" valign="top" height="35">&nbsp;</td>';
                $divtab_perubahan_timeline .= '</tr>';
                $divtab_perubahan_timeline .= '<tr>';
                $divtab_perubahan_timeline .= ' <td align="center" valign="top" width="75"><small>'.$badgeTime.'</small></td>';
                $divtab_perubahan_timeline .= ' <td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;"><img src="./images/vtl_node.png"></td>';
                $divtab_perubahan_timeline .= ' <td align="left" valign="top">
                                             <div class="popover-alwayshow2">
                                               <div class="popover right">
                                                 <div class="arrow"></div>
                                                 <div class="popover-title" style="min-height:25px;">'.$rowContent.'</div>
                                               </div>
                                             </div>
                                             </td>';
            }
        }
        $divtab_perubahan_timeline .= '<tr>';
        $divtab_perubahan_timeline .= ' <td align="left" valign="top" width="75">&nbsp;</td>';
        $divtab_perubahan_timeline .= ' <td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;">&nbsp;</td>';
        $divtab_perubahan_timeline .= ' <td align="left" valign="top" height="35">&nbsp;</td>';
        $divtab_perubahan_timeline .= '</tr>';
        if ($rowCounter <= 50) {
            $divtab_perubahan_timeline .= '<tr>';
            $divtab_perubahan_timeline .= '<td align="left" valign="top" width="75">&nbsp;</td>';
            $divtab_perubahan_timeline .= '<td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;"><img src="./images/vtl_node_end.png"></td>';
            $divtab_perubahan_timeline .= '<td align="right" valign="top" height="30">&nbsp;</td>';
            $divtab_perubahan_timeline .= '</tr>';
        }
        else {
            $divtab_perubahan_timeline .= '<tr>';
            $divtab_perubahan_timeline .= '<td align="left" valign="top" width="75">&nbsp;</td>';
            $divtab_perubahan_timeline .= '<td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;"><img src="./images/vtl_node_more.png"></td>';
            $divtab_perubahan_timeline .= '<td align="right" valign="top" height="30"><button class="btn btn-default" onclick="show_divtab_perubahan_table()">Lihat Tabel</button></td>';
            $divtab_perubahan_timeline .= '</tr>';
        }
        
        // foto
        $div_listOfFoto = '<ul class="list-group">';
        $SQLlist = " select * from ref_aset_foto where foto_id_aset = '".$this->getVar('rNum')."' order by foto_id";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rowCount = 0;
        while ($rrlist = $rhlist->fetch()) {
            $rowCount++;
            $div_listOfFoto .= '<li class="list-group-item"><a href="javascript:;" onclick="view_foto(\''.$rrlist['foto_filename'].'\')"><img src="'.$rrlist['foto_filename'].'" width="100%" class="thumbnail"></a></li>';
        }
        if ($rowCount == 0) {
            $div_listOfFoto .= '* belum ada foto';
        }
        $div_listOfFoto .= '</ul>';
        
        // dokumen
        $div_listOfDokumen = '<ul class="list-group">';
        $SQLlist = " select * from ref_aset_dokumen where file_id_aset = '".$this->getVar('rNum')."' order by file_id ";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rowCount = 0;
        while ($rrlist = $rhlist->fetch()) {
            $rowCount++;
            $div_listOfDokumen .= '<li class="list-group-item"><a href="'.$rrlist['file_name'].'" target="_blank">'.$rrlist['file_label'].'</a></li>';
        }
        if ($rowCount == 0) {
            $div_listOfDokumen .= '* belum ada dokumen';
        }
        $div_listOfDokumen .= '</ul>';
        
        $div_listOfManual = '<ul class="list-group">';
        $SQLlist = " select * from ref_aset_usermanual where file_id_aset = '".$this->getVar('rNum')."' order by file_id ";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rowCount = 0;
        while ($rrlist = $rhlist->fetch()) {
            $rowCount++;
            $div_listOfManual .= '<li class="list-group-item"><a href="'.$rrlist['file_name'].'" target="_blank">'.$rrlist['file_label'].'</a></li>';
        }
        if ($rowCount == 0) {
            $div_listOfManual .= '* belum ada panduan';
        }
        $div_listOfManual .= '</ul>';
        
                
        $returnVal = array();
        
        $returnVal['divview_badge'] = $fTpt_badge->run();
        $returnVal['divw_namaaset'] = '<h1><B>'.$rrAset['ast_label'].'</B></h1>';
        $returnVal['divtab_spesifikasi'] = $divtab_spesifikasi;
        $returnVal['divtab_lokasi_timeline'] = $divtab_lokasi_timeline;
        $returnVal['divtab_peristiwa_timeline'] = $divtab_peristiwa_timeline;
        $returnVal['divtab_perubahan_timeline'] = $divtab_perubahan_timeline;
        $returnVal['divtab_foto'] = $div_listOfFoto;
        $returnVal['divtab_dokumen'] = $div_listOfDokumen;
        $returnVal['divtab_panduan'] = $div_listOfManual;
        
        die(json_encode(($returnVal)));
        
    }
    
    function createQrCode($id=0) {

		include_once('./qrcode/qrlib.php');
        $functDB =& $this->loadModule('functionDB');

		$SQLGlobal = " select * from ref_global order by global_datetime desc limit 1 ";
        $rhGlobal  = $this->dbH->query($SQLGlobal);
        $functDB->dberror_show($rhGlobal);
        $rrGlobal = $rhGlobal->fetch();

        $SQL = " select * from ref_aset where ast_id = '".$id."' ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);
        $rr = $rh->fetch();

        $pngFiles = './tmpImage/invastqrc_'.$id.'.png';
		$codeToWrite = $rrGlobal['global_akses'].'/home/inq.php?id='.$rr['ast_refercode'];

		QRcode::png($codeToWrite, $pngFiles);

    }
    
    function formAddLokasi() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $form =& $this->newSmartForm();
        
        $form->addDirective('useCustomFormTag',true);
        $form->addDirective('customFormTagBegin','<form id="'.$form->directive['formName'].'" name="'.$form->directive['formName'].'" role="form">');
        $form->addDirective('customFormTagEnd','</form>');
        
        $fTpt =& $form->loadTemplate('/ref2015/refAset_formLokasi');
        
        $fTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid=ajxLokasiSave','url_ajxLokasiSave');
        $fTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid=ajxLokasiDelete','url_ajxLokasiDelete');
        
        $form->add('info_aset','Aset','text',false,$rrAset['ast_label'],array('extraAttributes'=>' style="width:100%;" readonly disabled '));

        $form->add('trxloc_tanggal','Tanggal','kendoDate',true,$rr['trxloc_tanggal'],array('extraAttributes'=>' style="width:100%;" '));
        $form->add('trxloc_waktu','Waktu','kendoTime',true,$rr['trxloc_waktu'],array('extraAttributes'=>' style="width:100%;" '));

        $select =& $form->add('trxloc_id_lokasi_baru','Lokasi Aset','kendoDbCombo',true,$rr['trxloc_id_lokasi_baru']);
        $select->configure(array(
                    'tableName'           => "ref_aset_lokasi",
                    'dataField'           => "loc_id",
                    'viewField'           => "loc_label",
                    'whereClause'         => "ref_stat_visible = 1 ",
                    'addNoOption'         => false,
                    'placeHolder'         => "Pilih Lokasi Aset",
                    'extraAttributes'     => "style='width:100%;' ",
        ));

        $form->add('trxloc_alasan','Alasan Pemindahan','textArea',true,$rr['trxloc_alasan'],array('extraAttributes'=>' style="width:100%; height:100px;" '));
        
        return $form->output();
        
    }
    
    function formAddEvent() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $form =& $this->newSmartForm();
        
        $form->addDirective('useCustomFormTag',true);
        $form->addDirective('customFormTagBegin','<form id="'.$form->directive['formName'].'" name="'.$form->directive['formName'].'" role="form">');
        $form->addDirective('customFormTagEnd','</form>');

        $fTpt =& $form->loadTemplate('/ref2015/refAset_formEvent');
        
        $fTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid=ajxEventSave','url_ajxEventSave');
        $fTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid=ajxEventDelete','url_ajxEventDelete');
        
        
        $form->add('info_aset','Aset','text',false,$rrAset['ast_label'],array('extraAttributes'=>' style="width:100%;" readonly disabled '));

        $form->add('trxkej_tanggal','Tanggal','kendoDate',true,$rr['trxkej_tanggal'],array('extraAttributes'=>' style="width:100%;" '));
        $form->add('trxkej_waktu','Waktu','kendoTime',true,$rr['trxkej_waktu'],array('extraAttributes'=>' style="width:100%;" '));

        $select =& $form->add('trxkej_id_kej','Jenis Kejadian','kendoDbCombo',true,$rr['trxkej_id_kej']);
        $select->configure(array(
                    'tableName'           => "ref_kejadian_jenis",
                    'dataField'           => "jnskej_id",
                    'viewField'           => "jnskej_label",
                    'whereClause'         => "ref_stat_visible = 1 ",
                    'addNoOption'         => false,
                    'placeHolder'     => "Pilih Jenis Kejadian",
                    'extraAttributes'     => "style='width:100%;' ",
        ));

        $form->add('trxkej_keterangan','Catatan','textArea',true,$rr['trxkej_keterangan'],array('extraAttributes'=>' style="width:100%; height:100px;" '));
        
        return $form->output();
        
    }
    
    function ajxEventSave() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $trxkej_tanggal = $functDB->encap_date($_POST['trxkej_tanggal']);
        $trxkej_waktu = $functDB->encap_time($_POST['trxkej_waktu']);
        $trxkej_id_kej = $functDB->encap_numeric($_POST['trxkej_id_kej']);
        $trxkej_keterangan = $functDB->encap_string($_POST['trxkej_keterangan']);
        $trxkej_oleh = $functDB->encap_string($member['firstName']);
        $trxkej_id_aset = $functDB->encap_numeric($this->getVar('rNum'));
        
        $arrData = array (  'trxkej_tanggal' => $trxkej_tanggal,
                            'trxkej_waktu' => $trxkej_waktu,
                            'trxkej_id_kej' => $trxkej_id_kej,
                            'trxkej_keterangan' => $trxkej_keterangan,
                            'trxkej_oleh' => $trxkej_oleh,
                            'trxkej_id_aset' => $trxkej_id_aset,
                            'trx_stat_input_by' => $member['idxNum'],
                            'trx_stat_input_time' => 'now()',
                            );
                            
        $functDB->dbins('trx_kejadian',$arrData);

        $this->setInVar('aswid','ajx_getEventData');
        
        $this->ajx_getEventData();
        
        die('finish');
        
    }
    
    function ajxEventDelete() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $functDB->dbdelete("trx_kejadian","trxkej_id = ".$this->getVar('rNum2'),'');
        
        $this->setInVar('aswid','ajx_getEventData');
        
        $this->ajx_getEventData();
        
        die('finish');
        
    }
    
    function ajx_getEventData() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        // divtab_peristiwa_timeline
        $divtab_peristiwa_timeline = '';
        $divtab_peristiwa_timeline .= '<table border="0" cellpadding="0" cellspacing="0" width="100%">';
        $divtab_peristiwa_timeline .= '<tr>';
        $divtab_peristiwa_timeline .= '<td align="left" valign="top" width="75">&nbsp;</td>';
        $divtab_peristiwa_timeline .= '<td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;"><img src="./images/vtl_node_now.png"></td>';
        $divtab_peristiwa_timeline .= '<td align="right" valign="top" height="30"><button class="btn btn-default" onclick="show_divtab_peristiwa_table()">Lihat Tabel</button> <button class="btn btn-default" onclick="openform_newevent()">+ Data</button></td>';
        $divtab_peristiwa_timeline .= '</tr>';
        
        $SQLlist = "select *,
                            (select jnskej_label from ref_kejadian_jenis where jnskej_id = trxkej_id_kej) as kejadian,
                            date_format(TIMESTAMP(trxkej_tanggal,trxkej_waktu), '%e %b %Y, %H:%i:%s') as waktu,
                            timestampdiff(day,TIMESTAMP(trxkej_tanggal,trxkej_waktu),now()) as diffday,
                            timestampdiff(hour,TIMESTAMP(trxkej_tanggal,trxkej_waktu),now()) as diffhour,
                            timestampdiff(minute,TIMESTAMP(trxkej_tanggal,trxkej_waktu),now()) as diffmin,
                            timestampdiff(second,TIMESTAMP(trxkej_tanggal,trxkej_waktu),now()) as diffsec
                     from   trx_kejadian 
                     where  trxkej_id_aset = '".$this->getVar('rNum')."' 
                     order by trxkej_tanggal desc, trxkej_waktu desc
                     ";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rowCounter = 0;
        while ($rrlist = $rhlist->fetch()) {
            $rowCounter++;
            if ($rowCounter <= 50) {
                
                $badgeTime = '';
                if ($rrlist['diffday'] > 0) {
                    $t_val1 = $rrlist['diffday'] * 24;
                    $t_val2 = $rrlist['diffhour'] - $t_val1;
                    if ($t_val2 > 0) {
                        $badgeTime = '- '.$rrlist['diffday'].' hari<BR>'.$t_val2.' jam';
                    }
                    else {
                        $badgeTime = '- '.$rrlist['diffday'].' hari';
                    }
                }
                elseif ($rrlist['diffhour'] > 0) {
                    $t_val1 = $rrlist['diffhour'] * 60;
                    $t_val2 = $rrlist['diffmin'] - $t_val1;
                    if ($t_val2 > 0) {
                        $badgeTime = '- '.$rrlist['diffhour'].' jam<BR>'.$t_val2.' menit';
                    }
                    else {
                        $badgeTime = '- '.$rrlist['diffhour'].' jam';
                    }
                }
                elseif ($rrlist['diffmin'] > 0) {
                    $t_val1 = $rrlist['diffmin'] * 60;
                    $t_val2 = $rrlist['diffsec'] - $t_val1;
                    if ($t_val2 > 0) {
                        $badgeTime = '- '.$rrlist['diffmin'].' menit<BR>'.$t_val2.' detik';
                    }
                    else {
                        $badgeTime = '- '.$rrlist['diffmin'].' menit';
                    }
                }
                elseif ($rrlist['diffsec'] > 0) {
                    $badgeTime = '- '.$rrlist['diffsec'].' detik';
                }
                
                $rowContent = '
                <span class="label label-default"><small><b>'.$rrlist['waktu'].'</b></small></span>
                <p style="margin-top:10px;">Telah terjadi <B>'.$rrlist['kejadian'].'</B> pada aset <B>'.$rrAset['ast_label'].'</B> dengan keterangan <B>'.$rrlist['trxkej_keterangan'].'</B>
                dilaporkan oleh <B>'.$rrlist['trxkej_oleh'].'</B>
                </p>
                ';
                
                $divtab_peristiwa_timeline .= '<tr>';
                $divtab_peristiwa_timeline .= ' <td align="left" valign="top" width="75">&nbsp;</td>';
                $divtab_peristiwa_timeline .= ' <td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;">&nbsp;</td>';
                $divtab_peristiwa_timeline .= ' <td align="left" valign="top" height="35">&nbsp;</td>';
                $divtab_peristiwa_timeline .= '</tr>';
                $divtab_peristiwa_timeline .= '<tr>';
                $divtab_peristiwa_timeline .= ' <td align="center" valign="top" width="75"><small>'.$badgeTime.'</small></td>';
                $divtab_peristiwa_timeline .= ' <td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;"><img src="./images/vtl_node.png"></td>';
                $divtab_peristiwa_timeline .= ' <td align="left" valign="top">
                                             <div class="popover-alwayshow2">
                                               <div class="popover right">
                                                 <div class="arrow"></div>
                                                 <div class="popover-title" style="min-height:25px;">'.$rowContent.'</div>
                                               </div>
                                             </div>
                                             </td>';
            }
        }
        $divtab_peristiwa_timeline .= '<tr>';
        $divtab_peristiwa_timeline .= ' <td align="left" valign="top" width="75">&nbsp;</td>';
        $divtab_peristiwa_timeline .= ' <td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;">&nbsp;</td>';
        $divtab_peristiwa_timeline .= ' <td align="left" valign="top" height="35">&nbsp;</td>';
        $divtab_peristiwa_timeline .= '</tr>';
        if ($rowCounter <= 50) {
            $divtab_peristiwa_timeline .= '<tr>';
            $divtab_peristiwa_timeline .= '<td align="left" valign="top" width="75">&nbsp;</td>';
            $divtab_peristiwa_timeline .= '<td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;"><img src="./images/vtl_node_end.png"></td>';
            $divtab_peristiwa_timeline .= '<td align="right" valign="top" height="30">&nbsp;</td>';
            $divtab_peristiwa_timeline .= '</tr>';
        }
        else {
            $divtab_peristiwa_timeline .= '<tr>';
            $divtab_peristiwa_timeline .= '<td align="left" valign="top" width="75">&nbsp;</td>';
            $divtab_peristiwa_timeline .= '<td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;"><img src="./images/vtl_node_more.png"></td>';
            $divtab_peristiwa_timeline .= '<td align="right" valign="top" height="30"><button class="btn btn-default" onclick="show_divtab_peristiwa_table()">Lihat Tabel</button></td>';
            $divtab_peristiwa_timeline .= '</tr>';
        }
        
        if ($this->getVar('aswid') == 'ajx_getEventData') {
            
            die($divtab_peristiwa_timeline.'');
        }
        else {
            
            return $divtab_peristiwa_timeline;
        }
        
    }
    
    function ajxLokasiSave() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $trxloc_tanggal = $functDB->encap_date($_POST['trxloc_tanggal']);
        $trxloc_waktu = $functDB->encap_time($_POST['trxloc_waktu']);
        $trxloc_id_lokasi_baru = $functDB->encap_numeric($_POST['trxloc_id_lokasi_baru']);
        $trxloc_alasan = $functDB->encap_string($_POST['trxloc_alasan']);
        $trxloc_oleh = $functDB->encap_string($member['firstName']);
        $trxloc_id_aset = $functDB->encap_numeric($this->getVar('rNum'));
        
        $arrData = array ( 'trxloc_tanggal' => $trxloc_tanggal,
                           'trxloc_waktu' => $trxloc_waktu,
                           'trxloc_id_lokasi_baru' => $trxloc_id_lokasi_baru,
                           'trxloc_alasan' => $trxloc_alasan,
                           'trxloc_oleh' => $trxloc_oleh,
                           'trxloc_id_aset' => $trxloc_id_aset,
                           'trx_stat_input_by' => $member['idxNum'],
                           'trx_stat_input_time' => 'now()',
                           );
        $functDB->dbins('trx_lokasi',$arrData);

        $this->setInVar('aswid','ajx_getLokasiData');
        
        $this->ajx_getLokasiData();
        
        die('finish');
        
    }
    
    function ajxLokasiDelete() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        $functDB->dbdelete("trx_lokasi","trxloc_id = ".$this->getVar('rNum2'),'');
        
        $this->setInVar('aswid','ajx_getLokasiData');
        
        $this->ajx_getLokasiData();
        
        die('finish');
        
    }
    
    function ajx_getLokasiData() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        // divtab_lokasi_timeline
        $divtab_lokasi_timeline = '';
        $divtab_lokasi_timeline .= '<table border="0" cellpadding="0" cellspacing="0" width="100%">';
        $divtab_lokasi_timeline .= '<tr>';
        $divtab_lokasi_timeline .= '<td align="left" valign="top" width="75">&nbsp;</td>';
        $divtab_lokasi_timeline .= '<td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;"><img src="./images/vtl_node_now.png"></td>';
        $divtab_lokasi_timeline .= '<td align="right" valign="top" height="30"><button class="btn btn-default" onclick="show_divtab_lokasi_table()">Lihat Tabel</button> <button class="btn btn-default" onclick="openform_newloc()">+ Data</button></td>';
        $divtab_lokasi_timeline .= '</tr>';
        
        $SQLlist = "select *,
                            (select loc_label from ref_aset_lokasi where loc_id = trxloc_id_lokasi_sebelumnya) as lokasi_sebelum,
                            (select loc_label from ref_aset_lokasi where loc_id = trxloc_id_lokasi_baru) as lokasi_baru,
                            date_format(TIMESTAMP(trxloc_tanggal,trxloc_waktu), '%e %b %Y, %H:%i:%s') as waktu,
                            timestampdiff(day,TIMESTAMP(trxloc_tanggal,trxloc_waktu),now()) as diffday,
                            timestampdiff(hour,TIMESTAMP(trxloc_tanggal,trxloc_waktu),now()) as diffhour,
                            timestampdiff(minute,TIMESTAMP(trxloc_tanggal,trxloc_waktu),now()) as diffmin,
                            timestampdiff(second,TIMESTAMP(trxloc_tanggal,trxloc_waktu),now()) as diffsec
                     from   trx_lokasi 
                     where  trxloc_id_aset = '".$this->getVar('rNum')."' 
                     order by trxloc_tanggal desc, trxloc_waktu desc
                     ";
        $rhlist  = $this->dbH->query($SQLlist);
        $functDB->dberror_show($rhlist);
        $rowCounter = 0;
        while ($rrlist = $rhlist->fetch()) {
            $rowCounter++;
            if ($rowCounter <= 50) {
                
                $badgeTime = '';
                if ($rrlist['diffday'] > 0) {
                    $t_val1 = $rrlist['diffday'] * 24;
                    $t_val2 = $rrlist['diffhour'] - $t_val1;
                    if ($t_val2 > 0) {
                        $badgeTime = '- '.$rrlist['diffday'].' hari<BR>'.$t_val2.' jam';
                    }
                    else {
                        $badgeTime = '- '.$rrlist['diffday'].' hari';
                    }
                }
                elseif ($rrlist['diffhour'] > 0) {
                    $t_val1 = $rrlist['diffhour'] * 60;
                    $t_val2 = $rrlist['diffmin'] - $t_val1;
                    if ($t_val2 > 0) {
                        $badgeTime = '- '.$rrlist['diffhour'].' jam<BR>'.$t_val2.' menit';
                    }
                    else {
                        $badgeTime = '- '.$rrlist['diffhour'].' jam';
                    }
                }
                elseif ($rrlist['diffmin'] > 0) {
                    $t_val1 = $rrlist['diffmin'] * 60;
                    $t_val2 = $rrlist['diffsec'] - $t_val1;
                    if ($t_val2 > 0) {
                        $badgeTime = '- '.$rrlist['diffmin'].' menit<BR>'.$t_val2.' detik';
                    }
                    else {
                        $badgeTime = '- '.$rrlist['diffmin'].' menit';
                    }
                }
                elseif ($rrlist['diffsec'] > 0) {
                    $badgeTime = '- '.$rrlist['diffsec'].' detik';
                }
                
                $lokasiSebelum = '';
                if (strlen(trim($rrlist['lokasi_sebelum']))>0) {
                    $lokasiSebelum = ' dari lokasi '.$rrlist['lokasi_sebelum'];
                }
                $rowContent = '
                <span class="label label-default"><small><b>'.$rrlist['waktu'].'</b></small></span>
                <p style="margin-top:10px;">Aset <B>'.$rrAset['ast_label'].'</B> telah dipindahkan '.$lokasiSebelum.' ke lokasi baru <B>'.$rrlist['lokasi_baru'].'</B>
                oleh <B>'.$rrlist['trxloc_oleh'].'</B> dengan alasan <B>'.$rrlist['trxloc_alasan'].'</B>
                </p>
                ';
                

                $divtab_lokasi_timeline .= '<tr>';
                $divtab_lokasi_timeline .= ' <td align="left" valign="top" width="75">&nbsp;</td>';
                $divtab_lokasi_timeline .= ' <td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;">&nbsp;</td>';
                $divtab_lokasi_timeline .= ' <td align="left" valign="top" height="35">&nbsp;</td>';
                $divtab_lokasi_timeline .= '</tr>';
                $divtab_lokasi_timeline .= '<tr>';
                $divtab_lokasi_timeline .= ' <td align="center" valign="top" width="75"><small>'.$badgeTime.'</small></td>';
                $divtab_lokasi_timeline .= ' <td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;"><img src="./images/vtl_node.png"></td>';
                $divtab_lokasi_timeline .= ' <td align="left" valign="top">
                                             <div class="popover-alwayshow2">
                                               <div class="popover right">
                                                 <div class="arrow"></div>
                                                 <div class="popover-title" style="min-height:25px;">'.$rowContent.'</div>
                                               </div>
                                             </div>
                                             </td>';
            }
        }
        $divtab_lokasi_timeline .= '<tr>';
        $divtab_lokasi_timeline .= ' <td align="left" valign="top" width="75">&nbsp;</td>';
        $divtab_lokasi_timeline .= ' <td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;">&nbsp;</td>';
        $divtab_lokasi_timeline .= ' <td align="left" valign="top" height="35">&nbsp;</td>';
        $divtab_lokasi_timeline .= '</tr>';
        if ($rowCounter <= 50) {
            $divtab_lokasi_timeline .= '<tr>';
            $divtab_lokasi_timeline .= '<td align="left" valign="top" width="75">&nbsp;</td>';
            $divtab_lokasi_timeline .= '<td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;"><img src="./images/vtl_node_end.png"></td>';
            $divtab_lokasi_timeline .= '<td align="right" valign="top" height="30">&nbsp;</td>';
            $divtab_lokasi_timeline .= '</tr>';
        }
        else {
            $divtab_lokasi_timeline .= '<tr>';
            $divtab_lokasi_timeline .= '<td align="left" valign="top" width="75">&nbsp;</td>';
            $divtab_lokasi_timeline .= '<td align="left" valign="top" width="50" style="background-image: url(\'./images/vtl_line.png\'); background-repeat: repeat-y;"><img src="./images/vtl_node_more.png"></td>';
            $divtab_lokasi_timeline .= '<td align="right" valign="top" height="30"><button class="btn btn-default" onclick="show_divtab_lokasi_table()">Lihat Tabel</button></td>';
            $divtab_lokasi_timeline .= '</tr>';
        }
        
        if ($this->getVar('aswid') == 'ajx_getLokasiData') {
            
            die($divtab_lokasi_timeline.'');
        }
        else {
            
            return $divtab_lokasi_timeline;
        }
    }
    
    
    function buildGridPerLokasi() {

	    $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

	    $html  = '';

	    $html .= '<div id="tabstrip2">'.chr(13);
	    $html .= '<ul>'.chr(13);

	    $SQL = " select * from ref_aset_lokasi where ref_stat_visible = 1 order by loc_id_jenislokasi, loc_label ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);
        $locCtr    = 0;
        $htmlLi    = '';
        $htmlDiv   = '';
        while ($rr = $rh->fetch()) {
	        $locCtr++;

	        $class = '';
	        if ($locCtr == 1) {
		        $class = ' class="k-state-active" ';
	        }

	        $htmlLi .= '<li '.$class.'>'.$rr['loc_kode'].'</li>'.chr(13);
	        $htmlDiv .= '<div><font size="+1"><B>Daftar Lokasi Aset '.$rr['loc_label'].'</B></font><BR>'.$this->buildPlainGrid_lokasi($rr['loc_id']).'</div>'.chr(13);
        }

        $html .= $htmlLi.'</ul>'.chr(13);
        $html .= $htmlDiv.chr(13);

        $html .= '</div>'.chr(13);

	    return $html;
    }

    function buildPlainGrid_lokasi($idLocation = 0) {

	    $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

	    $SQLLoc = " select * from ref_aset_lokasi where loc_id = '".$idLocation."' ";
        $rhLoc  = $this->dbH->query($SQLLoc);
        $functDB->dberror_show($rhLoc);
        $rrLoc  = $rhLoc->fetch();

        $SQL  = " select * from (
	        		  select   ast_id as id,
	        				   ast_id,
	        				   ast_label,
	        				   ast_kode_bmn,
	                           case when ref_aset.ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
	                           astgrp_label,
	                           astgrp_kode,
	                           astgrp_desc,
	                           pngjwb_label,
	                           pngjwb_kode,
	                           pngjwb_telp,
	                           pngjwb_email,
	                           (select trxloc_id_lokasi_baru from trx_lokasi where trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1) as trxloc_id_lokasi_baru,
                               (select get_ip_aset(ast_id)) as infoip,
                               (select get_domain_aset(ast_id)) as infodomain
	                  from     ref_aset
	                  			left join ref_aset_grup on astgrp_id = ast_id_grupaset
	                  			left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
	              ) tmp, ref_aset_lokasi
	              where loc_id = trxloc_id_lokasi_baru and trxloc_id_lokasi_baru = '".$idLocation."'
	              order by ast_label
                  ";

        $sgkMod =& $this->loadModule('smartGridPlain');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Aset '.$rrLoc['loc_label'].' ('.$rrLoc['loc_kode'].')';

        $sgkMod->directive['grid_btnDetail'] = true;
        $sgkMod->directive['grid_btnDetail_useDefault'] = false;
        $sgkMod->directive['grid_btnDetail_jsfCustom'] = 'detailGrid';
        $sgkMod->directive['grid_btnEdit'] = false;
        $sgkMod->directive['grid_btnDelete'] = false;

        $sgkMod->directive['inw3x3_headleft'] = array('');
        $sgkMod->directive['inw3x3_headright'] = array('');
        $sgkMod->directive['inw3x3_footright'] = array('');

        $sgkMod->directive['grid_fields'] = array(
            'ast_label' => 'Nama Aset',
            'ast_kode_bmn' => 'No. BMN',
            'astgrp_label' => 'Jenis',
            'pngjwb_label' => 'Penanggung Jawab',
            'infoip' => 'IP Address',
            'infodomain' => 'Domain',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'ast_kode_bmn' => '100',
            'astgrp_label' => '100',
            'status_visible' => '100',
            'pngjwb_label' => '180',
            'infoip' => '120',
            'infodomain' => '150',
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
    
    function buildGridPerSatker() {

	    $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

	    $html  = '';

	    $html .= '<div id="tabstrip4">'.chr(13);
	    $html .= '<ul>'.chr(13);

	    $SQL = " select * from ref_satker where ref_stat_visible = 1 order by ref_satker_label ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);
        $locCtr    = 0;
        $htmlLi    = '';
        $htmlDiv   = '';
        while ($rr = $rh->fetch()) {
	        $locCtr++;

	        $class = '';
	        if ($locCtr == 1) {
		        $class = ' class="k-state-active" ';
	        }

	        $htmlLi .= '<li '.$class.'>'.$rr['ref_satker_kode'].'</li>'.chr(13);
	        $htmlDiv .= '<div><font size="+1"><B>'.$rr['ref_satker_label'].'</B></font><BR>'.$this->buildPlainGrid_satker($rr['ref_satker_id']).'</div>'.chr(13);
        }

        $html .= $htmlLi.'</ul>'.chr(13);
        $html .= $htmlDiv.chr(13);

        $html .= '</div>'.chr(13);

	    return $html;
    }
    
    function buildPlainGrid_satker($satker_id = 0) {

	    $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

	    $SQLLoc = " select * from ref_satker where ref_satker_id = '".$satker_id."' ";
        $rhLoc  = $this->dbH->query($SQLLoc);
        $functDB->dberror_show($rhLoc);
        $rrLoc  = $rhLoc->fetch();

        $SQL  = " select   ast_id as id,
        				   ast_id,
        				   ast_label,
        				   ast_kode_bmn,
                           case when ref_aset.ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                           astgrp_label,
                           astgrp_kode,
                           astgrp_desc,
                           pngjwb_label,
                           pngjwb_kode,
                           pngjwb_telp,
                           pngjwb_email,
                           (select loc_label from ref_aset_lokasi, trx_lokasi where loc_id = trxloc_id_lokasi_baru and trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1) as infolokasi,
                           (select get_ip_aset(ast_id)) as infoip,
                           (select get_domain_aset(ast_id)) as infodomain
                  from     ref_aset
                  			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                  			left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                  where    pngjwb_id_satker = '".$satker_id."'
                  order by ast_label

                  ";
        $sgkMod =& $this->loadModule('smartGridPlain');

        $sgkMod->directive['sql_sql'] = $SQL;

        $sgkMod->directive['grid_btnDetail'] = true;
        $sgkMod->directive['grid_btnDetail_useDefault'] = false;
        $sgkMod->directive['grid_btnDetail_jsfCustom'] = 'detailGrid';
        $sgkMod->directive['grid_btnEdit'] = false;
        $sgkMod->directive['grid_btnDelete'] = false;

        $sgkMod->directive['inw3x3_headleft'] = array('');
        $sgkMod->directive['inw3x3_headright'] = array('');
        $sgkMod->directive['inw3x3_footright'] = array('');

        $sgkMod->directive['grid_fields'] = array(
            'ast_label' => 'Nama Aset',
            'ast_kode_bmn' => 'No. BMN',
            'astgrp_label' => 'Jenis',
            'infolokasi' => 'Lokasi Terkini',
            'pngjwb_label' => 'Penanggung Jawab',
            'infoip' => 'IP Address',
            'infodomain' => 'Domain',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'ast_kode_bmn' => '100',
            'astgrp_label' => '100',
            'status_visible' => '100',
            'infolokasi' => '150',
            'infoip' => '125',
            'infodomain' => '150',
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
    
    function buildGridPerPenanggung() {

	    $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

	    $html  = '';

	    $html .= '<div id="tabstrip3">'.chr(13);
	    $html .= '<ul>'.chr(13);

	    $SQL = " select * from ref_penanggungjawab where ref_stat_visible = 1 order by pngjwb_label ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);
        $locCtr    = 0;
        $htmlLi    = '';
        $htmlDiv   = '';
        while ($rr = $rh->fetch()) {
	        $locCtr++;

	        $class = '';
	        if ($locCtr == 1) {
		        $class = ' class="k-state-active" ';
	        }

	        $htmlLi .= '<li '.$class.'>'.$rr['pngjwb_kode'].'</li>'.chr(13);
	        $htmlDiv .= '<div><font size="+1"><B>'.$rr['pngjwb_label'].'</B></font><BR>Telepon: '.$rr['pngjwb_telp'].', Email: '.$rr['pngjwb_email'].'<BR>'.$this->buildPlainGrid_pngjwb($rr['pngjwb_id']).'</div>'.chr(13);
        }

        $html .= $htmlLi.'</ul>'.chr(13);
        $html .= $htmlDiv.chr(13);

        $html .= '</div>'.chr(13);

	    return $html;
    }

    function buildPlainGrid_pngjwb($pngjwb_id = 0) {

	    $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

	    $SQLLoc = " select * from ref_penanggungjawab where pngjwb_id = '".$pngjwb_id."' ";
        $rhLoc  = $this->dbH->query($SQLLoc);
        $functDB->dberror_show($rhLoc);
        $rrLoc  = $rhLoc->fetch();

        $SQL  = " select   ast_id as id,
        				   ast_id,
        				   ast_label,
        				   ast_kode_bmn,
                           case when ref_aset.ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                           astgrp_label,
                           astgrp_kode,
                           astgrp_desc,
                           pngjwb_label,
                           pngjwb_kode,
                           pngjwb_telp,
                           pngjwb_email,
                           (select loc_label from ref_aset_lokasi, trx_lokasi where loc_id = trxloc_id_lokasi_baru and trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1) as infolokasi,
                           (select get_ip_aset(ast_id)) as infoip,
                           (select get_domain_aset(ast_id)) as infodomain
                  from     ref_aset
                  			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                  			left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                  where    ast_id_pngjawab = '".$pngjwb_id."'
                  order by ast_label

                  ";
        $sgkMod =& $this->loadModule('smartGridPlain');

        $sgkMod->directive['sql_sql'] = $SQL;

        $sgkMod->directive['grid_btnDetail'] = true;
        $sgkMod->directive['grid_btnDetail_useDefault'] = false;
        $sgkMod->directive['grid_btnDetail_jsfCustom'] = 'detailGrid';
        $sgkMod->directive['grid_btnEdit'] = false;
        $sgkMod->directive['grid_btnDelete'] = false;

        $sgkMod->directive['inw3x3_headleft'] = array('');
        $sgkMod->directive['inw3x3_headright'] = array('');
        $sgkMod->directive['inw3x3_footright'] = array('');

        $sgkMod->directive['grid_fields'] = array(
            'ast_label' => 'Nama Aset',
            'ast_kode_bmn' => 'No. BMN',
            'astgrp_label' => 'Jenis',
            'infolokasi' => 'Lokasi Terkini',
            'infoip' => 'IP Address',
            'infodomain' => 'Domain',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'ast_kode_bmn' => '100',
            'astgrp_label' => '100',
            'status_visible' => '100',
            'infolokasi' => '150',
            'infoip' => '125',
            'infodomain' => '150',
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
    
}


?>
