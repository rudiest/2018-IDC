<?php

class tblLokasi extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/tblLokasi');
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
        else {

            $functDB =& $this->loadModule('functionDB');

            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=r2_refAset&sType=viewServer','url_detailData');
            
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

        $SQL  = " select   trxloc_tanggal,
                           trxloc_waktu,
                           trxloc_alasan,
                           trxloc_oleh,

                           (select loc_label from ref_aset_lokasi where loc_id = trxloc_id_lokasi_sebelumnya) as loksebelum,
                           (select loc_label from ref_aset_lokasi where loc_id = trxloc_id_lokasi_baru) as loksesudah,

                           ast_id as id,
                           ast_label,
                           ast_kode_bmn,

                           astgrp_label,
                           astgrp_kode,
                           astgrp_desc

                  from     trx_lokasi
                  			left join ref_aset on trxloc_id_aset = ast_id
                  			left join ref_aset_grup on astgrp_id = ast_id_grupaset
                  order by trxloc_tanggal desc, trxloc_waktu desc
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Perpindahan Lokasi Seluruh Aset';
        $sgkMod->directive['sm_function'] = 'buildGrid';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

        $sgkMod->directive['sgk_reload_jsf'] = 'gridReload()';
        $sgkMod->directive['grid_btnDetail'] = true;
        $sgkMod->directive['grid_btnDetail_useDefault'] = false;
        $sgkMod->directive['grid_btnDetail_jsfCustom'] = 'detailGrid';
        $sgkMod->directive['grid_btnEdit'] = false;
        $sgkMod->directive['grid_btnDelete'] = false;

        $sgkMod->directive['wrapper_useDefault'] = false;

        $sgkMod->directive['inw3x3_headleft'] = array('');
        $sgkMod->directive['inw3x3_headright'] = array('search');
        $sgkMod->directive['inw3x3_footright'] = array('print','download');
        
        $sgkMod->directive['grid_isgroupable'] = false;
        $sgkMod->directive['grid_isselectable'] = true;
        $sgkMod->directive['grid_columnmenu'] = false;
        $sgkMod->directive['grid_isfilterable'] = false;
        $sgkMod->directive['grid_isresize'] = false;
        $sgkMod->directive['grid_isreorder'] = false;

        $sgkMod->directive['grid_fields'] = array(
        	'trxloc_tanggal' => 'Tanggal',
            'trxloc_waktu' => 'Waktu',
            'astgrp_label' => 'Jenis',
            'ast_label' => 'Nama Aset',
            'ast_kode_bmn' => 'Kode BMN',
            'loksesudah' => 'Pindah Ke',
            'trxloc_alasan' => 'Alasan',
            'trxloc_oleh' => 'Oleh',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'trxloc_tanggal' => '125',
            'trxloc_waktu' => '100',
            'astgrp_label' => '150',
            'ast_label' => '200',
            'ast_kode_bmn' => '150',
            'loksesudah' => '150',
            'trxloc_oleh' => '100',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			'trxloc_tanggal' => 'date',
        );

        $sgkMod->directive['grid_fields_format'] = array(
			'trxloc_tanggal' => 'date',
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }

}


?>
