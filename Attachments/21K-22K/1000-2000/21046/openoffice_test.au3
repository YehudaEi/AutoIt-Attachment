;
; testing OPEN Office writer -> read , write , export Documents
; nobbe 2008
;
; - added a batch converter 
;

;
; forum
; http://www.oooforum.org/forum/viewtopic.phtml?p=73715&highlight=filters#73715

; sun programming manual for basic http://docs.sun.com/app/docs/doc/819-1326?l=de
;
;


#include <Array.au3>

; info on opening
; http://udk.openoffice.org/common/man/tutorial/office_automation.html

Global $OO_ServiceManager, $OO_Desktop, $OO_Doc

; init generally - this is for writer now only, needs to be changed for calc
_OO_INIT();

; open file 1
$f = @ScriptDir & "\test.doc";
_OO_LOADFILE($f);
_OO_GET_TEXT();

$f_out = @ScriptDir & "\test.pdf";
_OO_SAVEFILE($f_out, "PDF", 0)

; ---

; open file 2
$f = @ScriptDir & "\test1.doc";
_OO_LOADFILE($f);
$f_out = @ScriptDir & "\test1.pdf";
_OO_SAVEFILE($f_out, "PDF", 0)

; open file
$f = @ScriptDir & "\test2.doc";
_OO_LOADFILE($f);
_OO_GET_TEXT();

;;_OO_PRINTFILE("1-2");

$f_out = @ScriptDir & "\test_2.pdf";
_OO_SAVEFILE($f_out, "PDF", 0)


; ---

; open file
$f = @ScriptDir & "\test1.doc";
_OO_LOADFILE($f);
$f_out = @ScriptDir & "\test1.htm";
_OO_SAVEFILE($f_out, "HTML", 0)

#cs
	; open HTTP website and save as PDF too
	$f = "http://wiki.services.openoffice.org/wiki/Framework/Article/Filter/FilterList_OOo_2_1";
	$f = "http://www.google.com";
	_OO_LOADFILE($f);
	$f_out = @ScriptDir & "\web1.pdf";
	_OO_SAVEFILE($f_out, "PDF", "WEB") ; need the web PDF exporter now..
#ce


; open BLANK File and write some text to it
_OO_LOADFILE("BLANK");
_OO_WRITETEXT("This is a test " & @CRLF & _
		"write all into a new blank Staroffice Writer File" & _
		"testing OPEN Office writer -> PDF Converter " & _
		"with AUTOIT - " & _
		"actually this is really easy to do!! " & @CRLF & _
		"by nobbe 2008" & @CRLF);

_OO_WRITETEXT("Some more text  " & @CRLF);

$f_out = @ScriptDir & "\test3.pdf";
_OO_SAVEFILE($f_out, "PDF", 0)

;
; batch converter ----- 
;
; now get all *.rtf files from /vorlagen directory and convert into PDF files
;
$files_location = @ScriptDir & "\vorlagen\" ;

; Shows the filenames of all files in the directory.
$search = FileFindFirstFile($files_location & "*.rtf")

; Check if the search was successful
If $search = -1 Then
	MsgBox(0, "Error", "No files/directories matched the search pattern")
	Exit
EndIf

; all files
While 1
	$file = FileFindNextFile($search)
	If @error Then ExitLoop

	ConsoleWrite("RTF FILE : " & $files_location & $file & @CRLF)
	
	; open file now
	_OO_LOADFILE($files_location & $file);
	
	$pdf_out = $files_location & $file & ".pdf";
	_OO_SAVEFILE($pdf_out, "PDF", 0)

WEnd
; batch converter ----- 






Exit ;







; init the OO service manager and desktop
Func _OO_INIT()

	$OO_ServiceManager = ObjCreate("com.sun.star.ServiceManager")
	$OO_Desktop = $OO_ServiceManager.createInstance("com.sun.star.frame.Desktop")

	Return;

EndFunc   ;==>_OO_INIT



;
; open file now
;
Func _OO_LOADFILE($infile)

	; input arguments
	Local $inputargs = _ArrayCreate(_MakePropertyValue("Hidden", True));-1

	; works !
	;$inputfile = "http://udk.openoffice.org/common/man/tutorial/office_automation.html"

	; when i want a BLANK file
	If $infile == "BLANK" Then
		$OO_Doc = $OO_Desktop.loadComponentFromURL("private:factory/swriter", "_blank", 0, $inputargs)
	Else
		$infile = _Convert2URL($infile);
		ConsoleWrite($infile & @CRLF);
		$OO_Doc = $OO_Desktop.loadComponentFromURL($infile, "_blank", 0, $inputargs)
	EndIf

	Return
EndFunc   ;==>_OO_LOADFILE


;
; get the text from a writer document
;
Func _OO_GET_TEXT()
	$Enum1 = $OO_Doc.Text.createEnumeration()

	While $Enum1.hasMoreElements()
		
		$TextElement = $Enum1.nextElement()
		ConsoleWrite("element  : " & $TextElement.String() & @CRLF);
		#cs
			If $TextElement.supportsService("com.sun.star.text.Paragraph") Then
			$Enum2 = $TextElement.createEnumeration()
			;CurLine = "<P>"
			
			;' Schleife über alle Absatzteile
			While $Enum2.hasMoreElements()
			$TextPortion = $Enum2.nextElement
			ConsoleWrite ("TextPortion " & $TextPortion.String() & @crlf);
			
			WEnd
			
			EndIf
		#ce
	WEnd


	
EndFunc   ;==>_OO_GET_TEXT


;
; print current document on DEFAULT Printer (funny, can be ADOBE Pdf also)
;
; Pages Value="1-3; 7; 9"
;
Func _OO_PRINTFILE($pages)

	Local $printargs ;

	$printargs = _ArrayCreate(_MakePropertyValue("Pages", $pages));

	$OO_Doc.Print($printargs)
	
EndFunc   ;==>_OO_PRINTFILE




;
; PDF or HTML
; valid filters -- http://wiki.services.openoffice.org/wiki/Framework/Article/Filter/FilterList_OOo_2_1
;
Func _OO_SAVEFILE($outfile, $filter, $web)

	Local $exportargs ;

	;; store now as ??
	If $filter == "PDF" Then
		;; store now as PDF
		
		If $web == "WEB" Then ; needs web PDF export
			$exportargs = _ArrayCreate(_MakePropertyValue("FilterName", "writer_web_pdf_Export"));
		Else
			$exportargs = _ArrayCreate(_MakePropertyValue("FilterName", "writer_pdf_Export"));
		EndIf
	ElseIf $filter == "HTML" Then
		$exportargs = _ArrayCreate(_MakePropertyValue("FilterName", "HTML (StarWriter)"));
	EndIf

	$OO_Doc.storeToURL(_Convert2URL($outfile), $exportargs)

	;FileProperties(0).Name = "Overwrite"
	;FileProperties(0).Value = True
	;Doc.storeAsURL(sUrl, mFileProperties())


	Sleep(500) ; or it will result in a open office "crash "?
	$OO_Doc.close(True);
	
EndFunc   ;==>_OO_SAVEFILE


; write text at "cursor"
;
Func _OO_WRITETEXT($text)
	
	$objText = $OO_Doc.getText();

	$objCursor = $objText.createTextCursor()

	$objCursor.gotoEnd(False); set cursor to end of document

	;Inserting Text
	$objText.insertString($objCursor, $text, False);
EndFunc   ;==>_OO_WRITETEXT


;
;
Func _MakePropertyValue($cName, $uValue)
	Local $Pstruc
	$Pstruc = $OO_ServiceManager.Bridge_GetStruct("com.sun.star.beans.PropertyValue")
	$Pstruc.Name = $cName
	$Pstruc.Value = $uValue ; ($uValue)
	
	; MsgBox(0,"", $Pstruc.Value)
	Return $Pstruc
EndFunc   ;==>_MakePropertyValue


;
; convert to OO name convention
;
Func _Convert2URL($fname)
	
	; no http found ?
	If StringInStr($fname, "http") == 0 Then
		
		$fname = StringReplace($fname, ":", "|")
		$fname = StringReplace($fname, " ", "%20")
		$fname = "file:///" & StringReplace($fname, "\", "/")
	EndIf

	Return $fname
EndFunc   ;==>_Convert2URL
