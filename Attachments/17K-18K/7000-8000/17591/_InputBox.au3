$hWnd = WinGetHandle(WinGetTitle(""))

$Ret = _InputBox("InputBox demo", "Type password... " & @LF & "[Only Numbers are allowed]" & @LF & "[Maximum 8 Numbers]", _
	"", $hWnd, 1, 1, 8, -1, 220, -1, -1, 0, 0x00000008, 40)

If Not @error And $Ret <> "" Then MsgBox(262144+64, "Returned value", "You type <" & $Ret & ">", 20)
If @error = 2 And $Ret <> "" Then MsgBox(262144+64, "Returned value", "Time is out, here is what are you typed <" & $Ret & ">", 20)

Func _InputBox($Title,$Promt,$Default="",$hWnd=0,$IsPassword=0,$IsDigits=0,$Limit=-1,$Width=-1,$Height=-1,$Left=-1,$Top=-1,$Style=0,$exStyle=0,$Timeout=0)
	Local $OldOpt = Opt("GuiOnEventMode", 0)
	WinSetState($hWnd, "", @SW_DISABLE)
	If $Width < 200 Then $Width = 200
	If $Height < 150 Then $Height = 150
	
	Local $InputGui, $OKButton, $CancelButton, $InputBoxID, $Msg, $GuiCoords, $RetValue, $RetErr=0, $InputMsg, $TimerStart
	
	$InputGui = GUICreate($Title, $Width, $Height, $Left, $Top, 0x00040000+$Style, $exStyle, $hWnd)
	
	GUICtrlCreateLabel($Promt, 15, 5, $Width, -1)
	GUICtrlSetResizing(-1, 256+512)
	GUIRegisterMsg(0x24, "MY_WM_GETMINMAXINFO")
	
	$OKButton = GUICtrlCreateButton("OK", ($Width/2)-70, $Height-95, 60, 25)
	GUICtrlSetResizing(-1, 0x0240)
	GUICtrlSetState(-1, 2048)
	GUICtrlSetState(-1, 512)
	$CancelButton = GUICtrlCreateButton("Cancel", ($Width/2)+10, $Height-95, 60, 25)
	GUICtrlSetResizing(-1, 0x0240)
	GUICtrlSetState(-1, 2048)
	
	If $IsPassword <> 0 Then $IsPassword = 32
	If $IsDigits <> 0 Then $IsDigits = 8192
	$InputBoxID = GUICtrlCreateInput($Default, 20, $Height-60, $Width-40, 20, $IsPassword+$IsDigits+128, 0x00000001)
	GUICtrlSetResizing(-1, 0x0240)
	GUICtrlSetState(-1, 256)
	If $Limit <> -1 Then GUICtrlSetLimit(-1, $Limit)
	
	GUISetState(@SW_SHOW, $InputGui)
	If $Timeout > 0 Then $TimerStart = TimerInit()
	
	While 1
		$InputMsg = GUIGetMsg()
		Switch $InputMsg
			Case -12
				ControlFocus($InputGui, "", $OKButton)
				ControlFocus($InputGui, "", $CancelButton)
			Case -3, $CancelButton
				$RetValue = ""
				$RetErr = 1
				ExitLoop
			Case $OKButton
				$RetValue = GUICtrlRead($InputBoxID)
				$RetErr = 0
				ExitLoop
		EndSwitch
		
		If $Timeout > 0 And Round(TimerDiff($TimerStart)/1000) = $Timeout Then
			$RetValue = GUICtrlRead($InputBoxID)
			$RetErr = 2
			ExitLoop
		EndIf
	WEnd
	WinSetState($hWnd, "", @SW_ENABLE)
	GUIDelete($InputGui)
	GUISwitch($hWnd)
	Opt("GuiOnEventMode", $OldOpt)
	Return SetError($RetErr, 0, $RetValue)
EndFunc

Func MY_WM_GETMINMAXINFO($hWnd, $Msg, $wParam, $lParam)
	Local $MinMaxInfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int",$lParam)
	Local $MINGuiX = 200, $MINGuiY = 150, $MAXGuiX = 400, $MAXGuiY = 300
	DllStructSetData($MinMaxInfo, 7, $MINGuiX) ; Min X
	DllStructSetData($MinMaxInfo, 8, $MINGuiY) ; Min Y
	DllStructSetData($MinMaxInfo, 9, $MAXGuiX) ; Max X
	DllStructSetData($MinMaxInfo, 10, $MAXGuiY) ; Max Y
	Return 0
EndFunc
