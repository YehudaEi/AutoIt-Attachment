$PdfForge = ObjCreate("pdfforge.pdf.pdf")
Global $imageFilenames[3]
$imageFilenames[0]=@WorkingDir &"\9677.tiff"
$imageFilenames[1]=@WorkingDir &"\9783.tiff"
$imageFilenames[2]=@WorkingDir &"\9930.tiff"
$PdfForge.Images2PDF_2($imageFilenames, "output.pdf", 1)