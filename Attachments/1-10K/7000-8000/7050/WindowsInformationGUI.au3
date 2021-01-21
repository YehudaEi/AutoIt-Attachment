; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 beta
; Author:         Thorsten Meger <Thorsten.Meger@gmx.de>  & ...
;
; Script Function:
;	Windows XP Information displayed in a Gui
;
; ----------------------------------------------------------------------------

#include <GUIConstants.au3>
$counter = 3
$wait = 650
$Form1 = GUICreate("Windows Information", 685, 383, 158, 127)
$Group1 = GUICtrlCreateGroup("Information Panel", 8, 48, 585, 313)
$description = GUICtrlCreateInput("Description", 130, 112, 389, 21)
GUICtrlCreateLabel("Description", 16, 112, 103, 17)
GUICtrlCreateLabel("WindowsType", 16, 152, 103, 17)
$windowsType = GUICtrlCreateInput("WindowsType", 130, 152, 389, 21)
GUICtrlCreateLabel("SerialNumber", 16, 192, 103, 17)
$SerialNumber = GUICtrlCreateInput("SerialNumber", 130, 192, 389, 21)
GUICtrlCreateLabel("ProductKey", 16, 232, 103, 17)
$ProductKey = GUICtrlCreateInput("ProductKey", 130, 232, 389, 21)
GUICtrlCreateLabel("InstallDate", 16, 272, 103, 17)
$InstallDate = GUICtrlCreateInput("InstallDate", 130, 272, 389, 21)
$Group3 = GUICtrlCreateGroup("Status", 16, 64, 553, 41)
GUICtrlCreateLabel("Information read out ...", 24, 80, 400, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateLabel("LastBootUpTime", 16, 312, 103, 17)
$LastBootUpTime = GUICtrlCreateInput("LastBootUpTime", 130, 312, 389, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateLabel("Windows Information", 8, 8, 659, 25)
$Group2 = GUICtrlCreateGroup("Buttons", 608, 48, 65, 313)
$exit = GUICtrlCreateButton("Exit", 616, 72, 49, 25, 0)
$ButtonDescription = GUICtrlCreateButton("clipboard", 616, 112, 49, 25, 0)
$ButtonWindowsType = GUICtrlCreateButton("clipboard", 616, 152, 49, 25, 0)
$ButtonSerialNumber = GUICtrlCreateButton("clipboard", 616, 192, 49, 25, 0)
$ButtonProductKey = GUICtrlCreateButton("clipboard", 616, 232, 49, 25, 0)
$ButtonInstallDate = GUICtrlCreateButton("clipboard", 616, 272, 51, 25, 0)
$ButtonLastBootUpTime = GUICtrlCreateButton("clipboard", 616, 312, 51, 25, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$font = "Comic Sans MS"
GUICtrlSetFont(20, 16, 400, 4, $font)
$progressbar = GUICtrlCreateProgress(140, 75, 400, 25)
GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	If $counter = 3 Then
		Sleep(500)
		GUICtrlSetData(15, "Initialize... " & $counter)
		progress()
		$counter = $counter - 1
	ElseIf $counter = 2 Then
		GUICtrlSetData(15, "Initialize... " & $counter)
		progress()
		$counter = $counter - 1
	ElseIf $counter = 1 Then
		GUICtrlSetData(15, "Initialize... " & $counter)
		progress()
		$counter = $counter - 1
	ElseIf $counter = 0 Then
		GUICtrlSetData(15, "Ready ...")
		progress()
		$counter = $counter - 1
	ElseIf $counter = -1 Then
		Dim $Bin
		$Bin = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductID")
		$objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
		$colSettings = $objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")
		
		For $objOperatingSystem In $colSettings
		Next
		GUICtrlSetData(4, StringMid($objOperatingSystem.Description, 1))
		GUICtrlSetData(7, '(' & @OSVersion & ') ' & StringMid($objOperatingSystem.Caption, 19))
		GUICtrlSetData(9, StringMid($objOperatingSystem.SerialNumber, 1))
		GUICtrlSetData(11, DecodeProductKey($Bin))
		GUICtrlSetData(13, WMIDateStringToDate($objOperatingSystem.InstallDate))
		GUICtrlSetData(18, WMIDateStringToDate($objOperatingSystem.LastBootUpTime))
		$counter = $counter - 1
	ElseIf $counter < - 1 Then
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $exit
				GUICtrlSetData(15, "So long, Mega")
				Sleep(1500)
				ExitLoop
			Case $msg = $ButtonDescription
				ClipPut(StringMid($objOperatingSystem.Description, 1))
				GUICtrlSetData(15, "Description copied to clipboard")
			Case $msg = $ButtonWindowsType
				ClipPut('(' & @OSVersion & ') ' & StringMid($objOperatingSystem.Caption, 19))
				GUICtrlSetData(15, "WindowsType copied to clipboard")
			Case $msg = $ButtonSerialNumber
				ClipPut(StringMid($objOperatingSystem.SerialNumber, 1))
				GUICtrlSetData(15, "SerialNumber copied to clipboard")
			Case $msg = $ButtonProductKey
				ClipPut(DecodeProductKey($Bin))
				GUICtrlSetData(15, "ProductKey copied to clipboard")
			Case $msg = $ButtonInstallDate
				ClipPut(WMIDateStringToDate($objOperatingSystem.InstallDate))
				GUICtrlSetData(15, "InstallDate copied to clipboard")
			Case $msg = $ButtonLastBootUpTime
				ClipPut(WMIDateStringToDate($objOperatingSystem.LastBootUpTime))
				GUICtrlSetData(15, "LastBootUpTime copied to clipboard")
			Case Else
				;;;;;;;
		EndSelect
	EndIf
WEnd
Exit

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

Func WMIDateStringToDate($dtmDate)
	Return (StringMid($dtmDate, 7, 2) & "/" & _
			StringMid($dtmDate, 5, 2) & "/" & StringLeft($dtmDate, 4) _
			 & " " & StringMid($dtmDate, 9, 2) & ":" & StringMid($dtmDate, 11, 2) & ":" & StringMid($dtmDate, 13, 2))
EndFunc   ;==>WMIDateStringToDate

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
		GUICtrlSetState(30, $GUI_HIDE)
	EndIf
EndFunc   ;==>progress