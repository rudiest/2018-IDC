<?php

/*
    revision history :




*/

class smartGridKendo_SSP extends SM_module {

     var $elmnt_html = '';

     var $sspSQL = '';

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

        $this->directive['grid_fields_ishtml'] = array();
        $this->directive['grid_fields_type'] = array();

        $this->directive['stringFilterOperators'] = array(
            'eq' => 'LIKE',
            'neq' => 'NOT LIKE',
            'doesnotcontain' => 'NOT LIKE',
            'contains' => 'LIKE',
            'startswith' => 'LIKE',
            'endswith' => 'LIKE',
        );

        $this->directive['nonstringFilterOperators'] = array(
            'eq' => '=',
            'gt' => '>',
            'gte' => '>=',
            'lt' => '<',
            'lte' => '<=',
            'neq' => '<>'
        );

        $this->directive['aggregateFunctions'] = array(
            'average' => 'AVG',
            'min' => 'MIN',
            'max' => 'MAX',
            'count' => 'COUNT',
            'sum' => 'SUM'
        );

        $this->directive['grid_fields_type'] = array(
            'date' => 'date',
            'numeric' => 'numeric',
        );

    }

    function moduleThink() {
        $html = 'SGK_SSP';
        $this->say($html);
    }

    function build_sort() {

        // sort query
        $ssp_sql_sort = '';
        $ssp_sort = $_GET['sort'];
        if (is_array($ssp_sort) && (count($ssp_sort)>0)) {
            $x=0;
            $ssp_sql_sort = ' order by ';
            for ($x=0;$x<(count($ssp_sort));$x++) {
                $ssp_sql_sort .= trim($ssp_sort[$x]['field']).' '.trim($ssp_sort[$x]['dir']).',';
            }
            if ($x>0) {
                $ssp_sql_sort = substr($ssp_sql_sort,0,(strlen($ssp_sql_sort)-1));
            }
        }

        return $ssp_sql_sort;
    }

    function build_filter() {

        // filter query
        $ssp_sql_filter = '';
        $ssp_sql_filterArray = array();
        $ssp_filter = $_GET['filter'];

        // directive
        $grid_fields_type = $this->directive['grid_fields_type'];

        // one column or multi column filter ?
        // is_array($ssp_filter['filters']) && (count($ssp_filter['filters'])>0)
        if (strlen(trim($ssp_filter['filters']['logic']))>0) {

            // multi column filter
            $filtersInnerLogic = '';
            $filters = $ssp_filter['filters'];
            for ($x=0;$x<(count($filters));$x++) {

                $filtersInner = $filters[$x];
                $filtersInnerArray = array();
                $filtersInnerLogic = $filtersInner['logic'];
                $filtersInnerFilters = $filtersInner['filters'];

                for ($y=0;$y<(count($filtersInnerFilters));$y++) {

                    // check coloumn type
                    $cekColType = $grid_fields_type[$filtersInnerFilters[$y]['field']];

                    if ($this->directive['grid_fields_ishtml'][$filtersInnerFilters[$y]['field']]) {
                        $cekColType = 'string';
                    }

                    switch ($cekColType) {
                        case 'numeric' :    $filtersInnerArray[$y] = " ".$filtersInnerFilters[$y]['field'].
                                                                     " ".$this->directive['nonstringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                     " '".$filtersInnerFilters[$y]['value']."' ";
                                            break;
                        case 'date'    :    $temp = explode(' ',$filtersInnerFilters[$y]['value']);
                                            $filtersInnerFilters[$y]['value'] = trim($temp[2].' '.$temp[1].' '.$temp[3]);
                                            /*
                                            $filtersInnerArray[$y] = " ".$filtersInnerFilters[$y]['field'].
                                                                     " ".$this->directive['nonstringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                     " '".date('Y-m-d',strtotime($filtersInnerFilters[$y]['value']))."' ";
                                            */                         
                                            $filtersInnerArray[$y] = "( (".$filtersInnerFilters[$y]['field'].
                                                                     "  ".$this->directive['nonstringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                     "  '".date('Y-m-d',strtotime($filtersInnerFilters[$y]['value']))."') or ".
                                                                     "  (date_format(".$filtersInnerFilters[$y]['field'].",'%Y-m-d') = ".
                                                                     "   '".date('Y-m-d',strtotime($filtersInnerFilters[$y]['value']))."') ) ". 
                                                                     " "; 
                                            break;

                        default        :    switch ($filtersInnerFilters[$y]['operator']) {
                                                case 'eq'  :
                                                case 'neq' : $filtersInnerArray[$y] = " lower(".$filtersInnerFilters[$y]['field'].") ".
                                                                                      " ".$this->directive['stringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                                      " '".strtolower(trim($filtersInnerFilters[$y]['value']))."' ";
                                                                                      break;
                                                case 'contains'  :
                                                case 'doesnotcontain' :
                                                             $filtersInnerArray[$y] = " lower(".$filtersInnerFilters[$y]['field'].") ".
                                                                                      " ".$this->directive['stringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                                      " '%".strtolower(trim($filtersInnerFilters[$y]['value']))."%' ";
                                                                                      break;

                                                case 'startswith' :
                                                             $filtersInnerArray[$y] = " lower(".$filtersInnerFilters[$y]['field'].") ".
                                                                                      " ".$this->directive['stringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                                      " '".strtolower(trim($filtersInnerFilters[$y]['value']))."%' ";
                                                                                      break;

                                                case 'endswith' :
                                                             $filtersInnerArray[$y] = " lower(".$filtersInnerFilters[$y]['field'].") ".
                                                                                      " ".$this->directive['stringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                                      " '%".strtolower(trim($filtersInnerFilters[$y]['value']))."' ";
                                                                                      break;
                                            }
                                            break;
                    }
                }

                if (count($filtersInnerArray) > 0) {
                    $ssp_sql_filterArray[$x] = " (" . implode(" ".$filtersInnerLogic." ",$filtersInnerArray) . ") ";
                }
            }

            if (count($ssp_sql_filterArray) > 0) {
                $ssp_sql_filter = " where ".implode(" and ",$ssp_sql_filterArray[$x])." ";
                if (($this->getVar('sgSt')=='update') && ($_GET['id'] > 0)) {
                    $ssp_sql_filter .= " and id = ".$_GET['id'];
                }
            }
            elseif (($this->getVar('sgSt')=='update') && ($_GET['id'] > 0)) {
                $ssp_sql_filter .= " where id = ".$_GET['id'];
            }
        }
        else {

            // single column filter
            $filtersInnerArray = array();
            $filtersInnerFilters = $ssp_filter['filters'];
            $filtersInnerLogic = $ssp_filter['logic'];

            for ($y=0;$y<(count($filtersInnerFilters));$y++) {

                // check coloumn type
                $cekColType = $grid_fields_type[$filtersInnerFilters[$y]['field']];

                if (!(strlen(trim($cekColType))>0)) {
                    $cekColType = 'string';
                }

                if ($this->directive['grid_fields_ishtml'][$filtersInnerFilters[$y]['field']]) {
                    $cekColType = 'string';
                }

                switch ($cekColType) {
                    case 'numeric' :    $filtersInnerArray[$y] = " ".$filtersInnerFilters[$y]['field'].
                                                                 " ".$this->directive['nonstringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                 " '".$filtersInnerFilters[$y]['value']."' ";
                                        break;
                    case 'date'    :    // correct js data object, throw all gmt correction
                                        $temp = explode(' ',$filtersInnerFilters[$y]['value']);
                                        $filtersInnerFilters[$y]['value'] = trim($temp[2].' '.$temp[1].' '.$temp[3]);
                                        /*
                                        $filtersInnerArray[$y] = " ".$filtersInnerFilters[$y]['field'].
                                                                 " ".$this->directive['nonstringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                 " '".date('Y-m-d',strtotime($filtersInnerFilters[$y]['value']))."' ";
                                        */
                                        $filtersInnerArray[$y] = "( (".$filtersInnerFilters[$y]['field'].
                                                                     "  ".$this->directive['nonstringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                     "  '".date('Y-m-d',strtotime($filtersInnerFilters[$y]['value']))."') or ".
                                                                     "  (date_format(".$filtersInnerFilters[$y]['field'].",'%Y-%m-%d') = ".
                                                                     "   '".date('Y-m-d',strtotime($filtersInnerFilters[$y]['value']))."') ) ". 
                                                                     " ";                   
                                        break;

                    default        :    switch ($filtersInnerFilters[$y]['operator']) {
                                            case 'eq'  :
                                            case 'neq' : $filtersInnerArray[$y] = " lower(".$filtersInnerFilters[$y]['field'].") ".
                                                                                  " ".$this->directive['stringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                                  " '".strtolower(trim($filtersInnerFilters[$y]['value']))."' ";
                                                                                  break;
                                            case 'contains'  :
                                            case 'doesnotcontain' :
                                                         $filtersInnerArray[$y] = " lower(".$filtersInnerFilters[$y]['field'].") ".
                                                                                  " ".$this->directive['stringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                                  " '%".strtolower(trim($filtersInnerFilters[$y]['value']))."%' ";
                                                                                  break;

                                            case 'startswith' :
                                                         $filtersInnerArray[$y] = " lower(".$filtersInnerFilters[$y]['field'].") ".
                                                                                  " ".$this->directive['stringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                                  " '".strtolower(trim($filtersInnerFilters[$y]['value']))."%' ";
                                                                                  break;

                                            case 'endswith' :
                                                         $filtersInnerArray[$y] = " lower(".$filtersInnerFilters[$y]['field'].") ".
                                                                                  " ".$this->directive['stringFilterOperators'][$filtersInnerFilters[$y]['operator']].
                                                                                  " '%".strtolower(trim($filtersInnerFilters[$y]['value']))."' ";
                                                                                  break;
                                        }
                                        break;
                }
            }

            if (count($filtersInnerArray) > 0) {
                $ssp_sql_filter = " where (" . implode(" ".$filtersInnerLogic." ",$filtersInnerArray) . ") ";
                if (($this->getVar('sgSt')=='update') && ($_GET['id'] > 0)) {
                    $ssp_sql_filter .= " and id = ".$_GET['id'];
                }
            }
            elseif (($this->getVar('sgSt')=='update') && ($_GET['id'] > 0)) {
                $ssp_sql_filter .= " where id = ".$_GET['id'];
            }
        }

        return $ssp_sql_filter;
    }

    function auto_getSQL($SQL) {

        $sspSQL = '';

        $ssp_sql_sort = $this->build_sort();
        $ssp_sql_filter = $this->build_filter();

        $sspSQL = " select * from ( ".$SQL." ) sspTemp ".$ssp_sql_filter." ".$ssp_sql_sort;

        return $sspSQL;

    }


}


?>
