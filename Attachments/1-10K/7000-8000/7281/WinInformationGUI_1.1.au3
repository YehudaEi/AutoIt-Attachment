; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 beta
; Author:         Thorsten Meger <Thorsten.Meger@gmx.de>  & ...
;
; Script Function:
;	Windows XP Information displayed in a GUI
;	with Office-Key (only Office XP or 2003 supported)
;
; ----------------------------------------------------------------------------

#include <GUIConstants.au3>

;GUI
$GUI = GUICreate("Windows Information", 685, 450, 158, 127)

;Labels
$windowsInformation_L = GUICtrlCreateLabel("Windows Information", 8, 8, 659, 25)
$status_L = GUICtrlCreateLabel("Information read out ...", 24, 80, 400, 17)
$description_L = GUICtrlCreateLabel("Description", 16, 112, 103, 17)
$windowsType_L = GUICtrlCreateLabel("WindowsType", 16, 152, 103, 17)
$serialNumber_L = GUICtrlCreateLabel("SerialNumber", 16, 192, 103, 17)
$ProductKey_L = GUICtrlCreateLabel("ProductKey", 16, 232, 103, 17)
$InstallDate_L = GUICtrlCreateLabel("InstallDate", 16, 272, 103, 17)
$LastBootUpTime_L = GUICtrlCreateLabel("LastBootUpTime", 16, 312, 103, 17)
$RegisteredOwner_L = GUICtrlCreateLabel("RegisteredOwner", 16, 352, 103, 17)
$officeKey_L = GUICtrlCreateLabel("OfficeKey", 16, 392, 103, 17)

;Input
$description_I = GUICtrlCreateInput("Description", 130, 112, 389, 21)
$windowsType_I = GUICtrlCreateInput("WindowsType", 130, 152, 389, 21)
$serialNumber_I = GUICtrlCreateInput("SerialNumber", 130, 192, 389, 21)
$ProductKey_I = GUICtrlCreateInput("ProductKey", 130, 232, 389, 21)
$InstallDate_I = GUICtrlCreateInput("InstallDate", 130, 272, 389, 21)
$LastBootUpTime_I = GUICtrlCreateInput("LastBootUpTime", 130, 312, 389, 21)
$RegisteredOwner_I = GUICtrlCreateInput("RegisteredOwner", 130, 352, 389, 21)
$officeKey_I = GUICtrlCreateInput("OfficeKey", 130, 392, 389, 21)

;Groups
$informationPanel_G = GUICtrlCreateGroup("Information Panel", 8, 48, 585, 393)
$status_G = GUICtrlCreateGroup("Status", 14, 64, 553, 41)
$buttins_G = GUICtrlCreateGroup("Buttons", 608, 48, 65, 393)
$office_G = GUICtrlCreateGroup("Microsoft Office", 14, 375, 553, 48)

;Buttons
$exit_B = GUICtrlCreateButton("Exit", 616, 72, 49, 25, 0)
$Description_B = GUICtrlCreateButton("clipboard", 616, 112, 49, 25, 0)
$WindowsType_B = GUICtrlCreateButton("clipboard", 616, 152, 49, 25, 0)
$SerialNumber_B = GUICtrlCreateButton("clipboard", 616, 192, 49, 25, 0)
$ProductKey_B = GUICtrlCreateButton("clipboard", 616, 232, 49, 25, 0)
$InstallDate_B = GUICtrlCreateButton("clipboard", 616, 272, 49, 25, 0)
$LastBootUpTime_B = GUICtrlCreateButton("clipboard", 616, 312, 49, 25, 0)
$registeredOwner_B = GUICtrlCreateButton("clipboard", 616, 352, 49, 25, 0)
$OfficeKey_B = GUICtrlCreateButton("clipboard", 616, 392, 49, 25, 0)

; SetFont
$font = "Comic Sans MS"
GUICtrlSetFont($windowsInformation_L, 16, 400, 4, $font)

;ProgressBar
$progressbar = GUICtrlCreateProgress(140, 75, 400, 25)

;Global variables
Global $product = "" ; Office product Version (XP or 2003)
Global $counter = 3 ; Counter for progressBar
Global $wait = 150 ; Wait for progessBar

GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	If $counter = 3 Then
		Sleep(500)
		GUICtrlSetData($status_L, "Initialize... " & $counter)
		progress()
		$counter -= 1
	ElseIf $counter = 2 Then
		GUICtrlSetData($status_L, "Initialize... " & $counter)
		progress()
		$counter -= 1
	ElseIf $counter = 1 Then
		GUICtrlSetData($status_L, "Initialize... " & $counter)
		progress()
		$counter -= 1
	ElseIf $counter = 0 Then
		GUICtrlSetData($status_L, "Ready ...")
		progress()
		$counter -= 1
	ElseIf $counter = -1 Then
		Dim $Bin = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductID")
		Dim $key4RegisteredOwner = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
		$objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
		$colSettings = $objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")
		
		For $objOperatingSystem In $colSettings
		Next
		GUICtrlSetData($description_I, StringMid($objOperatingSystem.Description, 1))
		GUICtrlSetData($windowsType_I, '(' & @OSVersion & ') ' & StringMid($objOperatingSystem.Caption, 19))
		GUICtrlSetData($serialNumber_I, StringMid($objOperatingSystem.SerialNumber, 1))
		GUICtrlSetData($ProductKey_I, DecodeProductKey($Bin))
		GUICtrlSetData($InstallDate_I, WMIDateStringToDate($objOperatingSystem.InstallDate))
		GUICtrlSetData($LastBootUpTime_I, WMIDateStringToDate($objOperatingSystem.LastBootUpTime))
		GUICtrlSetData($RegisteredOwner_I, RegRead($key4RegisteredOwner, "RegisteredOwner"))
		GUICtrlSetData($officeKey_I, getOfficeKey())
		GUICtrlSetData($officeKey_L, "Office " & $product)
		$counter -= 1
	ElseIf $counter < - 1 Then
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $exit_B
				GUICtrlSetData($status_L, "So long, Mega")
				Sleep(1500)
				ExitLoop
			Case $msg = $Description_B
				ClipPut(StringMid($objOperatingSystem.Description, 1))
				GUICtrlSetData($status_L, "Description copied to clipboard")
			Case $msg = $WindowsType_B
				ClipPut('(' & @OSVersion & ') ' & StringMid($objOperatingSystem.Caption, 19))
				GUICtrlSetData($status_L, "WindowsType copied to clipboard")
			Case $msg = $SerialNumber_B
				ClipPut(StringMid($objOperatingSystem.SerialNumber, 1))
				GUICtrlSetData($status_L, "SerialNumber copied to clipboard")
			Case $msg = $ProductKey_B
				ClipPut(DecodeProductKey($Bin))
				GUICtrlSetData($status_L, "ProductKey copied to clipboard")
			Case $msg = $InstallDate_B
				ClipPut(WMIDateStringToDate($objOperatingSystem.InstallDate))
				GUICtrlSetData($status_L, "InstallDate copied to clipboard")
			Case $msg = $LastBootUpTime_B
				ClipPut(WMIDateStringToDate($objOperatingSystem.LastBootUpTime))
				GUICtrlSetData($status_L, "LastBootUpTime copied to clipboard")
			Case $msg = $registeredOwner_B
				ClipPut(RegRead($key4RegisteredOwner, "RegisteredOwner"))
				GUICtrlSetData($status_L, "RegisteredOwner copied to clipboard")
			Case $msg = $OfficeKey_B
				ClipPut(getOfficeKey())
				GUICtrlSetData($status_L, "OfficeKey copied to clipboard")
			Case Else
				;;;;;;;
		EndSelect
	EndIf
WEnd
Exit

; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 beta
; Author:         Unknown & Thorsten Meger <Thorsten.Meger@gmx.de>
;
; Script Function: Decode REG_BINARY
; ----------------------------------------------------------------------------

Func DecodeProductKey($BinaryDPID)
	Local $bKey[15]
	Local $sKey[29]
	Local $Digits[24]
	Local $Value = 0
	Local $hi = 0
	Local $n = 0
	Local $i = 0
	Local $dlen = 29
	Local $slen = 15
	Local $Result
	
	$Digits = StringSplit("BCDFGHJKMPQRTVWXY2346789", "")
	$BinaryDPID = StringMid($BinaryDPID, 105, 30)
	For $i = 1 To 29 Step 2
		$bKey[Int($i / 2) ] = Dec(StringMid($BinaryDPID, $i, 2))
	Next
	For $i = $dlen - 1 To 0 Step - 1
		If Mod(($i + 1), 6) = 0 Then
			$sKey[$i] = "-"
		Else
			$hi = 0
			For $n = $slen - 1 To 0 Step - 1
				$Value = BitOR(BitShift($hi, -8), $bKey[$n])
				$bKey[$n] = Int($Value / 24)
				$hi = Mod($Value, 24)
			Next
			$sKey[$i] = $Digits[$hi + 1]
		EndIf
	Next
	For $i = 0 To 28
		$Result = $Result & $sKey[$i]
	Next
	Return $Result
EndFunc   ;==>DecodeProductKey

; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 beta
; Author:         Unknown & Thorsten Meger <Thorsten.Meger@gmx.de>
;
; Script Function: WMIDateStringToDate (changed Date format)
; ----------------------------------------------------------------------------

Func WMIDateStringToDate($dtmDate)
	Return (StringMid($dtmDate, 7, 2) & "/" & _
			StringMid($dtmDate, 5, 2) & "/" & StringLeft($dtmDate, 4) _
			 & " " & StringMid($dtmDate, 9, 2) & ":" & StringMid($dtmDate, 11, 2) & ":" & StringMid($dtmDate, 13, 2))
EndFunc   ;==>WMIDateStringToDate

; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 beta
; Author:         Thorsten Meger <Thorsten.Meger@gmx.de>
;
; Script Function: Display a "fake" progressbar at the beginning
; ----------------------------------------------------------------------------

Func progress()
	If $counter = 3 Then
		For $i = 0 To 20 Step 1
			GUICtrlSetData($progressbar, $i)
			Sleep($wait / 20)
		Next
	ElseIf $counter = 2 Then
		For $i = 20 To 50 Step 1
			GUICtrlSetData($progressbar, $i)
			Sleep($wait / 30)
		Next
	ElseIf $counter = 1 Then
		For $i = 50 To 80 Step 1
			GUICtrlSetData($progressbar, $i)
			Sleep($wait / 30)
		Next
	ElseIf $counter = 0 Then
		For $i = 80 To 100 Step 1
			GUICtrlSetData($progressbar, $i)
			Sleep($wait / 20)
		Next
		GUICtrlSetState($progressbar, $GUI_HIDE)
	EndIf
EndFunc   ;==>progress

; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 beta
; Author:         Thorsten Meger <Thorsten.Meger@gmx.de>
;
; Script Function:Get & decode OfficeKey
; ----------------------------------------------------------------------------

Func getOfficeKey()
	Local $List[1]
	Local $i = 1
	$var = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\11.0\Common\InstallRoot", "Path")
	If $var <> "" Then
		$product = "2003"
		Dim $officeKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\11.0\Registration"
	Else
		$var = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\10.0\Common\InstallRoot", "Path")
		If @error <> 0 Then
			GUICtrlSetData($status_L, "Info: Unable to find installationPath, maybe no Office installed!")
			Return "No Office XP or 2003 found"
		EndIf
		If $var <> "" Then
			$product = "XP"
			Dim $officeKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\10.0\Registration"
		EndIf
	EndIf
	Dim $var = RegEnumKey($officeKey, $i)
	If @error <> 0 Then
		GUICtrlSetData($status_L, "Info: Unable to find REG_BINARY 'DigitalProductID', maybe no Office installed!")
		Return "No Office XP or 2003 found"
	Else
		$List[$i - 1] = RegRead($officeKey & "\" & $var, "DigitalProductID")
		If $List[$i - 1] = "" Then
			GUICtrlSetData($status_L, "Info: Unable to find REG_BINARY 'DigitalProductID', maybe no Office installed!")
		Else
			$key = $List[$i - 1]
			Return DecodeProductKey($key)
		EndIf
	EndIf
EndFunc   ;==>getOfficeKey