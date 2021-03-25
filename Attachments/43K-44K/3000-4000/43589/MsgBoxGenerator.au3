#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <StaticConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <UpDownConstants.au3>

Global $sOK, $sOKCANCEL, $sABORTRETRYIGNORE, $sYESNOCANCEL, $sYESNO, $sRETRYCANCEL, $sCANCELTRYCONTINUE, $sButtonOptions
$sOK = 'OK'
$sOKCANCEL = 'OK and Cancel'
$sABORTRETRYIGNORE = 'Abort, Retry, and Ignore'
$sYESNOCANCEL = 'Yes, No, and Cancel'
$sYESNO = 'Yes and No'
$sRETRYCANCEL = 'Retry and Cancel'
$sCANCELTRYCONTINUE = 'Cancel, Try Again, and Continue'
$sButtonOptions = StringFormat('%s|%s|%s|%s|%s|%s|%s', $sOK, $sOKCANCEL, $sABORTRETRYIGNORE, $sYESNOCANCEL, $sYESNO, $sRETRYCANCEL, $sCANCELTRYCONTINUE)

$hWnd = GUICreate('Message Box Generator', 500, 470)

GUICtrlCreateGroup('Title', 10, 0, 485, 50)
$iInputTitle = GUICtrlCreateInput('', 20, 20, 461, 21)

GUICtrlCreateGroup('', -99, -99, 1, 1)

GUICtrlCreateGroup('Text', 10, 50, 485, 135)
$iEditText = GUICtrlCreateEdit('', 20, 70, 461, 101)
GUICtrlCreateGroup('', -99, -99, 1, 1)

GUICtrlCreateGroup('Icon', 10, 190, 211, 91)
$iIconNone = GUICtrlCreateIcon('', 0, 20, 210, 32, 32)
GUICtrlSetTip(-1, 'No icon')
$iIconError = GUICtrlCreateIcon('C:\Windows\System32\user32.dll', -4, 60, 210, 32, 32)
GUICtrlSetTip(-1, 'Error')
$iIconQuestion = GUICtrlCreateIcon('C:\Windows\System32\user32.dll', -3, 100, 210, 32, 32)
GUICtrlSetTip(-1, 'Question')
$iIconWarning = GUICtrlCreateIcon('C:\Windows\System32\user32.dll', -2, 140, 210, 32, 32)
GUICtrlSetTip(-1, 'Warning')
$iIconInformation = GUICtrlCreateIcon('C:\Windows\System32\user32.dll', -5, 180, 210, 32, 32)
GUICtrlSetTip(-1, 'Information')
$iRadioIconNone = GUICtrlCreateRadio('', 30, 250, 13, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, 'No icon')
$iRadioIconError = GUICtrlCreateRadio('', 70, 250, 13, 17)
$iRadioIconQuestion = GUICtrlCreateRadio('', 110, 250, 13, 17)
$iRadioIconWarning = GUICtrlCreateRadio('', 150, 250, 13, 17)
$iRadioIconInformation = GUICtrlCreateRadio('', 190, 250, 13, 17)
GUICtrlCreateGroup('', -99, -99, 1, 1)

GUICtrlCreateGroup('Buttons', 10, 290, 211, 51)
$iComboButtons = GUICtrlCreateCombo('', 20, 310, 195, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWNLIST))
GUICtrlSetData(-1, $sButtonOptions, $sOK)
GUICtrlCreateGroup('', -99, -99, 1, 1)

GUICtrlCreateGroup('Default Button', 10, 350, 100, 51)
$iComboDefButton = GUICtrlCreateCombo('', 20, 370, 80, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWNLIST))
GUICtrlSetData(-1, 'First|Second|Third|Fourth', 'First')
GUICtrlCreateGroup('', -99, -99, 1, 1)

GUICtrlCreateGroup('Modality', 120, 350, 100, 51)
$iComboModality = GUICtrlCreateCombo('', 130, 370, 80, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWNLIST))
GUICtrlSetData(-1, 'Application|System|Task', 'Application')
GUICtrlCreateGroup('', -99, -99, 1, 1)

GUICtrlCreateGroup('Miscellaneous', 230, 190, 265, 241)
$iCheckboxMB_HELP = GUICtrlCreateCheckbox('Add a Help button to the message box', 240, 210, 247, 17)
GUICtrlSetTip(-1, 'Adds a Help button to the message box.' & @CRLF & 'When the user clicks the Help button or ' & @CRLF & 'presses F1, the system sends a WM_HELP ' & @CRLF & 'message to the owner.')
$iCheckboxMB_SETFOREGROUND = GUICtrlCreateCheckbox('The message box becomes the foreground window', 240, 232, 247, 37, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_MULTILINE))
$iCheckboxMB_DEFAULT_DESKTOP_ONLY = GUICtrlCreateCheckbox('Message box shows on the desktop of the interactive window station.', 240, 270, 247, 27, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_MULTILINE))
$iCheckboxMB_TOPMOST = GUICtrlCreateCheckbox('Message box has top-most attribute set', 240, 300, 247, 17)
$iCheckboxMB_RIGHT = GUICtrlCreateCheckbox('Title and text are right-justified', 240, 320, 247, 17)
$iCheckboxMB_RTLREADING = GUICtrlCreateCheckbox('Displays message and caption text using right-to-left reading order on Hebrew and Arabic systems', 240, 340, 247, 37, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_MULTILINE))
$iCheckboxMB_SERVICE_NOTIFICATION = GUICtrlCreateCheckbox('The function displays a message box on the current active desktop, even if there is no user logged on to the computer', 240, 380, 247, 47, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_MULTILINE))
GUICtrlCreateGroup('', -99, -99, 1, 1)

GUICtrlCreateGroup('Timeout(seconds)', 10, 410, 101, 51)
$iInputTimeout = GUICtrlCreateInput('0', 20, 430, 80, 21)
GUICtrlCreateUpdown(-1, BitOR($UDS_ARROWKEYS, $UDS_NOTHOUSANDS))
GUICtrlSetLimit(-1, 10000, 0)
GUICtrlCreateGroup('', -99, -99, 1, 1)

GUICtrlCreateGroup('Parent Handle', 120, 410, 101, 51)
$iInputParentHandle = GUICtrlCreateInput('', 130, 430, 81, 21)
GUICtrlCreateGroup('', -99, -99, 1, 1)

$iButtonCopyToClipboard = GUICtrlCreateButton('Copy code to clipboard', 230, 436, 120, 25)
$iButtonInsertIntoScite = GUICtrlCreateButton('Insert into SciTE', 355, 436, 90, 25)
$iButtonPreview = GUICtrlCreateButton('Preview', 450, 436, 45, 25)

GUISetState(@SW_SHOW)

$iFlags = 0
$sFlags = ''
$iPreviewFlags = 0
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $iButtonCopyToClipboard
			_GenerateFlags()
			ClipPut(_GenerateCode($sFlags))
			_Reset()
		Case $iButtonInsertIntoScite
			_GenerateFlags()
			_InsertIntoSciTE(_GenerateCode($sFlags))
			_Reset()
		Case $iButtonPreview
			_GenerateFlags()
			_Preview()
			_Reset()
	EndSwitch
WEnd

Func _Reset()
	$iFlags = 0
	$sFlags = ''
	$iPreviewFlags = 0
EndFunc

Func _GenerateCode($LsFlags = '')
	Local $sMsgBoxCode = ''
	$sMsgBoxCode &= 'MsgBox('
	If $iFlags > 1 Then
		$sMsgBoxCode &= 'BitOr(' & $LsFlags & ')'
	Else
		$sMsgBoxCode &= $LsFlags
	EndIf
	$sMsgBoxCode &= ', ' & GUICtrlRead($iInputTitle)
	$sMsgBoxCode &= ', ' & GUICtrlRead($iEditText)
	If GUICtrlRead($iInputParentHandle) <> '' Then
		$sMsgBoxCode &= ', ' & GUICtrlRead($iInputTimeout) & ', '
		$sMsgBoxCode &= GUICtrlRead($iInputParentHandle)
	ElseIf Guictrlread($iInputTimeout) <> 0 Then
		$sMsgBoxCode &= ', ' & GUICtrlRead($iInputTimeout)
	EndIf
	$sMsgBoxCode &= ')'
	Return $sMsgBoxCode
EndFunc

Func _GenerateFlags()
	If BitAND(GUICtrlRead($iRadioIconError), $GUI_CHECKED) Then
		_AddToFlags('$MB_ICONERROR', $MB_ICONERROR)
	ElseIf BitAnd(GUICtrlRead($iRadioIconQuestion), $GUI_CHECKED) Then
		_AddToFlags('$MB_ICONQUESTION', $MB_ICONQUESTION)
	ElseIf BitAnd(GUICtrlRead($iRadioIconWarning), $GUI_CHECKED) Then
		_AddToFlags('$MB_ICONWARNING', $MB_ICONWARNING)
	ElseIf BitAND(GUICtrlRead($iRadioIconInformation), $GUI_CHECKED) Then
		_AddToFlags('$MB_ICONINFORMATION', $MB_ICONINFORMATION)
	EndIf
	Switch GUICtrlRead($iComboButtons)
		Case $sOK
			_AddToFlags('')
		Case $sOKCANCEL
			_AddToFlags('$MB_OKCANCEL', $MB_OKCANCEL)
		Case $sABORTRETRYIGNORE
			_AddToFlags('$MB_ABORTRETRYIGNORE', $MB_ABORTRETRYIGNORE)
		Case $sYESNOCANCEL
			_AddToFlags('$MB_YESNOCANCEL', $MB_YESNOCANCEL)
		Case $sYESNO
			_AddToFlags('$MB_YESNO', $MB_YESNO)
		Case $sRETRYCANCEL
			_AddToFlags('$MB_RETRYCANCEL', $MB_RETRYCANCEL)
		Case $sCANCELTRYCONTINUE
			_AddToFlags('$MB_CANCELTRYCONTINUE', $MB_CANCELTRYCONTINUE)
	EndSwitch
	Switch GUICtrlRead($iComboDefButton)
		Case 'First'
			_AddToFlags('')
		Case 'Second'
			_AddToFlags('$MB_DEFBUTTON2', $MB_DEFBUTTON2)
		Case 'Third'
			_AddToFlags('$MB_DEFBUTTON3', $MB_DEFBUTTON3)
		Case 'Fourth'
			_AddToFlags('$MB_DEFBUTTON4', $MB_DEFBUTTON4)
	EndSwitch
	If BitAND(GUICtrlRead($iCheckboxMB_HELP), $GUI_CHECKED) Then _AddToFlags('$MB_HELP', $MB_HELP)
	If BitAND(GUICtrlRead($iCheckboxMB_SETFOREGROUND), $GUI_CHECKED) Then _AddToFlags('$MB_SETFOREGROUND', $MB_SETFOREGROUND)
	If BitAND(GUICtrlRead($iCheckboxMB_DEFAULT_DESKTOP_ONLY), $GUI_CHECKED) Then _AddToFlags('$MB_DEFAULT_DESKTOP_ONLY', $MB_DEFAULT_DESKTOP_ONLY)
	If BitAND(GUICtrlRead($iCheckboxMB_TOPMOST), $GUI_CHECKED) Then _AddToFlags('$MB_TOPMOST', $MB_TOPMOST)
	If BitAND(GUICtrlRead($iCheckboxMB_RIGHT), $GUI_CHECKED) Then _AddToFlags('$MB_RIGHT', $MB_RIGHT)
	If BitAND(GUICtrlRead($iCheckboxMB_RTLREADING), $GUI_CHECKED) Then _AddToFlags('$MB_RTLREADING', $MB_RTLREADING)
	If BitAND(GUICtrlRead($iCheckboxMB_SERVICE_NOTIFICATION), $GUI_CHECKED) Then _AddToFlags('$MB_SERVICE_NOTIFICATION', $MB_SERVICE_NOTIFICATION)
	Switch GUICtrlRead($iComboModality)
		Case 'Application'
			_AddToFlags('')
		Case 'System'
			_AddToFlags('$MB_SYSTEMMODAL', $MB_SYSTEMMODAL)
		Case 'Task'
			_AddToFlags('$MB_TASKMODAL', $MB_TASKMODAL)
	EndSwitch
EndFunc

Func _InsertIntoSciTE($sCode)
	If WinExists('[CLASS:SciTEWindow]') Then
		Local $sClip = ClipGet()
		ClipPut($sCode)
		ControlSend('[CLASS:SciTEWindow]', '', '[ID:350;CLASS:Scintilla]', '^v')
		ClipPut($sClip)
	Else
		MsgBox($MB_ICONERROR, 'Error', 'Cannot find SciTe window.')
	EndIf
EndFunc

Func _Preview()
	MsgBox($iPreviewFlags, GUICtrlRead($iInputTitle), GUICtrlRead($iEditText), GUICtrlRead($iInputTimeout), GUICtrlRead($iInputParentHandle))
EndFunc

Func _AddToFlags($LsFlag = '', $LiPreviewFlags = 0)
	If $LsFlag <> '' Then
		If $iFlags > 0 Then $sFlags &= ', '
		$sFlags &= $LsFlag
		$iFlags += 1
		$iPreviewFlags += $LiPreviewFlags
	EndIf
EndFunc
