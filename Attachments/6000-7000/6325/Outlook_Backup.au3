#include <GUIConstants.au3>
#include <GuiCombo.au3>
#include <RegCount.au3>
#include <Array.au3>
#include <String.au3>

Dim $Key = "HKEY_Users"



Dim $SID


$SID = _UserSID(); Create an array with all username from the local machine

; == GUI generated with Koda ==
$Form1 = GUICreate("Outlook Registry Backup/Restore", 622, 441, 192, 125)
$Label1 = GUICtrlCreateLabel('Select User', 208, 160)
$Combo1 = GUICtrlCreateCombo("", 208, 176, 153, 21)
$Button1 = GUICtrlCreateButton('Backup Outlook', 200, 200)
$Button2 = GUICtrlCreateButton('Restore Outlook', 290, 200)

;Adding username to combobox
For $x = 1 To $SID[0][0]
	_GUICtrlComboAddString ($Combo1, $SID[0][$x])
Next

GUISetState(@SW_SHOW)
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $Button1;Searching for the SID
			For $x = 1 To $SID[0][0]
				$User = GUICtrlRead($Combo1)
				If $User == $SID[0][$x] Then
					RunWait(@ComSpec & " /c " & 'REGEDIT /E ' & 'C:\Outlook_' & $User & '.reg ' & '"' & $Key & "\" & $SID[1][$x] & '\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles\"', "", @SW_SHOW)
					MsgBox(64, "Job Status", "Backup Done ...", 2)
					ExitLoop
				EndIf
			Next
		Case $msg = $Button2
			For $x = 1 To $SID[0][0]
				$User = GUICtrlRead($Combo1)
				If $User == $SID[0][$x] Then
					If FileExists('C:\Outlook_' & $User & '.reg') = "1" Then
						RunWait(@ComSpec & " /c " & 'REGEDIT /S ' & '"C:\Outlook_' & $User & '.reg"', "", @SW_SHOW)
						MsgBox(64, "Job Status", "Restore Done ...", 2)
						ExitLoop
					EndIf
				Else
					If FileExists('C:\Outlook_' & $User & '.reg') = "0" Then
						MsgBox(64, "Error", "The file doesn't exist.", 2)
						ExitLoop
					EndIf
				EndIf
			Next
	EndSelect
WEnd
Exit

;===============================================================================
; Function Name: _UserSID()
;
; Description: Return a 2 dimensional array first username second SID.
;
; Syntax: _UserSID ( [$s_UserName, $s_RemoteComputer] )
;
; Parameter(s): $s_UserName = Username to get SID.
; $s_RemoteComputer = ComputerName on the network
;
; Requirement(s): External: = None.
; Internal: = None.
;
; Return Value(s): On Success: = Returns 2 dimensional array with UserName, SID and sets @error to 0.
; On Failure: = Returns "" and sets @error to 1.
;
; Author(s): Dan Colón
;
; Note(s):
;
; Example(s):
; _UserSID("DColon") it will return DColon SID
; _UserSID() it will return every user SID
;===============================================================================

Func _UserSID($s_UserName = "All", $s_RemoteComputer = '')
	If $s_UserName = '' Then $s_UserName = 'All'
	If $s_RemoteComputer <> '' Then
		If StringMid($s_RemoteComputer, 1, 1) <> '\' Or StringMid($s_RemoteComputer, 2, 1) <> '\' Or StringRight($s_RemoteComputer, 1) <> '\' Then
			$s_RemoteComputer = '\\' & StringReplace($s_RemoteComputer, '\', '') & '\'
		EndIf
	EndIf
	
	Local $line, $var, $ProfilePath, $i = 1
	Local Const $regkey = $s_RemoteComputer & "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\"
	Local Const $regkeyval1 = "ProfilesDirectory"
	Local Const $regkeyval2 = "ProfileImagePath"
	
	$ProfilePath = RegRead($regkey, $regkeyval1)
	While 1
		$line = RegEnumKey($regkey, $i)
		$var = RegRead($regkey & $line, $regkeyval2)
		If @error = 1 Or @error = -1 Then ExitLoop
		If $s_UserName == "All" Then
			If Not IsDeclared("aArray") Then Dim $aArray[1][1]
			ReDim $aArray[UBound($aArray) + 1][UBound($aArray) + 1]
			$aArray[0][UBound($aArray) - 1] = StringMid($var, StringInStr($var, '\', 0, -1) + 1)
			$aArray[1][UBound($aArray) - 1] = $line
			$aArray[0][0] = UBound($aArray) - 1
		ElseIf StringLower($var) == StringLower($ProfilePath & "\" & $s_UserName) Then
			If Not IsDeclared("aArray") Then Dim $aArray[1][1]
			ReDim $aArray[UBound($aArray) + 1][UBound($aArray) + 1]
			$aArray[0][UBound($aArray) - 1] = StringMid($var, StringInStr($var, '\', 0, -1) + 1)
			$aArray[1][UBound($aArray) - 1] = $line
			$aArray[0][0] = UBound($aArray) - 1
		EndIf
		$i = $i + 1
	WEnd
	If Not IsDeclared("aArray") Then
		SetError(1)
		Return ("")
	Else
		SetError(0)
		Return ($aArray)
	EndIf
EndFunc   ;==>_UserSID