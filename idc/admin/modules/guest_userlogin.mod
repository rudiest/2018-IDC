<?php

class guest_userlogin extends SM_module {

    function moduleConfig() {


    }

    function moduleThink() {

        if ($this->sessionH->isMember()) {
            $this->sessionH->attemptLogout();
            unset($_SESSION);
        }

        $fDB =& $this->loadmodule('functionDB');

        $userlogin =& $this->newSmartForm();

        $userlogin->directive['formParams'] = ' role="form" ';
        $userlogin->directive['formClassTag'] = 'form-horizontal';


        $tmp =& $userlogin->add('penanda','User ID','text',true,'',array('extraAttributes'=>' style="width:100%;" '));

        $tmp =& $userlogin->add('kunci','Password','text',true,'',array('extraAttributes'=>' style="width:100%;" '));
        $tmp->addDirective('passWord',true);

        $userlogin->add('submit','','submit',false,'Login',array('extraAttributes'=>' value="Login" '));

        $userlogin->runForm();

        if ($userlogin->dataVerified()) {

            $penanda = $fDB->encap_string($userlogin->getVar('penanda'),0,0);
            $kunci = $fDB->encap_string($userlogin->getVar('kunci'),0,0);

            $this->sessionH->attemptLogin($penanda,$kunci);

            if ($this->sessionH->isMember()) {
                $member =  $this->sessionH->getMemberData();
                if ($member['statvisible'] != 1) {
                    $this->sessionH->attemptLogout();
                    $message = '<div class="alert alert-danger"><B>Gagal Login, User & Password tidak sesuai</B></div>';
                    $this->say($message.$userlogin->output());
                }
                else {
                    $this->sessionH->transferToPage('m2.php');
                }
            }
            else {
                $message = '<div class="alert alert-danger"><B>Gagal Login, User & Password tidak sesuai</B></div>';
                $this->say($message.$userlogin->output());
            }
        }
        else {

            $this->say($userlogin->output());
       }

    }

}


?>
