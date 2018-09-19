<?php

class guest_inquery extends SM_module {

    function moduleConfig() {



    }

    function moduleThink() {

        $member =  $this->sessionH->getMemberData();
        $functDB =& $this->loadModule('functionDB');

        $mobileHtml = '';

        /*
        if ($_GET['id'] > 0) {

        }
        */

        if (strlen(trim($_GET['id']))>0) {
	        $SQL = " select * from ref_aset where ast_refercode = '".$_GET['id']."' ";
	        $rh  = $this->dbH->query($SQL);
	        $functDB->dberror_show($rh);
	        $rr = $rh->fetch();
	        if (($rr['ast_id'] > 0) && ($rr['ast_refercode'] == $_GET['id'])) {
		        $mobileHtml = $this->inquery($rr['ast_id']);
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

        $SQL = " select *,
        		 	    ast_id as id,
                        case when ref_aset.ref_stat_visible = 1 then 'Tampil' else 'Disembunyikan' end as status_visible,
                        astgrp_label,
                        astgrp_kode,
                        astgrp_desc,
                        pngjwb_label,
                        pngjwb_kode,
                        pngjwb_telp,
                        pngjwb_email,
                        (select loc_label from ref_aset_lokasi, trx_lokasi where loc_id = trxloc_id_lokasi_baru and trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1) as infolokasi,
                        (select astlok_refercode from ref_aset_lokasi, trx_lokasi where loc_id = trxloc_id_lokasi_baru and trxloc_id_aset = ast_id order by trxloc_tanggal desc, trxloc_waktu desc limit 1) as idlokasi
                  from  ref_aset
                  		  left join ref_aset_grup on astgrp_id = ast_id_grupaset
                  		  left join ref_penanggungjawab on pngjwb_id = ast_id_pngjawab
        		 where  ast_id = '".$id."'
        		 ";
        $rh  = $this->dbH->query($SQL);
        $functDB->dberror_show($rh);
        $rr = $rh->fetch();

		$html .= '

		<div data-role="view" id="tabstrip-profile" data-title="SISTEM INVENTARIS DATACENTER KOMINFO" data-layout="mobile-tabstrip">
		<ul data-role="listview" data-style="inset" data-type="group">
        <li>Informasi Aset
          <ul>
            <li><B>'.$rr['ast_label'].'</B></li>
            <li><i>Kode BMN</i><BR>'.$rr['ast_kode_bmn'].'</li>
            <li><i>Jenis Aset</i><BR>'.$rr['astgrp_label'].'</li>
            <li><a href="inq2.php?id='.$rr['idlokasi'].'" data-rel="external"><span><i>Lokasi Terakhir</i><BR>'.$rr['infolokasi'].'</span></a></li>
            <li><i>Penanggung Jawab</i><BR>'.$rr['pngjwb_label'].'</li>
            <li><i>Telepon</i><BR>'.$rr['pngjwb_telp'].'</li>
            <li><i>E-mail</i><BR>'.$rr['pngjwb_email'].'</li>
          </ul>
        </li>
        </ul>
		</div>

		<div data-role="view" id="tabstrip-spek" data-title="SISTEM INVENTARIS DATACENTER KOMINFO" data-layout="mobile-tabstrip">
		<ul data-role="listview" data-style="inset" data-type="group">
        <li>Spesifikasi Aset
          <ul>
            <li><B>'.$rr['ast_label'].'</B></li>';

        $SQL2 = "select astspk_id as id,
	    		 		astspk_id,
	    		 		astgrpspek_label,
                        astspk_value_text,
                        astgrpspek_satuan,
                        astgrpspek_keterangan
                 from   ref_aset_spesifikasi
                          left join ref_aset_grup_spek on astgrpspek_id = astspk_id_grup_spek
                 where  astspk_id_aset = '".$id."'
                 order by astgrpspek_urutan, astgrpspek_label
        		 ";
        $rh2 = $this->dbH->query($SQL2);
        $functDB->dberror_show($rh2);
        while ($rr2 = $rh2->fetch()) {
	        $html .= '<li><i>'.$rr2['astgrpspek_label'].'</i><BR>'.$rr2['astspk_value_text'].'</li>';
        }

        $html .= '

          </ul>
        </li>
        </ul>
		</div>

		<div data-role="view" id="tabstrip-lokasi" data-title="SISTEM INVENTARIS DATACENTER KOMINFO" data-layout="mobile-tabstrip">
		<ul data-role="listview" data-style="inset" data-type="group">
        <li>Catatan Pemindahan Lokasi Aset
          <ul>
            <li><B>'.$rr['ast_label'].'</B></li>';

        $SQL3 = "select   trx_lokasi.*,
                          date_format(trxloc_tanggal,'%e %b %Y') as tgl_pindah,
                          date_format(trxloc_waktu,'%k:%i') as jam_pindah,
                          trxloc_id as id,
                          (select loc_label from ref_aset_lokasi where loc_id = trxloc_id_lokasi_sebelumnya) as loksebelum,
                          (select loc_label from ref_aset_lokasi where loc_id = trxloc_id_lokasi_baru) as loksesudah
                 from     trx_lokasi
                 where    trxloc_id_aset = '".$id."'
                 order by trxloc_tanggal desc, trxloc_waktu desc
        		 ";
        $rh3 = $this->dbH->query($SQL3);
        $functDB->dberror_show($rh3);
        while ($rr3 = $rh3->fetch()) {
	        $html .= '<li>Tanggal '.$rr3['tgl_pindah'].' '.$rr3['jam_pindah'].'<BR>'.$rr3['loksesudah'].'</li>';
        }

        $html .= '

          </ul>
        </li>
        </ul>
		</div>

		<div data-role="view" id="tabstrip-kejadian" data-title="SISTEM INVENTARIS DATACENTER KOMINFO" data-layout="mobile-tabstrip">
		<ul data-role="listview" data-style="inset" data-type="group">
        <li>Laporan Kejadian
          <ul>
            <li><B>'.$rr['ast_label'].'</B></li>';

        $SQL4 = " select   trx_kejadian.*,
                           trxkej_id as id,
                           date_format(trxkej_tanggal,'%e %b %Y') as tgl_kejadian,
                           date_format(trxkej_waktu,'%k:%i') as jam_kejadian,
                           jnskej_label
                  from     trx_kejadian
                  			 left join ref_kejadian_jenis on jnskej_id = trxkej_id_kej
                  where    trxkej_id_aset = '".$id."'
                  order by trxkej_tanggal desc, trxkej_waktu desc
        		 ";
        $rh4 = $this->dbH->query($SQL4);
        $functDB->dberror_show($rh4);
        while ($rr4 = $rh4->fetch()) {
	        $html .= '<li>Tanggal '.$rr4['tgl_kejadian'].' '.$rr4['jam_kejadian'].'<BR>'.$rr4['jnskej_label'].'<BR>'.$rr4['trxkej_keterangan'].'</li>';
        }

        $html .= '

          </ul>
        </li>
        </ul>
		</div>

		<div data-role="view" id="tabstrip-perubahan" data-title="SISTEM INVENTARIS DATACENTER KOMINFO" data-layout="mobile-tabstrip">
		<ul data-role="listview" data-style="inset" data-type="group">
        <li>Perubahan Spesifikasi Aset
          <ul>
            <li><B>'.$rr['ast_label'].'</B></li>';

        $SQL5 = " select   *,
                           logubah_id as id,
                           date_format(logubah_tanggal,'%e %b %Y') as tgl_kejadian,
                           date_format(logubah_waktu,'%k:%i') as jam_kejadian
                  from     log_perubahan
                  where    logubah_id_aset = '".$id."'
                  order by logubah_tanggal desc, logubah_waktu desc
        		 ";
        $rh5 = $this->dbH->query($SQL5);
        $functDB->dberror_show($rh5);
        while ($rr5 = $rh5->fetch()) {
	        $html .= '<li>Tanggal '.$rr5['tgl_kejadian'].' '.$rr5['jam_kejadian'].'<BR>'.$rr5['logubah_catatan'].'</li>';
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

		 <p>TabStrip</p>

		 <div data-role="footer">
		  <div data-role="tabstrip">
		   <a href="#tabstrip-profile" data-icon="info">Profile
		   </a><a href="#tabstrip-spek" data-icon="settings">Spesifikasi
		   </a><a href="#tabstrip-lokasi" data-icon="globe">Lokasi
		   </a><a href="#tabstrip-kejadian" data-icon="mostviewed">Kejadian
		   </a><a href="#tabstrip-perubahan" data-icon="history">Perubahan</a>
		  </div>
		 </div>
		</div>

		';

	    return $html;

    }

}


?>
