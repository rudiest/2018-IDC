<?php


/**
 *  Roadsend SiteManager
 *******************************************************************
 *  Copyright (c) 2001-2003 Roadsend, Inc.(http://www.roadsend.com)
 *******************************************************************
 *
 * This source file is subject to version 1.0 of the Roadsend Public
 * License, that is bundled with this package in the file
 * LICENSE, and is available through the world wide web at
 * http://www.roadsend.com/license/rpl1.txt
 *
 *******************************************************************
 * Author(s): Shannon Weyrick (weyrick@roadsend.com)
 *
 */

class kendoDbComboRBEntity extends SM_inputTypeEntity {

    /**
    * setup entity
    */

    function entityConfig() {

        // setup some defaults
        $this->directive['url']            = "";
        $this->directive['minLength']      = 3;
        $this->directive['autoBind']       = false;
        $this->directive['filter']         = "contains";
        $this->directive['dataValueField'] = "id";
        $this->directive['dataTextField']  = "value";
        $this->directive['placeholder']    = "Ketik min. 3 huruf";
    }

    /**
    * output
    */

    function entityThink() {

        // quote val?
        $val = htmlentities($val, ENT_COMPAT);

        $attr = $this->getCommonAttr();
        $this->say("<input $attr name=\"$this->varName\" id=\"$this->varName\" value=\"$val\" />");

        $kendoValue = '';
        if (!empty($this->value) || ($this->value == '0')) {
            $kendoValue = ', value: "'.$this->value.'"';
        }

        $output =  '<script type="text/javascript">'.chr(13).
                   '  $(document).ready( function() { '.chr(13).
                   '      $("#'.$this->varName.'").kendoComboBox({ ';
        $output .= ' dataSource: { type: "json", ';
        $output .= '               serverFiltering: true, ';
        $output .= '               schema: { total: function(record) { return record.total; }, ';
        $output .= '                         data: function(record) { return record.data; }, ';
        $output .= '                         model:  { id: "id", fields: {"id": {type: "number"}, "value": {type: "string"}}}, ';
        $output .= '                         }, ';

        if (strlen(trim($this->directive['additionalCustomData']))>0) {
            $output .= '               transport: { read: { url: "'.$this->directive['url'].'", dataType: "json", data: {q: function(){ var tmp = $("#'.$this->varName.'").data("kendoComboBox"); return tmp.value(); }, cD: function() { return '.$this->directive['additionalCustomData'].'(); } } }} ';
        }
        else {
	        $output .= '               transport: { read: { url: "'.$this->directive['url'].'", dataType: "json", data: {q: function(){ var tmp = $("#'.$this->varName.'").data("kendoComboBox"); return tmp.value(); }} }} ';
        }


        $output .= '               } ';

        if ($this->directive['minLength']>0) {
            $output .= ', minLength: '.$this->directive['minLength'].' ';
        }
        if ($this->directive['autoBind']) {
            $output .= ', autoBind: true';
        }
        else {
            $output .= ', autoBind: false';
        }
        if (strlen(trim($this->directive['filter']))>0) {
            $output .= ', filter: "'.$this->directive['filter'].'"';
        }
        if (strlen(trim($this->directive['dataValueField']))>0) {
            $output .= ', dataValueField: "'.$this->directive['dataValueField'].'"';
        }
        if (strlen(trim($this->directive['dataTextField']))>0) {
            $output .= ', dataTextField: "'.$this->directive['dataTextField'].'"';
        }
        if (strlen(trim($this->directive['placeholder']))>0) {
            $output .= ', placeholder: "'.$this->directive['placeholder'].'"';
        }
        if (strlen(trim($this->directive['kendotemplate']))>0) {
            $output .= ', template: '.$this->directive['kendotemplate'].' ';
        }
        if (strlen(trim($this->directive['cascadeFrom']))>0) {
            $output .= ', cascadeFrom: "'.$this->directive['cascadeFrom'].'" ';
        }
        if (strlen(trim($this->directive['additionalCustomData']))>0) {
            $output .= ', cascadeFrom: "'.$this->directive['cascadeFrom'].'" ';
        }

        $output .= $kendoValue.' }); }); </script>';
        $this->say($output);
    }
}

?>
