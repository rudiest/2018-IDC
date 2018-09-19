<?php

class guest_inquery_rak extends SM_module {

    function moduleConfig() {



    }

    function moduleThink() {

	    $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $mobileHtml = '';

        /*
        if ($_GET['id'] > 0) {

	        $mobileHtml = $this->inquery($_GET['id']);
        }
        */

        if (strlen(trim($_GET['id']))>0) {
	        $SQL = " select * from ref_aset_lokasi where astlok_refercode = '".$_GET['id']."' ";
	        $rh  = $this->dbH->query($SQL);
	        $functDB->dberror_show($rh);
	        $rr = $rh->fetch();
	        if (($rr['loc_id'] > 0) && ($rr['astlok_refercode'] == $_GET['id'])) {
		        $mobileHtml = $this->inquery($rr['loc_id']);
	        }
	        else {
		        $mobileHtml = 'Error! misslink ID';
	        }
        }
        else {
	        $mobileHtml = 'Error! misslink ID';
        }

        $this->say($mobileHtml);

    }

    function inquery($id = 0) {

	    $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $html = '';

        $SQL = " select ref_aset_lokasi.*,
        		 	    jnsloc_label,
        		 	    jnsloc_kode
                 from   ref_aset_lokasi
                  		  left join ref_lokasi_jenis on jnsloc_id = loc_id_jenislokasi
        		 where  loc_id = '".$id."'
        		 ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);
        $rr = $rh->fetch();

		$html .= '

		<div data-role="view" id="tabstrip-rak" data-title="SISTEM INVENTARIS DATACENTER KOMINFO" data-layout="mobile-tabstrip">
		<ul data-role="listview" data-style="inset" data-type="group">
        <li><B>'.$rr['loc_label'].'</B>
          <ul>

        ';

        $SQL2 = "select ref_aset.*,
        		 	    ast_id as id,
                        case when ref_aset.ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                        astgrp_label,
                        astgrp_kode,
                        astgrp_desc,
                        pngjwb_label,
                        pngjwb_kode,
                        pngjwb_telp,
                        pngjwb_email,
                        (select loc_label from ref_aset_lokasi, trx_lokasi where loc_id = trxloc_id_lokasi_baru and trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1) as infolokasi
                  from  ref_aset
                  		  left join ref_aset_grup on astgrp_id = ast_id_grupaset
                  		  left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
        		 where  ast_id in (
        		 	select  a.trxloc_id_aset
        		 	from    trx_lokasi a
        		 	where   a.trxloc_id_lokasi_baru = '".$id."' and
        		 	        a.trxloc_id_aset not in (
        		 	          select  b.trxloc_id_aset
        		 	          from    trx_lokasi b
        		 	          where   b.trxloc_id_lokasi_baru <> '".$id."' and
        		 	                  ( (b.trxloc_tanggal = a.trxloc_tanggal and
        		 	                     b.trxloc_waktu > a.trxloc_waktu) or
        		 	                    (b.trxloc_tanggal > a.trxloc_tanggal)
        		 	                    )
        		 	        )
        		 )
        		 ";
        $rh2  = $this->dbH->query($SQL2);
        $functDB->dberror_show($rh2);
        while ($rr2 = $rh2->fetch()) {

	        $html .= '<li><a href="inq.php?id='.$rr2['ast_refercode'].'" data-rel="external"><span><b>[ '.$rr2['astgrp_label'].' ]</b> <i>'.$rr2['ast_label'].'</i><BR>No.BMN: '.$rr2['ast_kode_bmn'].'</span></a></li>';
        }

        $html .= '

          </ul>
        </li>
        </ul>
		</div>

		<div data-role="layout" data-id="mobile-tabstrip">
		 <header data-role="header">
		   <div data-role="navbar">
		     <span data-role="view-title"></span>
		   </div>
		 </header>

		</div>

		';

	    return $html;

    }

}


?>
