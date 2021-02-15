#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <GUIListBox.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <ButtonConstants.au3>

Opt('MustDeclareVars', 1)

$Debug_LB = False ; Check ClassName being passed to ListBox functions, set to True and use a handle to another control to see it work

Global $aItems[9] = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
Global $hListBox
Global $Button_Ok

_Main("My List Box", $aItems)

Func _Main($sTitle,$aItems)
	Local $hGUI, $sMsg


	; Create GUI
	$hGUI = GUICreate($sTitle, 400, 194)
	;$hListBox = _GUICtrlListBox_Create($hGUI, "", 2, 2, 396, 296)
	$hListBox = _GUICtrlListBox_Create($hGUI, "", 2, 2, 200, 200)
	GUICtrlCreateLabel("Please select the computer name on the right.",240,60,150,100)
	$Button_Ok = GUICtrlCreateButton("Ok",250,100,100)

	GUISetState()
	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

	; Add files
	_GUICtrlListBox_BeginUpdate($hListBox)
	_GUICtrlListBox_ResetContent($hListBox)
	_GUICtrlListBox_InitStorage($hListBox, 100, 4096)
	For $i = 0 to 8
		_GUICtrlListBox_AddString($hListBox, $aItems[$i])
	Next
	_GUICtrlListBox_EndUpdate($hListBox)

	; Pre-select the first item in the list
	_GUICtrlListBox_ClickItem($hListBox,0)


	; Loop until user exits
	Do
		Switch $sMsg
			Case $Button_Ok
				Exit
		EndSwitch
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>_Main

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $hWndFrom, $iCode, $hWndListBox
	If Not IsHWnd($hListBox) Then $hWndListBox = GUICtrlGetHandle($hListBox)
	$hWndFrom = $ilParam
	;$iIDFrom = BitAND($iwParam, 0xFFFF) ; Low Word
	$iCode = BitShift($iwParam, 16) ; Hi Word

	If GUIGetMsg() = $Button_Ok Then
		MsgBox(0, "My List Box Results", "You pressed the Ok Button")
	EndIf

	Switch $hWndFrom
		Case $hListBox, $hWndListBox
			Switch $iCode
				Case $LBN_DBLCLK ; Sent when the user double-clicks a string in a list box
					MsgBox(0, "ListBox Test", "You selected: " & $aItems[_GUICtrlListBox_GetCurSel($hListBox)])
				Case $LBN_SELCHANGE ; Sent when the selection in a list box has changed
			EndSwitch
	EndSwitch
	; Proceed the default Autoit3 internal message commands.
	; You also can complete let the line out.
	; !!! But only 'Return' (without any value) will not proceed
	; the default Autoit3-message in the future !!!
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND
