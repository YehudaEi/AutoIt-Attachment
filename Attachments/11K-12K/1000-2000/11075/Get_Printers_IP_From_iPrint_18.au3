#include <IE.au3>
#include <Array.au3>

Dim $ippPage1 = "                                       "
Dim $ippPage2 = "                                       "
Dim $ippPage3 = "                                       "

;the following 4 vars set up the IE windows that contain the printer IPP addresses (3 are hidden, 1 is not)
Dim $oIE1 = _IECreate ($ippPage1, 0, 0, 1, -1)
Dim $oIE2 = _IECreate ($ippPage2, 0, 0, 1, -1)
Dim $oIE3 = _IECreate ($ippPage3, 0, 0, 1, -1)
Dim $oIE4 = _IECreate()

;these 3 vars should collect all the links that are on each of the printer pages
Dim $oLinks1 = _IELinkGetCollection($oIE1)
Dim $oLinks2 = _IELinkGetCollection($oIE2)
Dim $oLinks3 = _IELinkGetCollection($oIE3)

;variables used to control the HTML output

Dim $level1Counter = 0
Dim $level2Counter = 0
Dim $level3Counter = 0
Dim $level4Counter = 0
Dim $level5Counter = 0
Dim $level6Counter = 0
Dim $level7Counter = 0
Dim $level8Counter = 0
Dim $level9Counter = 0
Dim $level10Counter = 0
Dim $level11Counter = 0
Dim $level12Counter = 0
Dim $level13Counter = 0
Dim $level14Counter = 0
Dim $level15Counter = 0
Dim $level16Counter = 0
Dim $level17Counter = 0
Dim $level18Counter = 0
Dim $level19Counter = 0
Dim $level20Counter = 0
Dim $level21Counter = 0
Dim $level22Counter = 0
Dim $level23Counter = 0
Dim $level24Counter = 0
Dim $miscCounter = 0

Dim $totalCounter = 0


Dim $others = ""

Dim $lev1Array[1]
Dim $lev2Array[1]
Dim $lev3Array[1]
Dim $lev4Array[1]
Dim $lev5Array[1]
Dim $lev6Array[1]
Dim $lev7Array[1]
Dim $lev8Array[1]
Dim $lev9Array[1]
Dim $lev10Array[1]
Dim $lev11Array[1]
Dim $lev12Array[1]
Dim $lev13Array[1]
Dim $lev14Array[1]
Dim $lev15Array[1]
Dim $lev16Array[1]
Dim $lev17Array[1]
Dim $lev18Array[1]
Dim $lev19Array[1]
Dim $lev20Array[1]
Dim $lev21Array[1]
Dim $lev22Array[1]
Dim $lev23Array[1]
Dim $lev24Array[1]
Dim $miscArray[1]



;sets up the basic HTML content that will be used written to the webpage
$sHTML = ''
$sHTML &= '<HTML>' & @CRLF
$sHTML &= '<HEAD>' & @CRLF
$sHTML &= '<TITLE>Test Page With the Printers</TITLE>' & @CRLF
$sHTML &= '<link rel="stylesheet" type="text/css" href="mystyle.css" />' & @CRLF
$sHTML &= '</HEAD>' & @CRLF
$sHTML &= @CRLF
$sHTML &= "<BODY>" & @CRLF
$sHTML &= '<H1>McKell Printers</H1>' & @CRLF

;creates a for that checks each thingy in $oLinks1 if it matches the stringinstr function then adds it to the html content
For $oLink In $oLinks1
	Local $leftchr = StringLeft($oLink.outerText, 2)
	Local $serverIP = "                           "	
		Select 
		Case $leftchr = "01"
			_ArrayAdd($lev1Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "02"
			_ArrayAdd($lev2Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "03"
			_ArrayAdd($lev3Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "04"
			_ArrayAdd($lev4Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "05"
			_ArrayAdd($lev5Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "06"
			_ArrayAdd($lev6Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "07"
			_ArrayAdd($lev7Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "08"
			_ArrayAdd($lev8Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "09"
			_ArrayAdd($lev9Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "10"
			_ArrayAdd($lev10Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "11"
			_ArrayAdd($lev11Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "12"
			_ArrayAdd($lev12Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "13"
			_ArrayAdd($lev13Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "14"
			_ArrayAdd($lev14Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "15"
			_ArrayAdd($lev15Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "16"
			_ArrayAdd($lev16Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "17"
			_ArrayAdd($lev17Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
						
		Case $leftchr = "18"
			_ArrayAdd($lev18Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "19"
			_ArrayAdd($lev19Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "20"
			_ArrayAdd($lev20Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "21"
			_ArrayAdd($lev21Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "22"
			_ArrayAdd($lev22Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "23"
			_ArrayAdd($lev23Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "24"
			_ArrayAdd($lev24Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
						
		Case Else
			If StringInStr($oLink.href, "                                                         ") Then
				_ArrayAdd($miscArray, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			EndIf
	EndSelect
Next
;check above comments pretty much the same for this loop
For $oLink In $oLinks2
	Local $leftchr = StringLeft($oLink.outerText, 2)
	Local $serverIP = "                           "
		Select 
		Case $leftchr = "01"
			_ArrayAdd($lev1Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "02"
			_ArrayAdd($lev2Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "03"
			_ArrayAdd($lev3Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "04"
			_ArrayAdd($lev4Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "05"
			_ArrayAdd($lev5Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "06"
			_ArrayAdd($lev6Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "07"
			_ArrayAdd($lev7Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "08"
			_ArrayAdd($lev8Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "09"
			_ArrayAdd($lev9Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "10"
			_ArrayAdd($lev10Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "11"
			_ArrayAdd($lev11Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "12"
			_ArrayAdd($lev12Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "13"
			_ArrayAdd($lev13Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "14"
			_ArrayAdd($lev14Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "15"
			_ArrayAdd($lev15Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "16"
			_ArrayAdd($lev16Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "17"
			_ArrayAdd($lev17Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
						
		Case $leftchr = "18"
			_ArrayAdd($lev18Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "19"
			_ArrayAdd($lev19Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "20"
			_ArrayAdd($lev20Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "21"
			_ArrayAdd($lev21Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "22"
			_ArrayAdd($lev22Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "23"
			_ArrayAdd($lev23Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "24"
			_ArrayAdd($lev24Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
		Case Else
		;	If StringInStr($oLink.href, "                                                         ") Then
				
		;	EndIf
	EndSelect
Next
;check above comments pretty much the same for this loop
For $oLink In $oLinks3
	Local $leftchr = StringLeft($oLink.outerText, 2)
	Local $serverIP = "                           "
		Select 
		Case $leftchr = "01"
			_ArrayAdd($lev1Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "02"
			_ArrayAdd($lev2Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "03"
			_ArrayAdd($lev3Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "04"
			_ArrayAdd($lev4Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "05"
			_ArrayAdd($lev5Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "06"
			_ArrayAdd($lev6Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "07"
			_ArrayAdd($lev7Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "08"
			_ArrayAdd($lev8Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "09"
			_ArrayAdd($lev9Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "10"
			_ArrayAdd($lev10Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "11"
			_ArrayAdd($lev11Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "12"
			_ArrayAdd($lev12Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "13"
			_ArrayAdd($lev13Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "14"
			_ArrayAdd($lev14Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "15"
			_ArrayAdd($lev15Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "16"
			_ArrayAdd($lev16Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "17"
			_ArrayAdd($lev17Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
						
		Case $leftchr = "18"
			_ArrayAdd($lev18Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "19"
			_ArrayAdd($lev19Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "20"
			_ArrayAdd($lev20Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "21"
			_ArrayAdd($lev21Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "22"
			_ArrayAdd($lev22Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "23"
			_ArrayAdd($lev23Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
			
		Case $leftchr = "24"
			_ArrayAdd($lev24Array, '<TR><TD width="40%"><A href="' & $oLink.href & '"><IMG src="iprint.gif" border=0>' & $oLink.outerText & '</A></TD><TD align="right"><A href="' & $serverIP & $oLink.outerText & '" target=_blank><IMG src="info2.gif" border=0></A></TD></TR>' & @CRLF)
		Case Else
		;	If StringInStr($oLink.href, "                                                         ") Then
			
		;	EndIf
	EndSelect
Next

;closes the IE object things
_IEQuit($oIE1)
_IEQuit($oIE2)
_IEQuit($oIE3)


;the closing html

level1()

level2()

level3()

level4()

level5()

level6()

level7()

level8()

level9()

level10()

level11()

level12()

level13()

level14()

level15()

level16()

level17()

level18()

level19()

level20()

level21()

level22()

level23()

level24()

;miscArray()

$sHTML &= "</BODY>" & @CRLF
$sHTML &= "</HTML>"



;??? this writes html code but i think i misunderstood this command in that it writes it directly to the open browser, i gotta figure out how to save it to a htm file, may have to do it as FileWriteLine along with the rest of it?
_IEDocWriteHTML ($oIE4, $sHTML)
_IEAction ($oIE4, "refresh")

Func level1()
		$sHTML &= '<TABLE id="01">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 1</TH>' & @CRLF
		For $element In $lev1Array
			$sHTML &= $element
			$level1Counter = $level1Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
EndFunc

Func level2()
		$sHTML &= '<TABLE id="02">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 2</TH>' & @CRLF
		For $element In $lev2Array
			$sHTML &= $element
			$level2Counter = $level2Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
EndFunc

Func level3()
		$sHTML &= '<TABLE id="03">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 3</TH>' & @CRLF
		For $element In $lev3Array
			$sHTML &= $element
			$level3Counter = $level3Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
EndFunc


Func level4()
		$sHTML &= '<TABLE id="04">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 4</TH>' & @CRLF
		For $element In $lev4Array
			$sHTML &= $element
			$level4Counter = $level4Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
EndFunc

Func level5()
		$sHTML &= '<TABLE id="05">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 5</TH>' & @CRLF
		For $element In $lev5Array
			$sHTML &= $element
			$level5Counter = $level5Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
EndFunc
	
Func level6()
		$sHTML &= '<TABLE id="06">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 6</TH>' & @CRLF
		For $element In $lev6Array
			$sHTML &= $element
			$level6Counter = $level6Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
EndFunc
	
Func level7()
		$sHTML &= '<TABLE id="07">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 7</TH>' & @CRLF
		For $element In $lev7Array
			$sHTML &= $element
			$level7Counter = $level7Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc	
	
	Func level8()
		$sHTML &= '<TABLE id="08">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 8</TH>' & @CRLF
		For $element In $lev8Array
			$sHTML &= $element
			$level8Counter = $level8Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
EndFunc

Func level9()
		$sHTML &= '<TABLE id="09">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 9</TH>' & @CRLF
		For $element In $lev9Array
			$sHTML &= $element
			$level9Counter = $level9Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
EndFunc


Func level10()
		$sHTML &= '<TABLE id="10">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 10</TH>' & @CRLF
		For $element In $lev10Array
			$sHTML &= $element
			$level10Counter = $level10Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
	
	Func level11()
		$sHTML &= '<TABLE id="11">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 11</TH>' & @CRLF
		For $element In $lev11Array
			$sHTML &= $element
			$level11Counter = $level11Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
	
	Func level12()
		$sHTML &= '<TABLE id="12">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 12</TH>' & @CRLF
		For $element In $lev12Array
			$sHTML &= $element
			$level12Counter = $level12Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
	
	Func level13()
		$sHTML &= '<TABLE id="13">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 13</TH>' & @CRLF
		For $element In $lev13Array
			$sHTML &= $element
			$level13Counter = $level13Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
	
		Func level14()
		$sHTML &= '<TABLE id="14">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 14</TH>' & @CRLF
		For $element In $lev14Array
			$sHTML &= $element
			$level14Counter = $level14Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
	
		Func level15()
		$sHTML &= '<TABLE id="15">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 15</TH>' & @CRLF
		For $element In $lev15Array
			$sHTML &= $element
			$level15Counter = $level15Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
	
		Func level16()
		$sHTML &= '<TABLE id="16">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 16</TH>' & @CRLF
		For $element In $lev16Array
			$sHTML &= $element
			$level16Counter = $level16Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
	
			Func level17()
		$sHTML &= '<TABLE id="17">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 17</TH>' & @CRLF
		For $element In $lev17Array
			$sHTML &= $element
			$level17Counter = $level17Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
	
			Func level18()
		$sHTML &= '<TABLE id="18">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 18</TH>' & @CRLF
		For $element In $lev18Array
			$sHTML &= $element
			$level18Counter = $level18Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
	
			Func level19()
		$sHTML &= '<TABLE id="19">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 19</TH>' & @CRLF
		For $element In $lev19Array
			$sHTML &= $element
			$level19Counter = $level19Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
	
			Func level20()
		$sHTML &= '<TABLE id="20">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 20</TH>' & @CRLF
		For $element In $lev20Array
			$sHTML &= $element
			$level20Counter = $level20Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
	
				Func level21()
		$sHTML &= '<TABLE id="21">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 21</TH>' & @CRLF
		For $element In $lev21Array
			$sHTML &= $element
			$level21Counter = $level21Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
		
				Func level22()
		$sHTML &= '<TABLE id="22">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 22</TH>' & @CRLF
		For $element In $lev22Array
			$sHTML &= $element
			$level22Counter = $level22Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
	
	Func level23()
		$sHTML &= '<TABLE id="23">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 23</TH>' & @CRLF
		For $element In $lev23Array
			$sHTML &= $element
			$level23Counter = $level23Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc
	
	Func level24()
		$sHTML &= '<TABLE id="24">' & @CRLF
		$sHTML &= '<TBODY>' & @CRLF
		$sHTML &= '<TH>Level 24</TH>' & @CRLF
		For $element In $lev24Array
			$sHTML &= $element
			$level24Counter = $level24Counter + 1
		Next
		$sHTML &= '</TBODY>' & @CRLF
		$sHTML &= '</TABLE>' & @CRLF
		$sHTML &= @CRLF
	EndFunc

MsgBox(0, "Number of other Printers Found :", "The number of other printers found is: " & $others)
_ArrayDisplay($miscArray, "Test")
	
;	Func miscArray()
;		$sHTML &= '<TABLE id="misc">' & @CRLF
;		$sHTML &= '<TBODY>' & @CRLF
;		$sHTML &= '<TH>Miscellaneous Printers</TH>' & @CRLF
;		For $element In $miscArray
;			$sHTML &= $element
;			$miscCounter = $miscCounter + 1
;		Next
;		$sHTML &= '</TBODY>' & @CRLF
;		$sHTML &= '</TABLE>' & @CRLF
;		$sHTML &= @CRLF
;	EndFunc
	
$file = FileOpen("c:\testweb.htm", 2)
FileWrite($file, $sHTML)

Exit
