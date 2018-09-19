<?php

class tblLogSystem extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/tblLogSystem');
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

	    $member =  $this->sessionH->getMemberData();

        $SQL  = " select   date_format(act_time,'%Y-%m-%d') as tglaction,
                           date_format(act_time,'%H:%i:%s') as jamaction,
                           act_type,
                           act_table,
                           act_ipaddress,
                           act_browser,
                           act_id_memo,
                           firstName
                  from     log_activity
                              left join members on act_id_user = idxNum
                  order by act_time desc
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar Penggunaan Sistem IDC';
        $sgkMod->directive['sm_function'] = 'buildGrid';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

        $sgkMod->directive['sgk_reload_jsf'] = 'gridReload()';
        $sgkMod->directive['grid_btnDetail'] = false;
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

        $sgkMod->directive['grid_detailTemplate'] = 'tpl_detailData';

        $sgkMod->directive['grid_fields'] = array(
        	'tglaction' => 'Tanggal',
            'jamaction' => 'Waktu',
            'firstName' => 'User',
            'act_type' => 'Tipe',
            'act_table' => 'Tabel',
            'act_ipaddress' => 'Akses IP',
            'act_browser' => 'Akses Browser',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'tglaction' => '125',
            'jamaction' => '100',
            'firstName' => '200',
            'act_type' => '100',
            'act_table' => '150',
            'act_ipaddress' => '150',
        );

        $sgkMod->directive['grid_fields_type'] = array(
			'tglaction' => 'date',
        );

        $sgkMod->directive['grid_fields_format'] = array(
			'tglaction' => 'date',
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }

}


?>
