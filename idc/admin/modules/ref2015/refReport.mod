<?php

class refReport extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refReport');
        
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
            
            // form entry
            $selopt_jenisAset = '<option value=""></option>';
            $SQL = " select * from ref_aset_grup where ref_stat_visible = 1 order by astgrp_label ";
            $rh  = $this->dbH->query($SQL);
            while ($rr = $rh->fetch()) {
                $selopt_jenisAset .= '<option value="'.$rr['astgrp_id'].'">'.$rr['astgrp_label'].'</option>';
            }
            $defTpt->addtext($selopt_jenisAset,'selopt_jenisAset');
            
            $selopt_penanggungJawab = '<option value=""></option>';
            $SQL = " select * from ref_penanggungjawab where ref_stat_visible = 1 order by pngjwb_label ";
            $rh  = $this->dbH->query($SQL);
            while ($rr = $rh->fetch()) {
                $selopt_penanggungJawab .= '<option value="'.$rr['pngjwb_id'].'">'.$rr['pngjwb_label'].'</option>';
            }
            $defTpt->addtext($selopt_penanggungJawab,'selopt_penanggungJawab');
            
            $selopt_lokasi = '<option value=""></option>';
            $SQL = " select * from ref_aset_lokasi where ref_stat_visible = 1 order by loc_label ";
            $rh  = $this->dbH->query($SQL);
            while ($rr = $rh->fetch()) {
                $selopt_lokasi .= '<option value="'.$rr['loc_id'].'">'.$rr['loc_label'].'</option>';
            }
            $defTpt->addtext($selopt_lokasi,'selopt_lokasi');
            
            $selopt_aset = '<option value=""></option>';
            $SQL = " select * from ref_aset where ref_stat_visible = 1 order by ast_label ";
            $rh  = $this->dbH->query($SQL);
            while ($rr = $rh->fetch()) {
                $selopt_aset .= '<option value="'.$rr['ast_id'].'">'.$rr['ast_label'].'</option>';
            }
            $defTpt->addtext($selopt_aset,'selopt_aset');
            
            $selopt_satker = '<option value=""></option>';
            $SQL = " select * from ref_satker where ref_stat_visible = 1 order by ref_satker_label ";
            $rh  = $this->dbH->query($SQL);
            while ($rr = $rh->fetch()) {
                $selopt_satker .= '<option value="'.$rr['ref_satker_id'].'">'.$rr['ref_satker_label'].'</option>';
            }
            $defTpt->addtext($selopt_satker,'selopt_satker');
            
            $selopt_zona = '<option value=""></option>';
            $SQL = " select * from ref_zona where ref_stat_visible = 1 order by jnszona_label ";
            $rh  = $this->dbH->query($SQL);
            while ($rr = $rh->fetch()) {
                $selopt_zona .= '<option value="'.$rr['jnszona_id'].'">'.$rr['jnszona_label'].'</option>';
            }
            $defTpt->addtext($selopt_zona,'selopt_zona');
            
            $selopt_pendamping = '<option value=""></option>';
            $SQL = " select * from ref_pendamping order by pdp_nama ";
            $rh  = $this->dbH->query($SQL);
            while ($rr = $rh->fetch()) {
                $selopt_pendamping .= '<option value="'.$rr['pdp_id'].'">'.$rr['pdp_nama'].'</option>';
            }
            $defTpt->addtext($selopt_pendamping,'selopt_pendamping');
            
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=asetPdf','url_formDaftarAsetPrint');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=asetExcel','url_formDaftarAsetExcel');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=asetSpek','url_formProfilAsetPrint');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=asetSpekExcel','url_formProfilAsetExcel');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=asetSpekExcel2','url_formSpekAsetExcel');
            
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=domainPdf','url_formProfilDomainPrint');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=domainExcel','url_formProfilDomainExcel');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=ipPdf','url_formProfilIPPrint');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=ipExcel','url_formProfilIPExcel');
            
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=guestbookPdf','url_formGBPrint');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=guestbookExcel','url_formGBExcel');
            
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=dashboardPdf','url_formDashboardPrint');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=dashboardExcel','url_formDashboardExcel');
            
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=formData','popUrl_modifyData');
            
            // $defTpt->addtext($this->buildGrid(),'sma_tabGrid');
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
    
}


?>
