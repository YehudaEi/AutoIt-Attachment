#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <SendMessage.au3>
#include <Misc.au3>

Opt("GUIOnEventMode", 1)
#NoTrayIcon
#region ;;;GUI starts here;;;;
$hGUI_Main = GUICreate("Resource Manager", 448, 603, 192, 124)
GUISetOnEvent($GUI_EVENT_CLOSE, "MainGUIClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1Minimize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1Restore")
$List1 = GUICtrlCreateList("", 0, 0, 446, 565)
$Options = GUICtrlCreateButton("SHOW OPTIONS", 5, 568, 305, 33)
GUICtrlSetOnEvent(-1, "OptionsClick")
$Options = GUICtrlCreateButton("REFRESH", 350, 568, 65, 33)
GUICtrlSetOnEvent(-1, "RefreshClick")
$cDrop_Dummy = GUICtrlCreateDummy()
GUICtrlSetOnEvent(-1, "_On_Drop")
Global $aDrop_List
Global $List1Data
GUISetState(@SW_SHOW)
#endregion ;;;;;GUI ends here;;;;;6
GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND")
; Register $WM_DROPFILES function to detect drops anywhere on the GUI <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
GUIRegisterMsg(0x233, "On_WM_DROPFILES") ; $WM_DROPFILES

Global $List1Data
Global $WinTitle = WinGetTitle('[CLASS:SciTEWindow]')
Local $sFilePath = StringRegExpReplace($WinTitle, '^(\V+)(?:\h[-*]\V+)$', '\1')
_FileReadToArray($sFilePath & "_res.txt", $List1Data)
$ListDef = _ArrayToString($List1Data)
GUICtrlSetData($List1, $ListDef)

While 1
	Sleep(10)
WEnd

Func MainGUIClose()
	Exit
EndFunc

Func RefreshClick()
	GUICtrlSetData($List1, "")
	Local $sFilePath = StringRegExpReplace($WinTitle, '^(\V+)(?:\h[-*]\V+)$', '\1')
	_FileReadToArray($sFilePath & "_res.txt", $List1Data)
	$ListDef = _ArrayToString($List1Data)
	GUICtrlSetData($List1, $ListDef)
EndFunc

Func OptionsClick()
	$hGUI = GUICreate("RM Options", 375, 376, 300, 124, Default, $WS_EX_ACCEPTFILES)
	GUISetOnEvent($GUI_EVENT_CLOSE, "OptionsClose")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1Minimize")
	GUISetOnEvent($GUI_EVENT_RESTORE, "Form1Restore")
	Global $List2 = GUICtrlCreateList("", 0, -1, 283, 381, $LBS_EXTENDEDSEL)
	Global $bDeleteSel = GUICtrlCreateButton("Delete Selection", 285, 40, 89, 33)
	GUICtrlSetOnEvent(-1, "DelSel")
	Global $bClearAll = GUICtrlCreateButton("Clear All", 299, 88, 73, 33)
	GUICtrlSetOnEvent(-1, "ClearAll")
	Global $bGenerate = GUICtrlCreateButton("Generate", 315, 320, 57, 41)
	GUICtrlSetOnEvent(-1, "GenerateProf")
	Global $Label1 = GUICtrlCreateLabel("Edit Resource List", 285, 8, 90, 17)
	Global $Label2 = GUICtrlCreateLabel("Generate", 320, 264, 48, 17)
	Global $Label3 = GUICtrlCreateLabel("Resource Profile", 295, 288, 82, 17)
	Global $cDrop_Dummy = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, "_On_Drop")
	Global $aDrop_List
	GUISetState(@SW_SHOW)
EndFunc

#region ;;;;Options Functions begin here;;;;;
Func _On_Drop() ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    For $i = 1 To $aDrop_List[0]
        GUICtrlSetData($List2, $aDrop_List[$i])
    Next
EndFunc   ;==>_On_Drop

; React to items dropped on the GUI <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Func On_WM_DROPFILES($hWnd, $iMsg, $wParam, $lParam)
    ; Credit to ProgAndy for DLL calls
    #forceref $hWnd, $iMsg, $lParam
    Local $iSize, $pFileName
    ; Get number of files dropped
    Local $aRet = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 0)
    ; Reset array to correct size
    Global $aDrop_List[$aRet[0] + 1] = [$aRet[0]]
    ; And add item names
    For $i = 0 To $aRet[0] - 1
        $aRet = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
        $iSize = $aRet[0] + 1
        $pFileName = DllStructCreate("wchar[" & $iSize & "]")
        DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $iSize)
        $aDrop_List[$i + 1] = DllStructGetData($pFileName, 1)
        $pFileName = 0
    Next
    ; Send the count to trigger the drop function in the main loop
    GUICtrlSendToDummy($cDrop_Dummy, $aDrop_List[0])
EndFunc   ;==>On_WM_DROPFILES

Func DelSel()
    Local $a_SelectedItems = _GUICtrlListBox_GetSelItems($List2)
    For $i = $a_SelectedItems[0] To 1 Step -1
        _GUICtrlListBox_DeleteString($List2, $a_SelectedItems[$i])
    Next
EndFunc

Func ClearAll()
    GUICtrlSetData($List2, "")
EndFunc

Func GenerateProf()
    $FileCount = _GUICtrlListBox_GetCount($List2)
    Global $FileList[$FileCount + 1]
    For $i = 0 To $FileCount
        $FileList[$i] = _GUICtrlListBox_GetText($List2, $i)
    Next
    _ArrayDelete($FileList, $i)
	_FileWriteFromArray($sFilePath & "_res.txt", $FileList)
EndFunc

Func OptionsClose()
	GUIDelete("RM Options")
EndFunc

Func Form1Minimize()

EndFunc

Func Form1Restore()

EndFunc

Func _SciTE_InsertText($sString)
    $sString = StringReplace($sString, '\', '\\')
    _SciTE_ReplaceMarcos($sString)
    Return _SciTE_Send_Command(0, _SciTE_WinGetDirector(), 'insert:' & $sString)
EndFunc   ;==>_SciTE_InsertText

Func _SciTE_ReplaceMarcos(ByRef $sString)
    $sString = StringReplace($sString, @TAB, '\t')
    $sString = StringReplace($sString, @CR, '\r')
    $sString = StringReplace($sString, @LF, '\n')
EndFunc   ;==>_SciTE_ReplaceMarcos

Func _SciTE_WinGetDirector()
    Return WinGetHandle('DirectorExtension')
EndFunc   ;==>_SciTE_WinGetDirector

Func _SciTE_Send_Command($hHandle, $hSciTE, $sString)
	Local $ilParam, $tData
	If StringStripWS($sString, 8) = "" Then
		Return SetError(2, 0, 0) ; String is blank.
	EndIf
	$sString = ":" & Dec(StringTrimLeft($hHandle, 2)) & ":" & $sString
	$tData = DllStructCreate("char[" & StringLen($sString) + 1 & "]") ; wchar
	DllStructSetData($tData, 1, $sString)
	$ilParam = DllStructCreate("ptr;dword;ptr") ; ulong_ptr;dword;ptr
	DllStructSetData($ilParam, 1, 1) ; $ilParam, 1, 1
	DllStructSetData($ilParam, 2, DllStructGetSize($tData))
	DllStructSetData($ilParam, 3, DllStructGetPtr($tData))
	_SendMessage($hSciTE, $WM_COPYDATA, $hHandle, DllStructGetPtr($ilParam))
	Return Number(Not @error)
EndFunc   ;==>_SciTE_Send_Command
#endregion ;;;;;Options Functions end here;;;;;

;;;;dbl click read;;;
Func _WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)

    #forceref $hWnd, $iMsg, $lParam

    $iIDFrom = BitAND($wParam, 0xFFFF) ; Low Word
    $iCode = BitShift($wParam, 16) ; Hi Word

    Switch $iCode
        Case $LBN_DBLCLK
            Switch $iIDFrom
				Case $List1
					$QMark= Chr(34)
                    $sData = GUICtrlRead($List1) ; Use the native function

					_SciTE_InsertText($QMark & $sData & $QMark)
            EndSwitch
    EndSwitch

EndFunc
