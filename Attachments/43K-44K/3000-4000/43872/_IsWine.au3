;
; AutoIt Version:  3.0
; Language:   English
; Platfrom:   Win9x/NT
; Author:   Robert C. Maehl (rcmaehl@aol.com)
;
; Function:
;  Checks to see if the script is running
;  under WINE.
;
; Parameters:
; 00 = Check All
; 01 = Check IE
; 02 = Check Gecko
; 04 = Check Refresh
; 08 = Check Files
;
; Return Value:
;  Returns True/False
;
; @Error Value:
;  Returns 1 if invalid parameter.

; #FUNCTION# ====================================================================================================================
; Name ..........: _IsWine
; Description ...:
; Syntax ........: _IsWine($Param)
; Parameters ....: $Param               - An unknown value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IsWine($iParam)
	Local $Files[27] = ["winealsa.drv", "wineaudioio.drv", "wineboot.exe", "winebrowser.exe", "winecfg.exe", "wineconsole.exe", "winecoreaudio.drv", _
				"wined3d.dll", "winedbg.exe", "winedevice.exe", "wineesd.drv", "winefile.exe", "winegstreamer.dll", "winejack.drv", "winejoystick.drv", _
				"winemapi.dll", "winemenubuilder.exe", "winemine.exe", "winemp3.exe", "winemsibuilder.exe", "winenas.drv", "wineoss.drv", "winepath.exe", _
				"wineps.drv", "wineps16.drv", "winevdm.exe", "winex11.drv"]
	Local $Return = False
	Switch $Param
		Case 0
			_IsWine(1)
			_IsWine(2)
			_IsWine(4)
			_IsWine(8)
		Case 1
			If RegRead("HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\Version Vector", "IE") = "6.000" Then $Return = True
		Case 2
			If RegRead("HKEY_USERS\S-1-5-4\Software\Wine\MSHTML\1.0.0", "GeckoPath") = "C:\windows\system32\gecko\1.0.0\wine_gecko" Then $Return = True
		Case 3
			_IsWine(1)
			_IsWine(2)
		Case 4
			If @DesktopRefresh = 0 Then $Return = True
		Case 5
			_IsWine(1)
			_IsWine(4)
		Case 6
			_IsWine(2)
			_IsWine(4)
		Case 7
			_IsWine(1)
			_IsWine(2)
			_IsWine(4)
		Case 8
			For $Loop = 0 To 26 Step 1
				If FileExists(@SystemDir & "\" & $Files[$Loop]) Then $Return = True
			Next
		Case 9
			_IsWine(1)
			_IsWine(8)
		Case 10
			_IsWine(2)
			_IsWine(8)
		Case 11
			_IsWine(1)
			_IsWine(2)
			_IsWine(8)
		Case 12
			_IsWine(4)
			_IsWine(8)
		Case 13
			_IsWine(1)
			_IsWine(4)
			_IsWine(8)
		Case 14
			_IsWine(2)
			_IsWine(4)
			_IsWine(8)
		Case 15
			_IsWine(1)
			_IsWine(2)
			_IsWine(4)
			_IsWine(8)
		Case Else
			SetError(1)
	EndSwitch
	Return $Return
EndFunc