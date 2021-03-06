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
 * Change Log
 *
 *       11/29/2001 - all directives not already initilized were set to 'Null'.
 *                      This was done so that it would be posible to get a
 *                     list of directives on the fly. (gollum)
 *
 */

/**
 *  SUBMIT input entity.
 *
 *  directive:
 *
 *     value - the VALUE tag
 *     image - bool (default false). when true, type is IMAGE and SRC must be set
 *     extra - freeform extra text
 *     src   - image SRC, if type is IMAGE
 *
 * @author Shannon Weyrick <weyrick@roadsend.com>
 * @package roadsend_siteManager
 * @subpackage siteManager_smartForm
 */
class ajaxSubmitEntity extends SM_inputTypeEntity {


    /**
    * configure the entity
    */

    function entityConfig() {

        // clean layout up, we'll do our own
        // $this->parentFormEntity->layout = SF_LAYOUT_SINGLENOBR;

        // SUBMIT or IMG
        $this->directive['image'] = false;
        $this->directive['value'] = NULL;
        $this->directive['extra'] = NULL;
        $this->directive['src']     = NULL;
        $this->directive['onclick'] = NULL;
        $this->directive['classButton'] = "inputButton";
        $this->directive['useCancel'] = true;
        // $this->directive['noDisabled'] = false;
        // $this->directive['formLabelID'] = NULL;
        // $this->directive['useTrickyForm'] = false;
    }

    /**
    * output:  return static text
    */

    function entityThink() {

        if ($this->directive['image'])
            $sType = 'image';
        else
            $sType = 'button';

        $attr = $this->getCommonAttr();

        if ( $this->directive['useCancel'] ) {

            $tmpX = str_replace('()','',$this->directive['onclick']);            
            $this->say("<input type=\"button\" class=\"".$this->directive['classButton']."\" id=\"".$this->varName."_cancel\" name=\"".$this->varName."_cancel\" onclick=\"{$tmpX}_cancelForm()\" value=\"Batal\"\>&nbsp;&nbsp;");
        }
		//chekPrv()
        $this->say("<input ".$this->directive['extra']." class=\"".$this->directive['classButton']."\" $attr border=\"0\" type=\"".$sType.'" id="'.$this->varName.'" name="'.$this->varName.'"');

        if (isset($this->directive['onclick']))
            $this->say(" onclick=\"isAjax = true; if (chekPrv() == true) {".$this->directive['onclick']."}\" ");

        if (isset($this->directive['value']))
            $this->say(" value=\"{$this->directive['value']}\" ");

        if (isset($this->directive['extra']))
            $this->say(" {$this->directive['extra']} ");

        if (isset($this->directive['src']))
            $this->say(" src=\"{$this->directive['src']}\" ");

        $this->say('  />');

    }

}

?>
