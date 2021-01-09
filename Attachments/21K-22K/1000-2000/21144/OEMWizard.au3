#include <GUIConstantsEx.au3>

Global $OS = @OSVersion, $TempIni = @ScriptDir & '\oembrand_inf.ini', $INI = @SystemDir & '\oeminfo.ini'
Global Const $ES_NUMBER = 0x2000
; Vista Structures
Global $Struct = DllStructCreate("int cxLeftWidth;int cxRightWidth;int cyTopHeight;int cyBottomHeight;")
Global $Area[4] = [0, 0, 0, 45]

If $OS = "WIN_VISTA" Then
	$GUI = GUICreate("OEM Branding Wizard", 420, 430)
Else
	$GUI = GUICreate("OEM Branding Wizard", 420, 390)
EndIf
$_File = GUICtrlCreateMenu("File")
$_SaveSettings = GUICtrlCreateMenuItem("Save current settings", $_File)
$_CreateTempINI = GUICtrlCreateMenuItem("Create temporary settings", $_File)
GUICtrlCreateMenuItem("", $_File)
$_Exit = GUICtrlCreateMenuItem("Exit", $_File)
$_Options = GUICtrlCreateMenu("Options")
$_DeleteCurrentINI = GUICtrlCreateMenuItem("Delete current OS INI information", $_Options)
$_DeleteTempINI = GUICtrlCreateMenuItem("Delete temp INI information", $_Options)
GUICtrlCreateMenuItem("", $_Options)
$_LoadOEMINI = GUICtrlCreateMenuItem("Load OEM INI information", $_Options)
$_LoadTempINI = GUICtrlCreateMenuItem("Load temp INI information", $_Options)
$_About = GUICtrlCreateMenu("About")
$_Info = GUICtrlCreateMenuItem("About OEM Branding Wizard!", $_About)

If $OS = "WIN_VISTA" Then
	GUICtrlCreateLabel("", 0, 365, 420, 100)
	GUICtrlSetBkColor(-1, 0x000000)
EndIf

$UseOEMLogo = GUICtrlCreateCheckbox("Use OEM logo?", 200, 10)
$OEMLogo = GUICtrlCreatePic(@ScriptDir & '\oemlogo.bmp', 10, 10, 182, 144)
GUICtrlCreateLabel("OEM Logo Location:", 200, 30)
$OEMLogo_Locate = GUICtrlCreateInput("", 200, 44, 215, 19)
$OEMLogo_SetLocate = GUICtrlCreateButton("Find Logo", 200, 64)
GUICtrlSetState($OEMLogo_Locate, $GUI_DISABLE)
GUICtrlSetState($OEMLogo_SetLocate, $GUI_DISABLE)
$OEMLogo_KeepOriginal = GUICtrlCreateCheckbox("Keep original OEM logo?", 200, 88)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateLabel("Removes current OEM logo!", 216, 109, 220)
GUICtrlSetFont(-1, Default, 800)
GUICtrlSetColor(-1, 0xCC3300)

GUICtrlCreateLabel("Manufacturer Name:", 10, 170)
$Man_Info = GUICtrlCreateInput(@ScriptName, 10, 185, 185)
GUICtrlCreateLabel("Model:", 10, 210)
$Mod_Info = GUICtrlCreateInput(Random(1, 4, 1) & "." & Random(1, 10, 1) & "." & Random(1, 4, 1) & "." & Random(1, 15, 1), 10, 225, 185)

$Use_SupportInfo = GUICtrlCreateCheckbox("Use support info?", 220, 164, 185)
GUICtrlSetState(-1, $GUI_CHECKED)
If $OS = "WIN_VISTA" Then
	$Support_Hours = GUICtrlCreateInput("", 220, 185, 185, 21, $ES_NUMBER)
	$Support_Phone = GUICtrlCreateInput("", 220, 210, 185, 21, $ES_NUMBER)
	$Support_URL = GUICtrlCreateInput("", 220, 235, 185, 21)
	GUICtrlSetPos($OEMLogo, 10, 10, 96, 96)
Else
	$SupportInfo_Line1 = GUICtrlCreateInput("", 220, 185)
	$SupportInfo_Line2 = GUICtrlCreateInput("", 220, 210)
	$SupportInfo_Line3 = GUICtrlCreateInput("", 220, 235)
	$SupportInfo_Line4 = GUICtrlCreateInput("", 220, 260)
	$SupportInfo_Line5 = GUICtrlCreateInput("", 220, 285)
	$SupportInfo_Line6 = GUICtrlCreateInput("", 220, 310)
	$SupportInfo_Line7 = GUICtrlCreateInput("", 220, 335)
EndIf

GUICtrlCreateLabel("Save Settings:", 10, 260)
$_SaveOEM = GUICtrlCreateButton("Save OEM Branding", 10, 275)
$_TempOEM = GUICtrlCreateButton("Create temporary OEM info", 10, 305)

GUICtrlCreateLabel("OEM Branding Wizard:" & @LF & @TAB & "By James Brooks 2008", 10, 330, 200)
GUICtrlSetColor(-1, 0x004499)
GUICtrlSetFont(-1, Default, 800)

If $OS = "WIN_VISTA" Then
	_Vista_ApplyGlassArea($GUI, $Area, 0xE2E2E2)
EndIf

GUISetState(@SW_SHOW)

While 1
	$iMsg = GUIGetMsg()
	Switch $iMsg
		Case $GUI_EVENT_CLOSE, $_Exit
			Exit
		Case $OEMLogo_SetLocate
			$OEM_Location = FileOpenDialog("OEM Branding Wizard", @ScriptDir, "Microsoft Bitmap(*.bmp)")
			GUICtrlSetData($OEMLogo_Locate, $OEM_Location)
			If Not $OEM_Location = "" Then
				GUICtrlSetImage($OEMLogo, $OEM_Location)
			EndIf
		Case $UseOEMLogo
			If Not IsChecked($UseOEMLogo) Then
				GUICtrlSetState($OEMLogo_Locate, $GUI_DISABLE)
				GUICtrlSetState($OEMLogo_SetLocate, $GUI_DISABLE)
			Else
				GUICtrlSetState($OEMLogo_Locate, $GUI_ENABLE)
				GUICtrlSetState($OEMLogo_SetLocate, $GUI_ENABLE)
				If IsChecked($OEMLogo_KeepOriginal) Then
					GUICtrlSetState($OEMLogo_KeepOriginal, $GUI_UNCHECKED)
				EndIf
			EndIf
		Case $Use_SupportInfo
			If Not IsChecked($Use_SupportInfo) Then
				If $OS = "WIN_VISTA" Then
					GUICtrlSetState($Support_Hours, $GUI_DISABLE)
					GUICtrlSetState($Support_Phone, $GUI_DISABLE)
					GUICtrlSetState($Support_URL, $GUI_DISABLE)
				Else
					GUICtrlSetState($SupportInfo_Line1, $GUI_DISABLE)
					GUICtrlSetState($SupportInfo_Line2, $GUI_DISABLE)
					GUICtrlSetState($SupportInfo_Line3, $GUI_DISABLE)
					GUICtrlSetState($SupportInfo_Line4, $GUI_DISABLE)
					GUICtrlSetState($SupportInfo_Line5, $GUI_DISABLE)
					GUICtrlSetState($SupportInfo_Line6, $GUI_DISABLE)
					GUICtrlSetState($SupportInfo_Line7, $GUI_DISABLE)
				EndIf
			Else
				If $OS = 	"WIN_VISTA" Then
					GUICtrlSetState($Support_Hours, $GUI_ENABLE)
					GUICtrlSetState($Support_Phone, $GUI_ENABLE)
					GUICtrlSetState($Support_URL, $GUI_ENABLE)
				Else
					GUICtrlSetState($SupportInfo_Line1, $GUI_ENABLE)
					GUICtrlSetState($SupportInfo_Line2, $GUI_ENABLE)
					GUICtrlSetState($SupportInfo_Line3, $GUI_ENABLE)
					GUICtrlSetState($SupportInfo_Line4, $GUI_ENABLE)
					GUICtrlSetState($SupportInfo_Line5, $GUI_ENABLE)
					GUICtrlSetState($SupportInfo_Line6, $GUI_ENABLE)
					GUICtrlSetState($SupportInfo_Line7, $GUI_ENABLE)
				EndIf
			EndIf
		Case $_SaveOEM, $_SaveSettings
			If $OS <> "WIN_VISTA" Then
				IniWrite($INI, "General", "Manufacturer", GUICtrlRead($Man_Info))
				IniWrite($INI, "General", "Model", GUICtrlRead($Mod_Info))
				If IsChecked($UseOEMLogo) Then
					FileCopy($OEM_Location, @SystemDir & '\oemlogo.bmp', 1)
				Else
					If Not IsChecked($OEMLogo_KeepOriginal) Then
						FileDelete(@SystemDir & '\oemlogo.bmp')
					EndIf
				EndIf
				If IsChecked($Use_SupportInfo) Then
					$INIOS = IniReadSection($INI, "Support Information")
					If Not @error Then
						If Not $INIOS[1][1] = "" Then
							$Compare_Line1 = StringCompare($INIOS[1][1], GUICtrlRead($SupportInfo_Line1))
							If $Compare_Line1 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line1) = "" Then
									IniWrite($INI, "Support Information", "Line1", GUICtrlRead($SupportInfo_Line1))
								EndIf
							EndIf
						ElseIf $INIOS[1][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line1) = "" Then
								IniWrite($INI, "Support Information", "Line1", GUICtrlRead($SupportInfo_Line1))
							Else
								MsgBox(32, @ScriptName, "Line 1 cannot be blank!")
							EndIf
						EndIf
						If Not $INIOS[2][1] = "" Then
							$Compare_Line2 = StringCompare($INIOS[2][1], GUICtrlRead($SupportInfo_Line2))
							If $Compare_Line2 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line2) = "" Then
									IniWrite($INI, "Support Information", "Line2", GUICtrlRead($SupportInfo_Line2))
								EndIf
							EndIf
						ElseIf $INIOS[2][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line2) = "" Then
								IniWrite($INI, "Support Information", "Line2", GUICtrlRead($SupportInfo_Line2))
							EndIf
						EndIf
						If Not $INIOS[3][1] = "" Then
							$Compare_Line3 = StringCompare($INIOS[3][1], GUICtrlRead($SupportInfo_Line3))
							If $Compare_Line3 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line3) = "" Then
									IniWrite($INI, "Support Information", "Line3", GUICtrlRead($SupportInfo_Line3))
								EndIf
							EndIf
						ElseIf $INIOS[3][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line3) = "" Then
								IniWrite($INI, "Support Information", "Line3", GUICtrlRead($SupportInfo_Line3))
							EndIf
						EndIf
						If Not $INIOS[4][1] = "" Then
							$Compare_Line4 = StringCompare($INIOS[4][1], GUICtrlRead($SupportInfo_Line4))
							If $Compare_Line4 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line4) = "" Then
									IniWrite($INI, "Support Information", "Line4", GUICtrlRead($SupportInfo_Line4))
								EndIf
							EndIf
						ElseIf $INIOS[4][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line4) = "" Then
								IniWrite($INI, "Support Information", "Line4", GUICtrlRead($SupportInfo_Line4))
							EndIf
						EndIf
						If Not $INIOS[5][1] = "" Then
							$Compare_Line5 = StringCompare($INIOS[5][1], GUICtrlRead($SupportInfo_Line5))
							If $Compare_Line5 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line5) = "" Then
									IniWrite($INI, "Support Information", "Line5", GUICtrlRead($SupportInfo_Line5))
								EndIf
							EndIf
						ElseIf $INIOS[5][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line5) = "" Then
								IniWrite($INI, "Support Information", "Line5", GUICtrlRead($SupportInfo_Line5))
							EndIf
						EndIf
						If Not $INIOS[6][1] = "" Then
							$Compare_Line6 = StringCompare($INIOS[6][1], GUICtrlRead($SupportInfo_Line6))
							If $Compare_Line6 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line6) = "" Then
									IniWrite($INI, "Support Information", "Line6", GUICtrlRead($SupportInfo_Line6))
								EndIf
							EndIf
						ElseIf $INIOS[6][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line6) = "" Then
								IniWrite($INI, "Support Information", "Line6", GUICtrlRead($SupportInfo_Line6))
							EndIf
						EndIf
						If Not $INIOS[7][1] = "" Then
							$Compare_Line7 = StringCompare($INIOS[7][1], GUICtrlRead($SupportInfo_Line7))
							If $Compare_Line7 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line7) = "" Then
									IniWrite($INI, "Support Information", "Line7", GUICtrlRead($SupportInfo_Line7))
								EndIf
							EndIf
						ElseIf $INIOS[7][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line7) = "" Then
								IniWrite($INI, "Support Information", "Line7", GUICtrlRead($SupportInfo_Line7))
							EndIf
						EndIf
						OEMCheck()
					ElseIf @error Then
						MsgBox(16, @ScriptName, "OEMinfo.ini was not found - creating file!" & @LF & "Please try again now!")
						IniWrite($INI, "General", "Manufacturer", "")
						IniWrite($INI, "General", "Model", "")
						IniWrite($INI, "Support Information", "Line1", "")
						IniWrite($INI, "Support Information", "Line2", "")
						IniWrite($INI, "Support Information", "Line3", "")
						IniWrite($INI, "Support Information", "Line4", "")
						IniWrite($INI, "Support Information", "Line5", "")
						IniWrite($INI, "Support Information", "Line6", "")
						IniWrite($INI, "Support Information", "Line7", "")
					EndIf
				EndIf
			EndIf
		Case $_TempOEM, $_CreateTempINI
			If $OS <> "WIN_VISTA" Then
				IniWrite($TempIni, "General", "Manufacturer", GUICtrlRead($Man_Info))
				IniWrite($TempIni, "General", "Model", GUICtrlRead($Mod_Info))
				If IsChecked($UseOEMLogo) Then
					FileCopy($OEM_Location, @SystemDir & '\oemlogo.bmp', 1)
				Else
					If Not IsChecked($OEMLogo_KeepOriginal) Then
						FileDelete(@SystemDir & '\oemlogo.bmp')
					EndIf
				EndIf
				If IsChecked($Use_SupportInfo) Then
					$IniTest = IniReadSection($TempIni, "Support Information")
					If Not @error Then
						If Not $IniTest[1][1] = "" Then
							$Compare_Line1 = StringCompare($IniTest[1][1], GUICtrlRead($SupportInfo_Line1))
							If $Compare_Line1 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line1) = "" Then
									IniWrite($TempIni, "Support Information", "Line1", GUICtrlRead($SupportInfo_Line1))
								EndIf
							EndIf
						ElseIf $IniTest[1][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line1) = "" Then
								IniWrite($TempIni, "Support Information", "Line1", GUICtrlRead($SupportInfo_Line1))
							Else
								MsgBox(32, @ScriptName, "Line 1 cannot be blank!")
							EndIf
						EndIf
						If Not $IniTest[2][1] = "" Then
							$Compare_Line2 = StringCompare($IniTest[2][1], GUICtrlRead($SupportInfo_Line2))
							If $Compare_Line2 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line2) = "" Then
									IniWrite($TempIni, "Support Information", "Line2", GUICtrlRead($SupportInfo_Line2))
								EndIf
							EndIf
						ElseIf $IniTest[2][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line2) = "" Then
								IniWrite($TempIni, "Support Information", "Line2", GUICtrlRead($SupportInfo_Line2))
							EndIf
						EndIf
						If Not $IniTest[3][1] = "" Then
							$Compare_Line3 = StringCompare($IniTest[3][1], GUICtrlRead($SupportInfo_Line3))
							If $Compare_Line3 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line3) = "" Then
									IniWrite($TempIni, "Support Information", "Line3", GUICtrlRead($SupportInfo_Line3))
								EndIf
							EndIf
						ElseIf $IniTest[3][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line3) = "" Then
								IniWrite($TempIni, "Support Information", "Line3", GUICtrlRead($SupportInfo_Line3))
							EndIf
						EndIf
						If Not $IniTest[4][1] = "" Then
							$Compare_Line4 = StringCompare($IniTest[4][1], GUICtrlRead($SupportInfo_Line4))
							If $Compare_Line4 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line4) = "" Then
									IniWrite($TempIni, "Support Information", "Line4", GUICtrlRead($SupportInfo_Line4))
								EndIf
							EndIf
						ElseIf $IniTest[4][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line4) = "" Then
								IniWrite($TempIni, "Support Information", "Line4", GUICtrlRead($SupportInfo_Line4))
							EndIf
						EndIf
						If Not $IniTest[5][1] = "" Then
							$Compare_Line5 = StringCompare($IniTest[5][1], GUICtrlRead($SupportInfo_Line5))
							If $Compare_Line5 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line5) = "" Then
									IniWrite($TempIni, "Support Information", "Line5", GUICtrlRead($SupportInfo_Line5))
								EndIf
							EndIf
						ElseIf $IniTest[5][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line5) = "" Then
								IniWrite($TempIni, "Support Information", "Line5", GUICtrlRead($SupportInfo_Line5))
							EndIf
						EndIf
						If Not $IniTest[6][1] = "" Then
							$Compare_Line6 = StringCompare($IniTest[6][1], GUICtrlRead($SupportInfo_Line6))
							If $Compare_Line6 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line6) = "" Then
									IniWrite($TempIni, "Support Information", "Line6", GUICtrlRead($SupportInfo_Line6))
								EndIf
							EndIf
						ElseIf $IniTest[6][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line6) = "" Then
								IniWrite($TempIni, "Support Information", "Line6", GUICtrlRead($SupportInfo_Line6))
							EndIf
						EndIf
						If Not $IniTest[7][1] = "" Then
							$Compare_Line7 = StringCompare($IniTest[7][1], GUICtrlRead($SupportInfo_Line7))
							If $Compare_Line7 <> 0 Then
								If Not GUICtrlRead($SupportInfo_Line7) = "" Then
									IniWrite($TempIni, "Support Information", "Line7", GUICtrlRead($SupportInfo_Line7))
								EndIf
							EndIf
						ElseIf $IniTest[7][1] = "" Then
							If Not GUICtrlRead($SupportInfo_Line7) = "" Then
								IniWrite($TempIni, "Support Information", "Line7", GUICtrlRead($SupportInfo_Line7))
							EndIf
							OEMCheck()
						EndIf
					ElseIf @error Then
						MsgBox(16, @ScriptName, "OEMinfo.ini was not found - creating file!" & @LF & "Please try again now!")
						IniWrite($TempIni, "General", "Manufacturer", "")
						IniWrite($TempIni, "General", "Model", "")
						IniWrite($TempIni, "Support Information", "Line1", "")
						IniWrite($TempIni, "Support Information", "Line2", "")
						IniWrite($TempIni, "Support Information", "Line3", "")
						IniWrite($TempIni, "Support Information", "Line4", "")
						IniWrite($TempIni, "Support Information", "Line5", "")
						IniWrite($TempIni, "Support Information", "Line6", "")
						IniWrite($TempIni, "Support Information", "Line7", "")
					EndIf
				ElseIf $OS = "WIN_VISTA" Then
					; MsgBox(32, @ScriptName, "Windows Vista branding is not supported yet!")
					RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Logo", GUICtrlRead($OEM_Location))
					RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Manufacturer", GUICtrlRead($Man_Info))
					RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Model", GUICtrlRead($Mod_Info))
					RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\SupportHours", GUICtrlRead($Support_Hours))
					RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\SupportPhone", GUICtrlRead($Support_Phone))
					RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\SupportURL", GUICtrlRead($Support_URL))
				EndIf
			EndIf
		Case $_LoadTempINI
			If Not FileExists($TempIni) Then
				MsgBox(16, @ScriptName, "Temporary OEM branding information was not found!")
			Else
				$TempIni_Read = IniReadSection($TempIni, "Support Information")
				GUICtrlSetData($SupportInfo_Line1, $TempIni_Read[1][1])
				GUICtrlSetData($SupportInfo_Line2, $TempIni_Read[2][1])
				GUICtrlSetData($SupportInfo_Line3, $TempIni_Read[3][1])
				GUICtrlSetData($SupportInfo_Line4, $TempIni_Read[4][1])
				GUICtrlSetData($SupportInfo_Line5, $TempIni_Read[5][1])
				GUICtrlSetData($SupportInfo_Line6, $TempIni_Read[6][1])
				GUICtrlSetData($SupportInfo_Line7, $TempIni_Read[7][1])
			EndIf
		Case $_LoadOEMINI
			If Not FileExists($INI) Then
				MsgBox(16, @ScriptName, "OEM branding information was not found - Please create one!")
			Else
				$OSIni_Read = IniReadSection($INI, "Support Information")
				GUICtrlSetData($SupportInfo_Line1, $OSIni_Read[1][1])
				GUICtrlSetData($SupportInfo_Line2, $OSIni_Read[2][1])
				GUICtrlSetData($SupportInfo_Line3, $OSIni_Read[3][1])
				GUICtrlSetData($SupportInfo_Line4, $OSIni_Read[4][1])
				GUICtrlSetData($SupportInfo_Line5, $OSIni_Read[5][1])
				GUICtrlSetData($SupportInfo_Line6, $OSIni_Read[6][1])
				GUICtrlSetData($SupportInfo_Line7, $OSIni_Read[7][1])
			EndIf
		Case $_DeleteCurrentINI
			FileDelete($INI)
		Case $_DeleteTempINI
			FileDelete($TempIni)
		Case $_Info
			MsgBox(32, "OEM Branding Wizard", "OEM Branding Wizard is quick way of handling" & @LF & _
					"the OEM information found on the system properties box!" & @LF & _
					"Very useful for IT technicians who want to leave a mark!" & @LF & @LF & _
					"OEM Branding Wizard is made by James Brooks 2008!")
	EndSwitch
WEnd

Func IsChecked($control)
	Return BitAND(GUICtrlRead($control), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>IsChecked

Func OEMCheck()
	$OEMIni = IniReadSection($INI, "Support Information")
	If Not @error Then
		; Search for the desired value
		$found_the_value = False
		For $ax = 1 To $OEMIni[0][0]
			If StringInStr($OEMIni[$ax][1], 'Created using OEM Branding Wizard by James Brooks') Then
				;ConsoleWrite("Found wizard information!" & @CRLF)
				$found_the_value = True
				ExitLoop
			EndIf
		Next
	Else
		; Add if no section or file
		IniWrite($INI, "Support Information", "Line8", "Created using OEM Branding Wizard by James Brooks")
		ConsoleWrite("Information added!" & @CRLF)
	EndIf

	; Add value into the ini if the value does not exist
	If Not $found_the_value Then
		IniWrite($INI, "Support Information", "Line8", "Created using OEM Branding Wizard by James Brooks")
		ConsoleWrite("Information added!" & @CRLF)
	EndIf
EndFunc   ;==>OEMCheck

Func _Vista_ApplyGlassArea($hWnd, $Area, $bColor = 0x000000)
	If @OSVersion <> "WIN_VISTA" Then
		MsgBox(16, "_Vista_ApplyGlass", "You are not running Vista!")
		Exit
	Else
		If IsArray($Area) Then
			DllStructSetData($Struct, "cxLeftWidth", $Area[0])
			DllStructSetData($Struct, "cxRightWidth", $Area[1])
			DllStructSetData($Struct, "cyTopHeight", $Area[2])
			DllStructSetData($Struct, "cyBottomHeight", $Area[3])
			GUISetBkColor($bColor) ; Must be here!
			$Ret = DllCall("dwmapi.dll", "long*", "DwmExtendFrameIntoClientArea", "hwnd", $hWnd, "ptr", DllStructGetPtr($Struct))
			If @error Then
				Return 0
			Else
				Return $Ret
			EndIf
		Else
			MsgBox(16, "_Vista_ApplyGlassArea", "Area specified is not an array!")
		EndIf
	EndIf
EndFunc   ;==>_Vista_ApplyGlassArea