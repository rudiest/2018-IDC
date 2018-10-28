<?php

class refCetak extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','popSingleForm');
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
        elseif ( $this->getVar('popMode') == 'dashboardPdf' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->dashboardPdf(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'reportDomainPrint' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->reportDomainPrint(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'reportDomainExcel' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->reportDomainExcel(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'asetPdf' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->formAsetPdf(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'asetExcel' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->formAsetExcel(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'detailSpekPdf' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->detailSpekPdf(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'asetSpek' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->asetSpekPdf(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'asetSpekExcel' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->formaAetSpekPdfExcel(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'asetSpekExcel2' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->formaAsetSpekExcel2(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'detailLokasiPdf' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->detailLokasiPdf(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'detailKejadianPdf' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->detailKejadianPdf(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'detailPerubahanPdf' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->detailPerubahanPdf(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'domainPdf' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->formDomainPdf(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'domainExcel' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->formDomainExcel(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'ipPdf' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->formIPPdf(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'ipExcel' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->formIPExcel(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'guestbookPdf' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->formGBPdf(),'popContent');
        }
        elseif ( $this->getVar('popMode') == 'guestbookExcel' ) {

            $defTpt =& $this->getResource('defPop');
            $defTpt->addText($this->formGBExcel(),'popContent');
        }
        else {

            $functDB =& $this->loadModule('functionDB');

            $defTpt->addtext($this->getDirective('screenwidth'),'sma_subScreenWidth');
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
    function dashboardPdf($tmp = '') {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $pdfTitle = "Inventaris Data Center";
        $pdfSubTitle = "Kementerian Komunikasi dan Informatika";

        require_once('./tcpdf/tcpdf.php');

        $pdf = new TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);

        // set document information
        $pdf->SetCreator('Inventaris Data Center');
        $pdf->SetAuthor('Kementerian Komunikasi dan Informatika');
        $pdf->SetTitle($pdfTitle);

        // set default header data
        $pdf->SetHeaderData('images/logo_kominfo.jpg', 10, $pdfTitle, $pdfSubTitle, array(0,64,255), array(0,64,128));
        $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

        // set margins
        //$pdf->SetMargins(PDF_MARGIN_LEFT, 25, PDF_MARGIN_RIGHT);
        $pdf->SetMargins(10, 25, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(10);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

        // set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        // set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

        $pdf->AddPage();

        $pdf->SetFont('helvetica', '', 8, '', true);

        $wSQL = '';
        $searchLabel = "";
        if ($_GET['fR'] == 1) {

            if (strlen(trim($_GET['fNama'])) > 0) {
                $wSQL .= " and (lower(domain_label) like '%".strtolower(trim($_GET['fNama']))."%') ";
                $searchLabel .= "Domain mengandung kata ".$_GET['fNama'].". ";
            }
            if (strlen(trim($_GET['fUntuk'])) > 0) {
                $wSQL .= " and (lower(domain_peruntukan) like '%".strtolower(trim($_GET['fUntuk']))."%') ";
                $searchLabel .= "Peruntukan mengandung kata ".$_GET['fNama'].". ";
            }
            if (strlen(trim($_GET['fIP'])) > 0) {
                $wSQL .= " and (lower(get_domain_ip(domain_id)) like '".strtolower(trim($_GET['fIP']))."%') ";
                $searchLabel .= "IP Address = ".$_GET['fIP'].". ";
            }
            if ($_GET['fPng'] > 0) {
                $wSQL .= " and (domain_tanggungjawab_id = '".$_GET['fPng']."') ";

                $SQLZona = " select * from ref_penanggungjawab where pngjwb_id = '".$_GET['fPng']."' ";
                $rhZona  = $this->dbH->query($SQLZona);
                $rrZona  = $rhZona->fetch();

                $searchLabel .= "Penanggung Jawab = ".$rrZona['pngjwb_label'].". ";
            }
            if ($_GET['fZona'] > 0) {
                $wSQL .= " and (domain_id_zona = '".$_GET['fZona']."') ";

                $SQLZona = " select * from ref_zona where jnszona_id = '".$_GET['fZona']."' ";
                $rhZona  = $this->dbH->query($SQLZona);
                $rrZona  = $rhZona->fetch();

                $searchLabel .= "Zona = ".$rrZona['jnszona_label'].". ";
            }
        }
        if (strlen(trim($wSQL))>0) {
            $wSQL = ' where 1 '.$wSQL;
            $searchLabel = 'Filter data : '.$searchLabel;
        }

        $html  = '';

        $html .= '<table width="100%" border="0" cellspacing="0" cellpadding="2">';
        $html .= '<tr>';
        $html .= ' <td width="100%" align="center" valign="top"><H2 style="padding:0px; margin:0px;" align="center">Dashboard IDC</H2></td>';
        $html .= '</tr>';
        $html .= '<tr>';
        $html .= ' <td width="100%" align="center" valign="top"><H3 style="padding:0px; margin:0px;" align="center">'.date('D, j F Y H:i').'</H3></td>';
        $html .= '</tr>';
        $html .= '</table>';

        $html .= '<BR><BR>';

        $html .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
        $html .= '<tr>';
        $html .= ' <td width="100%" align="left" valign="top"><H3 style="padding:0px; margin:0px;">Status NMS</H3></td>';
        $html .= '</tr>';
        $html .= '<tr>';
        $html .= ' <td width="5%" align="left" valign="top">No.</td>';
        $html .= ' <td width="15%" align="left" valign="top">Aset</td>';
        $html .= ' <td width="15%" align="left" valign="top">Service</td>';
        $html .= ' <td width="50%" align="left" valign="top">Notes</td>';
        $html .= ' <td width="15%" align="left" valign="top">Last Update</td>';
        $html .= '</tr>';

        $SQLnms =   "select distinct nms_tag, nms_svcname, nms_id_aset
                     from   trx_nms
                     order by nms_tag, nms_svcname
                     ";
        $rhNMS = $this->dbH->query($SQLnms);
        $functDB->dberror_show($rhNMS);
        $htm_nms = '';
        while ($rrNMS = $rhNMS->fetch()) {
            $SQLnms2 =  "select *,
                                date_format(nms_lastupdate, '%e %b %Y, %H:%i:%s') as lastupd
                         from   trx_nms left join ref_aset on ast_id = nms_id_aset
                         where  nms_tag = '".$rrNMS['nms_tag']."' and
                                nms_svcname = '".$rrNMS['nms_svcname']."'
                         order by nms_timestamp desc
                         limit 1
                         ";
            $rhNMS2 = $this->dbH->query($SQLnms2);
            $functDB->dberror_show($rhNMS2);
            $rrNMS2 = $rhNMS2->fetch();

            if ($rrNMS2['nms_flag'] == 2) {
                $nms_counter++;
                $svcLabel = '';
                if ($rrNMS2['nms_svcname'] == 'nms_default') {
                    $svcLabel = 'default';
                }
                else {
                    $svcLabel = $rrNMS2['nms_svcname'];
                }
                $html .= '<tr>';
                $html .= ' <td width="5%" align="left" valign="top">'.$nms_counter.'</td>';
                $html .= ' <td width="15%" align="left" valign="top">'.$rrNMS2['ast_label'].'</td>';
                $html .= ' <td width="15%" align="left" valign="top">'.$svcLabel.'</td>';
                $html .= ' <td width="50%" align="left" valign="top">'.$rrNMS2['nms_svcnote'].'</td>';
                $html .= ' <td width="15%" align="center" valign="top">'.$rrNMS2['lastupd'].'</td>';
                $html .= '</tr>';
            }
        }
        $html .= '</table>';

        $html .= '<BR><BR>';

        $html .= '<table width="100%" border="0" cellspacing="0" cellpadding="2">';

        // get jenis perangkat
        $arDtJnsPerangkat = array();
        $arDtJnsPerangkatLabel = array();
        $arDtJnsPerangkatTotal = 0;
        $SQL_pieChart = "select *
                           from (select   astgrp_label,
                                          (select count(*) from ref_aset where ast_id_grupaset = astgrp_id and ref_stat_visible = 1) as total_visible
                                 from     ref_aset_grup
                                 where    ref_stat_visible = 1
                                 ) tmp
                           order by total_visible desc, astgrp_label
                           ";
        $rh_pieChart = $this->dbH->query($SQL_pieChart);
        $rowCounter = 0;
        while ($rr_pieChart = $rh_pieChart->fetch()) {
            $arDtJnsPerangkat[$rowCounter] = $rr_pieChart['total_visible'];
            $arDtJnsPerangkatLabel[$rowCounter] = "%.0f%% : ".$rr_pieChart['astgrp_label']." (".$rr_pieChart['total_visible']." unit)";
            $arDtJnsPerangkatTotal += $rr_pieChart['total_visible'];
            $rowCounter++;
        }
        $titleJnsPerangkat = 'JENIS PERANGKAT IDC ('.number_format($arDtJnsPerangkatTotal).' UNIT)';

        $html .= '<tr>';
        $html .= ' <td width="100%" align="center" valign="top" colspan="2"><img border="1" src="'.$this->jpg_pie3d($arDtJnsPerangkat,$titleJnsPerangkat,$arDtJnsPerangkatLabel).'"></td>';
        $html .= '</tr>';

        // get zona domain
        $arDtJnsDomain = array();
        $arDtJnsDomainLabel = array();
        $arDtJnsDomainTotal = 0;

        $SQL_pieChart = "select *
                           from (select   jnszona_label,
                                          (select count(*) from ref_domain where domain_id_zona = jnszona_id and ref_stat_visible = 1) as total_visible
                                 from     ref_zona
                                 where    ref_stat_visible = 1
                                 ) tmp
                           order by total_visible desc, jnszona_label
                           ";
        $rh_pieChart = $this->dbH->query($SQL_pieChart);
        $rowCounter = 0;
        while ($rr_pieChart = $rh_pieChart->fetch()) {
            $arDtJnsDomain[$rowCounter] = $rr_pieChart['total_visible'];
            $arDtJnsDomainLabel[$rowCounter] = "%.0f%% : ".$rr_pieChart['jnszona_label']." (".$rr_pieChart['total_visible']." domain)";
            $arDtJnsDomainTotal += $rr_pieChart['total_visible'];
            $rowCounter++;
        }
        $titleJnsDomain = 'ZONA DOMAIN IDC ('.number_format($arDtJnsDomainTotal).' DOMAIN)';

        // get zona ip
        $arDtJnsIP = array();
        $arDtJnsIPLabel = array();
        $arDtJnsIPTotal = 0;

        $SQL_pieChart = "select status_ip, count(*) as total_visible from (
                          select distinct ip_number,
                                 case when
                                   (INET_ATON(ip_number) not BETWEEN INET_ATON('10.0.0.0') AND INET_ATON('10.255.255.255')) and
                                   (INET_ATON(ip_number) not BETWEEN INET_ATON('172.16.0.0') AND INET_ATON('172.31.255.255')) and
                                   (INET_ATON(ip_number) not BETWEEN INET_ATON('192.168.0.0') AND INET_ATON('192.168.255.255'))
                                 then 'PUBLIC IP'
                                 else 'PRIVATE IP'
                                 end as status_ip
                          from   ref_ip
                                    left join ref_aset_ipmap on ref_ip.ip_id = ref_aset_ipmap.map_id_ip
                                    left join ref_aset on ref_aset_ipmap.map_id_aset = ref_aset.ast_id
                                    left join ref_domain_ipmap on ref_ip.ip_id = ref_domain_ipmap.map_id_ip
                                    left join ref_domain on ref_domain_ipmap.map_id_domain = ref_domain.domain_id
                          where  ref_ip.ref_stat_visible = 1 and
                                 (ref_aset.ast_id is not null or ref_domain.domain_id is not null)
                         ) tmp
                         group by status_ip
                         order by total_visible
                         ";
        $rh_pieChart = $this->dbH->query($SQL_pieChart);
        $rowCounter = 0;
        while ($rr_pieChart = $rh_pieChart->fetch()) {
            $arDtJnsIP[$rowCounter] = $rr_pieChart['total_visible'];
            $arDtJnsIPLabel[$rowCounter] = "%.0f%% : ".$rr_pieChart['status_ip']." (".$rr_pieChart['total_visible']." IP)";
            $arDtJnsIPTotal += $rr_pieChart['total_visible'];
            $rowCounter++;
        }
        $titleJnsIP = 'IP ADDRESS IDC ('.number_format($arDtJnsIPTotal).' IPv4)';

        $html .= '<tr>';
        $html .= ' <td width="50%" align="center" valign="top"><img border="1" src="'.$this->jpg_pie3d($arDtJnsDomain,$titleJnsDomain,$arDtJnsDomainLabel,400,200).'"></td>';
        $html .= ' <td width="50%" align="center" valign="top"><img border="1" src="'.$this->jpg_pie3d($arDtJnsIP,$titleJnsIP,$arDtJnsIPLabel,400,200).'"></td>';
        $html .= '</tr>';
        $html .= '</table>';

        $htm_logPemakaianIDC = '';
        $htm_logSejarahKunjungan = '';
        $htm_logPeristiwa = '';

        $maxCountDay = 30;
        $x = 0;
        $dateToSearch = date('Y-m-d',strtotime('+'.$x.' day',strtotime('-'.($maxCountDay).' day',strtotime($startingDate))));
        $maxRecordCount = 15;

        $htm_logPemakaianIDC .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
        $htm_logPemakaianIDC .= '<tr>';
        $htm_logPemakaianIDC .= ' <td width="100%" align="left" valign="top" colspan="2"><H3 style="padding:0px; margin:0px;">Pemakaian IDC<BR>('.$maxRecordCount.' data terakhir)</H3></td>';
        $htm_logPemakaianIDC .= '</tr>';
        $htm_logPemakaianIDC .= '<tr>';
        $htm_logPemakaianIDC .= ' <td width="10%" align="left" valign="top">No.</td>';
        $htm_logPemakaianIDC .= ' <td width="90%" align="left" valign="top">Keterangan</td>';
        $htm_logPemakaianIDC .= '</tr>';

        $t_counter = 0;
        $SQL_log1 = "select *,
                            date_format(act_time, '%e %b %Y, %H:%i:%s') as waktu,
                            timestampdiff(day,act_time,now()) as diffday,
                            timestampdiff(hour,act_time,now()) as diffhour,
                            timestampdiff(minute,act_time,now()) as diffmin,
                            timestampdiff(second,act_time,now()) as diffsec
                     from   log_activity
                              left join members on idxNum = act_id_user
                     where  act_table <> 'log_perubahan' and
                            act_time >= '".$dateToSearch."'
                     order by act_time desc
                     limit ".$maxRecordCount."
                     ";
        $rh_log1 = $this->dbH->query($SQL_log1);
        while ($rr_log1 = $rh_log1->fetch()) {
            $t_counter++;

            $bgColor = '';
            if (($t_counter % 2) == 1) {
                $bgColor = ' style="background-color: #FAFAFA;" ';
            }
            $badgeLabel = 'UNKNOWN';
            $badgeColour = 'default';
            if (trim($rr_log1['act_type']) == 'DBINSERT') {
                $badgeLabel = 'DB INSERT';
                $badgeColour = 'success';
            }
            elseif (trim($rr_log1['act_type']) == 'DBUPDATE') {
                $badgeLabel = 'DB UPDATE';
                $badgeColour = 'warning';
            }
            elseif (trim($rr_log1['act_type']) == 'DBDELETE') {
                $badgeLabel = 'DB DELETE';
                $badgeColour = 'danger';
            }

            $badgeTime = '';
            if ($rr_log1['diffday'] > 0) {
                $t_val1 = $rr_log1['diffday'] * 24;
                $t_val2 = $rr_log1['diffhour'] - $t_val1;
                if ($t_val2 > 0) {
                    $badgeTime = '- '.$rr_log1['diffday'].' hari '.$t_val2.' jam';
                }
                else {
                    $badgeTime = '- '.$rr_log1['diffday'].' hari';
                }
            }
            elseif ($rr_log1['diffhour'] > 0) {
                $t_val1 = $rr_log1['diffhour'] * 60;
                $t_val2 = $rr_log1['diffmin'] - $t_val1;
                if ($t_val2 > 0) {
                    $badgeTime = '- '.$rr_log1['diffhour'].' jam '.$t_val2.' menit';
                }
                else {
                    $badgeTime = '- '.$rr_log1['diffhour'].' jam';
                }
            }
            elseif ($rr_log1['diffmin'] > 0) {
                $t_val1 = $rr_log1['diffmin'] * 60;
                $t_val2 = $rr_log1['diffsec'] - $t_val1;
                if ($t_val2 > 0) {
                    $badgeTime = '- '.$rr_log1['diffmin'].' menit '.$t_val2.' detik';
                }
                else {
                    $badgeTime = '- '.$rr_log1['diffmin'].' menit';
                }
            }
            elseif ($rr_log1['diffsec'] > 0) {
                $badgeTime = '- '.$rr_log1['diffsec'].' detik';
            }

            $actInfo = '';
            switch ($rr_log1['act_table']) {

                case 'members' : $actInfo = 'Data <b>PENGGUNA SISTEM</b>'; break;
                case 'ref_aset' : $actInfo = 'Data <b>ASET</b>'; break;
                case 'ref_aset_grup' : $actInfo = 'Data <b>REFERENSI GRUP ASET</b>'; break;
                case 'ref_aset_grup_spek' : $actInfo = 'Data <b>REFERENSI GRUP SPESIFIKASI ASET</b>'; break;
                case 'ref_aset_lokasi' : $actInfo = 'Data <b>REFERENSI LOKASI ASET</b>'; break;
                case 'ref_aset_spesifikasi' : $actInfo = 'Data <b>REFERENSI ASET</b>'; break;
                case 'ref_domain' : $actInfo = 'Data <b>DOMAIN</b>'; break;
                case 'ref_global' : $actInfo = 'Data <b>REFERENSI URL</b>'; break;
                case 'ref_penanggungjawab' : $actInfo = 'Data <b>PENANGGUNG JAWAB</b>'; break;
                case 'trx_kejadian' : $actInfo = 'Data <b>PERISTIWA ASET</b>'; break;
                case 'trx_lokasi' : $actInfo = 'Data <b>LOKASI ASET</b>'; break;
                case 'trx_spesifikasi' : $actInfo = 'Data <b>SPESIFIKASI ASET</b>'; break;
                case 'trx_nms' : $actInfo = 'Data <b>NMS</b>'; break;

                default : $actInfo = 'Data <b>UNIDENTIFIED <i>'.$rr_log1['act_table'].'</i></b>'; break;
            }

            $htm_logPemakaianIDC .= '<tr>';
            $htm_logPemakaianIDC .= ' <td width="10%" align="left" valign="top">'.$t_counter.'</td>';
            $htm_logPemakaianIDC .= ' <td width="90%" align="left" valign="top"><B>'.$badgeLabel.' ('.$badgeTime.')</B><BR>'.$rr_log1['waktu'].'<BR><B>User: '.ucwords(strtolower($rr_log1['firstName'].' '.$rr_log1['lastName'])).'</B><BR>Info: '.$actInfo.'</td>';
            $htm_logPemakaianIDC .= '</tr>';
        }

        $htm_logPemakaianIDC .= '</table>';


        $htm_logSejarahKunjungan .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
        $htm_logSejarahKunjungan .= '<tr>';
        $htm_logSejarahKunjungan .= ' <td width="100%" align="left" valign="top" colspan="2"><H3 style="padding:0px; margin:0px;">Tamu IDC<BR>('.$maxRecordCount.' data terakhir)</H3></td>';
        $htm_logSejarahKunjungan .= '</tr>';
        $htm_logSejarahKunjungan .= '<tr>';
        $htm_logSejarahKunjungan .= ' <td width="10%" align="left" valign="top">No.</td>';
        $htm_logSejarahKunjungan .= ' <td width="90%" align="left" valign="top">Pengunjung</td>';
        $htm_logSejarahKunjungan .= '</tr>';

        $t_counter = 0;
        $SQL_log2 = "select *,
                            date_format(stat_inp_time, '%e %b %Y, %H:%i:%s') as waktu,
                            timestampdiff(day,stat_inp_time,now()) as diffday,
                            timestampdiff(hour,stat_inp_time,now()) as diffhour,
                            timestampdiff(minute,stat_inp_time,now()) as diffmin,
                            timestampdiff(second,stat_inp_time,now()) as diffsec
                     from   trx_guestbook
                     where  stat_inp_time >= '".$dateToSearch."'
                     order by stat_inp_time desc
                     limit ".$maxRecordCount."
                     ";
        $rh_log2 = $this->dbHL['guestbook']->query($SQL_log2);
        while ($rr_log2 = $rh_log2->fetch()) {
            $t_counter++;

            $bgColor = '';
            if (($t_counter % 2) == 1) {
                $bgColor = ' style="background-color: #FAFAFA;" ';
            }

            $badgeLabel = 'CHECKIN';
            $badgeColour = 'warning';
            if (trim($rr_log2['gb_checkout_is']) == '1') {
                $badgeLabel = 'CHECKOUT';
                $badgeColour = 'success';
            }

            $badgeTime = '';
            if ($rr_log2['diffday'] > 0) {
                $t_val1 = $rr_log2['diffday'] * 24;
                $t_val2 = $rr_log2['diffhour'] - $t_val1;
                if ($t_val2 > 0) {
                    $badgeTime = '- '.$rr_log2['diffday'].' hari '.$t_val2.' jam';
                }
                else {
                    $badgeTime = '- '.$rr_log2['diffday'].' hari';
                }
            }
            elseif ($rr_log2['diffhour'] > 0) {
                $t_val1 = $rr_log2['diffhour'] * 60;
                $t_val2 = $rr_log2['diffmin'] - $t_val1;
                if ($t_val2 > 0) {
                    $badgeTime = '- '.$rr_log2['diffhour'].' jam '.$t_val2.' menit';
                }
                else {
                    $badgeTime = '- '.$rr_log2['diffhour'].' jam';
                }
            }
            elseif ($rr_log2['diffmin'] > 0) {
                $t_val1 = $rr_log2['diffmin'] * 60;
                $t_val2 = $rr_log2['diffsec'] - $t_val1;
                if ($t_val2 > 0) {
                    $badgeTime = '- '.$rr_log2['diffmin'].' menit '.$t_val2.' detik';
                }
                else {
                    $badgeTime = '- '.$rr_log2['diffmin'].' menit';
                }
            }
            elseif ($rr_log2['diffsec'] > 0) {
                $badgeTime = '- '.$rr_log2['diffsec'].' detik';
            }

            $htm_logSejarahKunjungan .= '<tr>';
            $htm_logSejarahKunjungan .= ' <td width="10%" align="left" valign="top">'.$t_counter.'</td>';
            $htm_logSejarahKunjungan .= ' <td width="90%" align="left" valign="top"><B>'.$badgeLabel.' ('.$badgeTime.')</B><BR>'.$rr_log2['waktu'].'<BR><B>Instansi: '.ucwords(strtolower($rr_log2['gb_instansi'])).'</B><BR>Nama: '.ucwords(strtolower($rr_log2['gb_nama'])).'<BR>Tujuan: '.$rr_log2['gb_tujuan'].'<BR>Pendamping: '.$rr_log2['gb_pendamping'].'</td>';
            $htm_logSejarahKunjungan .= '</tr>';
        }

        $htm_logSejarahKunjungan .= '</table>';

        $htm_logPeristiwa .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
        $htm_logPeristiwa .= '<tr>';
        $htm_logPeristiwa .= ' <td width="100%" align="left" valign="top" colspan="2"><H3 style="padding:0px; margin:0px;">Peristiwa<BR>('.$maxRecordCount.' data terakhir)</H3></td>';
        $htm_logPeristiwa .= '</tr>';
        $htm_logPeristiwa .= '<tr>';
        $htm_logPeristiwa .= ' <td width="10%" align="left" valign="top">No.</td>';
        $htm_logPeristiwa .= ' <td width="90%" align="left" valign="top">Peristiwa</td>';
        $htm_logPeristiwa .= '</tr>';

        $t_counter = 0;
        $SQL_log3 = "select * from
                     (   select 'trx_kejadian' as id_table,
                                trxkej_id as id_rec,
                                date_format(trxkej_tanggal, '%e %b %Y') as tanggal,
                                date_format(trxkej_waktu, '%H:%i:%s') as waktu,
                                timestamp(trxkej_tanggal,trxkej_waktu) as tanggalwaktu,
                                timestampdiff(day,timestamp(trxkej_tanggal,trxkej_waktu),now()) as diffday,
                                timestampdiff(hour,timestamp(trxkej_tanggal,trxkej_waktu),now()) as diffhour,
                                timestampdiff(minute,timestamp(trxkej_tanggal,trxkej_waktu),now()) as diffmin,
                                timestampdiff(second,timestamp(trxkej_tanggal,trxkej_waktu),now()) as diffsec,
                                trxkej_oleh as oleh,
                                concat(
                                    '<B>Jenis Peristiwa: </B>',
                                    coalesce((select jnskej_label from ref_kejadian_jenis where jnskej_id = trxkej_id_kej),''),
                                    '. <B>Aset: </B>',
                                    coalesce((select ast_label from ref_aset where ast_id = trxkej_id_aset),''),
                                    '. <B>Catatan: </B>',
                                    coalesce(trxkej_keterangan,'')
                                ) as story
                         from   trx_kejadian
                         where  trxkej_tanggal >= '".$dateToSearch."'

                         union all

                         select  'trx_lokasi' as id_table,
                                trxloc_id as id_rec,
                                date_format(trxloc_tanggal, '%e %b %Y') as tanggal,
                                date_format(trxloc_waktu, '%H:%i:%s') as waktu,
                                timestamp(trxloc_tanggal,trxloc_waktu) as tanggalwaktu,
                                timestampdiff(day,timestamp(trxloc_tanggal,trxloc_waktu),now()) as diffday,
                                timestampdiff(hour,timestamp(trxloc_tanggal,trxloc_waktu),now()) as diffhour,
                                timestampdiff(minute,timestamp(trxloc_tanggal,trxloc_waktu),now()) as diffmin,
                                timestampdiff(second,timestamp(trxloc_tanggal,trxloc_waktu),now()) as diffsec,
                                trxloc_oleh as oleh,
                                concat(
                                    'Aset <B>',
                                    coalesce((select ast_label from ref_aset where ast_id = trxloc_id_aset),''),
                                    '</B> dipindahkan dari <B>',
                                    coalesce((select jnsloc_label from ref_lokasi_jenis where jnsloc_id = trxloc_id_lokasi_sebelumnya),''),
                                    '</B> ke lokasi baru <B>',
                                    coalesce((select jnsloc_label from ref_lokasi_jenis where jnsloc_id = trxloc_id_lokasi_baru),''),
                                    '</B> dengan alasan <B>',
                                    coalesce(trxloc_alasan,''),
                                    '</B>'
                                ) as story
                         from   trx_lokasi
                         where  trxloc_tanggal >= '".$dateToSearch."'

                         union all

                         select 'trx_spesifikasi' as id_table,
                                trxspec_id as id_rec,
                                date_format(trxspec_tanggal, '%e %b %Y') as tanggal,
                                date_format(trxspec_waktu, '%H:%i:%s') as waktu,
                                timestamp(trxspec_tanggal,trxspec_waktu) as tanggalwaktu,
                                timestampdiff(day,timestamp(trxspec_tanggal,trxspec_waktu),now()) as diffday,
                                timestampdiff(hour,timestamp(trxspec_tanggal,trxspec_waktu),now()) as diffhour,
                                timestampdiff(minute,timestamp(trxspec_tanggal,trxspec_waktu),now()) as diffmin,
                                timestampdiff(second,timestamp(trxspec_tanggal,trxspec_waktu),now()) as diffsec,
                                trxspec_oleh as oleh,
                                concat(
                                    'Perubahan Aset: <B>',
                                    coalesce((select ast_label from ref_aset where ast_id = trxspec_id_aset),''),
                                    '</B> '
                                    'untuk spesifikasi: <B>',
                                    coalesce((select astgrpspek_label from ref_aset_grup_spek where astgrpspek_id = trxspec_id_spec),''),
                                    '</B> dari sebelumnya <B>',
                                    coalesce(trxspec_angka_sebelumnya,trxspec_nonangka_sebelumnya,''),
                                    '</B> menjadi <B>',
                                    coalesce(trxspec_angka_perubahan,trxspec_nonangka_perubahan,''),
                                    '</B> dengan catatan: ',
                                    coalesce(trxspec_catatan,'')
                                ) as story
                         from   trx_spesifikasi
                         where  trxspec_tanggal >= '".$dateToSearch."'
                         ) tunion
                     order by tanggalwaktu desc
                     limit ".$maxRecordCount."
                     ";
        $rh_log3 = $this->dbH->query($SQL_log3);
        while ($rr_log3 = $rh_log3->fetch()) {
            $t_counter++;

            $bgColor = '';
            if (($t_counter % 2) == 1) {
                $bgColor = ' style="background-color: #FAFAFA;" ';
            }

            $badgeLabel = 'UNKNOWN';
            $badgeColour = 'default';
            if ($rr_log3['id_table'] == 'trx_kejadian') {
                $badgeLabel = 'PERISTIWA';
                $badgeColour = 'danger';
            }
            elseif ($rr_log3['id_table'] == 'trx_lokasi') {
                $badgeLabel = 'PEMINDAHAN';
                $badgeColour = 'warning';
            }
            elseif ($rr_log3['id_table'] == 'trx_spesifikasi') {
                $badgeLabel = 'PERUBAHAN';
                $badgeColour = 'info';
            }
            else {
                $badgeLabel = 'UNKNOWN';
                $badgeColour = 'primary';
            }

            $badgeTime = '';
            if ($rr_log3['diffday'] > 0) {
                $t_val1 = $rr_log3['diffday'] * 24;
                $t_val2 = $rr_log3['diffhour'] - $t_val1;
                if ($t_val2 > 0) {
                    $badgeTime = '- '.$rr_log3['diffday'].' hari '.$t_val2.' jam';
                }
                else {
                    $badgeTime = '- '.$rr_log3['diffday'].' hari';
                }
            }
            elseif ($rr_log3['diffhour'] > 0) {
                $t_val1 = $rr_log3['diffhour'] * 60;
                $t_val2 = $rr_log3['diffmin'] - $t_val1;
                if ($t_val2 > 0) {
                    $badgeTime = '- '.$rr_log3['diffhour'].' jam '.$t_val2.' menit';
                }
                else {
                    $badgeTime = '- '.$rr_log3['diffhour'].' jam';
                }
            }
            elseif ($rr_log3['diffmin'] > 0) {
                $t_val1 = $rr_log3['diffmin'] * 60;
                $t_val2 = $rr_log3['diffsec'] - $t_val1;
                if ($t_val2 > 0) {
                    $badgeTime = '- '.$rr_log3['diffmin'].' menit '.$t_val2.' detik';
                }
                else {
                    $badgeTime = '- '.$rr_log3['diffmin'].' menit';
                }
            }
            elseif ($rr_log3['diffsec'] > 0) {
                $badgeTime = '- '.$rr_log3['diffsec'].' detik';
            }

            $htm_logPeristiwa .= '<tr>';
            $htm_logPeristiwa .= ' <td width="10%" align="left" valign="top">'.$t_counter.'</td>';
            $htm_logPeristiwa .= ' <td width="90%" align="left" valign="top"><B>'.$badgeLabel.' ('.$badgeTime.')</B><BR>'.$rr_log3['tanggal'].' '.$rr_log3['waktu'].'<BR><B>Oleh: '.ucwords(strtolower($rr_log3['oleh'])).'</B><BR>'.$rr_log3['story'].'</td>';
            $htm_logPeristiwa .= '</tr>';

        }
        $htm_logPeristiwa .= '</table>';

        $html .= '<table width="100%" border="0" cellspacing="0" cellpadding="2">';
        $html .= '<tr>';
        $html .= ' <td width="32%" align="left" valign="top">'.$htm_logPemakaianIDC.'</td>';
        $html .= ' <td width="2%" align="left" valign="top">&nbsp;</td>';
        $html .= ' <td width="32%" align="left" valign="top">'.$htm_logSejarahKunjungan.'</td>';
        $html .= ' <td width="2%" align="left" valign="top">&nbsp;</td>';
        $html .= ' <td width="32%" align="left" valign="top">'.$htm_logPeristiwa.'</td>';
        $html .= '</tr>';
        $html .= '</table>';

        $filename = 'rep_dashboard_'.date('dmy_His').'.pdf';
        $fullfilename = './tmpPdf/'.$filename;

        $html .= '<BR><BR>'.$filename.' dicetak oleh '.$member['userName'].' pada '.date('d M Y H:i:s');

        $pdf->writeHTML($html);

        $pdf->Output($fullfilename, 'F');
        $pdf->Output($fullfilename, 'I');
        die();

    }

    function jpg_pie3d($arraydata, $title='', $arraylabel = null, $width = 800, $height = 350) {

        $fileName = './tmpPdf/chart_dash_'.rand(100,999).'_'.date('dmy_His').'.png';

        require_once ('./jpgraph4/jpgraph.php');
        require_once ('./jpgraph4/jpgraph_pie.php');
        require_once ('./jpgraph4/jpgraph_pie3d.php');

        // Some data
        if (!(is_array($arraydata))) {
            $arraydata = array(0);
        }

        // Create the Pie Graph.
        $graph = new PieGraph($width,$height);
        $graph->SetImgFormat('png');

        $theme_class= new VividTheme;
        $graph->SetTheme($theme_class);

        // Set A title for the plot
        $graph->title->SetFont(FF_FONT2 ,FS_BOLD);
        $graph->title->Set($title);

        // Create
        $p1 = new PiePlot3D($arraydata);
        $graph->Add($p1);

        $p1->ShowBorder();
        $p1->SetColor('black');
        $p1->SetCenter(0.3,0.525);
        $p1->SetSize(0.5);

        if (is_array($arraylabel)) {
            $p1->SetLegends($arraylabel);
            $graph->legend->SetPos(0.01,0.15,'right','top');
            $graph->legend->SetColumns(1);
        }

        $graph->Stroke($fileName);

        return $fileName;
    }


    function formAsetPdf($tmp = '') {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $pdfTitle = "Inventaris Data Center";
        $pdfSubTitle = "Kementerian Komunikasi dan Informatika";

        require_once('./tcpdf/tcpdf.php');

        $pdf = new TCPDF('L', 'mm', 'A4', true, 'UTF-8', false);

        // set document information
        $pdf->SetCreator('Inventaris Data Center');
        $pdf->SetAuthor('Kementerian Komunikasi dan Informatika');
        $pdf->SetTitle($pdfTitle);

        // set default header data
        $pdf->SetHeaderData('images/logo_kominfo.jpg', 10, $pdfTitle, $pdfSubTitle, array(0,64,255), array(0,64,128));
        $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

        // set margins
        //$pdf->SetMargins(PDF_MARGIN_LEFT, 25, PDF_MARGIN_RIGHT);
        $pdf->SetMargins(10, 25, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(10);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

        // set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        // set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

        $pdf->AddPage();

        $pdf->SetFont('helvetica', '', 8, '', true);

        $html  = '';

        $html .= '<H2 align="center">DAFTAR ASET</H2>';

        $html .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
        $html .= '<tr>';
        $html .= ' <td width="3%" align="center" valign="top">No.</td>';
        $html .= ' <td width="15%" align="center" valign="top">Nama Aset</td>';
        $html .= ' <td width="8%" align="center" valign="top">No. BMN</td>';
        $html .= ' <td width="10%" align="center" valign="top">Jenis</td>';
        $html .= ' <td width="13%" align="center" valign="top">Lokasi<BR>Terkini</td>';
        $html .= ' <td width="13%" align="center" valign="top">Satuan Kerja</td>';
        $html .= ' <td width="13%" align="center" valign="top">Penanggung Jawab</td>';
        $html .= ' <td width="10%" align="center" valign="top">IP Address</td>';
        $html .= ' <td width="15%" align="center" valign="top">Domain</td>';
        $html .= '</tr>';

        $wSQL = "";
        $searchLabel = "";
        if (strlen(trim($this->getVar('rNum4'))) > 0) {

            $searchLabel = "Pembatasan data dengan kata kunci <b>".$this->getVar('rNum4')."</b>.";

            $wSQL .= " (lower(ast_label) like '%".strtolower($this->getVar('rNum4'))."%') or ";
            $wSQL .= " (lower(ast_kode_bmn) like '%".strtolower($this->getVar('rNum4'))."%') or ";
            $wSQL .= " (lower(astgrp_label) like '%".strtolower($this->getVar('rNum4'))."%') or ";
            $wSQL .= " (lower(pngjwb_label) like '%".strtolower($this->getVar('rNum4'))."%') or ";
            $wSQL .= " (lower((select loc_label from ref_aset_lokasi, trx_lokasi where loc_id = trxloc_id_lokasi_baru and trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1)) like '%".strtolower($this->getVar('rNum4'))."%') or ";
            $wSQL .= " (lower((select get_ip_aset(ast_id))) like '%".strtolower($this->getVar('rNum4'))."%') or ";
            $wSQL .= " (lower((select get_domain_aset(ast_id))) like '%".strtolower($this->getVar('rNum4'))."%') ";

            if ($this->getVar('rNum4') > 0) {
                $wSQL .= " or (ast_id = '".($this->getVar('rNum4') * 1)."') ";
            }

            if (strtolower($this->getVar('rNum4')) == 'tampil') {
                $wSQL .= " or (ref_aset.ref_stat_visible = 1) ";
            }

            if (strtolower($this->getVar('rNum4')) == 'disembunyikan') {
                $wSQL .= " or (ref_aset.ref_stat_visible <> 1) ";
            }
        }
        elseif ($_GET['fR']==1) {
            $wSQL .= " 1 ";
            if (strlen(trim($_GET['fLabel']))>0) {
                $searchLabel .= "Nama / BMN = ".$_GET['fLabel'].". ";
                $t_label = explode(',',$_GET['fLabel']);
                if (count($t_label) > 1) {
                    reset($t_label);
                    $t_wsql = '';
                    while (list($key, $val) = each($t_label)) {
                        $t_wsql .= " (lower(ast_label) like '%".strtolower(trim($val))."%') or ";
                        $t_wsql .= " (lower(ast_kode_bmn) like '%".strtolower(trim($val))."%') or ";
                    }
                    $t_wsql .= " false ";
                    $wSQL .= " and (".$t_wsql.") ";
                }
                else {
                    $t_wsql  = '';
                    $t_wsql .= " (lower(ast_label) like '%".strtolower(trim($_GET['fLabel']))."%') or ";
                    $t_wsql .= " (lower(ast_kode_bmn) like '%".strtolower(trim($_GET['fLabel']))."%') ";
                    $wSQL .= " and (".$t_wsql.") ";
                }
            }
            if (strlen(trim($_GET['fIP']))>0) {
                $searchLabel .= "IP / Domain = ".$_GET['fIP'].". ";
                $t_label = explode(',',$_GET['fIP']);
                if (count($t_label) > 1) {
                    reset($t_label);
                    $t_wsql = '';
                    while (list($key, $val) = each($t_label)) {
                        $t_wsql .= " (lower((select get_ip_aset(ast_id))) like '".strtolower(trim($val))."%') or ";
                        $t_wsql .= " (lower((select get_domain_aset(ast_id))) like '%".strtolower(trim($val))."%') or ";
                    }
                    $t_wsql .= " false ";
                    $wSQL .= " and (".$t_wsql.") ";
                }
                else {
                    $t_wsql  = '';
                    $t_wsql .= " (lower((select get_ip_aset(ast_id))) like '".strtolower(trim($_GET['fIP']))."%') or ";
                    $t_wsql .= " (lower((select get_domain_aset(ast_id))) like '%".strtolower(trim($_GET['fIP']))."%') ";
                    $wSQL .= " and (".$t_wsql.") ";
                }
            }
            if ($_GET['fJenis'] > 0) {

                $SQLCekInput = "select * from ref_aset_grup where astgrp_id = '".$_GET['fJenis']."' ";
                $rhCekInput = $this->dbH->query($SQLCekInput);
                $rrCekInput = $rhCekInput->fetch();

                $searchLabel .= "Jenis = ".$rrCekInput['astgrp_label'].". ";
                $wSQL .= " and (ast_id_grupaset = '".$_GET['fJenis']."') ";
            }
            if ($_GET['fPng'] > 0) {

                $SQLCekInput = "select * from ref_penanggungjawab where pngjwb_id = '".$_GET['fPng']."' ";
                $rhCekInput = $this->dbH->query($SQLCekInput);
                $rrCekInput = $rhCekInput->fetch();

                $searchLabel .= "Penanggung Jawab = ".$rrCekInput['pngjwb_label'].". ";
                $wSQL .= " and (ast_id_pngjawab = '".$_GET['pngjwb_id']."') ";
            }
            if ($_GET['fSatker'] > 0) {

                $SQLCekInput = "select * from ref_satker where ref_satker_id = '".$_GET['fSatker']."' ";
                $rhCekInput = $this->dbH->query($SQLCekInput);
                $rrCekInput = $rhCekInput->fetch();

                $searchLabel .= "Satuan Kerja = ".$rrCekInput['ref_satker_label'].". ";
                $wSQL .= " and (ref_satker_id = '".$_GET['fSatker']."') ";
            }
            if ($_GET['fLokasi'] > 0) {

                $SQLCekInput = "select * from ref_aset_lokasi where loc_id = '".$_GET['fLokasi']."' ";
                $rhCekInput = $this->dbH->query($SQLCekInput);
                $rrCekInput = $rhCekInput->fetch();

                $searchLabel .= "Lokasi = ".$rrCekInput['loc_label'].". ";
                $wSQL .= " and (lower((select loc_label from ref_aset_lokasi, trx_lokasi where loc_id = trxloc_id_lokasi_baru and trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1)) = '".strtolower($rrCekInput['loc_label'])."') ";
            }

            if (strlen(trim($searchLabel))>0) {
                $searchLabel = 'Filter Data: '.$searchLabel;
            }
        }


        if (strlen(trim($wSQL))>0) {
            $wSQL = ' where '.$wSQL;
        }

        $SQL2 = " select   ref_aset.*,
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
                           ref_satker_kode,
                           (select loc_label from ref_aset_lokasi, trx_lokasi where loc_id = trxloc_id_lokasi_baru and trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1) as infolokasi,
                           (select get_ip_aset(ast_id)) as infoip,
                           (select get_domain_aset(ast_id)) as infodomain
                  from     ref_aset
                            left join ref_aset_grup on astgrp_id = ast_id_grupaset
                            left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                            left join ref_satker on ref_satker_id = pngjwb_id_satker
                              ".$wSQL."
                  order by ast_id
                  ";
        $rh2 = $this->dbH->query($SQL2);
        $functDB->dberror_show($rh2);
        while ($rr2 = $rh2->fetch()) {

            $rowCounter++;
            $html .= '<tr>';
            $html .= ' <td align="center" valign="top">'.($rowCounter).'.&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['ast_label']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['ast_kode_bmn']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['astgrp_label']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['infolokasi']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['ref_satker_label']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['pngjwb_label']).'<BR>'.$rr2['pngjwb_email'].'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.str_replace(', ','<br>',trim($rr2['infoip'])).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.str_replace(', ','<br>',trim($rr2['infodomain'])).'&nbsp;</td>';
            $html .= '</tr>';
        }

        $html .= '</table>';

        $html .= '<br>'.$searchLabel.'<br>'.number_format($rowCounter).' data tersaji.';

        $filename = 'rep_aset_'.date('dmy_His').'.pdf';
        $fullfilename = './tmpPdf/'.$filename;

        $html .= '<BR><BR>'.$filename.' dicetak oleh '.$member['userName'].' pada '.date('d M Y H:i:s');

        $pdf->writeHTML($html);

        $pdf->Output($fullfilename, 'F');
        $pdf->Output($fullfilename, 'I');
        die();

    }

    function formAsetExcel() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        ob_end_clean();

        require_once('./excelClass/Worksheet.php');
        require_once('./excelClass/Workbook.php');

        $member =  $this->sessionH->getMemberData();
        $filename = 'excel_aset_'.date('dmyhis').'.xls';

        header("Content-type: application/vnd.ms-excel");
        header("Content-Disposition: attachment; filename=".$filename );
        header("Expires: 0");
        header("Cache-Control: must-revalidate, post-check=0,pre-check=0");
        header("Pragma: public");

        // Creating a workbook
        $workbook = new Workbook("-");

        // Creating the first worksheet
        $worksheet1 =& $workbook->add_worksheet('Aset');

        $formatHD =& $workbook->add_format();
        $formatHD->set_size(14);
        $formatHD->set_bold(1);
        $formatHD->set_align('left');
        $formatHD->set_color('black');

        $formatHD1 =& $workbook->add_format();
        $formatHD1->set_size(12);
        $formatHD1->set_bold(1);
        $formatHD1->set_align('left');
        $formatHD1->set_color('black');

        $formatHD2 =& $workbook->add_format();
        $formatHD2->set_size(10);
        $formatHD2->set_bold(1);
        $formatHD2->set_align('left');
        $formatHD2->set_color('black');

        $formatRHD =& $workbook->add_format();
        $formatRHD->set_size(10);
        $formatRHD->set_bold(1);
        $formatRHD->set_align('left');
        $formatRHD->set_color('white');
        $formatRHD->set_pattern();
        $formatRHD->set_fg_color('black');
        $formatRHD->set_bottom(1);
        $formatRHD->set_top(1);
        $formatRHD->set_left(1);
        $formatRHD->set_right(1);

        $formatC =& $workbook->add_format();
        $formatC->set_size(10);
        $formatC->set_align('left');
        $formatC->set_color('black');
        $formatC->set_left(1);
        $formatC->set_right(1);
        $formatC->set_bottom(1);

        $formatCNC =& $workbook->add_format();
        $formatCNC->set_size(10);
        $formatCNC->set_align('left');
        $formatCNC->set_color('black');
        $formatCNC->set_left(1);
        $formatCNC->set_right(0);

        $formatCC =& $workbook->add_format();
        $formatCC->set_size(10);
        $formatCC->set_align('center');
        $formatCC->set_color('black');
        $formatCC->set_left(1);
        $formatCC->set_right(1);

        $formatCR =& $workbook->add_format();
        $formatCR->set_size(10);
        $formatCR->set_align('right');
        $formatCR->set_color('black');
        $formatCR->set_left(1);
        $formatCR->set_right(1);

        $formatECR =& $workbook->add_format();
        $formatECR->set_size(10);
        $formatECR->set_align('right');
        $formatECR->set_color('black');
        $formatECR->set_pattern();
        $formatECR->set_fg_color('yellow');
        $formatECR->set_left(1);
        $formatECR->set_right(1);

        $formatECL =& $workbook->add_format();
        $formatECL->set_size(10);
        $formatECL->set_align('left');
        $formatECL->set_color('black');
        $formatECL->set_pattern();
        $formatECL->set_fg_color('yellow');
        $formatECL->set_left(1);
        $formatECL->set_right(1);

        $formatB =& $workbook->add_format();
        $formatB->set_size(10);
        $formatB->set_align('left');
        $formatB->set_color('white');
        $formatB->set_pattern();
        $formatB->set_fg_color('black');
        $formatB->set_top(1);
        $formatB->set_bold(1);
        $formatB->set_bottom(1);

        $formatB1 =& $workbook->add_format();
        $formatB1->set_size(10);
        $formatB1->set_align('right');
        $formatB1->set_color('white');
        $formatB1->set_pattern();
        $formatB1->set_fg_color('black');
        $formatB1->set_top(1);
        $formatB1->set_bold(1);
        $formatB1->set_bottom(1);

        $formatBL =& $workbook->add_format();
        $formatBL->set_size(10);
        $formatBL->set_align('left');
        $formatBL->set_color('white');
        $formatBL->set_pattern();
        $formatBL->set_fg_color('black');
        $formatBL->set_top(1);
        $formatBL->set_bold(1);
        $formatBL->set_bottom(1);
        $formatBL->set_left(1);

        $formatBR =& $workbook->add_format();
        $formatBR->set_size(10);
        $formatBR->set_align('left');
        $formatBR->set_color('white');
        $formatBR->set_pattern();
        $formatBR->set_fg_color('black');
        $formatBR->set_top(1);
        $formatBR->set_bold(1);
        $formatBR->set_bottom(1);
        $formatBR->set_right(1);

        $worksheet1->set_column(1, 0, 4);
        $worksheet1->set_column(1, 1, 50);
        $worksheet1->set_column(1, 2, 20);
        $worksheet1->set_column(1, 3, 20);
        $worksheet1->set_column(1, 4, 20);
        $worksheet1->set_column(1, 5, 20);
        $worksheet1->set_column(1, 6, 20);
        $worksheet1->set_column(1, 7, 20);
        $worksheet1->set_column(1, 8, 20);
        $worksheet1->set_column(1, 9, 20);
        $worksheet1->set_column(1, 10, 20);

        $wSQL = "";
        $searchLabel = "";
        if (strlen(trim($this->getVar('rNum4'))) > 0) {

            $searchLabel = "Pembatasan data dengan kata kunci ".$this->getVar('rNum4').".";

            $wSQL .= " (lower(ast_label) like '%".strtolower($this->getVar('rNum4'))."%') or ";
            $wSQL .= " (lower(ast_kode_bmn) like '%".strtolower($this->getVar('rNum4'))."%') or ";
            $wSQL .= " (lower(astgrp_label) like '%".strtolower($this->getVar('rNum4'))."%') or ";
            $wSQL .= " (lower(pngjwb_label) like '%".strtolower($this->getVar('rNum4'))."%') or ";
            $wSQL .= " (lower((select loc_label from ref_aset_lokasi, trx_lokasi where loc_id = trxloc_id_lokasi_baru and trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1)) like '%".strtolower($this->getVar('rNum4'))."%') or ";
            $wSQL .= " (lower((select get_ip_aset(ast_id))) like '%".strtolower($this->getVar('rNum4'))."%') ";
            $wSQL .= " (lower((select get_domain_aset(ast_id))) like '%".strtolower($this->getVar('rNum4'))."%') ";

            if ($this->getVar('rNum4') > 0) {
                $wSQL .= " or (ast_id = '".($this->getVar('rNum4') * 1)."') ";
            }

            if (strtolower($this->getVar('rNum4')) == 'tampil') {
                $wSQL .= " or (ref_aset.ref_stat_visible = 1) ";
            }

            if (strtolower($this->getVar('rNum4')) == 'disembunyikan') {
                $wSQL .= " or (ref_aset.ref_stat_visible <> 1) ";
            }

        }
        elseif ($_GET['fR']==1) {
            $wSQL .= " 1 ";
            if (strlen(trim($_GET['fLabel']))>0) {
                $searchLabel .= "Nama / BMN = ".$_GET['fLabel'].". ";
                $t_label = explode(',',$_GET['fLabel']);
                if (count($t_label) > 1) {
                    reset($t_label);
                    $t_wsql = '';
                    while (list($key, $val) = each($t_label)) {
                        $t_wsql .= " (lower(ast_label) like '%".strtolower(trim($val))."%') or ";
                        $t_wsql .= " (lower(ast_kode_bmn) like '%".strtolower(trim($val))."%') or ";
                    }
                    $t_wsql .= " false ";
                    $wSQL .= " and (".$t_wsql.") ";
                }
                else {
                    $t_wsql  = '';
                    $t_wsql .= " (lower(ast_label) like '%".strtolower(trim($_GET['fLabel']))."%') or ";
                    $t_wsql .= " (lower(ast_kode_bmn) like '%".strtolower(trim($_GET['fLabel']))."%') ";
                    $wSQL .= " and (".$t_wsql.") ";
                }
            }
            if (strlen(trim($_GET['fIP']))>0) {
                $searchLabel .= "IP / Domain = ".$_GET['fIP'].". ";
                $t_label = explode(',',$_GET['fIP']);
                if (count($t_label) > 1) {
                    reset($t_label);
                    $t_wsql = '';
                    while (list($key, $val) = each($t_label)) {
                        $t_wsql .= " (lower((select get_ip_aset(ast_id))) like '".strtolower(trim($val))."%') or ";
                        $t_wsql .= " (lower((select get_domain_aset(ast_id))) like '%".strtolower(trim($val))."%') or ";
                    }
                    $t_wsql .= " false ";
                    $wSQL .= " and (".$t_wsql.") ";
                }
                else {
                    $t_wsql  = '';
                    $t_wsql .= " (lower((select get_ip_aset(ast_id))) like '".strtolower(trim($_GET['fIP']))."%') or ";
                    $t_wsql .= " (lower((select get_domain_aset(ast_id))) like '%".strtolower(trim($_GET['fIP']))."%') ";
                    $wSQL .= " and (".$t_wsql.") ";
                }
            }
            if ($_GET['fJenis'] > 0) {

                $SQLCekInput = "select * from ref_aset_grup where astgrp_id = '".$_GET['fJenis']."' ";
                $rhCekInput = $this->dbH->query($SQLCekInput);
                $rrCekInput = $rhCekInput->fetch();

                $searchLabel .= "Jenis = ".$rrCekInput['astgrp_label'].". ";
                $wSQL .= " and (ast_id_grupaset = '".$_GET['fJenis']."') ";
            }
            if ($_GET['fPng'] > 0) {

                $SQLCekInput = "select * from ref_penanggungjawab where pngjwb_id = '".$_GET['fPng']."' ";
                $rhCekInput = $this->dbH->query($SQLCekInput);
                $rrCekInput = $rhCekInput->fetch();

                $searchLabel .= "Penanggung Jawab = ".$rrCekInput['pngjwb_label'].". ";
                $wSQL .= " and (ast_id_pngjawab = '".$_GET['pngjwb_id']."') ";
            }
            if ($_GET['fSatker'] > 0) {

                $SQLCekInput = "select * from ref_satker where ref_satker_id = '".$_GET['fSatker']."' ";
                $rhCekInput = $this->dbH->query($SQLCekInput);
                $rrCekInput = $rhCekInput->fetch();

                $searchLabel .= "Satuan Kerja = ".$rrCekInput['ref_satker_label'].". ";
                $wSQL .= " and (ref_satker_id = '".$_GET['fSatker']."') ";
            }
            if ($_GET['fLokasi'] > 0) {

                $SQLCekInput = "select * from ref_aset_lokasi where loc_id = '".$_GET['fLokasi']."' ";
                $rhCekInput = $this->dbH->query($SQLCekInput);
                $rrCekInput = $rhCekInput->fetch();

                $searchLabel .= "Lokasi = ".$rrCekInput['loc_label'].". ";
                $wSQL .= " and (lower((select loc_label from ref_aset_lokasi, trx_lokasi where loc_id = trxloc_id_lokasi_baru and trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1)) = '".strtolower($rrCekInput['loc_label'])."') ";
            }

            if (strlen(trim($searchLabel))>0) {
                $searchLabel = 'Filter Data: '.$searchLabel;
            }
        }

        if (strlen(trim($wSQL))>0) {
            $wSQL = ' where '.$wSQL;
        }

        $worksheet1->write_string(0, 0, "Inventaris Data Center",$formatHD1);
        $worksheet1->write_string(1, 0, "Kementerian Komunikasi dan Informatika",$formatHD1);
        $worksheet1->write_string(3, 0, "Daftar Aset",$formatHD1);
        $worksheet1->write_string(4, 0, "Didownload oleh ".$member['userName'].", tanggal generate ".date('d F Y H:i:s'),$formatHD2);
        $worksheet1->write_string(5, 0, $searchLabel,$formatHD2);

        $worksheet1->write_string(7, 0, "ID",$formatRHD);
        $worksheet1->write_string(7, 1, "Nama Aset",$formatRHD);
        $worksheet1->write_string(7, 2, "No. BMN",$formatRHD);
        $worksheet1->write_string(7, 3, "Jenis",$formatRHD);
        $worksheet1->write_string(7, 4, "Lokasi Terkini",$formatRHD);
        $worksheet1->write_string(7, 5, "Satuan Kerja",$formatRHD);
        $worksheet1->write_string(7, 6, "Penanggung Jawab",$formatRHD);
        $worksheet1->write_string(7, 7, "Telp",$formatRHD);
        $worksheet1->write_string(7, 8, "Email",$formatRHD);
        $worksheet1->write_string(7, 9, "IP Address",$formatRHD);
        $worksheet1->write_string(7, 10, "Domain",$formatRHD);

        $SQL2  = " select   ref_aset.*,
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
                           ref_satker_kode,
                           (select loc_label from ref_aset_lokasi, trx_lokasi where loc_id = trxloc_id_lokasi_baru and trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1) as infolokasi,
                           (select get_ip_aset(ast_id)) as infoip,
                           (select get_domain_aset(ast_id)) as infodomain
                  from     ref_aset
                            left join ref_aset_grup on astgrp_id = ast_id_grupaset
                            left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                            left join ref_satker on ref_satker_id = pngjwb_id_satker
                              ".$wSQL."
                  order by ast_id
                  ";
        $rh2 = $this->dbH->query($SQL2);
        $functDB->dberror_show($rh2);
        $excelRowCounter = 0;
        while ($rr2 = $rh2->fetch()) {
            $excelRowCounter++;

            $worksheet1->write_number(7+$excelRowCounter, 0, $rr2['ast_id'],$formatC);
            $worksheet1->write_string(7+$excelRowCounter, 1, $rr2['ast_label'],$formatC);
            $worksheet1->write_string(7+$excelRowCounter, 2, $rr2['ast_kode_bmn'],$formatC);
            $worksheet1->write_string(7+$excelRowCounter, 3, $rr2['astgrp_label'],$formatC);
            $worksheet1->write_string(7+$excelRowCounter, 4, $rr2['infolokasi'],$formatC);
            $worksheet1->write_string(7+$excelRowCounter, 5, $rr2['ref_satker_label'],$formatC);
            $worksheet1->write_string(7+$excelRowCounter, 6, $rr2['pngjwb_label'],$formatC);
            $worksheet1->write_string(7+$excelRowCounter, 7, $rr2['pngjwb_telp'],$formatC);
            $worksheet1->write_string(7+$excelRowCounter, 8, $rr2['pngjwb_email'],$formatC);
            $worksheet1->write_string(7+$excelRowCounter, 9, trim($rr2['infoip']),$formatC);
            $worksheet1->write_string(7+$excelRowCounter, 10, trim($rr2['infodomain']),$formatC);
        }

        $workbook->close();

        die();
    }

    function asetSpekPdf($tmp = '') {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $pdfTitle = "Inventaris Data Center";
        $pdfSubTitle = "Kementerian Komunikasi dan Informatika";

        require_once('./tcpdf/tcpdf.php');

        $pdf = new TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);

        // set document information
        $pdf->SetCreator('Inventaris Data Center');
        $pdf->SetAuthor('Kementerian Komunikasi dan Informatika');
        $pdf->SetTitle($pdfTitle);

        // set default header data
        $pdf->SetHeaderData('images/logo_kominfo.jpg', 10, $pdfTitle, $pdfSubTitle, array(0,64,255), array(0,64,128));
        $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

        // set margins
        //$pdf->SetMargins(PDF_MARGIN_LEFT, 25, PDF_MARGIN_RIGHT);
        $pdf->SetMargins(10, 25, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(10);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

        // set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        // set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

        $pdf->AddPage();

        $pdf->SetFont('helvetica', '', 8, '', true);

        if (($idast == 0) && ($this->getVar('rNum') > 0)) {
            $idast = $this->getVar('rNum');
        }

        $SQLAset = "select ref_aset.*,
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
                    from   ref_aset
                            left join ref_aset_grup on astgrp_id = ast_id_grupaset
                            left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                            left join ref_satker on ref_satker_id = pngjwb_id_satker
                    where  ast_id = '".$idast."'
                    ";
        $rhAset  = $this->dbH->query($SQLAset);
        $rrAset  = $rhAset->fetch();

        $html  = '';

        $img = '';
        if (file_exists('tmpImage/invastqrc_'.$idast.'.png')) {
            $img = '<img src="./tmpImage/invastqrc_'.$idast.'.png" width="100" style="padding:10px; border:1px solid #000000;">';
        }

        $html .= '<table width="100%" border="0" cellspacing="0" cellpadding="4">';
        $html .= '<tr>';
        $html .= ' <td width="50%" align="left" valign="top"><h1>'.$rrAset['ast_label'].'</h1><BR>'.$img.'</td>';
        $html .= ' <td width="50%" align="right" valign="top">';

        $html .= '<table width="100%" border="0" cellspacing="0" cellpadding="4">';
        $html .= '<tr>';
        $html .= ' <td width="40%" align="right" valign="top">Jenis Aset</td>';
        $html .= ' <td width="5%" align="center" valign="top">:</td>';
        $html .= ' <td width="55%" align="left" valign="top">'.$rrAset['astgrp_label'].'</td>';
        $html .= '</tr>';
        $html .= '<tr>';
        $html .= ' <td width="40%" align="right" valign="top">No. BMN</td>';
        $html .= ' <td width="5%" align="center" valign="top">:</td>';
        $html .= ' <td width="55%" align="left" valign="top">'.$rrAset['ast_kode_bmn'].'</td>';
        $html .= '</tr>';
        $html .= '<tr>';
        $html .= ' <td width="40%" align="right" valign="top">Lokasi</td>';
        $html .= ' <td width="5%" align="center" valign="top">:</td>';
        $html .= ' <td width="55%" align="left" valign="top">'.$rrAset['infolokasi'].'</td>';
        $html .= '</tr>';
        $html .= '<tr>';
        $html .= ' <td width="40%" align="right" valign="top">IP Address</td>';
        $html .= ' <td width="5%" align="center" valign="top">:</td>';
        $html .= ' <td width="55%" align="left" valign="top">'.str_replace(', ','<BR>',trim($rrAset['infoip'])).'</td>';
        $html .= '</tr>';
        $html .= '<tr>';
        $html .= ' <td width="40%" align="right" valign="top">Domain</td>';
        $html .= ' <td width="5%" align="center" valign="top">:</td>';
        $html .= ' <td width="55%" align="left" valign="top">'.str_replace(', ','<BR>',trim($rrAset['infodomain'])).'</td>';
        $html .= '</tr>';
        $html .= '<tr>';
        $html .= ' <td width="40%" align="right" valign="top">Satuan Kerja</td>';
        $html .= ' <td width="5%" align="center" valign="top">:</td>';
        $html .= ' <td width="55%" align="left" valign="top">'.trim($rrAset['ref_satker_label']).'</td>';
        $html .= '</tr>';
        $html .= '<tr>';
        $html .= ' <td width="40%" align="right" valign="top">Penanggung Jawab</td>';
        $html .= ' <td width="5%" align="center" valign="top">:</td>';
        $html .= ' <td width="55%" align="left" valign="top">'.$rrAset['pngjwb_label'].'<BR>'.$rrAset['pngjwb_email'].'</td>';
        $html .= '</tr>';
        $html .= '</table>';

        $html .= ' </td>';
        $html .= '</tr>';
        $html .= '</table>';

        if (($_GET['fR'] != 1) || (($_GET['fR'] == 1) && ($_GET['useSpec'] == 1))) {

            $html .= '<H3>SPESIFIKASI ASET</H3>';

            $html .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
            $html .= '<tr>';
            $html .= ' <td width="5%" align="center" valign="top">No</td>';
            $html .= ' <td width="30%" align="center" valign="top">Spesifikasi</td>';
            $html .= ' <td width="20%" align="center" valign="top">Nilai</td>';
            $html .= ' <td width="10%" align="center" valign="top">Satuan</td>';
            $html .= ' <td width="35%" align="center" valign="top">Penjelasan</td>';
            $html .= '</tr>';

            $SQL2 = " select astspk_id as id,
                             astspk_id,
                             astgrpspek_label,
                             astspk_value_text,
                             astgrpspek_satuan,
                             astgrpspek_keterangan
                      from   ref_aset_spesifikasi, ref_aset_grup_spek
                      where  astgrpspek_id = astspk_id_grup_spek and
                             astspk_id_aset = '".$idast."'
                      order by astgrpspek_urutan, astgrpspek_label
                      ";
            $rh2 = $this->dbH->query($SQL2);
            $functDB->dberror_show($rh2);
            while ($rr2 = $rh2->fetch()) {

                $rowCounter++;
                $html .= '<tr>';
                $html .= ' <td align="center" valign="top">'.$rowCounter.'.&nbsp;</td>';
                $html .= ' <td align="left" valign="top">'.($rr2['astgrpspek_label']).'&nbsp;</td>';
                $html .= ' <td align="left" valign="top">'.($rr2['astspk_value_text']).'&nbsp;</td>';
                $html .= ' <td align="left" valign="top">'.($rr2['astgrpspek_satuan']).'&nbsp;</td>';
                $html .= ' <td align="left" valign="top">'.($rr2['astgrpspek_keterangan']).'&nbsp;</td>';
                $html .= '</tr>';
            }

            $html .= '</table>';

        }

        if (($_GET['fR'] != 1) || (($_GET['fR'] == 1) && ($_GET['useEvent'] == 1))) {

            $rowCounter = 0;

            $html .= '<H3>SEJARAH PERISTIWA ASET</H3>';

            $html .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
            $html .= '<tr>';
            $html .= ' <td width="5%" align="center" valign="top">No</td>';
            $html .= ' <td width="15%" align="center" valign="top">Tanggal & Jam</td>';
            $html .= ' <td width="15%" align="center" valign="top">Peristiwa</td>';
            $html .= ' <td width="15%" align="center" valign="top">Dicatat Oleh</td>';
            $html .= ' <td width="50%" align="center" valign="top">Keterangan</td>';
            $html .= '</tr>';

            $SQL2 = " select trxkej_id as id,
                             trxkej_id,
                             trxkej_keterangan,
                             trxkej_oleh,
                             date_format(trxkej_tanggal,'%a, %e %b %Y') as tglformat,
                             date_format(trxkej_waktu,'Jam %H:%i:%s') as waktuformat
                      from   trx_kejadian left join ref_kejadian_jenis on jnskej_id = trxkej_id_kej
                      where  trxkej_id_aset = '".$idast."'
                      order by trxkej_tanggal desc, trxkej_waktu desc
                      ";
            $rh2 = $this->dbH->query($SQL2);
            $functDB->dberror_show($rh2);
            while ($rr2 = $rh2->fetch()) {

                $rowCounter++;
                $html .= '<tr>';
                $html .= ' <td align="center" valign="top">'.$rowCounter.'.&nbsp;</td>';
                $html .= ' <td align="left" valign="top">'.($rr2['tglformat']).'<BR>'.($rr2['waktuformat']).'&nbsp;</td>';
                $html .= ' <td align="left" valign="top">'.($rr2['jnskej_label']).'&nbsp;</td>';
                $html .= ' <td align="left" valign="top">'.($rr2['trxkej_oleh']).'&nbsp;</td>';
                $html .= ' <td align="left" valign="top">'.($rr2['trxkej_keterangan']).'&nbsp;</td>';
                $html .= '</tr>';
            }

            $html .= '</table>';

        }

        if (($_GET['fR'] != 1) || (($_GET['fR'] == 1) && ($_GET['useChanges'] == 1))) {

            $html .= '<H3>PERUBAHAN DATA ASET</H3>';

            $html .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
            $html .= '<tr>';
            $html .= ' <td width="5%" align="center" valign="top">No</td>';
            $html .= ' <td width="15%" align="center" valign="top">Tanggal & Jam</td>';
            $html .= ' <td width="20%" align="center" valign="top">Dilakukan Oleh</td>';
            $html .= ' <td width="60%" align="center" valign="top">Keterangan</td>';
            $html .= '</tr>';

            $SQL2 = " select logubah_id as id,
                             logubah_id,
                             logubah_catatan,
                             logubah_oleh,
                             date_format(logubah_tanggal,'%a, %e %b %Y') as tglformat,
                             date_format(logubah_waktu,'Jam %H:%i:%s') as waktuformat
                      from   log_perubahan
                      where  logubah_id_aset = '".$idast."'
                      order by logubah_tanggal desc, logubah_waktu desc
                      ";
            $rh2 = $this->dbH->query($SQL2);
            $functDB->dberror_show($rh2);
            while ($rr2 = $rh2->fetch()) {

                $rowCounter++;
                $html .= '<tr>';
                $html .= ' <td align="center" valign="top">'.$rowCounter.'.&nbsp;</td>';
                $html .= ' <td align="left" valign="top">'.($rr2['tglformat']).'<BR>'.($rr2['waktuformat']).'&nbsp;</td>';
                $html .= ' <td align="left" valign="top">'.($rr2['logubah_oleh']).'&nbsp;</td>';
                $html .= ' <td align="left" valign="top">'.($rr2['logubah_catatan']).'&nbsp;</td>';
                $html .= '</tr>';
            }

            $html .= '</table>';

        }


        $filename = 'rep_aset_spek_'.date('dmy_His').'.pdf';
        $fullfilename = './tmpPdf/'.$filename;

        $html .= '<BR><BR>'.$filename.' dicetak oleh '.$member['userName'].' pada '.date('d M Y H:i:s');

        $pdf->writeHTML($html);

        $pdf->Output($fullfilename, 'F');
        $pdf->Output($fullfilename, 'I');
        die();

    }

    function formaAetSpekPdfExcel() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        ob_end_clean();

        require_once('./excelClass/Worksheet.php');
        require_once('./excelClass/Workbook.php');

        $member =  $this->sessionH->getMemberData();
        $filename = 'excel_aset_'.date('dmyhis').'.xls';

        header("Content-type: application/vnd.ms-excel");
        header("Content-Disposition: attachment; filename=".$filename );
        header("Expires: 0");
        header("Cache-Control: must-revalidate, post-check=0,pre-check=0");
        header("Pragma: public");

        // Creating a workbook
        $workbook = new Workbook("-");

        // Creating the first worksheet
        $worksheet1 =& $workbook->add_worksheet('Aset');

        $formatHD =& $workbook->add_format();
        $formatHD->set_size(14);
        $formatHD->set_bold(1);
        $formatHD->set_align('left');
        $formatHD->set_color('black');

        $formatHD1 =& $workbook->add_format();
        $formatHD1->set_size(12);
        $formatHD1->set_bold(1);
        $formatHD1->set_align('left');
        $formatHD1->set_color('black');

        $formatHD2 =& $workbook->add_format();
        $formatHD2->set_size(10);
        $formatHD2->set_bold(1);
        $formatHD2->set_align('left');
        $formatHD2->set_color('black');

        $formatRHD =& $workbook->add_format();
        $formatRHD->set_size(10);
        $formatRHD->set_bold(1);
        $formatRHD->set_align('left');
        $formatRHD->set_color('white');
        $formatRHD->set_pattern();
        $formatRHD->set_fg_color('black');
        $formatRHD->set_bottom(1);
        $formatRHD->set_top(1);
        $formatRHD->set_left(1);
        $formatRHD->set_right(1);

        $formatC =& $workbook->add_format();
        $formatC->set_size(10);
        $formatC->set_align('left');
        $formatC->set_color('black');
        $formatC->set_left(1);
        $formatC->set_right(1);
        $formatC->set_bottom(1);

        $formatCNC =& $workbook->add_format();
        $formatCNC->set_size(10);
        $formatCNC->set_align('left');
        $formatCNC->set_color('black');
        $formatCNC->set_left(1);
        $formatCNC->set_right(0);

        $formatCC =& $workbook->add_format();
        $formatCC->set_size(10);
        $formatCC->set_align('center');
        $formatCC->set_color('black');
        $formatCC->set_left(1);
        $formatCC->set_right(1);

        $formatCR =& $workbook->add_format();
        $formatCR->set_size(10);
        $formatCR->set_align('right');
        $formatCR->set_color('black');
        $formatCR->set_left(1);
        $formatCR->set_right(1);

        $formatECR =& $workbook->add_format();
        $formatECR->set_size(10);
        $formatECR->set_align('right');
        $formatECR->set_color('black');
        $formatECR->set_pattern();
        $formatECR->set_fg_color('yellow');
        $formatECR->set_left(1);
        $formatECR->set_right(1);

        $formatECL =& $workbook->add_format();
        $formatECL->set_size(10);
        $formatECL->set_align('left');
        $formatECL->set_color('black');
        $formatECL->set_pattern();
        $formatECL->set_fg_color('yellow');
        $formatECL->set_left(1);
        $formatECL->set_right(1);

        $formatB =& $workbook->add_format();
        $formatB->set_size(10);
        $formatB->set_align('left');
        $formatB->set_color('white');
        $formatB->set_pattern();
        $formatB->set_fg_color('black');
        $formatB->set_top(1);
        $formatB->set_bold(1);
        $formatB->set_bottom(1);

        $formatB1 =& $workbook->add_format();
        $formatB1->set_size(10);
        $formatB1->set_align('right');
        $formatB1->set_color('white');
        $formatB1->set_pattern();
        $formatB1->set_fg_color('black');
        $formatB1->set_top(1);
        $formatB1->set_bold(1);
        $formatB1->set_bottom(1);

        $formatBL =& $workbook->add_format();
        $formatBL->set_size(10);
        $formatBL->set_align('left');
        $formatBL->set_color('white');
        $formatBL->set_pattern();
        $formatBL->set_fg_color('black');
        $formatBL->set_top(1);
        $formatBL->set_bold(1);
        $formatBL->set_bottom(1);
        $formatBL->set_left(1);

        $formatBR =& $workbook->add_format();
        $formatBR->set_size(10);
        $formatBR->set_align('left');
        $formatBR->set_color('white');
        $formatBR->set_pattern();
        $formatBR->set_fg_color('black');
        $formatBR->set_top(1);
        $formatBR->set_bold(1);
        $formatBR->set_bottom(1);
        $formatBR->set_right(1);

        $worksheet1->set_column(1, 0, 4);
        $worksheet1->set_column(1, 1, 15);
        $worksheet1->set_column(1, 2, 50);
        $worksheet1->set_column(1, 3, 20);
        $worksheet1->set_column(1, 4, 20);
        $worksheet1->set_column(1, 5, 20);
        $worksheet1->set_column(1, 6, 10);
        $worksheet1->set_column(1, 7, 10);

        if (($idast == 0) && ($this->getVar('rNum') > 0)) {
            $idast = $this->getVar('rNum');
        }

        $SQLAset = "select ref_aset.*,
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
                    from   ref_aset
                            left join ref_aset_grup on astgrp_id = ast_id_grupaset
                            left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                            left join ref_satker on ref_satker_id = pngjwb_id_satker
                    where  ast_id = '".$idast."'
                    ";
        $rhAset  = $this->dbH->query($SQLAset);
        $rrAset  = $rhAset->fetch();

        $worksheet1->write_string(0, 0, "Inventaris Data Center",$formatHD1);
        $worksheet1->write_string(1, 0, "Kementerian Komunikasi dan Informatika",$formatHD1);
        $worksheet1->write_string(3, 0, "Profil Aset",$formatHD1);
        $worksheet1->write_string(4, 0, "Didownload oleh ".$member['userName'].", tanggal generate ".date('d F Y H:i:s'),$formatHD2);
        $worksheet1->write_string(5, 0, "",$formatHD2);

        $worksheet1->write_string(7, 0, "Nama",$formatHD2);
        $worksheet1->write_string(7, 2, $rrAset['ast_label'],$formatHD2);

        $worksheet1->write_string(8, 0, "Jenis",$formatHD2);
        $worksheet1->write_string(8, 2, $rrAset['astgrp_label'],$formatHD2);

        $worksheet1->write_string(9, 0, "No. BMN",$formatHD2);
        $worksheet1->write_string(9, 2, $rrAset['ast_kode_bmn'],$formatHD2);

        $worksheet1->write_string(10, 0, "Lokasi",$formatHD2);
        $worksheet1->write_string(10, 2, $rrAset['infolokasi'],$formatHD2);

        $worksheet1->write_string(11, 0, "IP Address",$formatHD2);
        $worksheet1->write_string(11, 2, $rrAset['infoip'],$formatHD2);

        $worksheet1->write_string(12, 0, "Domain",$formatHD2);
        $worksheet1->write_string(12, 2, $rrAset['infodomain'],$formatHD2);

        $worksheet1->write_string(13, 0, "Satuan Kerja",$formatHD2);
        $worksheet1->write_string(13, 2, $rrAset['ref_satker_label'],$formatHD2);

        $worksheet1->write_string(14, 0, "Penanggung Jawab",$formatHD2);
        $worksheet1->write_string(14, 2, $rrAset['pngjwb_label'].' ('.$rrAset['pngjwb_email'].')',$formatHD2);

        $startRow = 16;
        if (($_GET['fR'] != 1) || (($_GET['fR'] == 1) && ($_GET['useSpec'] == 1))) {

            $excelRowCounter = 0;

            $worksheet1->write_string($startRow, 0, "SPESIFIKASI ASET",$formatHD1);

            $worksheet1->write_string($startRow+$excelRowCounter+1, 0, "No",$formatRHD);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 1, "Spesifikasi",$formatRHD);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 2, "Nilai",$formatRHD);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 3, "Satuan",$formatRHD);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 4, "Penjelasan",$formatRHD);

            $SQL2 = " select astspk_id as id,
                             astspk_id,
                             astgrpspek_label,
                             astspk_value_text,
                             astgrpspek_satuan,
                             astgrpspek_keterangan
                      from   ref_aset_spesifikasi, ref_aset_grup_spek
                      where  astgrpspek_id = astspk_id_grup_spek and
                             astspk_id_aset = '".$idast."'
                      order by astgrpspek_urutan, astgrpspek_label
                      ";
            $rh2 = $this->dbH->query($SQL2);
            $functDB->dberror_show($rh2);
            while ($rr2 = $rh2->fetch()) {

                $excelRowCounter++;

                $worksheet1->write_number($startRow+$excelRowCounter+1, 0, $excelRowCounter,$formatC);
                $worksheet1->write_string($startRow+$excelRowCounter+1, 1, $rr2['astgrpspek_label'],$formatC);
                $worksheet1->write_string($startRow+$excelRowCounter+1, 2, $rr2['astspk_value_text'],$formatC);
                $worksheet1->write_string($startRow+$excelRowCounter+1, 3, $rr2['astgrpspek_satuan'],$formatC);
                $worksheet1->write_string($startRow+$excelRowCounter+1, 4, $rr2['astgrpspek_keterangan'],$formatC);
            }

            $startRow = $startRow+$excelRowCounter+3;
        }

        if (($_GET['fR'] != 1) || (($_GET['fR'] == 1) && ($_GET['useEvent'] == 1))) {

            $excelRowCounter = 0;

            $worksheet1->write_string($startRow, 0, "SEJARAH PERISTIWA ASET",$formatHD1);

            $worksheet1->write_string($startRow+$excelRowCounter+1, 0, "No",$formatRHD);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 1, "Tanggal",$formatRHD);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 2, "Jam",$formatRHD);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 3, "Peristiwa",$formatRHD);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 4, "Dicatat Oleh",$formatRHD);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 5, "Keterangan",$formatRHD);

            $SQL2 = " select trxkej_id as id,
                             trxkej_id,
                             trxkej_keterangan,
                             trxkej_oleh,
                             date_format(trxkej_tanggal,'%e %b %Y') as tglformat,
                             date_format(trxkej_waktu,'%H:%i:%s') as waktuformat
                      from   trx_kejadian left join ref_kejadian_jenis on jnskej_id = trxkej_id_kej
                      where  trxkej_id_aset = '".$idast."'
                      order by trxkej_tanggal desc, trxkej_waktu desc
                      ";
            $rh2 = $this->dbH->query($SQL2);
            $functDB->dberror_show($rh2);
            while ($rr2 = $rh2->fetch()) {

                $excelRowCounter++;

                $worksheet1->write_number($startRow+$excelRowCounter+1, 0, $excelRowCounter,$formatC);
                $worksheet1->write_string($startRow+$excelRowCounter+1, 1, $rr2['tglformat'],$formatC);
                $worksheet1->write_string($startRow+$excelRowCounter+1, 2, $rr2['waktuformat'],$formatC);
                $worksheet1->write_string($startRow+$excelRowCounter+1, 3, $rr2['jnskej_label'],$formatC);
                $worksheet1->write_string($startRow+$excelRowCounter+1, 4, $rr2['trxkej_oleh'],$formatC);
                $worksheet1->write_string($startRow+$excelRowCounter+1, 5, $rr2['trxkej_keterangan'],$formatC);
            }

            $startRow = $startRow+$excelRowCounter+3;

        }

        if (($_GET['fR'] != 1) || (($_GET['fR'] == 1) && ($_GET['useChanges'] == 1))) {

            $excelRowCounter = 0;

            $worksheet1->write_string($startRow, 0, "PERUBAHAN DATA ASET",$formatHD1);

            $worksheet1->write_string($startRow+$excelRowCounter+1, 0, "No",$formatRHD);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 1, "Tanggal",$formatRHD);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 2, "Jam",$formatRHD);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 3, "Dilakukan Oleh",$formatRHD);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 4, "Keterangan",$formatRHD);

            $SQL2 = " select logubah_id as id,
                             logubah_id,
                             logubah_catatan,
                             logubah_oleh,
                             date_format(logubah_tanggal,'%e %b %Y') as tglformat,
                             date_format(logubah_waktu,'%H:%i:%s') as waktuformat
                      from   log_perubahan
                      where  logubah_id_aset = '".$idast."'
                      order by logubah_tanggal desc, logubah_waktu desc
                      ";
            $rh2 = $this->dbH->query($SQL2);
            $functDB->dberror_show($rh2);
            while ($rr2 = $rh2->fetch()) {

                $excelRowCounter++;

                $worksheet1->write_number($startRow+$excelRowCounter+1, 0, $excelRowCounter,$formatC);
                $worksheet1->write_string($startRow+$excelRowCounter+1, 1, $rr2['tglformat'],$formatC);
                $worksheet1->write_string($startRow+$excelRowCounter+1, 2, $rr2['waktuformat'],$formatC);
                $worksheet1->write_string($startRow+$excelRowCounter+1, 3, $rr2['logubah_oleh'],$formatC);
                $worksheet1->write_string($startRow+$excelRowCounter+1, 4, $rr2['logubah_catatan'],$formatC);

                $rowCounter++;
            }

            $html .= '</table>';

        }



        $workbook->close();

        die();
    }

    function formaAsetSpekExcel2() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        ob_end_clean();

        require_once('./excelClass/Worksheet.php');
        require_once('./excelClass/Workbook.php');

        $member =  $this->sessionH->getMemberData();
        $filename = 'excel_aset_'.date('dmyhis').'.xls';

        header("Content-type: application/vnd.ms-excel");
        header("Content-Disposition: attachment; filename=".$filename );
        header("Expires: 0");
        header("Cache-Control: must-revalidate, post-check=0,pre-check=0");
        header("Pragma: public");

        // Creating a workbook
        $workbook = new Workbook("-");

        // Creating the first worksheet
        $worksheet1 =& $workbook->add_worksheet('Aset');

        $formatHD =& $workbook->add_format();
        $formatHD->set_size(14);
        $formatHD->set_bold(1);
        $formatHD->set_align('left');
        $formatHD->set_color('black');

        $formatHD1 =& $workbook->add_format();
        $formatHD1->set_size(12);
        $formatHD1->set_bold(1);
        $formatHD1->set_align('left');
        $formatHD1->set_color('black');

        $formatHD2 =& $workbook->add_format();
        $formatHD2->set_size(10);
        $formatHD2->set_bold(1);
        $formatHD2->set_align('left');
        $formatHD2->set_color('black');

        $formatRHD =& $workbook->add_format();
        $formatRHD->set_size(10);
        $formatRHD->set_bold(1);
        $formatRHD->set_align('left');
        $formatRHD->set_color('white');
        $formatRHD->set_pattern();
        $formatRHD->set_fg_color('black');
        $formatRHD->set_bottom(1);
        $formatRHD->set_top(1);
        $formatRHD->set_left(1);
        $formatRHD->set_right(1);

        $formatC =& $workbook->add_format();
        $formatC->set_size(10);
        $formatC->set_align('left');
        $formatC->set_color('black');
        $formatC->set_left(1);
        $formatC->set_right(1);
        $formatC->set_bottom(1);

        $formatCNC =& $workbook->add_format();
        $formatCNC->set_size(10);
        $formatCNC->set_align('left');
        $formatCNC->set_color('black');
        $formatCNC->set_left(1);
        $formatCNC->set_right(0);

        $formatCC =& $workbook->add_format();
        $formatCC->set_size(10);
        $formatCC->set_align('center');
        $formatCC->set_color('black');
        $formatCC->set_left(1);
        $formatCC->set_right(1);

        $formatCR =& $workbook->add_format();
        $formatCR->set_size(10);
        $formatCR->set_align('right');
        $formatCR->set_color('black');
        $formatCR->set_left(1);
        $formatCR->set_right(1);

        $formatECR =& $workbook->add_format();
        $formatECR->set_size(10);
        $formatECR->set_align('right');
        $formatECR->set_color('black');
        $formatECR->set_pattern();
        $formatECR->set_fg_color('yellow');
        $formatECR->set_left(1);
        $formatECR->set_right(1);

        $formatECL =& $workbook->add_format();
        $formatECL->set_size(10);
        $formatECL->set_align('left');
        $formatECL->set_color('black');
        $formatECL->set_pattern();
        $formatECL->set_fg_color('yellow');
        $formatECL->set_left(1);
        $formatECL->set_right(1);

        $formatB =& $workbook->add_format();
        $formatB->set_size(10);
        $formatB->set_align('left');
        $formatB->set_color('white');
        $formatB->set_pattern();
        $formatB->set_fg_color('black');
        $formatB->set_top(1);
        $formatB->set_bold(1);
        $formatB->set_bottom(1);

        $formatB1 =& $workbook->add_format();
        $formatB1->set_size(10);
        $formatB1->set_align('right');
        $formatB1->set_color('white');
        $formatB1->set_pattern();
        $formatB1->set_fg_color('black');
        $formatB1->set_top(1);
        $formatB1->set_bold(1);
        $formatB1->set_bottom(1);

        $formatBL =& $workbook->add_format();
        $formatBL->set_size(10);
        $formatBL->set_align('left');
        $formatBL->set_color('white');
        $formatBL->set_pattern();
        $formatBL->set_fg_color('black');
        $formatBL->set_top(1);
        $formatBL->set_bold(1);
        $formatBL->set_bottom(1);
        $formatBL->set_left(1);

        $formatBR =& $workbook->add_format();
        $formatBR->set_size(10);
        $formatBR->set_align('left');
        $formatBR->set_color('white');
        $formatBR->set_pattern();
        $formatBR->set_fg_color('black');
        $formatBR->set_top(1);
        $formatBR->set_bold(1);
        $formatBR->set_bottom(1);
        $formatBR->set_right(1);

        $worksheet1->set_column(1, 0, 4);
        $worksheet1->set_column(1, 1, 15);
        $worksheet1->set_column(1, 2, 50);
        $worksheet1->set_column(1, 3, 20);
        $worksheet1->set_column(1, 4, 20);
        $worksheet1->set_column(1, 5, 20);
        $worksheet1->set_column(1, 6, 10);
        $worksheet1->set_column(1, 7, 10);

        $wSQL = "";
        $searchLabel = "";
        if ($_GET['fR']==1) {
            $wSQL .= " 1 ";
            if (strlen(trim($_GET['fLabel']))>0) {
                $searchLabel .= "Nama / BMN = ".$_GET['fLabel'].". ";
                $t_label = explode(',',$_GET['fLabel']);
                if (count($t_label) > 1) {
                    reset($t_label);
                    $t_wsql = '';
                    while (list($key, $val) = each($t_label)) {
                        $t_wsql .= " (lower(ast_label) like '%".strtolower(trim($val))."%') or ";
                        $t_wsql .= " (lower(ast_kode_bmn) like '%".strtolower(trim($val))."%') or ";
                    }
                    $t_wsql .= " false ";
                    $wSQL .= " and (".$t_wsql.") ";
                }
                else {
                    $t_wsql  = '';
                    $t_wsql .= " (lower(ast_label) like '%".strtolower(trim($_GET['fLabel']))."%') or ";
                    $t_wsql .= " (lower(ast_kode_bmn) like '%".strtolower(trim($_GET['fLabel']))."%') ";
                    $wSQL .= " and (".$t_wsql.") ";
                }
            }
            $sIDJenis = 0;
            if ($_GET['fJenis'] > 0) {

                $SQLCekInput = "select * from ref_aset_grup where astgrp_id = '".$_GET['fJenis']."' ";
                $rhCekInput = $this->dbH->query($SQLCekInput);
                $rrCekInput = $rhCekInput->fetch();

                $searchLabel .= "Jenis = ".$rrCekInput['astgrp_label'].". ";
                $wSQL .= " and (ast_id_grupaset = '".$_GET['fJenis']."') ";

                $sIDJenis = $_GET['fJenis'];
            }

            if (strlen(trim($searchLabel))>0) {
                $searchLabel = 'Filter Data: '.$searchLabel;
            }
        }

        if (strlen(trim($wSQL))>0) {
            $wSQL = ' where '.$wSQL;
        }

        $worksheet1->write_string(0, 0, "Inventaris Data Center",$formatHD1);
        $worksheet1->write_string(1, 0, "Kementerian Komunikasi dan Informatika",$formatHD1);
        $worksheet1->write_string(3, 0, "Komparasi Spesifikasi Aset",$formatHD1);
        $worksheet1->write_string(4, 0, "Didownload oleh ".$member['userName'].", tanggal generate ".date('d F Y H:i:s'),$formatHD2);
        $worksheet1->write_string(5, 0, $searchLabel,$formatHD2);

        $startRow = 6;
        $excelRowCounter = 0;

        $worksheet1->write_string($startRow+$excelRowCounter+1, 0, "No",$formatRHD);
        $worksheet1->write_string($startRow+$excelRowCounter+1, 1, "Jenis",$formatRHD);
        $worksheet1->write_string($startRow+$excelRowCounter+1, 2, "Aset",$formatRHD);
        $worksheet1->write_string($startRow+$excelRowCounter+1, 3, "No. BMN",$formatRHD);
        $worksheet1->write_string($startRow+$excelRowCounter+1, 4, "Satuan Kerja",$formatRHD);
        $worksheet1->write_string($startRow+$excelRowCounter+1, 5, "Penanggung Jawab",$formatRHD);

        $SQL2 = " select *
                  from   ref_aset_grup_spek
                  where  astgrpspek_id_grup = '".$sIDJenis."' and ref_stat_visible
                  order by astgrpspek_urutan, astgrpspek_label
                  ";
        $rh2 = $this->dbH->query($SQL2);
        $functDB->dberror_show($rh2);
        $excelColCounter = 6;
        $arrayColSpec = array();
        while ($rr2 = $rh2->fetch()) {
            if (strlen(trim($rr2['astgrpspek_satuan']))>0) {
                $worksheet1->write_string($startRow+$excelRowCounter+1, $excelColCounter, $rr2['astgrpspek_label'].' ('.$rr2['astgrpspek_satuan'].')',$formatRHD);
            }
            else {
                $worksheet1->write_string($startRow+$excelRowCounter+1, $excelColCounter, $rr2['astgrpspek_label'],$formatRHD);
            }
            $arrayColSpec[$excelColCounter] = $rr2['astgrpspek_id'];
            $excelColCounter++;
        }

        $worksheet1->write_string($startRow+$excelRowCounter+1, $excelColCounter, "IP",$formatRHD);
        $worksheet1->write_string($startRow+$excelRowCounter+1, $excelColCounter+1, "Domain",$formatRHD);

        $SQLAset = "select ref_aset.*,
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
                    from   ref_aset
                            left join ref_aset_grup on astgrp_id = ast_id_grupaset
                            left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
                            left join ref_satker on ref_satker_id = pngjwb_id_satker
                    ".$wSQL."

                    order by astgrp_label, ast_label
                    ";
        $rhAset  = $this->dbH->query($SQLAset);
        $asetCounter = 0;
        while ($rrAset = $rhAset->fetch()) {

            $excelRowCounter++;
            $asetCounter++;

            $worksheet1->write_string($startRow+$excelRowCounter+1, 0, $asetCounter,$formatC);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 1, $rrAset['astgrp_label'],$formatC);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 2, $rrAset['ast_label'],$formatC);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 3, $rrAset['ast_kode_bmn'],$formatC);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 4, $rrAset['ref_satker_label'],$formatC);
            $worksheet1->write_string($startRow+$excelRowCounter+1, 5, $rrAset['pngjwb_label'].' ('.$rrAset['pngjwb_email'].')',$formatC);

            $excelColCounter = 6;
            reset($arrayColSpec);
            while (list($key, $val) = each($arrayColSpec)) {

                if ($val > 0) {
                    $SQL5 = "select * from ref_aset_spesifikasi where astspk_id_aset = '".$rrAset['ast_id']."' and astspk_id_grup_spek = '".$val."' ";
                    $rh5 = $this->dbH->query($SQL5);
                    $rr5 = $rh5->fetch();

                    $worksheet1->write_string($startRow+$excelRowCounter+1, $excelColCounter, $rr5['astspk_value_text'],$formatC);
                }

                $excelColCounter++;
            }

            $worksheet1->write_string($startRow+$excelRowCounter+1, $excelColCounter, $rrAset['infoip'],$formatC);
            $worksheet1->write_string($startRow+$excelRowCounter+1, $excelColCounter+1, $rrAset['infodomain'],$formatC);

        }

        $workbook->close();

        die();
    }

    function detailSpekPdf($tmp = '') {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $pdfTitle = "Inventaris Data Center";
        $pdfSubTitle = "Kementerian Komunikasi dan Informatika";

        require_once('./tcpdf/tcpdf.php');

        $pdf = new TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);

        // set document information
        $pdf->SetCreator('Inventaris Data Center');
        $pdf->SetAuthor('Kementerian Komunikasi dan Informatika');
        $pdf->SetTitle($pdfTitle);

        // set default header data
        $pdf->SetHeaderData('images/logo_kominfo.jpg', 10, $pdfTitle, $pdfSubTitle, array(0,64,255), array(0,64,128));
        $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

        // set margins
        //$pdf->SetMargins(PDF_MARGIN_LEFT, 25, PDF_MARGIN_RIGHT);
        $pdf->SetMargins(10, 25, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(10);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

        // set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        // set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

        $pdf->AddPage();

        $pdf->SetFont('helvetica', '', 8, '', true);

        if (($idast == 0) && ($this->getVar('rNum') > 0)) {
            $idast = $this->getVar('rNum');
        }

        $SQLAset = "select *
                    from   ref_aset
                    where  ast_id = '".$idast."'
                    ";
        $rhAset  = $this->dbH->query($SQLAset);
        $rrAset  = $rhAset->fetch();

        $html  = '';
        $html .= '<H2 align="center">Spesifikasi Aset<br>'.($rrAset['ast_label']).' ('.($rrAset['ast_kode_bmn']).')</H2>';

        $html .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
        $html .= '<tr>';
        $html .= ' <td width="3%" align="center" valign="top">No</td>';
        $html .= ' <td width="35%" align="center" valign="top">Spesifikasi</td>';
        $html .= ' <td width="20%" align="center" valign="top">Nilai</td>';
        $html .= ' <td width="10%" align="center" valign="top">Satuan</td>';
        $html .= ' <td width="37%" align="center" valign="top">Penjelasan</td>';
        $html .= '</tr>';

        $SQL2 = " select astspk_id as id,
                         astspk_id,
                         astgrpspek_label,
                         astspk_value_text,
                         astgrpspek_satuan,
                         astgrpspek_keterangan
                  from   ref_aset_spesifikasi, ref_aset_grup_spek
                  where  astgrpspek_id = astspk_id_grup_spek and
                         astspk_id_aset = '".$idast."'
                  order by astgrpspek_urutan, astgrpspek_label
                  ";
        $rh2 = $this->dbH->query($SQL2);
        $functDB->dberror_show($rh2);
        while ($rr2 = $rh2->fetch()) {

            $rowCounter++;
            $html .= '<tr>';
            $html .= ' <td align="center" valign="top">'.$rowCounter.'.&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['astgrpspek_label']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['astspk_value_text']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['astgrpspek_satuan']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['astgrpspek_keterangan']).'&nbsp;</td>';
            $html .= '</tr>';
        }

        $html .= '</table>';


        $filename = 'rep_aset_spek_'.date('dmy_His').'.pdf';
        $fullfilename = './tmpPdf/'.$filename;

        $html .= '<BR><BR>'.$filename.' dicetak oleh '.$member['userName'].' pada '.date('d M Y H:i:s');

        $pdf->writeHTML($html);

        $pdf->Output($fullfilename, 'F');
        $pdf->Output($fullfilename, 'I');
        die();

    }

    function detailLokasiPdf($tmp = '') {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
//die(print_r($member).'--'.print_r($_GET));
        $pdfTitle = "Inventaris Data Center";
        $pdfSubTitle = "Kementerian Komunikasi dan Informatika";

        require_once('./tcpdf/tcpdf.php');

        $pdf = new TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);

        // set document information
        $pdf->SetCreator('Inventaris Data Center');
        $pdf->SetAuthor('Kementerian Komunikasi dan Informatika');
        $pdf->SetTitle($pdfTitle);

        // set default header data
        $pdf->SetHeaderData('images/logo_kominfo.jpg', 10, $pdfTitle, $pdfSubTitle, array(0,64,255), array(0,64,128));
        $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

        // set margins
        //$pdf->SetMargins(PDF_MARGIN_LEFT, 25, PDF_MARGIN_RIGHT);
        $pdf->SetMargins(10, 25, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(10);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

        // set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        // set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

        $pdf->AddPage();

        $pdf->SetFont('helvetica', '', 8, '', true);

        if (($idast == 0) && ($this->getVar('rNum') > 0)) {
            $idast = $this->getVar('rNum');
        }

        $SQLAset = "select *
                    from   ref_aset
                    where  ast_id = '".$idast."'
                    ";
        $rhAset  = $this->dbH->query($SQLAset);
        $rrAset  = $rhAset->fetch();

        $html  = '';
        $html .= '<H2 align="center">Daftar Perpindahan Lokasi Aset<br>'.($rrAset['ast_label']).' ('.($rrAset['ast_kode_bmn']).')</H2>';

        $html .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
        $html .= '<tr>';
        $html .= ' <td width="3%" align="center" valign="top">No</td>';
        $html .= ' <td width="11%" align="center" valign="top">Tanggal</td>';
        $html .= ' <td width="8%" align="center" valign="top">Jam</td>';
        $html .= ' <td width="13%" align="center" valign="top">Lokasi Aset</td>';
        $html .= ' <td width="50%" align="center" valign="top">Alasan Pemindahan</td>';
        $html .= ' <td width="15%" align="center" valign="top">Oleh</td>';
        $html .= '</tr>';

        $SQL2 = " select   trx_lokasi.*,
                           trxloc_id as id,
                           (select loc_label from ref_aset_lokasi where loc_id = trxloc_id_lokasi_sebelumnya) as loksebelum,
                           (select loc_label from ref_aset_lokasi where loc_id = trxloc_id_lokasi_baru) as loksesudah
                  from     trx_lokasi
                  where    trxloc_id_aset = '".$idast."'
                  order by trxloc_tanggal desc, trxloc_waktu desc
                  ";
        $rh2 = $this->dbH->query($SQL2);
        $functDB->dberror_show($rh2);
        while ($rr2 = $rh2->fetch()) {

            $rowCounter++;
            $html .= '<tr>';
            $html .= ' <td align="center" valign="top">'.$rowCounter.'.&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['trxloc_tanggal']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['trxloc_waktu']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['loksesudah']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['trxloc_alasan']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['trxloc_oleh']).'&nbsp;</td>';
            $html .= '</tr>';
        }

        $html .= '</table>';


        $filename = 'rep_aset_lokasi_'.date('dmy_His').'.pdf';
        $fullfilename = './tmpPdf/'.$filename;

        $html .= '<BR><BR>'.$filename.' dicetak oleh '.$member['userName'].' pada '.date('d M Y H:i:s');

        $pdf->writeHTML($html);

        $pdf->Output($fullfilename, 'F');
        $pdf->Output($fullfilename, 'I');
        die();
    }

    function detailKejadianPdf($tmp = '') {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
//die(print_r($member).'--'.print_r($_GET));
        $pdfTitle = "Inventaris Data Center";
        $pdfSubTitle = "Kementerian Komunikasi dan Informatika";

        require_once('./tcpdf/tcpdf.php');

        $pdf = new TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);

        // set document information
        $pdf->SetCreator('Inventaris Data Center');
        $pdf->SetAuthor('Kementerian Komunikasi dan Informatika');
        $pdf->SetTitle($pdfTitle);

        // set default header data
        $pdf->SetHeaderData('images/logo_kominfo.jpg', 10, $pdfTitle, $pdfSubTitle, array(0,64,255), array(0,64,128));
        $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

        // set margins
        //$pdf->SetMargins(PDF_MARGIN_LEFT, 25, PDF_MARGIN_RIGHT);
        $pdf->SetMargins(10, 25, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(10);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

        // set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        // set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

        $pdf->AddPage();

        $pdf->SetFont('helvetica', '', 8, '', true);

        if (($idast == 0) && ($this->getVar('rNum') > 0)) {
            $idast = $this->getVar('rNum');
        }

        $SQLAset = "select *
                    from   ref_aset
                    where  ast_id = '".$idast."'
                    ";
        $rhAset  = $this->dbH->query($SQLAset);
        $rrAset  = $rhAset->fetch();

        $html  = '';
        $html .= '<H2 align="center">Daftar Laporan Kejadian<br>'.($rrAset['ast_label']).' ('.($rrAset['ast_kode_bmn']).')</H2>';

        $html .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
        $html .= '<tr>';
        $html .= ' <td width="3%" align="center" valign="top">No</td>';
        $html .= ' <td width="11%" align="center" valign="top">Tanggal</td>';
        $html .= ' <td width="8%" align="center" valign="top">Jam</td>';
        $html .= ' <td width="13%" align="center" valign="top">Jenis</td>';
        $html .= ' <td width="50%" align="center" valign="top">Keterangan</td>';
        $html .= ' <td width="15%" align="center" valign="top">Oleh</td>';
        $html .= '</tr>';

        $SQL2 = " select   trx_kejadian.*,
                           trxkej_id as id,
                           jnskej_label
                  from     trx_kejadian
                             left join ref_kejadian_jenis on jnskej_id = trxkej_id_kej
                  where    trxkej_id_aset = '".$idast."'
                  order by trxkej_tanggal desc, trxkej_waktu desc
                  ";
        $rh2 = $this->dbH->query($SQL2);
        $functDB->dberror_show($rh2);
        while ($rr2 = $rh2->fetch()) {

            $rowCounter++;
            $html .= '<tr>';
            $html .= ' <td align="center" valign="top">'.$rowCounter.'.&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['trxkej_tanggal']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['trxkej_waktu']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['jnskej_label']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['trxkej_keterangan']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['trxkej_oleh']).'&nbsp;</td>';
            $html .= '</tr>';
        }

        $html .= '</table>';


        $filename = 'rep_aset_kejadian_'.date('dmy_His').'.pdf';
        $fullfilename = './tmpPdf/'.$filename;

        $html .= '<BR><BR>'.$filename.' dicetak oleh '.$member['userName'].' pada '.date('d M Y H:i:s');

        $pdf->writeHTML($html);

        $pdf->Output($fullfilename, 'F');
        $pdf->Output($fullfilename, 'I');
        die();
    }

    function detailPerubahanPdf($tmp = '') {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
//die(print_r($member).'--'.print_r($_GET));
        $pdfTitle = "Inventaris Data Center";
        $pdfSubTitle = "Kementerian Komunikasi dan Informatika";

        require_once('./tcpdf/tcpdf.php');

        $pdf = new TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);

        // set document information
        $pdf->SetCreator('Inventaris Data Center');
        $pdf->SetAuthor('Kementerian Komunikasi dan Informatika');
        $pdf->SetTitle($pdfTitle);

        // set default header data
        $pdf->SetHeaderData('images/logo_kominfo.jpg', 10, $pdfTitle, $pdfSubTitle, array(0,64,255), array(0,64,128));
        $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

        // set margins
        //$pdf->SetMargins(PDF_MARGIN_LEFT, 25, PDF_MARGIN_RIGHT);
        $pdf->SetMargins(10, 25, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(10);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

        // set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        // set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

        $pdf->AddPage();

        $pdf->SetFont('helvetica', '', 8, '', true);

        if (($idast == 0) && ($this->getVar('rNum') > 0)) {
            $idast = $this->getVar('rNum');
        }

        $SQLAset = "select *
                    from   ref_aset
                    where  ast_id = '".$idast."'
                    ";
        $rhAset  = $this->dbH->query($SQLAset);
        $rrAset  = $rhAset->fetch();

        $html  = '';
        $html .= '<H2 align="center">Daftar Laporan Kejadian<br>'.($rrAset['ast_label']).' ('.($rrAset['ast_kode_bmn']).')</H2>';

        $html .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
        $html .= '<tr>';
        $html .= ' <td width="3%" align="center" valign="top">No</td>';
        $html .= ' <td width="11%" align="center" valign="top">Tanggal</td>';
        $html .= ' <td width="8%" align="center" valign="top">Jam</td>';
        $html .= ' <td width="63%" align="center" valign="top">Catatan Perubahan</td>';
        $html .= ' <td width="15%" align="center" valign="top">Oleh</td>';
        $html .= '</tr>';

        $SQL2 = "select   *,
                           logubah_id as id
                  from     log_perubahan
                  where    logubah_id_aset = '".$idast."'
                  order by logubah_tanggal desc, logubah_waktu desc
                  ";
        $rh2 = $this->dbH->query($SQL2);
        $functDB->dberror_show($rh2);
        while ($rr2 = $rh2->fetch()) {

            $rowCounter++;
            $html .= '<tr>';
            $html .= ' <td align="center" valign="top">'.$rowCounter.'.&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['logubah_tanggal']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['logubah_waktu']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['logubah_catatan']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['logubah_oleh']).'&nbsp;</td>';
            $html .= '</tr>';
        }

        $html .= '</table>';


        $filename = 'rep_aset_perubahan_'.date('dmy_His').'.pdf';
        $fullfilename = './tmpPdf/'.$filename;

        $html .= '<BR><BR>'.$filename.' dicetak oleh '.$member['userName'].' pada '.date('d M Y H:i:s');

        $pdf->writeHTML($html);

        $pdf->Output($fullfilename, 'F');
        $pdf->Output($fullfilename, 'I');
        die();
    }

    function formDomainPdf($tmp = '') {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $pdfTitle = "Inventaris Data Center";
        $pdfSubTitle = "Kementerian Komunikasi dan Informatika";

        require_once('./tcpdf/tcpdf.php');

        $pdf = new TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);

        // set document information
        $pdf->SetCreator('Inventaris Data Center');
        $pdf->SetAuthor('Kementerian Komunikasi dan Informatika');
        $pdf->SetTitle($pdfTitle);

        // set default header data
        $pdf->SetHeaderData('images/logo_kominfo.jpg', 10, $pdfTitle, $pdfSubTitle, array(0,64,255), array(0,64,128));
        $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

        // set margins
        //$pdf->SetMargins(PDF_MARGIN_LEFT, 25, PDF_MARGIN_RIGHT);
        $pdf->SetMargins(10, 25, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(10);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

        // set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        // set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

        $pdf->AddPage();

        $pdf->SetFont('helvetica', '', 8, '', true);

        $wSQL = '';
        $searchLabel = "";
        if ($_GET['fR'] == 1) {

            if (strlen(trim($_GET['fNama'])) > 0) {
                $wSQL .= " and (lower(domain_label) like '%".strtolower(trim($_GET['fNama']))."%') ";
                $searchLabel .= "Domain mengandung kata ".$_GET['fNama'].". ";
            }
            if (strlen(trim($_GET['fUntuk'])) > 0) {
                $wSQL .= " and (lower(domain_peruntukan) like '%".strtolower(trim($_GET['fUntuk']))."%') ";
                $searchLabel .= "Peruntukan mengandung kata ".$_GET['fNama'].". ";
            }
            if (strlen(trim($_GET['fIP'])) > 0) {
                $wSQL .= " and (lower(get_domain_ip(domain_id)) like '".strtolower(trim($_GET['fIP']))."%') ";
                $searchLabel .= "IP Address = ".$_GET['fIP'].". ";
            }
            if ($_GET['fPng'] > 0) {
                $wSQL .= " and (domain_tanggungjawab_id = '".$_GET['fPng']."') ";

                $SQLZona = " select * from ref_penanggungjawab where pngjwb_id = '".$_GET['fPng']."' ";
                $rhZona  = $this->dbH->query($SQLZona);
                $rrZona  = $rhZona->fetch();

                $searchLabel .= "Penanggung Jawab = ".$rrZona['pngjwb_label'].". ";
            }
            if ($_GET['fSatker'] > 0) {
                $wSQL .= " and (ref_satker_id = '".$_GET['fSatker']."') ";
                
                $SQLCekInput = "select * from ref_satker where ref_satker_id = '".$_GET['fSatker']."' ";
                $rhCekInput = $this->dbH->query($SQLCekInput);
                $rrCekInput = $rhCekInput->fetch();

                $searchLabel .= "Satuan Kerja = ".$rrCekInput['ref_satker_label'].". ";
            }
            if ($_GET['fZona'] > 0) {
                $wSQL .= " and (domain_id_zona = '".$_GET['fZona']."') ";

                $SQLZona = " select * from ref_zona where jnszona_id = '".$_GET['fZona']."' ";
                $rhZona  = $this->dbH->query($SQLZona);
                $rrZona  = $rhZona->fetch();

                $searchLabel .= "Zona = ".$rrZona['jnszona_label'].". ";
            }
        }
        if (strlen(trim($wSQL))>0) {
            $wSQL = ' where 1 '.$wSQL;
            $searchLabel = 'Filter data : '.$searchLabel;
        }

        $html  = '';
        $html .= '<H2 align="center">DAFTAR DOMAIN</H2>';

        $html .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
        $html .= '<tr>';
        $html .= ' <td width="5%" align="center" valign="top">No</td>';
        $html .= ' <td width="10%" align="center" valign="top">Zona</td>';
        $html .= ' <td width="15%" align="center" valign="top">Domain</td>';
        $html .= ' <td width="15%" align="center" valign="top">Peruntukan</td>';
        $html .= ' <td width="12%" align="center" valign="top">IP</td>';
        $html .= ' <td width="13%" align="center" valign="top">Aset</td>';
        $html .= ' <td width="15%" align="center" valign="top">Satuan Kerja</td>';
        $html .= ' <td width="15%" align="center" valign="top">Penanggung Jawab</td>';
        $html .= '</tr>';
        $SQL2 = " select   ref_domain.*,
                           domain_id as id,
                           case when ref_domain.ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                           jnszona_label,
                           jnszona_kode,
                           pngjwb_label as tanggungjawab,
                           pngjwb_telp,
                           pngjwb_email,
                           ref_satker_label,
                           get_domain_ip(domain_id) as ip_adr,
                           get_domain_aset2(domain_id) as aset
                  from     ref_domain
                             left join ref_zona on jnszona_id = domain_id_zona
                             left join ref_penanggungjawab on pngjwb_id = domain_tanggungjawab_id
                             left join ref_satker on ref_satker_id = pngjwb_id_satker
                  ".$wSQL."
                  order by domain_label
                  ";
        $rh2 = $this->dbH->query($SQL2);
        $functDB->dberror_show($rh2);
        while ($rr2 = $rh2->fetch()) {

            $rowCounter++;
            $html .= '<tr>';
            $html .= ' <td align="center" valign="top">'.($rowCounter).'.&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.(str_replace('ZONA ','',$rr2['jnszona_label'])).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['domain_label']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['domain_peruntukan']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['ip_adr']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.trim($rr2['aset']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['ref_satker_label']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['tanggungjawab']).'<BR>'.$rr2['pngjwb_email'].'&nbsp;</td>';
            $html .= '</tr>';
        }

        $html .= '</table><BR>'.$searchLabel;


        $filename = 'rep_domain_'.date('dmy_His').'.pdf';
        $fullfilename = './tmpPdf/'.$filename;

        $html .= '<BR><BR>'.$filename.' dicetak oleh '.$member['userName'].' pada '.date('d M Y H:i:s');

        $pdf->writeHTML($html);

        $pdf->Output($fullfilename, 'F');
        $pdf->Output($fullfilename, 'I');
        die();

    }

    function formDomainExcel() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        ob_end_clean();

        require_once('./excelClass/Worksheet.php');
        require_once('./excelClass/Workbook.php');

        $member =  $this->sessionH->getMemberData();
        $filename = 'excel_domain_'.date('dmyhis').'.xls';

        header("Content-type: application/vnd.ms-excel");
        header("Content-Disposition: attachment; filename=".$filename );
        header("Expires: 0");
        header("Cache-Control: must-revalidate, post-check=0,pre-check=0");
        header("Pragma: public");

        // Creating a workbook
        $workbook = new Workbook("-");

        // Creating the first worksheet
        $worksheet1 =& $workbook->add_worksheet('Domain');

        $formatHD =& $workbook->add_format();
        $formatHD->set_size(14);
        $formatHD->set_bold(1);
        $formatHD->set_align('left');
        $formatHD->set_color('black');

        $formatHD1 =& $workbook->add_format();
        $formatHD1->set_size(12);
        $formatHD1->set_bold(1);
        $formatHD1->set_align('left');
        $formatHD1->set_color('black');

        $formatHD2 =& $workbook->add_format();
        $formatHD2->set_size(10);
        $formatHD2->set_bold(1);
        $formatHD2->set_align('left');
        $formatHD2->set_color('black');

        $formatRHD =& $workbook->add_format();
        $formatRHD->set_size(10);
        $formatRHD->set_bold(1);
        $formatRHD->set_align('left');
        $formatRHD->set_color('white');
        $formatRHD->set_pattern();
        $formatRHD->set_fg_color('black');
        $formatRHD->set_bottom(1);
        $formatRHD->set_top(1);
        $formatRHD->set_left(1);
        $formatRHD->set_right(1);

        $formatC =& $workbook->add_format();
        $formatC->set_size(10);
        $formatC->set_align('left');
        $formatC->set_color('black');
        $formatC->set_left(1);
        $formatC->set_right(1);
        $formatC->set_bottom(1);

        $formatCNC =& $workbook->add_format();
        $formatCNC->set_size(10);
        $formatCNC->set_align('left');
        $formatCNC->set_color('black');
        $formatCNC->set_left(1);
        $formatCNC->set_right(0);

        $formatCC =& $workbook->add_format();
        $formatCC->set_size(10);
        $formatCC->set_align('center');
        $formatCC->set_color('black');
        $formatCC->set_left(1);
        $formatCC->set_right(1);

        $formatCR =& $workbook->add_format();
        $formatCR->set_size(10);
        $formatCR->set_align('right');
        $formatCR->set_color('black');
        $formatCR->set_left(1);
        $formatCR->set_right(1);

        $formatECR =& $workbook->add_format();
        $formatECR->set_size(10);
        $formatECR->set_align('right');
        $formatECR->set_color('black');
        $formatECR->set_pattern();
        $formatECR->set_fg_color('yellow');
        $formatECR->set_left(1);
        $formatECR->set_right(1);

        $formatECL =& $workbook->add_format();
        $formatECL->set_size(10);
        $formatECL->set_align('left');
        $formatECL->set_color('black');
        $formatECL->set_pattern();
        $formatECL->set_fg_color('yellow');
        $formatECL->set_left(1);
        $formatECL->set_right(1);

        $formatB =& $workbook->add_format();
        $formatB->set_size(10);
        $formatB->set_align('left');
        $formatB->set_color('white');
        $formatB->set_pattern();
        $formatB->set_fg_color('black');
        $formatB->set_top(1);
        $formatB->set_bold(1);
        $formatB->set_bottom(1);

        $formatB1 =& $workbook->add_format();
        $formatB1->set_size(10);
        $formatB1->set_align('right');
        $formatB1->set_color('white');
        $formatB1->set_pattern();
        $formatB1->set_fg_color('black');
        $formatB1->set_top(1);
        $formatB1->set_bold(1);
        $formatB1->set_bottom(1);

        $formatBL =& $workbook->add_format();
        $formatBL->set_size(10);
        $formatBL->set_align('left');
        $formatBL->set_color('white');
        $formatBL->set_pattern();
        $formatBL->set_fg_color('black');
        $formatBL->set_top(1);
        $formatBL->set_bold(1);
        $formatBL->set_bottom(1);
        $formatBL->set_left(1);

        $formatBR =& $workbook->add_format();
        $formatBR->set_size(10);
        $formatBR->set_align('left');
        $formatBR->set_color('white');
        $formatBR->set_pattern();
        $formatBR->set_fg_color('black');
        $formatBR->set_top(1);
        $formatBR->set_bold(1);
        $formatBR->set_bottom(1);
        $formatBR->set_right(1);

        $worksheet1->set_column(1, 0, 4);
        $worksheet1->set_column(1, 1, 15);
        $worksheet1->set_column(1, 2, 50);
        $worksheet1->set_column(1, 3, 20);
        $worksheet1->set_column(1, 4, 20);
        $worksheet1->set_column(1, 5, 20);
        $worksheet1->set_column(1, 6, 10);
        $worksheet1->set_column(1, 7, 10);

        $wSQL = '';
        $searchLabel = "";
        if ($_GET['fR'] == 1) {

            if (strlen(trim($_GET['fNama'])) > 0) {
                $wSQL .= " and (lower(domain_label) like '%".strtolower(trim($_GET['fNama']))."%') ";
                $searchLabel .= "Domain mengandung kata ".$_GET['fNama'].". ";
            }
            if (strlen(trim($_GET['fUntuk'])) > 0) {
                $wSQL .= " and (lower(domain_peruntukan) like '%".strtolower(trim($_GET['fUntuk']))."%') ";
                $searchLabel .= "Peruntukan mengandung kata ".$_GET['fNama'].". ";
            }
            if (strlen(trim($_GET['fIP'])) > 0) {
                $wSQL .= " and (lower(get_domain_ip(domain_id)) like '".strtolower(trim($_GET['fIP']))."%') ";
                $searchLabel .= "IP Address = ".$_GET['fIP'].". ";
            }
            if ($_GET['fPng'] > 0) {
                $wSQL .= " and (domain_tanggungjawab_id = '".$_GET['fPng']."') ";

                $SQLZona = " select * from ref_penanggungjawab where pngjwb_id = '".$_GET['fPng']."' ";
                $rhZona  = $this->dbH->query($SQLZona);
                $rrZona  = $rhZona->fetch();

                $searchLabel .= "Penanggung Jawab = ".$rrZona['pngjwb_label'].". ";
            }
            if ($_GET['fSatker'] > 0) {
                $wSQL .= " and (ref_satker_id = '".$_GET['fSatker']."') ";
                
                $SQLCekInput = "select * from ref_satker where ref_satker_id = '".$_GET['fSatker']."' ";
                $rhCekInput = $this->dbH->query($SQLCekInput);
                $rrCekInput = $rhCekInput->fetch();

                $searchLabel .= "Satuan Kerja = ".$rrCekInput['ref_satker_label'].". ";
            }
            if ($_GET['fZona'] > 0) {
                $wSQL .= " and (domain_id_zona = '".$_GET['fZona']."') ";

                $SQLZona = " select * from ref_zona where jnszona_id = '".$_GET['fZona']."' ";
                $rhZona  = $this->dbH->query($SQLZona);
                $rrZona  = $rhZona->fetch();

                $searchLabel .= "Zona = ".$rrZona['jnszona_label'].". ";
            }
        }
        if (strlen(trim($wSQL))>0) {
            $wSQL = ' where 1 '.$wSQL;
            $searchLabel = 'Filter data : '.$searchLabel;
        }

        $worksheet1->write_string(0, 0, "Inventaris Data Center",$formatHD1);
        $worksheet1->write_string(1, 0, "Kementerian Komunikasi dan Informatika",$formatHD1);
        $worksheet1->write_string(3, 0, "Daftar Domain",$formatHD1);
        $worksheet1->write_string(4, 0, "Didownload oleh ".$member['userName'].", tanggal generate ".date('d F Y H:i:s'),$formatHD2);
        $worksheet1->write_string(5, 0, $searchLabel,$formatHD2);

        $worksheet1->write_string(6, 0, "No",$formatRHD);
        $worksheet1->write_string(6, 1, "Zona",$formatRHD);
        $worksheet1->write_string(6, 2, "Domain",$formatRHD);
        $worksheet1->write_string(6, 3, "Peruntukan",$formatRHD);
        $worksheet1->write_string(6, 4, "Keterangan",$formatRHD);
        $worksheet1->write_string(6, 5, "IP",$formatRHD);
        $worksheet1->write_string(6, 6, "Aset",$formatRHD);
        $worksheet1->write_string(6, 7, "Satuan Kerja",$formatRHD);
        $worksheet1->write_string(6, 8, "Penanggung Jawab",$formatRHD);
        $worksheet1->write_string(6, 9, "Kontak Person",$formatRHD);

        $SQL2  = " select   ref_domain.*,
                           domain_id as id,
                           case when ref_domain.ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                           jnszona_label,
                           jnszona_kode,
                           pngjwb_label as tanggungjawab,
                           pngjwb_telp,
                           pngjwb_email,
                           ref_satker_label,
                           get_domain_ip(domain_id) as ip_adr,
                           get_domain_aset2(domain_id) as aset
                  from     ref_domain
                             left join ref_zona on jnszona_id = domain_id_zona
                             left join ref_penanggungjawab on pngjwb_id = domain_tanggungjawab_id
                             left join ref_satker on ref_satker_id = pngjwb_id_satker
                               ".$wSQL."
                  order by domain_label
                  ";
        $rh2 = $this->dbH->query($SQL2);
        $functDB->dberror_show($rh2);
        $excelRowCounter = 0;
        while ($rr2 = $rh2->fetch()) {
            $excelRowCounter++;

            $worksheet1->write_number(6+$excelRowCounter, 0, $excelRowCounter,$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 1, $rr2['jnszona_label'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 2, $rr2['domain_label'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 3, $rr2['domain_peruntukan'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 4, $rr2['domain_keterangan'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 5, $rr2['ip_adr'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 6, $rr2['aset'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 7, $rr2['ref_satker_label'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 8, $rr2['tanggungjawab'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 9, $rr2['pngjwb_email'],$formatC);

        }

        $workbook->close();

        die();
    }

    function formIPPdf($tmp = '') {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $pdfTitle = "Inventaris Data Center";
        $pdfSubTitle = "Kementerian Komunikasi dan Informatika";

        require_once('./tcpdf/tcpdf.php');

        $pdf = new TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);

        // set document information
        $pdf->SetCreator('Inventaris Data Center');
        $pdf->SetAuthor('Kementerian Komunikasi dan Informatika');
        $pdf->SetTitle($pdfTitle);

        // set default header data
        $pdf->SetHeaderData('images/logo_kominfo.jpg', 10, $pdfTitle, $pdfSubTitle, array(0,64,255), array(0,64,128));
        $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

        // set margins
        //$pdf->SetMargins(PDF_MARGIN_LEFT, 25, PDF_MARGIN_RIGHT);
        $pdf->SetMargins(10, 25, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(10);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

        // set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        // set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

        $pdf->AddPage();

        $pdf->SetFont('helvetica', '', 8, '', true);

        $wSQL = '';
        if ($_GET['fR'] == 1) {

            $octet = array();
            $soctet = array();

            $octet[0] = 0;
            $octet[1] = 0;
            $octet[2] = 0;
            $octet[3] = 0;

            $soctet[0] = 255;
            $soctet[1] = 255;
            $soctet[2] = 255;
            $soctet[3] = 255;

            if (strlen(trim($_GET['fMulai'])) > 0) {

                $startOctet = explode('.',$_GET['fMulai']);

                if (($startOctet[0] > 0) && ($startOctet[0] <= 255)) {
                    $octet[0] = $startOctet[0];
                }
                else {
                    $octet[0] = 0;
                }

                if (($startOctet[1] > 0) && ($startOctet[1] <= 255)) {
                    $octet[1] = $startOctet[1];
                }
                else {
                    $octet[1] = 0;
                }

                if (($startOctet[2] > 0) && ($startOctet[2] <= 255)) {
                    $octet[2] = $startOctet[2];
                }
                else {
                    $octet[2] = 0;
                }

                if (($startOctet[3] > 0) && ($startOctet[3] <= 255)) {
                    $octet[3] = $startOctet[3];
                }
                else {
                    $octet[3] = 0;
                }

                $startOctetFinal = $octet[0].'.'.$octet[1].'.'.$octet[2].'.'.$octet[3];

                $searchLabel .= "IP = ".$_GET['fMulai'].". (".$startOctetFinal."). ";
            }
            else {
                $startOctetFinal = '0.0.0.0';
            }
            if (strlen(trim($_GET['fSelesai'])) > 0) {

                $soctet = explode('.',$_GET['fSelesai']);

                if (($soctet[0] > 0) && ($soctet[0] <= 255)) {
                    $soctet[0] = $soctet[0];
                }
                else {
                    $soctet[0] = 0;
                }

                if (($soctet[1] > 0) && ($soctet[1] <= 255)) {
                    $soctet[1] = $soctet[1];
                }
                else {
                    $soctet[1] = 0;
                }

                if (($soctet[2] > 0) && ($soctet[2] <= 255)) {
                    $soctet[2] = $soctet[2];
                }
                else {
                    $soctet[2] = 0;
                }

                if (($soctet[3] > 0) && ($soctet[3] <= 255)) {
                    $soctet[3] = $soctet[3];
                }
                else {
                    $soctet[3] = 0;
                }

                $endOctetFinal = $soctet[0].'.'.$soctet[1].'.'.$soctet[2].'.'.$soctet[3];

                $searchLabel .= "IP sampai dengan ".$_GET['fSelesai']." (".$endOctetFinal."). ";
            }
            else {
                if (strlen(trim($_GET['fMulai'])) > 0) {
                    $endOctetFinal = $startOctetFinal;
                }
                else {
                    $endOctetFinal = '255.255.255.255';
                }
            }
            if ($_GET['fJenis'] == 1) {

                $searchLabel2 .= "Hanya menampilkan IP Private. ";
                $wSQL2 = " and ((INET_ATON(ip_number) BETWEEN INET_ATON('10.0.0.0') AND INET_ATON('10.255.255.255')) and
                          (INET_ATON(ip_number) BETWEEN INET_ATON('172.16.0.0') AND INET_ATON('172.31.255.255')) and
                          (INET_ATON(ip_number) BETWEEN INET_ATON('192.168.0.0') AND INET_ATON('192.168.255.255'))) ";
            }
            if ($_GET['fJenis'] == 2) {

                $searchLabel2 .= "Hanya menampilkan IP Public. ";
                $wSQL2 = " and ((INET_ATON(ip_number) not BETWEEN INET_ATON('10.0.0.0') AND INET_ATON('10.255.255.255')) and
                          (INET_ATON(ip_number) not BETWEEN INET_ATON('172.16.0.0') AND INET_ATON('172.31.255.255')) and
                          (INET_ATON(ip_number) not BETWEEN INET_ATON('192.168.0.0') AND INET_ATON('192.168.255.255'))) ";
            }
            if ($_GET['fPeta'] == 1) {
                $searchLabel3 = "Hanya yang sudah dipetakan ke domain dan aset. ";
            }
            if ($_GET['fPeta'] == 2) {
                $searchLabel3 = "Hanya yang sudah dipetakan ke aset. ";
            }
            if ($_GET['fPeta'] == 3) {
                $searchLabel3 = "Hanya yang sudah dipetakan ke domain. ";
            }
            if ($_GET['fPeta'] == 4) {
                $searchLabel3 = "Hanya yang belum dipetakan ke aset ataupun domain. ";
            }
        }
        if (strlen(trim($searchLabel))>0) {
            $wSQL = " WHERE (INET_ATON(ip_number) BETWEEN INET_ATON('".$startOctetFinal."') AND INET_ATON('".$endOctetFinal."')) ";
            $searchLabel = 'Filter data : '.$searchLabel;

            if (strlen(trim($searchLabel2))>0) {
                $wSQL = $wSQL . $wSQL2;
                $searchLabel = $searchLabel . $searchLabel2 . $searchLabel3;
            }
        }
        elseif (strlen(trim($searchLabel2))>0) {
            $wSQL = " WHERE 1 ". $wSQL2;
            $searchLabel = $searchLabel . $searchLabel2 . $searchLabel3;
        }
        elseif (strlen(trim($searchLabel3))>0) {
            $searchLabel = $searchLabel . $searchLabel2 . $searchLabel3;
        }

        $html  = '';
        $html .= '<H2 align="center">DAFTAR IP ADDRESS</H2>';

        $html .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
        $html .= '<tr>';
        $html .= ' <td width="5%" align="center" valign="top">No</td>';
        $html .= ' <td width="25%" align="center" valign="top">IP ADDRESS</td>';
        $html .= ' <td width="35%" align="center" valign="top">Pemetaan Ke Server</td>';
        $html .= ' <td width="35%" align="center" valign="top">Pemetaan Ke Domain</td>';
        $html .= '</tr>';
        $SQL2 = " select   ref_ip.*,
                           ip_id as id,
                           case when ref_ip.ref_stat_visible = 1 then 'Ya' else 'Tidak' end as status_visible
                  from     ref_ip
                              ".$wSQL."
                  order by INET_ATON(ip_number)
                  ";
        $rh2 = $this->dbH->query($SQL2);
        $functDB->dberror_show($rh2);
        while ($rr2 = $rh2->fetch()) {

            $domainmap = 0;
            $ipmap = 0;

            $aset_info = '';
            $SQL3 = " select * from ref_aset_ipmap, ref_aset where map_id_ip = '".$rr2['ip_id']."' and map_id_aset = ast_id order by ast_label ";
            $rh3 = $this->dbH->query($SQL3);
            while ($rr3 = $rh3->fetch()) {
                $aset_info .= $rr3['ast_label'].', ';
                $ipmap = 1;
            }
            if (strlen(trim($aset_info))>0) {
                $aset_info = substr($aset_info,0,(strlen($aset_info)-2));
            }

            $domain_info = '';
            $SQL4 = " select * from ref_domain_ipmap, ref_domain where map_id_ip = '".$rr2['ip_id']."' and map_id_domain = domain_id order by domain_label ";
            $rh4 = $this->dbH->query($SQL4);
            while ($rr4 = $rh4->fetch()) {
                $domain_info .= $rr4['domain_label'].', ';
                $domainmap = 1;
            }
            if (strlen(trim($domain_info))>0) {
                $domain_info = substr($domain_info,0,(strlen($domain_info)-2));
            }

            if (($_GET['fPeta'] == 2) && ($ipmap == 0)) {
                continue;
            }
            if (($_GET['fPeta'] == 3) && ($domainmap == 0)) {
                continue;
            }
            if (($_GET['fPeta'] == 1) && ($ipmap == 0) && ($domainmap == 0)) {
                continue;
            }
            if (($_GET['fPeta'] == 4) && (($ipmap > 0) || ($domainmap > 0))) {
                continue;
            }

            $rowCounter++;
            $html .= '<tr>';
            $html .= ' <td align="center" valign="top">'.($rowCounter).'.&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['ip_number']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($aset_info).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($domain_info).'&nbsp;</td>';
            $html .= '</tr>';
        }

        $html .= '</table><BR>'.$searchLabel;

        $filename = 'rep_ip_'.date('dmy_His').'.pdf';
        $fullfilename = './tmpPdf/'.$filename;

        $html .= '<BR><BR>'.$filename.' dicetak oleh '.$member['userName'].' pada '.date('d M Y H:i:s');

        $pdf->writeHTML($html);

        $pdf->Output($fullfilename, 'F');
        $pdf->Output($fullfilename, 'I');
        die();

    }

    function formIPExcel() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        ob_end_clean();

        require_once('./excelClass/Worksheet.php');
        require_once('./excelClass/Workbook.php');

        $member =  $this->sessionH->getMemberData();
        $filename = 'excel_ip_'.date('dmyhis').'.xls';

        header("Content-type: application/vnd.ms-excel");
        header("Content-Disposition: attachment; filename=".$filename );
        header("Expires: 0");
        header("Cache-Control: must-revalidate, post-check=0,pre-check=0");
        header("Pragma: public");

        // Creating a workbook
        $workbook = new Workbook("-");

        // Creating the first worksheet
        $worksheet1 =& $workbook->add_worksheet('IP Address');

        $formatHD =& $workbook->add_format();
        $formatHD->set_size(14);
        $formatHD->set_bold(1);
        $formatHD->set_align('left');
        $formatHD->set_color('black');

        $formatHD1 =& $workbook->add_format();
        $formatHD1->set_size(12);
        $formatHD1->set_bold(1);
        $formatHD1->set_align('left');
        $formatHD1->set_color('black');

        $formatHD2 =& $workbook->add_format();
        $formatHD2->set_size(10);
        $formatHD2->set_bold(1);
        $formatHD2->set_align('left');
        $formatHD2->set_color('black');

        $formatRHD =& $workbook->add_format();
        $formatRHD->set_size(10);
        $formatRHD->set_bold(1);
        $formatRHD->set_align('left');
        $formatRHD->set_color('white');
        $formatRHD->set_pattern();
        $formatRHD->set_fg_color('black');
        $formatRHD->set_bottom(1);
        $formatRHD->set_top(1);
        $formatRHD->set_left(1);
        $formatRHD->set_right(1);

        $formatC =& $workbook->add_format();
        $formatC->set_size(10);
        $formatC->set_align('left');
        $formatC->set_color('black');
        $formatC->set_left(1);
        $formatC->set_right(1);
        $formatC->set_bottom(1);

        $formatCNC =& $workbook->add_format();
        $formatCNC->set_size(10);
        $formatCNC->set_align('left');
        $formatCNC->set_color('black');
        $formatCNC->set_left(1);
        $formatCNC->set_right(0);

        $formatCC =& $workbook->add_format();
        $formatCC->set_size(10);
        $formatCC->set_align('center');
        $formatCC->set_color('black');
        $formatCC->set_left(1);
        $formatCC->set_right(1);

        $formatCR =& $workbook->add_format();
        $formatCR->set_size(10);
        $formatCR->set_align('right');
        $formatCR->set_color('black');
        $formatCR->set_left(1);
        $formatCR->set_right(1);

        $formatECR =& $workbook->add_format();
        $formatECR->set_size(10);
        $formatECR->set_align('right');
        $formatECR->set_color('black');
        $formatECR->set_pattern();
        $formatECR->set_fg_color('yellow');
        $formatECR->set_left(1);
        $formatECR->set_right(1);

        $formatECL =& $workbook->add_format();
        $formatECL->set_size(10);
        $formatECL->set_align('left');
        $formatECL->set_color('black');
        $formatECL->set_pattern();
        $formatECL->set_fg_color('yellow');
        $formatECL->set_left(1);
        $formatECL->set_right(1);

        $formatB =& $workbook->add_format();
        $formatB->set_size(10);
        $formatB->set_align('left');
        $formatB->set_color('white');
        $formatB->set_pattern();
        $formatB->set_fg_color('black');
        $formatB->set_top(1);
        $formatB->set_bold(1);
        $formatB->set_bottom(1);

        $formatB1 =& $workbook->add_format();
        $formatB1->set_size(10);
        $formatB1->set_align('right');
        $formatB1->set_color('white');
        $formatB1->set_pattern();
        $formatB1->set_fg_color('black');
        $formatB1->set_top(1);
        $formatB1->set_bold(1);
        $formatB1->set_bottom(1);

        $formatBL =& $workbook->add_format();
        $formatBL->set_size(10);
        $formatBL->set_align('left');
        $formatBL->set_color('white');
        $formatBL->set_pattern();
        $formatBL->set_fg_color('black');
        $formatBL->set_top(1);
        $formatBL->set_bold(1);
        $formatBL->set_bottom(1);
        $formatBL->set_left(1);

        $formatBR =& $workbook->add_format();
        $formatBR->set_size(10);
        $formatBR->set_align('left');
        $formatBR->set_color('white');
        $formatBR->set_pattern();
        $formatBR->set_fg_color('black');
        $formatBR->set_top(1);
        $formatBR->set_bold(1);
        $formatBR->set_bottom(1);
        $formatBR->set_right(1);

        $wSQL = '';
        if ($_GET['fR'] == 1) {

            $octet = array();
            $soctet = array();

            $octet[0] = 0;
            $octet[1] = 0;
            $octet[2] = 0;
            $octet[3] = 0;

            $soctet[0] = 255;
            $soctet[1] = 255;
            $soctet[2] = 255;
            $soctet[3] = 255;

            if (strlen(trim($_GET['fMulai'])) > 0) {

                $startOctet = explode('.',$_GET['fMulai']);

                if (($startOctet[0] > 0) && ($startOctet[0] <= 255)) {
                    $octet[0] = $startOctet[0];
                }
                else {
                    $octet[0] = 0;
                }

                if (($startOctet[1] > 0) && ($startOctet[1] <= 255)) {
                    $octet[1] = $startOctet[1];
                }
                else {
                    $octet[1] = 0;
                }

                if (($startOctet[2] > 0) && ($startOctet[2] <= 255)) {
                    $octet[2] = $startOctet[2];
                }
                else {
                    $octet[2] = 0;
                }

                if (($startOctet[3] > 0) && ($startOctet[3] <= 255)) {
                    $octet[3] = $startOctet[3];
                }
                else {
                    $octet[3] = 0;
                }

                $startOctetFinal = $octet[0].'.'.$octet[1].'.'.$octet[2].'.'.$octet[3];

                $searchLabel .= "IP = ".$_GET['fMulai'].". (".$startOctetFinal."). ";
            }
            else {
                $startOctetFinal = '0.0.0.0';
            }
            if (strlen(trim($_GET['fSelesai'])) > 0) {

                $soctet = explode('.',$_GET['fSelesai']);

                if (($soctet[0] > 0) && ($soctet[0] <= 255)) {
                    $soctet[0] = $soctet[0];
                }
                else {
                    $soctet[0] = 0;
                }

                if (($soctet[1] > 0) && ($soctet[1] <= 255)) {
                    $soctet[1] = $soctet[1];
                }
                else {
                    $soctet[1] = 0;
                }

                if (($soctet[2] > 0) && ($soctet[2] <= 255)) {
                    $soctet[2] = $soctet[2];
                }
                else {
                    $soctet[2] = 0;
                }

                if (($soctet[3] > 0) && ($soctet[3] <= 255)) {
                    $soctet[3] = $soctet[3];
                }
                else {
                    $soctet[3] = 0;
                }

                $endOctetFinal = $soctet[0].'.'.$soctet[1].'.'.$soctet[2].'.'.$soctet[3];

                $searchLabel .= "IP sampai dengan ".$_GET['fSelesai']." (".$endOctetFinal."). ";
            }
            else {
                if (strlen(trim($_GET['fMulai'])) > 0) {
                    $endOctetFinal = $startOctetFinal;
                }
                else {
                    $endOctetFinal = '255.255.255.255';
                }
            }
            if ($_GET['fJenis'] == 1) {

                $searchLabel2 .= "Hanya menampilkan IP Private. ";
                $wSQL2 = " and ((INET_ATON(ip_number) BETWEEN INET_ATON('10.0.0.0') AND INET_ATON('10.255.255.255')) and
                          (INET_ATON(ip_number) BETWEEN INET_ATON('172.16.0.0') AND INET_ATON('172.31.255.255')) and
                          (INET_ATON(ip_number) BETWEEN INET_ATON('192.168.0.0') AND INET_ATON('192.168.255.255'))) ";
            }
            if ($_GET['fJenis'] == 2) {

                $searchLabel2 .= "Hanya menampilkan IP Public. ";
                $wSQL2 = " and ((INET_ATON(ip_number) not BETWEEN INET_ATON('10.0.0.0') AND INET_ATON('10.255.255.255')) and
                          (INET_ATON(ip_number) not BETWEEN INET_ATON('172.16.0.0') AND INET_ATON('172.31.255.255')) and
                          (INET_ATON(ip_number) not BETWEEN INET_ATON('192.168.0.0') AND INET_ATON('192.168.255.255'))) ";
            }
            if ($_GET['fPeta'] == 1) {
                $searchLabel3 = "Hanya yang sudah dipetakan ke domain dan aset. ";
            }
            if ($_GET['fPeta'] == 2) {
                $searchLabel3 = "Hanya yang sudah dipetakan ke aset. ";
            }
            if ($_GET['fPeta'] == 3) {
                $searchLabel3 = "Hanya yang sudah dipetakan ke domain. ";
            }
            if ($_GET['fPeta'] == 4) {
                $searchLabel3 = "Hanya yang belum dipetakan ke aset ataupun domain. ";
            }


        }
        if (strlen(trim($searchLabel))>0) {
            $wSQL = " WHERE (INET_ATON(ip_number) BETWEEN INET_ATON('".$startOctetFinal."') AND INET_ATON('".$endOctetFinal."')) ";
            $searchLabel = 'Filter data : '.$searchLabel;

            if (strlen(trim($searchLabel2))>0) {
                $wSQL = $wSQL . $wSQL2;
                $searchLabel = $searchLabel . $searchLabel2 . $searchLabel3;
            }
        }
        elseif (strlen(trim($searchLabel2))>0) {
            $wSQL = " WHERE 1 ". $wSQL2;
            $searchLabel = $searchLabel . $searchLabel2 . $searchLabel3;
        }
        elseif (strlen(trim($searchLabel3))>0) {
            $searchLabel = $searchLabel . $searchLabel2 . $searchLabel3;
        }

        $worksheet1->set_column(1, 0, 4);
        $worksheet1->set_column(1, 1, 15);
        $worksheet1->set_column(1, 2, 50);
        $worksheet1->set_column(1, 3, 20);
        $worksheet1->set_column(1, 4, 20);
        $worksheet1->set_column(1, 5, 20);
        $worksheet1->set_column(1, 6, 10);
        $worksheet1->set_column(1, 7, 10);

        $worksheet1->write_string(0, 0, "Inventaris Data Center",$formatHD1);
        $worksheet1->write_string(1, 0, "Kementerian Komunikasi dan Informatika",$formatHD1);
        $worksheet1->write_string(3, 0, "Daftar IP Address",$formatHD1);
        $worksheet1->write_string(4, 0, "Didownload oleh ".$member['userName'].", tanggal generate ".date('d F Y H:i:s'),$formatHD2);
        $worksheet1->write_string(5, 0, $searchLabel,$formatHD2);

        $worksheet1->write_string(6, 0, "No",$formatRHD);
        $worksheet1->write_string(6, 1, "IP Address",$formatRHD);
        $worksheet1->write_string(6, 2, "Pemetaan Ke Server",$formatRHD);
        $worksheet1->write_string(6, 3, "Pemetaan Ke Domain",$formatRHD);

        $SQL2 = " select   ref_ip.*,
                           ip_id as id,
                           case when ref_ip.ref_stat_visible = 1 then 'Ya' else 'Tidak' end as status_visible
                  from     ref_ip
                              ".$wSQL."
                  order by INET_ATON(ip_number)
                  ";
        $rh2 = $this->dbH->query($SQL2);
        $functDB->dberror_show($rh2);
        $excelRowCounter = 0;
        while ($rr2 = $rh2->fetch()) {

            $domainmap = 0;
            $ipmap = 0;

            $aset_info = '';
            $SQL3 = " select * from ref_aset_ipmap, ref_aset where map_id_ip = '".$rr2['ip_id']."' and map_id_aset = ast_id order by ast_label ";
            $rh3 = $this->dbH->query($SQL3);
            while ($rr3 = $rh3->fetch()) {
                $aset_info .= $rr3['ast_label'].', ';
                $ipmap = 1;
            }
            if (strlen(trim($aset_info))>0) {
                $aset_info = substr($aset_info,0,(strlen($aset_info)-2));
            }

            $domain_info = '';
            $SQL4 = " select * from ref_domain_ipmap, ref_domain where map_id_ip = '".$rr2['ip_id']."' and map_id_domain = domain_id order by domain_label ";
            $rh4 = $this->dbH->query($SQL4);
            while ($rr4 = $rh4->fetch()) {
                $domain_info .= $rr4['domain_label'].', ';
                $domainmap = 1;
            }
            if (strlen(trim($domain_info))>0) {
                $domain_info = substr($domain_info,0,(strlen($domain_info)-2));
            }

            if (($_GET['fPeta'] == 2) && ($ipmap == 0)) {
                continue;
            }
            if (($_GET['fPeta'] == 3) && ($domainmap == 0)) {
                continue;
            }
            if (($_GET['fPeta'] == 1) && ($ipmap == 0) && ($domainmap == 0)) {
                continue;
            }
            if (($_GET['fPeta'] == 4) && (($ipmap > 0) || ($domainmap > 0))) {
                continue;
            }

            $excelRowCounter++;

            $worksheet1->write_number(6+$excelRowCounter, 0, $excelRowCounter,$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 1, $rr2['ip_number'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 2, $aset_info,$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 3, $domain_info,$formatC);
        }

        $workbook->close();

        die();
    }

    function formGBPdf($tmp = '') {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $pdfTitle = "Inventaris Data Center";
        $pdfSubTitle = "Kementerian Komunikasi dan Informatika";

        require_once('./tcpdf/tcpdf.php');

        $pdf = new TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);

        // set document information
        $pdf->SetCreator('Inventaris Data Center');
        $pdf->SetAuthor('Kementerian Komunikasi dan Informatika');
        $pdf->SetTitle($pdfTitle);

        // set default header data
        $pdf->SetHeaderData('images/logo_kominfo.jpg', 10, $pdfTitle, $pdfSubTitle, array(0,64,255), array(0,64,128));
        $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

        // set margins
        //$pdf->SetMargins(PDF_MARGIN_LEFT, 25, PDF_MARGIN_RIGHT);
        $pdf->SetMargins(10, 25, PDF_MARGIN_RIGHT);
        $pdf->SetHeaderMargin(10);
        $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

        // set auto page breaks
        $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

        // set image scale factor
        $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

        $pdf->AddPage();

        $pdf->SetFont('helvetica', '', 8, '', true);

        $html  = '';
        $html .= '<H2 align="center">DAFTAR PENGUNJUNG KOMINFO</H2>';

        $html .= '<table width="100%" border="1" cellspacing="0" cellpadding="2">';
        $html .= '<tr>';
        $html .= ' <td width="3%"  align="center" valign="top">No</td>';
        $html .= ' <td width="15%" align="center" valign="top">Check In</td>';
        $html .= ' <td width="17%" align="center" valign="top">Foto</td>';
        $html .= ' <td width="25%" align="center" valign="top">Pengunjung</td>';
        $html .= ' <td width="25%" align="center" valign="top">Tujuan</td>';
        $html .= ' <td width="15%"  align="center" valign="top">Check Out</td>';
        $html .= '</tr>';

        $wSQL = '';
        $searchLabel = "";
        if ($_GET['fR'] == 1) {

            if (strlen(trim($_GET['fNama'])) > 0) {
                $wSQL .= " and (lower(gb_nama) like '%".strtolower(trim($_GET['fNama']))."%') ";
                $searchLabel .= "Nama Pengunjung mengandung kata ".$_GET['fNama'].". ";
            }
            if (strlen(trim($_GET['fInstansi'])) > 0) {
                $wSQL .= " and (lower(gb_instansi) like '%".strtolower(trim($_GET['fInstansi']))."%') ";
                $searchLabel .= "Nama Instansi mengandung kata ".$_GET['fInstansi'].". ";
            }
            if (strlen(trim($_GET['fAwal'])) > 0) {
                $fAwal = explode('-',$_GET['fAwal']);
                $wSQL .= " and (stat_inp_time >= '".$fAwal[2].'-'.$fAwal[1].'-'.$fAwal[0]."') ";
                $searchLabel .= "Tanggal Kunjungan mulai ".$_GET['fAwal'].". ";
            }
            if (strlen(trim($_GET['fAkhir'])) > 0) {
                $fAkhir = explode('-',$_GET['fAkhir']);
                $wSQL .= " and (stat_inp_time <= '".$fAkhir[2].'-'.$fAkhir[1].'-'.$fAkhir[0]."') ";
                $searchLabel .= "Tanggal Kunjungan sampai ".$_GET['fAkhir'].". ";
            }
            if ($_GET['fPdp'] > 0) {
                $wSQL .= " and (gb_pendamping = '".$_GET['fPdp']."') ";

                $SQLPdp = " select * from ref_pendamping where pdp_id = '".$_GET['fPdp']."' ";
                $rhPdp  = $this->dbH->query($SQLPdp);
                $rrPdp  = $rhPdp->fetch();

                $searchLabel .= "Pendamping = ".$rrPdp['pdp_nama'].". ";
            }
        }
        if (strlen(trim($wSQL))>0) {
            $wSQL = ' where 1 '.$wSQL;
            $searchLabel = 'Filter data : '.$searchLabel;
        }

        $SQL2  = " select  trx_guestbook.*,
                           gb_id as id,
                           case when gb_checkout_is = 1 then concat('Checkout<BR>',date_format(gb_checkout_time,'%e-%b %H:%i:%s')) else '---' end as stat_co,
                           date_format(stat_inp_time,'%a, %e %b %Y %H:%i:%s') as time_in,
                           concat( coalesce(gb_nama,''),
                                   ',<BR>Telp: ',coalesce(gb_telepon,''),
                                   ',<BR>Email: ',coalesce(gb_email,''),
                                   ',<BR>Instansi: ',coalesce(gb_instansi,'')
                                   ) as pengunjung,
                           concat( coalesce(gb_tujuan,''),
                                   ',<BR>Pendamping: ',coalesce(gb_pendamping,'')
                                   ) as tujuan,
                           gb_foto_fullurl as img_url
                  from     trx_guestbook
                  ".$wSQL."
                  order by stat_inp_time
                  ";
        $rh2 = $this->dbHL['guestbook']->query($SQL2);
        $functDB->dberror_show($rh2);
        while ($rr2 = $rh2->fetch()) {

            $rowCounter++;

            $html_imgtag = '';
            if ((file_exists("./images/guestbook/".$rr2['gb_foto_fullurl'])) && (strlen(trim($rr2['gb_foto_fullurl']))>0)) {
                $html_imgtag = '<img src="http://tamudc.kominfo.go.id/home/images/guestbook/'.$rr2['gb_foto_fullurl'].'">';
            }

            $html .= '<tr>';
            $html .= ' <td align="center" valign="top">'.($rowCounter).'.&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['time_in']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($html_imgtag).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['pengunjung']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['tujuan']).'&nbsp;</td>';
            $html .= ' <td align="left" valign="top">'.($rr2['stat_co']).'&nbsp;</td>';
            $html .= '</tr>';
        }

        $html .= '</table><BR>'.$searchLabel;

        $filename = 'rep_ip_'.date('dmy_His').'.pdf';
        $fullfilename = './tmpPdf/'.$filename;

        $html .= '<BR><BR>'.$filename.' dicetak oleh '.$member['userName'].' pada '.date('d M Y H:i:s');

        $pdf->writeHTML($html);

        $pdf->Output($fullfilename, 'F');
        $pdf->Output($fullfilename, 'I');
        die();

    }

    function formGBExcel() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        ob_end_clean();

        require_once('./excelClass/Worksheet.php');
        require_once('./excelClass/Workbook.php');

        $member =  $this->sessionH->getMemberData();
        $filename = 'excel_ip_'.date('dmyhis').'.xls';

        header("Content-type: application/vnd.ms-excel");
        header("Content-Disposition: attachment; filename=".$filename );
        header("Expires: 0");
        header("Cache-Control: must-revalidate, post-check=0,pre-check=0");
        header("Pragma: public");

        // Creating a workbook
        $workbook = new Workbook("-");

        // Creating the first worksheet
        $worksheet1 =& $workbook->add_worksheet('Pengunjung');

        $formatHD =& $workbook->add_format();
        $formatHD->set_size(14);
        $formatHD->set_bold(1);
        $formatHD->set_align('left');
        $formatHD->set_color('black');

        $formatHD1 =& $workbook->add_format();
        $formatHD1->set_size(12);
        $formatHD1->set_bold(1);
        $formatHD1->set_align('left');
        $formatHD1->set_color('black');

        $formatHD2 =& $workbook->add_format();
        $formatHD2->set_size(10);
        $formatHD2->set_bold(1);
        $formatHD2->set_align('left');
        $formatHD2->set_color('black');

        $formatRHD =& $workbook->add_format();
        $formatRHD->set_size(10);
        $formatRHD->set_bold(1);
        $formatRHD->set_align('left');
        $formatRHD->set_color('white');
        $formatRHD->set_pattern();
        $formatRHD->set_fg_color('black');
        $formatRHD->set_bottom(1);
        $formatRHD->set_top(1);
        $formatRHD->set_left(1);
        $formatRHD->set_right(1);

        $formatC =& $workbook->add_format();
        $formatC->set_size(10);
        $formatC->set_align('left');
        $formatC->set_color('black');
        $formatC->set_left(1);
        $formatC->set_right(1);
        $formatC->set_bottom(1);

        $formatCNC =& $workbook->add_format();
        $formatCNC->set_size(10);
        $formatCNC->set_align('left');
        $formatCNC->set_color('black');
        $formatCNC->set_left(1);
        $formatCNC->set_right(0);

        $formatCC =& $workbook->add_format();
        $formatCC->set_size(10);
        $formatCC->set_align('center');
        $formatCC->set_color('black');
        $formatCC->set_left(1);
        $formatCC->set_right(1);

        $formatCR =& $workbook->add_format();
        $formatCR->set_size(10);
        $formatCR->set_align('right');
        $formatCR->set_color('black');
        $formatCR->set_left(1);
        $formatCR->set_right(1);

        $formatECR =& $workbook->add_format();
        $formatECR->set_size(10);
        $formatECR->set_align('right');
        $formatECR->set_color('black');
        $formatECR->set_pattern();
        $formatECR->set_fg_color('yellow');
        $formatECR->set_left(1);
        $formatECR->set_right(1);

        $formatECL =& $workbook->add_format();
        $formatECL->set_size(10);
        $formatECL->set_align('left');
        $formatECL->set_color('black');
        $formatECL->set_pattern();
        $formatECL->set_fg_color('yellow');
        $formatECL->set_left(1);
        $formatECL->set_right(1);

        $formatB =& $workbook->add_format();
        $formatB->set_size(10);
        $formatB->set_align('left');
        $formatB->set_color('white');
        $formatB->set_pattern();
        $formatB->set_fg_color('black');
        $formatB->set_top(1);
        $formatB->set_bold(1);
        $formatB->set_bottom(1);

        $formatB1 =& $workbook->add_format();
        $formatB1->set_size(10);
        $formatB1->set_align('right');
        $formatB1->set_color('white');
        $formatB1->set_pattern();
        $formatB1->set_fg_color('black');
        $formatB1->set_top(1);
        $formatB1->set_bold(1);
        $formatB1->set_bottom(1);

        $formatBL =& $workbook->add_format();
        $formatBL->set_size(10);
        $formatBL->set_align('left');
        $formatBL->set_color('white');
        $formatBL->set_pattern();
        $formatBL->set_fg_color('black');
        $formatBL->set_top(1);
        $formatBL->set_bold(1);
        $formatBL->set_bottom(1);
        $formatBL->set_left(1);

        $formatBR =& $workbook->add_format();
        $formatBR->set_size(10);
        $formatBR->set_align('left');
        $formatBR->set_color('white');
        $formatBR->set_pattern();
        $formatBR->set_fg_color('black');
        $formatBR->set_top(1);
        $formatBR->set_bold(1);
        $formatBR->set_bottom(1);
        $formatBR->set_right(1);

        $worksheet1->set_column(1, 0, 4);
        $worksheet1->set_column(1, 1, 15);
        $worksheet1->set_column(1, 2, 50);
        $worksheet1->set_column(1, 3, 20);
        $worksheet1->set_column(1, 4, 20);
        $worksheet1->set_column(1, 5, 20);
        $worksheet1->set_column(1, 6, 10);
        $worksheet1->set_column(1, 7, 10);

        $wSQL = '';
        $searchLabel = "";
        if ($_GET['fR'] == 1) {

            if (strlen(trim($_GET['fNama'])) > 0) {
                $wSQL .= " and (lower(gb_nama) like '%".strtolower(trim($_GET['fNama']))."%') ";
                $searchLabel .= "Nama Pengunjung mengandung kata ".$_GET['fNama'].". ";
            }
            if (strlen(trim($_GET['fInstansi'])) > 0) {
                $wSQL .= " and (lower(gb_instansi) like '%".strtolower(trim($_GET['fInstansi']))."%') ";
                $searchLabel .= "Nama Instansi mengandung kata ".$_GET['fInstansi'].". ";
            }
            if (strlen(trim($_GET['fAwal'])) > 0) {
                $fAwal = explode('-',$_GET['fAwal']);
                $wSQL .= " and (stat_inp_time >= '".$fAwal[2].'-'.$fAwal[1].'-'.$fAwal[0]."') ";
                $searchLabel .= "Tanggal Kunjungan mulai ".$_GET['fAwal'].". ";
            }
            if (strlen(trim($_GET['fAkhir'])) > 0) {
                $fAkhir = explode('-',$_GET['fAkhir']);
                $wSQL .= " and (stat_inp_time <= '".$fAkhir[2].'-'.$fAkhir[1].'-'.$fAkhir[0]."') ";
                $searchLabel .= "Tanggal Kunjungan sampai ".$_GET['fAkhir'].". ";
            }
            if ($_GET['fPdp'] > 0) {
                $wSQL .= " and (gb_pendamping = '".$_GET['fPdp']."') ";

                $SQLPdp = " select * from ref_pendamping where pdp_id = '".$_GET['fPdp']."' ";
                $rhPdp  = $this->dbH->query($SQLPdp);
                $rrPdp  = $rhPdp->fetch();

                $searchLabel .= "Pendamping = ".$rrPdp['pdp_nama'].". ";
            }
        }
        if (strlen(trim($wSQL))>0) {
            $wSQL = ' where 1 '.$wSQL;
            $searchLabel = 'Filter data : '.$searchLabel;
        }

        $worksheet1->write_string(0, 0, "Inventaris Data Center",$formatHD1);
        $worksheet1->write_string(1, 0, "Kementerian Komunikasi dan Informatika",$formatHD1);
        $worksheet1->write_string(3, 0, "Daftar Pengunjung Data Center",$formatHD1);
        $worksheet1->write_string(4, 0, "Didownload oleh ".$member['userName'].", tanggal generate ".date('d F Y H:i:s'),$formatHD2);
        $worksheet1->write_string(5, 0, $searchLabel,$formatHD2);

        $worksheet1->write_string(6, 0, "No",$formatRHD);
        $worksheet1->write_string(6, 1, "Check In",$formatRHD);
        $worksheet1->write_string(6, 2, "DB Datetime",$formatRHD);
        $worksheet1->write_string(6, 3, "Instansi",$formatRHD);
        $worksheet1->write_string(6, 4, "Nama",$formatRHD);
        $worksheet1->write_string(6, 5, "Telp",$formatRHD);
        $worksheet1->write_string(6, 6, "Email",$formatRHD);
        $worksheet1->write_string(6, 7, "Tujuan",$formatRHD);
        $worksheet1->write_string(6, 8, "Pendamping",$formatRHD);
        $worksheet1->write_string(6, 9, "Check Out",$formatRHD);
        $worksheet1->write_string(6, 10, "DB Datetime",$formatRHD);

        $SQL2  = " select  trx_guestbook.*,
                           gb_id as id,
                           case when gb_checkout_is = 1 then concat('Checkout, ',date_format(gb_checkout_time,'%e-%b %H:%i:%s')) else '---' end as stat_co,
                           date_format(stat_inp_time,'%a, %e %b %Y %H:%i:%s') as time_in,
                           concat( coalesce(gb_nama,''),
                                   ',<BR>Telp: ',coalesce(gb_telepon,''),
                                   ',<BR>Email: ',coalesce(gb_email,''),
                                   ',<BR>Instansi: ',coalesce(gb_instansi,'')
                                   ) as pengunjung,
                           concat( coalesce(gb_tujuan,''),
                                   ',<BR>Pendamping: ',coalesce(gb_pendamping,'')
                                   ) as tujuan,
                           concat('<img src=\"../../../idc2015/home/images/guestbook/',gb_foto_fullurl,'\" width=\"200\">') as img_tag
                  from     trx_guestbook
                  ".$wSQL."
                  order by stat_inp_time
                  ";
        $rh2 = $this->dbHL['guestbook']->query($SQL2);
        $functDB->dberror_show($rh2);
        $excelRowCounter = 0;
        while ($rr2 = $rh2->fetch()) {
            $excelRowCounter++;

            $worksheet1->write_number(6+$excelRowCounter, 0, $excelRowCounter,$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 1, $rr2['time_in'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 2, $rr2['stat_inp_time'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 3, $rr2['gb_instansi'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 4, $rr2['gb_nama'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 5, $rr2['gb_telepon'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 6, $rr2['gb_email'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 7, $rr2['gb_tujuan'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 8, $rr2['gb_pendamping'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 9, $rr2['stat_co'],$formatC);
            $worksheet1->write_string(6+$excelRowCounter, 10, $rr2['gb_checkout_time'],$formatC);
        }

        $workbook->close();

        die();
    }

}


?>