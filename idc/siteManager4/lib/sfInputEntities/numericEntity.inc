<?php

class numericEntity extends SM_inputTypeEntity {

    /**
    * setup entity 
    */

    function entityConfig() {
            
        // setup some defaults
        $this->directive['usemin']  = false;
        $this->directive['min']     = 0;
        $this->directive['usemax']  = false;
        $this->directive['max']  	= 0;
        $this->directive['step']  	= 1;
        $this->directive['class']   = ' class="k-textbox" ';
    }

    /**
    * output 
    */

    function entityThink() {
        
	    $val = $this->value;
	    $val = htmlentities($val, ENT_COMPAT);
	    
	    $type = ' type="number" ';
	    
	    $min = '';
	    if ($this->directive['usemin']) {
		    $min = ' min="'.$this->directive['min'].'" ';
	    }
	    
	    $max = '';
	    if ($this->directive['usemax']) {
		    $max = ' max="'.$this->directive['max'].'" ';
	    }
	    
	    $step = ' step="'.$this->directive['step'].'" ';
	    
	    $attr = $this->getCommonAttr();
	    
	    $this->say("<input $attr id=\"$this->varName\" name=\"$this->varName\" value=\"$val\" $type $min $max $step />");
	    $this->say('<script type="text/javascript">$(document).ready(function(){$("#'.$this->varName.'").kendoNumericTextBox({decimals:0,format:"n0"});});</script>'."\n");
    }

}

?>
