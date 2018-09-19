<?php

class gbList extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/gbList');
        
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

            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid=deleteTamuIDC','ajaxurl_delete');
            
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=guestbookPdf','popUrl_cetakPdf');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=guestbookExcel','popUrl_cetakExcel');
            
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
    function buildGrid($tmp = '') {
        
        $member =  $this->sessionH->getMemberData();

        $SQL  = " select   trx_guestbook.*,
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
                           concat('<img src=\"./images/guestbook/',gb_foto_fullurl,'\" width=\"200\">') as img_tag
                  from     trx_guestbook
                  order by trx_guestbook.stat_inp_time desc
                  ";
        
        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['dbconn'] = 'guestbook';
        
        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Buku Tamu IDC';
        $sgkMod->directive['sm_function'] = 'buildGrid';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

        $sgkMod->directive['element_add_formtechnique'] = 'jsf';
        $sgkMod->directive['element_add_jsf'] = 'addNewData()';
        $sgkMod->directive['sgk_reload_jsf'] = 'gridReload()';
        $sgkMod->directive['grid_btnDetail'] = false;
        $sgkMod->directive['grid_btnDetail_useDefault'] = false;
        $sgkMod->directive['grid_btnDetail_jsfCustom'] = '';
        $sgkMod->directive['grid_btnEdit'] = false;
        
        if ($member['idlevel'] == 1) {
            
            $sgkMod->directive['grid_btnDelete'] = true;
            $sgkMod->directive['grid_btnDelete_useDefault'] = false;
            $sgkMod->directive['grid_btnDelete_jsfCustom'] = 'deleteGrid';
        }
        else {
            
            $sgkMod->directive['grid_btnDelete'] = false;
            $sgkMod->directive['grid_btnDelete_useDefault'] = false;
            $sgkMod->directive['grid_btnDelete_jsfCustom'] = 'deleteGrid';
        }
        
        

        $sgkMod->directive['wrapper_useDefault'] = false;

        $sgkMod->directive['inw3x3_headleft'] = array('');
        $sgkMod->directive['inw3x3_headright'] = array('search');
        $sgkMod->directive['inw3x3_footright'] = array('');
        
        $sgkMod->directive['grid_isgroupable'] = false;
        $sgkMod->directive['grid_isselectable'] = true;
        $sgkMod->directive['grid_columnmenu'] = false;
        $sgkMod->directive['grid_isfilterable'] = false;
        $sgkMod->directive['grid_isresize'] = false;
        $sgkMod->directive['grid_isreorder'] = false;

        $sgkMod->directive['grid_fields'] = array(
        	'time_in' => 'CheckIn',
            'img_tag' => 'Foto',
            'pengunjung' => 'Pengunjung',
            'tujuan' => 'Tujuan',
            'stat_co' => 'Checkout?',
        );

        $sgkMod->directive['grid_fields_width'] = array(
        	'time_in' => '150',
            'img_tag' => '200',
        	'pengunjung' => '250',
            'stat_co' => '150',
        );

        $sgkMod->directive['grid_fields_type'] = array(
        );

        $sgkMod->directive['grid_fields_format'] = array(
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
            'img_tag' => true,
            'pengunjung' => true,
            'tujuan' => true
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }
    
    function deleteTamuIDC() {
        
        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');
        
        if ($member['idlevel'] == 1) {
            $SQLDel = " delete from trx_guestbook where gb_id = '".$this->getVar('rNum')."' ";
            $act    = $this->dbHL['guestbook']->query($SQLDel);
        }
        
        die('1024');
    }

}


?>
