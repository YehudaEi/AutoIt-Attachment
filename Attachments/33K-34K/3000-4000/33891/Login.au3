#cs
	Name:         Login.au3
	Description:  Creates an ini file that holds information on useraccounts, i havent put any encryption in it yet but im pretty noob and would need help with it.
	Author:       pieeater
	Version:      0.0.2
	Last Update:  2011/05/2
	Note(s):      _Success() and _Admin_Account MUST be used in all scripts using this UDF.
	Credits: mircea, jchd, bwochinski
	AutoIt:       3.3.6.1

	Update Status:
	==========================================
	2011-5-2 - 0.0.2 - pieeater
	Added: Return values instead of msgbox's, made the username and password hashed!
	==========================================
	2011-5-2 - 0.0.1 - pieeater
	Added: _Create_Account() and _Create_Admin().
	==========================================
	2011-5-1 - 0.0.0 - pieeater
	Initial Release
	==========================================
#ce

; #Function Names#===================================================================================
;   _Login()
;	_Login_Menu()
;	_Create_Account()
;	_Create_Admin()
;	_Admin_Login()
; ===================================================================================================

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <Crypt.au3>

Global $a=IniReadSectionNames("accounts.ini")
Global $newuserinput = GUICtrlCreateInput("", 8, 40, 185, 21)
Global $newupassinput = GUICtrlCreateInput("", 8, 96, 185, 21, $ES_PASSWORD)
Global $AdminLogin = GUICtrlCreateButton( "&Admin &Login", 110, 10)
; #FUNCTION# ====================================================================================================================
; Name...........: _login()
; Description ...: Opens a GUI to create a new account or switch to the login menu.
; Syntax.........: _login()
; Parameters ....: none
; Returns........: nothing, it opens the create user menu though.
; Author ........: pieeater
; Remarks .......: You don't have to add a new account if you have already made one.
; Example .......: _login()
; ===============================================================================================================================
Func _login()
	$NewUser = GUICreate("New username", 209, 188, -1, -1)
	$newuserinput = GUICtrlCreateInput("", 8, 40, 185, 21)
	$newupassinput = GUICtrlCreateInput("", 8, 96, 185, 21, $ES_PASSWORD)
	$Createnewuser = GUICtrlCreateButton("&OK", 14, 128, 75, 25, $BS_NOTIFY)
	$Cancelnewuser = GUICtrlCreateButton("&Cancel", 111, 128, 75, 25, $BS_NOTIFY)
	$EnterPassLabel = GUICtrlCreateLabel("Enter password", 8, 68, 77, 17, 0)
	$newusername = GUICtrlCreateLabel("Enter New Username", 8, 16, 105, 17)
	$switchlogin = GUICtrlCreateButton( "&Login", 55, 160, 100, 25)
	$AdminLogin = GUICtrlCreateButton( "&Admin &Login", 120, 10)
	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			case $cancelnewuser
				Exitloop
			Case $GUI_EVENT_CLOSE
				Exit
			Case $createnewuser
				_Create_New_User()
			Case $AdminLogin
				GUIDelete($NewUser)
				_Admin_Login()
			Case $switchlogin
				GUIDelete($NewUser)
				_Login_Menu()
		EndSwitch
	WEnd
EndFunc
; #FUNCTION# ====================================================================================================================
; Name...........: _Create_New_User()
; Description ...: Used by _login() to create a new user, it's used internally so i wouldnt suggest using it in your script.
; Syntax.........: _Create_New_User()
; Parameters ....: None
; Returns........: 0 = success
;				  -1 = Username Exists
; Author ........: pieeater
; ===============================================================================================================================
Func _Create_New_User()
	If IniRead("accounts.ini", "Accounts", _Crypt_HashData(GUICtrlRead($newuserinput), $CALG_MD5), 0) == 0 Then
		IniWrite("accounts.ini", "Accounts", _Crypt_HashData(GUICtrlRead($newuserinput), $CALG_MD5), _Crypt_HashData(GUICtrlRead($newupassinput), $CALG_MD5))
		Return 0
	Else
		Return -1
	EndIf
EndFunc
; #FUNCTION# ====================================================================================================================
; Name...........: _Login_Menu()
; Description ...: Opens the login without going through the create user GUI.
; Syntax.........: _Login_Menu()
; Parameters ....: None
; Returns........: 0 = success
;				  -1 = Username Exists
; Author ........: pieeater
; Example .......: _Login_Menu()
; Note...........: Starts the function _Success() if correct information is used(Note: _Success() MUST be used in all scripts using this UDF).
; ===============================================================================================================================
Func _Login_Menu()
	$gui=GUICreate("Login", 209, 188, -1, -1)
	$userinput = GUICtrlCreateInput("", 8, 40, 185, 21)
	$passinput = GUICtrlCreateInput("", 8, 96, 185, 21, $ES_PASSWORD)
	$Enter = GUICtrlCreateButton("&OK", 14, 128, 75, 25, $BS_NOTIFY)
	$Cancel = GUICtrlCreateButton("&Cancel", 111, 128, 75, 25, $BS_NOTIFY)
	$Labelpass = GUICtrlCreateLabel("Enter password", 8, 68, 77, 17, 0)
	$username = GUICtrlCreateLabel("Enter Username", 8, 16, 105, 17)
	$login = GUICtrlCreateButton( "&Login", 55, 160, 100, 25)
	$AdminLogin = GUICtrlCreateButton( "&Admin &Login", 120, 10)
	GUISetState(@SW_SHOW)
    While 1
        $nMsg=GUIGetMsg()
        Switch $nMsg
            Case $Cancel
                Exit
            Case $GUI_EVENT_CLOSE
                Exit
			Case $login
				GUIDelete($gui)
				_Login()
			Case $AdminLogin
				GUIDelete($gui)
				_Admin_Login()
            Case $Enter
				$pass = GUICtrlRead($passinput)
				$user = GUICtrlRead($userinput)
				$a = IniReadSection("accounts.ini", "Accounts")
				For $i=1 To $a[0][0]
					If $a[$i][1] == _Crypt_HashData($pass, $CALG_MD5) And $a[$i][0] == _Crypt_HashData($user, $CALG_MD5) Then
						GUIDelete($gui)
						_Success()
					Else
						MsgBox(4096, "Failed login", "Try again with the right username or password.")
						GUIDelete($gui)
						_Login_Menu()
					EndIf
				Next
		EndSwitch
    WEnd
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Create_Account()
; Description ...: Allows adding an account inside the script without a GUI.
; Syntax.........: _Create_Account( $uName, $pWord)
; Parameters ....: $uName = Username.
;                  $pWord = Password.
; Returns........: 0 = success
;				  -1 = Username Exists
; Author ........: pieeater
; Example .......: _Create_Account( "username", "password")
; ===============================================================================================================================
Func _Create_Account( $uName = "", $pWord = "")
	If IniRead("accounts.ini", "Accounts", _Crypt_HashData($uName,$CALG_MD5),0) == 0 Then
		IniWrite("accounts.ini", "Accounts", _Crypt_HashData($uName, $CALG_MD5) & " ", " " & _Crypt_HashData($pWord, $CALG_MD5))
		Return 0
	Else
		Return -1
	EndIf
EndFunc
; #FUNCTION# ====================================================================================================================
; Name...........: _Create_Admin()
; Description ...: Creates an administrator account.
; Syntax.........: _Create_Admin( $uNname, $pWord)
;  Parameters ....: $uName = Username.
;                  $pWord = Password.
; Returns........: 0 = success
;				  -1 = Username Exists
; Author ........: pieeater
; Example .......: _Create_Admin( "username", "password")
; ===============================================================================================================================
Func _Create_Admin( $uName = "", $pWord = "")
	$ini=IniReadSection("accounts.ini", "Admin")
	If $ini=1 Then
		IniWrite("accounts.ini", "Admin", _Crypt_HashData($uName, $CALG_MD5)&" ", " " & _Crypt_HashData( $pWord, $CALG_MD5))
		Return 0
	Else
		Return -1
	EndIf
EndFunc
; #FUNCTION# ====================================================================================================================
; Name...........: _Admin_Login()
; Description ...: Opens the GUI for an Admin Login.
; Syntax.........: _Admin_Login()
; Parameters ....: None
; Returns........: 0 = success
;				  -1 = Username or Password invalid
;				  -2 = no admin account
; Author ........: pieeater
; Example .......: _Admin_Login()
; Notes..........: Starts the function _Admin_Login() if correct information is put into the GUI(Note: _Admin_Login() MUST be used in all scripts using this UDF).
; ===============================================================================================================================
Func _Admin_Login()
	$Admin=GUICreate("Admin Login", 209, 188, -1, -1)
	$Adminuserinput = GUICtrlCreateInput("", 8, 40, 185, 21)
	$Adminpassinput = GUICtrlCreateInput("", 8, 96, 185, 21, $ES_PASSWORD)
	$Enter2 = GUICtrlCreateButton("&OK", 14, 128, 75, 25, $BS_NOTIFY)
	$Cancel2 = GUICtrlCreateButton("&Cancel", 111, 128, 75, 25, $BS_NOTIFY)
	$Labelpass2 = GUICtrlCreateLabel("Enter password", 8, 68, 77, 17, 0)
	$username = GUICtrlCreateLabel("Enter Username", 8, 16, 105, 17)
	GUISetState(@SW_SHOW)
    While 1
        $nMsg=GUIGetMsg()
        Switch $nMsg
            Case $Cancel2
                Exit
            Case $GUI_EVENT_CLOSE
                Exit
			Case $Enter2
				$ap=GUICtrlRead($Adminpassinput)
				$au=GUICtrlRead($Adminuserinput)
				$AdminIni=IniReadSection("accounts.ini","Admin")
				If $AdminIni[1][0] == _Crypt_HashData( $au, $CALG_MD5) And $AdminIni[1][1] == _Crypt_HashData( $ap, $CALG_MD5) Then
					GUIDelete($Admin)
					_Admin_Account()
					Return 0
				ElseIf $AdminIni=1 Then
					Return -2
				Else
					Return -1
				EndIf
		EndSwitch
	WEnd
EndFunc