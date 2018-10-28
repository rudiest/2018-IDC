<?php

  global $SM_siteManager;

  // input frobbers
  $SM_siteManager->includeLib('sfInputFrob');

  // include input entities
  $SM_siteManager->includeLib('sfInputEntities');

  // filters
  $SM_siteManager->includeLib('sfFilters');

  // form entities
  $SM_siteManager->includeLib('sfFormEntity');


  class smartFormKendo extends SM_module {

	var $entityList = NULL;

    var $sfOutput = '';

    var $jsOutput = '';

    var $template = '';

    var $formID = '';

    function moduleConfig() {

        if (!isset($this->dbH)) {SM_fatalErrorPage("this module requires a database connection, which wasn't present!");}

        /* configuration */
        $this->directive['showRequiredHelp']    = true;
        $this->directive['requiredTag']         = true;
        $this->directive['requiredStar']        = ' (!)';
        $this->directive['requiredText']        = '';
        $this->directive['requiredBadMsg']      = 'Harus Diisi';

        $this->directive['formName']            = 'kendoForm_'.time();
        $this->formID                           = $this->directive['formName'];
    }

    function moduleThink() {


    }

    function loadTemplate($templateFile) {
        global $SM_siteManager;
        // attempt to load the template file
        $this->template = $SM_siteManager->loadTemplate($templateFile);
        $this->template->addDirective('SF', array('parentForm' => $this));
        return $this->template;
    }

    function getTemplate() {
        return $this->template;
    }

	function add($varName, $title, $type, $req=false, $val='', $args=NULL, $lay=SF_LAYOUT_UNDEFINED, $tA='LEFT', $iA='LEFT') {

        // don't allow the same variable twice
        if (isset($this->entityList[$varName])) {
            $this->debugLog("add: variable name $varName was already defined. ignoreing.");
            return NULL;
        }

        // if this is a read only form, change type to 'staticText' entity
        if ($this->directive['readOnly'])
            $type = 'presetText';

        // verify and load this type
        if (!SM_sfLoadEntity($type)) {
            $this->debugLog("add: bad/unknown type passed (input entity module not found): $type");
            return NULL;
        }

        // setup default layout
        if ($lay == SF_LAYOUT_UNDEFINED)
            $lay = $this->directive['defaultLayout'];

        // good entity, add it in
        $this->entityList[$varName] = new SM_formEntity($varName, $title, $type, $req, $this, $lay, $val, $tA, $iA, $this->directive['useJS']);

        // if they passed args, do them here
        if (is_array($args))
            $this->entityList[$varName]->inputEntity->configure($args);

        // success, return reference to formEntity
        return $this->entityList[$varName]->inputEntity;

    }

    /**
     * add a hidden variable to the form
     * @param string $name the name of the variable to add
     * @param string $value value of variable
     */
    function addHidden($name, $value) {
        $this->directive['hiddens'][$name] = $value;
    }

     /**
      * remove an entity from the form that has previously been added
      * @param string $varName the variable to remove
      */
    function remove($varName) {

        if (isset($this->entityList[$varName])) {
            unset($this->entityList[$varName]);
            return true;
        }
        else {
            $this->debugLog("remove: variable not found for remove: $varName");
            return false;
        }

    }

    function setArgs($varName, $args) {

        if (!is_array($args)) {
            $this->debugLog("setFilterArgs: args variable was not an array");
            return false;
        }

        if (!isset($this->entityList[$varName])) {
            $this->debugLog("setArgs: variable not found for filter add: $varName");
            return false;
        }
        else {
            $this->entityList[$varName]->inputEntity->configure($args);
        }

    }

    function setDefaultValue($varName, $default, $forceNotFTL=false) {

        if (!isset($this->entityList[$varName])) {
            $this->debugLog("setDefaultValue: variable not found for argument set: $varName");
            return false;
        }

        // we only set defaults on FTL, unless force is on
        if ($this->ftl || $forceNotFTL) {
            // we set force to true on the inputEntity setDefaultValue, to avoid another ftl check
            $this->entityList[$varName]->inputEntity->setDefaultvalue($default,true);
            return true;
        }
        else {
            return false;
        }

    }

    function setDefaults($varHash, $forceNotFTL=false) {
        foreach ($varHash as $k => $v) {
            if (isset($this->entityList[$k])) {
                $this->setDefaultValue($k, $v, $forceNotFTL);
            }
        }
    }

    function runTemplate() {

        // BACKWARD COMPATIBILITY
        // FIXME: this is deprecated, will be removed at some point...
        if (is_string($this->template)) {

            // loop through each entity, do subs
            foreach ($this->entityList as $ent) {

                // get info from entity objects for display
                $vName  = $ent->varName;
                (preg_match("/^(.+)\_\w+$/",$vName,$m)) ? $vpName = $m[1] : $vpName = $vName;
                $title  = $ent->getTitle();
                $input  = $ent->output();

                // try to substitute in the template
                $tSubVar  = '{'."$vName.title".'}';
                $tpSubVar = '{'."$vpName.title".'}';
                $iSubVar  = '{'."$vName.input".'}';
                $ipSubVar = '{'."$vpName.input".'}';

                $this->template = str_replace($tSubVar, $title, $this->template);
                $this->template = str_replace($tpSubVar, $title, $this->template);
                $this->template = str_replace($iSubVar, $input, $this->template);
                $this->template = str_replace($ipSubVar, $input, $this->template);

            }

            // sub in submit and reset buttons
            $submitPattern = "/\{submit.(.+)\}/U";
            if (preg_match($submitPattern,$this->template,$m)) {
                SM_sfLoadEntity('submit');
                $submitButton = new SM_formEntity('_submitBut'.'_'.$this->formID, '', 'submit', false, $this);
                $submitButton->inputEntity->addDirective('value',$m[1]);
                if (!empty($this->directive['submitImage'])) {
                    $submitButton->inputEntity->addDirective('image',true);
                    $submitButton->inputEntity->addDirective('src',$this->directive['submitImage']);
                }
                $submitVal = $submitButton->output();
                $this->template = preg_replace($submitPattern, $submitVal, $this->template);
            }

            $resetPattern = "/\{reset.(.+)\}/U";
            if (preg_match($resetPattern,$this->template,$m)) {
                SM_sfLoadEntity('reset');
                $resetButton = new SM_formEntity('_resetBut'.'_'.$this->formID, '', 'reset', false, $this);
                $resetButton->inputEntity->addDirective('value',$m[1]);
                if (!empty($this->directive['resetImage'])) {
                    $resetButton->inputEntity->addDirective('image',true);
                    $resetButton->inputEntity->addDirective('src',$this->directive['resetImage']);
                }
                $resetVal = $resetButton->output();
                $this->template = preg_replace($resetPattern, $resetVal, $this->template);
            }

            return $this->template;

        }
        elseif (is_object($this->template)) {

            // SM_layoutTemplate method
            return $this->template->run();

        }

        // fall through, unknown template
        $this->debugLog("unknown template type (non-string or SM_layoutTemplate");
        return '';

    }

    function buildTemplate($submit='') {

        // if $submit is set, convert html entities to allow >, etc
        if ($submit != '') {
            $submit = htmlspecialchars($submit);
        }

        $template = "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"4\">";

        // preloop variable set
        $colorRow   = false;
        $lastVar    = '';; // the last variable we just looked at

        // loop through each entity
        $firstEnt = true;
        $numFormEntities = sizeof($this->entityList);
        foreach ($this->entityList as $varName => $ent) {

            // get info from entity objects for display
            $title  = '<sm type="sf" data="title" var="'.$ent->varName.'">';
            $input  = '<sm type="sf" data="entity" var="'.$ent->varName.'">';
            $layout = $ent->getLayout();
            $tA     = $ent->getTitleAlign();
            $iA     = $ent->getInputAlign();
            $bgO    = $ent->getShowBgColor();       // check for bg color setting

            if ($title == '') $title = '&nbsp;';
            $template .= "<tr><td align=\"$tA\">$title</td><td align=\"$iA\">$input</td></tr>";

            $lastVar = $ent->varName;
        }

        // submit button
        $template .= "<tr><td >&nbsp;</td><td align=\"$iA\"><sm type=\"sf\" data=\"submit\" title=\"".$submit."\"></td></tr>";

        // $template .= "<tr><td colspan=\"2\" align=\"{$this->directive['submitAlign']}\">".'<sm type="sf" data="submit" title="'."$submit\"></td></tr>";

        $template .= "</table>\n";

        // create a new template, set it's template data to the template we just made
        $this->template = new SM_layoutTemplate();
        $this->template->addDirective('SF', array('parentForm' => $this));
        $this->template->setTemplateData($template);

    }

    function output($submit="", $hiddens=NULL) {

        // add the ftl last
        $this->addHidden($this->formID.'_ftl','1');

        // if we don't have any entities, quit now
        if ((!isset($this->entityList)) || (!is_array($this->entityList))) {
            $this->debugLog("Warning: no input entities were added, but output was called!");
            return '';
        }

        // if we don't already have a template, make one
        if (empty($this->template))
            $this->buildTemplate($submit);

        // run template, which runs all entityThinks
        $templateOutput = $this->runTemplate();

        // $this->sfOutput  = "\n<form id=\"{$this->directive['formName']}\" name=\"{$this->directive['formName']}\" method=\"post\"";

        $this->sfOutput  = "\n<div id=\"{$this->directive['formName']}\">\n";

        if (is_array($hiddens)|| (isset($this->directive['hiddens']) && is_array($this->directive['hiddens'] ) )) {

            // if they're both arrays, merge them
            if (is_array($hiddens) && (isset($this->directive['hiddens']) && is_array($this->directive['hiddens'])))
                $hiddens = array_merge($hiddens, $this->directive['hiddens']);

            // if only directive hiddens is set, make that $hiddens
            if ( (isset($this->directive['hiddens']) && is_array($this->directive['hiddens'])) && !(is_array($hiddens)))
                $hiddens = $this->directive['hiddens'];

            foreach($hiddens as $hKey => $hVal) {
                $this->sfOutput .= "<input type=\"hidden\" name=\"{$hKey}\" value=\"$hVal\" />\n";
            }

        }

        // if we've been told to dump the template, do so here
        /*
        if ((!empty($this->directive['dumpTemplate'])) && ($this->directive['dumpTemplate'])) {
            if (is_string($this->template))
                $this->sfOutput .= "<!--\n\n TEMPLATE DUMP\n\n$this->template\n\n -->\n";
            else {
                $tOutput = join("\n",$this->template->htmlTemplate);
                $this->sfOutput .= "<!--\n\n TEMPLATE DUMP\n\n{$tOutput}\n\n -->\n";
            }
        }
        */

        // run template, which runs all entityThinks
        $this->sfOutput .= $templateOutput;

        // end form
        if (!$this->directive['formIsEnded'])
            $this->sfOutput .= "\n</div>\n";

        // return final output
        return $this->sfOutput;

    }

	function getFormEntity($varName) {

        // sanity
        if (!isset($this->entityList[$varName])) {
            $this->debugLog("getFormEntity: variable not found: $varName");
            return NULL;
        }

        return $this->entityList[$varName];

    }

  }

?>
