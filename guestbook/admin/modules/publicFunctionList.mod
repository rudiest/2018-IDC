<?php

class publicFunctionList extends SM_module {
     
     function moduleConfig() {

        // * Directives
        $this->addInVar('rNum',0);
        $this->addInVar('rNum2',0);
        $this->addInVar('rNum3','');
        $this->addInVar('rNum4','');
        
        $this->addInVar('option','');    
        $this->addInVar('sType','');     
        $this->addInVar('popMode','');   
        $this->addInVar('fsg2',0);       
        $this->addInVar('sg2m',0);       
        $this->addInVar('wSQL',0);       
    }

    function moduleThink() {
	    
		// this module intended to used by directly calling below function
    
    }
    
    function genQuickLinksDefault() {
	    
	    $newsHTMLTable   = '<tr>
							  <td align="left" valign="top" width="15%" style="padding:10px" bgcolor="#F3F3F3">
							    <img src="./images/web/quicklink_dummy_1.jpg" height="111" width="80" border="0"></a>
							  </td>
							  <td align="left" valign="top" style="padding:10px; padding-right:20px;" bgcolor="#F3F3F3">
							    <a class="newsShortDesc">Fakultas Kesehatan<BR>Menawarkan 7 jurusan yang dapat diambil</a>
							  </td>
							</tr>
							<tr>
							  <td align="center" valign="middle" colspan="2" bgcolor="#F6ECE2">&nbsp;</td>
							</tr>
							
							<tr>
							  <td align="left" valign="top" width="15%" style="padding:10px" bgcolor="#F3F3F3">
							    <img src="./images/web/quicklink_dummy_2.jpg" height="111" width="80" border="0"></a>
							  </td>
							  <td align="left" valign="top" style="padding:10px; padding-right:20px;" bgcolor="#F3F3F3">
							    <a class="newsShortDesc">Seputar Kota Kediri<BR>Jelajahi tempat menarik di sekitar kota Kediri</a>
							  </td>
							</tr>
							<tr>
							  <td align="center" valign="middle" colspan="2" bgcolor="#F6ECE2">&nbsp;</td>
							</tr>
							
							<tr>
							  <td align="left" valign="top" width="15%" style="padding:10px" bgcolor="#F3F3F3">
							    <img src="./images/web/quicklink_dummy_3.jpg" height="111" width="80" border="0"></a>
							  </td>
							  <td align="left" valign="top" style="padding:10px; padding-right:20px;" bgcolor="#F3F3F3">
							    <a class="newsShortDesc">Fasilitas Kampus<BR>Kampus IIK campus memiliki beragam fasilitas untuk menunjang pembelajaran</a>
							  </td>
							</tr>
							<tr>
							  <td align="center" valign="middle" colspan="2" bgcolor="#F6ECE2">&nbsp;</td>
							</tr>
							
							<tr>
							  <td align="left" valign="top" width="15%" style="padding:10px" bgcolor="#F3F3F3">
							    <img src="./images/web/quicklink_dummy_4.jpg" height="111" width="80" border="0"></a>
							  </td>
							  <td align="left" valign="top" style="padding:10px; padding-right:20px;" bgcolor="#F3F3F3">
							    <a class="newsShortDesc">Karir Mahasiswa<BR>IIK mendorong para mahasiswanya untuk mengejar jenjang karir</a>
							  </td>
							</tr>
							<tr>
							  <td align="center" valign="middle" colspan="2" bgcolor="#F6ECE2">&nbsp;</td>
							</tr>
							';
							
		return $newsHTMLTable;
    }
    
    function genQuickLinksRandomEvent() {
	    
	   $newsHTMLTable = '';
	   $newsHTMLTable .= '  <tr>
	   							<td align="left" valign="middle" colspan="2" bgcolor="#F6ECE2">
	   							&nbsp; <font color="#B26C1D"><B>+</B> Tautan Cepat</font></td>
	   						</tr>';
	   $newsHTMLTable .= '  <tr>
							  <td align="left" valign="top" width="15%" style="padding:7px"><a href="./indexin.php?opt=brochure&bid=1" target="_self"><img style="border:1px solid black;" src="./images/web/brochure_jpm_tautan.jpg" width="50"></a></td>
							  <td align="left" valign="top" style="padding:5px; padding-right:20px;">
							  <B><a href="./indexin.php?opt=brochure&bid=1" target="_self">Brosur JPM</a></B>
							  </td>
							</tr>
							<tr>
							  <td align="left" valign="top" width="15%" style="padding:7px"><a href="./indexin.php?opt=brochure&bid=0" target="_self"><img style="border:1px solid black;" src="./images/web/brochure_jpt_tautan.jpg" width="50"></a></td>
							  <td align="left" valign="top" style="padding:5px; padding-right:20px;">
							  <B><a href="./indexin.php?opt=brochure&bid=0" target="_self">Brosur JPT</a></B>
							  </td>
							</tr>
	   						<tr>
							  <td align="left" valign="top" width="15%" style="padding:7px"><a href="./indexin.php?opt=facilIN" target="_self"><img style="border:1px solid black;" src="./images/web/quicklink_dummy_3.jpg" width="50"></a></td>
							  <td align="left" valign="top" style="padding:5px; padding-right:20px;">
							  <B><a href="./indexin.php?opt=facilIN" target="_self">Fasilitas Kampus</a></B>
							  </td>
							</tr>
							<tr>
							  <td align="left" valign="top" width="15%" style="padding:7px"><a href="./indexin.php?opt=facilIN" target="_self"><img style="border:1px solid black;" src="./images/web/quicklink_dummy_2.jpg" width="50"></a></td>
							  <td align="left" valign="top" style="padding:5px; padding-right:20px;">
							  <B><a href="./indexin.php?opt=artIN&bl=3&rm=3&sm=0&id=156" target="_self">Seputar Kota Kediri</a></B>
							  </td>
							</tr>
							<tr>
							  <td align="center" valign="middle" colspan="2" bgcolor="#F6ECE2">&nbsp;</td>
							</tr>';
							
	   $SQL = " select *, date_format(artcle_start_date,'%e %b %Y') as artcle_tanggal from article where artcle_type in (1) order by artcle_start_date desc, artcle_end_date desc limit 3 ";
	   $rh2 = $this->dbH->query($SQL); 
	   $newsHTMLTable .= '  <tr>
	   							<td align="left" valign="middle" colspan="2" bgcolor="#F6ECE2">
	   							<B>&nbsp; <font color="#B26C1D">+</font> <a href="./indexin.php?opt=listIN&bl=3&rm=3&sm=0&sType=listnews&flag=1" target="_self">Berita Terbaru</a></B></td>
	   						</tr>';
	   while ($rr2 = $rh2->fetch()) {
	       
	       $imageThumbnail = '';
	       if ((strlen(trim($rr2['artcle_img_thumbnail'])) > 0) && (file_exists($rr2['artcle_img_thumbnail']))) {
	   	     
	   	     $imageThumbnail = $rr2['artcle_img_thumbnail'];
	       }
	       else {
	   	     
	   	     $imageThumbnail = './images/web/thumbnail_nopic.jpg';
	       }
	       
	       $newsHTMLTable .= '  <tr>
								  <td align="left" valign="top" width="15%" style="padding:7px"><a href="./indexin.php?opt=artIN&bl=3&rm=3&sm=0&id='.$rr2['artcle_id'].'"><img style="border:1px solid black;" src="'.$imageThumbnail.'" width="50"></a></td>
								  <td align="left" valign="top" style="padding:5px; padding-right:20px;">
								  <a href="http://www.iik.ac.id/webv2/home/indexin.php?opt=artIN&bl=3&rm=3&sm=0&id='.$rr2['artcle_id'].'">'.$rr2['artcle_full_title'].'</a>
								  </td>
								</tr>
								<tr>
								  <td align="center" valign="middle" colspan="2" bgcolor="#F6ECE2"></td>
								</tr>
								';
								
		}
		
		$newsHTMLTable .= '<tr>
							  <td align="center" valign="middle" colspan="2" bgcolor="#F6ECE2">&nbsp;</td>
							</tr>';
							
	   $SQL = " select *, date_format(artcle_start_date,'%e %b %Y') as artcle_tanggal from article where artcle_type in (9) order by artcle_start_date desc, artcle_end_date desc limit 3 ";
	   $rh2 = $this->dbH->query($SQL); 
	   $newsHTMLTable .= '  <tr>
	   							<td align="left" valign="middle" colspan="2" bgcolor="#F6ECE2">
	   							<B>&nbsp; <font color="#B26C1D">+</font> <a href="./indexin.php?opt=listIN&bl=3&rm=3&sm=0&sType=listagenda&flag=1" target="_self">Agenda</a></B></td>
	   						</tr>';
	   while ($rr2 = $rh2->fetch()) {
	       
	       $imageThumbnail = '';
	       if ((strlen(trim($rr2['artcle_img_thumbnail'])) > 0) && (file_exists($rr2['artcle_img_thumbnail']))) {
	   	     
	   	     $imageThumbnail = $rr2['artcle_img_thumbnail'];
	       }
	       else {
	   	     
	   	     $imageThumbnail = './images/web/thumbnail_nopic.jpg';
	       }
	       
	       $newsHTMLTable .= '  <tr>
								  <td align="left" valign="top" width="15%" style="padding:7px"><a href="./indexin.php?opt=artIN&bl=3&rm=3&sm=0&id='.$rr2['artcle_id'].'"><img style="border:1px solid black;" src="'.$imageThumbnail.'" width="50"></a></td>
								  <td align="left" valign="top" style="padding:5px; padding-right:20px;">
								  <a href="http://www.iik.ac.id/webv2/home/indexin.php?opt=artIN&bl=3&rm=3&sm=0&id='.$rr2['artcle_id'].'">'.$rr2['artcle_full_title'].'</a>
								  </td>
								</tr>
								<tr>
								  <td align="center" valign="middle" colspan="2" bgcolor="#F6ECE2"></td>
								</tr>
								';
								
		}
	   /*$newsHTMLTable .= '<tr>
							  <td align="center" valign="middle" colspan="2" bgcolor="#F6ECE2">&nbsp;</td>
							</tr>
							<tr>
	   							<td align="left" valign="middle" colspan="2" bgcolor="#F6ECE2">
	   							<B>&nbsp; <font color="#B26C1D">+</font> <a href="./indexin.php?opt=facilIN" target="_self">Fasilitas Kampus</a></B></td>
	   						</tr>
	   						<tr>
							  <td align="center" valign="middle" colspan="2" bgcolor="#F6ECE2">&nbsp;</td>
							</tr>
							<tr>
	   							<td align="left" valign="middle" colspan="2" bgcolor="#F6ECE2">
	   							<B>&nbsp; <font color="#B26C1D">+</font> <a href="./indexin.php?opt=artIN&bl=3&rm=3&sm=0&id=156" target="_self">Seputar Kota Kediri</a></B></td>
	   						</tr>
							';*/
	  					           
	   
																						
	   $newsHTMLTable .= '<tr>
							  <td align="center" valign="middle" colspan="2" bgcolor="#F6ECE2">&nbsp;</td>
							</tr>
							<tr>
	   							<td align="left" valign="middle" colspan="2" bgcolor="#F6ECE2">
	   							<B>&nbsp; <font color="#B26C1D">+</font> <a>Facebook</a></B></td>
	   						</tr>
	   						<td align="center" valign="middle" colspan="2" bgcolor="#F6ECE2">
	   							<!--<div class="fb-activity" data-site="http://www.iik.ac.id" data-width="170" data-height="300" data-header="true" data-linktarget="_top" data-font="arial" data-recommendations="true"></div>-->
	   							<fb:activity site="www.iik.ac.id" width="170" height="300" font="arial" border_color="#F6ECE2" recommendations="true" header="false" border="white" ref="sidebar"></fb:activity>
	   						</td>
	   					  </tr>	';	   
	   
		return $newsHTMLTable;
    }
    
    function genQuickLinksDekan($idfakultas = 0) {
	    
	   $id_artikel_dekan = 0;
	   switch($idfakultas) {
	
		   case 2  : $id_artikel_dekan = 103; break;
		   
		   default : $id_artikel_dekan = 0; break;
	   }
	   
	   $SQL = " select *, date_format(artcle_start_date,'%e %b %Y') as artcle_tanggal from article where artcle_id = ".$id_artikel_dekan;
	   $rh2 = $this->dbH->query($SQL); 
	   $rr2 = $rh2->fetch();
	   
	   $newsHTMLTable = '';
	   if ($rr2['artcle_id'] > 0) {
		   
		   $imageThumbnail = '';
	       if ((strlen(trim($rr2['artcle_img_thumbnail2'])) > 0) && (file_exists($rr2['artcle_img_thumbnail2']))) {
	   	     
	   	     $imageThumbnail = $rr2['artcle_img_thumbnail2'];
	       }
	       else {
	   	     
	   	     $imageThumbnail = './images/web/thumbnail_nopic.jpg';
	       }
	       
	       $newsHTMLTable .= '  <tr>
								  <td align="right" valign="middle" colspan="2" style="padding-right:30px; pading-bottom:20px;"><a href="./indexin.php?opt=artIN&id='.$rr2['artcle_id'].'"><img src="'.$imageThumbnail.'"></a></td>
								</tr>
								<tr>
								  <td align="right" valign="middle" colspan="2" style="padding-right:30px; pading-bottom:20px;">&nbsp;</td>
								</tr>
								<tr>
								  <td align="right" valign="middle" colspan="2" style="padding-right:30px; pading-top:20px;" >'.$rr2['artcle_full_title'].'<BR>'.$rr2['artcle_short_desc'].'</td>
								</tr>
								';
	   }
	     
	   return $newsHTMLTable;
    }
    
    
    
}


?>
