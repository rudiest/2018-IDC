<?php

/**
 *  This is a new combobox, that has fitur for kendo remote binding. Data will not be populated at first runt. Dont forget to set the database action.
 */
class kendoDbComboRemoteBindEntity extends SM_inputTypeEntity {

    function entityConfig() {

        if (empty($this->directive['dataBaseID']))
            $this->directive['dataBaseID'] = 'default';

        $varName   = $this->varName;

        $this->directive['comboSQL']    = NULL;
    }

    /**
    * output
    */
    function entityThink() {

        $attr = $this->getCommonAttr();

        $htmlOption = '';
        $SQL  = $this->directive['comboSQL'];
        if (strlen(trim($SQL))>0) {

            $rh = $this->dbHL[$this->directive['dataBaseID']]->query($SQL);
            if ($this->dbErrorCheck($rh, $this)) {
                $htmlOption .= '<option value="0">** bad SQL query **</option>';
                return;
            }

            while ($rr = $rh->fetchRow(DB_FETCHMODE_ORDERED)) {

                if (($this->value != '') && ($this->value == $rr['id'])) {
                    $htmlOption .= '<option value="'.$rr['id'].'" selected>'.$rr['label'].'</option>';
                }
                else {
                    $htmlOption .= '<option value="'.$rr['id'].'">'.$rr['label'].'</option>';
                }
            }
            $rh = null;
        }

        $htmlTag  = '';
        $htmlTag .= '<select id="'.$this->varName.'" name="'.$this->varName.'" '.$attr.'>';
        $htmlTag .= $htmlOption;
        $htmlTag .= '</select>';

        // url for remote binding
        $urlBind  = $_SERVER['REQUEST_URI'].'&isRmtBin=yes&rmtBinId='.$this->varName;
        if (strlen(trim($this->directive['urlBind']))>0) {
            $urlBind = $this->directive['urlBind'].'&isRmtBin=yes&rmtBinId='.$this->varName;
        }

        $kendoTag  = '';
        if (strlen(trim($this->directive['placeHolder']))>0) {
            $kendoTag .= 'placeholder: "'.$this->directive['placeHolder'].'",';
        }

        if ($this->directive['minLength']>0) {
            $kendoTag .= 'minLength: '.$this->directive['minLength'].',';
        }
        else {
            $kendoTag .= 'minLength: 3,';
        }

        if ($this->directive['autoBindFalse']) {
            $kendoTag .= 'autoBind: false,'.chr(13);
        }
        else {
            $kendoTag .= 'autoBind: true,'.chr(13);
        }

        $jsKendo  = '<script type="text/javascript">'.chr(13);
        $jsKendo .= '$(document).ready(function(){'.chr(13);
        $jsKendo .= '  $("#'.$this->varName.'").kendoComboBox({'.chr(13);
        $jsKendo .= '    dataTextField:"label",'.chr(13);
        $jsKendo .= '    dataValueField:"id",'.chr(13);
        $jsKendo .= '    filter:"contains",'.chr(13);
        $jsKendo .= $kendoTag;
        $jsKendo .= '    dataSource: { '.chr(13);
        $jsKendo .= '      type: "json", '.chr(13);
        $jsKendo .= '      pageSize: "30", '.chr(13);
        $jsKendo .= '      serverFiltering: true, '.chr(13);
        $jsKendo .= '      schema: { total : function (data) { return data.total; }, '.chr(13);
        $jsKendo .= '                data  : function (data) { return data.result; }, '.chr(13);
        $jsKendo .= '                model : { id: "id", fields: {  "id": {  type: "number"  }, "label": { type: "string" } } }, '.chr(13);
        $jsKendo .= '                type  : "json" '.chr(13);
        $jsKendo .= '                }, '.chr(13);
        $jsKendo .= '      transport: { read: { url: "'.$urlBind.'", dataType: "json" } } '.chr(13);
        $jsKendo .= '    } '.chr(13);
        $jsKendo .= '  }); '.chr(13);
        $jsKendo .= '}); '.chr(13);
        $jsKendo .= '</script>'.chr(13);

        $this->say($htmlTag.$jsKendo);
    }

}

?>
