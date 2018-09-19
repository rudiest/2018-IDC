<?php

class refIP extends SM_module {

     function moduleConfig() {

        /* Load template */
        $this->useTemplate('defTpt','/ref2015/refIP');
        $this->useTemplate('defTpt2','/ref2015/refIP_form');
        $this->useTemplate('defTpt3','/ref2015/refIP_rangedForm');

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
        elseif ( $this->getVar('popMode') == 'formData' ) {

            $defTpt =& $this->getResource('defTpt2');
            $defTpt->addText($this->formAddData(),'sma_formcontent');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option'),'url_batal');
        }
        elseif ( $this->getVar('popMode') == 'formRange' ) {

            $defTpt =& $this->getResource('defTpt3');
            $defTpt->addText($this->formRange(),'sma_formcontent');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option'),'url_batal');
        }
        else {

            $functDB =& $this->loadModule('functionDB');

            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=formData','popUrl_modifyData');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=formRange','popUrl_addRange');
            
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid=findServer','ajaxurl_detailGrid');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=r2_refAset&sType=viewServer','url_findServer');

            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=ipPdf','popUrl_cetakPdf');
            $defTpt->addtext($this->sessionH->uLink('m2.php').'&option=appCetak&popMode=ipExcel','popUrl_cetakExcel');
            
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
    function findServer() {

	    $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

	    if ($_GET['id_ip'] > 0) {

		    $SQL = " select * from ref_ip where ip_id = '".$_GET['id_ip']."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();

            if (strlen(trim($rr['ip_id']))>0) {
	            $SQL2 = "select map_id_aset
	            	     from   ref_aset_ipmap
	            	     where  map_id_ip = '".trim($rr['ip_id'])."'
	            	     ";
	            $rh2  = $this->dbH->query($SQL2);
	            $functDB->dberror_show($rh2);
	            $rr2 = $rh2->fetch();
	            if ($rr2['map_id_aset'] > 0) {

		            die($rr2['map_id_aset'].'');
	            }
	            else {

		            die('Data server dari IP '.$rr['ip_number'].' Tidak ditemukan');
	            }
            }
            else {

	            die('IP Address tidak ditemukan.');
            }

	    }
	    else {

		    die('Error! misslink ID');
	    }

    }

    function buildGrid($tmp = '') {

        $SQL  = " select   ref_ip.*,
                           ip_id as id,
                           case when ref_ip.ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                           replace(get_ip_aset2(ip_id),', ','<BR>') as aset,
                           replace(get_ip_domain(ip_id),', ','<BR>') as domain
                  from     ref_ip
                  order by INET_ATON(ip_number)
                  ";

        $sgkMod =& $this->loadModule('smartGridKendo');

        $sgkMod->directive['sql_sql'] = $SQL;
        $sgkMod->directive['element_title'] = 'Daftar IP Address IDC KOMINFO';
        $sgkMod->directive['sm_function'] = 'buildGrid';
        $sgkMod->directive['ds_read_url'] = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

        $sgkMod->directive['element_add_formtechnique'] = 'jsf';
        $sgkMod->directive['element_add_jsf'] = 'addNewData()';
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

        $sgkMod->directive['wrapper_useDefault'] = false;

        $sgkMod->directive['inw3x3_headleft'] = array('add','custom');
        $sgkMod->directive['inw3x3_headright'] = array('search');
        $sgkMod->directive['inw3x3_footright'] = array('print','download');
        
        $sgkMod->directive['gridBtnCustom_js'] = 'addRange()';
        $sgkMod->directive['gridBtnCustom_label'] = 'Add Range';
        
        $sgkMod->directive['grid_isgroupable'] = false;
        $sgkMod->directive['grid_isselectable'] = true;
        $sgkMod->directive['grid_columnmenu'] = false;
        $sgkMod->directive['grid_isfilterable'] = false;
        $sgkMod->directive['grid_isresize'] = false;
        $sgkMod->directive['grid_isreorder'] = false;

        $sgkMod->directive['grid_fields'] = array(
        	'ip_number' => 'IP Address',
        	'aset' => 'Pemetaan Ke Aset',
            'domain' => 'Pemetaan Ke Domain',
            'status_visible' => 'Tampil?',
        );

        $sgkMod->directive['grid_fields_width'] = array(
        	'aset' => '150',
            'domain' => '150',
        	'status_visible' => '100',
        );

        $sgkMod->directive['grid_fields_type'] = array(
        );

        $sgkMod->directive['grid_fields_format'] = array(
        );

        $sgkMod->directive['grid_fields_ishtml'] = array(
            'aset' => true,
            'domain' => true,
        );

        $sgkMod->directive['grid_fields_inithide'] = array(

        );

        return $sgkMod->run();

    }
    
    function formRange() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $form =& $this->newSmartForm();
        
        $fTpt =& $form->loadTemplate('/ref2015/refIP_rangedForm_sf.tpt');
        
        $form->directive['formParams'] = ' role="form" ';
        $form->directive['formClassTag'] = 'form-horizontal';
        $form->directive['onSubEvent'] = 'onsubmit="return confirmSave();"';
        
        
        $form->add('submit','','submit',false,'Save',array('extraAttributes'=>' value="Save" '));

        $form->runForm();

        if ($form->dataVerified()) {

           // die('test123 '.print_r($_POST));
           $msg = '';
           
           if ( $this->checkIPv4() ) {
               
               // verify data
               if ( ($_POST['ipv4_1'] >= 0) && ($_POST['ipv4_1'] <= 255) ) {
                   if ( ($_POST['ipv4_2'] >= 0) && ($_POST['ipv4_2'] <= 255) ) {
                       if ( ($_POST['ipv4_3'] >= 0) && ($_POST['ipv4_3'] <= 255) ) {
                           if ( ($_POST['ipv4_4'] >= 0) && ($_POST['ipv4_4'] <= 255) ) {
                               
                               $codeCounter = 0;
                               $codeCounterMax = 0;
                               if ($_POST['ipv4_c'] > 0) {
                                   $codeCounterMax = $_POST['ipv4_c'];
                               }
                               
                               $c2mark = 0;
                               $c3mark = 0;
                               $c4mark = 0;
                               
                               $c1 = $_POST['ipv4_1']; 
                               while (($c1 <= 255) && ($codeCounter < $codeCounterMax)) {
                                   if ($c2mark == 0) {
                                       $c2 = $_POST['ipv4_2']; 
                                       $c2mark = 1;
                                   }
                                   else {
                                       $c2 = 0;
                                   }
                                   while (($c2 <= 255) && ($codeCounter < $codeCounterMax)) {
                                       if ($c3mark == 0) {
                                           $c3 = $_POST['ipv4_3']; 
                                           $c3mark = 1;
                                       }
                                       else {
                                           $c3 = 0;
                                       }
                                       while (($c3 <= 255) && ($codeCounter < $codeCounterMax)) {
                                           if ($c4mark == 0) {
                                               $c4 = $_POST['ipv4_4']; 
                                               $c4mark = 1;
                                           }
                                           else {
                                               $c4 = 0;
                                           }
                                           while (($c4 <= 255) && ($codeCounter < $codeCounterMax)) {
                                               $codeCounter++;
                                               $full_ipv = $c1.'.'.$c2.'.'.$c3.'.'.$c4;
                                               // echo($codeCounter.'. '.$full_ipv.'<BR>');
                                               
                                               $ip_number = $functDB->encap_string($full_ipv);
                                               $arrData = array ( 'ip_number' => $ip_number,
                                                                  'ref_stat_visible' => 1,
                                                                  'ref_stat_inp_by' => $member['idxNum'],
                                                                  'ref_stat_inp_time' => 'now()',
                                                                  );
                                               $functDB->dbins('ref_ip',$arrData);
                                               
                                               $c4++;
                                           }
                                           $c3++;
                                       }
                                       $c2++;
                                   }
                                   $c1++;
                               }
                               
                               /*
                               for ($c1 = $_POST['ipv4_1']; (($c1 <= 255) && ($codeCounter < $codeCounterMax)); $c1++) {
                                   for ($c2 = $_POST['ipv4_2']; (($c2 <= 255) && ($codeCounter < $codeCounterMax)); $c2++) {
                                        for ($c3 = $_POST['ipv4_3']; (($c3 <= 255) && ($codeCounter < $codeCounterMax)); $c3++) {
                                            for ($c4 = $_POST['ipv4_4']; (($c4 <= 255) && ($codeCounter < $codeCounterMax)); $c4++) {
                                                $codeCounter++;
                                                $full_ipv = $c1.'.'.$c2.'.'.$c3.'.'.$c4;
                                                echo($codeCounter.'. '.$full_ipv.'<BR>');
                                            }
                                        }
                                   }
                               }
                               */
                               
                               // die('ipv4 created.');
                               
                           }
                           else {
                               $msg = '<script type="text/javascript">alert("Error IPv4 entry on 4th segment.");</script>';
                           }
                       }
                       else {
                           $msg = '<script type="text/javascript">alert("Error IPv4 entry on 3rd segment.");</script>';
                       }
                   }
                   else {
                       $msg = '<script type="text/javascript">alert("Error IPv4 entry on 2nd segment.");</script>';
                   }
               }
               else {
                   $msg = '<script type="text/javascript">alert("Error IPv4 entry on 1st segment.");</script>';
               }
               
               return $msg.$form->output();
           }
           elseif ( $this->checkIPv6() ) {
               
               // verify data
               if ( (hexdec($_POST['ipv6_1']) >= 0) && (hexdec($_POST['ipv6_1']) <= 65535) ) {
                   if ( (hexdec($_POST['ipv6_2']) >= 0) && (hexdec($_POST['ipv6_2']) <= 65535) ) {
                       if ( (hexdec($_POST['ipv6_3']) >= 0) && (hexdec($_POST['ipv6_3']) <= 65535) ) {
                           if ( (hexdec($_POST['ipv6_4']) >= 0) && (hexdec($_POST['ipv6_4']) <= 65535) ) {
                               if ( (hexdec($_POST['ipv6_5']) >= 0) && (hexdec($_POST['ipv6_5']) <= 65535) ) {
                                   if ( (hexdec($_POST['ipv6_6']) >= 0) && (hexdec($_POST['ipv6_6']) <= 65535) ) {
                                       if ( (hexdec($_POST['ipv6_7']) >= 0) && (hexdec($_POST['ipv6_7']) <= 65535) ) {
                                           if ( (hexdec($_POST['ipv6_8']) >= 0) && (hexdec($_POST['ipv6_8']) <= 65535) ) {
                                       
                                               $codeCounter = 0;
                                               $codeCounterMax = 0;
                                               if ($_POST['ipv6_c'] > 0) {
                                                   $codeCounterMax = $_POST['ipv6_c'];
                                               }
                                               
                                               $c2mark = 0;
                                               $c3mark = 0;
                                               $c4mark = 0;
                                               $c5mark = 0;
                                               $c6mark = 0;
                                               $c7mark = 0;
                                               $c8mark = 0;
                                               
                                               $c1 = hexdec($_POST['ipv6_1']); 
                                               while (($c1 <= 255) && ($codeCounter < $codeCounterMax)) {
                                                   if ($c2mark == 0) {
                                                       $c2 = hexdec($_POST['ipv6_2']); 
                                                       $c2mark = 1;
                                                   }
                                                   else {
                                                       $c2 = 0;
                                                   }
                                                   while (($c2 <= 255) && ($codeCounter < $codeCounterMax)) {
                                                       if ($c3mark == 0) {
                                                           $c3 = hexdec($_POST['ipv6_3']); 
                                                           $c3mark = 1;
                                                       }
                                                       else {
                                                           $c3 = 0;
                                                       }
                                                       while (($c3 <= 255) && ($codeCounter < $codeCounterMax)) {
                                                           if ($c4mark == 0) {
                                                               $c4 = hexdec($_POST['ipv6_4']); 
                                                               $c4mark = 1;
                                                           }
                                                           else {
                                                               $c4 = 0;
                                                           }
                                                           while (($c4 <= 255) && ($codeCounter < $codeCounterMax)) {
                                                               if ($c5mark == 0) {
                                                                   $c5 = hexdec($_POST['ipv6_5']); 
                                                                   $c5mark = 1;
                                                               }
                                                               else {
                                                                   $c5 = 0;
                                                               }
                                                               while (($c5 <= 255) && ($codeCounter < $codeCounterMax)) {
                                                                   if ($c6mark == 0) {
                                                                       $c6 = hexdec($_POST['ipv6_6']); 
                                                                       $c6mark = 1;
                                                                   }
                                                                   else {
                                                                       $c6 = 0;
                                                                   }
                                                                   while (($c6 <= 255) && ($codeCounter < $codeCounterMax)) {
                                                                       if ($c7mark == 0) {
                                                                           $c7 = hexdec($_POST['ipv6_7']); 
                                                                           $c7mark = 1;
                                                                       }
                                                                       else {
                                                                           $c7 = 0;
                                                                       }
                                                                       while (($c7 <= 255) && ($codeCounter < $codeCounterMax)) {
                                                                           if ($c8mark == 0) {
                                                                               $c8 = hexdec($_POST['ipv6_8']); 
                                                                               $c8mark = 1;
                                                                           }
                                                                           else {
                                                                               $c8 = 0;
                                                                           }
                                                                           while (($c8 <= 255) && ($codeCounter < $codeCounterMax)) {
                                                                               $codeCounter++;
                                                                               $full_ipv = dechex($c1).':'.
                                                                                           dechex($c2).':'.
                                                                                           dechex($c3).':'.
                                                                                           dechex($c4).':'.
                                                                                           dechex($c5).':'.
                                                                                           dechex($c6).':'.
                                                                                           dechex($c7).':'.
                                                                                           dechex($c8);
                                                                               // echo($codeCounter.'. '.$full_ipv.'<BR>');
                                                                               
                                                                               $ip_number = $functDB->encap_string($full_ipv);
                                                                               $arrData = array ( 'ip_number' => $ip_number,
                                                                                                  'ref_stat_visible' => 1,
                                                                                                  'ref_stat_inp_by' => $member['idxNum'],
                                                                                                  'ref_stat_inp_time' => 'now()',
                                                                                                  );
                                                                               $functDB->dbins('ref_ip',$arrData);
                                                                               
                                                                               $c8++;
                                                                           }
                                                                           $c7++;
                                                                       }
                                                                       $c6++;
                                                                   }
                                                                   $c5++;
                                                               }
                                                               $c4++;
                                                           }
                                                           $c3++;
                                                       }
                                                       $c2++;
                                                   }
                                                   $c1++;
                                               }
                                               
                                               /*
                                               for ($c1 = hexdec($_POST['ipv6_1']); (($c1 <= 255) && ($codeCounter < $codeCounterMax)); $c1++) {
                                                   for ($c2 = hexdec($_POST['ipv6_2']); (($c2 <= 255) && ($codeCounter < $codeCounterMax)); $c2++) {
                                                       for ($c3 = hexdec($_POST['ipv6_3']); (($c3 <= 255) && ($codeCounter < $codeCounterMax)); $c3++) {
                                                           for ($c4 = hexdec($_POST['ipv6_4']); (($c4 <= 255) && ($codeCounter < $codeCounterMax)); $c4++) {
                                                               for ($c5 = hexdec($_POST['ipv6_5']); (($c5 <= 255) && ($codeCounter < $codeCounterMax)); $c5++) {
                                                                   for ($c6 = hexdec($_POST['ipv6_6']); (($c6 <= 255) && ($codeCounter < $codeCounterMax)); $c6++) {
                                                                       for ($c7 = hexdec($_POST['ipv6_7']); (($c7 <= 255) && ($codeCounter < $codeCounterMax)); $c7++) {
                                                                           for ($c8 = hexdec($_POST['ipv6_8']); (($c8 <= 255) && ($codeCounter < $codeCounterMax)); $c8++) {
                                                                               
                                                                               $codeCounter++;
                                                                               $full_ipv = dechex($c1).':'.
                                                                                           dechex($c2).':'.
                                                                                           dechex($c3).':'.
                                                                                           dechex($c4).':'.
                                                                                           dechex($c5).':'.
                                                                                           dechex($c6).':'.
                                                                                           dechex($c7).':'.
                                                                                           dechex($c8);
                                                                               echo($codeCounter.'. '.$full_ipv.'<BR>');
                                                                               
                                                                           }
                                                                       }
                                                                   }    
                                                               }        
                                                           }   
                                                       }
                                                   }
                                               }
                                               */
                                       
                                               // die('ipv6 created.');
                                           }
                                           else {
                                               $msg = '<script type="text/javascript">alert("Error IPv6 entry on 8th segment.");</script>';
                                           }       
                                       }
                                       else {
                                           $msg = '<script type="text/javascript">alert("Error IPv6 entry on 7th segment.");</script>';
                                       }        
                                   }
                                   else {
                                       $msg = '<script type="text/javascript">alert("Error IPv6 entry on 6th segment.");</script>';
                                   }    
                               }
                               else {
                                   $msg = '<script type="text/javascript">alert("Error IPv6 entry on 5th segment.");</script>';
                               }    
                           }
                           else {
                               $msg = '<script type="text/javascript">alert("Error IPv6 entry on 4th segment.");</script>';
                           }    
                       }
                       else {
                           $msg = '<script type="text/javascript">alert("Error IPv6 entry on 3rd segment.");</script>';
                       }    
                   }
                   else {
                       $msg = '<script type="text/javascript">alert("Error IPv6 entry on 2nd segment.");</script>';
                   }    
               }
               else {
                   $msg = '<script type="text/javascript">alert("Error IPv6 entry on 1st segment.");</script>';
               }    
                   
                
               return $msg.$form->output();
           }
           else {
               
               $msg = '<script type="text/javascript">alert("Error! IPv4 or IPv6 empty.");</script>';
               return $msg.$form->output();
           }

        }
        else {

            return ($form->output());
        }
    }
    
    function checkIPv4() {
        if (
            ($_POST['ipv4_1'] > 0) ||
            ($_POST['ipv4_2'] > 0) ||
            ($_POST['ipv4_3'] > 0) ||
            ($_POST['ipv4_4'] > 0) 
        ) {
            return true;
        }
        else {
            return false;
        }
    }
    
    function checkIPv6() {
        if (
            ($_POST['ipv6_1'] > 0) ||
            ($_POST['ipv6_2'] > 0) ||
            ($_POST['ipv6_3'] > 0) ||
            ($_POST['ipv6_4'] > 0) ||
            ($_POST['ipv6_5'] > 0) ||
            ($_POST['ipv6_6'] > 0) ||
            ($_POST['ipv6_7'] > 0) ||
            ($_POST['ipv6_8'] > 0) 
        ) {
            return true;
        }
        else {
            return false;
        }
    }

    function formAddData() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $form =& $this->newSmartForm();
        
        $form->directive['formParams'] = ' role="form" ';
        $form->directive['formClassTag'] = 'form-horizontal';
        
        if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit')) {

            $SQL = " select * from ref_ip where ip_id = '".$this->getVar('rNum')."' ";
            $rh  = $this->dbH->query($SQL);
            $functDB->dberror_show($rh);
            $rr = $rh->fetch();
        }
        else {

        }

        $form->add('ip_number','IP Address (!)','text',true,$rr['ip_number'],array('extraAttributes'=>' style="width:250px;" '));

        $selEnt =& $form->add('ref_stat_visible','Status Tampil (!)','kendoCombo',true,$rr['ref_stat_visible'],array('extraAttributes'=>' style="width:250px;" '));
        $selEnt->addOption('Tampil pada daftar pilihan','1');
        $selEnt->addOption('Sembunyikan pada daftar pilihan','2');

        if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit')) {

            $select =& $form->add('form_aksi','Ubah/Hapus?','kendoCombo',true,1,array('extraAttributes'=>' style="width:150px;" onchange="if (this.value==9) { if (window.confirm(\'Yakin akan menghapus?\')) { } else { var combobox = $(\'#form_aksi\').data(\'kendoComboBox\'); combobox.value(\'1\'); } } " '));
            $select->addOption('Ubah Data','1');
            $select->addOption('Hapus','9');
        }

        $form->add('submit','','submit',false,'Save',array('extraAttributes'=>' value="Save" '));

        $form->runForm();

        if ($form->dataVerified()) {

           $ip_number = $functDB->encap_string($form->getVar('ip_number'),1);
           $ref_stat_visible = $functDB->encap_numeric($form->getVar('ref_stat_visible'));
           $form_aksi = $functDB->encap_numeric($form->getVar('form_aksi'));
           
           $url_grid = $this->sessionH->uLink('m2.php').'&option='.$this->getVar('option');

           if (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '1')) {

	            $arrData = array (  'ip_number' => $ip_number,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_inp_by' => $member['idxNum'],
                                    'ref_stat_inp_time' => 'now()',
                                    );
                $functDB->dbupd("ref_ip",$arrData,"ip_id = ".$this->getVar('rNum'));

                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            elseif (($this->getVar('rNum') > 0) && ($this->getVar('sType') == 'edit') && ($form_aksi == '9')) {

                // allowed to delete
                $functDB->dbdelete("ref_ip","ip_id = ".$this->getVar('rNum'),'');
                die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }
            else {

                 $arrData = array ( 'ip_number' => $ip_number,
                                    'ref_stat_visible' => $ref_stat_visible,
                                    'ref_stat_inp_by' => $member['idxNum'],
                                    'ref_stat_inp_time' => 'now()',
                                    );

                 $functDB->dbins('ref_ip',$arrData);

                 die('<SCRIPT LANGUAGE="JavaScript">window.location.href = "'.$url_grid.'";</SCRIPT>');
            }

        }
        else {

            return ($form->output());
        }
    }

}


?>
