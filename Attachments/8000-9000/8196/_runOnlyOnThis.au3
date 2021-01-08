#include <String.au3>

; Added the option to specify whether it runs only on this windows, or this harddrive.
If _runOnlyOnThis("", "", -1, "test", 1) <> 1 Then Exit (0)

; Put your script code below here

MsgBox(64, "Secured Program", "Yeah, the secured main-program started!" & _
		@CRLF & @CRLF & "Thanks & and have fun!" & @CRLF & @CRLF & "Mega")

;===============================================================================
;
; Function Name:    _runOnlyOnThis ...
; Description:      Activation by parameter sets a unique registry key
;					After a successful activation, checks for the regkey
;					If correct go on, else Exit(0)
;
; Parameter(s):     (Script) First time, the activation key
;					(Func) $s_KeyName = RegKeyName
;						   $s_EncryptPassword = Encryption passphrase
;						   $i_EncryptLevel = Level (quantity)
;						   $s_ActivationKey = key which starts the func
;						   $i_Option (default =1)
;
;						   _runOnlyOnThis ... $i_Option
;						   1 = Windows installtion (Date)
;						   2 = HardDrive
;
; Return Value(s): 	On Success - Returns  1
;					On Failure - Returns -1 RegWrite Problem,
;								 Returns -2 Not activated,
;								 Returns -3 Wrong registry key
;								 Returns -4 Couldn't DriveGetSerial
;
; Note(s):			Basically useful to prevent user starting the script on
;					non activated PCs
;					String.au3 has to be included
;
; Author(s):        Thorsten Meger
;
;===============================================================================
Func _runOnlyOnThis($s_KeyName, $s_EncryptPassword, $i_EncryptLevel, $s_ActivationKey, $i_option = 1)
	
	If $s_KeyName = "" Then $s_KeyName = "Version"
	If $s_EncryptPassword = "" Then $s_EncryptPassword = "thisPc"
	If $i_EncryptLevel = -1 Then $i_EncryptLevel = 2
	If $s_ActivationKey = "" Then $s_ActivationKey = "activate"
	If $i_option <> 1 Or $i_option <> 2 Then $i_option = 1
	
	If $i_option = 1 Then
		Local $stringToCrypt = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "InstallDate")
	ElseIf $i_option = 2 Then
		Local $stringToCrypt = DriveGetSerial(StringLeft(@SystemDir, 3))
		If @error = 1 Then Return -4
	EndIf
	
	Local $crypted = _StringEncrypt(1, $stringToCrypt, $s_EncryptPassword, $i_EncryptLevel)
	If $cmdLine[0] > 0 And $cmdLine[1] = $s_ActivationKey Then
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\" & StringLeft(@ScriptName, StringLen(@ScriptName) - 4), $s_KeyName, "REG_SZ", _
				StringTrimLeft($crypted, 4))
		Return -1
		
	ElseIf RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\" & StringLeft(@ScriptName, StringLen(@ScriptName) - 4), $s_KeyName) = "" Then
		MsgBox(64, "Error", "You are not allowed to run this program!", 5)
		Return -2
		
	ElseIf RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\" & StringLeft(@ScriptName, StringLen(@ScriptName) - 4), $s_KeyName) <> _
			(StringTrimLeft($crypted, 4)) Then
		MsgBox(64, "Error", "You are not allowed to run this program on this computer!", 5)
		Return -3
	EndIf
	Return 1
EndFunc   ;==>_runOnlyOnThis