<?php

class appDashboard extends SM_module {

    function moduleConfig() {


    }

    function moduleThink() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $fTpt =& $this->loadTemplate('appDashboard');

        // set starting date
        if (strlen(trim($_GET['sD']))>0) {
            $date_parse_result = date_parse(trim($_GET['sD']));
            if ( ($date_parse_result['warning_count'] == 0) && ($date_parse_result['error_count'] == 0) ) {
                $startingDate = $date_parse_result['year'].'-'.$date_parse_result['month'].'-'.$date_parse_result['day'];
            }
            else {
                $startingDate = date('Y-m-d');
            }
        }
        else {
            $startingDate = date('Y-m-d');
        }

        // total perangkat
        $htm_totalPerangkat = '';
        $htm_piePerangkat = '';
        $htm_pieTotal = '';
        $SQL_totalPerangkat = "select *
                               from (select   *,
                                              (select count(*) from ref_aset where ast_id_grupaset = astgrp_id and ref_stat_visible = 1) as total_visible
                                     from     ref_aset_grup
                                     where    ref_stat_visible = 1
                                     ) tmp
                               order by total_visible desc, astgrp_label
                               ";
        $rh_totalPerangkat = $this->dbH->query($SQL_totalPerangkat);
        $functDB->dberror_show($rh_totalPerangkat);
        while ($rr_totalPerangkat = $rh_totalPerangkat->fetch()) {
            $htm_totalPerangkat .= '<li class="list-group-item"><span class="badge">'.$rr_totalPerangkat['total_visible'].'</span> '.$rr_totalPerangkat['astgrp_label'].'</li>';
            $htm_piePerangkat .= "{label: '".$rr_totalPerangkat['astgrp_label']."', value: ".$functDB->encap_numeric($rr_totalPerangkat['total_visible'])."},";
            $htm_pieTotal += $rr_totalPerangkat['total_visible'];
        }
        $fTpt->addText($htm_totalPerangkat,'sma_totalPerangkat');
        if (strlen(trim($htm_piePerangkat))>0) {
            $htm_piePerangkat = substr($htm_piePerangkat,0,(strlen(trim($htm_piePerangkat))-1));
        }
        $fTpt->addText($htm_piePerangkat,'chart_pie1_data');
        $fTpt->addText($htm_pieTotal.'','chart_pie1_total');

        // jumlah
        $SQLj1 = "select count(*) as jml
                  from   ref_domain
                  where  ref_stat_visible = 1
                  ";
        $rhj1 = $this->dbH->query($SQLj1);
        $rrj1 = $rhj1->fetch();

        /*
        $SQLj21 = "select count(*) as jml
                  from   ref_ip, ref_aset_ipmap, ref_aset
                  where  ref_ip.ip_id = ref_aset_ipmap.map_id_ip and
                         ref_aset_ipmap.map_id_aset = ref_aset.ast_id and
                         ref_ip.ref_stat_visible = 1 and 
                         (INET_ATON(ip_number) not BETWEEN INET_ATON('10.0.0.0') AND INET_ATON('10.255.255.255')) and
                         (INET_ATON(ip_number) not BETWEEN INET_ATON('172.16.0.0') AND INET_ATON('172.31.255.255')) and
                         (INET_ATON(ip_number) not BETWEEN INET_ATON('192.168.0.0') AND INET_ATON('192.168.255.255')) 
                  ";
        $rhj21 = $this->dbH->query($SQLj21);
        $rrj21 = $rhj21->fetch();
        
        $SQLj22 = "select count(*) as jml
                  from   ref_ip, ref_domain_ipmap, ref_domain
                  where  ref_ip.ip_id = ref_domain_ipmap.map_id_ip and
                         ref_domain_ipmap.map_id_domain = ref_domain.domain_id and
                         ref_ip.ref_stat_visible = 1
                  ";
        $rhj22 = $this->dbH->query($SQLj22);
        $rrj22 = $rhj22->fetch();
        */
        
        $SQLj21 = "select count(*) as jml from (
                      select distinct ip_number
                      from   ref_ip
                                left join ref_aset_ipmap on ref_ip.ip_id = ref_aset_ipmap.map_id_ip
                                left join ref_aset on ref_aset_ipmap.map_id_aset = ref_aset.ast_id
                                left join ref_domain_ipmap on ref_ip.ip_id = ref_domain_ipmap.map_id_ip
                                left join ref_domain on ref_domain_ipmap.map_id_domain = ref_domain.domain_id
                      where  ref_ip.ref_stat_visible = 1 and 
                             (INET_ATON(ip_number) not BETWEEN INET_ATON('10.0.0.0') AND INET_ATON('10.255.255.255')) and
                             (INET_ATON(ip_number) not BETWEEN INET_ATON('172.16.0.0') AND INET_ATON('172.31.255.255')) and
                             (INET_ATON(ip_number) not BETWEEN INET_ATON('192.168.0.0') AND INET_ATON('192.168.255.255')) and
                             (ref_aset.ast_id is not null or ref_domain.domain_id is not null)
                    ) tmp
                  ";
        $rhj21 = $this->dbH->query($SQLj21);
        $rrj21 = $rhj21->fetch();

        $SQLj3 = "select count(*) as jml
                  from   ref_aset
                  where  ref_stat_visible = 1 and ast_id_grupaset = 1
                  ";
        $rhj3 = $this->dbH->query($SQLj3);
        $rrj3 = $rhj3->fetch();

        $SQLj4 = "select count(*) as jml
                  from   ref_aset
                  where  ref_stat_visible = 1
                  ";
        $rhj4 = $this->dbH->query($SQLj4);
        $rrj4 = $rhj4->fetch();

        $fTpt->addText(number_format($rrj1['jml']).'','sma_jmlDomain');
        $fTpt->addText(number_format($rrj21['jml'] + $rrj22['jml']).'','sma_jmlIP');
        $fTpt->addText(number_format($rrj3['jml']).'','sma_jmlServer');
        $fTpt->addText(number_format($rrj4['jml']).'','sma_jmlPerangkat');

        // jumlah kejadian selama 7 hari kebelakang
        $maxCountDay = 7;

        $htm_sejarah = '';
        $htm_sejarah2 = '';

        $htm_logPemakaianIDC = '';
        $htm_logKunjungan = '';
        $htm_logPeristiwa = '';
        for ($x=0; $x<=$maxCountDay; $x++) {

            $dateToSearch = date('Y-m-d',strtotime('+'.$x.' day',strtotime('-'.($maxCountDay).' day',strtotime($startingDate))));
            $dateToSearchFormat = date('d/m',strtotime('+'.$x.' day',strtotime('-'.($maxCountDay).' day',strtotime($startingDate))));

            $SQL_his1 = "select count(*) as jml
                         from   trx_kejadian
                         where  trxkej_tanggal = '".$dateToSearch."'
                         ";
            $rh_his1 = $this->dbH->query($SQL_his1);
            $rr_his1 = $rh_his1->fetch();

            $SQL_his2 = "select count(*) as jml
                         from   trx_lokasi
                         where  trxloc_tanggal = '".$dateToSearch."'
                         ";
            $rh_his2 = $this->dbH->query($SQL_his2);
            $rr_his2 = $rh_his2->fetch();

            $SQL_his3 = "select count(*) as jml
                         from   trx_spesifikasi
                         where  trxspec_tanggal = '".$dateToSearch."'
                         ";
            $rh_his3 = $this->dbH->query($SQL_his3);
            $rr_his3 = $rh_his3->fetch();

            $SQL_his4 = "select count(*) as jml
                         from   trx_guestbook
                         where  stat_inp_time = '".$dateToSearch."'
                         ";
            $rh_his4 = $this->dbHL['guestbook']->query($SQL_his4);
            $rr_his4 = $rh_his4->fetch();

            $htm_sejarah .= '{"period": "'.$dateToSearchFormat.'",
                              "event": "'.$functDB->encap_numeric($rr_his1['jml']).'",
                              "move": "'.$functDB->encap_numeric($rr_his2['jml']).'",
                              "change": "'.$functDB->encap_numeric($rr_his3['jml']).'",
                              "guest": "'.$functDB->encap_numeric($rr_his4['jml']).'"},';

            // chart 2
            $SQL_his5 = "select count(*) as jml
                         from   log_activity
                         where  act_type = 'DBINSERT' and
                                act_table <> 'log_perubahan' and
                                date_format(act_time,'%Y-%m-%d') = '".$dateToSearch."'
                         ";
            $rh_his5 = $this->dbH->query($SQL_his5);
            $rr_his5 = $rh_his5->fetch();
            
            $SQL_his6 = "select count(*) as jml
                         from   log_activity
                         where  act_type = 'DBUPDATE' and
                                date_format(act_time,'%Y-%m-%d') = '".$dateToSearch."'
                         ";
            $rh_his6 = $this->dbH->query($SQL_his6);
            $rr_his6 = $rh_his6->fetch();

            $SQL_his7 = "select count(*) as jml
                         from   log_activity
                         where  act_type = 'DBDELETE' and
                                date_format(act_time,'%Y-%m-%d') = '".$dateToSearch."'
                         ";
            $rh_his7 = $this->dbH->query($SQL_his7);
            $rr_his7 = $rh_his7->fetch();

            $htm_sejarah2 .= '{"period": "'.$dateToSearchFormat.'",
                               "dbinsert": "'.$functDB->encap_numeric($rr_his5['jml']).'",
                               "dbupdate": "'.$functDB->encap_numeric($rr_his6['jml']).'",
                               "dbdelete": "'.$functDB->encap_numeric($rr_his7['jml']).'"},';

        }
        if (strlen(trim($htm_sejarah))>0) {
            $htm_sejarah = substr($htm_sejarah,0,(strlen(trim($htm_sejarah))-1));
        }
        $fTpt->addText($htm_sejarah,'chart_line1');
        if (strlen(trim($htm_sejarah2))>0) {
            $htm_sejarah2 = substr($htm_sejarah2,0,(strlen(trim($htm_sejarah2))-1));
        }
        $fTpt->addText($htm_sejarah2,'chart_line2');


        $htm_logPemakaianIDC = '';
        $htm_logSejarahKunjungan = '';
        $htm_logPeristiwa = '';

        $maxCountDay = 30;
        $x = 0;
        $dateToSearch = date('Y-m-d',strtotime('+'.$x.' day',strtotime('-'.($maxCountDay).' day',strtotime($startingDate))));
        $maxRecordCount = 15;

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

            $htm_logPemakaianIDC .= '
                <li class="list-group-item" '.$bgColor.'>
                    <span class="badge pull-right">'.$badgeTime.'</span>
                    <span class="label label-'.$badgeColour.'">'.$badgeLabel.'</span><BR>
                    <p style="margin-top:15px; margin-bottom:0px;"><span class="glyphicon glyphicon-user" aria-hidden="true" style="margin-right:5px;"></span> <B>'.ucwords(strtolower($rr_log1['firstName'].' '.$rr_log1['lastName'])).'</B></p>
                    <p style="margin-top:0px; margin-bottom:5px;" class="small"><span class="glyphicon glyphicon-time" aria-hidden="true" style="margin-right:5px; "></span> '.$rr_log1['waktu'].'</p>
                    <p style="margin-top:0px;">'.$actInfo.'</p>
                </li>
            ';
        }
        $fTpt->addText($htm_logPemakaianIDC,'sma_logPemakaianIDC');

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

            $htm_logSejarahKunjungan .= '
                <li class="list-group-item" '.$bgColor.'>
                    <span class="badge pull-right">'.$badgeTime.'</span>
                    <span class="label label-'.$badgeColour.'">'.$badgeLabel.'</span><BR>
                    <p style="margin-top:15px; margin-bottom:0px;"><span class="glyphicon glyphicon-briefcase" aria-hidden="true" style="margin-right:5px;"></span> <B>'.ucwords(strtolower($rr_log2['gb_instansi'])).'</B></p>
                    <p style="margin-top:0px; margin-bottom:0px;"><span class="glyphicon glyphicon-user" aria-hidden="true" style="margin-right:5px;"></span> '.ucwords(strtolower($rr_log2['gb_nama'])).'</p>
                    <p style="margin-top:0px; margin-bottom:5px;" class="small"><span class="glyphicon glyphicon-time" aria-hidden="true" style="margin-right:5px; "></span> '.$rr_log2['waktu'].'</p>
                    <p style="margin-top:0px;"><b>Tujuan: </b>'.$rr_log2['gb_tujuan'].', <b>Pendamping: </b>'.$rr_log2['gb_pendamping'].'</p>
                </li>
            ';
        }
        $fTpt->addText($htm_logSejarahKunjungan,'sma_logSejarahKunjungan');

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

            $htm_logPeristiwa .= '
                <li class="list-group-item" '.$bgColor.'>
                    <span class="badge pull-right">'.$badgeTime.'</span>
                    <span class="label label-'.$badgeColour.'">'.$badgeLabel.'</span><BR>
                    <p style="margin-top:15px; margin-bottom:0px;"><span class="glyphicon glyphicon-user" aria-hidden="true" style="margin-right:5px;"></span> '.ucwords(strtolower($rr_log3['oleh'])).'</p>
                    <p style="margin-top:0px; margin-bottom:5px;" class="small"><span class="glyphicon glyphicon-time" aria-hidden="true" style="margin-right:5px; "></span> '.$rr_log3['tanggal'].' '.$rr_log3['waktu'].'</p>
                    <p style="margin-top:0px;">'.$rr_log3['story'].'</p>
                </li>
            ';
        }
        $fTpt->addText($htm_logPeristiwa,'sma_logPeristiwa');

        // rekap kejadian per bulan
        $nowYear = date('Y',strtotime($startingDate));
        $nowMonth = date('m',strtotime($startingDate));

        $nowFullMonth = date('Y-m-01',strtotime($startingDate));
        $nextFullMonth = date('Y-m-01',strtotime('+1 month',strtotime($startingDate)));

        $SQL_kejAlatNow = "select count(*) as jml
                           from   trx_kejadian
                           where  date_format(trxkej_tanggal,'%Y') = '".$nowYear."' and
                                  date_format(trxkej_tanggal,'%m') = '".$nowMonth."'
                           ";
        $rh_kejAlatNow = $this->dbH->query($SQL_kejAlatNow);
        $functDB->dberror_show($rh_kejAlatNow);
        $rr_kejAlatNow = $rh_kejAlatNow->fetch();

        $SQL_kejAlatPrv = "select count(*) as jml
                           from   trx_kejadian
                           ";
        $rh_kejAlatPrv = $this->dbH->query($SQL_kejAlatPrv);
        $functDB->dberror_show($rh_kejAlatPrv);
        $rr_kejAlatPrv = $rh_kejAlatPrv->fetch();

        $SQL_pindahNow = " select count(*) as jml
                           from   trx_lokasi
                           where  date_format(trxloc_tanggal,'%Y') = '".$nowYear."' and
                                  date_format(trxloc_tanggal,'%m') = '".$nowMonth."'
                           ";
        $rh_pindahNow = $this->dbH->query($SQL_pindahNow);
        $functDB->dberror_show($rh_pindahNow);
        $rr_pindahNow = $rh_pindahNow->fetch();

        $SQL_pindahPrv = " select count(*) as jml
                           from   trx_lokasi
                           ";
        $rh_pindahPrv = $this->dbH->query($SQL_pindahPrv);
        $functDB->dberror_show($rh_pindahPrv);
        $rr_pindahPrv = $rh_pindahPrv->fetch();

        $SQL_ubahNow = "select count(*) as jml
                        from   trx_spesifikasi
                        where  date_format(trxspec_tanggal,'%Y') = '".$nowYear."' and
                               date_format(trxspec_tanggal,'%m') = '".$nowMonth."'
                        ";
        $rh_ubahNow = $this->dbH->query($SQL_ubahNow);
        $functDB->dberror_show($rh_ubahNow);
        $rr_ubahNow = $rh_ubahNow->fetch();

        $SQL_ubahPrv = "select count(*) as jml
                        from   trx_spesifikasi
                        ";
        $rh_ubahPrv = $this->dbH->query($SQL_ubahPrv);
        $functDB->dberror_show($rh_ubahPrv);
        $rr_ubahPrv = $rh_ubahPrv->fetch();

        $SQL_guestbookNow = "select count(*) as jml
                             from   trx_guestbook
                             where  date_format(stat_inp_time,'%Y') = '".$nowYear."' and
                                    date_format(stat_inp_time,'%m') = '".$nowMonth."'
                             ";
        $rh_guestbookNow = $this->dbHL['guestbook']->query($SQL_guestbookNow);
        $functDB->dberror_show($rh_guestbookNow);
        $rr_guestbookNow = $rh_guestbookNow->fetch();

        $SQL_guestbookPrv = "select count(*) as jml
                             from   trx_guestbook
                             ";
        $rh_guestbookPrv = $this->dbHL['guestbook']->query($SQL_guestbookPrv);
        $functDB->dberror_show($rh_guestbookPrv);
        $rr_guestbookPrv = $rh_guestbookPrv->fetch();

        $htm_rekapPerBulan  = '';

        $htm_rekapPerBulan .= '<li class="list-group-item"><span class="badge">'.number_format($rr_kejAlatNow['jml']).' / '.number_format($rr_kejAlatPrv['jml']).'</span> Peristiwa Perangkat</li>';
        $htm_rekapPerBulan .= '<li class="list-group-item"><span class="badge">'.number_format($rr_pindahNow['jml']).' / '.number_format($rr_pindahPrv['jml']).'</span> Pemindahan</li>';
        $htm_rekapPerBulan .= '<li class="list-group-item"><span class="badge">'.number_format($rr_ubahNow['jml']).' / '.number_format($rr_ubahPrv['jml']).'</span> Perubahan Spek</li>';
        $htm_rekapPerBulan .= '<li class="list-group-item"><span class="badge">'.number_format($rr_guestbookNow['jml']).' / '.number_format($rr_guestbookPrv['jml']).'</span> Tamu Kunjungan</li>';

        $fTpt->addText($htm_rekapPerBulan,'sma_rekapKejadianPerBulan');
        
        
        // nms data
        $SQLnms =   "select distinct nms_tag, nms_svcname, nms_id_aset
                     from   trx_nms
                     order by nms_tag, nms_svcname
                     ";
        $rhNMS = $this->dbH->query($SQLnms);
        $functDB->dberror_show($rhNMS);
        $htm_nms = '';
        $nms_counter = 0;
        $nms_counter_max = 5;
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
                if (!($nms_counter > $nms_counter_max)) {
                    $svcLabel = '';
                    if ($rrNMS2['nms_svcname'] == 'nms_default') {
                        $svcLabel = 'default';
                    }
                    else {
                        $svcLabel = $rrNMS2['nms_svcname'];
                    }
                    $htm_nms .= '<li class="list-group-item">
                                  <div class="row">
                                      <div class="col-md-2"><B>'.$rrNMS2['ast_label'].'</B></div>
                                      <div class="col-md-1"><B>'.$svcLabel.'</B></div>
                                      <div class="col-md-6">'.$rrNMS2['nms_svcnote'].'</div>
                                      <div class="col-md-3">'.$rrNMS2['lastupd'].'</div>
                                  </div>
                                 </li>';
                }
            }
            
        }
        $url_nms = $this->sessionH->uLink('m2.php').'&option=nmsList';
        if ($nms_counter > $nms_counter_max) {
            $htm_nms .= '<li class="list-group-item">
                          <div class="row">
                              <div class="col-md-12"><a href="'.$url_nms.'" target="_blank">Lihat selanjutnya (+'.($nms_counter-$nms_counter_max).') ...</a></div>
                          </div>
                         </li>';
        }
        $fTpt->addText($htm_nms,'sma_nmsEvent');
        

        $this->say($fTpt->run());

    }

}

  ?>