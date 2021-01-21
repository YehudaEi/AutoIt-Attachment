#include <IE.au3>
#include <File.au3>

Global _
		$oIE, _
		$oButton1, $oParent, _
		$sInstallPath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "betaInstallDir"), _
		$sExamplePath = $sInstallPath & "\Examples\Helpfile\Examples\", _
		$sCommentPath = $sInstallPath & "\Examples\Helpfile\Comments\"

HotKeySet("{Esc}", "_Exit")

; Create the directory stores if they don't already exist
DirCreate($sExamplePath)
DirCreate($sCommentPath)

; Check to see that the helpfile is open
If Not WinExists("AutoIt Help") Then
	Run("hh.exe " & $sInstallPath & "\AutoIt.chm", $sInstallPath)
	WinWait("AutoIt Help")
EndIf
WinActivate("AutoIt Help")
WinWaitActive("AutoIt Help")

; Register the IE.au3 Error Handler
_IEErrorHandlerRegister()

; Attach to the helpfile browser window
$oIE = _IEAttach("AutoIt Help", "Embedded")
If Not IsObj($oIE) Then
	MsgBox(48, "Error", "Could not attach to the help file.")
	Exit
EndIf

; Set up an event sink so that we can trigger on page loads
$oEvent = ObjEvent($oIE, "Evt_")

; The inital page load is already done... refresh so that event fires
_IEAction($oIE, "refresh")

; Keep the script running as long as $oIE is a browser object
While __IEIsObjType($oIE, "browserdom")
	Sleep(50)
WEnd

Func Evt_onload()

	; This function will be fired whenever a new help page loads

	; Get a reference to the first H1 tag, then its text
	Local $o_object = @COM_EventObj
	Local $oSection = _IETagNameGetCollection($o_object, "h1", 0)
	Local $sSectionName = $oSection.innerText

	; When Section is "Function Reference", the next element is the function name
	; Get a reference to the function name, then its text
	Local $oFunction = $oSection.nextSibling
	Local $sFuncName = $oFunction.innerText

	; Get a reference to the "Open this Script" button
	; Then get a reference to its parent which is the codebox
	$oButton1 = _IETagNameGetCollection($oIE, "OBJECT", 0)
	$oParent = $oButton1.parentElement

	Switch $sSectionName
		Case "Function Reference", "Keyword Reference"
			_CreateFiles($sFuncName)
			_CreateComment($sFuncName)
			_CreateExample($sFuncName)
		Case Else
			;;;
	EndSwitch
EndFunc   ;==>Evt_onload

Func _CreateFiles($s_FuncName)
	$sExampleFile = $sExamplePath & $s_FuncName & "_Custom.au3"
	$sCommentFile = $sCommentPath & $s_FuncName & ".txt"
	If Not FileExists($sExampleFile) Then
		_FileCreate($sExampleFile)
	EndIf
	If Not FileExists($sCommentFile) Then
		_FileCreate($sCommentFile)
	EndIf
EndFunc   ;==>_CreateFiles

Func _CreateExample($s_FuncName)
	; Create a new element to hold the button
	$oButton2 = $oIE.document.createElement("")

	; Build the HTML for the button
	If Not IsObj($oButton2) Then Return 0
	$sHTML = "&nbsp;"
	$sHTML &= '<OBJECT id=hhctrl type="application/x-oleobject" classid="clsid:adb880a6-d8ff-11cf-9377-00aa003b7a11" width=58 height=57>'
	$sHTML &= '<PARAM name="Command" value="ShortCut">'
	$sHTML &= '<PARAM name="Button" value="Text:Open Custom Script">'
	$sHTML &= '<PARAM name="Item1" value=",Examples\HelpFile\Examples\' & $s_FuncName & '_Custom.au3,">'
	$sHTML &= '</OBJECT>'
	With $oButton2
		.innerHTML = $sHTML
	EndWith
	; Insert the button as the next child of the codebox
	If Not IsObj($oParent) Then Return 0
	$oParent.appendChild($oButton2)

	Return 1
EndFunc   ;==>_CreateExample

Func _CreateComment($s_FuncName)
	; Create a new element to hold the codebox
	$oComment = $oIE.document.createElement("")

	; Gather previous comments if they exist
	$sCommentFile = $sCommentPath & $s_FuncName & ".txt"
	$sFuncComment = FileRead($sCommentFile)
	If @error Then $sFuncComment = ""

	; Build the HTML for the commentbox
	If Not IsObj($oComment) Then Return 0
	$sHTML = ''
	$sHTML &= '<p><b>Comment</b></p>'
	$sHTML &= '<p class="codebox">'
	$sHTML &= '<br>'
	$sHTML &= $sFuncComment
	$sHTML &= '<br><br>'
	$sHTML &= '<OBJECT id=hhctrl type="application/x-oleobject" classid="clsid:adb880a6-d8ff-11cf-9377-00aa003b7a11" width=58 height=57>'
	$sHTML &= '<PARAM name="Command" value="ShortCut">'
	$sHTML &= '<PARAM name="Button" value="Text:Add Comment">'
	$sHTML &= '<PARAM name="Item1" value=",Examples\HelpFile\Comments\' & $s_FuncName & '.txt,">'
	$sHTML &= '</OBJECT>'
	With $oComment
		.innerHTML = $sHTML
	EndWith

	; Insert the commentbox after the codebox
	If Not IsObj($oParent) Then Return 0
	$oParent.insertAdjacentElement("afterEnd", $oComment)

	Return 1
EndFunc   ;==>_CreateComment

Func _Exit()
	Exit
EndFunc   ;==>_Exit