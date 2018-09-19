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
 *
 * @author Shannon Weyrick <weyrick@roadsend.com>
 * @package roadsend_siteManager
 * @subpackage siteManager_smartForm
 */
class dateXEntity extends SM_inputTypeEntity {

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

        // defaults
        $this->directive['yearSelect']  = false;
        $this->directive['yearStart']   = date("Y");
        $this->directive['yearEnd']     = date("Y")+5;
        $this->directive['monthType']   = 'M';

        $this->dSel         = '';
        $this->mSel         = '';
        $this->ySel         = '';

        $this->dVarName = $varName.'_d';
        $this->mVarName = $varName.'_m';
        $this->yVarName = $varName.'_y';

        // setup date variables: trigger newValue event by hand
        $this->eventNewValue();

    }

    /**
    * run in entityConfig(), and also if user changes default value after entityConfig() runs
    * (through SM_inputEntity::setDefaultValue)
    */

    function eventNewValue() {

        // if seperate date vars are available for this varName, grab them here
        if (isset($_POST[$this->mVarName]))
            $this->mSel = $_POST[$this->mVarName];
        if (isset($_POST[$this->dVarName]))
            $this->dSel = $_POST[$this->dVarName];
        if (isset($_POST[$this->yVarName]))
            $this->ySel = $_POST[$this->yVarName];

        // if we already have a value, and no single values, parse it out
        if (($this->value != '')&&(($this->mSel == '')||($this->dSel=='')||($this->ySel==''))) {

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


        // if we have any of the *Sel vars now, setup the main one as well
        if (($this->mSel != '')&&($this->dSel!='')&&($this->ySel!='')) {
            $_POST[$this->varName]     = $this->ySel.'-'.$this->mSel.'-'.$this->dSel;
        }

        // if the YEAR is not all numeric, complain
        if (($this->ySel != '')&&(!preg_match("/^\d\d\d\d$/",$this->ySel))) {
            $this->isValid = false;
            $this->fixMessage = "Year is invalid";
        }

    }


    /**
    * output
    */

    function entityThink() {

        $formID = $this->parentFormEntity->parentSmartForm->formID.'_'.$this->parentFormEntity->varName;

        $dSelO[$this->dSel] = 'selected="selected"';
        $mSelO[$this->mSel] = 'selected="selected"';
        $ySelO[$this->ySel] = 'selected="selected"';

        $attr = $this->getCommonAttr();


        $this->say("<select id=\"".$formID.'_date'."_d\" name=\"{$this->dVarName}\" $attr>\n");
        $this->say("<option value=\"0\">---</option>\n");
        for ($i=1; $i<32; $i++) {
            (isset($dSelO[$i])) ? $s = $dSelO[$i] : $s = '';
            $this->say("<option value=\"$i\" $s>$i</option>\n");
        }
        $this->say("</select>\n");

        $this->say("<select id=\"".$formID.'_date'."_m\" name=\"{$this->mVarName}\" $attr>\n");
        $this->say("<option value=\"0\">---</option>\n");
        for ($i=1; $i<13; $i++) {
            $monthName = date($this->directive['monthType'], mktime(0,0,0,$i,1,1999));
            (isset($mSelO[$i])) ? $s = $mSelO[$i] : $s = '';
            $this->say("<option value=\"$i\" $s>$monthName</option>\n");
        }
        $this->say("</select>\n");

        // year select or text box
        if ($this->directive['yearSelect']) {
            $this->say("<select name=\"{$this->yVarName}\" $attr>\n");
            for ($i=$this->directive['yearStart']; $i<$this->directive['yearEnd']; $i++) {
                (isset($ySelO[$i])) ? $s = $ySelO[$i] : $s = '';
                $this->say("<option value=\"$i\" $s>$i</option>\n");
            }
            $this->say("</select>\n");
        }
        else {
            // text box. there will be a filter on it
            $val = $this->ySel;
            $this->say("<input id=\"".$formID.'_date'."\" $attr type=\"text\" size=\"4\" maxlength=\"4\" name=\"{$this->yVarName}\" value=\"$val\" />\n");
        }

        $this->say('<script type="text/javascript">createCalendarWidget(\''.$formID.'_date\',\'EDIT\', \'ICON\',\'./images/calendar.gif\');</script>');


    }

}

?>
