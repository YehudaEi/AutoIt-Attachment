; GUI_MD5ForFile
; April 07, 2010
;
Global $sFile
Global $gui00 = GUICreate(" GUI_MD5ForFile", 325, 150, -1, -1)
Global $inp01 = GUICtrlCreateInput("", 35, 25, 250, 20)
Global $inp02 = GUICtrlCreateInput("", 35, 70, 250, 20)
Global $btn01 = GUICtrlCreateButton("Open File", 20, 115, 70, 25)
Global $btn02 = GUICtrlCreateButton("Copy Hash", 125, 115, 70, 25)
Global $btn03 = GUICtrlCreateButton("Exit", 230, 115, 70, 25)
GUISetState(@SW_SHOW, $gui00)
;
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case -3, $btn03
			ExitLoop
		Case $btn01
			$sFile = FileOpenDialog("Select File", @ScriptDir, "All Files (*.*)", 1)
			If $sFile Then
				GUICtrlSetData($inp01, $sFile)
				GUICtrlSetData($inp02, _MD5ForFile($sFile))
			Else
				ContinueLoop
			EndIf
		Case $btn02
			ClipPut(GUICtrlRead($inp02))
	EndSwitch
WEnd
GUIDelete($gui00)
Exit
;
; #FUNCTION# ;===============================================================================
;
; Name...........: _MD5ForFile
; Description ...: Calculates MD5 value for the specific file.
; Syntax.........: _MD5ForFile ($sFile)
; Parameters ....: $sFile - Full path to the file to process.
; Return values .: Success - Returns MD5 value in form of hex string
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - CreateFile function or call to it failed.
;                  |2 - CreateFileMapping function or call to it failed.
;                  |3 - MapViewOfFile function or call to it failed.
;                  |4 - MD5Init function or call to it failed.
;                  |5 - MD5Update function or call to it failed.
;                  |6 - MD5Final function or call to it failed.
; Author ........: trancexx
;
;==========================================================================================
Func _MD5ForFile($sFile)
	Local $a_hCall = DllCall("kernel32.dll", "hwnd", "CreateFileW", _
			"wstr", $sFile, _
			"dword", 0x80000000, _
			"dword", 3, _
			"ptr", 0, _
			"dword", 3, _
			"dword", 0, _
			"ptr", 0)
	If @error Or $a_hCall[0] = -1 Then
		Return SetError(1, 0, "")
	EndIf
	Local $hFile = $a_hCall[0]
	$a_hCall = DllCall("kernel32.dll", "ptr", "CreateFileMappingW", _
			"hwnd", $hFile, _
			"dword", 0, _
			"dword", 2, _
			"dword", 0, _
			"dword", 0, _
			"ptr", 0)
	If @error Or Not $a_hCall[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
		Return SetError(2, 0, "")
	EndIf
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
	Local $hFileMappingObject = $a_hCall[0]
	$a_hCall = DllCall("kernel32.dll", "ptr", "MapViewOfFile", _
			"hwnd", $hFileMappingObject, _
			"dword", 4, _
			"dword", 0, _
			"dword", 0, _
			"dword", 0)
	If @error Or Not $a_hCall[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(3, 0, "")
	EndIf
	Local $pFile = $a_hCall[0]
	Local $iBufferSize = FileGetSize($sFile)
	Local $tMD5_CTX = DllStructCreate("dword i[2];" & _
			"dword buf[4];" & _
			"ubyte in[64];" & _
			"ubyte digest[16]")
	DllCall("advapi32.dll", "none", "MD5Init", "ptr", DllStructGetPtr($tMD5_CTX))
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(4, 0, "")
	EndIf
	DllCall("advapi32.dll", "none", "MD5Update", _
			"ptr", DllStructGetPtr($tMD5_CTX), _
			"ptr", $pFile, _
			"dword", $iBufferSize)
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(5, 0, "")
	EndIf
	DllCall("advapi32.dll", "none", "MD5Final", "ptr", DllStructGetPtr($tMD5_CTX))
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(6, 0, "")
	EndIf
	DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
	Local $sMD5 = Hex(DllStructGetData($tMD5_CTX, "digest"))
	Return SetError(0, 0, $sMD5)
EndFunc
;
