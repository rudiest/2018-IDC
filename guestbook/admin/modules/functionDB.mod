<?php

  /**
  * <NAME> functionDB.mod
  * <DESC> list of generated function !
  * <PIC>  Gema
  **/

  class functionDB extends SM_module {

    function moduleConfig() {}

    function moduleThink() {}

    function dbins($table, $columnNameAndValue, $cleanup = 1) {

        // clean up input state
        // cek member
        // cek access right
        // cek action right
        // log action
        // execute action

        $member =  $this->sessionH->getMemberData();
        if ($member['idxNum'] == '') {
            $member['idxNum'] = '-50';
        }

        $colname = '';
        $colvalue = '';
        reset($columnNameAndValue);
        while (list($key, $val) = each($columnNameAndValue)) {
            $colname .= $key.',';
            $colvalue .= $val.',';
        }
        $colname = substr($colname,0,-1);
        $colvalue = substr($colvalue,0,-1);

        $SQL = "insert into ".$table." ( ".$colname." ) values ( ".$colvalue." ); ";

        $SQLlog = "insert into
                   log_activity
                   ( act_time,
                     act_type,
                     act_table,
                     act_docurl,
                     act_dicref,
                     act_ipaddress,
                     act_macaddress,
                     act_browser,
                     act_id_user,
                     act_id_session,
                     act_id_memo
                     )
                   values ( now(),
                            'DBINSERT',
                            '".$table."',
                            '".str_replace("'","\'",$_SERVER['REQUEST_URI'])."',
                            '".str_replace("'","\'",$_SERVER['HTTP_REFERER'])."',
                            '".$_SERVER['REMOTE_ADDR']."',
                            '".session_id()."',
                            '".str_replace("'","\'",$_SERVER['HTTP_USER_AGENT'])."',
                            '".$member['idxNum']."',
                            '".$_GET['sID']."',
                             ".$this->encap_string($SQL)."
                            )
                   ";
        $act = $this->dbH->query($SQLlog);
        $this->dberror_show($act, $SQLlog);

        $act = $this->dbH->query($SQL);
        $this->dberror_show($act, $SQL);
    }

    function dblock($table = '', $primaryName = '', $primaryValue = 0, $memo = '') {

        $member =  $this->sessionH->getMemberData();

        $memo = 'Locking data from table '.$table.' with '.$primaryName.'='.$primaryValue.'. '.$memo;

        $SQLlog = "insert into
                   log_activity
                   ( act_time,
                     act_type,
                     act_table,
                     act_docurl,
                     act_dicref,
                     act_ipaddress,
                     act_macaddress,
                     act_browser,
                     act_id_user,
                     act_id_session,
                     act_id_memo
                     )
                   values ( now(),
                            'DATALOCK',
                            '".$table."',
                            '".str_replace("'","\'",$_SERVER['REQUEST_URI'])."',
                            '".str_replace("'","\'",$_SERVER['HTTP_REFERER'])."',
                            '".$_SERVER['REMOTE_ADDR']."',
                            '".session_id()."',
                            '".str_replace("'","\'",$_SERVER['HTTP_USER_AGENT'])."',
                            '".$member['idxNum']."',
                            '".$_GET['sID']."',
                             ".$this->encap_string($memo)."
                            )
                   ";
        $act = $this->dbH->query($SQLlog);
        $this->dberror_show($act, $SQLlog);

        return 'locklogged';
    }

    function dbunlock($table = '', $primaryName = '', $primaryValue = 0, $memo = '') {

        $member =  $this->sessionH->getMemberData();

        $memo = 'Unlocking data from table '.$table.' with '.$primaryName.'='.$primaryValue.'. '.$memo;

        $SQLlog = "insert into
                   log_activity
                   ( act_time,
                     act_type,
                     act_table,
                     act_docurl,
                     act_dicref,
                     act_ipaddress,
                     act_macaddress,
                     act_browser,
                     act_id_user,
                     act_id_session,
                     act_id_memo
                     )
                   values ( now(),
                            'DATAUNLOCK',
                            '".$table."',
                            '".str_replace("'","\'",$_SERVER['REQUEST_URI'])."',
                            '".str_replace("'","\'",$_SERVER['HTTP_REFERER'])."',
                            '".$_SERVER['REMOTE_ADDR']."',
                            '".session_id()."',
                            '".str_replace("'","\'",$_SERVER['HTTP_USER_AGENT'])."',
                            '".$member['idxNum']."',
                            '".$_GET['sID']."',
                             ".$this->encap_string($memo)."
                            )
                   ";
        $act = $this->dbH->query($SQLlog);
        $this->dberror_show($act, $SQLlog);

        return 'unlocklogged';
    }

    function dbupd($table, $columnNameAndValue, $whereclause, $cleanup = 1) {

        // clean up input state
        // cek member
        // cek access right
        // cek action right
        // log action
        // execute action

        $member =  $this->sessionH->getMemberData();
        if ($member['idxNum'] == '') {
            $member['idxNum'] = '-50';
        }

        $colname = '';
        $colsetvalue = '';
        reset($columnNameAndValue);
        while (list($key, $val) = each($columnNameAndValue)) {
            $colsetvalue .= $key.' = '.$val.',';
            $colname .= $key.',';
        }
        $colsetvalue = substr($colsetvalue,0,-1);
        $colname = substr($colname,0,-1);

        $SQL = "update ".$table." set ".$colsetvalue." where ".$whereclause." ";

        $SQLlog = "insert into
                   log_activity
                   ( act_time,
                     act_type,
                     act_table,
                     act_docurl,
                     act_dicref,
                     act_ipaddress,
                     act_macaddress,
                     act_browser,
                     act_id_user,
                     act_id_session,
                     act_id_memo
                     )
                   values ( now(),
                            'DBUPDATE',
                            '".$table."',
                            '".str_replace("'","\'",$_SERVER['REQUEST_URI'])."',
                            '".str_replace("'","\'",$_SERVER['HTTP_REFERER'])."',
                            '".$_SERVER['REMOTE_ADDR']."',
                            '".session_id()."',
                            '".str_replace("'","\'",$_SERVER['HTTP_USER_AGENT'])."',
                            '".$member['idxNum']."',
                            '".$_GET['sID']."',
                             ".$this->encap_string($SQL)."
                            )
                   ";
        $act = $this->dbH->query($SQLlog);
        $this->dberror_show($act, $SQLlog);

        $act = $this->dbH->query($SQL);
        $this->dberror_show($act, $SQL);
    }

    function dbdelete($table, $whereclause, $memo = '', $cleanup = 1) {

        $member =  $this->sessionH->getMemberData();

        $SQL = "delete from ".$table." where ".$whereclause." ";

        $SQLlog = "insert into
                   log_activity
                   ( act_time,
                     act_type,
                     act_table,
                     act_docurl,
                     act_dicref,
                     act_ipaddress,
                     act_macaddress,
                     act_browser,
                     act_id_user,
                     act_id_session,
                     act_id_memo
                     )
                   values ( now(),
                            'DBDELETE',
                            '".$table."',
                            '".str_replace("'","\'",$_SERVER['REQUEST_URI'])."',
                            '".str_replace("'","\'",$_SERVER['HTTP_REFERER'])."',
                            '".$_SERVER['REMOTE_ADDR']."',
                            '".session_id()."',
                            '".str_replace("'","\'",$_SERVER['HTTP_USER_AGENT'])."',
                            '".$member['idxNum']."',
                            '".$_GET['sID']."',
                             ".$this->encap_string($memo.'='.$SQL)."
                            )
                   ";
        $act = $this->dbH->query($SQLlog);
        $this->dberror_show($act, $SQLlog);

        $act = $this->dbH->query($SQL);
        $this->dberror_show($act, $SQL);
    }

    function encap_numeric($value) {
        if (strlen(trim($value))>0) {
            if (is_numeric($value)) {
                return $value;
            }
            else {
                return 'null';
            }
        }
        else {
            return 'null';
        }
    }

    function encap_date($value,$format=1) {
        if (strlen(trim($value))>0) {
            $nowvalue = '';
            switch ($format) {

                case '4': $tmp = explode(' ',$value);

                          $idmonth = 0;
                          switch (strtolower($tmp[1])) {
                              case 'jan' : $idmonth = '01'; break;
                              case 'feb' : $idmonth = '02'; break;
                              case 'mar' : $idmonth = '03'; break;
                              case 'apr' : $idmonth = '04'; break;
                              case 'may' : $idmonth = '05'; break;
                              case 'jun' : $idmonth = '06'; break;
                              case 'jul' : $idmonth = '07'; break;
                              case 'aug' : $idmonth = '08'; break;
                              case 'sep' : $idmonth = '09'; break;
                              case 'oct' : $idmonth = '10'; break;
                              case 'nov' : $idmonth = '11'; break;
                              case 'dec' : $idmonth = '12'; break;
                          }

                          $nowvalue = $tmp[3].'-'.$idmonth.'-'.str_pad($tmp[2],2,'0',STR_PAD_LEFT);
                          break;

                case '3': $tmp = explode('-',$value);
                          if ($tmp[2] <= 99) {
                              $tmp[2] = '20'.$tmp[2];
                          }
                          $nowvalue = $tmp[2].'-'.$tmp[0].'-'.$tmp[1];
                          break;

                case '2': $tmp = explode('-',$value);
                          if ($tmp[0] <= 99) {
                              $tmp[0] = '20'.$tmp[0];
                          }
                          $nowvalue = $tmp[0].'-'.$tmp[1].'-'.$tmp[2];
                          break;

                default : $tmp = explode('-',$value);
                          if ($tmp[2] <= 99) {
                              $tmp[2] = '20'.$tmp[2];
                          }
                          $nowvalue = $tmp[2].'-'.$tmp[1].'-'.$tmp[0];
                          break;
            }
            if (strlen(trim($nowvalue))>2) {
                return "'".$nowvalue."'";
            }
            else {
                return 'null';
            }
        }
        else {
            return 'null';
        }
    }

    function encap_time($value,$format=1) {
        if (strlen(trim($value))>0) {
            $nowvalue = '';
            switch ($format) {

	            case '4': $tmp = explode(' ',$value);
					      $nowvalue = $tmp[4];
                          break;

                default : $tmp1 = explode(' ',$value);
                          $tmp2 = explode(':',$tmp1[0]);

                          $hour = $tmp2[0];
                          $minu = $tmp2[1];
                          $seco = $tmp2[2];

                          // use am pm ?
                          if ($tmp1[1] == 'AM') {

                          }
                          elseif ($tmp1[1] == 'PM') {
                            $hour = $hour + 12;
                          }

                          if (($hour >= 0) && (strlen(trim($hour))>0)) {
                            $nowvalue = str_pad($hour,2,'0',STR_PAD_LEFT);
                          }
                          else {
                            $nowvalue = '00';
                          }

                          if (($minu >= 0) && (strlen(trim($minu))>0)) {
                            $nowvalue .= ':' . str_pad($minu,2,'0',STR_PAD_LEFT);
                          }
                          else {
                            $nowvalue .= ':00';
                          }

                          if (($seco >= 0) && (strlen(trim($seco))>0)) {
                            $nowvalue .= ':' . str_pad($seco,2,'0',STR_PAD_LEFT);
                          }
                          else {
                            $nowvalue .= ':00';
                          }
                          break;
            }
            if (strlen(trim($nowvalue))>2) {
                return "'".$nowvalue."'";
            }
            else {
                return 'null';
            }
        }
        else {
            return 'null';
        }
    }

    function encap_datetime($date,$formatdate=1,$time,$formattime=1) {

        $rstDate = $this->encap_date($date,$formatdate);
        $rstTime = $this->encap_time($time,$formattime);

        $nowvalue = '';
        if ($rstDate == 'null') {
            if ($rstTime == 'null') {
                return 'null';
            }
            else {
                return "'0000-00-00 ".str_replace("'","",$rstTime)."'";
            }
        }
        else {
            if ($rstTime == 'null') {
                return "'".str_replace("'","",$rstDate)." 00:00:00'";
            }
            else {
                return "'".str_replace("'","",$rstDate)." ".str_replace("'","",$rstTime)."'";
            }
        }

        return null;
    }

    function encap_string($value, $escapechar = 0) {

        if ($escapechar == 1) {
            $value = str_replace("\'","'",$value);
            $value = str_replace('\"','"',$value);
            $value = str_replace("'","\'",$value);
            $value = str_replace('"','\"',$value);
        }
        else {
            $value = str_replace("\'","'",$value);
            $value = str_replace('\"','"',$value);
            $value = str_replace('"','',$value);
            $value = str_replace("'","",$value);
        }

        return "'".$value."'";
    }


    function dberror_show($dbconn, $prevsql = '', $usehtml = 1, $usedie = 1) {
        $errorMessage = '';
        $nl = '';
        if ($usehtml == 1) {
            $nl = '<BR>';
        }
        else {
            $nl = "\r\n";
        }

        if ($this->dbH->errorCode() > 0) {

            $pdoDbErrorInfo = $this->dbH->errorInfo();

            $errorMessage .= 'DB ERROR'.$nl;
            $errorMessage .= 'SQL Code: '.$pdoDbErrorInfo[0].$nl;
            $errorMessage .= 'Driver Code: '.$pdoDbErrorInfo[1].$nl;
            $errorMessage .= 'Message: '.$pdoDbErrorInfo[2].$nl;
            $errorMessage .= 'PREVIOUS SQL: '.$prevsql.$nl;
            $errorMessage .= 'Traceback: '.$nl;
            $traceback = $dbconn->backtrace;
            reset($traceback);
            while (list($key, $val) = each($traceback)) {

                if (  ($val['file'] != '/opt/lampp/lib/php/DB.php') &&
                      ($val['file'] != '/opt/lampp/lib/php/PEAR/FixPHP5PEARWarnings.php') &&
                      ($val['file'] != '/opt/lampp/lib/php/PEAR.php') &&
                      ($val['file'] != '/opt/lampp/lib/php/DB/common.php') &&
                      ($val['file'] != '/opt/lampp/lib/php/DB/pgsql.php') &&
                      ($val['file'] != '/opt/lampp/htdocs/oasis3/siteManager/lib/smModules.inc') &&
                      ($val['file'] != '/opt/lampp/htdocs/oasis3/home/index.php') ) {

                      $errorMessage .= '['.$key.'] fname:'.$val['file'].', line:'.$val['line'].', func:'.$val['function'].', class:'.$val['class'].$nl;
                }
            }
            if ($usedie == 1) {
                die($errorMessage);
            }
            else {
                return $errorMessage;
            }
        }

        return $errorMessage;
    }

  }

  ?>