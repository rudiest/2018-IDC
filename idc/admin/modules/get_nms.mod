<?php

class get_nms extends SM_module {

    function moduleConfig() {



    }

    function moduleThink() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $debugLine = '';
        
        $nms_ts = date('Y-m-d H:i:s');
        $debugLine .= 'Started at '.$nms_ts.' <BR>'.chr(13);
        
        // $nms_state = file_get_contents('./json_nms.js');
        //$nms_state = file_get_contents('http://172.30.0.239:8090/state');
        $nms_state = file_get_contents('http://172.30.0.239/appmobile/retrievejson.php');
        $nms_var = json_decode($nms_state, true);
        
        // $nms_state = file('http://202.89.117.113:8090/state');
        // $nms_var = json_decode($nms_state[0], true);
        
        // $nms_state = $this->curl_get_contents('http://202.89.117.113:8090/state');
        // $nms_var = json_decode($nms_state, true);
        
        $debugLine .= date('Y-m-d H:i:s').': NMS fetched.<BR>'.chr(13);
        
        // $debugLine .= date('Y-m-d H:i:s').': State: '.$nms_state.'.<BR>'.chr(13);
        // $debugLine .= date('Y-m-d H:i:s').': Var: '.print_r($nms_var).'.<BR>'.chr(13);
        
        $SQL = " select * 
                 from   ref_aset,
                        ref_aset_grup,
                        ref_aset_grup_spek,
                        ref_aset_spesifikasi
                 where  ast_id_grupaset = astgrp_id and
                        astgrpspek_id_grup = astgrp_id and
                        astgrpspek_kode = 'NMS__' and
                        astspk_id_aset = ast_id and
                        astspk_id_grup_spek = astgrpspek_id and
                        length(trim(coalesce(astspk_value_text,''))) > 0
                 order by astspk_value_text, ast_label
                 ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);
        while ($rr = $rh->fetch()) {
            
            $debugLine .= date('Y-m-d H:i:s').': - find nms map '.$rr['astspk_value_text'].' from aset '.$rr['ast_label'].'.<BR>'.chr(13);
            
            reset($nms_var['content']);
            while (list($key, $val) = each($nms_var['content'])) {
                
                $debugLine .= date('Y-m-d H:i:s').': -- read json '.$key.' value '.$val.'.<BR>'.chr(13);
                
                if ( strtolower(trim($key)) == strtolower(trim($rr['astspk_value_text'])) ) {
                    // we got match
                    $debugLine .= date('Y-m-d H:i:s').': -- match nms map '.$rr['astspk_value_text'].' with key '.$key.'.<BR>'.chr(13);
                    
                    // get the basic nms state
                    $nms_flag = 0;
                    if (preg_match("/\bok\b/i", $nms_var['content'][$key]['plugin_output']) == 1) {
                        $nms_flag = 1;
                    }
                    else {
                        $nms_flag = 2;
                    }
                    $debugLine .= date('Y-m-d H:i:s').': -- flagged '.$nms_flag.' with message '.$nms_var['content'][$key]['plugin_output'].'.<BR>'.chr(13);
                    
                    $SQLcheck = "select * 
                                 from   trx_nms
                                 where  nms_tag = '".$key."' and
                                        nms_svcname = 'nms_default'
                                 order by nms_input desc
                                 limit 1
                                 ";
                    $rhcheck  = $this->dbH->query($SQLcheck);
                    $functDB->dberror_show($rhcheck);
                    $rrcheck = $rhcheck->fetch();
                    $newstate = 0;
                    if (strlen(trim($rrcheck['nms_tag'])) >0) {
                        // cek apakah state sama ?
                        if ($rrcheck['nms_svcnote'] == $nms_var['content'][$key]['plugin_output']) {
                            // update last checknya
                            $arrData = array ( 'nms_lastupdate' => "'".$nms_ts."'"
                                               );
                            $functDB->dbupd("trx_nms",$arrData,"nms_timestamp = '".$rrcheck['nms_timestamp']."' and nms_tag = '".$rrcheck['nms_tag']."' and nms_svcname = '".$rrcheck['nms_svcname']."' and nms_svcnote = '".$rrcheck['nms_svcnote']."' ");
                            $debugLine .= date('Y-m-d H:i:s').': -- previous record at '.$rrcheck['nms_timestamp'].' found updating last-update to '.$nms_ts.'.<BR>'.chr(13);
                        }
                        else {
                            // new state.
                            $newstate = 1;
                        }
                    }
                    else {
                        // new state.
                        $newstate = 1;
                    }
                    
                    if ($newstate == 1) {
                        $nms_flag = $functDB->encap_numeric($nms_flag);
                        $nms_tag = $functDB->encap_string($key);
                        $nms_svcname = $functDB->encap_string('nms_default');
                        $nms_svcnote = $functDB->encap_string($nms_var['content'][$key]['plugin_output']);
                        $nms_id_aset = $functDB->encap_numeric($rr['ast_id']);
                        $arrData = array ( 'nms_timestamp' => "'".$nms_ts."'",
                                           'nms_input' => "'".$nms_ts."'",
                                           'nms_lastupdate' => "'".$nms_ts."'",
                                           'nms_tag' => $nms_tag,
                                           'nms_flag' => $nms_flag,
                                           'nms_svcname' => $nms_svcname,
                                           'nms_svcnote' => $nms_svcnote,
                                           'nms_id_aset' => $nms_id_aset
                                           );
                        $functDB->dbins('trx_nms',$arrData);
                        $debugLine .= date('Y-m-d H:i:s').': -- new record! previous state is '.$rrcheck['nms_svcnote'].' at '.$rrcheck['nms_timestamp'].'<BR>'.chr(13);
                            
                        
                        if ($nms_flag == 2) {
                            // insert to table kejadian
                            $trxkej_tanggal = "'".date('Y-m-d',strtotime($nms_ts))."'";
                            $trxkej_waktu = "'".date('H:i:s',strtotime($nms_ts))."'";
                            $trxkej_id_kej = $functDB->encap_numeric(98);
                            $trxkej_keterangan = $functDB->encap_string($nms_var['content'][$key]['plugin_output']);
                            $trxkej_oleh = $functDB->encap_string('NMS');
                            $trxkej_id_aset = $functDB->encap_numeric($rr['ast_id']);
                            
                            $arrData = array ( 'trxkej_tanggal' => $trxkej_tanggal,
                                               'trxkej_waktu' => $trxkej_waktu,
                                               'trxkej_id_kej' => $trxkej_id_kej,
                                               'trxkej_keterangan' => $trxkej_keterangan,
                                               'trxkej_oleh' => $trxkej_oleh,
                                               'trxkej_id_aset' => $trxkej_id_aset,
                                               'trx_stat_input_by' => 1,
                                               'trx_stat_input_time' => 'now()',
                                               );
                            $functDB->dbins('trx_kejadian',$arrData);
                            $debugLine .= date('Y-m-d H:i:s').': -- insert to table kejadian<BR>'.chr(13);
                        }
                    }
                    
                    // get additional nms service
                    $SQLextra = "select * 
                                 from   ref_aset,
                                        ref_aset_grup,
                                        ref_aset_grup_spek,
                                        ref_aset_spesifikasi
                                 where  ast_id_grupaset = astgrp_id and
                                        astgrpspek_id_grup = astgrp_id and
                                        astgrpspek_kode = 'NMSSV' and
                                        astspk_id_aset = ast_id and
                                        astspk_id_grup_spek = astgrpspek_id and
                                        length(trim(coalesce(astspk_value_text,''))) > 0 and
                                        ast_id = '".$rr['ast_id']."'
                                 order by astspk_value_text, ast_label
                                 ";
                    $rhExtra  = $this->dbH->query($SQLextra);
                    $functDB->dberror_show($rhExtra);
                    $rrExtra = $rhExtra->fetch();
                    
                    if (strlen(trim($rrExtra['astspk_value_text']))>0) {
                        
                        $debugLine .= date('Y-m-d H:i:s').': -- request additional nms services '.$rrExtra['astspk_value_text'].'<BR>'.chr(13);
                        
                        $reqServices = array();
                        $t_reqServices = explode(';',$rrExtra['astspk_value_text']);
                        if (is_array($t_reqServices) && (count($t_reqServices) >0)) {
                            $reqServices = $t_reqServices;
                        }
                        else {
                            $reqServices[0] = $rrExtra['astspk_value_text'];
                        }
                        
                        $t_nmsService = $nms_var['content'][$key]['services'];
                        
                        reset($reqServices);
                        while (list($key2, $val2) = each($reqServices)) {
                            $servicename = trim($val2);
                            $debugLine .= date('Y-m-d H:i:s').': --- trying to find '.$servicename.'<BR>'.chr(13);
                            
                            reset($t_nmsService);
                            while (list($key3, $val3) = each($t_nmsService)) {
                                
                                if (strtolower(trim($key3)) == strtolower(trim($servicename))) {
                                    
                                    // found
                                    $debugLine .= date('Y-m-d H:i:s').': ---- '.$servicename.' found in nms tag as '.$key3.'.<BR>'.chr(13);
                                    
                                    $nms_flag = 0;
                                    if (preg_match("/\bok\b/i", $nms_var['content'][$key]['services'][$key3]['plugin_output']) == 1) {
                                        $nms_flag = 1;
                                    }
                                    else {
                                        $nms_flag = 2;
                                    }
                                    $debugLine .= date('Y-m-d H:i:s').': ---- flagged '.$nms_flag.' with message '.$nms_var['content'][$key]['services'][$key3]['plugin_output'].'.<BR>'.chr(13);
                                    
                                    $SQLcheck = "select * 
                                                 from   trx_nms
                                                 where  nms_tag = '".$key."' and
                                                        nms_svcname = '".$key3."'
                                                 order by nms_input desc
                                                 limit 1
                                                 ";
                                    $rhcheck  = $this->dbH->query($SQLcheck);
                                    $functDB->dberror_show($rhcheck);
                                    $rrcheck = $rhcheck->fetch();
                                    $newstate = 0;
                                    if (strlen(trim($rrcheck['nms_tag'])) >0) {
                                        // cek apakah state sama ?
                                        if ($rrcheck['nms_svcnote'] == $nms_var['content'][$key]['services'][$key3]['plugin_output']) {
                                            // update last checknya
                                            $arrData = array ( 'nms_lastupdate' => "'".$nms_ts."'"
                                                               );
                                            $functDB->dbupd("trx_nms",$arrData,"nms_timestamp = '".$rrcheck['nms_timestamp']."' and nms_tag = '".$rrcheck['nms_tag']."' and nms_svcname = '".$rrcheck['nms_svcname']."' and nms_svcnote = '".$rrcheck['nms_svcnote']."' ");
                                            $debugLine .= date('Y-m-d H:i:s').': ---- previous record at '.$rrcheck['nms_timestamp'].' found updating last-update to '.$nms_ts.'.<BR>'.chr(13);
                                        }
                                        else {
                                            // new state.
                                            $newstate = 1;
                                        }
                                    }
                                    else {
                                        // new state.
                                        $newstate = 1;
                                    }
                                    
                                    if ($newstate == 1) {
                                        $nms_flag = $functDB->encap_numeric($nms_flag);
                                        $nms_tag = $functDB->encap_string($key);
                                        $nms_svcname = $functDB->encap_string($key3);
                                        $nms_svcnote = $functDB->encap_string($nms_var['content'][$key]['services'][$key3]['plugin_output']);
                                        $nms_id_aset = $functDB->encap_numeric($rr['ast_id']);
                                        $arrData = array ( 'nms_timestamp' => "'".$nms_ts."'",
                                                           'nms_input' => "'".$nms_ts."'",
                                                           'nms_lastupdate' => "'".$nms_ts."'",
                                                           'nms_tag' => $nms_tag,
                                                           'nms_flag' => $nms_flag,
                                                           'nms_svcname' => $nms_svcname,
                                                           'nms_svcnote' => $nms_svcnote,
                                                           'nms_id_aset' => $nms_id_aset,
                                                           );
                                        $functDB->dbins('trx_nms',$arrData);
                                        $debugLine .= date('Y-m-d H:i:s').': ---- new record! previous state is '.$rrcheck['nms_svcnote'].' at '.$rrcheck['nms_timestamp'].'<BR>'.chr(13);
                                            
                                        
                                        if ($nms_flag == 2) {
                                            // insert to table kejadian
                                            $trxkej_tanggal = "'".date('Y-m-d',strtotime($nms_ts))."'";
                                            $trxkej_waktu = "'".date('H:i:s',strtotime($nms_ts))."'";
                                            $trxkej_id_kej = $functDB->encap_numeric(98);
                                            $trxkej_keterangan = $functDB->encap_string($nms_var['content'][$key]['services'][$key3]['plugin_output']);
                                            $trxkej_oleh = $functDB->encap_string('NMS');
                                            $trxkej_id_aset = $functDB->encap_numeric($rr['ast_id']);
                                            
                                            $arrData = array ( 'trxkej_tanggal' => $trxkej_tanggal,
                                                               'trxkej_waktu' => $trxkej_waktu,
                                                               'trxkej_id_kej' => $trxkej_id_kej,
                                                               'trxkej_keterangan' => $trxkej_keterangan,
                                                               'trxkej_oleh' => $trxkej_oleh,
                                                               'trxkej_id_aset' => $trxkej_id_aset,
                                                               'trx_stat_input_by' => 1,
                                                               'trx_stat_input_time' => 'now()',
                                                               );
                                            $functDB->dbins('trx_kejadian',$arrData);
                                            $debugLine .= date('Y-m-d H:i:s').': ---- insert to table kejadian<BR>'.chr(13);
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    
                } // end if 
                
            } // end nms var loop
            
        } // end aset loop
        
        die($debugLine);
        $this->say($debugLine);
        
    }
    
    function curl_get_contents($url) {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_URL, $url);
        $data = curl_exec($ch);
        curl_close($ch);
        return $data;
    }

    

}


?>
