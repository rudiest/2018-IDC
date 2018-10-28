<?php

require('rotation.php');

define('FPDF_FONTPATH','/opt/lampp/htdocs/lisdev/home/fpdf17/font/');

class PDFLIS extends PDF_Rotate {

	var $watermark;
	var $maintitle = 'Hasil Pemeriksaan Laboratorium';

	// Page header
	function Header()
	{
	    // Logo
	    $this->Image('./images/logo_aricanti.png',5,5,53);

	    $this->SetFont('arial','B',15);

	    $this->setXY(60,5);
	    $this->Cell(146,8,$this->maintitle,0,0,'L');
	    $this->ln();

	    $this->SetFont('arial','',10);
	    $this->setX(60);
	    $this->Cell(146,5,'Jl. Raya Mas Ubud Gianyar, Telp/fax: 0361 974 573',0,0,'L');
	    $this->ln();

	    $this->setX(60);
	    $this->Cell(146,5,'Konsultan dr. I.G.N. Sumardika Sp.PK',0,0,'L');
	    $this->ln();

	    $this->setX(60);
	    $this->Cell(146,5,'',0,0,'L');
	    $this->ln();

	}

	function RotatedText($x, $y, $txt, $angle) 	{
	    //Text rotated around its origin
	    $this->Rotate($angle,$x,$y);
	    $this->Text($x,$y,$txt);
	    $this->Rotate(0);
	}

	// Page footer
	function Footer()
	{
	    // Position at 1.5 cm from bottom
	    $this->SetY(-15);
	    $this->SetFont('arial','',10);
	    $this->Cell(0,10,'Halaman '.$this->PageNo().' dari {nb}',0,0,'C');

	    if (strlen(trim($this->watermark))>0) {
		    //Put the watermark
    		$this->SetFont('Arial','B',50);
    		$this->SetTextColor(255,192,203);
    		$this->RotatedText(35,190,$this->watermark,45);
	    }

	}

}

?>