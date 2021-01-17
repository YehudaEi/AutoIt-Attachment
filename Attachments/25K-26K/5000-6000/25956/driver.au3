; #FUNCTION# ====================================================================================================================
; Name...........: _DriverList
; Description ...: Returns an array listing the currently running drivers (Image base, base address & Path).
; Syntax.........: _DriverList()
; Return values .: Success - An array of image base,base address,Path
;                  Failure - Flase, sets @error = 0
;				   |0 - Unable to call "EnumDeviceDrivers"
; Remarks........: [0][0] = Image Base 
;				   [0][1] = Base address
;				   [0][2] = Path
; Author ........: Digisoul
; ===============================================================================================================================

Func _DriverList()
	Local $a_Drv
	Local $drvs = DllStructCreate("dword[1024]")
	Local $dll_data = DllCall("Psapi.dll", "int", "EnumDeviceDrivers", "ptr", DllStructGetPtr($drvs), "dword", DllStructGetSize($drvs), "dword*", 0)
	If $dll_data[3] > 0 Then
		Local $enum_drv = $dll_data[3] / 4 ; number of Drivers
		Local $a_Drv[$enum_drv][3]
		For $i = 1 To $enum_drv
			$a_Drv[$i - 1][0] = DllStructGetData($drvs, 1, $i) ; Image Of Driver
			$a_Drv[$i - 1][1] = GetDeviceDriverBaseNameW(DllStructGetData($drvs, 1, $i)); Base Of Driver
			$a_Drv[$i - 1][2] = GetDeviceDriverFileNameW($a_Drv[$i - 1][1]); Path Of Driver
		Next
		$drvs = 0
		Return $a_Drv
	Else
		$drvs = 0
		Return SetError(0)
	EndIf
EndFunc   ;==>Enum_driver


Func GetDeviceDriverBaseNameW($image_base)
	Local $path = ""
	Local $dll_data2 = DllCall("Psapi.dll", "dword", "GetDeviceDriverBaseNameW", "ptr", $image_base, "wstr", "", "dword", 260)
	If $dll_data2[0] Then
;~ 		ConsoleWrite(">Image Base: " & $image_base & @CRLF & "-Base Address: " & $dll_data2[1] & @CRLF & "-Driver Name: " & $dll_data2[2] & @CRLF & "-Driver path: " & GetDeviceDriverFileNameW($dll_data2[1]) & @CRLF & @CRLF)
		Return $dll_data2[1]
	Else
		Return ""
	EndIf
EndFunc   ;==>GetDeviceDriverBaseNameW

Func GetDeviceDriverFileNameW($image_adrs)
	Local $init_path
	$pth = DllCall("Psapi.dll", "dword", "GetDeviceDriverFileNameW", "ptr", $image_adrs, "wstr", "", "dword", 260)
	If $pth[0] Then
		; Valid Paths
		Switch $pth[2]
			Case StringInStr($pth[2], "\SystemRoot", 2) <> 0
				$init_path = StringReplace($pth[2], "\SystemRoot", @WindowsDir, 1, 2)
			Case Else
				If StringInStr($pth[2], "\??\") <> 0 Then
					$init_path = StringReplace($pth[2], "\??\", "")
				ElseIf StringInStr(StringLeft($pth[2], 1), "\") <> 0 Then
					$invalid = StringLeft($pth[2], StringInStr($pth[2], "\", 1, 2))
					$init_path = StringReplace($pth[2], $invalid, @WindowsDir & "\")
				ElseIf StringInStr(StringLeft($pth[2], 3), ":\") = 0 Then
					$init_path = @SystemDir & "\Drivers\" & $pth[2]
				Else
					$init_path = $pth[2]
				EndIf
		EndSwitch

		Return $init_path
	Else
		Return False
	EndIf
EndFunc   ;==>GetDeviceDriverFileNameW

