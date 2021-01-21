#include <GUIConstants.au3>

Dim $oIE = _IECreateEmbedded()
Dim $HTML_String
Dim $oMyError
Global $__IELoadWaitTimeout = 300000 ; 5 Minutes

; Initialize SvenP 's  error handler 
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

GUICreate("Email Address Encryptor 1.0", 600, 400, (@DesktopWidth/2)-300, (@DesktopHeight/2)-350, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
$oIEProp = _IEEmbed(10, 250, 580, 100)
$Emailaddress = GUICtrlCreateInput ("Address@Domain.Com", 10,  35, 300, 20)
$List = GUICtrlCreateList ("",10,65,580,60)
$btn_1 = GUICtrlCreateButton ("Generate Address", 10,  125, 110, 20)
$btn_2 = GUICtrlCreateButton ("Copy 2 Clipboard", 130, 125, 110, 20)
GUISetState()

While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
	Case $msg = $btn_1
		_String2Ascii()
	Case $msg = $btn_2
		ClipPut($HTML_String)
	EndSelect
WEnd
	_IEQuit($oIE)
Exit
 

Func _IEEmbed($top, $left, $width , $height )
Local $oIE_Embed = GUICtrlCreateObj($oIE, $top, $left, $width, $height)
_IENavigate ( $oIE, "about:blank" )
_IEDocWriteHTML ( $oIE, "<body>This is how your Email looks in a Web Browser : <!-- ENCODED E-mail LINK READS --> <!-- END OF ENCODED LINK --></body>" )
EndFunc

Func _String2Ascii()
	local $Length, $Chars
	$Length = StringLen(GUICtrlRead($Emailaddress))
			;MsgBox(0, "ASCII code lenght", $Length) ; Debug
	Local $Array[$Length]
		For $i = 1 to $Length
			$Array = StringSplit(GUICtrlRead($Emailaddress),"",0) ; Read Chars
				;MsgBox(0, "Chars code :", $Array[$i]) ; Debug
			$Chars =$Chars &"&#"& Asc($Array[$i])&";"
				;MsgBox(0, "Chars code :", $Chars) ; Debug
		Next
		$HTML_String = "<a href='" & $Chars & "'>"& $chars & "</a>"
	_IEDocWriteHTML ( $oIE, "<body>This is how your Email looks in a Web Browser : <!-- ENCODED E-mail LINK READS -->" & _ 
	$HTML_String & "<!-- END OF ENCODED LINK --></body>" )
	GUICtrlSetData($List,$HTML_String)
EndFunc
	

;===============================================================================
;
; Function Name:    _IECreateEmbedded()
; Description:		Create a Webbrowser object suitable for embedding in an AutoIt GUI
;					with GuiCtrlCreateObj().  Note that this object will not have a
;					DOM Document until you use _IENavigate() (Tip: you can navigate to
;					"about:blank"). Also note that you cannot perform most operations
;					on this object until it has been realized with GuiCtrlCreateObj()
; Parameter(s):		None
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns a Webbrowser object reference
;                   On Failure - Returns 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IECreateEmbedded()
	
	Local $o_object = ObjCreate("Shell.Explorer.2")
	
	If Not IsObj($o_object) Then
		SetError(1)
		Return 0
	EndIf
	;
	SetError(0)
	Return $o_object
EndFunc   ;==>_IECreateEmbedded

;===============================================================================
;
; Function Name:    _IENavigate()
; Description:		Directs an existing browser window to navigate to the specified URL
; Parameter(s):		$o_object 		- Object variable of an InternetExplorer.Application, Window or Frame object
;					$s_Url 			- URL to navigate to (e.g. "http://www.autoitscript.com")
;					$f_wait 		- Optional: specifies whether to wait for page to load before returning
;										0 = Return immediately, not waiting for page to load
;										1 = (Default) Wait for page load to complete before returning
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns -1 (The navigate method actually has no return value - all we know is that we tried)
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IENavigate($o_object, $s_Url, $f_wait = 1)
	If Not IsObj($o_object) Then
		SetError(1)
		Return 0
	EndIf
	;
	Do
		Sleep(100)
	Until ($o_object.readyState = "complete" Or $o_object.readyState = 4)
	;
	$o_object.navigate ($s_Url)
	If ($f_wait = 1) Then _IELoadWait($o_object)
	SetError(0)
	Return -1
EndFunc   ;==>_IENavigate

;===============================================================================
;
; Function Name:    _IEDocWriteHTML()
; Description:		Replaces the HTML for the entire document
; Parameter(s):     $o_object 	- Object variable of an InternetExplorer.Application, Window or Frame object
;					$s_html		- The HTML string to write to the document
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns 1
;					On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEDocWriteHTML($o_object, $s_html)
	If Not IsObj($o_object) Then
		SetError(1)
		Return 0
	EndIf
	;
	$o_object.document.Write ($s_html)
	$o_object.document.close ()
	_IELoadWait($o_object.document)
	SetError(0)
	Return 1
EndFunc   ;==>_IEDocWriteHTML

;===============================================================================
;
; Function Name:    _IELoadWait()
; Description:		Wait for a browser page load to complete before returning
; Parameter(s):		$o_object 	- Object variable of an InternetExplorer.Application
;					$i_delay	- Optional: Milliseconds to wait before checking status
;					$i_timeout	- Optional: Period of time to wait before exiting function
;									(default = 300000 ms aka 5 min)
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success 	- Returns 1
;                   On Failure 	- Returns 0 and sets @ERROR = 1
;					On Timeout	- Returns 0 and sets @ERROR = 2
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IELoadWait($o_object, $i_delay = 0, $i_timeout = -1)
	If Not IsObj($o_object) Then
		SetError(1)
		Return 0
	EndIf
	;
	Sleep($i_delay)
	;
	Local $oTemp
	;
	Local $IELoadWaitTimer = TimerInit()
	If $i_timeout = -1 Then $i_timeout = $__IELoadWaitTimeout
	While TimerDiff($IELoadWaitTimer) < $i_timeout
		Switch ObjName($o_object)
			Case "IWebBrowser2"; InternetExplorer
				Do
					Sleep(100)
				Until ($o_object.readyState = "complete" Or $o_object.readyState = 4)
				Do
					Sleep(100)
				Until ($o_object.document.readyState = "complete" Or $o_object.document.readyState = 4)
			Case "DispHTMLWindow2" ; Window, Frame, iFrame
				Do
					Sleep(100)
				Until ($o_object.document.readyState = "complete" Or $o_object.document.readyState = 4)
				Do
					Sleep(100)
				Until ($o_object.top.document.readyState = "complete" Or $o_object.top.document.readyState = 4)
			Case "DispHTMLDocument" ; Document
				$oTemp = $o_object.parentWindow
				Do
					Sleep(100)
				Until ($oTemp.document.readyState = "complete" Or $oTemp.document.readyState = 4)
				Do
					Sleep(100)
				Until ($oTemp.top.document.readyState = "complete" Or $oTemp.top.document.readyState = 4)
			Case Else ; this should work with any other DOM object
				$oTemp = $o_object.document.parentWindow
				Do
					Sleep(100)
				Until ($oTemp.document.readyState = "complete" Or $oTemp.document.readyState = 4)
				Do
					Sleep(100)
				Until ($oTemp.top.document.readyState = "complete" Or $o_object.top.document.readyState = 4)
		EndSwitch
		SetError(0)
		Return 1
	WEnd
	SetError(2)
	Return 0
EndFunc   ;==>_IELoadWait

;===============================================================================
;
; Function Name:   _IEQuit()
; Description:		Close the browser and remove the object reference to it
; Parameter(s):		$o_object 	- Object variable of an InternetExplorer.Application
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEQuit($o_object)
	If Not IsObj($o_object) Then
		SetError(1)
		Return 0
	EndIf
	;
	SetError(0)
	; $o_object.quit ()
	$o_object = 0
	Return 1
EndFunc   ;==>_IEQuit

;This is Sven P's custom error handler
Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
  Msgbox(0,"COM Error Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
			 "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
			 "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
			 "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
			 "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
			 "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
			 "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
			 "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
			 "err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
			)
  SetError(1)  ; to check for after this function returns
Endfunc
