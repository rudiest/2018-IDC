<?php

class smartGridPlain extends SM_module {

     var $elmnt_html = '';

     var $elmnt_jsScript = '';

     var $elmnt_jsScriptInJqReady = '';

     var $columnSum = array();

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

        // datasource
        $this->directive['ds_pageSize'] = '50';
        $this->directive['ds_dataField'] = 'id';
        $this->directive['ds_read_url'] = '';

        // sitemanager
        $this->directive['sm_function'] = 'buildGrid';

        // grid
        $this->directive['grid_fields_format'] = array();
        $this->directive['grid_fields_align'] = array();
        $this->directive['grid_fields_valign'] = array();
        $this->directive['grid_fields_ishtml'] = array();
        $this->directive['grid_fields_width'] = array();
        $this->directive['grid_fields_type'] = array();
        $this->directive['grid_total_fields'] = array();
        $this->directive['grid_total'] = '';
        $this->directive['grid_sum'] = 0;
        $this->directive['grid_fields'] = array();

        // column sum
        $this->directive['displayDecimalSum']   = 0;
        $this->directive['displayColumnSum']    = false;

        // fields button
        $this->directive['grid_btnDetail'] = true;
        $this->directive['grid_btnEdit'] = true;
        $this->directive['grid_btnDelete'] = true;

        $this->directive['grid_btnDetail_useDefault'] = true;
        $this->directive['grid_btnEdit_useDefault'] = true;
        $this->directive['grid_btnDelete_useDefault'] = true;

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

        $this->directive['tbl_useAutoNumber'] = false;

        // query execution
        $this->directive['sql_select'] = '';
        $this->directive['sql_from'] = '';
        $this->directive['sql_where'] = '';
        $this->directive['sql_group'] = '';
        $this->directive['sql_order'] = '';
        $this->directive['sql_limit'] = '';

        // grid method
        $this->directive['sgk_reload_jsf'] = 'jsf_'.$this->directive['sgk_id'].'_reload()';

        // snippet (sub detail mechanism)
        $this->directive['snippet_used'] = false;
        $this->directive['snippet_label'] = array();
        $this->directive['snippet_smmodule'] = array();
        $this->directive['snippet_smfunctions'] = array();
    }

    function moduleThink() {

        if ($this->getVar('popMode') == 'ajxcall') {
            if ($this->getVar('popMode') == 'ajxcall') {
                switch($this->getVar('sgSt')) {
                    case 'create' : break;
                    case 'destroy' : break;
                    case 'update' : break;
                    case 'read' : $this->sqlRead(); break;
                }
            }
            else {
                die('Link Error: ');
            }
        }

        // build the grid !
        $html = '';
        $html  = $this->buildDefaultInnerWrapper($html);
        $this->say($html);

    }

    function buildDefaultInnerWrapper($data = '') {


        $SQL = $this->directive['sql_sql'];
        $rhS  = $this->dbH->query($SQL);
        if ($this->dbH->errorCode() > 0) {
            $pdoDbErrorInfo = $this->dbH->errorInfo();
            die($pdoDbErrorInfo[0].'-'.$pdoDbErrorInfo[1].': '.$pdoDbErrorInfo[2].'. SQL = '.$SQL);
        }


        $outputData = array();
        $outputDataCounter = 0;

        while ($rrFinal = $rhS->fetch()) {

            $outputData[$outputDataCounter] = $rrFinal;
            $outputDataCounter++;
        }

        $grid_fields = $this->directive['grid_fields'];
        $html = '';
        $html .= '<div id="simpleGridList" class="panel"><table width="100%" border="0" cellspacing="0" cellpadding="4" style="border:1px solid #CACACA;">'.chr(13);
        $html .= '<tr>'.chr(13);

        if ($this->directive['grid_btnDetail']) {
             $html .= ' <td width="30" align="left" valign="top" style="border:1px solid #CACACA; padding:5px;"> &nbsp;</td>'.chr(13);
        }

        if ($this->directive['grid_btnEdit']) {
            $html .= ' <td width="20" align="left" valign="top" style="border:1px solid #CACACA; padding:5px;"> &nbsp;</td>'.chr(13);
        }

        if ($this->directive['grid_btnDelete']) {
            $html .= ' <td width="20" align="left" valign="top" style="border:1px solid #CACACA; padding:5px;"> &nbsp;</td>'.chr(13);
        }

        $html .= ' <td width="20" align="left" valign="top" style="border:1px solid #CACACA; padding:5px;">'.chr(13);
        $html .= ' No. '.chr(13);
        $html .= ' </td>'.chr(13);
        $width = ' ';
        $align = ' ';
        $valign = ' ';
        reset($grid_fields);
        while (list($key, $val) = each($grid_fields)) {

             if ($this->directive['grid_fields_width'][$key] > 0) {
                $width = 'width="'.$this->directive['grid_fields_width'][$key].'"';
             } else {
                 $width = ' ';
             }

             if (strlen(trim($this->directive['grid_fields_align'][$key])) > 0) {
                 $align = 'align="'.$this->directive['grid_fields_align'][$key].'"';
             } else {
                $align = 'align="left"';
             }
             if (strlen(trim($this->directive['grid_fields_valign'][$key])) > 0) {
                $valign = $this->directive['grid_fields_valign'][$key];
             } else {
                $valign = 'top';
             }

             $html .= ' <td '.$width.' '.$align.' valign="'.$valign.'" style="border:1px solid #CACACA;  padding:5px;">'.chr(13);
             $html .= '  '.$val.chr(13);
             $html .= ' </td>'.chr(13);
        }
        $html .= '</tr>'.chr(13);

        $noUrut = 0;
        reset($outputData);
        while (list($key1, $val1) = each($outputData)) {

            $IDval = $outputData[$noUrut][id];

            $html .= '<tr>'.chr(13);
            $noUrut++;
            $html_btnDetail = '';
            $html_btnEdit = '';
            $html_btnDelete = '';

            if ($this->directive['grid_btnDetail']) {

                if ($this->directive['grid_btnDetail_useDefault']) {
                    $html_btnDetail_onclick = 'jsf_'.$this->directive['sgk_id'].'_btndetail(\''.$IDval.'\')';
                }
                elseif (strlen(trim($this->directive['grid_btnDetail_win_url']))>0) {
                    $html_btnDetail_onclick = "window.location = '".$this->directive['grid_btnDetail_win_url']."&rNum=".$IDval."'; ";
                }
                elseif (strlen(trim($this->directive['grid_btnDetail_pop_url']))>0) {
                    $html_btnDetail_onclick = "showForm(".$this->directive['grid_btnDetail_pop_width'].",".$this->directive['grid_btnDetail_pop_height'].",'_new','".$this->directive['grid_btnDetail_pop_url']."&rNum=".$IDval."'); ";
                }
                elseif (strlen(trim($this->directive['grid_btnDetail_jsfCustom']))>0) {
                    $html_btnDetail_onclick = $this->directive['grid_btnDetail_jsfCustom'].'(\''.$IDval.'\')';
                }

                $html_btnDetail = '<img src="./images/icons/ic20_white_info.png" onmouseover="gridbtn_over(this)" onmouseout="gridbtn_out(this)" style="border:1px solid #CACACA;" onclick="'.$html_btnDetail_onclick.'">';
                $html .= ' <td align="left" valign="top" style="border:1px solid #CACACA; padding:5px;">'.chr(13);
                $html .= $html_btnDetail;
                $html .= ' </td>'.chr(13);
            }

            if ($this->directive['grid_btnEdit']) {

                if ($this->directive['grid_btnEdit_useDefault']) {
                    $html_btnEdit_onclick = 'jsf_'.$this->directive['sgk_id'].'_btnedit(\''.$IDval.'\')';
                }
                elseif (strlen(trim($this->directive['grid_btnEdit_jsfCustom']))>0) {
                    $html_btnEdit_onclick = $this->directive['grid_btnEdit_jsfCustom'].'(\''.$IDval.'\')';
                }
                $html_btnEdit = '<img src="./images/icons/ic20_white_pencil.png" onmouseover="gridbtn_over(this)" onmouseout="gridbtn_out(this)" style="border:1px solid #CACACA;" onclick="'.$html_btnEdit_onclick.'">';
                $html .= ' <td align="left" valign="top" style="border:1px solid #CACACA; padding:5px;">'.chr(13);
                $html .= $html_btnEdit;
                $html .= ' </td>'.chr(13);
            }

            if ($this->directive['grid_btnDelete']) {

                if ($this->directive['grid_btnDelete_useDefault']) {
                    $html_btnDelete_onclick = 'jsf_'.$this->directive['sgk_id'].'_btndelete(\''.$IDval.'\')';
                }
                elseif (strlen(trim($this->directive['grid_btnDelete_jsfCustom']))>0) {
                    $html_btnDelete_onclick = $this->directive['grid_btnDelete_jsfCustom'].'(\''.$IDval.'\')';
                }

                $html_btnDelete = '<img src="./images/icons/ic20_white_cancel.png" onmouseover="gridbtn_over(this)" onmouseout="gridbtn_out(this)" style="border:1px solid #CACACA;" onclick="'.$html_btnDelete_onclick.'">';
                $html .= ' <td align="left" valign="top" style="border:1px solid #CACACA; padding:5px;">'.chr(13);
                $html .= $html_btnDelete;
                $html .= ' </td>'.chr(13);
            }

            $html .= ' <td align="'.$align.'" valign="'.$valign.'" style="border:1px solid #CACACA; padding:5px;">'.chr(13);
            $html .= '  '.$noUrut.chr(13);
            $html .= ' </td>'.chr(13);
            reset($grid_fields);
            while (list($key, $val) = each($grid_fields)) {

	             if (strlen(trim($this->directive['grid_fields_align'][$key])) > 0) {
	                 $align = $this->directive['grid_fields_align'][$key];
	             } else {
	                 $align = 'left';
	             }

	             if (strlen(trim($this->directive['grid_fields_valign'][$key])) > 0) {
	                 $valign = $this->directive['grid_fields_valign'][$key];
	             } else {
	                 $valign = 'top';
	             }

                 $html .= ' <td align="'.$align.'" valign="'.$valign.'" style="border:1px solid #CACACA; padding:5px;">'.chr(13);
                 $html .= $val1[$key].chr(13);
                 $html .= ' </td>'.chr(13);

                 if ($this->directive['grid_total_fields'][$key]) {
                    $this->columnSum[$key]+=(str_replace(',','',$val1[$key])+0);
                }
                //echo($this->columnSum[$key].'--');

            }
            //echo(print_r($this->columnSum[$key]).'==');
            $html .= '</tr>'.chr(13);
        }

        //die();
        if (strtolower($this->directive['grid_total']) == 'sum') {
            $html .= '<tr>'.chr(13);
            if ($this->directive['grid_btnDetail']) {
                 $html .= ' <td width="30" align="left" valign="top" style="border:1px solid #CACACA; padding:5px;"> &nbsp;</td>'.chr(13);
            }

            if ($this->directive['grid_btnEdit']) {
                $html .= ' <td width="30" align="left" valign="top" style="border:1px solid #CACACA; padding:5px;"> &nbsp;</td>'.chr(13);
            }

            if ($this->directive['grid_btnDelete']) {
                $html .= ' <td width="30" align="left" valign="top" style="border:1px solid #CACACA; padding:5px;"> &nbsp;</td>'.chr(13);
            }
            $html .= ' <td align="left" valign="top" style="border:1px solid #CACACA; padding:5px;"> &nbsp;</td>'.chr(13);

            reset($grid_fields);
            while (list($key, $val) = each($grid_fields)) {

	            if (strlen(trim($this->directive['grid_fields_align'][$key])) > 0) {
	                 $align = $this->directive['grid_fields_align'][$key];
	            } else {
	                 $align = 'left';
	            }

	            if (strlen(trim($this->directive['grid_fields_valign'][$key])) > 0) {
	                 $valign = $this->directive['grid_fields_valign'][$key];
	            } else {
	                 $valign = 'top';
	            }

                $html .= ' <td align="'.$align.'" valign="'.$valign.'" style="border:1px solid #CACACA; padding:5px;">'.chr(13);
                if ($this->directive['grid_total_fields'][$key]) {
	                $html .= '  '.number_format($this->columnSum[$key]).chr(13);
                } else {
                    $html .= ' ';
                }
                $html .= ' </td>'.chr(13);

            }


            $html .= '</tr>'.chr(13);
        }
        $html .= '</table></div>'.chr(13);


        return $html;

    }



}


?>
