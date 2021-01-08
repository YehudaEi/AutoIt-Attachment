; ------------------------------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 beta
; Author:         Thorsten Meger <Thorsten.Meger@gmx.de>  & ...
;
; Script Function: LoginWrapper / Security Check
;
;	The script allows you to protect your script from starting by unauthenticated users.
;	This scrips wrapps your script. After authenticated successfully, it "installs" your script hidden
;   at the given location and starts it. 
;	If the "main-script" is closed, this script deletes the your Script.exe
;	Wrapper.exe contains (your script)
; ------------------------------------------------------------------------------------------------------
;	The script creates an (system/hidden) ini-File in the script-folder.
;	The login.ini contains the encrypted usernames & passwords
;	To add users who can authenticate successfully, start the script with the para defined
;	in $createNewUser default(newuser)
;	The login.ini contains one adminUser(InitialUser & InitialPassword)
;	Change Initial - user & password to your needs
; ------------------------------------------------------------------------------------------------------

; **** Change this to your script.exe ******************************************************

Dim $yourScriptExe = 'c:\MsgBox.exe'	; your script.exe (I recommend c:\)
Dim $InitialUser = 'xxx' 				; change this to your "admin" user
Dim $InitialPassword = 'xxx' 			; change this to your "admin" password
Dim $iniPath = @WindowsDir & '\'		; where to save the ini files
Dim $nameOfIni = 'login.ini' 			; Login.ini should be renamed to the name of the wrapped mainScript. That will allow multiple wrapping
Dim $createNewUser = 'newuser' 			; change this to secure creating new users (first parameter) e.g. : LoginWrapper.exe newuser
Dim $Sound = 1							; Sound On/Off, 1 = On, 0 = Off

; FileInstall doesn't work with variables, so you have to type fullPath as a string!!!
; Example : FileInstall('c:\yourPath\yourScriptExe.exe', 'c:\yourScriptExe.exe', 1) ; 2nd para must be the same as in $yourScriptExe!
Func _FileInstall()
	FileInstall('c:\Downloads\AutoIt-Skripte\Entwicklung\Wrapper\MsgBox.exe', 'c:\MsgBox.exe', 1) ; first 	;!!!Change here!!!
	FileSetAttrib($yourScriptExe, "+SH")
	Sleep(20)
	Run($yourScriptExe)
	If @error = 1 Then MsgBox(0, "Error", "Couldn't find the main script!", 4)
	check()
EndFunc   ;==>_FileInstall
; ******************************************************************************************

#include <GUIConstants.au3>
#include <String.au3>
#include <File.au3>
Opt("RunErrorsFatal", 0)

; The GUI
$GUI = GUICreate("Security Check", 318, 223, 192, 125)
; Group
$main_G = GUICtrlCreateGroup("Credentials", 8, 56, 297, 153)
; Label
$username_L = GUICtrlCreateLabel("Username : ", 16, 80, 131, 17, $SS_SUNKEN)
$password_L = GUICtrlCreateLabel("Password : ", 16, 112, 131, 17, $SS_SUNKEN)
$status_L = GUICtrlCreateLabel("Status", 16, 176, 267, 17, $SS_SUNKEN)
$headline_L = GUICtrlCreateLabel("Login", 8, 18, 299, 33)
; Input
$username_I = GUICtrlCreateInput("", 160, 76, 121, 21, -1, $WS_EX_CLIENTEDGE)
$password_I = GUICtrlCreateInput("", 160, 110, 121, 21, $ES_PASSWORD, $WS_EX_CLIENTEDGE)
; Button
$button_B = GUICtrlCreateButton("Login", 16, 136, 131, 25, $BS_DEFPUSHBUTTON)
; CheckBox
$changePassword_C = GUICtrlCreateCheckbox("Change Password", 160, 136, 113, 25)

GUICtrlSetFont($headline_L, 18, -1, -1, "Arial")
GUICtrlSetColor($headline_L, "0xff0000")
; TrayTip
TrayTip("Security Check", "Please, authenticate with user & password", 2, 1)
GUISetState(@SW_SHOW)

;Variables
Dim $guiStatus = 0
Dim $exists = False
Dim $changeActivated = False
Dim $acceptedUser = ''
Dim $sectionArray = ''
; create Obj for speech
Dim $voice = ObjCreate("Sapi.SpVoice")

; You can change the elements which are used for encryption here
Dim $cryptArray = StringSplit("2we4rf,adfi8,i9lp,we2ay,9o0pw,asdc4,1209i,tz573,98m3,6tg5", ",")

start()

; Check at start, whether the ini file is there. If not create it with the initial credentials
Func Start()
	;Check for password file
	If Not FileExists($iniPath & $nameOfIni) Then
		_FileCreate($iniPath & $nameOfIni)
		Local $cryptWord = Random(0, 9, 1)
		IniWrite($iniPath & $nameOfIni, '1', _StringEncrypt(1, $InitialUser, 'key', 2), _StringEncrypt(1, $InitialPassword, $cryptArray[$cryptWord], 2) & $cryptWord)
		FileSetAttrib($iniPath & $nameOfIni, "+SH")
	EndIf
EndFunc   ;==>OnAutoItStart


; Changing GUI whether you want to login or create new users
If $cmdLine[0] > 0 Then
	If $cmdLine[1] = $createNewUser Then
		$guiStatus = 1
		GUICtrlSetData($button_B, "Save")
		GUICtrlSetData($headline_L, "New User")
		GUICtrlSetData($status_L, "Ready ...")
		GUICtrlSetState($changePassword_C, $GUI_HIDE)
	EndIf
EndIf

; Func create new user
Func createNewUser()
	Local $exists = False
	$sectionArray = IniReadSection($iniPath & $nameOfIni, '1')
	If @error Then
		MsgBox(4096, "", "Error occured, probably no INI file.")
	Else
		For $i = 1 To $sectionArray[0][0]
			If _StringEncrypt(0, $sectionArray[$i][0], 'key', 2) = GUICtrlRead($username_I) Then
				GUICtrlSetData($status_L, "User already exists!")
				If $Sound = 1 Then Speak("User already exists!")
				$exists = True
				Sleep(500)
				GUICtrlSetData($status_L, "Ready...")
				ExitLoop
			EndIf
		Next
		If $exists = False Then
			Local $cryptWord = Random(0, 9, 1)
			IniWrite($iniPath & $nameOfIni, '1', _StringEncrypt(1, GUICtrlRead($username_I), 'key', 2), _StringEncrypt(1, GUICtrlRead($password_I), $cryptArray[$cryptWord], 2) & $cryptWord)
			GUICtrlSetData($status_L, "New User created!")
			If $Sound = 1 Then Speak("New User created!")
			Sleep(500)
			GUICtrlSetData($status_L, "Ready...")
		EndIf
	EndIf
EndFunc   ;==>createNewUser

; check user and password
Func verifyUserAndPassword()
	$exists = False
	GUICtrlSetData($status_L, "Verifying User")
	$sectionArray = IniReadSection($iniPath & $nameOfIni, '1')
	If @error Then
		MsgBox(4096, "", "Error occured, probably no INI file.")
	Else
		For $i = 1 To $sectionArray[0][0]
			Local $user = _StringEncrypt(0, $sectionArray[$i][0], 'key', 2)
			If $user = GUICtrlRead($username_I) Then
				Local $cryptNr = StringRight($sectionArray[$i][1], 1)
				Local $value = StringLeft($sectionArray[$i][1], StringLen($sectionArray[$i][1]) - 1)
				If _StringEncrypt(0, $value, $cryptArray[$cryptNr], 2) = GUICtrlRead($password_I) Then
					GUICtrlSetData($status_L, "Login accepted! Welcome! " & $user)
					If $Sound = 1 Then Speak("Login accepted! Welcome! " & $user)
					$exists = True
					$acceptedUser = GUICtrlRead($username_I)
					If Not BitAND(GUICtrlRead($changePassword_C), $GUI_CHECKED) Then
						_FileInstall()
					EndIf
				EndIf
			EndIf
		Next
	EndIf
	If $exists = False Then
		Sleep(200)
		GUICtrlSetData($status_L, "Access denied!")
		If $Sound = 1 Then Speak("Access denied!", 2, 100)
		Sleep(500)
		GUICtrlSetData($status_L, "Ready...")
	EndIf
EndFunc   ;==>verifyUserAndPassword

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $button_B
			If (StringLen(GUICtrlRead($username_I)) < 3 Or StringLen(GUICtrlRead($password_I)) < 3) And $exists = False Then
				GUICtrlSetData($status_L, "Minimum 3 letters")
				If $Sound = 1 Then Speak("Minimum 3 letters")
			Else
				If $guiStatus = 0 And Not BitAND(GUICtrlRead($changePassword_C), $GUI_DISABLE) And $changeActivated = False Then
					verifyUserAndPassword()
				ElseIf $guiStatus = 1 And Not BitAND(GUICtrlRead($changePassword_C), $GUI_DISABLE) And $changeActivated = False Then
					createNewUser()
				EndIf
				If $changeActivated = True Then
					If GUICtrlRead($username_I) = GUICtrlRead($password_I) Then
						For $i = 1 To $sectionArray[0][0]
							If _StringEncrypt(0, $sectionArray[$i][0], 'key', 2) = $acceptedUser Then
								Local $cryptWord = Random(0, 9, 1)
								IniWrite($iniPath & $nameOfIni, '1', _StringEncrypt(1, $acceptedUser, 'key', 2), _StringEncrypt(1, GUICtrlRead($username_I), $cryptArray[$cryptWord], 2) & $cryptWord)
								ExitLoop
							EndIf
						Next
						If (StringLen(GUICtrlRead($username_I)) < 3 Or StringLen(GUICtrlRead($password_I)) < 3) Then
							GUICtrlSetData($status_L, "Minimum 3 letters")
							If $Sound = 1 Then Speak("Minimum 3 letters")
						Else
							GUICtrlSetData($status_L, "New password saved!")
							If $Sound = 1 Then Speak("New password saved!")
							Sleep(500)
							GUICtrlSetData($status_L, "Program closes in 1 sec")
							If $Sound = 1 Then Speak("Security Check closes ...")
							Sleep(200)
							check()
						EndIf
					Else
						GUICtrlSetData($status_L, "New passwords dont't match!")
						GUICtrlSetData($username_I, "")
						GUICtrlSetData($password_I, "")
						If $Sound = 1 Then Speak("New passwords dont't match!")
					EndIf
				EndIf
				If BitAND(GUICtrlRead($changePassword_C), $GUI_CHECKED) And Not BitAND(GUICtrlRead($changePassword_C), $GUI_DISABLE) And $changeActivated = False Then
					changePassword()
				EndIf
			EndIf
	EndSelect
WEnd

; Preparing GUI for checking password
Func changePassword()
	If $exists = True Then
		$changeActivated = True
		GUICtrlSetState($changePassword_C, $GUI_DISABLE)
		_GuiCtrlEditChangePasswordChar($username_I)
		_GuiCtrlEditChangePasswordChar($password_I)
		GUICtrlSetData($status_L, "Please, enter new password")
		GUICtrlSetData($username_L, "New password")
		GUICtrlSetData($password_L, "Reenter password")
		GUICtrlSetData($username_I, "")
		GUICtrlSetData($password_I, "")
		GUICtrlSetData($button_B, "Save new password")
		GUICtrlSetState($username_I, $Gui_FOCUS)
	Else
		GUICtrlSetData($status_L, "Please, authenticate first!")
		If $Sound = 1 Then Speak("Please, authorize first!")
	EndIf
EndFunc   ;==>changePassword

; Speak func
Func Speak($Text, $Rate = 2, $Vol = 100)
	$voice.Rate = $Rate
	$voice.Volume = $Vol
	$voice.Speak ($Text)
EndFunc   ;==>Speak

Func OnAutoItExit()
	FileDelete($yourScriptExe)
EndFunc   ;==>OnAutoItExit

Func check()
#NoTrayIcon
GUISetState(@SW_HIDE)
Dim $exe = StringSplit($yourScriptExe, "\")
Sleep(200) ; Sleep, before LoginWrapper starts to check whether the wrapped exe is running
While 1
	If ProcessExists($exe[$exe[0]]) = 0 Then
		FileDelete($yourScriptExe)
		Exit(0)
	EndIf
	Sleep(2000)
WEnd
EndFunc

; Func to set the username (which is clear) to mask the typed signs
Func _GuiCtrlEditChangePasswordChar(ByRef $h_edit, $s_newchar = '#')
	Local Const $EM_SETPASSWORDCHAR = 0xCC
	GUISetState(@SW_LOCK)
	If StringInStr(@OSVersion, "WIN_XP") And @NumParams = 1 Then
		Local $s_text = GUICtrlRead($h_edit)
		Local $pos = ControlGetPos(WinGetTitle(""), "", $h_edit)
		GUICtrlDelete($h_edit)
		$h_edit = GUICtrlCreateInput($s_text, $pos[0], $pos[1], $pos[2], $pos[3], $ES_PASSWORD, $WS_EX_CLIENTEDGE)
	Else
		GUICtrlSetStyle($h_edit, $ES_PASSWORD, $WS_EX_CLIENTEDGE)
		GUICtrlSendMsg($h_edit, $EM_SETPASSWORDCHAR, Asc($s_newchar), 0)
	EndIf
	GUISetState(@SW_UNLOCK)
EndFunc   ;==>_GuiCtrlEditChangePasswordChar