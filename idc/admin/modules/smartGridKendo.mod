<?php

/*
    revision history :




*/

class smartGridKendo extends SM_module {

     var $elmnt_html = '';

     var $elmnt_jsScript = '';

     var $elmnt_jsScriptInJqReady = '';

     function moduleConfig() {

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
        $this->addInVar('sgSt','');
        $this->addInVar('sgID','');
        $this->addInVar('swid','');
        $this->addInVar('aswid','');

        // load directive
        $this->directive['dbconn'] = '';

        // smartgrid config
        if (strlen(trim($this->getVar('sgID'))) > 0) {
            $this->directive['sgk_id'] = $this->getVar('sgID');
        }
        else {
            $this->directive['sgk_id'] = 'sgk'.rand(100,999);
        }

        // grid content wrapper
        $this->directive['wrapper_useDefault'] = true;
        $this->directive['wrapper_customBegin'] = '';
        $this->directive['wrapper_customEnd'] = '';

        // grid inner content wrapper
        $this->directive['innerwrapper_useDefault'] = true;
        $this->directive['innerwrapper_useDefault_type'] = '3x3';
        $this->directive['innerwrapper_customBegin'] = '';
        $this->directive['innerwrapper_customEnd'] = '';
        
        $this->directive['innerwrapper_bgcolor'] = '#1D89CF';
        

        // inner content wrapper, 3x3 default setup
        $this->directive['inw3x3_headleft'] = array('hint','add');
        $this->directive['inw3x3_head'] = array('title');
        $this->directive['inw3x3_headright'] = array('search','help');
        $this->directive['inw3x3_footleft'] = array('');
        $this->directive['inw3x3_foot'] = array('');
        $this->directive['inw3x3_footright'] = array('clear','download','print');

        // element content
        $this->directive['element_hint'] = 'this is a sample of hint text';
        $this->directive['element_help'] = 'help help help help help help help help this is a sample of help text';
        $this->directive['element_title'] = 'title of the grid';
        $this->directive['element_add_title'] = 'Add';
        $this->directive['element_add_formtechnique'] = 'showform'; // showform, changepage, jsf
        $this->directive['element_add_popupwidth'] = '550';
        $this->directive['element_add_popupheight'] = '350';
        $this->directive['element_add_url'] = '';
        $this->directive['element_add_jsf'] = '';

        // datasource
        $this->directive['ds_pageSize'] = '25';
        $this->directive['ds_dataField'] = 'id';
        $this->directive['ds_read_url'] = '';
        
        $this->directive['sgk_ds_extracode'] = '';

        // sitemanager
        $this->directive['sm_function'] = 'buildGrid';

        // grid
        $this->directive['grid_isgroupable'] = true;
        $this->directive['grid_issortable'] = true;
        $this->directive['grid_isscrollable'] = false;
        $this->directive['grid_ispageable'] = true;
        $this->directive['grid_isfilterable'] = true;
        $this->directive['grid_isnavigatable'] = false;
        $this->directive['grid_isselectable'] = true;
        $this->directive['grid_server_process'] = true;
        $this->directive['grid_editable'] = false;
        $this->directive['grid_columnmenu'] = false;
        $this->directive['grid_isresize'] = true;
        $this->directive['grid_isreorder'] = true;

        $this->directive['grid_crud'] = false;
        $this->directive['grid_crud_batch'] = false;
        $this->directive['grid_crud_iscreate'] = false;
        $this->directive['grid_crud_urlcreate'] = '';
        $this->directive['grid_crud_isedit'] = false;
        $this->directive['grid_crud_urledit'] = '';
        $this->directive['grid_crud_isdelete'] = false;
        $this->directive['grid_crud_urldelete'] = '';

        $this->directive['grid_fields_crud_editable'] = array();
        $this->directive['grid_fields_crud_nullable'] = array();
        $this->directive['grid_fields_crud_validation'] = array();

        $this->directive['grid_rowTemplate'] = '';
        $this->directive['grid_detailTemplate'] = '';
        $this->directive['grid_detailInit'] = '';

        $this->directive['grid_customInit'] = '';

        $this->directive['grid_fields_template'] = array();
        $this->directive['grid_fields_format'] = array();
        $this->directive['grid_fields_isnotsortable'] = array();
        $this->directive['grid_fields_isnotfilterable'] = array();
        $this->directive['grid_fields_ishtml'] = array();
        $this->directive['grid_fields_width'] = array();
        $this->directive['grid_fields_type'] = array();
        $this->directive['grid_fields'] = array();
        $this->directive['grid_fields_align'] = array();
        $this->directive['grid_fields_inithide'] = array();

        $this->directive['grid_fieldsCustomButton'] = '';

        // link to another extention
        $this->directive['gridBtnCustom_isUsed'] = false;
        $this->directive['gridBtnCustom_Ext'] = '';
        $this->directive['gridBtnCustom_function'] = 'buildPdf';
        $this->directive['gridBtnCustom_label'] = 'Custom';
        $this->directive['gridBtnCustom_icon'] = 'ic20_white_info';

        // fields button
        $this->directive['grid_btnDetail'] = true;
        $this->directive['grid_btnEdit'] = true;
        $this->directive['grid_btnDelete'] = true;

        $this->directive['grid_btnDetail_useDefault'] = true;
        $this->directive['grid_btnEdit_useDefault'] = true;
        $this->directive['grid_btnDelete_useDefault'] = true;

        $this->directive['grid_btnDetail_useIcon'] = './images/icons/ic20_white_info.png';
        $this->directive['grid_btnEdit_useIcon'] = './images/icons/ic20_white_pencil.png';
        $this->directive['grid_btnDelete_useIcon'] = './images/icons/ic20_white_cancel.png';

        $this->directive['grid_btnDetail_iconStyle'] = '';
        $this->directive['grid_btnEdit_iconStyle'] = '';
        $this->directive['grid_btnDelete_iconStyle'] = '';

        $this->directive['grid_btnDetail_icon'] = './images/icons/ic20_white_info.png';
        $this->directive['grid_btnEdit_icon'] = './images/icons/ic20_white_pencil.png';
        $this->directive['grid_btnDelete_icon'] = './images/icons/ic20_white_cancel.png';

        $this->directive['grid_btnDetail_jsfAuto'] = true;
        $this->directive['grid_btnEdit_jsfAuto'] = true;
        $this->directive['grid_btnDelete_jsfAuto'] = true;

        $this->directive['grid_btnDetail_jsfAuto_url'] = true;
        $this->directive['grid_btnEdit_jsfAuto_url'] = true;
        $this->directive['grid_btnDelete_jsfAuto_url'] = true;

        $this->directive['grid_btnDetail_win_url'] = '';
        $this->directive['grid_btnEdit_win_url'] = '';
        $this->directive['grid_btnDelete_win_url'] = '';

        $this->directive['grid_btnDetail_pop_url'] = '';
        $this->directive['grid_btnDetail_pop_width'] = '640';
        $this->directive['grid_btnDetail_pop_height'] = '480';
        $this->directive['grid_btnEdit_pop_url'] = '';
        $this->directive['grid_btnEdit_pop_width'] = '640';
        $this->directive['grid_btnEdit_pop_height'] = '480';
        $this->directive['grid_btnDelete_pop_url'] = '';
        $this->directive['grid_btnDelete_pop_width'] = '640';
        $this->directive['grid_btnDelete_pop_height'] = '480';

        $this->directive['grid_btnDetail_jsfCustom'] = '';
        $this->directive['grid_btnEdit_jsfCustom'] = '';
        $this->directive['grid_btnDelete_jsfCustom'] = '';

        // query execution
        $this->directive['sql_sql'] = '';

        // grid method
        $this->directive['sgk_reload_jsf'] = 'jsf_'.$this->directive['sgk_id'].'_reload()';
        $this->directive['sgk_reload_jsf_usecustom'] = false;

        // snippet (sub detail mechanism)
        $this->directive['snippet_used'] = false;
        $this->directive['snippet_label'] = array();
        $this->directive['snippet_smmodule'] = array();
        $this->directive['snippet_smfunctions'] = array();
    }

    function moduleThink() {

        if ($this->getVar('popMode') == 'ajxcall') {
            switch($this->getVar('sgSt')) {
                case 'create' : $this->sqlCreate(); break;
                case 'destroy' : $this->sqlDestroy(); break;
                case 'update' : $this->sqlUpdate(); break;
                case 'read' : $this->sqlRead(); break;
            }
        }
        elseif ($_POST['sBtn'] == 'dl') {

            $gridConfig = array();

            $gridConfig['fields'] = $this->directive['grid_fields'];
            $gridConfig['colwidth'] = $this->directive['grid_fields_width'];
            $gridConfig['title'] = $this->directive['element_title'];

            $gridConfig['snippet_used'] = $this->directive['snippet_used'];
            $gridConfig['snippet_label'] = $this->directive['snippet_label'];
            $gridConfig['snippet_smmodule'] = $this->directive['snippet_smmodule'];
            $gridConfig['snippet_smfunctions'] = $this->directive['snippet_smfunctions'];

            $gridConfig['ds_dataField'] = $this->directive['ds_dataField'];

            $gridConfig['grid_fields_type'] = $this->directive['grid_fields_type'];
            $gridConfig['grid_fields_format'] = $this->directive['grid_fields_format'];
            $gridConfig['grid_fields_align'] = $this->directive['grid_fields_align'];

            $SQL = $this->directive['sql_sql'];

            $smgExt =& $this->loadModule('smartGridKendo_Ext');
            $smgExt->directive['grid_fields_ishtml'] = $this->directive['grid_fields_ishtml'];
            $smgExt->directive['grid_fields_type']   = $this->directive['grid_fields_type'];
            $smgExt->directive['grid_fields']   = $this->directive['grid_fields'];
            $smgExt->buildXls($SQL, $gridConfig);

            die('stop');
        }
        elseif ($_POST['sBtn'] == 'custom') {

            $gridConfig = array();

            $gridConfig['fields'] = $this->directive['grid_fields'];
            $gridConfig['colwidth'] = $this->directive['grid_fields_width'];
            $gridConfig['title'] = $this->directive['element_title'];

            $gridConfig['snippet_used'] = $this->directive['snippet_used'];
            $gridConfig['snippet_label'] = $this->directive['snippet_label'];
            $gridConfig['snippet_smmodule'] = $this->directive['snippet_smmodule'];
            $gridConfig['snippet_smfunctions'] = $this->directive['snippet_smfunctions'];

            $gridConfig['ds_dataField'] = $this->directive['ds_dataField'];

            $gridConfig['grid_fields_type'] = $this->directive['grid_fields_type'];
            $gridConfig['grid_fields_format'] = $this->directive['grid_fields_format'];
            $gridConfig['grid_fields_align'] = $this->directive['grid_fields_align'];

            $SQL = $this->directive['sql_sql'];

            if ($this->directive['gridBtnCustom_isUsed']) {
                if ((strlen(trim($this->directive['gridBtnCustom_Ext']))>0) && (strlen(trim($this->directive['gridBtnCustom_function']))>0)) {
                    $smgExt =& $this->loadModule($this->directive['gridBtnCustom_Ext']);
                    $smgExt->directive['grid_fields_ishtml'] = $this->directive['grid_fields_ishtml'];
                    $smgExt->directive['grid_fields_type']   = $this->directive['grid_fields_type'];
                    $smgExt->directive['grid_fields']   = $this->directive['grid_fields'];
                    eval('$smgExt->'.$this->directive['gridBtnCustom_function'].'($SQL, $gridConfig);');
                    // $smgExt->buildXls($SQL, $gridConfig);
                }
                elseif (strlen(trim($this->directive['gridBtnCustom_function']))>0) {
                    $smgExt =& $this->loadModule('smartGridKendo_Ext');
                    $smgExt->directive['grid_fields_ishtml'] = $this->directive['grid_fields_ishtml'];
                    $smgExt->directive['grid_fields_type']   = $this->directive['grid_fields_type'];
                    $smgExt->directive['grid_fields']   = $this->directive['grid_fields'];
                    eval('$smgExt->'.$this->directive['gridBtnCustom_function'].'($SQL, $gridConfig);');
                }
            }
            die('stop');
        }
        elseif ($_POST['sBtn'] == 'pRn') {

            $gridConfig = array();

            $gridConfig['fields'] = $this->directive['grid_fields'];
            $gridConfig['colwidth'] = $this->directive['grid_fields_width'];
            $gridConfig['title'] = $this->directive['element_title'];

            $gridConfig['snippet_used'] = $this->directive['snippet_used'];
            $gridConfig['snippet_label'] = $this->directive['snippet_label'];
            $gridConfig['snippet_smmodule'] = $this->directive['snippet_smmodule'];
            $gridConfig['snippet_smfunctions'] = $this->directive['snippet_smfunctions'];

            $gridConfig['ds_dataField'] = $this->directive['ds_dataField'];

            $gridConfig['grid_fields_type'] = $this->directive['grid_fields_type'];
            $gridConfig['grid_fields_format'] = $this->directive['grid_fields_format'];
            $gridConfig['grid_fields_align'] = $this->directive['grid_fields_align'];

            $SQL = $this->directive['sql_sql'];

            $smgExt =& $this->loadModule('smartGridKendo_Ext');
            $smgExt->directive['grid_fields_ishtml'] = $this->directive['grid_fields_ishtml'];
            $smgExt->directive['grid_fields_type']   = $this->directive['grid_fields_type'];
            $smgExt->directive['grid_fields']   = $this->directive['grid_fields'];
            $smgExt->buildPdf($SQL, $gridConfig);

            die('stop');
        }

        // build the grid !
        $html = '';

        // create inner wrapper
        if ($this->directive['innerwrapper_useDefault']) {
            $html  = $this->buildDefaultInnerWrapper($html);
        }
        else {
            $html  = $this->directive['innerwrapper_customBegin'].chr(13).
                       $html.chr(13).
                     $this->directive['innerwrapper_customEnd'].chr(13);
        }

        // create outer wrapper
        if ($this->directive['wrapper_useDefault']) {
            $html  = '<div class="panel">'.chr(13).
                       $html.chr(13).
                     '</div>'.chr(13);
        }
        else {
            $html  = $this->directive['wrapper_customBegin'].chr(13).
                       $html.chr(13).
                     $this->directive['wrapper_customEnd'].chr(13);
        }

        $html .= $this->elmnt_html . chr(13);
        $html .= '<script type="text/javascript">'.chr(13);
        $html .= '<!--'.chr(13);
        $html .= $this->elmnt_jsScript . chr(13);
        $html .= '$(document).ready(function($){'.chr(13);
        $html .= $this->elmnt_jsScriptInJqReady . chr(13);
        $html .= '});'.chr(13);
        $html .= '-->'.chr(13);
        $html .= '</script>'.chr(13);

        $this->say($html);

    }

    function sqlCreate() {
        $this->sqlRead();
    }

    function sqlDestroy() {
        $this->sqlRead();
    }

    function sqlUpdate() {
        $this->sqlRead();
    }

    function sqlRead_execute($SQL) {

        if (strlen(trim($this->directive['dbconn']))>0) {
            $rhS  = $this->dbHL[$this->directive['dbconn']]->query($SQL);
            if ($this->dbHL[$this->directive['dbconn']]->errorCode() > 0) {
                $pdoDbErrorInfo = $this->dbHL[$this->directive['dbconn']]->errorInfo();
                die($pdoDbErrorInfo[0].'-'.$pdoDbErrorInfo[1].': '.$pdoDbErrorInfo[2]);
            }
        }
        else {
            $rhS  = $this->dbH->query($SQL);
            if ($this->dbH->errorCode() > 0) {
                $pdoDbErrorInfo = $this->dbH->errorInfo();
                die($pdoDbErrorInfo[0].'-'.$pdoDbErrorInfo[1].': '.$pdoDbErrorInfo[2]);
            }
        }
        $arrayData = array();
        $noUrut = 0;
        while ($rrS = $rhS->fetch()) {
            $noUrut++;

            // snippet, row icons
            $html_btnDetail = '';
            $html_btnEdit = '';
            $html_btnDelete = '';

            if ($this->directive['grid_btnDetail']) {

                if ($this->directive['grid_btnDetail_useDefault']) {
                    $html_btnDetail_onclick = 'jsf_'.$this->directive['sgk_id'].'_btndetail(\''.$rrS[$this->directive['ds_dataField']].'\')';
                }
                elseif (strlen(trim($this->directive['grid_btnDetail_win_url']))>0) {
                    $html_btnDetail_onclick = "window.location = '".$this->directive['grid_btnDetail_win_url']."&rNum=".$rrS[$this->directive['ds_dataField']]."'; ";
                }
                elseif (strlen(trim($this->directive['grid_btnDetail_pop_url']))>0) {
                    $html_btnDetail_onclick = "showForm(".$this->directive['grid_btnDetail_pop_width'].",".$this->directive['grid_btnDetail_pop_height'].",'_new','".$this->directive['grid_btnDetail_pop_url']."&rNum=".$rrS[$this->directive['ds_dataField']]."'); ";
                }
                elseif (strlen(trim($this->directive['grid_btnDetail_jsfCustom']))>0) {
                    $html_btnDetail_onclick = $this->directive['grid_btnDetail_jsfCustom'].'(\''.$rrS[$this->directive['ds_dataField']].'\')';
                }

                $html_btnDetail = '<img src="'.$this->directive['grid_btnDetail_useIcon'].'" onmouseover="gridbtn_over(this)" onmouseout="gridbtn_out(this)" style="border:1px solid #CACACA; '.$this->directive['grid_btnDetail_iconStyle'].'" onclick="'.$html_btnDetail_onclick.'">';
            }

            if ($this->directive['grid_btnEdit']) {

                if ($this->directive['grid_btnEdit_useDefault']) {
                    $html_btnEdit_onclick = 'jsf_'.$this->directive['sgk_id'].'_btnedit(\''.$rrS[$this->directive['ds_dataField']].'\')';
                }
                elseif (strlen(trim($this->directive['grid_btnEdit_jsfCustom']))>0) {
                    $html_btnEdit_onclick = $this->directive['grid_btnEdit_jsfCustom'].'(\''.$rrS[$this->directive['ds_dataField']].'\')';
                }

                $html_btnEdit = '<img src="'.$this->directive['grid_btnEdit_useIcon'].'" onmouseover="gridbtn_over(this)" onmouseout="gridbtn_out(this)" style="border:1px solid #CACACA; '.$this->directive['grid_btnEdit_iconStyle'].'" onclick="'.$html_btnEdit_onclick.'">';
            }

            if ($this->directive['grid_btnDelete']) {

                if ($this->directive['grid_btnDelete_useDefault']) {
                    $html_btnDelete_onclick = 'jsf_'.$this->directive['sgk_id'].'_btndelete(\''.$rrS[$this->directive['ds_dataField']].'\')';
                }
                elseif (strlen(trim($this->directive['grid_btnDelete_jsfCustom']))>0) {
                    $html_btnDelete_onclick = $this->directive['grid_btnDelete_jsfCustom'].'(\''.$rrS[$this->directive['ds_dataField']].'\')';
                }

                $html_btnDelete = '<img src="'.$this->directive['grid_btnDelete_useIcon'].'" onmouseover="gridbtn_over(this)" onmouseout="gridbtn_out(this)" style="border:1px solid #CACACA; '.$this->directive['grid_btnDelete_iconStyle'].'" onclick="'.$html_btnDelete_onclick.'">';
            }

            $rrS['btnDetail'] = $html_btnDetail;
            $rrS['btnEdit'] = $html_btnEdit;
            $rrS['btnDelete'] = $html_btnDelete;

            // do we need to execute additional script ?
            if ($this->directive['snippet_used']) {

                reset($this->directive['snippet_label']);
                while (list($key, $val) = each($this->directive['snippet_label'])) {

                    unset($tmpModule);
                    unset($resultSnippet);

                    $tmpModule =& $this->loadModule($this->directive['snippet_smmodule'][$key]);
                    eval('$resultSnippet = $tmpModule->'.$this->directive['snippet_smfunctions'][$key].'('.$rrS[$this->directive['ds_dataField']].');');

                    if (strlen(trim($resultSnippet)) > 0) {
                        $rrS[$val] = $resultSnippet;
                    }

                }
            }

            reset($rrS);
            while (list($key, $val) = each($rrS)) {
                if ($val == null) {
                    $rrS[$key] = '';
                }
            }

            $arrayData[] = $rrS;
        }

        return $arrayData;
    }

    function sqlRead() {

        $SQL = $this->directive['sql_sql'];

        if($this->directive['grid_server_process'] == true) {

            // create sort and filter SQL
            $modSSP =& $this->loadModule('smartGridKendo_SSP');
            $modSSP->directive['grid_fields_ishtml'] = $this->directive['grid_fields_ishtml'];
            $modSSP->directive['grid_fields_type']   = $this->directive['grid_fields_type'];
            $modSSP->directive['grid_fields']   = $this->directive['grid_fields'];
            $SQL = $modSSP->auto_getSQL($SQL);

            // get total count row for all filtered sql
            $SQLTotal = " select count(*) as jml from ( $SQL ) tmp ";
            
            if (strlen(trim($this->directive['dbconn']))>0) {
                $rhSTotal = $this->dbHL[$this->directive['dbconn']]->query($SQLTotal);
                if ($this->dbHL[$this->directive['dbconn']]->errorCode() > 0) {
                    $pdoDbErrorInfo = $this->dbHL[$this->directive['dbconn']]->errorInfo();
                    die($pdoDbErrorInfo[0].'-'.$pdoDbErrorInfo[1].': '.$pdoDbErrorInfo[2]);
                }
            }
            else {
                $rhSTotal = $this->dbH->query($SQLTotal);
                if ($this->dbH->errorCode() > 0) {
                    $pdoDbErrorInfo = $this->dbH->errorInfo();
                    die($pdoDbErrorInfo[0].'-'.$pdoDbErrorInfo[1].': '.$pdoDbErrorInfo[2]);
                }
            }
            
            $rrSTotal = $rhSTotal->fetch();
            $totalRow = $rrSTotal['jml'];

            // paging setup
            $pageSize = 50;
            if ($_GET['pageSize'] > 0) {
                $pageSize = $_GET['pageSize'];
            }
            $pageRowSkip = 0;
            if ($_GET['take'] > 0) {
                $pageRowSkip = $_GET['skip'];
            }

            // grouping
            if (count($_GET['group'])>0) {

                $arrayDataGroup = array();
                $group = $_GET['group'];
                if (is_array($group) && (count($group)>0)) {

                    $arrayData = $this->sqlRead_execute($SQL);
                    $arrayDataGroup = $this->recurGroupBuilder(0,(count($group)),'','','',$SQL,$group,$pageSize,$pageRowSkip);
                    $arrayGrid = array('total'=>$totalRow,
                                       'group'=>$arrayDataGroup,
                                       'sql'=>$SQL
                                       );
                }
            }
            else {

                // logic for filter
                $SQL = $SQL . " limit ".$pageSize." offset ".$pageRowSkip." ";

                $arrayData = array();
                $arrayData = $this->sqlRead_execute($SQL);
                $arrayGrid = array('total'=>$totalRow,
                                   'result'=>$arrayData,
                                   'sql'=>$SQL
                                   );
            }
        }
        else {

            $arrayData = array();
            $arrayData = $this->sqlRead_execute($SQL);
            $arrayGrid = array('total'=>count($arrayData),
                               'result'=>$arrayData
                               );
        }

        /*
        include('./ext/JSON.php');
        $json = new Services_JSON();
        die($json->encode($arrayGrid));
        */

        die(json_encode($arrayGrid));
        die('');
    }

    function recurGroupBuilder($lvlNow, $lvlMax, $value, $whereall, $aggr, $SQLGroup, $group, $pageSize , $pageRowSkip) {

        if ($lvlNow < $lvlMax) {

            $SQLGetGroup = " select ".$group[$lvlNow]['field']." from (".$SQLGroup.") kdogrp".$lvlNow." group by ".$group[$lvlNow]['field']." order by ".$group[$lvlNow]['field']." ".$group[$lvlNow]['dir']." limit 100";
            
            if (strlen(trim($this->directive['dbconn']))>0) {
                $rhSGetGroup = $this->dbHL[$this->directive['dbconn']]->query($SQLGetGroup);
                if ($this->dbHL[$this->directive['dbconn']]->errorCode() > 0) {
                    $pdoDbErrorInfo = $this->dbHL[$this->directive['dbconn']]->errorInfo();
                    die($pdoDbErrorInfo[0].'-'.$pdoDbErrorInfo[1].': '.$pdoDbErrorInfo[2]);
                }
            }
            else {
                $rhSGetGroup = $this->dbH->query($SQLGetGroup);
                if ($this->dbH->errorCode() > 0) {
                    $pdoDbErrorInfo = $this->dbH->errorInfo();
                    die($pdoDbErrorInfo[0].'-'.$pdoDbErrorInfo[1].': '.$pdoDbErrorInfo[2]);
                }
            }
            
            $noUrutGroup = 0;
            $returnedResult = array();
            while ($rrSGetGroup = $rhSGetGroup->fetch()) {

                $where = $whereall . " and " . $group[$lvlNow]['field'] . " = '" . $rrSGetGroup[$group[$lvlNow]['field']] . "' ";

                if ($lvlNow == ($lvlMax-1)) {

                    // last group

                    $SQLNew = " select * from (".$SQLGroup.") kdogrp".$lvlNow." where true ".$where." limit ".$pageSize." offset ".$pageRowSkip;

                    $itemDetail = array();
                    $itemDetail = $this->sqlRead_execute($SQLNew);

                    $returnedResult[$noUrutGroup]['field']          = $group[$lvlNow]['field'];
                    $returnedResult[$noUrutGroup]['hasSubgroups']   = false;
                    $returnedResult[$noUrutGroup]['items']          = $itemDetail;
                    $returnedResult[$noUrutGroup]['value']          = $rrSGetGroup[$group[$lvlNow]['field']];
                    $returnedResult[$noUrutGroup]['aggregates']     = array();
                }
                else {

                    $itemDetail = $this->recurGroupBuilder(($lvlNow+1), $lvlMax, $rrSGetGroup[$group[$lvlNow]['field']], $where, $aggr, $SQLGroup, $group, $pageSize, $pageRowSkip);

                    $returnedResult[$noUrutGroup]['field']          = $group[$lvlNow]['field'];
                    $returnedResult[$noUrutGroup]['hasSubgroups']   = true;
                    $returnedResult[$noUrutGroup]['items']          = $itemDetail;
                    $returnedResult[$noUrutGroup]['value']          = $rrSGetGroup[$group[$lvlNow]['field']];
                    $returnedResult[$noUrutGroup]['aggregates']     = array();
                }

                $noUrutGroup++;
            }

            return $returnedResult;
        }
        else {

            return '';
        }
    }

    function buildDataSource() {

        $html = '';

        // re-initialize directive
        $urlRead = '';
        if (!(strlen(trim($this->directive['ds_read_url']))>0)) {
            if (strlen(trim($this->directive['sm_function']))>0) {
                $urlRead = $this->sessionH->uLink('main.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid='.$this->directive['sm_function'].'&sgSt=read&sgID='.$this->directive['sgk_id'];
            }
        }
        else {
            $urlRead = $this->directive['ds_read_url'].'&popMode=ajxcall&aswid='.$this->directive['sm_function'].'&sgSt=read&sgID='.$this->directive['sgk_id'];
        }

        $this->elmnt_jsScript .= 'var ds_'.$this->directive['sgk_id'].';'.chr(13);

        $this->elmnt_jsScriptInJqReady .= '   ds_'.$this->directive['sgk_id'].' = new kendo.data.DataSource({ '.chr(13);
        $this->elmnt_jsScriptInJqReady .= '      pageSize: '.$this->directive['ds_pageSize'].', '.chr(13);

        if($this->directive['grid_server_process'] == true) {
            $this->elmnt_jsScriptInJqReady .= '      serverAggregates: true, '.chr(13);
            $this->elmnt_jsScriptInJqReady .= '      serverFiltering: true, '.chr(13);
            $this->elmnt_jsScriptInJqReady .= '      serverGrouping: true, '.chr(13);
            $this->elmnt_jsScriptInJqReady .= '      serverPaging: true, '.chr(13);
            $this->elmnt_jsScriptInJqReady .= '      serverSorting: true, '.chr(13);
            $this->elmnt_jsScriptInJqReady .= '      autoSync: true, '.chr(13);
        }
        else {
            $this->elmnt_jsScriptInJqReady .= '      serverAggregates: false, '.chr(13);
            $this->elmnt_jsScriptInJqReady .= '      serverFiltering: false, '.chr(13);
            $this->elmnt_jsScriptInJqReady .= '      serverGrouping: false, '.chr(13);
            $this->elmnt_jsScriptInJqReady .= '      serverPaging: false, '.chr(13);
            $this->elmnt_jsScriptInJqReady .= '      serverSorting: false, '.chr(13);
        }


        $this->elmnt_jsScriptInJqReady .= '      schema: { total : "total", '.chr(13);
        $this->elmnt_jsScriptInJqReady .= '                data  : "result", '.chr(13);
        $this->elmnt_jsScriptInJqReady .= '                aggregates : "aggregate", '.chr(13);
        $this->elmnt_jsScriptInJqReady .= '                errors : "error", '.chr(13);
        $this->elmnt_jsScriptInJqReady .= '                groups : "group", '.chr(13);
        $this->elmnt_jsScriptInJqReady .= '                model : { id: "'.$this->directive['ds_dataField'].'", fields: { '.$this->buildDataSourceField().' } }, '.chr(13);
        $this->elmnt_jsScriptInJqReady .= '                type : "json" '.chr(13);
        $this->elmnt_jsScriptInJqReady .= '                }, '.chr(13);

        if ($this->directive['grid_crud']) {
            if ($this->directive['grid_crud_batch']) {
                $this->elmnt_jsScriptInJqReady .= '      batch: true, '.chr(13);
            }
            else {
                $this->elmnt_jsScriptInJqReady .= '      batch: false, '.chr(13);
            }
        }

        $this->elmnt_jsScriptInJqReady .= '      transport: { read: { url: "'.$urlRead.'", data: { wSQL: 1, q: function() { return $("#elh_'.$this->directive['sgk_id'].'_searchbox").val(); } '.$this->directive['sgk_ds_extracode'].' }, dataType: "json" } '.chr(13);

        if ($this->directive['grid_crud']) {

            if ($this->directive['grid_crud_iscreate']) {
                $urlCreate = '';
                if (!(strlen(trim($this->directive['grid_crud_urlcreate']))>0)) {
                    if (strlen(trim($this->directive['sm_function']))>0) {
                        $urlCreate = $this->sessionH->uLink('main.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid='.$this->directive['sm_function'].'&sgSt=create&sgID='.$this->directive['sgk_id'];
                    }
                }
                else {
                    $urlCreate = $this->directive['grid_crud_urlcreate'].'&popMode=ajxcall&aswid='.$this->directive['sm_function'].'&sgSt=create&sgID='.$this->directive['sgk_id'];
                }
                $this->elmnt_jsScriptInJqReady .= ', create: { url: "'.$urlCreate.'", data: { wSQL: 1, q: function() { } '.$this->directive['sgk_ds_extracode'].' }, dataType: "json" } '.chr(13);
            }

            if ($this->directive['grid_crud_isedit']) {
                $urlEdit = '';
                if (!(strlen(trim($this->directive['grid_crud_urledit']))>0)) {
                    if (strlen(trim($this->directive['sm_function']))>0) {
                        $urlEdit = $this->sessionH->uLink('main.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid='.$this->directive['sm_function'].'&sgSt=update&sgID='.$this->directive['sgk_id'];
                    }
                }
                else {
                    $urlEdit = $this->directive['grid_crud_urledit'].'&popMode=ajxcall&aswid='.$this->directive['sm_function'].'&sgSt=update&sgID='.$this->directive['sgk_id'];
                }
                $this->elmnt_jsScriptInJqReady .= ', update: { url: "'.$urlEdit.'", data: { wSQL: 1, q: function() { } '.$this->directive['sgk_ds_extracode'].' }, dataType: "json" } '.chr(13);
            }

            if ($this->directive['grid_crud_isdelete']) {
                $urlDelete = '';
                if (!(strlen(trim($this->directive['grid_crud_urldelete']))>0)) {
                    if (strlen(trim($this->directive['sm_function']))>0) {
                        $urlDelete = $this->sessionH->uLink('main.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid='.$this->directive['sm_function'].'&sgSt=delete&sgID='.$this->directive['sgk_id'];
                    }
                }
                else {
                    $urlDelete = $this->directive['grid_crud_urldelete'].'&popMode=ajxcall&aswid='.$this->directive['sm_function'].'&sgSt=delete&sgID='.$this->directive['sgk_id'];
                }
                $this->elmnt_jsScriptInJqReady .= ', destroy: { url: "'.$urlDelete.'", data: { wSQL: 1, q: function() { } '.$this->directive['sgk_ds_extracode'].' }, dataType: "json" } '.chr(13);
            }

        }

        $this->elmnt_jsScriptInJqReady .= '                   } }); '.chr(13);

        return $html;

    }

    function buildDataSourceField() {

        $html = '';

        $arField = $this->directive['grid_fields'];

        $html .= ' "btnDetail": { type:"string", editable: false, nullable: true }, ';
        $html .= ' "btnEdit": { type:"string", editable: false, nullable: true }, ';
        $html .= ' "btnDelete": { type:"string", editable: false, nullable: true }, ';

        reset($arField);
        while (list($key, $val) = each($arField)) {

            $html .= ' "'.$key.'": { ';

            switch ($this->directive['grid_fields_type'][$key]) {
              case 'numeric' : $html .= ' type: "number" '; break;
              case 'string' : $html .= ' type: "string" '; break;
              case 'boolean' : $html .= ' type: "boolean" '; break;
              case 'date' : $html .= ' type: "date" '; break;

              default : $html .= ' type: "string" '; break;
            }

            if ($this->directive['grid_editable']) {
                if ($this->directive['grid_fields_crud_editable'][$key]) {
                    $html .= ', editable: true ';
                    if ($this->directive['grid_fields_crud_nullable'][$key]) {
                        $html .= ', nullable: true ';
                    }
                    else {
                        $html .= ', nullable: false ';
                    }
                }
                else {
                    $html .= ', editable: false ';
                }
            }

            $html .= ' },'.chr(13);
        }

        $html = substr($html,0,(strlen($html)-2));

        return $html;
    }

    function buildGridField() {

        $html = '';

        if ($this->directive['grid_btnDetail']) {
            $html .= ' { field: "btnDetail", title: " ", encoded:false, width:40, filterable: false, sortable: false, groupable:false, attributes: {style: "vertical-align:top"} },'.chr(13);
        }
        if ($this->directive['grid_btnEdit']) {
            $html .= ' { field: "btnEdit", title: " ", encoded:false, width:40, filterable: false, sortable: false, groupable:false, attributes: {style: "vertical-align:top"} },'.chr(13);
        }
        if ($this->directive['grid_btnDelete']) {
            $html .= ' { field: "btnDelete", title: " ", encoded:false, width:40, filterable: false, sortable: false, groupable:false, attributes: {style: "vertical-align:top"} },'.chr(13);
        }

        $arField = $this->directive['grid_fields'];

        reset($arField);
        while (list($key, $val) = each($arField)) {

            $html .= ' { ';

            if ($this->directive['grid_fields_width'][$key] > 0) {
                $html .= ' width: '.$this->directive['grid_fields_width'][$key].',';
            }

            if ($this->directive['grid_fields_ishtml'][$key]) {
                $html .= ' encoded: false,';
            }
            else {
                $html .= ' encoded: true,';
            }

            if ($this->directive['grid_fields_inithide'][$key]) {
                $html .= ' hidden: true,';
            }
            else {
                $html .= ' hidden: false,';
            }

            if ($this->directive['grid_fields_isnotfilterable'][$key]) {
                $html .= ' filterable: false,';
            }
            else {

                switch ($this->directive['grid_fields_type'][$key]) {
                  case 'numeric' : $html .= ' filterable: { '.
                                            '   operators: { '.
                                            '        number: { '.
                                            '           eq: "Sama dengan", '.
                                            '           gte: "Lebih dari", '.
                                            '           lte: "Kurang dari" '.
                                            '        } '.
                                            '   }, '.
                                            '   messages: { info: "Saring data dengan kriteria",'.
                                            '               filter: "Filter",'.
                                            '               clear: "Clear" }'.
                                            ' }, ';
                                   break;

                  case 'date'    : $html .= ' filterable: { '.
                                            '   operators: { '.
                                            '        date: { '.
                                            '           eq: "Tepat tanggal", '.
                                            '           gte: "Mulai tanggal", '.
                                            '           lte: "Sampai tanggal" '.
                                            '        } '.
                                            '   }, '.
                                            '   ui: function(element) { '.
                                            '         element.kendoDatePicker({ '.
                                            '           format: "d MMM yyyy", '.
                                            '           parseformat: ["yyyy-MM-dd", "d/M/yyyy", "d-M-yyyy", "d MMM yyyy"] '.
                                            '           }); '.
                                            '   }, '.
                                            '   messages: { info: "Saring data dengan kriteria",'.
                                            '               filter: "Filter",'.
                                            '               clear: "Clear" }'.
                                            ' }, ';
                                   break;

                  default :  $html .= ' filterable: { '.
                                            '   operators: { '.
                                            '        string: { '.
                                            '           contains: "Mengandung kata", '.
                                            '           startswith: "Dimulai dengan", '.
                                            '           endswith: "Diakhiri dengan" '.
                                            '        } '.
                                            '   }, '.
                                            '   messages: { info: "Saring data dengan kriteria",'.
                                            '               filter: "Filter",'.
                                            '               clear: "Clear" }'.
                                            ' }, ';
                                   break;
                }
            }

            $html .= ' attributes: { style: "vertical-align:top; ';
            if (strlen($this->directive['grid_fields_align'][$key]) > 0) {
                // $html .= 'attributes:  { style:"text-align:'.$this->directive['grid_fields_align'][$key].';" },';
                $html .= ' text-align:'.$this->directive['grid_fields_align'][$key].'; ';
            }
            $html .= ' "},';

            if ($this->directive['grid_fields_isnotsortable'][$key]) {
                $html .= ' sortable: false,';
            }
            else {
                $html .= ' sortable: true,';
            }

            switch ($this->directive['grid_fields_format'][$key]) {
              case 'numeric' : $html .= ' format: "{0:n0}",'; break;
              case 'float' : $html .= ' format: "{0:n}",'; break;
              case 'percent' : $html .= ' format: "{0:p}",'; break;
              case 'dolar' : $html .= ' format: "{0:\'$ \'###,###,###,###,###}",'; break;
              case 'rupiah' : $html .= ' format: "{0:\'Rp. \'###,###,###,###,###}",'; break;
              case 'fulltimestamp' : $html .= ' format: "{0:ddd, d MMMM yyyy H:mm:ss}",'; break;
              case 'timestamp' : $html .= ' format: "{0:d MMM yyyy H:mm:ss}",'; break;
              case 'date' : $html .= ' format: "{0:dd MMM yyyy}",'; break;
              case 'datetime' : $html .= ' format: "{0:d MMM yyyy}",'; break;
              case 'time' : $html .= ' format: "{0:H:mm:ss}",'; break;
            }

            if (strlen(trim($this->directive['grid_fields_template'][$key]))>0) {
                $html .= ' template: "'.$this->directive['grid_fields_template'][$key].'",';
            }

            $html .= ' field: "'.$key.'",'.chr(13).' title: "'.$val.'" },'.chr(13);
        }

        // { command: { text: "View Details", click: showDetails }, title: " ", width: "140px" }
        if ($this->directive['grid_fieldsCustomButton']) {
            $html .= ' '.$this->directive['grid_fieldsCustomButton'].','.chr(13);
        }

        $html = substr($html,0,(strlen($html)-2));

        return $html;
    }

    function buildGrid() {

        $html = '';

        // build datasource

        $this->buildDataSource();

        $html .= '<div id="elh_'.$this->directive['sgk_id'].'_grid"></div>'.chr(13);

        $this->elmnt_jsScript .= 'var grid_'.$this->directive['sgk_id'].';'.chr(13);

        $this->elmnt_jsScriptInJqReady .= '   grid_'.$this->directive['sgk_id'].' = $("#elh_'.$this->directive['sgk_id'].'_grid").kendoGrid({ '.chr(13);

        if ($this->directive['grid_isgroupable'])
            $this->elmnt_jsScriptInJqReady .= '      groupable: true,'.chr(13);
        else
            $this->elmnt_jsScriptInJqReady .= '      groupable: false,'.chr(13);

        if ($this->directive['grid_issortable'])
            $this->elmnt_jsScriptInJqReady .= '      sortable: { mode: "multiple" },'.chr(13);
        else
            $this->elmnt_jsScriptInJqReady .= '      sortable: false,'.chr(13);

        if ($this->directive['grid_isscrollable'])
            $this->elmnt_jsScriptInJqReady .= '      scrollable: true,'.chr(13);
        else
            $this->elmnt_jsScriptInJqReady .= '      scrollable: false,'.chr(13);

        if ($this->directive['grid_ispageable'])
            $this->elmnt_jsScriptInJqReady .= '      pageable: { buttonCount: 5, pageSizes: [5,10,25,50,100], input: true },'.chr(13);
        else
            $this->elmnt_jsScriptInJqReady .= '      pageable: false,'.chr(13);

        if ($this->directive['grid_isresize'])
            $this->elmnt_jsScriptInJqReady .= '      resizable: true,'.chr(13);
        else
            $this->elmnt_jsScriptInJqReady .= '      resizable: false,'.chr(13);

        if ($this->directive['grid_isreorder'])
            $this->elmnt_jsScriptInJqReady .= '      reorderable: true,'.chr(13);
        else
            $this->elmnt_jsScriptInJqReady .= '      reorderable: false,'.chr(13);

        if ($this->directive['grid_columnmenu'])
            $this->elmnt_jsScriptInJqReady .= '      columnMenu: true,'.chr(13);
        else
            $this->elmnt_jsScriptInJqReady .= '      columnMenu: false,'.chr(13);

        if ($this->directive['grid_isfilterable'])
            $this->elmnt_jsScriptInJqReady .= '      filterable: true,'.chr(13);
        else
            $this->elmnt_jsScriptInJqReady .= '      filterable: false,'.chr(13);

        if (($this->directive['grid_crud']) && ($this->directive['grid_editable'])) {
            $this->elmnt_jsScriptInJqReady .= '      editable: true,'.chr(13);
        }
        else {
            $this->elmnt_jsScriptInJqReady .= '      editable: false,'.chr(13);
        }

        if ($this->directive['grid_isnavigatable'])
            $this->elmnt_jsScriptInJqReady .= '      navigatable: true,'.chr(13);
        else
            $this->elmnt_jsScriptInJqReady .= '      navigatable: false,'.chr(13);

        if ($this->directive['grid_isselectable'])
            $this->elmnt_jsScriptInJqReady .= '      selectable: "row",'.chr(13);
        else
            $this->elmnt_jsScriptInJqReady .= '      selectable: false,'.chr(13);

        if (strlen(trim($this->directive['grid_detailInit']))>0) {
            $this->elmnt_jsScriptInJqReady .= '      detailInit: '.$this->directive['grid_detailInit'].', '.chr(13);
        }

        if (strlen(trim($this->directive['grid_rowTemplate']))>0) {
            $this->elmnt_jsScriptInJqReady .= '      rowTemplate: kendo.template($("#'.$this->directive['grid_rowTemplate'].'").html()), '.chr(13);
        }

        if (strlen(trim($this->directive['grid_detailTemplate']))>0) {
            $this->elmnt_jsScriptInJqReady .= '      detailTemplate: kendo.template($("#'.$this->directive['grid_detailTemplate'].'").html()), '.chr(13);
        }

        $this->elmnt_jsScriptInJqReady .= '      columns: [ '.$this->buildGridField().' ], '.chr(13);
        $this->elmnt_jsScriptInJqReady .= '      dataSource: ds_'.$this->directive['sgk_id'].', '.chr(13);
        $this->elmnt_jsScriptInJqReady .= '      autoBind: true '.chr(13);

        if (strlen(trim($this->directive['grid_customInit']))>0) {
            $this->elmnt_jsScriptInJqReady .= '   '.$this->directive['grid_customInit'].' '.chr(13);
        }

        $this->elmnt_jsScriptInJqReady .= '   }); '.chr(13);

        // snippet for detail icons
        if ($this->directive['grid_btnDetail']) {

            $html_btnDetail_autoURL = '';
            if ($this->directive['grid_btnDetail_useDefault']) {

                $this->elmnt_html .= '<div id="elh_'.$this->directive['sgk_id'].'_windetail"></div>'.chr(13);

                $html_btnDetail_autoURL = $this->sessionH->uLink('main.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid='.$this->directive['sm_function'].'&sgSt=btnDetail&sgID='.$this->directive['sgk_id'];
                $this->elmnt_jsScript .= 'function jsf_'.$this->directive['sgk_id'].'_btndetail(option) {'.chr(13);
                $this->elmnt_jsScript .= '  $.get("'.$html_btnDetail_autoURL.'",'.chr(13);
                $this->elmnt_jsScript .= '        { rNum4: option },'.chr(13);
                $this->elmnt_jsScript .= '        function (data) { '.chr(13);
                //$this->elmnt_jsScript .= '           $("#elh_'.$this->directive['sgk_id'].'_windetail").html(data); '.chr(13);
                $this->elmnt_jsScript .= '           var window = $("#elh_'.$this->directive['sgk_id'].'_windetail").data("kendoWindow"); '.chr(13);
                $this->elmnt_jsScript .= '           window.content(data); '.chr(13);
                $this->elmnt_jsScript .= '           window.center(); '.chr(13);
                $this->elmnt_jsScript .= '           window.open(); '.chr(13);
                $this->elmnt_jsScript .= '        },'.chr(13);
                $this->elmnt_jsScript .= '        "html"); '.chr(13);
                $this->elmnt_jsScript .= '} '.chr(13);

                $this->elmnt_jsScriptInJqReady .= '   $("#elh_'.$this->directive['sgk_id'].'_windetail").kendoWindow({'.chr(13);
                $this->elmnt_jsScriptInJqReady .= '      actions: ["Close"], '.chr(13);
                $this->elmnt_jsScriptInJqReady .= '      modal: true, '.chr(13);
                $this->elmnt_jsScriptInJqReady .= '      visible: false, '.chr(13);
                $this->elmnt_jsScriptInJqReady .= '      title: "Detail Information", '.chr(13);
                $this->elmnt_jsScriptInJqReady .= '      resizable: false '.chr(13);
                $this->elmnt_jsScriptInJqReady .= '   });'.chr(13);
            }
        }

        if ($this->directive['grid_btnEdit']) {

            $html_btnEdit_autoURL = '';
            if ($this->directive['grid_btnEdit_useDefault']) {

                $html_btnEdit_autoURL = $this->sessionH->uLink('main.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid='.$this->directive['sm_function'].'&sgSt=btnEdit&sgID='.$this->directive['sgk_id'];
                $this->elmnt_jsScript .= 'function jsf_'.$this->directive['sgk_id'].'_btnedit(option) {'.chr(13);
                switch($this->directive['element_add_formtechnique']) {
                    case 'changepage' : $this->elmnt_jsScript .= '   window.location.href = "'.$html_btnEdit_autoURL.'&rNum4="+option; '.chr(13);
                                      break;
                    case 'showform' :
                    default         : $this->elmnt_jsScript .= '   showForm('.$this->directive['element_add_popupwidth'].','.$this->directive['element_add_popupheight'].',"_new","'.$html_btnEdit_autoURL.'&rNum4="+option);'.chr(13);
                                      break;
                }
                $this->elmnt_jsScript .= '}'.chr(13);
            }
        }

        if ($this->directive['grid_btnDelete']) {

            $html_btnDelete_autoURL = '';
            if ($this->directive['grid_btnDelete_useDefault']) {

                $this->elmnt_html .= '<div id="elh_'.$this->directive['sgk_id'].'_windelete"></div>'.chr(13);

                $html_btnDelete_autoURL = $this->sessionH->uLink('main.php').'&option='.$this->getVar('option').'&popMode=ajxcall&aswid='.$this->directive['sm_function'].'&sgSt=btnDelete&sgID='.$this->directive['sgk_id'];
                $this->elmnt_jsScript .= 'function jsf_'.$this->directive['sgk_id'].'_btndelete(option) {'.chr(13);
                $this->elmnt_jsScript .= '  if (window.confirm("Delete data? (this can not be undone)")) { '.chr(13);
                $this->elmnt_jsScript .= '      var changeReason = prompt("Action Remark/Nore Required"); '.chr(13);
                $this->elmnt_jsScript .= '      if ($.trim(changeReason).length > 0) { '.chr(13);
                $this->elmnt_jsScript .= '        $.get("'.$html_btnDelete_autoURL.'",'.chr(13);
                $this->elmnt_jsScript .= '          { rNum4: option, reason: changeReason },'.chr(13);
                $this->elmnt_jsScript .= '          function (data) { '.chr(13);
                $this->elmnt_jsScript .= '            if (data.length > 0) { alert(data); } '.chr(13);
                $this->elmnt_jsScript .= '            '.$this->directive['sgk_reload_jsf'].'; '.chr(13);
                $this->elmnt_jsScript .= '          },'.chr(13);
                $this->elmnt_jsScript .= '          "html"); '.chr(13);
                $this->elmnt_jsScript .= '      } '.chr(13);
                $this->elmnt_jsScript .= '      else { alert("Action remark required"); } '.chr(13);
                $this->elmnt_jsScript .= '  } '.chr(13);
                $this->elmnt_jsScript .= '} '.chr(13);

                $this->elmnt_jsScriptInJqReady .= '   $("#elh_'.$this->directive['sgk_id'].'_windelete").kendoWindow({'.chr(13);
                $this->elmnt_jsScriptInJqReady .= '      actions: ["Close"], '.chr(13);
                $this->elmnt_jsScriptInJqReady .= '      modal: true, '.chr(13);
                $this->elmnt_jsScriptInJqReady .= '      title: "Detail Information", '.chr(13);
                $this->elmnt_jsScriptInJqReady .= '      resizable: false '.chr(13);
                $this->elmnt_jsScriptInJqReady .= '   });'.chr(13);
            }
        }

        if (strlen(trim($this->directive['sgk_reload_jsf']))>0) {
	        if (!($this->directive['sgk_reload_jsf_usecustom'])) {
	            $this->elmnt_jsScript .= 'function '.$this->directive['sgk_reload_jsf'].' {'.chr(13);
	            $this->elmnt_jsScript .= '  ds_'.$this->directive['sgk_id'].'.read(); '.chr(13);
	            $this->elmnt_jsScript .= '} '.chr(13);
            }
        }

        return $html;

    }

    function buildElementEntity($element = '') {

        $html = '';

        switch($element) {

            case 'help' :   $this->elmnt_html .= '<div id="elh_'.$this->directive['sgk_id'].'_winhelp">'.$this->directive['element_help'].'</div>'.chr(13);

                            $this->elmnt_jsScript .= 'function jsf_'.$this->directive['sgk_id'].'_winhelp() {'.chr(13);
                            $this->elmnt_jsScript .= '  var window = $("#elh_'.$this->directive['sgk_id'].'_winhelp").data("kendoWindow"); '.chr(13);
                            $this->elmnt_jsScript .= '  window.center(); '.chr(13);
                            $this->elmnt_jsScript .= '  window.open(); '.chr(13);
                            $this->elmnt_jsScript .= '}'.chr(13);

                            $this->elmnt_jsScriptInJqReady .= '   $("#elh_'.$this->directive['sgk_id'].'_winhelp").kendoWindow({'.chr(13);
                            $this->elmnt_jsScriptInJqReady .= '      actions: ["Maximize", "Close"], '.chr(13);
                            $this->elmnt_jsScriptInJqReady .= '      modal: true, '.chr(13);
                            $this->elmnt_jsScriptInJqReady .= '      title: "Hint", '.chr(13);
                            $this->elmnt_jsScriptInJqReady .= '      resizable: true '.chr(13);
                            $this->elmnt_jsScriptInJqReady .= '   });'.chr(13);

                            $html .= '<input type="button" class="k-button" value="Help" id="elh_'.$this->directive['sgk_id'].'_winhelp_btn" onclick="jsf_'.$this->directive['sgk_id'].'_winhelp()">';

                            break;

            case 'hint' :   // $this->directive['element_hint']
                            $this->elmnt_html .= '<div id="elh_'.$this->directive['sgk_id'].'_winhint">'.$this->directive['element_hint'].'</div>'.chr(13);

                            $this->elmnt_jsScript .= 'function jsf_'.$this->directive['sgk_id'].'_winhint() {'.chr(13);
                            $this->elmnt_jsScript .= '  var window = $("#elh_'.$this->directive['sgk_id'].'_winhint").data("kendoWindow"); '.chr(13);
                            $this->elmnt_jsScript .= '  window.center(); '.chr(13);
                            $this->elmnt_jsScript .= '  window.open(); '.chr(13);
                            $this->elmnt_jsScript .= '}'.chr(13);

                            $this->elmnt_jsScriptInJqReady .= '   $("#elh_'.$this->directive['sgk_id'].'_winhint").kendoWindow({'.chr(13);
                            $this->elmnt_jsScriptInJqReady .= '      actions: ["Maximize", "Close"], '.chr(13);
                            $this->elmnt_jsScriptInJqReady .= '      modal: true, '.chr(13);
                            $this->elmnt_jsScriptInJqReady .= '      title: "Hint", '.chr(13);
                            $this->elmnt_jsScriptInJqReady .= '      resizable: true '.chr(13);
                            $this->elmnt_jsScriptInJqReady .= '   });'.chr(13);

                            $html .= '<input type="button" class="k-button" value="Hint" id="elh_'.$this->directive['sgk_id'].'_winhint_btn" onclick="jsf_'.$this->directive['sgk_id'].'_winhint()">';

                            break;

            case 'title' :  $html .= '<span><b>'.$this->directive['element_title'].'</b></span>'.chr(13);

                            break;

            case 'search' : $html .= '<input type="text" class="k-textbox" id="elh_'.$this->directive['sgk_id'].'_searchbox" value="" onkeyup="var code = event.which; if(code==13) { ds_'.$this->directive['sgk_id'].'.read(); }"> '.chr(13);
                            $html .= '<input type="button" class="k-button" value="Search" id="elh_'.$this->directive['sgk_id'].'_searchbox_btn" onclick="ds_'.$this->directive['sgk_id'].'.read();">';
                            break;

            case 'add' :    $html .= '<input type="button" class="k-button" id="elh_'.$this->directive['sgk_id'].'_add_btn" value="'.$this->directive['element_add_title'].'" onclick="jsf_'.$this->directive['sgk_id'].'_add()">';

                            $this->elmnt_jsScript .= 'function jsf_'.$this->directive['sgk_id'].'_add() {'.chr(13);
                            switch($this->directive['element_add_formtechnique']) {

                                case 'showform' : $this->elmnt_jsScript .= '   showForm('.$this->directive['element_add_popupwidth'].','.$this->directive['element_add_popupheight'].',"_new","'.$this->directive['element_add_url'].'");'.chr(13);
                                                  break;

                                case 'changepage' : $this->elmnt_jsScript .= '   window.location.href = "'.$this->directive['element_add_url'].'"; '.chr(13);
                                                  break;

                                case 'jsf' : $this->elmnt_jsScript .= '   '.$this->directive['element_add_jsf'].'; '.chr(13);
                                                  break;
                            }
                            $this->elmnt_jsScript .= '}'.chr(13);

                            break;

            case 'clear' :   // $this->directive['element_hint']
                            $this->elmnt_jsScript .= 'function jsf_'.$this->directive['sgk_id'].'_clear() {'.chr(13);
                            $this->elmnt_jsScript .= '  window.location.reload(); '.chr(13);
                            $this->elmnt_jsScript .= '}'.chr(13);

                            // $html .= '<input type="button" class="k-button" value="Clear" id="elh_'.$this->directive['sgk_id'].'_clear_btn" onclick="jsf_'.$this->directive['sgk_id'].'_clear()">';
                            $html .= '<a href="#" id="elh_'.$this->directive['sgk_id'].'_clear_btn" onclick="jsf_'.$this->directive['sgk_id'].'_clear()" class="k-button k-button-icontext" style="width:85px; height:25px; font-size: 14px; font-weight: bold; vertical-align: middle; padding-top:3px;" ><span class="k-icon" style="background-image: url(\'./images/app/icobtn_eraser.png\');"></span>Clear</a>';

                            break;

            case 'download' :   // $this->directive['element_hint']
                            $this->elmnt_jsScript .= 'function jsf_'.$this->directive['sgk_id'].'_download() {'.chr(13);

                            $this->elmnt_jsScript .= '  var ds_filter = ds_'.$this->directive['sgk_id'].'.filter(); '.chr(13);
                            $this->elmnt_jsScript .= '  var ds_sort = ds_'.$this->directive['sgk_id'].'.sort(); '.chr(13);
                            $this->elmnt_jsScript .= '  var ds_group = ds_'.$this->directive['sgk_id'].'.group(); '.chr(13);
                            $this->elmnt_jsScript .= '  var ds_q = $("#elh_'.$this->directive['sgk_id'].'_searchbox").val(); '.chr(13);

                            $this->elmnt_jsScript .= '  $.ajax({type: "POST", url: "'.$this->ds_url.'", data: { sBtn: "dl", gQ: ds_q, gF: JSON.stringify(ds_filter), gG: JSON.stringify(ds_group), gS: JSON.stringify(ds_sort) }, success: function(data) { window.open(data,"_blank"); }, dataType: "text" }); '.chr(13);

                            $this->elmnt_jsScript .= '}'.chr(13);

                            $html .= '<a href="#" id="elh_'.$this->directive['sgk_id'].'_download_btn" onclick="jsf_'.$this->directive['sgk_id'].'_download()" class="btn btn-primary" style="" >Download</a>';

                            break;

            case 'print' :   // $this->directive['element_hint']
                            $this->elmnt_jsScript .= 'function jsf_'.$this->directive['sgk_id'].'_print() {'.chr(13);

                            $this->elmnt_jsScript .= '  var ds_filter = ds_'.$this->directive['sgk_id'].'.filter(); '.chr(13);
                            $this->elmnt_jsScript .= '  var ds_sort = ds_'.$this->directive['sgk_id'].'.sort(); '.chr(13);
                            $this->elmnt_jsScript .= '  var ds_group = ds_'.$this->directive['sgk_id'].'.group(); '.chr(13);
                            $this->elmnt_jsScript .= '  var ds_q = $("#elh_'.$this->directive['sgk_id'].'_searchbox").val(); '.chr(13);
                            $this->elmnt_jsScript .= '  $.ajax({type: "POST", url: "'.$this->ds_url.'", data: { sBtn: "pRn", gQ: ds_q, gF: JSON.stringify(ds_filter), gG: JSON.stringify(ds_group), gS: JSON.stringify(ds_sort) }, success: function(data) { window.open(data,"_blank"); }, dataType: "text" }); '.chr(13);

                            $this->elmnt_jsScript .= '}'.chr(13);

                            $html .= '<a href="#" id="elh_'.$this->directive['sgk_id'].'_print_btn" onclick="jsf_'.$this->directive['sgk_id'].'_print()" class="btn btn-primary" style="" >Print</a>';

                            break;

            case 'custom' :

                            /*
                            $this->elmnt_jsScript .= 'function jsf_'.$this->directive['sgk_id'].'_custom() {'.chr(13);

                            $this->elmnt_jsScript .= '  var ds_filter = ds_'.$this->directive['sgk_id'].'.filter(); '.chr(13);
                            $this->elmnt_jsScript .= '  var ds_sort = ds_'.$this->directive['sgk_id'].'.sort(); '.chr(13);
                            $this->elmnt_jsScript .= '  var ds_group = ds_'.$this->directive['sgk_id'].'.group(); '.chr(13);
                            $this->elmnt_jsScript .= '  var ds_page = ds_'.$this->directive['sgk_id'].'.page(); '.chr(13);
                            $this->elmnt_jsScript .= '  var ds_pageSize = ds_'.$this->directive['sgk_id'].'.pageSize(); '.chr(13);

                            $this->elmnt_jsScript .= '  if (ds_group == "") { '.chr(13);
                            $this->elmnt_jsScript .= '    $.ajax({type: "POST", url: "'.$this->ds_url.'", data: { sBtn: "custom", gP: ds_page, gPS: ds_pageSize, gF: JSON.stringify(ds_filter), gG: JSON.stringify(ds_group), gS: JSON.stringify(ds_sort) }, success: function(data) { window.open(data,"_blank"); }, dataType: "text" }); '.chr(13);
                            $this->elmnt_jsScript .= '  } else { alert("Maaf, proses tidak bisa dilakukan saat tabel dalam bentuk GROUP."); } '.chr(13);

                            //$this->elmnt_jsScript .= '  alert(ds_group); if (ds_group == "") { alert("clear"); } ';
                            //$this->elmnt_jsScript .= '  $.ajax({type: "POST", url: "'.$this->ds_url.'", data: { sBtn: "custom", gP: ds_page, gPS: ds_pageSize, gF: JSON.stringify(ds_filter), gG: JSON.stringify(ds_group), gS: JSON.stringify(ds_sort) }, success: function(data) { window.open(data,"_blank"); }, dataType: "text" }); '.chr(13);

                            $this->elmnt_jsScript .= '}'.chr(13);

                            $html .= '<a href="#" id="elh_'.$this->directive['sgk_id'].'_custom_btn" onclick="jsf_'.$this->directive['sgk_id'].'_custom()" class="k-button k-button-icontext" style="width:110px; height:25px; font-size: 14px; font-weight: bold; vertical-align: middle; padding-top:3px;" ><span class="k-icon" style="background-image: url(\'./images/app/'.$this->directive['gridBtnCustom_icon'].'\');"></span>'.$this->directive['gridBtnCustom_label'].'</a>';
                            */

                            // $html .= '<a href="#" id="elh_'.$this->directive['sgk_id'].'_custom_btn" onclick="'.$this->directive['gridBtnCustom_js'].'" class="k-button k-button-icontext" style="width:110px; height:25px; font-size: 14px; font-weight: bold; vertical-align: middle; padding-top:3px;" ><span class="k-icon" style="background-image: url(\'./images/app/'.$this->directive['gridBtnCustom_icon'].'\');"></span>'.$this->directive['gridBtnCustom_label'].'</a>';
                            // $html .= '<a href="#" id="elh_'.$this->directive['sgk_id'].'_custom_btn" onclick="'.$this->directive['gridBtnCustom_js'].'" class="k-button" style="width:110px; height:25px; font-size: 14px; font-weight: bold; vertical-align: middle; padding-top:3px;" ><span class="k-icon" style="background-image: url(\'./images/app/'.$this->directive['gridBtnCustom_icon'].'\');"></span>'.$this->directive['gridBtnCustom_label'].'</a>';
							$html .= '<input type="button" id="elh_'.$this->directive['sgk_id'].'_custom_btn" onclick="'.$this->directive['gridBtnCustom_js'].'" class="k-button" style="" value="'.$this->directive['gridBtnCustom_label'].'">';

                            break;

        }


        return $html;

    }


    function buildElement($elemList) {

        $html = '';

        if (is_array($elemList)) {
            reset($elemList);
            while (list($key, $val) = each($elemList)) {
                $html .= $this->buildElementEntity($val).'&nbsp;'.chr(13);
            }
        }
        else {
            $html = $this->buildElementEntity($elemList);
        }

        return $html;
    }

    function buildDefaultInnerWrapper($data = '') {

        $html = '';

        switch ($this->directive['innerwrapper_useDefault_type']) {

            case '3x3' : $html .= '<table width="100%" border="0" cellspacing="0" cellpadding="4">'.chr(13);
                         $html .= '<tr>'.chr(13);
                         $html .= ' <td align="left" valign="middle" width="30%" bgcolor="'.$this->directive['innerwrapper_bgcolor'].'" style="padding:10px; color:white; ">'.chr(13);
                         $html .= '  '.$this->buildElement($this->directive['inw3x3_headleft']).chr(13);
                         $html .= ' </td>'.chr(13);
                         $html .= ' <td align="center" valign="middle" width="40%" bgcolor="'.$this->directive['innerwrapper_bgcolor'].'" style="padding:10px; color:white; ">'.chr(13);
                         $html .= '  '.$this->buildElement($this->directive['inw3x3_head']).chr(13);
                         $html .= ' </td>'.chr(13);
                         $html .= ' <td align="right" valign="middle" width="30%" bgcolor="'.$this->directive['innerwrapper_bgcolor'].'" style="padding:10px; color:white; ">'.chr(13);
                         $html .= '  '.$this->buildElement($this->directive['inw3x3_headright']).chr(13);
                         $html .= ' </td>'.chr(13);
                         $html .= '</tr>'.chr(13);
                         $html .= '<tr>'.chr(13);
                         $html .= ' <td align="left" valign="top" colspan="3">'.chr(13);
                         $html .= '  '.$this->buildGrid().chr(13);
                         $html .= ' </td>'.chr(13);
                         $html .= '</tr>'.chr(13);
                         $html .= '<tr>'.chr(13);
                         $html .= ' <td align="left" valign="top" width="30%" style="padding:2px;">'.chr(13);
                         $html .= '  '.$this->buildElement($this->directive['inw3x3_footleft']).chr(13);
                         $html .= ' </td>'.chr(13);
                         $html .= ' <td align="center" valign="top" width="40%" style="padding:2px;">'.chr(13);
                         $html .= '  '.$this->buildElement($this->directive['inw3x3_foot']).chr(13);
                         $html .= ' </td>'.chr(13);
                         $html .= ' <td align="right" valign="top" width="30%" style="padding:2px;">'.chr(13);
                         $html .= '  '.$this->buildElement($this->directive['inw3x3_footright']).chr(13);
                         $html .= ' </td>'.chr(13);
                         $html .= '</tr>'.chr(13);
                         $html .= '</table>'.chr(13);

                         break;
                         
            case '1rx2' : $html .= '<table width="100%" border="0" cellspacing="0" cellpadding="4">'.chr(13);
                         $html .= '<tr>'.chr(13);
                         $html .= ' <td align="right" valign="middle" bgcolor="'.$this->directive['innerwrapper_bgcolor'].'" style="padding:10px; color:white; ">'.chr(13);
                         $html .= '  '.$this->buildElement($this->directive['inw3x3_headright']).chr(13);
                         $html .= ' </td>'.chr(13);
                         $html .= '</tr>'.chr(13);
                         $html .= '<tr>'.chr(13);
                         $html .= ' <td align="left" valign="top">'.chr(13);
                         $html .= '  '.$this->buildGrid().chr(13);
                         $html .= ' </td>'.chr(13);
                         $html .= '</tr>'.chr(13);
                         $html .= '</table>'.chr(13);

                         break;             
        }
        return $html;
    }



}


?>
