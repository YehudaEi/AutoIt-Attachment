Global _
        $a = 0, _
		$status = 0, _
		$input = 0, _
		$img = 0, _
		$select = 0, _
		$span = 0, _
		$td = 0, _
		$select = 0, _
        $oLinks, _
		$oInputs, _
		$oImgs, _
		$oSelect, _
		$oEvent, _
		$oLinkEvents[1], _
		$oInputEvents[1], _
		$oImgEvents[1], _
		$oSpanEvents[1], _
		$oTdEvents[1], _
		$oSelectEvents[1]
		
; We use a very simple GUI to show the results of our Events.
#include "GUIConstants.au3"
#include "IE.au3"

_IEErrorHandlerRegister ()

$GUIMain=GUICreate              ( "Event Test",       600,500 )
$GUIEdit=GUICtrlCreateEdit      ( "Test Log:" & @CRLF,  10, 20, 580, 400)
$GUIProg=GUICtrlCreateProgress  (                       10,  5, 580,  10)
$GUIExit=GUICtrlCreateButton    ( " Close ",          250, 450, 80,  30)
GUISetState ()       ;Show GUI
;$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")
; We prepare the Internet Explorer as our test subject
$oIE=ObjCreate("InternetExplorer.Application.1")

With $oIE
    .Visible=1
    .Top = (@DesktopHeight-400)/2
    .Height=400         ; Make it a bit smaller than our GUI.
    .Width=600
    .Silent=1           ; Don't show IE's dialog boxes
    $IEWnd=HWnd(.hWnd)  ; Remember the Window, in case user decides to close it
EndWith

; We choose for a specific Internet Explorer interface 'DWebBrowserEvents' because the IE is subject
; to modifications by e.g. Visual Studio and Adobe Acrobat Reader. If you have IE-plugins installed, 
; AutoIt might not be able to find the correct interface automatically.
$EventObject=ObjEvent($oIE,"IEEvent_","DWebBrowserEvents")
;$oDoc = _IEDocGetObj ($oIE)
;$EventObject=ObjEvent($oIE.Document.parentwindow,"IEEvent2_")
if @error then 
   Msgbox(0,"AutoIt COM Test", _ 
    "ObjEvent: Can't use event interface 'DWebBrowserEvents'. Error code: " & hex(@error,8))
   exit
endif

; Now starting to load an example Web page.
$URL = "http://www.google.com/"
$oIE.Navigate( $URL )           
sleep(1000)             ; Give it some time to load the web page

;_IEAction($oIE, "refresh")
GUISwitch ( $GUIMain )  ; Switch back to our GUI in case IE stealed the focus

; Waiting for user to close the GUI.
While 1
   $msg = GUIGetMsg()
   If $msg = $GUI_EVENT_CLOSE or $msg = $GUIExit Then ExitLoop
Wend

$EventObject.Stop   ; Tell IE we don't want to receive events.
$EventObject=0      ; Kill the Event Object
ToolTip("")
If WinExists($IEWnd) then $oIE.Quit     ; Close IE Window

$oIE=0              ; Remove IE from memory (not really necessary).



GUIDelete ()        ; Remove GUI

exit                ; End of our Demo.

; A few Internet Explorer Event Functions
; See also: http://msdn.microsoft.com/workshop/browser/webbrowser/reference/objects/webbrowser.asp

Func IEEvent_BeforeNavigate($URL, $Flags, $TargetFrameName, $PostData, $Headers, $Cancel)
;   Note: the declaration is different from the one on MSDN.
    GUICtrlSetData ( $GUIEdit, "BeforeNavigate: " & $URL & " Flags: " & $Flags & " tgframe: " & $TargetFrameName & " Postdat: " & $PostData & " Hdrs: " & $Headers & " canc: " & $Cancel  & @CRLF  , "append" )
EndFunc

Func IEEvent_ProgressChange($Progress,$ProgressMax)
    If $ProgressMax > 0 Then
        GUICtrlSetData($GUIProg, ($Progress * 100) / $ProgressMax )
    EndIf
EndFunc

Func IEEvent_StatusTextChange($Text)
	If $Text <> "" and StringLeft($Text,7)<>"http://" and $Text <> "Done" Then
		GUICtrlSetData( $GUIEdit, "IE Status text changed to: " & $Text & @CRLF  , "append" )
	EndIf
EndFunc

Func IEEvent_PropertyChange( $szProperty)
	If $szProperty <> "" Then
		GUICtrlSetData ( $GUIEdit, "IE Changed the value of the property: " & $szProperty & @CRLF  , "append" )
	EndIf
EndFunc

Func IEEvent_DownloadBegin()
	ToolTip("")
    GUICtrlSetData ( $GUIEdit, "IE has started a navigation operation" & @CRLF  , "append" )
EndFunc


Func IEEvent_DownloadComplete()
    GUICtrlSetData ( $GUIEdit, "IE has finished a navigation operation" & @CRLF  , "append" )
EndFunc

Func IEEvent_NavigateError($oIE )
	GUICtrlSetData ( $GUIEdit, "IE has finished a navigate error "& $URL & @CRLF  , "append" )
EndFunc

Func IEEvent_TitleChange($Text )
	GUICtrlSetData ( $GUIEdit, "IE Title: "& $Text & @CRLF  , "append" )
EndFunc

Func IEEvent_OnQuit()	  
	  GUICtrlSetData ( $GUIEdit, "IE has quit" & @CRLF  , "append" )
	  	  
	  ToolTip("")
EndFunc

  
Func IEEvent_NavigateComplete($URL)  
	$top= _IEPropertyGet ($oIE, "top")
	$left= _IEPropertyGet ($oIE, "left")
	ToolTip($oIE.Document.title,$left+10,$top+50,"Download Complete",1)
	$oEvent = ObjEvent($oIE.document.parentWindow, "IE_Evt_")
	
	_IEHeadInsertEventScript($oIE, "document", "oncontextmenu", ";return false")
;   Note: the declaration is different from the one on MSDN.
    GUICtrlSetData ( $GUIEdit, "IE has finished loading URL: " & $URL & @CRLF  , "append" )
	
	 $a = 0
    $oLinks = _IELinkGetCollection($oIE)
    For $oLink In $oLinks
        ReDim $oLinkEvents[$a + 1]
        $oLinkEvents[$a] = ObjEvent($oLink, "IE_Evt_")
        $a += 1
    Next
	
	$input = 0
	$oInputs = _IEFormGetCollection($oIE,0)
    For $oInput In $oInputs
        ReDim $oInputEvents[$input + 1]
        $oInputEvents[$input] = ObjEvent($oInput, "IE_Evt_")
        $input += 1
    Next
	
	$select = 0
	$oSelects = _IEFormGetCollection($oIE,0)
    For $oSelect In $oSelects
        ReDim $oSelectEvents[$select + 1]
        $oSelectEvents[$select] = ObjEvent($oSelect, "IE_Evt_")
        $select += 1
    Next
	
	$img = 0
	$oImgs = _IEImgGetCollection($oIE)
    For $oImg In $oImgs
        ReDim $oImgEvents[$img + 1]
        $oImgEvents[$img] = ObjEvent($oImg, "IE_Evt_")
        $img += 1
    Next
EndFunc

Func IE_Evt_onclick()

    $oElement = @COM_EventObj
	ToolTip("")
	ScriptLine($oIE,$oElement, "click")


EndFunc   ;==>IE_Evt_onclick

Func IE_Evt_onfocusout() 
	 $oElement = @COM_EventObj
	 ToolTip("")
	ScriptLine($oIE,$oElement, "set")	
EndFunc

Func ScriptLine($oIE,$oElement,$action)
	$web_element = StringUpper($oElement.tagName)
	Select
	Case $action = "click"		
		Select
		Case $web_element = "INPUT"
			Select
			Case StringUpper($oElement.type) = "SUBMIT" or StringUpper($oElement.type) = "BUTTON"
				ConsoleWrite("Browser(title:="&$oIE.document.title&").Button(name:="&$oElement.name&").click"& @CRLF)
			Case StringUpper($oElement.type) = "IMG" 	
				ConsoleWrite("Browser(title:="&$oIE.document.title&").Image(base_name:="&$oElement.name&").click"& @CRLF)
			EndSelect
		Case $web_element = "A"
			ConsoleWrite("Browser(title:="&$oIE.document.title&").Link(base_name:="&$oElement.href&").click"& @CRLF)
		Case $web_element = "IMG"
				ConsoleWrite("Browser(title:="&$oIE.document.title&").Image(base_name:="&$oElement.name&").click"& @CRLF)
		Case $web_element = "SELECT"
				ConsoleWrite("Browser(title:="&$oIE.document.title&").List(base_name:="&$oElement.innerText&").click"& @CRLF)
		Case else
           ConsoleWrite( "Unsupported onclick tagname " & $web_element  & @CRLF)
	EndSelect
	Case $action = "set"		
		Select
		Case $web_element = "INPUT"
			Select
			Case StringUpper($oElement.type) = "TEXT" or StringUpper($oElement.type) = "PASSWORD"
				ConsoleWrite("Browser(title:="&$oIE.document.title&").TextField(name:="&$oElement.name&").set '"&$oElement.value&"'"& @CRLF)
	EndSelect
	Case $web_element = "SELECT"			
;HERE IS THE PROBLEM, WHAT SHOULD I PUT INSTEAD OF 	$oElement.value
			ConsoleWrite("Browser(title:="&$oIE.document.title&").TextField(name:="&$oElement.name&").set '"&$oElement.value&"'"& @CRLF)
		Case else
           ConsoleWrite( "Unsupported onclick tagname " & $web_element  & @CRLF)
	   EndSelect
	EndSelect
EndFunc
