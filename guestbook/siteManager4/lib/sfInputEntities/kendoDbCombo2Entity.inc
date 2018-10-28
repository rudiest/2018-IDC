<?php

/**
 *  This is a new combobox, that has fitur for kendo remote binding. Data will not be populated at first runt. Dont forget to set the database action.
 */
class kendoDbCombo2Entity extends SM_inputTypeEntity {

    var $comboSQL = '';

    function entityConfig() {

        if (empty($this->directive['dataBaseID']))
            $this->directive['dataBaseID'] = 'default';

        $varName   = $this->varName;

        $this->directive['comboSQL']    = NULL;
        $this->directive['useJsVarData']= true;

        $this->directive['tableName']   = NULL;
        $this->directive['whereClause'] = NULL;
        $this->directive['viewField']   = NULL;
        $this->directive['dataField']   = NULL;
        $this->directive['orderBy']     = NULL;
        $this->directive['groupBy']     = NULL;
        $this->directive['vfSeparator'] = ', ';
    }

    /**
    * output
    */
    function entityThink() {

        $attr = $this->getCommonAttr();

        $SQL = '';
        $fromPopulate = 0;
        if (strlen(trim($this->directive['comboSQL']))>0) {
            $SQL = $this->directive['comboSQL'];
            $fromPopulate = 0;
        }
        else {
            $this->generateSQL();
            if (strlen(trim($this->comboSQL))>0) {
                $SQL = $this->comboSQL;
                $fromPopulate = 1;
            }
        }

        $htmlOption = '';
        $jsVar = 'var jsdata_'.$this->varName.' = [ ';
        if (strlen(trim($SQL))>0) {
            $rh = $this->dbHL[$this->directive['dataBaseID']]->query($SQL);
            if ($this->dbErrorCheck($rh, $this)) {
                $htmlOption .= '<option value="0">** bad SQL query **</option>';
                $jsVar .= '{ "id": 0, "label": "** bad SQL query **"} '.chr(13);
                return;
            }
            $rhCounter = 0;
            while ($rr = $rh->fetchRow(DB_FETCHMODE_ORDERED)) {
                $rhCounter++;
                if ($fromPopulate == 0) {
                    if (($this->value != '') && ($this->value == $rr['id'])) {
                        $htmlOption .= '<option value="'.$rr['id'].'" selected>'.$rr['label'].'</option>';
                    }
                    else {
                        $htmlOption .= '<option value="'.$rr['id'].'">'.$rr['label'].'</option>';
                    }
                    $jsVar .= '{ "id": '.$rr['id'].', "label": "'.$rr['label'].'"}, '.chr(13);
                }
                else {

                    $id = '';
                    $label = '';

                    $id = $rr[0];
                    for ($fc=1; $fc < sizeof($rr); $fc++) {
                        $label .= $rr[$fc].$this->directive['vfSeparator'];
                    }
                    $cutVal = strlen($this->directive['vfSeparator']);
                    $label = substr(str_replace("'","",str_replace('"','',$label)), 0, -$cutVal);

                    if ($id > 0) {
                        $jsVar .= '{ "id": '.$id.', "label": "'.$label.'"}, '.chr(13);
                    }
                }
            }
            $rh = null;
            if ($rhCounter > 0) $jsVar = substr($jsVar,0,(strlen($jsVar)-3));
        }
        $jsVar .= ' ]; '.chr(13);

        $htmlTag  = '';
        $htmlTag .= '<select id="'.$this->varName.'" name="'.$this->varName.'" '.$attr.'>';

        if (!($this->directive['useJsVarData'])) {
            $htmlTag .= $htmlOption;
        }

        $htmlTag .= '</select>';

        // url for remote binding
        $urlBind  = $_SERVER['REQUEST_URI'].'&isRmtBin=yes&rmtBinId='.$this->varName;
        if (strlen(trim($this->directive['urlBind']))>0) {
            $urlBind = $this->directive['urlBind'].'&isRmtBin=yes&rmtBinId='.$this->varName;
        }

        $kendoTag  = '';
        if (strlen(trim($this->directive['placeHolder']))>0) {
            $kendoTag .= 'placeholder: "'.$this->directive['placeHolder'].'",'.chr(13);
        }

        if ($this->directive['autoBindFalse']) {
            $kendoTag .= 'autoBind: false,'.chr(13);
        }
        else {
            $kendoTag .= 'autoBind: true,'.chr(13);
        }

        if ($this->directive['minLength']>0) {
            $kendoTag .= 'minLength: '.$this->directive['minLength'].','.chr(13);
        }
        else {
            $kendoTag .= 'minLength: 3,'.chr(13);
        }

        if (strlen(trim($this->directive['filter']))>0) {
            $kendoTag .= 'filter: "'.$this->directive['filter'].'",'.chr(13);
        }
        else {
            $kendoTag .= 'filter: "contains",'.chr(13);
        }

        $jsKendo  = '<script type="text/javascript">'.chr(13);
        $jsKendo .= $jsVar;
        $jsKendo .= '$(document).ready(function(){'.chr(13);
        $jsKendo .= '  $("#'.$this->varName.'").kendoComboBox({'.chr(13);
        $jsKendo .= '    dataTextField:"label",'.chr(13);
        $jsKendo .= '    dataValueField:"id",'.chr(13);
        $jsKendo .= $kendoTag;

        if ($this->directive['useJsVarData']) {
            $jsKendo .= '    dataSource: { data: jsdata_'.$this->varName.', pageSize: 50 } '.chr(13);
        }

        $jsKendo .= '  }); '.chr(13);
        $jsKendo .= '}); '.chr(13);
        $jsKendo .= '</script>'.chr(13);

        $this->say($htmlTag.$jsKendo);
    }

    function generateSQL() {

        if (empty($this->dbHL[$this->directive['dataBaseID']])) {
            $this->fatalErrorPage("attempt to use dbSelectEntity without a database connection on id [{$this->directive['dataBaseID']}]!");
        }

        if (($this->directive['tableName'] == '')||($this->directive['dataField'] == '')) {
            $this->debugLog("table or dataField was not set!");
            return;
        }

        if (!empty($this->directive['whereClause'])) {
            if (!eregi("WHERE",$this->directive['whereClause']))
                $wC = 'WHERE '.$this->directive['whereClause'];
            else
                $wC = $this->directive['whereClause'];
        }
        else {
            $wC = '';
        }

        $vF = $this->directive['viewField'];
        if (empty($vF)) {
            $this->fatalErrorPage("viewField wasn't set");
        }

        // order by viewField by default
        if ($this->directive['orderBy'] != '')
            $oB = 'ORDER BY '.$this->directive['orderBy'];
        elseif ($this->directive['orderBy'] != '*')
            $oB = 'ORDER BY '.$this->directive['viewField'];
        else
            $oB = '';

        // order by viewField by default
        if ($this->directive['groupBy'] != '')
            $gB = ' GROUP BY '.$this->directive['groupBy'];
        else
            $gB = '';

        // check for a dbOverRide
        if(isset($this->directive['dbOverRide']))
           $dbName = $this->directive['dbOverRide'];

        $this->comboSQL = "SELECT {$this->directive['dataField']} AS table_id, {$this->directive['viewField']} FROM {$this->directive['tableName']} $wC $gB $oB";

        return $this->comboSQL;
    }

}

?>
