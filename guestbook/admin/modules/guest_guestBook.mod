<?php

class guest_guestBook extends SM_module {

     function moduleConfig() {

        $this->addDirective('testDirective');
        
        $this->addInVar('rNum',0);
    }

    function moduleThink() {
        
        $functDB =& $this->loadModule('functionDB');

        if ($this->sessionH->isMember()) {
            $this->sessionH->attemptLogout();
            unset($_SESSION);
        }
        
        if ((count($_POST) > 0) && ($_POST['formID'] == 'idcGuestBook')) {
            
            $gb_nama = $functDB->encap_string($_POST['gb_nama'],1);
            $gb_instansi = $functDB->encap_string($_POST['gb_instansi'],1);
            $gb_tujuan = $functDB->encap_string($_POST['gb_tujuan'],1);
            $gb_pendamping = $functDB->encap_string($_POST['gb_pendamping'],1);
            $gb_telepon = $functDB->encap_string($_POST['gb_telepon'],1);
            $gb_email = $functDB->encap_string($_POST['gb_email'],1);
            
            $arrData = array ( 'gb_nama' => $gb_nama,
                               'gb_instansi' => $gb_instansi,
                               'gb_tujuan' => $gb_tujuan,
                               'gb_pendamping' => $gb_pendamping,
                               'gb_telepon' => $gb_telepon,
                               'gb_email' => $gb_email,
                               'stat_inp_time' => 'now()',
                               );
            $functDB->dbins('trx_guestbook',$arrData);
            
            $lastInsertId = $this->dbH->lastInsertId();
            
            if (($lastInsertId > 0) && (strlen(trim($_POST['fotoData']))>0)) {
                
                $filename = 'gb_'.$lastInsertId.'_'.date('ymdhis').'.jpg';
                $imageData = trim($_POST['fotoData']);
                $filteredData=substr($imageData, strpos($imageData, ",")+1);
                $unencodedData=base64_decode($filteredData);
                $fp = fopen('./images/guestbook/'.$filename, 'wb' );
                fwrite( $fp, $unencodedData);
                fclose( $fp );
                
                $arrData = array ('gb_foto_fullurl' => $functDB->encap_string($filename));
                $functDB->dbupd('trx_guestbook',$arrData,'gb_id = '.$lastInsertId);
            }
            
            die('1024');
            
        }
        
        $fTpt =& $this->loadTemplate('guest_guestBook_sf');
        
        $sma_areaPilihPendamping = '';
        $SQL = " select   *
                 from     ref_pendamping 
                 order by pdp_nama";
        $rh  = $this->dbH->query($SQL);
        while ($rr = $rh->fetch()) {
            $sma_areaPilihPendamping .= '<option value="'.$rr['pdp_nama'].'">'.$rr['pdp_nama'].'</option>';    
        }
        
        $fTpt->addText($sma_areaPilihPendamping,'sma_areaPilihPendamping');
        
        $this->say($fTpt->run());
        
    }
    
    function getTataTertib() {
        
        $SQL = " select   *
                 from     ref_peraturan
                 ";
        $rh  = $this->dbH->query($SQL);
        $rr = $rh->fetch();
        
        return ($rr['peraturan']);
    }
    
    function getInstansi() {
        
        $functDB =& $this->loadModule('functionDB');

        $arrayData = array();

        $whereClause = "";
        if (strlen(trim($_GET['filter']['filters']['0']['value']))>0) {
            $fil = $_GET['filter']['filters']['0']['value'];
            $whereClause = " and (lower(gb_instansi) like '".$fil."%') ";
        }

        $SQL = " select   gb_id as id, 
                          gb_instansi as instansi 
                 from     trx_guestbook 
                 where    gb_id > 0 ".$whereClause." 
                 order by gb_instansi 
                 limit    50";
        $rh  = $this->dbH->query($SQL);
        while ($rr = $rh->fetch()) {
            $arrayData[] = $rr;
        };
        
        $arrayGrid = array('total'=>count($arrayData),
                           'data'=>$arrayData
                           );

        die(json_encode($arrayGrid));

    }
    
    
    function guestCheckout() {
        
        $functDB =& $this->loadModule('functionDB');
        
        $SQL = " select *,
                        date_format(stat_inp_time,'%e %b %Y, pukul %H:%i:%s') as waktucheckin,
                        date_format(gb_checkout_time,'%e %b %Y, pukul %H:%i:%s') as waktucheckout
                 from   trx_guestbook 
                 where  gb_id = '".$this->getVar('rNum')."' 
                 ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);
        $rr = $rh->fetch();
        
        $html  = '<table width="100%" border="0" cellpadding="5" cellspacing="0">';
        $html .= '<tr>';
        $html .= ' <td align="left" valign="top" width="400" height="325">';
        $html .= '   <img src="./images/guestbook/'.$rr['gb_foto_fullurl'].'" alt="Foto '.$rr['gb_nama'].'" width="400">';
        $html .= ' </td>';
        $html .= ' <td align="left" valign="top" width="400">';
        $html .= '   <table width="100%" border="0" cellpadding="5" cellspacing="0">';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Check In</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['waktucheckin'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Nama</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['gb_nama'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Instansi</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['gb_instansi'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Tujuan</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['gb_tujuan'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Pendamping</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['gb_pendamping'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Telepon</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['gb_telepon'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">E-mail</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['gb_email'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Check Out</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">';
        $html .= '        <button class="btn btn-warning" onclick="btn_goCheckout('.$rr['gb_id'].')">Check Out</button>';
        $html .= '     </td>';
        $html .= '   </tr>';
        $html .= '   </table>';
        $html .= ' </td>';
        $html .= ' </tr>';
        $html .= ' </table>';
        
        return $html;
    }
    
    function guestView() {
        
        $functDB =& $this->loadModule('functionDB');
        
        $SQL = " select *,
                        date_format(stat_inp_time,'%e %b %Y, pukul %H:%i:%s') as waktucheckin,
                        date_format(gb_checkout_time,'%e %b %Y, pukul %H:%i:%s') as waktucheckout
                 from   trx_guestbook 
                 where  gb_id = '".$this->getVar('rNum')."' 
                 ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);
        $rr = $rh->fetch();
        
        $html  = '<table width="100%" border="0" cellpadding="5" cellspacing="0">';
        $html .= '<tr>';
        $html .= ' <td align="left" valign="top" width="400" height="325">';
        $html .= '   <img src="./images/guestbook/'.$rr['gb_foto_fullurl'].'" alt="Foto '.$rr['gb_nama'].'" width="400">';
        $html .= ' </td>';
        $html .= ' <td align="left" valign="top" width="400">';
        $html .= '   <table width="100%" border="0" cellpadding="5" cellspacing="0">';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Check In</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['waktucheckin'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Nama</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['gb_nama'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Instansi</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['gb_instansi'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Tujuan</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['gb_tujuan'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Pendamping</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['gb_pendamping'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Telepon</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['gb_telepon'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">E-mail</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['gb_email'].'</td>';
        $html .= '   </tr>';
        $html .= '   <tr>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">Check Out</td>';
        $html .= '     <td align="left" valign="top" style="padding:5px;">'.$rr['waktucheckout'].'</td>';
        $html .= '   </tr>';
        $html .= '   </table>';
        $html .= ' </td>';
        $html .= ' </tr>';
        $html .= ' </table>';
        
        return $html;
    }
    
    function goCheckout() {
        
        $functDB =& $this->loadModule('functionDB');
        
        $SQL = " select *,
                        date_format(stat_inp_time,'%e %b %Y, pukul %H:%i:%s') as waktucheckin,
                        date_format(gb_checkout_time,'%e %b %Y, pukul %H:%i:%s') as waktucheckout
                 from   trx_guestbook 
                 where  gb_id = '".$this->getVar('rNum')."' 
                 ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);
        $rr = $rh->fetch();
        
        if ($rr['gb_checkout_is'] == 1) {
            
            die('Maaf, Tamu '.$rr['gb_nama'].' telah check out pada '.$rr['waktucheckout']);
        }
        else {
            
            $arrData = array ('gb_checkout_is' => 1,
                              'gb_checkout_time' => 'now()');
            $functDB->dbupd('trx_guestbook',$arrData,'gb_id = '.$this->getVar('rNum'));
            
            die('1024');
        }
        
    }
    
    function buildGrid() {

        $SQL  = " select   trx_guestbook.*,
                           gb_id as id,
                           case when gb_checkout_is = 1 
                             then 
                               concat('<input type=\"button\" value=\"Lihat\" class=\"btn btn-info\" onclick=\"popView(', gb_id, ')\">') 
                             else 
                               concat('<input type=\"button\" value=\"Checkout\" class=\"btn btn-danger\" onclick=\"popCheckout(', gb_id, ')\">') 
                             end as btnaction,
                           concat( '',date_format(stat_inp_time,'%e %b %Y, pukul %H:%i:%s'),'',
                                   '<BR>',
                                   '<img src=\"./images/guestbook/',gb_foto_fullurl,'\" width=\"185\" style=\"margin-bottom:10px;\">', 
                                   '<BR><ul class=\"ulGridClass\" style=\"padding-left:10px;\">',
                                   '<li><b>Nama: </b>', coalesce(gb_nama,''), '</li>',
                                   '<li><b>Instansi: </b>', coalesce(gb_instansi,''), '</li>',                                   
                                   (case when gb_checkout_is = 1 
                                   then 
                                       concat('<li><b>Check-Out: </b>',date_format(gb_checkout_time,'%e/%c/%y %H:%i:%s')) 
                                   else 
                                       '<li><b>Check-Out: </b>Belum Checkout</li>' 
                                   end),                                   
                                   '</ul>') as fototaginfo
                  from     trx_guestbook
                  where    (gb_checkout_is = 0 or gb_checkout_is is null) 
                  order by stat_inp_time desc
                  ";
        // and stat_inp_time >= '".date('Y-m-d',strtotime('-2 day'))."'
        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Buku Tamu';
        $sgkMod->directive['sm_function'] = 'buildGrid';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('index.php').'&opt=ajx_bukuTamu';

        $sgkMod->directive['element_add_formtechnique'] = 'jsf';
        $sgkMod->directive['element_add_jsf'] = 'addNewData()';
        $sgkMod->directive['sgk_reload_jsf'] = 'gridReload()';
        $sgkMod->directive['grid_btnDetail'] = false;
        $sgkMod->directive['grid_btnEdit'] = false;
        $sgkMod->directive['grid_btnDelete'] = false;
        
        $sgkMod->directive['ds_pageSize'] = 5;
        
        $sgkMod->directive['wrapper_useDefault'] = false;
        $sgkMod->directive['innerwrapper_useDefault'] = false;
        $sgkMod->directive['grid_isgroupable'] = false;
        $sgkMod->directive['grid_isselectable'] = false;
        $sgkMod->directive['grid_isresize'] = false;
        $sgkMod->directive['grid_isreorder'] = false;
        
        $sgkMod->directive['inw3x3_headleft'] = array('');
        $sgkMod->directive['inw3x3_headright'] = array('');
        $sgkMod->directive['inw3x3_footright'] = array('');

        $sgkMod->directive['grid_fields'] = array(
        	'fototaginfo' => 'Foto & Identitas',
            'btnaction' => 'Aksi',
        );
        
        $sgkMod->directive['grid_fields_isnotfilterable'] = array(
        	'btnaction' => true,
        );
        

        $sgkMod->directive['grid_fields_width'] = array(
            'btnaction' => '50',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			
        );

        $sgkMod->directive['grid_fields_format'] = array(
			
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
            'fototaginfo' => true,
            'btnaction' => true,
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }

}


?>
