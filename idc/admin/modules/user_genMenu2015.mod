<?php

  /**
  * <NAME> genMenu.mod
  * <DESC> menentukan menu apa yang tampil
  * <PIC>  Gema
  **/

  class user_genMenu2015 extends SM_module {

      function moduleConfig() {


      }
      
      function moduleThink() {
          
          $member = $this->sessionH->getMemberData();
          
          $fTpt =& $this->loadTemplate('user_genMenu2015');
          
          $base_url = $this->sessionH->uLink('m2.php');
          
          $fTpt->addText($base_url.'','sma_urlMenu');
          
          switch($this->directive['menuGroup']) {
              case 1 : $fTpt->addText('k-state-active','sma_groupMenu1'); break;
              case 2 : $fTpt->addText('k-state-active','sma_groupMenu2'); break;
              case 3 : $fTpt->addText('k-state-active','sma_groupMenu3'); break;
              case 4 : $fTpt->addText('k-state-active','sma_groupMenu4'); break;
              case 5 : $fTpt->addText('k-state-active','sma_groupMenu5'); break;
              default : $fTpt->addText('k-state-active','sma_groupMenu1'); break;
          }
          
          // admin section
          if ($member['idlevel'] == 1) {
              $fTpt2 =& $this->loadTemplate('admin_genMenu2015');
              $fTpt2->addText($base_url.'','sma_urlMenu');
              
              if ($this->directive['menuGroup'] == 5) {
                  $fTpt2->addText('k-state-active','sma_groupMenu5');
              }
              
              $fTpt ->addText($fTpt2->run().'','sma_adminMenu');
              
          }
          
          $this->say($fTpt->run());
          
      }

  }

  ?>