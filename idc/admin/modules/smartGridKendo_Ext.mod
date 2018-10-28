<?php

class smartGridKendo_Ext extends SM_module {

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
        $this->addInVar('swid','');
        $this->addInVar('aswid','');
        $this->addInVar('aswparam','');

    }

    function moduleThink() {

        $this->say($defTpt->run());
    }

    function sqlGenSort($gridSort) {

        $sortCounter = count($gridSort);
        $sortSQL = ' ';

        if (is_array($gridSort)) {

            for ($x = 0; $x < $sortCounter; $x++) {

                if (strlen(trim($gridSort[$x]->field)) > 0) {
                    $sortSQL .= ' '.$gridSort[$x]->field.' '.$gridSort[$x]->dir.' ';

                    if ( $x < ($sortCounter - 1) ) {

                        $sortSQL .= ', ';
                    }
                }
            }
        }

        return $sortSQL;
    }

    function sqlGenGroup($gridGroup) {

        $groupCounter = count($gridGroup);
        $groupSQL = ' ';

        if (is_array($gridGroup)) {

            for ($x = 0; $x < $groupCounter; $x++) {

                if (strlen(trim($gridGroup[$x]->field)) > 0) {
                    $groupSQL .= ' '.$gridGroup[$x]->field.' ';

                    if ( $x < ($groupCounter - 1) ) {

                        $groupSQL .= ', ';
                    }
                }
            }
        }

        return $groupSQL;
    }
    
    function build_q_filter($q = '') {
        
        // filter query
        $ssp_sql_filter = '';
        $ssp_sql_filterArray = array();
        $ssp_filter = $q;
        
        if ((strlen(trim($ssp_filter))> 0) && (strtolower(trim($ssp_filter)) != 'undefined')) {
             
            // directive
            $grid_fields_type = $this->directive['grid_fields_type'];
            $grid_fields = $this->directive['grid_fields'];
            
            $y = 0;
            reset($grid_fields);
            while (list($fieldName, $fieldVal) = each($grid_fields)) {
                
                // check coloumn type
                $cekColType = $grid_fields_type[$fieldName];

                if ($this->directive['grid_fields_ishtml'][$fieldName]) {
                    $cekColType = 'string';
                }

                switch ($cekColType) {
                    case 'numeric' :    if (is_numeric($ssp_filter)) {
                                            $filtersInnerArray[$y] = " (".$fieldName." = '".$ssp_filter."') ";
                                            $y++;
                                        }
                                        break;
                                        
                    case 'date'    :    $filtersInnerArray[$y] = " ( (lower(date_format(".$fieldName.",'%Y-%m-%d')) like '%".strtolower($ssp_filter)."%') or ".
                                                                 "   (lower(date_format(".$fieldName.",'%d %b %Y')) like '%".strtolower($ssp_filter)."%') or ".
                                                                 "   (lower(date_format(".$fieldName.",'%d %M %Y')) like '%".strtolower($ssp_filter)."%') or ".
                                                                 "   (lower(date_format(".$fieldName.",'%d/%m/%Y')) like '%".strtolower($ssp_filter)."%') )";
                                        $y++;                         
                                        break;

                    default        :    $filtersInnerArray[$y] = " (lower(".$fieldName.") like '%".strtolower($ssp_filter)."%') ";
                                        $y++;
                                        break;
                }
                
            }
            
            
            if (count($filtersInnerArray) > 0) {
                $ssp_sql_filter = implode(" or ",$filtersInnerArray);
            }
            
        }
         
        return $ssp_sql_filter;
    }

    function sqlGenFilter($gridFilter) {

        $combSQL  = array();
        $whereSQL = '';

        if (is_object($gridFilter)) {

            $colFilter = count($gridFilter->filters);
            $filLogic = $gridFilter->logic;

            if ( $colFilter > 0 ) {

                $whereSQL .= ' ( ';
                for ($x = 0; $x < $colFilter; $x++) {

                    if ( count($gridFilter->filters[$x]) > 0 ) {

                        $combSQL[$x] = $this->sqlGenFilter($gridFilter->filters[$x]);
                        $whereSQL .= ' '.$this->sqlGenFilter($gridFilter->filters[$x]).' ';
                    }

                    if ( $x < ($colFilter - 1) ) {

                        $whereSQL .= ' '.$filLogic.' ';
                    }
                }
                $whereSQL .= ' ) ';

                return $whereSQL;

            }
            else {

                if (strlen(trim($gridFilter->field)) > 0) {

                    switch($gridFilter->operator) {

                        case 'contains' : $whereSQL = " lower(".$gridFilter->field.") like '%".strtolower($gridFilter->value)."%' "; break;
                        case 'startswith' : $whereSQL = " lower(".$gridFilter->field.") like '".strtolower($gridFilter->value)."%' "; break;
                        case 'endswith' : $whereSQL = " lower(".$gridFilter->field.") like '%".strtolower($gridFilter->value)."' "; break;
                        case 'eq' : $whereSQL = " lower(".$gridFilter->field."::text) = '".strtolower($gridFilter->value)."' "; break;
                        case 'neq' : $whereSQL = " lower(".$gridFilter->field."::text) <> '".strtolower($gridFilter->value)."' "; break;

                        case 'gte' : $whereSQL = " ".$gridFilter->field." >= '".($gridFilter->value)."' "; break;
                        case 'gt' : $whereSQL = " ".$gridFilter->field." > '".($gridFilter->value)."' "; break;
                        case 'lte' : $whereSQL = " ".$gridFilter->field." <= '".($gridFilter->value)."' "; break;
                        case 'lt' : $whereSQL = " ".$gridFilter->field." < '".($gridFilter->value)."' "; break;

                    }

                    return $whereSQL;
                }
                else {

                    return '';
                }
            }
        }
        else {

            return '';
        }
    }

    function dataPreparation($gridSQL = '', $gridConfig) {

        $member =  $this->sessionH->getMemberData();

        $gridFilter = json_decode(stripslashes($_POST['gF']));
        $gridGroup = json_decode(stripslashes($_POST['gG']));
        $gridSort = json_decode(stripslashes($_POST['gS']));
        $gridQ = $_POST['gQ'];

        $whereSQL = $this->sqlGenFilter($gridFilter);
        $groupSQL = $this->sqlGenGroup($gridGroup);
        $sortSQL = $this->sqlGenSort($gridSort);
        
        $ssp_sql_q_filter = $this->build_q_filter($gridQ);

        $snippetConfig = array();
        $snippetModule = array();
        $snippetFunc = array();
        reset($gridConfig['snippet_label']);
        while (list($key, $val) = each($gridConfig['snippet_label'])) {

            $snippetConfig[$val] = $gridConfig['snippet_smfunctions'][$key];
            $snippetModule[$val] = $gridConfig['snippet_smmodule'][$key];
            $snippetFunc[$val] = $gridConfig['snippet_smfunctions'][$key];
        }

        $finViewFields = '';

        $grid_fields = $gridConfig['fields'];
        reset($grid_fields);
        while (list($key, $val) = each($grid_fields)) {

            if ($gridConfig['snippet_used']) {
                if (strlen(trim($snippetConfig[$key]))>0) {
                    $finViewFields .= " '' as ".$key.",";
                }
                else {
                    $finViewFields .= $key.',';
                }
            }
            else {
                $finViewFields .= $key.',';
            }
        }

        if (strlen(trim($finViewFields))>0) {
            $finViewFields = substr($finViewFields,0,(strlen(trim($finViewFields))-1));
        }
        else {
            $finViewFields = ' * ';
        }

        $outputData = array();
        $outputDataCounter = 0;

        $useGroup = '0';

        if (strlen(trim($groupSQL)) > 0) {

            $useGroup = 1;

            $finGroupSQL = " select ".trim($groupSQL)." from ( ".trim($gridSQL)." ) tmp ";
            if (strlen(trim($whereSQL)) > 0) {
                $finGroupSQL .= " where ".trim($whereSQL)." ".$ssp_sql_q_filter;
            }
            elseif (strlen(trim($ssp_sql_q_filter)) > 0) {
                $finGroupSQL .= " where ".$ssp_sql_q_filter;
            }
            
            $finGroupSQL .= " group by ".trim($groupSQL)." order by ".trim($groupSQL)." ";

            $rh = $this->dbH->query($finGroupSQL);
            if ($this->dbH->errorCode() > 0) {
                $pdoDbErrorInfo = $this->dbH->errorInfo();
                die($pdoDbErrorInfo[0].'-'.$pdoDbErrorInfo[1].': '.$pdoDbErrorInfo[2]);
            }
            while ($rr = $rh->fetch()) {

                $groupByWhere = '';
                $groupByCol = array();
                $finSQL = '';

                reset($rr);
                while (list($key, $val) = each($rr)) {
                    if (strlen(trim($val))>0) {
                        $groupByWhere .= $key ."='".$val."' and ";
                        $groupByCol[$key] = $val;
                    }
                    else {
                        $groupByWhere .= " coalesce(".$key."::text,'') = '".trim($val)."' and ";
                        $groupByCol[$key] = trim($val);
                    }
                }

                if (strlen(trim($groupByWhere)) > 0) {
                    $groupByWhere = substr($groupByWhere,0,(strlen($groupByWhere)-4));
                    $finSQL = " select ".trim($finViewFields)." from ( ".trim($gridSQL)." ) tmp ";

                    if (strlen(trim($whereSQL)) > 0) {
                        $finSQL .= " where ".trim($whereSQL)." and ".$groupByWhere." ";
                    }
                    else {
                        $finSQL .= " where ".$groupByWhere." ";
                    }

                    if (strlen(trim($sortSQL)) > 0) {
                        $finSQL .= " order by ".trim($sortSQL);
                    }

                    $outputDataDetail = array();
                    $outputDataDetailCounter = 0;

                    $rhFinal  = $this->dbH->query($finSQL);
                    if ($this->dbH->errorCode() > 0) {
                        $pdoDbErrorInfo = $this->dbH->errorInfo();
                        die($pdoDbErrorInfo[0].'-'.$pdoDbErrorInfo[1].': '.$pdoDbErrorInfo[2]);
                    }
                    while ($rrFinal = $rhFinal->fetch()) {

                        if ($gridConfig['snippet_used']) {
                            reset($gridConfig['snippet_label']);
                            while (list($key, $val) = each($gridConfig['snippet_label'])) {
                                unset($tmpModule);
                                unset($resultSnippet);
                                $tmpModule =& $this->loadModule($gridConfig['snippet_smmodule'][$key]);
                                if ( $rrFinal[$gridConfig['ds_dataField']] > 0 ) {
                                    eval('$resultSnippet = $tmpModule->'.$gridConfig['snippet_smfunctions'][$key].'('.$rrFinal[$gridConfig['ds_dataField']].');');
                                }
                                if (strlen(trim($resultSnippet)) > 0) {
                                    $rrFinal[$val] = strip_tags(str_replace(', ','<br>',strtolower($resultSnippet)));
                                }
                            }
                        }

                        $outputDataDetail[$outputDataDetailCounter] = $rrFinal;
                        $outputDataDetailCounter++;
                    }

                    $outputData[$outputDataCounter]['gBC'] = $groupByCol;
                    $outputData[$outputDataCounter]['gBW'] = $groupByWhere;
                    $outputData[$outputDataCounter]['dta'] = $outputDataDetail;

                    $outputDataCounter++;
                }
            }
        }
        else {

            $useGroup = 0;
            $finSQL = " select ".trim($finViewFields)." from ( ".trim($gridSQL)." ) tmp ";

            if (strlen(trim($whereSQL)) > 0) {
                $finSQL .= " where ".trim($whereSQL)." ".$ssp_sql_q_filter;
            }
            elseif (strlen(trim($ssp_sql_q_filter)) > 0) {
                $finSQL .= " where ".$ssp_sql_q_filter;
            }

            if (strlen(trim($sortSQL)) > 0) {
                $finSQL .= " order by ".trim($sortSQL);
            }

            $rhFinal  = $this->dbH->query($finSQL);
            if ($this->dbH->errorCode() > 0) {
                $pdoDbErrorInfo = $this->dbH->errorInfo();
                die($pdoDbErrorInfo[0].'-'.$pdoDbErrorInfo[1].': '.$pdoDbErrorInfo[2]);
            }
            while ($rrFinal = $rhFinal->fetch()) {

                if ($gridConfig['snippet_used']) {

                    reset($gridConfig['snippet_label']);
                    while (list($key, $val) = each($gridConfig['snippet_label'])) {

                        unset($tmpModule);
                        unset($resultSnippet);

                        $tmpModule =& $this->loadModule($gridConfig['snippet_smmodule'][$key]);
                        if ( $rrFinal[$gridConfig['ds_dataField']] > 0 ) {
                            eval('$resultSnippet = $tmpModule->'.$gridConfig['snippet_smfunctions'][$key].'('.$rrFinal[$gridConfig['ds_dataField']].');');
                        }

                        if (strlen(trim($resultSnippet)) > 0) {
                            $rrFinal[$val] = strip_tags(str_replace(', ','<br>',strtolower($resultSnippet)));
                        }
                    }
                }

                $outputData[$outputDataCounter] = $rrFinal;
                $outputDataCounter++;
            }
        }

        $return_value = array();

        $return_value[0] = $outputDataCounter;
        $return_value[1] = $outputData;
        $return_value[2] = $useGroup;

        return $return_value;
    }

    function buildPdf($gridSQL = '', $gridConfig) {

        $member =  $this->sessionH->getMemberData();

        $grid_fields = $gridConfig['fields'];

        $outputDataCounter = 0;
        $outputData = array();
        $useGroup = 0;

        $return_value = $this->dataPreparation($gridSQL, $gridConfig);
        $outputDataCounter = $return_value[0];
        $outputData = $return_value[1];
        $useGroup = $return_value[2];

        $colWidthMaxTotal = 1000;
        $number = 0;
        $colWidthConfig = array();
        reset($gridConfig['fields']);
        while (list($key, $val) = each($gridConfig['fields'])) {

            if ($gridConfig['colwidth'][$key] > 0) {
                $colWidthConfig[$key] = $gridConfig['colwidth'][$key] * 1.35;
            }
            else {
                $colWidthConfig[$key] = 0;
                $number++;
            }
            $colWidthColSum += $colWidthConfig[$key];
        }
        $colWidthColSisa = (($colWidthMaxTotal) - $colWidthColSum)/$number;

        // start generating html
        $html  = '<html><head><title>Sistem Administrasi Pengelolaan Aset IIK</title><link rel="stylesheet" href="../../sysapp/style/default_style.css" type="text/css" /></head><body style="padding:10px;">';
        $html .= '<table width="100%" border="0" cellspacing="0" cellpadding="5">';
        $html .= '<tr>';
        $html .= ' <td align="left" valign="top" width="80"><img src="../images/logo_kominfo.png"></td>';
        $html .= ' <td align="left" valign="top"><h2>'.$gridConfig['title'].'</h2></td>';
        $html .= '<tr>';
        $html .= '</table><BR>';
        $html .= '<table width="100%" border="1" cellspacing="0" cellpadding="5">';

        //create row
        if ($useGroup == 1) {

            reset($outputData);
            while (list($key1, $val1) = each($outputData)) {

                $infoGroupBy = '';
                reset($val1['gBC']);
                while (list($key, $val) = each($val1['gBC'])) {

                    $infoGroupBy .= $grid_fields[$key].' = '.$val.', ';
                }

                $html .= '<tr><td align="left" valign="top" colspan="'.count($gridConfig['fields']).'">'.$infoGroupBy.'</td></tr>';

                // create header
                $html .= '<tr>';
                reset($grid_fields);
                while (list($key, $val) = each($grid_fields)) {

                    if (!(strlen(trim($val))>0)) $val = '&nbsp;';

                    if ($colWidthConfig[$key] > 0) {
                        $width = $colWidthConfig[$key];
                        $html .= '<td width="'.$width.'" align="left" valign="top" bgcolor="#FF2525"><B>'.strip_tags($val).'</B></td>';
                    }
                    else {
                        if (!(strlen(trim($val))>0)) $val = '&nbsp;';
                        $html .= '<td align="left" valign="top" bgcolor="#FF2525"><B>'.strip_tags($val).'</B></td>';
                    }
                }
                $html .= '</tr>';

                reset($val1['dta']);
                while (list($key2, $val2) = each($val1['dta'])) {
                    $html .= '<tr>';
                    reset($grid_fields);
                    while (list($key, $val) = each($grid_fields)) {

                        if (($gridConfig['grid_fields_type'][$key] == 'date') && (strlen(trim($val2[$key]))>0)) {
                            if ($gridConfig['grid_fields_format'][$key] == 'fulltimestamp') {
                                $val2[$key] = date('D, d M Y H:i:s', strtotime($val2[$key]));
                            }
                            elseif ($gridConfig['grid_fields_format'][$key] == 'timestamp') {
                                $val2[$key] = date('d M Y H:i:s', strtotime($val2[$key]));
                            }
                            elseif ($gridConfig['grid_fields_format'][$key] == 'ftnosecond') {
                                $val2[$key] = date('D, d M Y H:i', strtotime($val2[$key]));
                            }
                            elseif ($gridConfig['grid_fields_format'][$key] == 'ttnosecond') {
                                $val2[$key] = date('d M Y H:i', strtotime($val2[$key]));
                            }
                            elseif ($gridConfig['grid_fields_format'][$key] == 'date') {
                                $val2[$key] = date('d M Y', strtotime($val2[$key]));
                            }
                            elseif ($gridConfig['grid_fields_format'][$key] == 'time') {
                                $val2[$key] = date('H:i:s', strtotime($val2[$key]));
                            }
                            else {
                                $val2[$key] = date('d M Y', strtotime($val2[$key]));
                            }
                        }

                        if (($gridConfig['grid_fields_type'][$key] == 'numeric') && (strlen(trim($val2[$key]))>0)) {
                            $val2[$key] = number_format($val2[$key]);
                        }

                        if (!(strlen(trim($val2[$key]))>0)) $val2[$key] = '&nbsp;';

                        $align = 'left';
                        if (strlen(trim($gridConfig['grid_fields_align'][$key]))>0) {
                            $align = $gridConfig['grid_fields_align'][$key];
                        }

                        if ($colWidthConfig[$key] > 0) {
                            $width = $colWidthConfig[$key];
                            $html .= '<td width="'.$width.'" align="'.$align.'" valign="top">'.($val2[$key]).'</td>';
                        }
                        else {
                            $html .= '<td align="'.$align.'" valign="top">'.($val2[$key]).'</td>';
                        }
                    }
                    $html .= '</tr>';
                }
            }
        }
        else {

            $html .= '<tr>';
            reset($grid_fields);
            while (list($key, $val) = each($grid_fields)) {

                if (!(strlen(trim($val))>0)) $val = '&nbsp;';

                if ($colWidthConfig[$key] > 0) {
                    $width = $colWidthConfig[$key];
                    $html .= '<td width="'.$width.'" align="left" valign="top"  bgcolor="#FF2525"><B>'.($val).'</B></td>';
                }
                else {
                    $col = strlen($val);
                    $width = $colWidthColSisa;
                    $html .= '<td align="left" valign="top"  bgcolor="#FF2525"><B>'.($val).'</B></td>';
                }
            }
            $html .= '</tr>';


            reset($outputData);
            while (list($key1, $val1) = each($outputData)) {
                $html .= '<tr>';
                reset($grid_fields);
                while (list($key, $val) = each($grid_fields)) {

                    if (($gridConfig['grid_fields_type'][$key] == 'date') && (strlen(trim($val1[$key]))>0)) {
                        if ($gridConfig['grid_fields_format'][$key] == 'fulltimestamp') {
                            $val1[$key] = date('D, d M Y H:i:s', strtotime($val1[$key]));
                        }
                        elseif ($gridConfig['grid_fields_format'][$key] == 'timestamp') {
                            $val1[$key] = date('d M Y H:i:s', strtotime($val1[$key]));
                        }
                        elseif ($gridConfig['grid_fields_format'][$key] == 'ftnosecond') {
                            $val1[$key] = date('D, d M Y H:i', strtotime($val1[$key]));
                        }
                        elseif ($gridConfig['grid_fields_format'][$key] == 'ttnosecond') {
                            $val1[$key] = date('d M Y H:i', strtotime($val1[$key]));
                        }
                        elseif ($gridConfig['grid_fields_format'][$key] == 'date') {
                            $val1[$key] = date('d M Y', strtotime($val1[$key]));
                        }
                        elseif ($gridConfig['grid_fields_format'][$key] == 'time') {
                            $val1[$key] = date('H:i:s', strtotime($val1[$key]));
                        }
                        else {
                            $val1[$key] = date('d M Y', strtotime($val1[$key]));
                        }
                    }

                    if (($gridConfig['grid_fields_type'][$key] == 'numeric') && (strlen(trim($val1[$key]))>0)) {
                        $val1[$key] = number_format($val1[$key]);
                    }

                    $align = 'left';
                    if (strlen(trim($gridConfig['grid_fields_align'][$key]))>0) {
                        $align = $gridConfig['grid_fields_align'][$key];
                    }

                    if (!(strlen(trim($val1[$key]))>0)) $val1[$key] = '&nbsp;';

                    if ($colWidthConfig[$key] > 0) {
                        $width = $colWidthConfig[$key];
                        $html .= '<td width="'.$width.'" align="'.$align.'" valign="top" >'.($val1[$key]).'</td>';
                    }
                    else {
                        $width = $colWidthColSisa;
                        $html .= '<td align="'.$align.'" valign="top" >'.($val1[$key]).'</td>';
                    }
                }
                $html .= '</tr>';
            }


        }

        $html .= '</table>';
        $html .= '</body><script>window.print();</script></html>';

        $filename = './tmp/gridext_'.$_GET['option'].'_'.$member['member_id'].'_'.time().'.html';
        $handle = fopen($filename, 'a');
        fwrite($handle, $html);
        die($filename);
    }

    function buildXls($gridSQL = '', $gridConfig) {

        $member =  $this->sessionH->getMemberData();

        $grid_fields = $gridConfig['fields'];

        $outputDataCounter = 0;
        $outputData = array();
        $useGroup = 0;

        $return_value = $this->dataPreparation($gridSQL, $gridConfig);
        $outputDataCounter = $return_value[0];
        $outputData = $return_value[1];
        $useGroup = $return_value[2];

        $colWidthMaxTotal = 1000;
        $number = 0;
        $colWidthConfig = array();
        reset($gridConfig['fields']);
        while (list($key, $val) = each($gridConfig['fields'])) {

            if ($gridConfig['colwidth'][$key] > 0) {
                $colWidthConfig[$key] = $gridConfig['colwidth'][$key];
            }
            else {
                $colWidthConfig[$key] = 0;
                $number++;
            }
            $colWidthColSum += $colWidthConfig[$key];
        }
        $colWidthColSisa = (($colWidthMaxTotal) - $colWidthColSum)/$number;

        // start generating xls
        // ob_end_clean();

        require_once('./excelClass/Worksheet.php');
        require_once('./excelClass/Workbook.php');

        $filename = './tmpXls/gridext_'.$_GET['option'].'_'.$member['member_id'].'_'.time().'.xls';

        // header("Content-type: application/vnd.ms-excel");
        // header("Content-Disposition: attachment; filename=".$filename );
        // header("Expires: 0");
        // header("Cache-Control: must-revalidate, post-check=0,pre-check=0");
        // header("Pragma: public");

        // Creating a workbook
        $workbook = new Workbook($filename);

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
        $formatHD2->set_size(8);
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

        $formatFoot =& $workbook->add_format();
        $formatFoot->set_size(10);
        $formatFoot->set_bold(1);
        $formatFoot->set_align('left');
        $formatFoot->set_color('white');
        $formatFoot->set_pattern();
        $formatFoot->set_fg_color('black');
        $formatFoot->set_bottom(1);
        $formatFoot->set_left(1);
        $formatFoot->set_right(1);



        $worksheet = array();
        $wCtr = 0;

        // Creating the first worksheet
        $worksheet[$wCtr] =& $workbook->add_worksheet('IDC Report');

        // create header report
        $worksheet[$wCtr]->write_string(0, 0, $gridConfig['title'],$formatHD1);
        $worksheet[$wCtr]->write_string(1, 0, 'IDC Excel Generator, generated '.date('D, d M Y H:i:s'),$formatHD2);

        $rowCounter = 3;

        if ($useGroup == 1) {

            reset($outputData);
            while (list($key1, $val1) = each($outputData)) {
                $infoGroupBy = '';
                reset($val1['gBC']);
                while (list($key, $val) = each($val1['gBC'])) {
                    $infoGroupBy .= $grid_fields[$key].' = '.$val.', ';
                }

                $worksheet[$wCtr]->write_string($rowCounter, 0, $infoGroupBy);
                $rowCounter++;

                // create header
                $colCounter = 0;
                $worksheet[$wCtr]->set_column($colCounter, $colCounter, 5);
                $worksheet[$wCtr]->write_string($rowCounter, $colCounter, 'No.', $formatRHD);
                $colCounter++;

                reset($grid_fields);
                while (list($key, $val) = each($grid_fields)) {

                    if (!(strlen(trim($val))>0)) $val = '';

                    if ($colWidthConfig[$key] > 0) {
                        $width = round($colWidthConfig[$key] / 7);
                        $worksheet[$wCtr]->set_column($colCounter, $colCounter, $width);
                        $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val), $formatRHD);
                        $colCounter++;
                    }
                    else {
                        if (!(strlen(trim($val))>0)) $val = '';
                        $worksheet[$wCtr]->set_column($colCounter, $colCounter, 20);
                        $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val), $formatRHD);
                        $colCounter++;
                    }
                }

                $rowCounter++;

                $dataCounter = 0;
                reset($val1['dta']);
                while (list($key2, $val2) = each($val1['dta'])) {

                    $dataCounter++;

                    $colCounter = 0;
                    $worksheet[$wCtr]->write_string($rowCounter, $colCounter, $dataCounter);
                    $colCounter++;

                    reset($grid_fields);
                    while (list($key, $val) = each($grid_fields)) {

                        if (($gridConfig['grid_fields_type'][$key] == 'numeric') && (strlen(trim($val2[$key]))>0)) {

                            if (!(strlen(trim($val2[$key]))>0)) $val2[$key] = '';

                            if ($gridConfig['grid_fields_align'][$key] == 'right') {
                                $worksheet[$wCtr]->write_number($rowCounter, $colCounter, strip_tags($val2[$key]), $formatCR);
                                $colCounter++;
                            }
                            elseif ($gridConfig['grid_fields_align'][$key] == 'center') {
                                $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val2[$key]), $formatCC);
                                $colCounter++;
                            }
                            else {
                                $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val2[$key]), $formatC);
                                $colCounter++;
                            }
                        }
                        else {

                            if (($gridConfig['grid_fields_type'][$key] == 'date') && (strlen(trim($val2[$key]))>0)) {
                                if ($gridConfig['grid_fields_format'][$key] == 'fulltimestamp') {
                                    $val2[$key] = date('D, d M Y H:i:s', strtotime($val2[$key]));
                                }
                                elseif ($gridConfig['grid_fields_format'][$key] == 'timestamp') {
                                    $val2[$key] = date('d M Y H:i:s', strtotime($val2[$key]));
                                }
                                elseif ($gridConfig['grid_fields_format'][$key] == 'ftnosecond') {
                                    $val2[$key] = date('D, d M Y H:i', strtotime($val2[$key]));
                                }
                                elseif ($gridConfig['grid_fields_format'][$key] == 'ttnosecond') {
                                    $val2[$key] = date('d M Y H:i', strtotime($val2[$key]));
                                }
                                elseif ($gridConfig['grid_fields_format'][$key] == 'date') {
                                    $val2[$key] = date('d M Y', strtotime($val2[$key]));
                                }
                                elseif ($gridConfig['grid_fields_format'][$key] == 'time') {
                                    $val2[$key] = date('H:i:s', strtotime($val2[$key]));
                                }
                                else {
                                    $val2[$key] = date('d M Y', strtotime($val2[$key]));
                                }
                            }

                            if (!(strlen(trim($val2[$key]))>0)) $val2[$key] = '';

                            if ($gridConfig['grid_fields_align'][$key] == 'right') {
                                $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val2[$key]), $formatCR);
                                $colCounter++;
                            }
                            elseif ($gridConfig['grid_fields_align'][$key] == 'center') {
                                $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val2[$key]), $formatCC);
                                $colCounter++;
                            }
                            else {
                                $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val2[$key]), $formatC);
                                $colCounter++;
                            }
                        }
                    }

                    $rowCounter++;
                }

                // create footer
                $colCounter = 0;
                $worksheet[$wCtr]->write_string($rowCounter, $colCounter, 'No.', $formatRHD);
                $colCounter++;
                reset($grid_fields);
                while (list($key, $val) = each($grid_fields)) {
                    if (!(strlen(trim($val))>0)) $val = '';
                    if ($colWidthConfig[$key] > 0) {
                        $width = round($colWidthConfig[$key] / 7);
                        $worksheet[$wCtr]->set_column($colCounter, $colCounter, $width);
                        $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val), $formatRHD);
                        $colCounter++;
                    }
                    else {
                        if (!(strlen(trim($val))>0)) $val = '';
                        $worksheet[$wCtr]->set_column($colCounter, $colCounter, 20);
                        $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val), $formatRHD);
                        $colCounter++;
                    }
                }

                $rowCounter++;
            }
        }
        else {

            // create header
            $colCounter = 0;
            $worksheet[$wCtr]->set_column($colCounter, $colCounter, 50);
            $worksheet[$wCtr]->write_string($rowCounter, $colCounter, 'No.', $formatRHD);
            $colCounter++;

            reset($grid_fields);
            while (list($key, $val) = each($grid_fields)) {

                if (!(strlen(trim($val))>0)) $val = '&nbsp;';

                if ($colWidthConfig[$key] > 0) {
                    $width = round($colWidthConfig[$key] / 7);
                    $worksheet[$wCtr]->set_column($colCounter, $colCounter, $width);
                    $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val), $formatRHD);
                    $colCounter++;

                }
                else {
                    $worksheet[$wCtr]->set_column($colCounter, $colCounter, 20);
                    $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val), $formatRHD);
                    $colCounter++;
                }
            }

            $rowCounter++;
            $dataCounter = 0;

            reset($outputData);
            while (list($key1, $val1) = each($outputData)) {

                $dataCounter++;
                $colCounter = 0;
                $worksheet[$wCtr]->write_string($rowCounter, $colCounter, $dataCounter);
                $colCounter++;

                reset($grid_fields);
                while (list($key, $val) = each($grid_fields)) {

                    if (($gridConfig['grid_fields_type'][$key] == 'numeric') && (strlen(trim($val1[$key]))>0)) {

                        if (!(strlen(trim($val1[$key]))>0)) $val1[$key] = '';

                        if ($gridConfig['grid_fields_align'][$key] == 'right') {
                            $worksheet[$wCtr]->write_number($rowCounter, $colCounter, strip_tags($val1[$key]), $formatCR);
                            $colCounter++;
                        }
                        elseif ($gridConfig['grid_fields_align'][$key] == 'center') {
                            $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val1[$key]), $formatCC);
                            $colCounter++;
                        }
                        else {
                            $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val1[$key]), $formatC);
                            $colCounter++;
                        }
                    }
                    else {

                        if (($gridConfig['grid_fields_type'][$key] == 'date') && (strlen(trim($val1[$key]))>0)) {

                            if ($gridConfig['grid_fields_format'][$key] == 'fulltimestamp') {
                                $val1[$key] = date('D, d M Y H:i:s', strtotime($val1[$key]));
                            }
                            elseif ($gridConfig['grid_fields_format'][$key] == 'timestamp') {
                                $val1[$key] = date('d M Y H:i:s', strtotime($val1[$key]));
                            }
                            elseif ($gridConfig['grid_fields_format'][$key] == 'ftnosecond') {
                                $val1[$key] = date('D, d M Y H:i', strtotime($val1[$key]));
                            }
                            elseif ($gridConfig['grid_fields_format'][$key] == 'ttnosecond') {
                                $val1[$key] = date('d M Y H:i', strtotime($val1[$key]));
                            }
                            elseif ($gridConfig['grid_fields_format'][$key] == 'date') {
                                $val1[$key] = date('d M Y', strtotime($val1[$key]));
                            }
                            elseif ($gridConfig['grid_fields_format'][$key] == 'time') {
                                $val1[$key] = date('H:i:s', strtotime($val1[$key]));
                            }
                            else {
                                $val1[$key] = date('d M Y', strtotime($val1[$key]));
                            }
                        }

                        if (!(strlen(trim($val1[$key]))>0)) $val1[$key] = '';

                        if ($gridConfig['grid_fields_align'][$key] == 'right') {
                            $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val1[$key]), $formatCR);
                            $colCounter++;
                        }
                        elseif ($gridConfig['grid_fields_align'][$key] == 'center') {
                            $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val1[$key]), $formatCC);
                            $colCounter++;
                        }
                        else {
                            $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val1[$key]), $formatC);
                            $colCounter++;
                        }
                    }
                }
                $rowCounter++;
            }

            // create footer
            $colCounter = 0;
            $worksheet[$wCtr]->write_string($rowCounter, $colCounter, 'No.', $formatRHD);
            $colCounter++;
            reset($grid_fields);
            while (list($key, $val) = each($grid_fields)) {
                if (!(strlen(trim($val))>0)) $val = '';
                if ($colWidthConfig[$key] > 0) {
                    $width = round($colWidthConfig[$key] / 7);
                    $worksheet[$wCtr]->set_column($colCounter, $colCounter, $width);
                    $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val), $formatRHD);
                    $colCounter++;
                }
                else {
                    if (!(strlen(trim($val))>0)) $val = '';
                    $worksheet[$wCtr]->set_column($colCounter, $colCounter, 20);
                    $worksheet[$wCtr]->write_string($rowCounter, $colCounter, strip_tags($val), $formatRHD);
                    $colCounter++;
                }
            }
        }

        $workbook->close();

        die($filename);
    }


}

?>