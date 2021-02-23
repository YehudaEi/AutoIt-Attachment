#cs ----------------------------------------------------------------------------

 AutoIt Version: 1.0
 Author:         pieeater

 Script Function:
	Allows you to force the user to have spacific information before they can enter
	another part of your script... if you use it right. Examples will be provided

#ce ----------------------------------------------------------------------------


; #Function Names#===================================================================================
;   _login()
;   _createAccount()
;please leave suggested functions and i will try my best to add them in the future :D
; ===================================================================================================

#include-once
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Crypt.au3>
#include <File.au3>
#include <Array.au3>

#cs #FUNCTION# ====================================================================================================================
 Name...........: _login()
 Description ...: Opens a gui allowing the user to input an username and an password
 Syntax.........: _login($flag)
 Parameters ....: $flag = 0
				  $flag = 1
 Returns........: $flag = 0
					0 = login succesful
					1 = login failed
					2 = file not found
				  $flag = 1
					Returns a string containing the username if succesful, if unsuccesful returns 1, if no file returns 2
 Author ........: pieeater
 Remarks .......: this will only find the username and password if the file is in the same directory as script
 Example .......: _login()
#ce ===============================================================================================================================

Func _login($flag = 0)
	Local $exit = 1
	#Region ### START Koda GUI section ### Form=
	Local $Form1 = GUICreate("Login", 183, 153, 398, 133)
	Local $Label1 = GUICtrlCreateLabel("Username", 32, 8, 52, 17)
	Local $Label2 = GUICtrlCreateLabel("Password", 32, 64, 50, 17)
	Local $Input1 = GUICtrlCreateInput("", 32, 32, 121, 21)
	Local $Input2 = GUICtrlCreateInput("", 32, 88, 121, 21, BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))
	Local $Button1 = GUICtrlCreateButton("Login", 8, 120, 75, 25, $WS_GROUP)
	Local $Button2 = GUICtrlCreateButton("Exit", 96, 120, 75, 25, $WS_GROUP)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While $exit <> 0
		Local $nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				$exit = 0
				GUIDelete($Form1)
				Return 1
			Case $Button2
				$exit = 0
				GUIDelete($Form1)
				Return 1
			Case $Button1
				If FileExists(@ScriptDir & "/Accounts.crypt") Then
					Dim $array
					Local $WIN = 1
					_FileReadToArray(@ScriptDir & "/Accounts.crypt", $array)
					;_ArrayDisplay($array)
					For $i = 1 To $array[0]
						Local $lSplit = StringSplit($array[$i], "=", 2)
						If $lSplit[0] == _Crypt_HashData(GUICtrlRead($Input1), $CALG_MD5)Then
							If $lSplit[1] == _Crypt_HashData(GUICtrlRead($Input2), $CALG_MD5)Then
								;MsgBox(0, "Win", "you win:D")
								$WIN = 0
								If $flag == 0 Then Return 0
								If $flag == 1 Then Return GUICtrlRead($Input1)
								GUIDelete($Form1)
							EndIf
						EndIf
					Next
					If $WIN <> 0 Then
						MsgBox(0, "Error", "Username or Password wrong")
						GUICtrlSetData($Input1, "")
						GUICtrlSetData($Input2, "")
						ControlFocus("Login", "", $Input1)
					EndIf
				Else
					MsgBox(48, "Error", "Cannot find file with the accounts!!!" & @LF & 'Note: if there is no file called "Accounts.crypt" in the same folder as the script then the script wont find any accounts')
					GUIDelete($Form1)
					Return 2
				EndIf
		EndSwitch
	WEnd
EndFunc

#cs #FUNCTION# ====================================================================================================================
 Name...........: _createAccount()
 Description ...: Adds a user account to the file "Accounts.crypt"
 Syntax.........: _createAccount( $_uName, $_pWord)
 Parameters ....: $_uName = Username.
                  $_pWord = Password.
 Returns........: 0 = Success
				  -1 = Username exists
 Author ........: pieeater
 Example .......: _createAccount( "username", "password")
#ce ===============================================================================================================================

Func _createAccount($_uName, $_pWord)
	Dim $array
	If Not FileExists(@ScriptDir & "/Accounts.crypt") Then
		FileWrite("Accounts.crypt", _Crypt_HashData($_uName, $CALG_MD5) & "=" & _Crypt_HashData($_pWord, $CALG_MD5))
		Return 0
	EndIf
	_FileReadToArray(@ScriptDir & "/Accounts.crypt", $array)
	;_ArrayDisplay($array)  used in testing
	For $i = 1 To $array[0]
		Local $lSplit = StringSplit($array[$i], "=", 2)
		If $lSplit[0] == _Crypt_HashData($_uName, $CALG_MD5)Then
			MsgBox(0, "Error", "Username exists")
			$WIN = 0
			Return 1
		EndIf
	Next
	If $WIN <> 0 Then
		FileWriteLine("Accounts.crypt", _Crypt_HashData($_uName, $CALG_MD5) & "=" & _Crypt_HashData($_pWord, $CALG_MD5))
		Return 0
	EndIf
EndFunc