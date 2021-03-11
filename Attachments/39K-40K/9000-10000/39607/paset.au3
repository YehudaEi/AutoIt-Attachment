#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\CompInfo\Control-Panel.ico
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#comments-start --INFO
	;
	; User's must have permission and be part of the group listed in the Clients.ini under Paset.
	;
#comments-end ----INFO
;
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <AD.au3>
#include <file.au3>
#include <misc.au3>
;
#region ----------------------------------Variables and Prep
;
Global $iniPath = @ScriptDir & "\Clients.ini"
Global $sLogMsg
;
Global $iniLog = IniRead($iniPath, @LogonDomain, "DestPath", False)
If $iniLog = "False" Then
	ConsoleWrite("Can't read DestPath from INI!" & @CRLF)
Else
	$iniLog = $iniLog & "\Paset.log"
EndIf
;
_AD_Open()
If @error Then
	ConsoleWrite("Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended & @CRLF)
	MsgBox(0, "Error with AD Open", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)
	Exit
EndIf
;
Global $iniPasetGroup = IniRead($iniPath, @LogonDomain, "Paset", False)
;
If $iniPasetGroup = "False" And _AD_IsMemberOf("Domain Admins", @UserName, True) <> 1 Then
	_FileWriteLog($iniLog, @UserName & " attempted to run the Paset utility.")
	MsgBox(0, "Error", "Domain not authorized or INI file read error.")
	_AD_Close()
	Exit
EndIf
;
Global $iniPass = IniRead($iniPath, @LogonDomain, "DePass", False)
If $iniPass = "False" Or "" Then $iniPass = "Welcome.1"
Global $iniLog = IniRead($iniPath, @LogonDomain, "DestPath", False)
If $iniLog = "False" Then
	ConsoleWrite("Can't read DestPath from INI!" & @CRLF)
Else
	$iniLog = $iniLog & "\Paset.log"
EndIf
;
#endregion ----------------------------------Variables and Prep
;-----------------------------------------
#region ----------------------------------Building the GUI -Live
;
$gcPaset = GUICreate("Password Reset Utility", 280, 480, -1, -1)
GUISetIcon("C:\Users\admin\Downloads\Sugar\CompInfo\Control-Panel.ico", -1, $gcPaset)
;
$glUsers = GUICtrlCreateList("", 10, 10, 260, 270)
GUICtrlCreateLabel("Please enter a username to search for.", 15, 290, 250, 20, $SS_CENTER)
;
$giUsername = GUICtrlCreateInput("*", 10, 330, 200, 25)
;
$gbSearch = GUICtrlCreateButton("Search", 220, 330, 50, 25)
;
$glError = GUICtrlCreateLabel("Passwords are reset to: " & $iniPass, 40, 370, 200, 50, $SS_CENTER)
GUICtrlSetColor(-1, 0x0000FF)
;
$gbClose = GUICtrlCreateButton("Close", 10, 440, 100, 25)
;
$gbReset = GUICtrlCreateButton("Reset Password", 130, 430, 140, 40)
GUICtrlSetFont(-1, 10, 600)
;
GUISetState(@SW_SHOW, $gcPaset)
;
#endregion ----------------------------------Building the GUI -Live
;-----------------------------------------
#region ----------------------------------Live Code
;
While 1
	If _IsPressed("0D") = 1 Then List_Users()
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $gbSearch
			List_Users()
		Case $gbReset
			ResetPass()
		Case $GUI_EVENT_CLOSE, $gbClose
			_Exit()
	EndSwitch
WEnd
;
#endregion ----------------------------------Live Code
;-----------------------------------------
#region ----------------------------------Functions
;
Func ResetPass()
;~ 	GUICtrlSetData($glError, "")
	$sTarget = GUICtrlRead($glUsers)
	If $sTarget = "" Then
		GUICtrlSetData($glError, "Please select a user first.")
		Return
	EndIf
	ConsoleWrite($sTarget & @CRLF)

	If _AD_IsObjectLocked($sTarget) = 1 Then _AD_UnlockObject($sTarget)
	_AD_SetPassword($sTarget, $iniPass, 1)
	If @error Then
		MsgBox(0, "Uh Oh!", "Sorry, either you do not have permission to reset that user's password or an unknown error occurred.")
		_FileWriteLog($iniLog, @UserName & " failed to reset " & $sTarget & "'s password.")
	Else
		GUICtrlSetData($glError, $sTarget & "'s password was reset to " & $iniPass)
		_FileWriteLog($iniLog, @UserName & " reset " & $sTarget & "'s password.")
	EndIf
EndFunc   ;==>ResetPass
;
Func List_Users()
	GUICtrlSetData($glUsers, "")
	If GUICtrlRead($glError) <> "Passwords are reset to: " & $iniPass Then GUICtrlSetData($glError, "Passwords are reset to: " & $iniPass)
	Local $sUser = GUICtrlRead($giUsername)
;~ 	ConsoleWrite($sUser & @CRLF)
	;InputBox("Test", "User account(s) to search for." & @CRLF & "Wildcards are allowed.", "*", "", 300, 150, Default, Default, Default)
	If $sUser <> "*" Then $sUser = "*" & $sUser & "*"
;~ 	If @error = 1 Then Return
	Local $aUser = _AD_GetObjectsInOU("", "(&(objectcategory=person)(Samaccountname=" & $sUser & "))", 2, "samaccountname, description")
	If @error = 3 Then
		GUICtrlSetData($glError, "No Users Found!")
;~ 		MsgBox(16, "Test", "No user accounts found using the specified search pattern!")
	Else

;~ 		_ArrayDisplay($aUser, "List of user accounts", -1, 0, "", "|", "|SamAccountName|Description")
		For $i = 1 To $aUser[0][0]
			GUICtrlSetData($glUsers, $aUser[$i][0])
		Next
	EndIf
	Return 1

EndFunc   ;==>List_Users
;
Func _Exit()
	GUIDelete($gcPaset)
	_AD_Close()
	Exit
EndFunc   ;==>_Exit
;
#endregion ----------------------------------Functions