
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7

#include <Constants.au3>


Local $res, $line, $sRegCmd, $sRegString

Global $dll = "OLE32.dll" , $var,$var1,$var2,$path




If _CheckDLLregistered($dll) Then ; The dll is registered
	ConsoleWrite("DLL Registered HKEY_CLASSES_ROOT\CLSID\" & $var & "\" & $var1 & @CRLF) ; ( Returns Registry paths )
	Exit

Else ; The dll is not registered so we need to register it in here other wise won't work

	ConsoleWrite("DLL NOT Registered " & $sRegCmd & @CRLF) ; ( Returns Registry paths )

	Exit
EndIf

;~ -----------------------------------------------------------------------------------------------------------------------------------------
;~ AutoIt Version: v3.3.0.0
;~ Language......: English
;~ Platform......: Windows XP
;~ Developer.....: Ambientguitar
;~ Last Modified.: 07/08/2012
;~ version.......: 1.0.0.0
;~ Copyright.....: (C) Ambientguitar
;~ File Name.....: Function _CheckDLLregistered
;~ Description...: Allows users to Check if a DLL is registered in their system
;~ Purpose.......: Check a DLL is registered if not register it using Regserv32.
;~ Returns.......: 1 if registered
;~ Parameters....:  DLL Name to check
;~ Example.......: _CheckDLLregistered($dll)  Or try _CheckDLLregistered(msado15.dll)

;~ -----------------------------------------------------------------------------------------------------------------------------------------


Func _CheckDLLregistered($dllname)
	For $i = 1 To 3000
		$var = RegEnumKey("HKEY_CLASSES_ROOT\CLSID", $i)
		If @error <> 0 Then ExitLoop
		For $j = 1 To 3000
			$var1 = RegEnumKey("HKEY_CLASSES_ROOT\CLSID\" & $var, $j)
			If @error <> 0 Then ExitLoop
			;MsgBox(4096, "SubKey #" & $var,$j & " under HKEY_CLASSES_ROOT\CLSID\" & $var1)
			If $var1 = "InprocServer32" Then
				$path = "HKEY_CLASSES_ROOT\CLSID\" & $var & "\" & $var1
				ToolTip($path, 10, 20, "Enumerating Registry")
				$var2 = RegRead($path, "")
				If StringInStr($var2, $dllname) Then
					Return 1
				EndIf
			EndIf
		Next
	Next
EndFunc   ;==>_CheckDLLregistered
