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

/**
 *
 *  
 *  directives:
 *  
 *   secondSelect   - should seconds be displayed
 *   
 *   hourFormat     - 12 hour or 24 hour in display
 *   hourStart      - 0-24 range for time
 *   hourEnd        - 0-24 range for time is 24 hours by default but can be truncted
 *             
 *   minuteType   - increments (5,10,15,30 ect)
 *
 *   time MUST be in format HH:MM:SS 
 *
 * @author Shannon Weyrick <weyrick@roadsend.com>
 * @package roadsend_siteManager
 * @subpackage siteManager_smartForm 
 */
class kendoTimeEntity extends SM_inputTypeEntity {

    var $hSel;
    var $mSel;
    var $sSel;

    var $hVarName;
    var $mVarName;
    var $sVarName;
    
    /**
    * setup this input entity
    */

    function entityConfig() {
        
        $varName   = $this->varName;

        // defaults
        $this->directive['secondSelect']  = false;
        $this->directive['hourStart']  = 0;
        $this->directive['hourEnd']  = $this->directive['hourStart'] + 24;
        
        // 12 hour clock
        // $this->directive['hourFormat']   = "g A";
        // 24 hour clock 
        $this->directive['hourFormat']   = "H";
        
        $this->directive['minuteIncrement']   = 1;
                
        $this->hSel         = '';
        $this->mSel         = '';
        $this->sSel         = '';

        $this->eventNewValue();
    }   

    /**
    * run in entityConfig(), and also if user changes default value after entityConfig() runs
    * (through SM_inputEntity::setDefaultValue)
    */

    function eventNewValue() {

        // if we already have a value, and no single values, parse it out
        if (($this->value != '')&&(($this->hSel == '')||($this->mSel=='')||($this->sSel==''))) {
                
            // try to identify different formats
            if (preg_match("/(\d\d*)[:\/](\d\d*)[:\/](\d\d)/",$this->value, $regs)) {
                $this->hSel = $regs[1];
                $this->mSel = $regs[2];
                $this->sSel = $regs[3];
            }
        
            settype($this->hSel,'integer');
            settype($this->mSel,'integer');
            settype($this->sSel,'integer');
                                       
        }
        
        // if we have any of the *Sel vars now, setup the main one as well
        if (($this->hSel != '')&&($this->mSel!='')&&($this->sSel!='')) {
            $_POST[$this->varName]     = $this->hSel.':'.$this->mSel.':'.$this->sSel;
        }

    }


    /**
    * output
    */

    function entityThink() {
	    
	    $val = $this->value;
	    $val = htmlentities($val, ENT_COMPAT);
	    
	    $attr = $this->getCommonAttr();
	    
	    $this->say("<input $attr id=\"$this->varName\" name=\"$this->varName\" value=\"$val\" $type />");
	    $this->say('<script type="text/javascript">$(document).ready(function(){$("#'.$this->varName.'").kendoTimePicker({interval: '.$this->directive['minuteIncrement'].', format: "HH:mm"});});</script>'."\n");
    }

}

?>
