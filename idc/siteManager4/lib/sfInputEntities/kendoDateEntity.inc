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
 *  input entity suitable for date entry. the month
 *  and day are select boxes - the year may either
 *  be a select box or years, or text input box
 *
 *  the final date returned is in the format YYYY/DD/MM
 *
 *  directives:
 *
 *   yearSelect  - when set to true, the year will be a select
 *             box rather than a text input box. if using
 *             this feature, be sure to set yearStart and
 *             yearEnd, which will define what years are
 *             included in the select box.
 *             default (true)
 *
 *   yearStart   - the year the select box will start at
 *             default (current year)
 *
 *   yearEnd     - the year the select box will end at
 *             default (current year+5)
 *
 *   monthType   - either 'long' or 'short'. affects displayed month name
 *
 *   addNoOption - when true, one of the options will be "no option",
 *                  ie, you can select a blank option to specify
 *                  the value is set with noOptionData
 *
 *   noOptionData    - defaults to 0.
 *   noOptionDisplay - defaults to --
 *
 *   showMonth - Display the month select box
 *   showDay   - Display the day select box
 *   showYear  - Display the year select box
 *
 * @author Shannon Weyrick <weyrick@roadsend.com>
 * @package roadsend_siteManager
 * @subpackage siteManager_smartForm
 */
class kendoDateEntity extends SM_inputTypeEntity {

    var $dSel;
    var $mSel;
    var $ySel;

    var $dVarName;
    var $mVarName;
    var $yVarName;

    /**
    * setup this input entity
    */

    function entityConfig() {

        $varName   = $this->varName;

        $this->dSel         = '';
        $this->mSel         = '';
        $this->ySel         = '';

        // setup date variables: trigger newValue event by hand
        $this->eventNewValue();
    }

    /**
    * run in entityConfig(), and also if user changes default value after entityConfig() runs
    * (through SM_inputEntity::setDefaultValue)
    */

    function eventNewValue() {

        // try to identify different formats
        // [M]M-[D]D-YY[YY]
        if (preg_match("/(\d\d*)[-\/](\d\d*)[-\/](\d\d\d*\d*)/",$this->value, $regs)) {
            $this->mSel = $regs[1];
            $this->dSel = $regs[2];
            $this->ySel = $regs[3];
        }

        // YYYY-[M]M-[D]D
        if (preg_match("/(\d\d\d\d)[-\/](\d\d*)[-\/](\d\d*)/",$this->value, $regs)) {
            $this->ySel = $regs[1];
            $this->mSel = $regs[2];
            $this->dSel = $regs[3];
        }

        settype($this->mSel,'integer');
        settype($this->dSel,'integer');
        settype($this->ySel,'integer');

    }

    function getValue() {
        // we override input entity and always return POST version, which is set in eventNewValue
        return $_POST[$this->varName];
    }


    /**
    * output
    */
    function entityThink() {

        $value = '';
        if ((strlen(trim($this->value))>0) && (strtotime($this->value)>0)) {
            //$value = ',value: new Date('.date('Y',strtotime($this->value)).', '.(date('m',strtotime($this->value))-1).', '.date('d',strtotime($this->value)).', '.date('H',strtotime($this->value)).', '.date('i',strtotime($this->value)).', '.date('s',strtotime($this->value)).')';
            // all date has to be YYYY-mm-dd hh24:mi:ss
            $tmpTimeStamp = explode(' ',$this->value);
            $tmpDate = explode('-',$tmpTimeStamp[0]);
            $tmpTime = explode(':',$tmpTimeStamp[1]);

            if (($tmpDate[0] > 31) && ($tmpDate[2] <= 31)) {
                $value = ',value: new Date('.str_pad($tmpDate[0],4,'0',STR_PAD_LEFT).', '.str_pad(($tmpDate[1]-1),2,'0',STR_PAD_LEFT).', '.str_pad($tmpDate[2],2,'0',STR_PAD_LEFT).', '.str_pad($tmpTime[0],2,'0',STR_PAD_LEFT).', '.str_pad($tmpTime[1],2,'0',STR_PAD_LEFT).', '.str_pad($tmpTime[2],2,'0',STR_PAD_LEFT).')';
            }
            elseif (($tmpDate[2] > 31) && ($tmpDate[1] <= 31)) {
                $value = ',value: new Date('.str_pad($tmpDate[2],4,'0',STR_PAD_LEFT).', '.str_pad(($tmpDate[1]-1),2,'0',STR_PAD_LEFT).', '.str_pad($tmpDate[0],2,'0',STR_PAD_LEFT).', '.str_pad($tmpTime[0],2,'0',STR_PAD_LEFT).', '.str_pad($tmpTime[1],2,'0',STR_PAD_LEFT).', '.str_pad($tmpTime[2],2,'0',STR_PAD_LEFT).')';
            }
        }

        $attr = $this->getCommonAttr();

        $this->say('<input name="'.$this->varName.'" id="'.$this->varName.'" value="'.$this->ySel.'-'.$this->mSel.'-'.$this->dSel.'" '.$attr.' />'."\n");
        $this->say('<script type="text/javascript">$(document).ready(function(){$("#'.$this->varName.'").kendoDatePicker({format:"dd-MM-yyyy", parseFormat:["yyyy-mm-dd", "d m yyyy", "d m y", "dd/mm/yyyy", "dd MM yyyy", "dd-MM-yyyy", "d MM yyyy", "dd MMM yyyy"] '.$value.' });});</script>'."\n");
    }

}

?>
