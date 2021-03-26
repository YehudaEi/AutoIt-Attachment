
	Func guiLaunch()
		Global $mainGui = GUICreate("Second Window", 450, 500, -1, -1, BitXOR($WS_SYSMENU, $WS_MINIMIZEBOX))
		GUICtrlCreatePic($morronicLogo, 200, 13, 312, 150)
		GUISetState(@SW_SHOW)

		;StatusBar setup at the bottom
		$StatusBar = _GUICtrlStatusBar_Create($mainGui)
		Dim $StatusBar_PartsWidth[3] = [150, 450, -1]
		_GUICtrlStatusBar_SetParts($StatusBar, $StatusBar_PartsWidth)
		_GUICtrlStatusBar_SetText($StatusBar, @ComputerName, 0)
		_GUICtrlStatusBar_SetText($StatusBar, @TAB & $1 & $cpu, 1)
		_GUICtrlStatusBar_SetText($StatusBar, @TAB & $ip, 2)
		_GUICtrlStatusBar_SetMinHeight($StatusBar, 25)

		While 1
			$msg = GUIGetMsg()
			Switch $msg
				Case $Gui_Event_Close
					MsgBox(0, "", "See how the $1 and $cpu variables show up as" & @CR & "not declared in SciTe, I can't fix it")
					Exit
			EndSwitch
		WEnd
	EndFunc
