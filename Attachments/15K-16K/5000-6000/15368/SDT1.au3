Global Const $GUI_EVENT_CLOSE  =  -3
Global Const $GUI_EVENT_MINIMIZE  =  -4
Global Const $GUI_CHECKED  =  1
Global Const $GUI_GR_RECT  =  10
Global Const $WS_VSCROLL  =  0x00200000
Global Const $WS_BORDER  =  0x00800000
Global Const $WS_POPUP  =  0x80000000
Global Const $WS_EX_TOOLWINDOW  =  0x00000080
Global Const $CBS_DROPDOWNLIST  =  0x0003
Global Const $CB_ERR  =  -1
Global Const $CB_FINDSTRING  =  0x14C
Global Const $CB_FINDSTRINGEXACT  =  0x158
Global Const $CB_GETLBTEXT  =  0x148
Global Const $CB_GETLBTEXTLEN  =  0x149
Global Const $CB_SETEDITSEL  =  0x142
Global Const $SS_CENTER  =  1
Global Const $SS_BLACKRECT  =  4
TraySetState(2)
_Singleton("SDT")
Opt('MustDeclareVars', 1)
Opt("TrayAutoPause",0)
Opt("TrayMenuMode",1)
Opt("ColorMode",1)
AutoItSetOption("GUICloseOnESC", 0) 
TraySetIcon("ikona.ico")
Dim $SDT, $iMsgB, $splash, $showsplash, $ssplash, $warn, $gB, $loading, $j, $warnings, $k, $pr, $pr1, $pr2, $pr3, $graphic, $graphic1, $shd, $sf, $rst, $lgf, $ret
Dim $msg, $radio, $mso, $s1, $s2, $s3, $winstart, $ShutdownNOW, $LogoffNOW, $RestartNOW, $Status, $ac, $mintray, $smtray, $properties, $ho, $mi
Dim $Group, $Group1, $action, $hours, $minutes, $execute, $old_string = "", $a, $b, $c, $d, $e, $f, $g, $cancel, $about, $exit, $timer, $timer1
GUICreate("SDT", 320, 270, (@DesktopWidth-320)/2, (@DesktopHeight-265)/2)
GUISetBkColor(0xf0f0ee)
$ShutdownNOW = GUICtrlCreateButton("Shutdown", 5, 5, 100, 35, $SS_CENTER)
$RestartNOW = GUICtrlCreateButton("Restart", 110, 5, 100, 35, $SS_CENTER)
$LogoffNOW = GUICtrlCreateButton("LogOff", 215, 5, 100, 35, $SS_CENTER)
$Group = GUICtrlCreateGroup("Set...", 5, 50, 214, 140, $SS_CENTER)
$a = GUICtrlCreateLabel("Set action :", 15, 72)
$action = GUICtrlCreateCombo("", 77, 69, 130, 93, $CBS_DROPDOWNLIST)
$b = GUICtrlCreateLabel(" Set Time (hh:mm) :", 15, 107)
$hours = GUICtrlCreateCombo("00", 115, 104, 37, 150, $CBS_DROPDOWNLIST + $WS_VSCROLL)
$c = GUICtrlCreateLabel(":", 160, 107)
$minutes = GUICtrlCreateCombo("00", 170, 104, 37, 150, $CBS_DROPDOWNLIST + $WS_VSCROLL)
$execute = GUICtrlCreateButton("Execute", 15, 145, 193, 35, $SS_CENTER)
GUICtrlCreateGroup ("Set action :",-99,-99,1,1)
$Group1 = GUICtrlCreateGroup("Options...", 5, 200, 310, 65, $SS_CENTER)
$radio = GUICtrlCreateCheckbox("Start SDT with Windows", 15, 216)
$smtray = GUICtrlCreateCheckbox("Start Minimized in Tray", 15, 240)
$ssplash = GUICtrlCreateCheckbox("Show Splash Screen", 160, 216)
$warn = GUICtrlCreateCheckbox("Warnings", 160, 240)
GUICtrlCreateGroup ("Options...",-99,-99,1,1)
GUICtrlSetBkColor($ShutdownNOW, 0xf0f0ff)
GUICtrlSetBkColor($RestartNOW, 0xf0f0ff)
GUICtrlSetBkColor($LogoffNOW, 0xf0f0ff)
GUICtrlSetBkColor($execute, 0xf0f0ff)
GUICtrlSetData($Action, "Shutdown|Restart|LogOff", "Shutdown")
RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action", "REG_SZ", GUICtrlRead($action))
$d = GUICtrlCreateLabel("Current Time :", 233, 65)
$e = GUICtrlCreateLabel(@HOUR & " : " & @MIN , 233, 85, 40)
$g = GUICtrlCreateLabel("Current Date :", 233, 145)
$f = GUICtrlCreateLabel(@MDAY & "\" & @MON & "\" & @YEAR, 233, 165, 70)
$graphic1 = GUICtrlCreateGraphic(0, 0, 320, 45, 0)
$graphic = GUICtrlCreateGraphic(226, 55, 87, 135, 0)
GUICtrlSetBkColor($graphic1, 0xffffff)
GUICtrlSetColor($graphic1, 0x777777)
GUICtrlSetGraphic($graphic, $GUI_GR_RECT)
GUICtrlSetBkColor($graphic, 0xffffff)
GUICtrlSetBkColor($d, 0xffffff)
GUICtrlSetBkColor($e, 0xffffff)
GUICtrlSetBkColor($f, 0xffffff)
GUICtrlSetBkColor($g, 0xffffff)
GUICtrlSetColor($graphic, 0x777777)
GUICtrlSetGraphic($graphic, $GUI_GR_RECT)
$showsplash = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "SSplash")
if $showsplash <> 1 Then
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "SSplash", "REG_SZ", "0")
	For $i = 0 To 59
	$sf = $sf & '|' & StringFormat("%02d", $i)
   	GUICtrlSetData($minutes, $sf, "00")
    If $i < 24 Then GUICtrlSetData($hours, $sf, "04")
	Next
Else
	GuiCtrlSetState($ssplash, $GUI_CHECKED)
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "SSplash", "REG_SZ", "1")
	$splash = GUICreate("", 360, 180, (@DesktopWidth-360)/2, (@DesktopHeight-150)/2, $WS_POPUP+$WS_BORDER, $WS_EX_TOOLWINDOW)
	GUISetBkColor(0x000000)
	$loading = GUICtrlCreateLabel("Loading Shutdown Timer by Nenad..." & @LF & @LF & "Please wait...", 10, 50, 340, 80, $SS_CENTER, $SS_BLACKRECT)
	GUICtrlSetFont($loading, 16, 400, 0, "Times New Roman")
	GUICtrlSetColor($loading, 0xf0f0ee)
	GUISetState(@SW_SHOW, $splash)
		$pr = GuiCtrlCreateGraphic(0, 0, 0, 3, 0)
		GUICtrlSetBkColor($pr,0xf0f0ee)
		GUICtrlSetGraphic($pr, $GUI_GR_RECT)
		$pr1 = GuiCtrlCreateGraphic(360, 177, 0, 3, 0)
		GUICtrlSetBkColor($pr1,0xf0f0ee)
		GUICtrlSetGraphic($pr1, $GUI_GR_RECT)
		$pr2 = GuiCtrlCreateGraphic(0, 180, 3, 0, 0)
		GUICtrlSetBkColor($pr2,0xf0f0ee)
		GUICtrlSetGraphic($pr2, $GUI_GR_RECT)
		$pr3 = GuiCtrlCreateGraphic(357, 0, 3, 0, 0)
		GUICtrlSetBkColor($pr3,0xf0f0ee)
		GUICtrlSetGraphic($pr3, $GUI_GR_RECT)
		$k = 0
		$j = 0
	For $i = 0 To 59
	$k = $k + 3
	$j = $j + 6
	GUICtrlSetPos($pr, 0, 0, $j, 3)
	GUICtrlSetPos($pr1, 360 - $j, 177, $j, 3)
	GUICtrlSetPos($pr2, 0, 180 - $k, 3, 180)
	GUICtrlSetPos($pr3, 357, 0, 3, $k)
	$sf = $sf & '|' & StringFormat("%02d", $i)
   	GUICtrlSetData($minutes, $sf, "00")
    If $i < 24 Then GUICtrlSetData($hours, $sf, "04")
	Next
	GUICtrlDelete($pr)
	GUICtrlDelete($pr1)
	GUICtrlDelete($pr2)
	GUICtrlDelete($pr3)
	GUIDelete($splash)
EndIf
$warnings = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Warnings")
$winstart = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "WStart")
$mintray = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "SMTray")
If $warnings = 0 Then
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Warnings", "REG_SZ", "0")
ElseIf $warnings = 1 Or ($warnings <> 1 And $warnings <> 0) Then
	GuiCtrlSetState($warn, $GUI_CHECKED)
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Warnings", "REG_SZ", "1")
EndIf
If $winstart <> 1 Then
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "WStart", "REG_SZ", "0")
Else
	GuiCtrlSetState($radio, $GUI_CHECKED)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Run", "SDT", "REG_SZ", @AutoItExe)
EndIf
If $mintray = 0 Then
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "SMTray", "REG_SZ", "0")
	GUISetState(@SW_SHOW)
ElseIf $mintray = 1 Or ($mintray <> 1 And $mintray <> 0) Then
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "SMTray", "REG_SZ", "1")
	GuiCtrlSetState($smtray, $GUI_CHECKED)
GUISetState(@SW_HIDE)
TraySetState (1)
			$Properties	= TrayCreateItem("Properties")
			$s1 = TrayCreateItem("")
			$about = TrayCreateItem("About")
			$s2 = TrayCreateItem("")
			$shd = TrayCreateItem("Shutdown")
			$rst = TrayCreateItem("Restart")
			$lgf = TrayCreateItem("Logoff")
			$s3 = TrayCreateItem("")
			$exit = TrayCreateItem("Exit")
			GUISetState(@SW_HIDE)
			TraySetState (1)
			While 1
				$mso = TrayGetMsg()
				Select
					Case $mso = 0
						ContinueLoop
					Case $mso = $properties
						GUISetState(@SW_SHOW)
						TrayItemDelete($properties)
						TrayItemDelete($s1)
						TrayItemDelete($about)
						TrayItemDelete($s2)
						TrayItemDelete($shd)
						TrayItemDelete($rst)
						TrayItemDelete($lgf)
						TrayItemDelete($s3)
						TrayItemDelete($exit)
						ExitLoop
					Case $mso = $about
						Msgbox(48, "About:", "Shutdown Timer by Nenad")
					Case $mso = $shd
						TrayItemDelete($properties)
						TrayItemDelete($s1)
						TrayItemDelete($about)
						TrayItemDelete($s2)
						TrayItemDelete($shd)
						TrayItemDelete($rst)
						TrayItemDelete($lgf)
						TrayItemDelete($s3)
						TrayItemDelete($exit)
						Shutdown(9)
					Case $mso = $rst
						TrayItemDelete($properties)
						TrayItemDelete($s1)
						TrayItemDelete($about)
						TrayItemDelete($s2)
						TrayItemDelete($shd)
						TrayItemDelete($rst)
						TrayItemDelete($lgf)
						TrayItemDelete($s3)
						TrayItemDelete($exit)
						Shutdown(6)
					Case $mso = $lgf
						TrayItemDelete($properties)
						TrayItemDelete($s1)
						TrayItemDelete($about)
						TrayItemDelete($s2)
						TrayItemDelete($shd)
						TrayItemDelete($rst)
						TrayItemDelete($lgf)
						TrayItemDelete($s3)
						TrayItemDelete($exit)
						Shutdown(0)
					Case $mso = $exit
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Hours", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Minutes", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action", "REG_SZ", "")
						GUIDelete()
						Exit
				EndSelect
			WEnd
		EndIf
		$timer = TimerInit()
		AdlibEnable("Timer", 500)
		Func Timer()
			ControlSetText("SDT", "", $e, @HOUR & " : " & @MIN)
			ControlSetText("SDT", "", $f, @MDAY & "\" & @MON & "\" & @YEAR)
		EndFunc
While 1
	$msg = GUIGetMsg()
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Hours", "REG_SZ", GUICtrlRead($hours))
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Minutes", "REG_SZ", GUICtrlRead($minutes))
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action", "REG_SZ", GUICtrlRead($action))

Select
	Case $msg = $execute
		$warnings = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Warnings")
		If $warnings = "1" Then 
			MsgBox(48, "SDT", "Your computer will " & GUICtrlRead($action) & " at " & GUICtrlRead($hours) & ":" &GUICtrlRead($minutes))
		EndIf
			TraySetState (1)
			$cancel	= TrayCreateItem("Cancel")
			$s1 = TrayCreateItem("")
			$shd = TrayCreateItem("Shutdown")
			$rst = TrayCreateItem("Restart")
			$lgf = TrayCreateItem("Logoff")
			$s3 = TrayCreateItem("")
			$about = TrayCreateItem("About")
			$s2 = TrayCreateItem("")
			$exit = TrayCreateItem("Exit")
			GUISetState(@SW_HIDE)
			TraySetState (1)
			While 1
				$ac = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action")
				$ho = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Hours")
				$mi = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Minutes")
				If $ho = @HOUR Then
					If $mi = @MIN Then
						$warnings = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Warnings")
						If $ac = ("Shutdown") Then
							If $warnings = "1" Then
								$gB = MsgBox(308,"SDT","Your computer will SHUT DOWN now!" & @LF & "Do You wish to proceed?", 60)
								While 1	
									Select
										Case $gB = 6 Or $gB = -1
											Shutdown(9)
											GUIDelete()
											Exit
										Case $gB = 7
											RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Hours", "REG_SZ", "")
											RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Minutes", "REG_SZ", "")
											RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action", "REG_SZ", "")
											TrayItemDelete($cancel)
											TrayItemDelete($s1)
											TrayItemDelete($about)
											TrayItemDelete($s2)
											TrayItemDelete($shd)
											TrayItemDelete($rst)
											TrayItemDelete($lgf)
											TrayItemDelete($s3)
											TrayItemDelete($exit)
											$Properties	= TrayCreateItem("Properties")
											$s1 = TrayCreateItem("")
											$shd = TrayCreateItem("Shutdown")
											$rst = TrayCreateItem("Restart")
											$lgf = TrayCreateItem("Logoff")
											$s3 = TrayCreateItem("")
											$about = TrayCreateItem("About")
											$s2 = TrayCreateItem("")
											$exit = TrayCreateItem("Exit")
											ExitLoop
									EndSelect
								WEnd
							Else
								Shutdown(9)
								GUIDelete()
								Exit
							EndIf
						ElseIf $ac = ("Restart") Then
							If $warnings = "1" Then
								$gB = MsgBox(308,"SDT","Your computer will RESTART now!" & @LF & "Do You wish to proceed?", 60)
								While 1	
									Select
										Case $gB = 6 Or $gB = -1
											Shutdown(6)
											GUIDelete()
											Exit
										Case $gB = 7
											RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Hours", "REG_SZ", "")
											RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Minutes", "REG_SZ", "")
											RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action", "REG_SZ", "")
											TrayItemDelete($cancel)
											TrayItemDelete($s1)
											TrayItemDelete($about)
											TrayItemDelete($s2)
											TrayItemDelete($shd)
											TrayItemDelete($rst)
											TrayItemDelete($lgf)
											TrayItemDelete($s3)
											TrayItemDelete($exit)
											$Properties	= TrayCreateItem("Properties")
											$s1 = TrayCreateItem("")
											$shd = TrayCreateItem("Shutdown")
											$rst = TrayCreateItem("Restart")
											$lgf = TrayCreateItem("Logoff")
											$s3 = TrayCreateItem("")
											$about = TrayCreateItem("About")
											$s2 = TrayCreateItem("")
											$exit = TrayCreateItem("Exit")
											ExitLoop
									EndSelect
								WEnd
							Else
								Shutdown(6)
								GUIDelete()
								Exit
							EndIf
						ElseIf $ac = ("LogOff") Then
							If $warnings = "1" Then
								$gB = MsgBox(308,"SDT","Your computer will LOG OFF current user now!" & @LF & "Do You wish to proceed?", 60)
								While 1	
									Select
										Case $gB = 6 Or $gB = -1
											Shutdown(0)
											GUIDelete()
											Exit
										Case $gB = 7
											RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Hours", "REG_SZ", "")
											RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Minutes", "REG_SZ", "")
											RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action", "REG_SZ", "")
											TrayItemDelete($cancel)
											TrayItemDelete($s1)
											TrayItemDelete($about)
											TrayItemDelete($s2)
											TrayItemDelete($shd)
											TrayItemDelete($rst)
											TrayItemDelete($lgf)
											TrayItemDelete($s3)
											TrayItemDelete($exit)
											$Properties	= TrayCreateItem("Properties")
											$s1 = TrayCreateItem("")
											$shd = TrayCreateItem("Shutdown")
											$rst = TrayCreateItem("Restart")
											$lgf = TrayCreateItem("Logoff")
											$s3 = TrayCreateItem("")
											$about = TrayCreateItem("About")
											$s2 = TrayCreateItem("")
											$exit = TrayCreateItem("Exit")
											ExitLoop
									EndSelect
								WEnd
							Else
								Shutdown(0)
								GUIDelete()
								Exit
							EndIf
						EndIf
					EndIf
				EndIf
				$mso = TrayGetMsg()
				Select
					Case $mso = 0
						ContinueLoop
					Case $mso = $cancel
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Hours", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Minutes", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action", "REG_SZ", "")
						GUISetState(@SW_SHOW)
						TrayItemDelete($cancel)
						TrayItemDelete($s1)
						TrayItemDelete($about)
						TrayItemDelete($s2)
						TrayItemDelete($shd)
						TrayItemDelete($rst)
						TrayItemDelete($lgf)
						TrayItemDelete($s3)
						TrayItemDelete($exit)
						ExitLoop
					Case $mso = $properties
						GUISetState(@SW_SHOW)
						TrayItemDelete($properties)
						TrayItemDelete($s1)
						TrayItemDelete($about)
						TrayItemDelete($s2)
						TrayItemDelete($shd)
						TrayItemDelete($rst)
						TrayItemDelete($lgf)
						TrayItemDelete($s3)
						TrayItemDelete($exit)
						ExitLoop
					Case $mso = $about
						Msgbox(64, "About:", "Shutdown Timer by Nenad")
					Case $mso = $shd
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Hours", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Minutes", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action", "REG_SZ", "")
						TrayItemDelete($properties)
						TrayItemDelete($s1)
						TrayItemDelete($about)
						TrayItemDelete($s2)
						TrayItemDelete($shd)
						TrayItemDelete($rst)
						TrayItemDelete($lgf)
						TrayItemDelete($s3)
						TrayItemDelete($exit)
						Shutdown(9)
					Case $mso = $rst
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Hours", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Minutes", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action", "REG_SZ", "")
						TrayItemDelete($properties)
						TrayItemDelete($s1)
						TrayItemDelete($about)
						TrayItemDelete($s2)
						TrayItemDelete($shd)
						TrayItemDelete($rst)
						TrayItemDelete($lgf)
						TrayItemDelete($s3)
						TrayItemDelete($exit)
						Shutdown(6)
					Case $mso = $lgf
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Hours", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Minutes", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action", "REG_SZ", "")
						TrayItemDelete($properties)
						TrayItemDelete($s1)
						TrayItemDelete($about)
						TrayItemDelete($s2)
						TrayItemDelete($shd)
						TrayItemDelete($rst)
						TrayItemDelete($lgf)
						TrayItemDelete($s3)
						TrayItemDelete($exit)
						Shutdown(0)
					Case $mso = $exit
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Hours", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Minutes", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action", "REG_SZ", "")
						GUIDelete()
						Exit
				EndSelect
			WEnd
		Case $msg = $GUI_EVENT_MINIMIZE
			GUISetState(@SW_HIDE)
			TraySetState (1)
			$Properties	= TrayCreateItem("Properties")
			$s1 = TrayCreateItem("")
			$about = TrayCreateItem("About")
			$s2 = TrayCreateItem("")
			$shd = TrayCreateItem("Shutdown")
			$rst = TrayCreateItem("Restart")
			$lgf = TrayCreateItem("Logoff")
			$s3 = TrayCreateItem("")
			$exit = TrayCreateItem("Exit")
			GUISetState(@SW_HIDE)
			TraySetState (1)
			While 1
				$mso = TrayGetMsg()
				Select
					Case $mso = 0
						ContinueLoop
					Case $mso = $properties
						GUISetState(@SW_SHOWNORMAL)
						TrayItemDelete($properties)
						TrayItemDelete($s1)
						TrayItemDelete($about)
						TrayItemDelete($s2)
						TrayItemDelete($shd)
						TrayItemDelete($rst)
						TrayItemDelete($lgf)
						TrayItemDelete($s3)
						TrayItemDelete($exit)
						ExitLoop
					Case $mso = $about
						Msgbox(64, "About:", "Shutdown Timer by Nenad")
					Case $mso = $exit
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Hours", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Minutes", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action", "REG_SZ", "")
						GUIDelete()
						Exit
				EndSelect
			WEnd
		Case $msg = $smtray
			$mintray = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "SMTray")
			If $mintray = "1" Then
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "SMTray", "REG_SZ", "0")
			Else
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "SMTray", "REG_SZ", "1")
			EndIf
		Case $msg = $radio
			$winstart = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "WStart")
			if $winstart = "1" Then
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "WStart", "REG_SZ", "0")
				RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Run", "SDT")
			Else
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "WStart", "REG_SZ", "1")
				RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Run", "SDT", "REG_SZ", @AutoItExe)
			EndIf
		Case $msg = $ssplash
			$showsplash = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "SSplash")
			if $showsplash = "1" Then
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "SSplash", "REG_SZ", "0")
			Else
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "SSplash", "REG_SZ", "1")
			EndIf

		Case $msg = $warn
			$warnings = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Warnings")
			if $warnings = "1" Then
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Warnings", "REG_SZ", "0")
			Else
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Warnings", "REG_SZ", "1")
			EndIf	
		Case $msg = $ShutdownNOW
			Shutdown(9)
		Case $msg = $RestartNOW
			Shutdown(6)
		Case $msg = $LogoffNOW
			Shutdown(0)
		Case $msg = $GUI_EVENT_CLOSE
		$warnings = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Warnings")
		If $warnings = "1" Then
			$iMsgB = MsgBox(52,"SDT","Do you want to quit SDT?" & @LF & "If you have any task scheduled, it will be canceled if you quit now.")
			While 1	
				Select
					Case $iMsgB = 6
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Hours", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Minutes", "REG_SZ", "")
						RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SDT", "Action", "REG_SZ", "")
						GUIDelete()
						Exit
					Case $iMsgB = 7
						ExitLoop
				EndSelect
			WEnd
		Else
			GUIDelete()
			Exit
		EndIf
		Case $msg = $Action
			_GUICtrlComboAutoComplete ($action, $old_string)
		Case $msg = $hours
			_GUICtrlComboAutoComplete ($hours, $old_string)
		Case $msg = $minutes
			_GUICtrlComboAutoComplete ($minutes, $old_string)
	EndSelect
WEnd
GUIDelete()
Exit

Func _GUICtrlComboAutoComplete($h_combobox, ByRef $s_text, $s_WTitle = "", $s_WText = "")
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, 0)
	Local $ret, $s_inputtext, $s_data
	If _IsPressed('08') Then
		$s_text = GUICtrlRead($h_combobox)
	Else
		If IsHWnd($h_combobox) Then
			If $s_text <> ControlGetText($s_WTitle, $s_WText, $h_combobox) Then
				$s_data = ControlGetText($s_WTitle, $s_WText, $h_combobox)
				$ret = _GUICtrlComboFindString($h_combobox, $s_data)
				If ($ret <> $CB_ERR) Then
					_GUICtrlComboGetLBText($h_combobox, $ret, $s_inputtext)
					ControlSetText($s_WTitle, $s_WText, $h_combobox, $s_inputtext)
					_GUICtrlComboSetEditSel($h_combobox, StringLen($s_data), StringLen(ControlGetText($s_WTitle, $s_WText, $h_combobox)))
				EndIf
				$s_text = ControlGetText(WinGetTitle(""), "", $h_combobox)
			EndIf
		Else
			If $s_text <> GUICtrlRead($h_combobox) Then
				$s_data = GUICtrlRead($h_combobox)
				$ret = _GUICtrlComboFindString($h_combobox, $s_data)
				If ($ret <> $CB_ERR) Then
					_GUICtrlComboGetLBText($h_combobox, $ret, $s_inputtext)
					GUICtrlSetData($h_combobox, $s_inputtext)
					_GUICtrlComboSetEditSel($h_combobox, StringLen($s_data), StringLen(GUICtrlRead($h_combobox)))
				EndIf
				$s_text = GUICtrlRead($h_combobox)
			EndIf
		EndIf
	EndIf
EndFunc
Func _Singleton($occurenceName, $flag = 0)
	Local $ERROR_ALREADY_EXISTS = 183
	$occurenceName = StringReplace($occurenceName, "\", "")
	Local $handle = DllCall("kernel32.dll", "int", "CreateMutex", "int", 0, "long", 1, "str", $occurenceName)
	Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
	If $lastError[0] = $ERROR_ALREADY_EXISTS Then
		If $flag = 0 Then
			Exit -1
		Else
			SetError($lastError[0])
			Return 0
		EndIf
	EndIf
	Return $handle[0]
EndFunc
Func _IsClassName($h_hWnd, $s_ClassName)
	If Not IsHWnd($h_hWnd) Then $h_hWnd = GUICtrlGetHandle($h_hWnd)
	Local $aResult = DllCall("user32.dll", "int", "GetClassNameA", "hwnd", $h_hWnd, "str", "", "int", 256)
	If @error Then Return SetError(@error, @error, "")
	If IsArray($aResult) Then
		If StringUpper(StringMid($aResult[2], 1, StringLen($s_ClassName))) = StringUpper($s_ClassName) Then
			Return 1
		Else
			Return 0
		EndIf
	Else
		Return SetError(-1, -1, 0)
	EndIf
EndFunc
Func _IsPressed($s_hexKey, $v_dll = 'user32.dll')
	Local $a_R = DllCall($v_dll, "int", "GetAsyncKeyState", "int", '0x' & $s_hexKey)
	If Not @error And BitAND($a_R[0], 0x8000) = 0x8000 Then Return 1
	Return 0
EndFunc
Func _GUICtrlComboFindString($h_combobox, $s_search, $i_exact = 0)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		If ($i_exact) Then
			Return _SendMessage($h_combobox, $CB_FINDSTRINGEXACT, -1, $s_search, 0, "int", "str")
		Else
			Return _SendMessage($h_combobox, $CB_FINDSTRING, -1, $s_search, 0, "int", "str")
		EndIf
	Else
		If ($i_exact) Then
			Return GUICtrlSendMsg($h_combobox, $CB_FINDSTRINGEXACT, -1, $s_search)
		Else
			Return GUICtrlSendMsg($h_combobox, $CB_FINDSTRING, -1, $s_search)
		EndIf
	EndIf
EndFunc
Func _GUICtrlComboGetLBText($h_combobox, $i_index, ByRef $s_text)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	Local $len = _GUICtrlComboGetLBTextLen($h_combobox, $i_index)
	
	$s_text = ""
	Local $ret, $struct = DllStructCreate("char[" & $len + 1 & "]")
	If Not IsHWnd($h_combobox) Then $h_combobox = GUICtrlGetHandle($h_combobox)
	$ret = DllCall("user32.dll", "int", "SendMessageA", "hwnd", $h_combobox, "int", $CB_GETLBTEXT, "int", $i_index, "ptr", DllStructGetPtr($struct))
	If ($ret[0] == $CB_ERR) Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	$s_text = DllStructGetData($struct, 1)
	Return $ret
EndFunc
Func _GUICtrlComboSetEditSel($h_combobox, $i_start, $i_stop)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_SETEDITSEL, 0, $i_stop * 65536 + $i_start)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_SETEDITSEL, 0, $i_stop * 65536 + $i_start)
	EndIf
EndFunc
Func _SendMessage($h_hWnd, $i_msg, $wParam = 0, $lParam = 0, $i_r = 0, $s_t1 = "int", $s_t2 = "int")
	Local $a_ret = DllCall("user32.dll", "long", "SendMessage", "hwnd", $h_hWnd, "int", $i_msg, $s_t1, $wParam, $s_t2, $lParam)
	If @error Then Return SetError(@error, @extended, "")
	If $i_r >= 0 And $i_r <= 4 Then Return $a_ret[$i_r]
	Return $a_ret
EndFunc
Func _GUICtrlComboGetLBTextLen($h_combobox, $i_index)
	If Not _IsClassName ($h_combobox, "ComboBox") Then Return SetError($CB_ERR, $CB_ERR, $CB_ERR)
	If IsHWnd($h_combobox) Then
		Return _SendMessage($h_combobox, $CB_GETLBTEXTLEN, $i_index)
	Else
		Return GUICtrlSendMsg($h_combobox, $CB_GETLBTEXTLEN, $i_index, 0)
	EndIf
EndFunc
