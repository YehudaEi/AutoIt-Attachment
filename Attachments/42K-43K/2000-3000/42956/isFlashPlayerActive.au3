#include <WinAPI.au3>
#include <array.au3>
#AutoIt3Wrapper_UseX64=n    ; bei 32bit Prozessen

; TEST
HotKeySet("{ESC}", "_Exit")
Func _Exit()
    Exit
EndFunc


While Sleep( 1000 )
	ConsoleWrite(  isFlashPlayerActive() & @LF  )
WEnd



Func isFlashPlayerActive( $checkChrome = 1 , $checkFirefox = 1 , $checkInternetExplorer = 1 )
; Author: Andreas Karlsson (monoceres) & ProgAndy & Bluesmaster


	Static $hPsapi    = DllOpen("Psapi.dll")


	; 1 - CHROME
	if $checkChrome Then

		$tModulesStruct   = DllStructCreate("hwnd [200]")
		Local $SIZEOFHWND = DllStructGetSize($tModulesStruct) / 200

		Local $aReturn[1]
		$aProcessList = ProcessList( "chrome.exe" )

		For $iProcessList = 1 To $aProcessList[0][0]  ; iterate Processes with the same name

			$hProcess = _WinAPI_OpenProcess(BitOR(0x0400, 0x0010), False, $aProcessList[$iProcessList][1] )    ;  $PROCESS_QUERY_INFORMATION = 0x0400  |  $PROCESS_VM_READ = 0x0010
			If Not $hProcess Then Return SetError(1, 0, -1)
			$aCall = DllCall($hPsapi, "int", "EnumProcessModules", "ptr", $hProcess, "ptr", DllStructGetPtr($tModulesStruct), "dword", DllStructGetSize($tModulesStruct), "dword*", "")
			If $aCall[4] > DllStructGetSize($tModulesStruct) Then
				$tModulesStruct = DllStructCreate("hwnd [" & $aCall[4] / $SIZEOFHWND & "]")
				$aCall = DllCall($hPsapi, "int", "EnumProcessModules", "ptr", $hProcess, "ptr", DllStructGetPtr($tModulesStruct), "dword", $aCall[4], "dword*", "")
			EndIf
			Local $aReturnTemp[$aCall[4] / $SIZEOFHWND]
			For $i = 0 To UBound( $aReturnTemp ) - 1

				$aCall = DllCall($hPsapi, "dword", "GetModuleFileNameExW", "ptr", $hProcess, "ptr", DllStructGetData($tModulesStruct, 1, $i + 1), "wstr", "", "dword", 65536 )
				$aCall[3] =  StringRegExp( $aCall[3] , "[^\\]+\.[^\\]+$", 1)[0]  ; Restpfad entfernen
				$aReturnTemp[$i] = $aCall[3]

			Next

			_ArrayConcatenate( $aReturn , $aReturnTemp )
		Next

		_WinAPI_CloseHandle($hProcess)

		if _ArraySearch( $aReturn , "pepflashplayer.dll" ) <> -1 Then Return 1   ; dont check the other browsers if flash found

	EndIf



	; 2 - FIREFOX
	if $checkFirefox Then

		Dim $flashPIDs[1]
		$j = 1
		$pList = ProcessList()
		For $i = 1 To $pList[0][0]
			If StringInStr($pList[$i][0], "FlashPlayerPlugin") Then
				$flashPIDs[0] = $j
				$j += 1
				ReDim $flashPIDs[$j]
				$flashPIDs[$j - 1] = $pList[$i][1]
			EndIf
		Next

		$totalFlashMem = 0
		For $i = 1 To $flashPIDs[0]
			$pStats = ProcessGetStats($flashPIDs[$i])
			$totalFlashMem += $pStats[0] / 1024 / 1024
		Next

		if $totalFlashMem > 50 Then Return 2

	EndIf



	; 3 - INTERNET EXPLORER
	if $checkChrome Then

		$tModulesStruct   = DllStructCreate("hwnd [200]")
		Local $SIZEOFHWND = DllStructGetSize($tModulesStruct) / 200

		Local $aReturn[1]
		$aProcessList = ProcessList( "iexplore.exe" )

		For $iProcessList = 1 To $aProcessList[0][0]  ; iterate Processes with the same name

			$hProcess = _WinAPI_OpenProcess(BitOR(0x0400, 0x0010), False, $aProcessList[$iProcessList][1] )    ;  $PROCESS_QUERY_INFORMATION = 0x0400  |  $PROCESS_VM_READ = 0x0010
			If Not $hProcess Then Return SetError(1, 0, -1)
			$aCall = DllCall($hPsapi, "int", "EnumProcessModules", "ptr", $hProcess, "ptr", DllStructGetPtr($tModulesStruct), "dword", DllStructGetSize($tModulesStruct), "dword*", "")
			If $aCall[4] > DllStructGetSize($tModulesStruct) Then
				$tModulesStruct = DllStructCreate("hwnd [" & $aCall[4] / $SIZEOFHWND & "]")
				$aCall = DllCall($hPsapi, "int", "EnumProcessModules", "ptr", $hProcess, "ptr", DllStructGetPtr($tModulesStruct), "dword", $aCall[4], "dword*", "")
			EndIf
			Local $aReturnTemp[$aCall[4] / $SIZEOFHWND]
			For $i = 0 To UBound( $aReturnTemp ) - 1

				$aCall = DllCall($hPsapi, "dword", "GetModuleFileNameExW", "ptr", $hProcess, "ptr", DllStructGetData($tModulesStruct, 1, $i + 1), "wstr", "", "dword", 65536 )
				$aCall[3] =  StringRegExp( $aCall[3] , "[^\\]+\.[^\\]+$", 1)[0]  ; Restpfad entfernen
				$aReturnTemp[$i] = $aCall[3]

			Next

			_ArrayConcatenate( $aReturn , $aReturnTemp )
		Next

		_WinAPI_CloseHandle($hProcess)

		if _ArraySearch( $aReturn , "flash.ocx" ) <> -1 Then Return 3   ; dont check the other browsers if flash found

	EndIf


	Return False

EndFunc









