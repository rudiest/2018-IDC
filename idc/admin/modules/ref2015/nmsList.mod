<?php

class nmsList extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/nmsList');
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

        $SQL  = "select distinct 
                            t1.nms_tag as code_tag, 
                            t1.nms_svcname as code_svc, 
                            t1.nms_id_aset,
                            ast_label,
                            (select  concat(coalesce(t2.nms_svcnote,''), '<br><small>Last update: ', coalesce(date_format(t2.nms_lastupdate, '%e %b %Y, %H:%i:%s'),'')) as value
                                 from    trx_nms t2
                                 where   t2.nms_tag = code_tag and
                                         t2.nms_svcname = code_svc
                                 order by t2.nms_timestamp desc
                                 limit 1
                                 ) as nms_note
                 from       trx_nms t1
                               left join ref_aset on ast_id = t1.nms_id_aset
                 where      ((select t3.nms_flag
                              from   trx_nms t3
                              where  t3.nms_tag = t1.nms_tag and
                                     t3.nms_svcname = t1.nms_svcname
                              order by t3.nms_timestamp desc
                              limit 1) = 2)
                 order by   t1.nms_tag, 
                            t1.nms_svcname
                 ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Status NMS';
        $sgkMod->directive['sm_function'] = 'buildGrid';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

        $sgkMod->directive['sgk_reload_jsf'] = 'gridReload()';
        $sgkMod->directive['grid_btnDetail'] = false;
        $sgkMod->directive['grid_btnEdit'] = false;
        $sgkMod->directive['grid_btnDelete'] = false;

        $sgkMod->directive['wrapper_useDefault'] = false;
        
        $sgkMod->directive['innerwrapper_bgcolor'] = '#D9534F';
        
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
        	'ast_label' => 'Aset',
            'code_svc' => 'Service',
            'nms_note' => 'NMS Note',
        );

        $sgkMod->directive['grid_fields_width'] = array(
            'ast_label' => '250',
            'code_svc' => '150',
        );

        $sgkMod->directive['grid_fields_type'] = array(
        );

        $sgkMod->directive['grid_fields_format'] = array(
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
            'nms_note' => true,
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }

}


?>
