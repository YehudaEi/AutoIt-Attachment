; ----------------------------------------------------------------------------
;
; uses 2 google APIs for retrieving weather information and for an online chart generator 



; getting weather information from google API
;
; also uses google chart api for some a little trend display
; http://chart.apis.google.com/chart?chs=200x100&chd=t:15,17,19,21&cht=bvg&chds=0,40


; http://www.google.com/ig/api?weather=Berlin -> this works??

; images are at

; http://www.google.com/images/weather/chance_of_rain.gif 40*40 pixel

#cs
	
	http://www.google.com/ig/api?weather=Berlin
	http://www.google.com/images/weather/chance_of_rain.gif
	
	Feed Url's
	UK English: http://www.google.co.uk/ig/api?weather=
	US English: http://www.google.com/ig/api?weather=
	Norwegian: http://www.google.no/ig/api?weather=
	Japanese:                                        
	Russian: http://www.google.ru/ig/api?weather=
	French: http://www.google.fr/ig/api?weather=
	German:                                     
	Canada http://www.google.ca/ig/api?weather=
	
	icon resources 
	                              
	                                                               
	
	
	author nobbe	04.2009
#ce

; ----------------------------------------------------------------------------

#include <inet.au3>
#include <array.au3>
;#include <_XMLDomWrapper.au3> ; all code now included in main file

#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#include <GDIPlus.au3>	; Initialize GDI+ library

ConsoleWrite(@AutoItVersion & @CRLF);

Global $strFile
Global $objDoc = 0;
Global $oXMLMyError ;COM error handler OBJ ; Initialize SvenP 's error handler
Global $sXML_error
Global $debugging = 1;
Global $DOMVERSION = -1
Global $bXMLAUTOSAVE = True

Global $infile = @ScriptDir & "\weather.xml";

Global $town = "Stuttgart";

Global $b_use_celsius = 0 ; 1 for celsius or 0 for farenheit


Global $lbl_tag[5], $lbl_tag_low[5], $lbl_tag_high[5], $pic_tag[5], $lbl_tag_condition[5]

; for controls positioning
Global $x_start = 8;

#Region ### START Koda GUI section ### Form=H:\autoit\xml_weather\google_weather.kxf
$GUI = GUICreate("google weather", 800, 131, 0, 0)

;
For $i = 0 To 4
	$lbl_tag[$i] = GUICtrlCreateLabel("", $x_start, 10, 40, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "Arial")

	$lbl_tag_low[$i] = GUICtrlCreateLabel("", $x_start, 30, 40, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "Arial")

	$lbl_tag_high[$i] = GUICtrlCreateLabel("", $x_start + 30, 30, 40, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "Arial")

	$pic_tag[$i] = GUICtrlCreatePic("", $x_start, 48, 40, 40, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
	$lbl_tag_condition[$i] = GUICtrlCreateLabel("", $x_start, 104, 150, 17)

	GUICtrlSetFont(-1, 8, 800, 0, "Arial")
	$x_start += 130

Next

; for google chart
;http://chart.apis.google.com/chart?chs=200x100&chd=t:15,17,19,21&cht=bvg&chds=0,40
$pic_chart = GUICtrlCreatePic("", $x_start - 40, 10, 200, 100)


GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_set_info()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd


; set on controls
Func _set_info()

	WinSetTitle($GUI, "", "google weather for " & $town);

	; for english values (fahrenheit)
	;$url = "http://www.google.com/ig/api?weather=" & $town ;& "&hl=de";
	
	; for germany
	$url = "                                    " & $town
	
	
	$url = _URLEncode($url)
	ConsoleWrite($url & @CRLF);

	; save into TEMP file first to check the XML data by hand
	;InetGet("http://www.google.com/ig/api?weather=Berlin" & '\&' & "hl=de", @ScriptDir & "\weather.xml", 1, 0)

	InetGet($url, $infile, 1, 0)

	; change codepage to let xml parser accept it better 
	$text = FileRead($infile)
	$text = StringReplace($text, '<?xml version="1.0"?>', '<?xml version="1.0" encoding="ISO-8859-2"?>')
	FileDelete($infile)
	FileWrite($infile, $text)


	;$result = _INetGetSource($url)
	;ConsoleWrite($result);

	; now xml file in local drive @scriptdir

	$objDoc = _XMLFileOpen($infile)

	$curr_condition = _XMLGetAttrib("//xml_api_reply/weather/current_conditions/condition", "data");
	ConsoleWrite("$curr_condition " & $curr_condition & @CRLF);
	GUICtrlSetData($lbl_tag[0], $curr_condition)

	$curr_temp_f = _XMLGetAttrib("//xml_api_reply/weather/current_conditions/temp_f", "data");
	ConsoleWrite("$curr_temp_f " & $curr_temp_f & @CRLF);
	$b_use_celsius = 1
	$high = "";
	$high = $high & _f2c($curr_temp_f) & ",";
	
	GUICtrlSetData($lbl_tag_low[0], _f2c($curr_temp_f));
	
	$b_use_celsius = 0

	$curr_wind = _XMLGetAttrib("//xml_api_reply/weather/current_conditions/wind_condition", "data");
	ConsoleWrite("wind attrib " & $curr_wind & @CRLF);
	GUICtrlSetData($lbl_tag_condition[0], $curr_wind)

	$curr_icon = _XMLGetAttrib("//xml_api_reply/weather/current_conditions/icon", "data");
	ConsoleWrite("wind attrib " & $curr_icon & @CRLF);
	$pic_preview = @ScriptDir & "\icon.gif";

	$rc = InetGet("http://www.google.com/" & $curr_icon, @ScriptDir & "\icon.gif")
	ConsoleWrite("nach get picture " & @CRLF)
	GUICtrlSetImage($pic_tag[0], $pic_preview)

	;; ok now all other items

	#cs
		$strXPath1 = "//xml_api_reply/weather/forecast_conditions/day_of_week"
		$strXPath2 = "//xml_api_reply/weather/forecast_conditions/low"
		$strXPath3 = "//xml_api_reply/weather/forecast_conditions/high"
		$strXPath4 = "//xml_api_reply/weather/forecast_conditions/icon"
		$strXPath5 = "//xml_api_reply/weather/forecast_conditions/condition"
	#ce

	$strXPath1 = "weather/forecast_conditions/day_of_week"
	$strXPath2 = "weather/forecast_conditions/low"
	$strXPath3 = "weather/forecast_conditions/high"
	$strXPath4 = "weather/forecast_conditions/icon"
	$strXPath5 = "weather/forecast_conditions/condition"

	$strAttrib = "data";

	; day of week
	$array = _get_all_attrib($strXPath1, $strAttrib)
	;	_ArrayDisplay($array, 'attrib')
	For $i = 1 To 4
		GUICtrlSetData($lbl_tag[$i], $array[$i])
	Next

	; low temperature
	$array = _get_all_attrib($strXPath2, $strAttrib)
	;	_ArrayDisplay($array, 'attrib')
	For $i = 1 To 4
		GUICtrlSetData($lbl_tag_low[$i], _f2c($array[$i]) & " °") ; convert to celsius
	Next

	; high temperature
	$array = _get_all_attrib($strXPath3, $strAttrib)
	;	_ArrayDisplay($array, 'attrib')
	
	For $i = 1 To 4
		
		$high = $high & _f2c($array[$i]) & ",";
		GUICtrlSetData($lbl_tag_high[$i], _f2c($array[$i]) & " °")
	Next

	; -1 char
	$high = StringLeft($high, StringLen($high) - 1)




	; icons
	$array = _get_all_attrib($strXPath4, $strAttrib)
	;	_ArrayDisplay($array, 'attrib')
	For $i = 1 To 4
		$rc = InetGet("http://www.google.com/" & $array[$i], @ScriptDir & "\icon.gif")
		GUICtrlSetImage($pic_tag[$i], @ScriptDir & "\icon.gif")
	Next;

	; condition
	$array = _get_all_attrib($strXPath5, $strAttrib)
	;	_ArrayDisplay($array, 'attrib')
	For $i = 1 To 4
		GUICtrlSetData($lbl_tag_condition[$i], $array[$i])
	Next


	; http://chart.apis.google.com/chart?chs=200x100&chd=t:15,17,19,21&cht=bvg&chds=0,40
	; the google chart api sends only png pictures- we need to convert to gif
	
	$rc = InetGet("http://chart.apis.google.com/chart?chs=200x100&chd=t:" & $high & "&cht=bvg&chds=0,40&chxt=y&chxr=0,0,40", @ScriptDir & "\chart.png")
	
	_GDIPlus_Startup()
	Local $hImage
	$hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\chart.png")
	_GDIPlus_ImageSaveToFile($hImage, @ScriptDir & "\chart.gif")
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()

	GUICtrlSetImage($pic_chart, @ScriptDir & "\chart.gif")

EndFunc   ;==>_set_info



; retrieve all item attributes
;
; this is a different code than the one in _xmldomwrapper

;	Path
;		$strXPath1 = "//xml_api_reply/weather/forecast_conditions/day_of_week"
; 	Attrib
; 		$strAttrib = "data";
;
; returns : array of all attributes of a certain type


Func _get_all_attrib($path, $attrib)
	Local $ret[1]
	Local $objDocNodeList
	Local $irun = 0
	Local $item

	If Not IsObj($objDoc) Then
		_XMLError("No object passed to function _get_all_attrib")
		ConsoleWrite("No object passed to function _get_all_attrib " & @CRLF)

		Return SetError(2, 0, -1)
	EndIf

	$objDocNodeList = $objDoc.documentElement.selectNodes($path)

	ConsoleWrite("Number of Nodes = " & $objDocNodeList.length & @CRLF) ;; number of entries
	If $objDocNodeList.length > 0 Then
		ConsoleWrite("$objDocNodeList.length > 0 = " & $objDocNodeList.length & @CRLF)

		ReDim $ret[$objDocNodeList.length + 1]

		$ret[0] = $objDocNodeList.length;

		; set all items into array
		For $irun = 0 To $objDocNodeList.length - 1
			$item = $objDocNodeList.item($irun).getAttribute($attrib)
			ConsoleWrite($attrib & " (" & $item & ")" & @CRLF)
			$ret[$irun + 1] = $item
		Next

	EndIf

	Return $ret;
EndFunc   ;==>_get_all_attrib


; encode for url
Func _URLEncode($toEncode, $encodeType = 2)
	ConsoleWrite("func _URLEncode" & @CRLF)

	Local $strHex = "", $iDec
	Local $aryChar = StringSplit($toEncode, "")
	If $encodeType = 1 Then;;Encode EVERYTHING
		For $i = 1 To $aryChar[0]
			$strHex = $strHex & "%" & Hex(Asc($aryChar[$i]), 2)
		Next
		Return $strHex
	ElseIf $encodeType = 0 Then;;Practical Encoding
		For $i = 1 To $aryChar[0]
			$iDec = Asc($aryChar[$i])
			If $iDec <= 32 Or $iDec = 37 Then
				$strHex = $strHex & "%" & Hex($iDec, 2)
			Else
				$strHex = $strHex & $aryChar[$i]
			EndIf
		Next
		Return $strHex
	ElseIf $encodeType = 2 Then;;RFC 1738 Encoding
		For $i = 1 To $aryChar[0]
			If Not StringInStr("$-_.+!*'(),;/?:@=&abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890", $aryChar[$i]) Then
				$strHex = $strHex & "%" & Hex(Asc($aryChar[$i]), 2)
			Else
				$strHex = $strHex & $aryChar[$i]
			EndIf
		Next
		Return $strHex
	EndIf
EndFunc   ;==>_URLEncode


; convert fahrenheit 2 celsius
Func _f2c($f)
	Local $c
	If $b_use_celsius > 0 Then

		$c = ($f - 32) * (5 / 9)
		$c = Round($c, 0)
		Return $c ;& " °"
	Else
		Return $f ;& " °"
	EndIf

EndFunc   ;==>_f2c



;===============================================================================
; Function Name:	 _XMLFileOpen
; Description:		Creates an instance of an XML file.
; Parameter(s):	$strXMLFile - the XML file to open
;						$strNameSpc - the namespace to specifiy if the file uses one.
;						$iVer - specifically try to use the version supplied here.
;						$bValOnParse - validate the document as it is being parsed
; Syntax:			 _XMLFileOpen($strXMLFile, [$strNameSpc], [$iVer], [$bValOnParse] )
; Return Value(s): On Success - 1
;						 On Failure - -1 and set
;							@Error to:
;								0 - No error
;								1 - Parse error
;								2 - No object
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
;===============================================================================
Func _XMLFileOpen($strXMLFile, $strNameSpc = "", $iVer = -1, $bValOnParse = True)
	;==== pick your poison
	If $iVer <> -1 Then
		If $iVer > -1 And $iVer < 7 Then
			$objDoc = ObjCreate("Msxml2.DOMDocument." & $iVer & ".0")
			If IsObj($objDoc) Then
				$DOMVERSION = $iVer
			EndIf
		Else
			MsgBox(266288, "Error:", "Failed to create object with MSXML version " & $iVer)
			SetError(1)
			Return 0
		EndIf
	Else
		For $x = 8 To 0 Step -1
			If FileExists(@SystemDir & "\msxml" & $x & ".dll") Then
				$objDoc = ObjCreate("Msxml2.DOMDocument." & $x & ".0")
				If IsObj($objDoc) Then
					$DOMVERSION = $x
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf
	If Not IsObj($objDoc) Then
		_XMLError("Error: MSXML not found. This object is required to use this program.")
		SetError(2)

		MsgBox(266288, "Error:", "Error: MSXML not found. This object is required to use this program.")

		Return -1
	EndIf


	;Thanks Lukasz Suleja
	$oXMLMyError = ObjEvent("AutoIt.Error")
	If $oXMLMyError = "" Then
		$oXMLMyError = ObjEvent("AutoIt.Error", "_XMLCOMEerr") ; ; Initialize SvenP 's error handler
	EndIf
	$strFile = $strXMLFile
	$objDoc.async = False
	$objDoc.preserveWhiteSpace = True
	$objDoc.validateOnParse = $bValOnParse
	If $DOMVERSION > 4 Then $objDoc.setProperty("ProhibitDTD", False)
	$objDoc.Load($strFile)
	$objDoc.setProperty("SelectionLanguage", "XPath")
	$objDoc.setProperty("SelectionNamespaces", $strNameSpc)
	If $objDoc.parseError.errorCode > 0 Then ConsoleWrite($objDoc.parseError.reason & @LF)
	If $objDoc.parseError.errorCode <> 0 Then
		_XMLError("Error opening specified file: " & $strXMLFile & @CRLF & $objDoc.parseError.reason)
		SetError($objDoc.parseError.errorCode)
		$objDoc = 0
		Return -1
	EndIf
	Return $objDoc
EndFunc   ;==>_XMLFileOpen


;===============================================================================
; Function Name:	_XMLGetAttrib
; Description:		Get XML Field based on XPath input from root node.
; Parameter(s):		$path	xml tree path from root node (root/child/child..)
; Syntax:			_XMLGetAttrib($path,$attrib)
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
; Return Value(s): On Success  The attribute value.
;						 On Failure -1 and sets
;								@Error to:
;									0 = No error
;									1 = Attribute not found.
;									2 = No object
;===============================================================================
Func _XMLGetAttrib($strXPath, $strAttrib, $strQuery = "")
	If Not IsObj($objDoc) Then
		_XMLError("No object passed to function _XMLGetAttrib")
		Return SetError(2, 0, -1)
	EndIf
	;Local $objNodeList, $arrResponse[1], $i, $xmlerr, $objAttr
	Local $objNodeList, $arrResponse, $i, $xmlerr, $objAttr
	$objNodeList = $objDoc.documentElement.selectNodes($strXPath & $strQuery)
	_DebugWrite("Get Attrib length= " & $objNodeList.length)
	While @error = 0
		If $objNodeList.length > 0 Then
			;ReDim $arrResponse[$objNodeList.length]
			For $i = 0 To $objNodeList.length - 1
				$objAttr = $objNodeList.item($i).getAttribute($strAttrib)
				$arrResponse = $objAttr
				_DebugWrite("RET>>" & $objAttr)
			Next
			;_DebugWrite("RET>>" & $arrResponse)
			Return $arrResponse
		Else
			$xmlerr = @CRLF & "No qualified items found"
			ExitLoop
		EndIf
	WEnd
	_XMLError("Attribute " & $strAttrib & " not found for: " & $strXPath & $xmlerr)
	Return SetError(1, 0, -1)
	;	EndIf
EndFunc   ;==>_XMLGetAttrib

;===============================================================================
; Function Name:	_XMLError
; Description:		Sets error message generated by XML functs.
;					or Gets the message that was Set.
; Parameter(s):		$sError Node from root to delete
; Syntax:			_XMLError([$sError)
; Author(s):		Stephen Podhajecki <gehossafats@netmdc.com>
; Return Value(s)			Nothing or Error message
;===============================================================================
Func _XMLError($sError = "")
	If $sError = "" Then
		$sError = $sXML_error
		$sXML_error = ""
		Return $sError
	Else
		$sXML_error = $sError
	EndIf
	_DebugWrite($sXML_error)
EndFunc   ;==>_XMLError
;===============================================================================
; Function Name:	_XMLCOMEerr
; Description:		Displays a message box with the COM Error.
; Parameter(s):		none
; Syntax:			_XMLCOMEerr()
; Author(s):		SvenP 's error handler
; Return Value(s)
; From the forum this came.
;===============================================================================
Func _XMLCOMEerr()
	_ComErrorHandler()
	Return
EndFunc   ;==>_XMLCOMEerr
Func _ComErrorHandler($quiet = "")
	Local $COMErr_Silent, $HexNumber
	;===============================================================================
	;added silent switch to allow the func returned to the option to display custom
	;error messages
	If $quiet = True Or $quiet = False Then
		$COMErr_Silent = $quiet
		$quiet = ""
	EndIf
	;===============================================================================
	$HexNumber = Hex($oXMLMyError.number, 8)
	If @error Then Return
	Local $msg = "COM Error with DOM!" & @CRLF & @CRLF & _
			"err.description is: " & @TAB & $oXMLMyError.description & @CRLF & _
			"err.windescription:" & @TAB & $oXMLMyError.windescription & @CRLF & _
			"err.number is: " & @TAB & $HexNumber & @CRLF & _
			"err.lastdllerror is: " & @TAB & $oXMLMyError.lastdllerror & @CRLF & _
			"err.scriptline is: " & @TAB & $oXMLMyError.scriptline & @CRLF & _
			"err.source is: " & @TAB & $oXMLMyError.source & @CRLF & _
			"err.helpfile is: " & @TAB & $oXMLMyError.helpfile & @CRLF & _
			"err.helpcontext is: " & @TAB & $oXMLMyError.helpcontext
	If $COMErr_Silent <> True Then
		MsgBox(0, @AutoItExe, $msg)
	Else
		_XMLError($msg)
	EndIf
	SetError(1)
EndFunc   ;==>_ComErrorHandler
; simple helper functions
;===============================================================================
; Function Name:	- 	_DebugWrite($message)
; Description:		- Writes a message to console with a crlf on the end
; Parameter(s):		- $message the message to display
; Syntax:			- _DebugWrite($message)
; Author(s):		-
; Return Value(s)			-
;===============================================================================
Func _DebugWrite($message, $flag = @LF)
	If $debugging Then
		If $flag <> "" Then
			ConsoleWrite($message & $flag)
		Else
			ConsoleWrite($message)
		EndIf
	EndIf
EndFunc   ;==>_DebugWrite