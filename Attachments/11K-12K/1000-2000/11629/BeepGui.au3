#include <GuiConstants.au3>
#include <GuiStatusbar.au3>

Global Const $DebugIt = 1
Global Const $WM_COMMAND = 0x0111
Global Const $WM_COPYDATA = 0x4A
Global $List_Func, $List_Var, $StatusBar

_Main()

Func _Main()
	If Not ProcessExists("SciTe.exe") Then 
		$Scite = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SciTE4Autoit3","DisplayIcon")
		Run($Scite)
	EndIf
	$gui = GUICreate("Beep Gui", 210, 200, @DesktopWidth - 215, 0, BitOR($WS_THICKFRAME, $WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
	WinSetOnTop($gui, "", 1)
	$List_Func = GUICtrlCreateList("", 10, 10, 90, 120, BitOR($WS_BORDER, $WS_VSCROLL))
	$s_text = "_R"
	For $x = 1 To 88
		$s_text &= "|_" & $x
	Next
	GUICtrlSetData($List_Func, $s_text)
	$List_Var = GUICtrlCreateList("", 110, 10, 90, 120, BitOR($WS_BORDER, $WS_VSCROLL))
	$s_text = ""
	For $x = 100 To 1500 Step 50
		$s_text &= "|" & $x
	Next
	GUICtrlSetData($List_Var, $s_text)
	$btn_measure = GUICtrlCreateButton("Measure", 10, 130, 90, 20)
	$btn_staff = GUICtrlCreateButton("Full Line Of Staff", 110, 130, 90, 20)
	$btn_send = GUICtrlCreateButton("Copy", 10, 160, 90, 20)
	$btn_quit = GUICtrlCreateButton("Quit", 110, 160, 90, 20)
	$StatusBar = _GUICtrlStatusBarCreate($gui, -1, "")
	_GUICtrlStatusBarSetSimple($StatusBar)
	GUISetState(@SW_SHOW, $gui)
	GUIRegisterMsg($WM_COMMAND, "MY_WM_COMMAND")
	ConsoleWrite("Here" & @LF)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $btn_quit
				Exit
			Case $btn_send
				_InsertIntoScite(GUICtrlRead($List_Func) & "(" & GUICtrlRead($List_Var) & ")" & @CRLF)
			Case $btn_measure
				_InsertIntoScite(";-------- Measure ----------" & @CRLF)
			Case $btn_staff
				_InsertIntoScite(";--- Full Line Of Staff ----" & @CRLF)
		EndSwitch
	WEnd
EndFunc   ;==>_Main

Func List_Func_SelChange()
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then _DebugPrint("$LBN_DBLCLK: " & GUICtrlRead($List_Func))
	;----------------------------------------------------------------------------------------------
	_GUICtrlStatusBarSetText($StatusBar, GUICtrlRead($List_Func) & "(" & GUICtrlRead($List_Var) & ")", $SB_SIMPLEID)
EndFunc   ;==>List_Func_SelChange

Func List_Var_SelChange()
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then _DebugPrint("$LBN_DBLCLK: " & GUICtrlRead($List_Var))
	;----------------------------------------------------------------------------------------------
	_GUICtrlStatusBarSetText($StatusBar, GUICtrlRead($List_Func) & "(" & GUICtrlRead($List_Var) & ")", $SB_SIMPLEID)
EndFunc   ;==>List_Var_SelChange

Func MY_WM_COMMAND($hWnd, $msg, $wParam, $lParam)
	Local $nNotifyCode = _HiWord($wParam)
	Local $nID = _LoWord($wParam)
	Local $hCtrl = $lParam
	Local Const $LBN_ERRSPACE = (-2);
	Local Const $LBN_SELCHANGE = 1;
	Local Const $LBN_DBLCLK = 2;
	Local Const $LBN_SELCANCEL = 3;
	Local Const $LBN_SETFOCUS = 4;
	Local Const $LBN_KILLFOCUS = 5;

	Switch $nID
		Case $List_Func
			Switch $nNotifyCode
				Case $LBN_SELCHANGE
					List_Func_SelChange()
			EndSwitch
		Case $List_Var
			Switch $nNotifyCode
				Case $LBN_SELCHANGE
					List_Var_SelChange()
			EndSwitch
	EndSwitch
	; Proceed the default Autoit3 internal message commands.
	; You also can complete let the line out.
	; !!! But only 'Return' (without any value) will not proceed
	; the default Autoit3-message in the future !!!
	Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_COMMAND

Func _DebugPrint($s_text)
	$s_text = StringReplace($s_text, @LF, @LF & "-->")
	ConsoleWrite("!===========================================================" & @LF & _
			"+===========================================================" & @LF & _
			"-->" & $s_text & @LF & _
			"+===========================================================" & @LF)
EndFunc   ;==>_DebugPrint


Func _HiWord($x)
	Return BitShift($x, 16)
EndFunc   ;==>_HiWord

Func _LoWord($x)
	Return BitAND($x, 0xFFFF)
EndFunc   ;==>_LoWord

Func _InsertIntoScite($DataToInsert)
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then _DebugPrint('_InsertIntoScite-->' & $DataToInsert)
	;----------------------------------------------------------------------------------------------
	Opt("WinSearchChildren", 1)
	Local $Scite_hwnd = WinGetHandle("DirectorExtension")
	$DataToInsert = StringReplace($DataToInsert, "\", "\\")
	$DataToInsert = StringReplace($DataToInsert, @TAB, "\t")
	$DataToInsert = StringReplace($DataToInsert, @CRLF, "\r\n")
	_SciTE_Send_Command(0, $Scite_hwnd, "insert:" & $DataToInsert)
EndFunc   ;==>_InsertIntoScite

;
; Send command to SciTE
Func _SciTE_Send_Command($My_Hwnd, $Scite_hwnd, $sCmd)
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then _DebugPrint('_SciTE_Send_Command-->' & $sCmd)
	;----------------------------------------------------------------------------------------------
	Local $CmdStruct = DllStructCreate('Char[' & StringLen($sCmd) + 1 & ']')
	If @error Then Return
	DllStructSetData($CmdStruct, 1, $sCmd)
	Local $COPYDATA = DllStructCreate('Ptr;DWord;Ptr')
	DllStructSetData($COPYDATA, 1, 1)
	DllStructSetData($COPYDATA, 2, StringLen($sCmd) + 1)
	DllStructSetData($COPYDATA, 3, DllStructGetPtr($CmdStruct))
	DllCall('User32.dll', 'None', 'SendMessage', 'HWnd', $Scite_hwnd, _
			'Int', $WM_COPYDATA, 'HWnd', $My_Hwnd, _
			'Ptr', DllStructGetPtr($COPYDATA))
	$CmdStruct = 0
EndFunc   ;==>_SciTE_Send_Command