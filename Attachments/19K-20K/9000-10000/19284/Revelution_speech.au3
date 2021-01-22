#include <INet.au3>

$IP = "71.79.78.24"

if fileexists( "talkset.ini") Then
	$image = iniread( "dp.ini", "dp", "dp", "http://www.iconarchive.com/icons/icontexto/elite-soldiers/Elite-Soldier-32x32.png")
	else 
MsgBox(0, "info", "hello, this apears to be the first time you have run this messenger, if you have not already registered you may clcik register once th eprogram loads. how ever we reccomend you visit our main website at                . please use only numbers 0-9, lettersA-Z, underscores _, arabic alphabet, spanish alphabet, up-down lines liek this |, and the following chracters !@#%^&*()<>?/.,:;''{}[]\. DO NOT use spaces" )
$newver = _INetGetSource( "                                           " )
iniwrite( "version.ini", "version", "version", $newver)
$image = inputbox( "Pic", "Because we are working on Display Pictures we now allow you to pic an icon for your own use, only you can see your icon, but other will be able to soon. you can enter a image on the web, including http://, or the full path to a local file C:/. if you at any time want to chnages this, simply click File > Changed Dp if you do not enter an image, the default will be used.", "http://www.iconarchive.com/icons/icontexto/elite-soldiers/Elite-Soldier-32x32.png")
iniwrite( "dp.ini", "dp", "dp", $image)
EndIf




if fileexists("talkset.ini") Then
$talkon = iniread("talkset.ini", "set", "on", "ERROR")
Else
	$awn = msgbox(68, "settings", "do you wish for text to speech to be on?")
	if $awn = '6' Then
		iniwrite("talkset.ini", "set", "on", "1")
		$talkon = "1"
	elseif $awn = "7" Then
		iniwrite("talkset.ini", "set", "on", "0")
		$talkon = "0"
	endif
	endif
	if $talkon = "1" Then
		$talksets = "on"
	elseif $talkon = "0" then 
		$talksets = "off"
	endif
	
	$enl= "2"
#cs
	
	Copyright (c) 2006, Jos van Egmond
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without modification,
	are permitted provided that the following conditions are met:
	
	* Redistributions of source code must retain the above copyright notice,
	this list of conditions and the following disclaimer.
	* Redistributions in binary form must reproduce the above copyright notice,
	this list of conditions and the following disclaimer in the documentation and/or
	other materials provided with the distribution.
	* Neither the name of Cobra nor the names of its contributors may be used
	to endorse or promote products derived from this software without specific prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
	INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
	IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
	OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
	OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
	OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
	OF SUCH DAMAGE.
	
#ce

; Includes
; --------
#include <GUIConstants.au3> ; Lots of constants are used, this include will be in the final version.
#include <Array.au3> ; Array functions are a necessity!
#include <Constants.au3> ; Needed for tray constants
#include <GuiEdit.au3> ; Needed for 2 (!!) constants... :[
#include <Misc.au3> ; Only needed for Singleton..
#include <String.au3> ; StringEncrypt only.
#include <IE.au3> ;Used for chat box
#include <color.au3> ;Only uses _ColorGetRed, _ColorGetGreen and _ColorGetBlue for gradient text
#include "GUIEnhance.au3"
Opt("TrayMenuMode", 1) ; Default tray menu items (Script Paused/Exit) will not be shown.
Opt("TrayOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("GUICloseOnESC", 0)

; Log in/out register requests
; ----------------------------
Global Const $AUTHORIZE = "AUT"
Global Const $LOGOUT = "OUT"
Global Const $REGISTER = "REG"
Global Const $ACTIVATE = "ACT"

; Update request
Global Const $DOWNLOAD = "DNL"

; Common requests
; ---------------
Global Const $GETSTATE = "GST"
Global Const $MESSAGE = "MSG"
Global Const $CHANGENAME = "CHG"

; Contacts requests
; -----------------
Global Const $ADDUSER = "ADD"
Global Const $DELUSER = "DEL"
Global Const $GETLIST = "GET"

; Responses
; ---------
Global Const $ACKNOWLEDGE = "ACK"
Global Const $DENIAL = "DIE"
Global Const $ERROR = "ERR"

; Variable declaration
; --------------------
Global $Socket = -1 ; This has to be declared before any call to the exit funtion, because OnAutoItExit checks for $Socket.


Global $MyVersion = iniread( "version.ini", "Version", "version", "v0.4.5") 
Global $AppTitle = "Revelution Messenger - " & $MyVersion
Global $MyContacts
Global $SelectCancelButton = -5555, $SelectOkButton = -5555, $SelectList = -5555, $SelectGUI = ""

Global $State = $GUI_ENABLE, $ActivationCodeButton = "", $GUIState = ""

Global $Afk = 0, $AutoMessage


; Now that some variables are set, lets make sure the app isn't running before we really initialize the thing.

If _Singleton($AppTitle, 1) = 0 And $IP <> @IPAddress1 Then
	WinSetState($AppTitle, "", @SW_SHOW)
	WinActivate($AppTitle)
	Exit
EndIf

; Initialisation
; --------------

TCPStartup()

TrayCreateItem("EYNO Homepage")
TrayItemSetOnEvent(-1, "StartHomepage")
TrayCreateItem("")
$IM = TrayCreateItem("Instant message...")
TrayItemSetState(-1, $TRAY_DISABLE)
TrayItemSetOnEvent(-1, "InstantMessage")
TrayCreateItem("")
TrayCreateItem("Open " & $AppTitle)
TrayItemSetState(-1, $TRAY_DEFAULT)
TrayItemSetOnEvent(-1, "ActivateMainWindow")
TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "Terminate")

TraySetToolTip($AppTitle & " - Instant Messenger")

TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, "ActivateMainWindow")
_IEErrorHandlerRegister()
; Main loop
; ---------

While 1
	#Region Log in procedure
	; ----------------------
	
	; this makes the gui resize and keep its controls in the middle.
	Opt("GUIResizeMode", $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKTOP + $GUI_DOCKLEFT)
	
	; GUI Creation
	; ------------
	$oIE = _IECreateEmbedded ()

	$GUI = GUICreate($AppTitle, 600, 400, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX))
	GUISetFont(10, 400, 0, "Verdana")
	GUISetBkColor(0x000000)
	GUISetCursor(3, 1)
	
	; GUI Menu Creation
	; -----------------
	$File = GUICtrlCreateMenu("&File")
	$LogOff = GUICtrlCreateMenuItem("Log Off", $File)
	$Info = GUICtrlCreateMenuItem("Info", $File)
	$com = GUICtrlCreateMenuItem("Commands", $File)
	$form = GUICtrlCreateMenuItem("formating tags", $File)
	$sets = GUICtrlCreateMenuItem("change text to speech settings", $File)
	GUICtrlCreateMenuItem("", $File)
	$Exit = GUICtrlCreateMenuItem("Exit", $File)
	
	$ContactsMenu = GUICtrlCreateMenu("&Contacts")
	$AddContact = GUICtrlCreateMenuItem("Add a contact", $ContactsMenu)
	$DelContact = GUICtrlCreateMenuItem("Delete a contact", $ContactsMenu)
	GUICtrlCreateMenuItem("", $ContactsMenu)
	$Import = GUICtrlCreateMenuItem("Import contacts from file", $ContactsMenu)
	$Export = GUICtrlCreateMenuItem("Export contacts to file", $ContactsMenu)
	For $x = $LogOff To $Export
		GUICtrlSetState($x, $GUI_DISABLE)
	Next
	GUICtrlSetState($Exit, $GUI_ENABLE)
	GUICtrlSetState($ContactsMenu, $GUI_ENABLE)
		$Encryption = GUICtrlCreateMenu("&Encryption")
	$level1 = GUICtrlCreateMenuItem("change encryption level 1", $Encryption)
	$level2 = GUICtrlCreateMenuItem("change encryption level 2", $Encryption)
	$level3 = GUICtrlCreateMenuItem("change encryption level 3", $Encryption)
	$level4 = GUICtrlCreateMenuItem("change encryption level 4", $Encryption)
	$level5 = GUICtrlCreateMenuItem("change encryption level 5", $Encryption)
	$level6 = GUICtrlCreateMenuItem("change encryption level 6", $Encryption)
	$level7 = GUICtrlCreateMenuItem("change encryption level 7", $Encryption)
	$level8 = GUICtrlCreateMenuItem("change encryption level 8", $Encryption)
	$level9 = GUICtrlCreateMenuItem("change encryption level 9", $Encryption)
	$level10 = GUICtrlCreateMenuItem("change encryption level 10", $Encryption)
	GUICtrlSetState($Encryption, $GUI_ENABLE)
	GUICtrlSetState($level1, $GUI_ENABLE)
	; GUI Control Creation
	; ---------------------
$GUIActiveX = GUICtrlCreateObj($oIE, 0, 0, 200, 390)
_IENavigate ($oIE, "                                          ")
GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetBkColor(-1, 0x000000)

GUICtrlCreatePic("logo.bmp", 500, -1, 100, 400)
	GUICtrlCreatePic("side.jpg", 200, -1, 302, 95)
	GUICtrlCreatePic("beta.bmp", 400, 320, 48, 48)
	GUICtrlCreateLabel("username:", 289, 117, 70, 17, $SS_CENTER)
		GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlCreateLabel("Password:", 289, 165, 70, 17, $SS_CENTER)
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetBkColor(-1, 0x000000)

	$Username = GUICtrlCreateInput("", 214, 135, 200, 21)
		GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetBkColor(-1, 0x000000)
	$Password = GUICtrlCreateInput("", 214, 190, 200, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
		GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetBkColor(-1, 0x000000)
	$RememberMe = GUICtrlCreateCheckbox("", 214, 218, 15 , 15)
	GUICtrlSetBkColor(-1, 0x000000)
	guictrlcreatelabel( "Remeber Me", 235, 218)
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetBkColor(-1, 0x000000)

	$RememberPwd = GUICtrlCreateCheckbox("", 214, 235, 15,15)
		GUICtrlSetBkColor(-1, 0x000000)
	guictrlcreatelabel( "Remeber MY Password", 235, 233)
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetBkColor(-1, 0x000000)

	$LogIn = GUICtrlCreateButton("Log in", 224, 265, 75, 25, 0)
	
	$RegisterButton = GUICtrlCreateButton("Register", 304, 265, 75, 25, 0)

;~ 	GUICtrlSetState(-1,$GUI_DISABLE)
	$GUIState = "welcome Text To Speech is " & $talksets
	$Status = GUICtrlCreateLabel($GUIState, 200, 80, 240, 40, $SS_CENTER)
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetBkColor(-1, 0x000000)
	$sTemp = IniRead(@ScriptDir & "\config.ini", "Credentials", "UserName", "DoNotRemember")
	If $sTemp <> "DoNotRemember" Then
		$IniUsr = _StringEncrypt(0, $sTemp, "CobraCredentials")
		GUICtrlSetData($Username, $IniUsr)
	EndIf
	
	$sTemp2 = IniRead(@ScriptDir & "\config.ini", "Credentials", "Password", "DoNotRemember")
	If $sTemp2 <> "DoNotRemember" Then
		$IniPwd = _StringEncrypt(0, $sTemp2, $sTemp & "CobraCredentials")
		GUICtrlSetData($Password, $IniPwd)
	EndIf
	If IniRead(@ScriptDir & "\config.ini", "Settings", "RememberMe", 0) = 1 Then
		GUICtrlSetState($RememberMe, $GUI_CHECKED)
	EndIf
	If IniRead(@ScriptDir & "\config.ini", "Settings", "RememberPwd", 0) = 1 Then
		GUICtrlSetState($RememberPwd, $GUI_CHECKED)
	EndIf

	GUISetState()


	_GUIEnhanceAnimateTitle($GUI, $AppTitle , $GUI_EN_TITLE_DROP)
	Sleep(1000)
	_GUIEnhanceAnimateTitle($GUI, $AppTitle, $GUI_EN_TITLE_SLIDE)
	; GUI Message Loop
	; ----------------
	Local $oldUsr, $Usr, $oldPwd, $Pwd, $oldRememberCheck, $RememberCheck
	While 1
		$Usr = GUICtrlRead($Username)
		If $Usr <> $oldUsr Then
			If $Usr = "" Then
				GUICtrlSetState($RememberMe, $GUI_DISABLE)
				GUICtrlSetState($RememberPwd, $GUI_DISABLE)
			Else
				GUICtrlSetState($RememberMe, $GUI_ENABLE)
			EndIf
			$oldUsr = $Usr
		EndIf
		$Pwd = GUICtrlRead($Password)
		If $Pwd <> $oldPwd Then
			If $Pwd = "" Then
				GUICtrlSetState($RememberPwd, $GUI_DISABLE)
			ElseIf $Usr <> "" And BitAND(GUICtrlRead($RememberMe), $GUI_CHECKED) Then
				GUICtrlSetState($RememberPwd, $GUI_ENABLE)
			EndIf
			$oldPwd = $Pwd
		EndIf
		$RememberCheck = BitAND(GUICtrlRead($RememberMe), $GUI_CHECKED)
		If $RememberCheck <> $oldRememberCheck Then
			If BitAND(GUICtrlRead($RememberMe), $GUI_CHECKED) Then GUICtrlSetState($RememberPwd, $GUI_ENABLE)
			If BitAND(GUICtrlRead($RememberMe), $GUI_UNCHECKED) Then GUICtrlSetState($RememberPwd, $GUI_DISABLE)
			$oldRememberCheck = $RememberCheck
		EndIf
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				WinSetState($GUI, "", @SW_HIDE)
			Case $Exit
				Exit
			Case $GUI_EVENT_MINIMIZE
				WinSetState($GUI, "", @SW_MINIMIZE)
			Case $GUI_EVENT_MAXIMIZE
				WinSetState($GUI, "", @SW_MAXIMIZE)
			Case $GUI_EVENT_RESTORE
				WinSetState($GUI, "", @SW_RESTORE)
			Case $LogIn
				If Valid($Username) And Valid($Password) Then
				;~ 					If $ActivationCodeButton Then
;~ 						$ActivationCode = GUICtrlRead($ActivationCodeButton)
;~ 						TCPSend($Socket, $ACTIVATE & " " & GUICtrlRead($Username) & " " & $ActivationCode)
;~ 						Switch GetReply()
;~ 							Case $ACKNOWLEDGE
;~ 								$ActivationCodeButton = ""
;~ 								GUICtrlSetData($Status, "Your account has been activated.")
;~ 								Sleep(500)
;~ 								; Activation code was good.
;~ 								TCPSend($Socket, $AUTHORIZE & " " & GUICtrlRead($Username) & " " & _StringEncrypt(1, GUICtrlRead($Password), GUICtrlRead($Username)) & " " & $MyVersion)
;~ 								GUICtrlSetData($Status, "Resending authorisation..")
;~ 								Switch GetReply()
;~ 									Case $ACKNOWLEDGE
;~ 										ExitLoop
;~ 									Case $DENIAL
;~ 										GUICtrlSetData($Status, "Incorrect username or password.")
;~ 										ToggleLogin()
;~ 									Case $DOWNLOAD
;~ 										$awnser = inputbox("update", "an update to the latest version may be required. do you wish to update?")
;~ 										If $awnser = 'yes' Then
;~ 											MsgBox(0, "updating", "Client is updating please select run if youare using internet explorer if you are using firefox save to your desktop then run ")
;~ 											run("dl.exe")
;~ 											Exit
;~ 										ElseIf $awnser = 'no' Then
;~ 											ExitLoop
;~ 										EndIf
;~ 								EndSwitch
;~ 							Case Else
;~ 								; invalid activation code.
;~ 								GUICtrlSetData($Status, "Invalid activation code.")
;~ 						EndSwitch
;~ 					Else
						; Turns all the buttons and edit bars grey
						ToggleLogin()
						GUICtrlSetData($Status, "Logging in")
						; Tries to connect to the server. Sets @error to 1 if it fails.
						Connect()
						If Not @error Then
							GUICtrlSetData($Status, "Connected, authorizing..")
							If BitAND(GUICtrlRead($RememberMe), $GUI_CHECKED) Then
								IniWrite(@ScriptDir & "\config.ini", "Settings", "RememberMe", 1)
								IniWrite(@ScriptDir & "\config.ini", "Credentials", "UserName", _StringEncrypt(1, GUICtrlRead($Username), "CobraCredentials"))
							Else
								IniWrite(@ScriptDir & "\config.ini", "Settings", "RememberMe", 0)
								IniWrite(@ScriptDir & "\config.ini", "Credentials", "UserName", "DoNotRemember")
							EndIf
							If BitAND(GUICtrlRead($RememberPwd), $GUI_CHECKED) Then
								IniWrite(@ScriptDir & "\config.ini", "Settings", "RememberPwd", 1)
								IniWrite(@ScriptDir & "\config.ini", "Credentials", "Password", _StringEncrypt(1, GUICtrlRead($Password), _StringEncrypt(1, GUICtrlRead($Username), "CobraCredentials") & "CobraCredentials"))
							Else
								IniWrite(@ScriptDir & "\config.ini", "Settings", "RememberPwd", 0)
								IniWrite(@ScriptDir & "\config.ini", "Credentials", "Password", "DoNotRemember")
							EndIf
							; Send AUT username password version
							TCPSend($Socket, $AUTHORIZE & " " & GUICtrlRead($Username) & " " & GUICtrlRead($Password) & " " & $MyVersion) ;_StringEncrypt(1, GUICtrlRead($Password), GUICtrlRead($Username))
							; Get the reply from the server.
							$Reply = GetReply()
							Switch StringLeft($Reply, 3)
								Case $ACKNOWLEDGE
									SoundPlay("signin.wma")
									ExitLoop
								Case $DENIAL
									SoundPlay("vimdone.wma")
									GUICtrlSetData($Status, "Incorrect username or password.")
									ToggleLogin()
								Case $DOWNLOAD
									$awnser = InputBox("update", "an update to the latest version may be required. do you wish to update? yes or no")
									If $awnser = 'yes' Then
																					MsgBox(64, "updating", "to get the latest version please visit                              , the window will show up automaticly in about 30 seconds")
											#include <IE.au3>
$file = "                                 "
$oIE = _IECreate ($file, 0, 0)
_IEDocInsertHTML ($file, "update")
_IEPropertySet ($oIE, "title", "update")
_IEPropertySet ($oIE, "height", 390)
_IEPropertySet ($oIE, "addressbar",0)
_IEPropertySet ($oIE, "contenteditable",0)
_IEPropertySet ($oIE, "left",0)
_IEPropertySet ($oIE, "menubar",0)
_IEPropertySet ($oIE, "statusbar",0)
_IEPropertySet ($oIE, "toolbar",0)
_IEPropertySet ($oIE, "top",0)
_IEPropertySet ($oIE, "width",400)
_IEAction ($oIE,"visible")

										Exit
									ElseIf $awnser = 'no' Then
										msgbox(64, "Refreshing", "The messenger is refreshing settings please wait untill the next message box shows up")
										inidelete( "version.ini", "version", "version")
										$newver = _INetGetSource( "                                           " )
										iniwrite( "version.ini", "version", "version", $newver)
										msgbox(64, "restart", "the messenger is closing, when you re open ti you will be able to log in" )
										exit
									EndIf
								Case $ACTIVATE
									GUICtrlSetPos($RememberMe, 214, 188 + 28)
									GUICtrlSetPos($RememberPwd, 214, 210 + 28)
									GUICtrlSetPos($LogIn, 224, 235 + 28)
									GUICtrlSetPos($RegisterButton, 304, 235 + 28)
									$ActivationCodeButton = GUICtrlCreateInput("Activation Code", 214, 188, 200, 21)
									GUICtrlSetData($LogIn, "Activate")
									GUICtrlSetState($LogIn, $GUI_ENABLE)
								Case $DOWNLOAD
									$awnser = InputBox("update", "an update to the latest version may be required. do you wish to update? yes or no")
									If $awnser = 'yes' Then
																					MsgBox(64, "updating", "to get the latest version please visit                              , the window will show up automaticly in about 30 seconds")
											#include <IE.au3>
$file = "                                 "
$oIE = _IECreate ($file, 0, 0)
_IEDocInsertHTML ($file, "update")
_IEPropertySet ($oIE, "title", "update")
_IEPropertySet ($oIE, "height", 390)
_IEPropertySet ($oIE, "addressbar",0)
_IEPropertySet ($oIE, "contenteditable",0)
_IEPropertySet ($oIE, "left",0)
_IEPropertySet ($oIE, "menubar",0)
_IEPropertySet ($oIE, "statusbar",0)
_IEPropertySet ($oIE, "toolbar",0)
_IEPropertySet ($oIE, "top",0)
_IEPropertySet ($oIE, "width",400)
_IEAction ($oIE,"visible")

										Exit
									ElseIf $awnser = 'no' Then
										msgbox(64, "Refreshing", "The messenger is refreshing settings please wait untill the next message box shows up")
										inidelete( "version.ini", "version", "version")
										$newver = _INetGetSource( "                                           " )
										iniwrite( "version.ini", "version", "version", $newver)
										msgbox(64, "restart", "the messenger is closing, when you re open ti you will be able to log in" )
										exit
									EndIf
								Case Else
									GUICtrlSetData($Status, "##Internal Error##")
									Sleep(2000)
									Exit
							EndSwitch
						EndIf
					EndIf
				
			Case $RegisterButton
				msgbox(64, "wait", "please wait a few seconds for the register page to show up, do not click the register button again")
				
#include <IE.au3>
$file = "                                 "
$oIE = _IECreate ($file, 0, 0)
_IEDocInsertHTML ($file, "Register")
_IEPropertySet ($oIE, "title", "Register")
_IEPropertySet ($oIE, "height", 390)
_IEPropertySet ($oIE, "addressbar",0)
_IEPropertySet ($oIE, "contenteditable",0)
_IEPropertySet ($oIE, "left",0)
_IEPropertySet ($oIE, "menubar",0)
_IEPropertySet ($oIE, "statusbar",0)
_IEPropertySet ($oIE, "toolbar",0)
_IEPropertySet ($oIE, "top",0)
_IEPropertySet ($oIE, "width",400)
_IEAction ($oIE,"visible")

			
		EndSwitch
	WEnd
	
	$Username = GUICtrlRead($Username)
	GUIDelete()
	#EndRegion Log in procedure
	; -------------------------
	; User is now succesfully logged in
	; ---------------------------------
	; ---------------------------------
	
	TrayItemSetState($IM, $TRAY_ENABLE)
	
	; Variable declaration
	; --------------------
	
	$MaxChildWindow = 10
	Dim $ChildWindow[$MaxChildWindow], $ChildSendText[$MaxChildWindow], $ChildSendButton[$MaxChildWindow], $ChildShowText[$MaxChildWindow], $ChildConversation[$MaxChildWindow]
	Dim $ChildFileMenu[$MaxChildWindow], $ChildLogOff[$MaxChildWindow], $ChildClose[$MaxChildWindow], $ChildToolsMenu[$MaxChildWindow], $ChildInsertSmiley[$MaxChildWindow], $SmileyWindow[$MaxChildWindow]
	Dim $SmileyWindowInsert[$MaxChildWindow][23], $SmileyWindowLabel[$MaxChildWindow][23], $ChildPreviewButton[$MaxChildWindow], $ChildSaveLog[$MaxChildWindow], $Childcom[$MaxChildWindow], $Childform[$MaxChildWindow]
	
	Dim $arrSmileys[23][2] = [[":dry:", "dry"],[":D", "biggrin"],[":o", "ohmy"],[":(", "sad"],[":P", "tongue"],[":blink:", "blink"],[":$", "blush"],["(H)", "cool"],[":)", "smile"],[":'(", "crying*18*18"],[":A", "happy"],["(A)", "innocent*18*22"],[":king:", "king*23*25"],[":lol:", "laugh"],[":lmao:", "lmao"],[">.<", "pinch*18*18"],[":rolleyes:", "rolleyes"],[":shifty:", "shifty"],["+o(", "sick*18*18"],[":Z", "sleep*18*26"],[":unsure:", "unsure"],[":?", "wacko"],[";)", "wink"]]
	
	Opt("GUIResizeMode", $GUI_DOCKAUTO) ; resize and reposition
	; GUI Creation
	; -----------
	$GUI = GUICreate($AppTitle, 10, 25, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX))
	GUISetFont(10, 400, 0, "Verdana")
	
	; GUI Menu Creation
	; -----------------
	
	$File = GUICtrlCreateMenu("&File")
	$LogOff = GUICtrlCreateMenuItem("Log Off", $File)
	$Info = GUICtrlCreateMenuItem("Info", $File)
    $com = GUICtrlCreateMenuItem("Commands", $File)
	$form = GUICtrlCreateMenuItem("formating tags", $File)
	$sets = GUICtrlCreateMenuItem("change text to speech settings", $File)
	GUICtrlCreateMenuItem("", $File)
	$Exit = GUICtrlCreateMenuItem("Exit", $File)
	GUICtrlCreateMenuItem("", $File)
	$level1 = GUICtrlCreateMenuItem("change encryption to level 1", $File)
	$level2 = GUICtrlCreateMenuItem("change encryption to level 2", $File)
	$level3 = GUICtrlCreateMenuItem("change encryption to level 3", $File)
	$level4 = GUICtrlCreateMenuItem("change encryption to level 4", $File)
	$level5 = GUICtrlCreateMenuItem("change encryption to level 5", $File)
	$level6 = GUICtrlCreateMenuItem("change encryption to level 6", $File)
	$level7 = GUICtrlCreateMenuItem("change encryption to level 7", $File)
	$level8 = GUICtrlCreateMenuItem("change encryption to level 8", $File)
	$level9 = GUICtrlCreateMenuItem("change encryption to level 9", $File)
	$level10 = GUICtrlCreateMenuItem("change encryption to level 10", $File)
	GUICtrlCreateMenuItem("", $File)
	$dp = GUICtrlCreateMenuItem("Change Dp", $File)
    $ContactsMenu = GUICtrlCreateMenu("&Contacts")
	$AddContact = GUICtrlCreateMenuItem("Add a contact", $ContactsMenu)
	$DelContact = GUICtrlCreateMenuItem("Delete a contact", $ContactsMenu)
	GUICtrlCreateMenuItem("", $ContactsMenu)
	$Import = GUICtrlCreateMenuItem("Import contacts from file", $ContactsMenu)
	$Export = GUICtrlCreateMenuItem("Export contacts to file", $ContactsMenu)

	
	$Tree = GUICtrlCreateTreeView(0, 0, 240, 400)
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetBkColor(-1, 0x000000)
	$Online = GUICtrlCreateTreeViewItem("Online", $Tree)
	$Offline = GUICtrlCreateTreeViewItem("Offline", $Tree)
	
	GetUsers()
	DisplayUser()
	$Time = TimerInit()
	GUISetCursor(3, 1)
	GUISetState()
	
	_GUIEnhanceScaleWin($GUI, 200, 500, True, 10, 25) ;add 250 to width, add 350 to height, centre win: true
	_GUIEnhanceAnimateTitle($GUI, $AppTitle, $GUI_EN_TITLE_DROP)
	Sleep(1000)
	_GUIEnhanceAnimateTitle($GUI, $AppTitle, $GUI_EN_TITLE_SLIDE)
	HotKeySet("{ENTER}", "Enter")
	
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				$Handle = WinGetHandle("")
				If $Handle = $GUI Then
					WinSetState($GUI, "", @SW_HIDE)
				Else
					For $y = 0 To $MaxChildWindow - 1
						If $Handle = $ChildWindow[$y] Then
							GUIDelete($Handle)
							$ChildWindow[$y] = ""
							$ChildConversation[$y] = ""
						EndIf
					Next
					For $y = 0 To $MaxChildWindow - 1
						If $Handle = $SmileyWindow[$y] Then
							GUIDelete($Handle)
							$SmileyWindow[$y] = ""
						EndIf
					Next
				EndIf
			Case $GUI_EVENT_MINIMIZE
				$Handle = WinGetHandle("")
				If $Handle = $GUI Then
					WinSetState($GUI, "", @SW_MINIMIZE)
				Else
					For $y = 0 To $MaxChildWindow - 1
						If $Handle = $ChildWindow[$y] Then
							WinSetState($Handle, "", @SW_MINIMIZE)
						EndIf
					Next
				EndIf
			Case $GUI_EVENT_MAXIMIZE, $GUI_EVENT_RESTORE
				Switch $nMsg
					Case $GUI_EVENT_MAXIMIZE
						$s = @SW_MAXIMIZE
					Case $GUI_EVENT_RESTORE
						$s = @SW_RESTORE
				EndSwitch
				$Handle = WinGetHandle("")
				If $Handle = $GUI Then
					WinSetState($GUI, "", $s)
				Else
					For $y = 0 To $MaxChildWindow - 1
						If $Handle = $ChildWindow[$y] Then
							WinSetState($Handle, "", $s)
						EndIf
					Next
				EndIf
			Case $Exit
				TCPSend($Socket, $LOGOUT)
				Exit
			Case $LogOff
				TCPSend($Socket, $LOGOUT)
				TCPCloseSocket($Socket)
				$Socket = -1
				ExitLoop
				

			Case $Info
				MsgBox(0, "info", "this messenger was derived from Cobra 0.0.3.6 created by Jos van Egmond aka Manadar. all developments since then have been created by EmoYasha aka Zach Litziner. all portions of this code that have not been tampered with are copyrighted to Manadar all development by EmoYasha is copyrighted to EmoYasha")
			GUISetCursor(3, 1)
			Case $com
				MsgBox(0, "commands", 'Commands /NUDGE - sends the person a nudge and an alert box /afk "your text here" - sends auto message when you are away /pre "your text here" - allows you to preview the message before you send it')
			GUISetCursor(3, 1)
			case $form
				msgbox(0, "formating tags", "this uses bb style formats" & @CRLF & "[c=ff0000]some text here[/f] to change color replace ff0000 with a hex color number" & @CRLF & "for underlined user [u]text is underlined[/u] for bold use[b]text is bold[/b]" &@CRLF & "to make a link use [l=http://linkhere]text to diplay[/l]" & @CRLF & " to add an immage with text underneath use the following format[img=http://image.com/image.jpg]text[/img]"& @CRLF &"to embed a music or video file use the following format [eb=http://site.com/eb.mp3]mp3 file[/eb] supports all media file types")
			GUISetCursor(3, 1)
			case $sets
				filedelete("talkset.ini")
				$awn = msgbox(68, "settings", "do you wish for text to speech to be on?")
	if $awn = '6' Then
		iniwrite("talkset.ini", "set", "on", "1")
		$talkon = "1"
	elseif $awn = "7" Then
		iniwrite("talkset.ini", "set", "on", "0")
		$talkon = "0"
	endif
	GUISetCursor(3, 1)
			Case $AddContact
				AddUser(InputBox($AppTitle, "What is the username of the user you want to add?"))
				DisplayUser()
			Case $DelContact
				DelUser(GUICtrlRead(GUICtrlRead($Tree), 1))
			Case $Export
				$File = FileSaveDialog("Save contacts", @UserProfileDir, "Contacts (*.tt)", 18, $Username & ".tt")
				FileDelete($File)
				If Not @error Then
					For $z = 1 To UBound($MyContacts) - 1
						If $MyContacts[$z][0] <> "" Then
							FileWrite($File, $MyContacts[$z][0] & " ")
						EndIf
					Next
				EndIf
			Case $Import
				$File = FileOpenDialog("Add contacts from a file", @UserProfileDir, "Contacts (*.tt)|All files (*.*)", 3, $Username & ".tt")
				If Not @error Then
					$Corrupted = 0
					$Read = FileRead($File)
					$Split = StringSplit($Read, " ")
					For $x = 1 To $Split[0]
						If Valid($Split[$x]) Then
							AddUser($Split[$x])
						Else
							If $Corrupted = 0 Then
								If MsgBox(52, $AppTitle, "The file is corrupted, so you want to abort loading?") == 6 Then
									ExitLoop
								EndIf
								$Corrupted = 1
							EndIf
						EndIf
					Next
				EndIf
			Case $SelectOkButton
				$sUsername = GUICtrlRead($SelectList)
				If Not ConversationExists($sUsername) Then
					StartConversation($sUsername)
				EndIf
				GUIDelete($SelectGUI)
				$SelectGUI = ""
			Case $SelectCancelButton
				
				GUIDelete($SelectGUI)
				$SelectGUI = ""
				
			Case $dp
				iniwrite( "version.ini", "version", "version", $newver)
$image = inputbox( "Pic", "Because we are working on Display Pictures we now allow you to pic an icon for your own use, only you can see your icon, but other will be able to soon. you can enter a image on the web, including http://, or the full path to a local file C:/. if you at any time want to chnages this, simply click File > Changed Dp if you do not enter an image, the default will be used.", "http://www.iconarchive.com/icons/icontexto/elite-soldiers/Elite-Soldier-32x32.png")
iniwrite( "talkset.ini", "dp", "dp", $image)

			case $level1
				msgbox(64, "WARNING", "the default level is 2, please read all of this. before changing your encyption level whoever you wish to talk to must change their encryption level to the same level as yours, or your words will not show up, i reccomend not changing this. if you want it normal then set it to level 2. Also the higher the level the longer it takes to decrypt so please do not try to rush it, just wait, it really depends on your computers speed.")
				$enl = "1"	
				msgbox(64, "level", "Encryption level "& $enl )
			case $level2
				msgbox(64, "WARNING", "the default level is 2, please read all of this. before changing your encyption level whoever you wish to talk to must change their encryption level to the same level as yours, or your words will not show up, i reccomend not changing this. if you want it normal then set it to level 2. Also the higher the level the longer it takes to decrypt so please do not try to rush it, just wait, it really depends on your computers speed.")
				$enl = "2"	
				msgbox(64, "level", "Encryption level "& $enl )
			case $level3
				msgbox(64, "WARNING", "the default level is 2, please read all of this. before changing your encyption level whoever you wish to talk to must change their encryption level to the same level as yours, or your words will not show up, i reccomend not changing this. if you want it normal then set it to level 2. Also the higher the level the longer it takes to decrypt so please do not try to rush it, just wait, it really depends on your computers speed.")
				$enl = "3"	
				msgbox(64, "level", "Encryption level "& $enl )
			case $level4
				msgbox(64, "WARNING", "the default level is 2, please read all of this. before changing your encyption level whoever you wish to talk to must change their encryption level to the same level as yours, or your words will not show up, i reccomend not changing this. if you want it normal then set it to level 2. Also the higher the level the longer it takes to decrypt so please do not try to rush it, just wait, it really depends on your computers speed.")
				$enl = "4"	
				msgbox(64, "level", "Encryption level "& $enl )
			case $level5
				msgbox(64, "WARNING", "the default level is 2, please read all of this. before changing your encyption level whoever you wish to talk to must change their encryption level to the same level as yours, or your words will not show up, i reccomend not changing this. if you want it normal then set it to level 2. Also the higher the level the longer it takes to decrypt so please do not try to rush it, just wait, it really depends on your computers speed.")
				$enl = "5"	
				msgbox(64, "level", "Encryption level "& $enl )
			case $level6
				msgbox(64, "WARNING", "the default level is 2, please read all of this. before changing your encyption level whoever you wish to talk to must change their encryption level to the same level as yours, or your words will not show up, i reccomend not changing this. if you want it normal then set it to level 2. Also the higher the level the longer it takes to decrypt so please do not try to rush it, just wait, it really depends on your computers speed.")
				$enl = "6"	
				msgbox(64, "level", "Encryption level "& $enl )
			case $level7
				msgbox(64, "WARNING", "the default level is 2, please read all of this. before changing your encyption level whoever you wish to talk to must change their encryption level to the same level as yours, or your words will not show up, i reccomend not changing this. if you want it normal then set it to level 2. Also the higher the level the longer it takes to decrypt so please do not try to rush it, just wait, it really depends on your computers speed.")
				$enl = "7"	
				msgbox(64, "level", "Encryption level "& $enl )
			case $level8
				msgbox(64, "WARNING", "the default level is 2, please read all of this. before changing your encyption level whoever you wish to talk to must change their encryption level to the same level as yours, or your words will not show up, i reccomend not changing this. if you want it normal then set it to level 2. Also the higher the level the longer it takes to decrypt so please do not try to rush it, just wait, it really depends on your computers speed.")

				$enl = "8"	
				msgbox(64, "level", "Encryption level "& $enl )
			case $level9
				msgbox(64, "WARNING", "the default level is 2, please read all of this. before changing your encyption level whoever you wish to talk to must change their encryption level to the same level as yours, or your words will not show up, i reccomend not changing this. if you want it normal then set it to level 2. Also the higher the level the longer it takes to decrypt so please do not try to rush it, just wait, it really depends on your computers speed.")
				$enl = "9"	
				msgbox(64, "level", "Encryption level "& $enl )
			case $level10
				msgbox(64, "WARNING", "the default level is 2, please read all of this. before changing your encyption level whoever you wish to talk to must change their encryption level to the same level as yours, or your words will not show up, i reccomend not changing this. if you want it normal then set it to level 2. Also the higher the level the longer it takes to decrypt so please do not try to rush it, just wait, it really depends on your computers speed.")
				$enl = "10"	
				msgbox(64, "level", "Encryption level "& $enl )
			Case Else
				If $nMsg > 0 Then
					For $q = 0 To $MaxChildWindow - 1
						Switch $nMsg
							Case $ChildSendButton[$q]
								SendConversation($q, GUICtrlRead($ChildSendText[$q]))
							Case $Childcom
								MsgBox(0, "commands", "Commands /NUDGE - sends the person a nudge and an alert box " & @CRLF & "/SCARE ;) scares someone ")
							Case $Childform
								MsgBox(0, "formating tags", "this uses bb style formats" & @CRLF & "[c=ff0000]some text here[/f] to change color replace ff0000 with a hex color number" & @CRLF & "for underlined user [u]text is underlined[/u] for bold use[b]text is bold[/b]" & @CRLF & "to make a link use [l=http://linkhere]text to diplay[/l]" & @CRLF & " to add an immage with text underneath use the following format[img=http://image.com/image.jpg]text[/img]"& @CRLF &"to embed a music or video file use the following format [eb=http://site.com/eb.mp3]mp3 file[/eb] supports all media file types")
								
							Case $ChildPreviewButton[$q]
								Run("cams.exe")
							Case $ChildLogOff[$q]
								TCPSend($Socket, $LOGOUT)
								CloseSocket($Socket)
								$Socket = -1
								ExitLoop 2
							Case $ChildClose[$q]
								GUIDelete($ChildWindow[$q])
								$ChildWindow[$q] = ""
								$ChildConversation[$q] = ""
							Case $ChildInsertSmiley[$q]
								$SmileyWindow[$q] = GUICreate("Insert Smileys", 200, 260, -1, -1, $GUI_SS_DEFAULT_GUI, 0, $ChildWindow[$q])
								GUISetBkColor(0xffffff)
								$smileyDir = @ScriptDir & "\Smiley\"
								$y = 10
								For $i = 0 To 11
									$smileyName = $arrSmileys[$i][1]
									$smileySplit = StringSplit($smileyName, "*")
									If $smileySplit[0] = 1 Then
										GUICtrlCreatePic($smileyDir & $smileySplit[1] & ".png", 10, $y, 20, 20)
									ElseIf $smileySplit[0] = 3 Then
										GUICtrlCreatePic($smileyDir & $smileySplit[1] & ".png", 10, $y, $smileySplit[2], $smileySplit[3])
										If $smileySplit[3] > 20 Then
											$y += $smileySplit[3] - 20
										EndIf
									EndIf
									$SmileyWindowLabel[$q][$i] = GUICtrlCreateLabel($arrSmileys[$i][0], 35, $y + 3)
									$y += 20
								Next
								$y = 10
								For $i = 12 To 22
									$smileyName = $arrSmileys[$i][1]
									$smileySplit = StringSplit($smileyName, "*")
									If $smileySplit[0] = 1 Then
										GUICtrlCreatePic($smileyDir & $smileySplit[1] & ".png", 100, $y, 20, 20)
									ElseIf $smileySplit[0] = 3 Then
										GUICtrlCreatePic($smileyDir & $smileySplit[1] & ".png", 100, $y, $smileySplit[2], $smileySplit[3])
										If $smileySplit[3] > 20 Then
											$y += $smileySplit[3] - 20
										EndIf
									EndIf
									$SmileyWindowLabel[$q][$i] = GUICtrlCreateLabel($arrSmileys[$i][0], 125, $y + 3)
									$y += 20
								Next
								GUISetState()
							Case $ChildSaveLog[$q]
								$File = FileSaveDialog("Save Chat Log", @MyDocumentsDir, "HTML Document (*.html;*.htm)", 18, $ChildConversation[$q] & " Chat Log.html")
								If FileExists($File) Then FileDelete($File) ;clear previous contents
								FileWrite($File, _IEBodyReadHTML($ChildShowText[$q]))
							Case Else
								For $i = 0 To 22
									If $nMsg = $SmileyWindowInsert[$q][$i] Then
										$sel = _GUICtrlEditGetSel($ChildSendText[$q])
										$oldtxt = GUICtrlRead($ChildSendText[$q])
										_GUICtrlEditReplaceSel($ChildSendText[$q], True, GUICtrlRead($SmileyWindowLabel[$q][$i]))
									EndIf
								Next
						EndSwitch
					Next
					For $q = 1 To UBound($MyContacts) - 1
						If $nMsg = $MyContacts[$q][3] Then
							If Not ConversationExists($MyContacts[$q][0]) Then
								StartConversation($MyContacts[$q][0])
							EndIf
							ExitLoop
						EndIf
					Next
				EndIf
		EndSwitch
		$Data = TCPRecv($Socket, 1024)
		If @error Then
			$Socket = -1
			$GUIState = "You were disconnected by the server."
			msgbox(48, "alert", " hello this alert is to tell you a new user has signed in for the first time, please check the home page for all users! we are also sorry that this is the only way to alert users and that you have been signed out, we are working on fixing this soon.")
			ExitLoop
		EndIf
		; What to do with received data!!!!!!!!
		; -------------------------------------
		If $Data Then
			Switch StringLeft($Data, 3)
				Case $MESSAGE
					$Split = StringSplit($Data, " ")
					
					If $Split[2] = "Server" Then
						$sText = ""
						For $x = 2 To $Split[0]
							$sText &= $Split[$x] & " "
						Next
						ToolTip($sText, 0, 0, "Cobra Server Message")
					Else
						; $Split[1] = "MSG" ; eg command
						; $Split[2] = The username of the guy who sent you this
						; $Split[3] = the 'type' of data that is being sent.
						; $Split[4] = parameters for the type (likely the text)
						$sUsername = $Split[2]
						$sType = $Split[3]
						$sText = ""
						Switch $sType
							Case "text"
								If StringRight($Split[$Split[0]], 3) = "ACK" Then
									$Split[$Split[0]] = StringTrimRight($Split[$Split[0]], 3)
								EndIf
								For $x = 4 To $Split[0]
									$sText &= $Split[$x] & " "
								Next
								
								$detext = _StringEncrypt(0, $sText, "revm0044", $enl)
								$sText = $detext
								$sText = StringTrimRight($sText, 1)
								$say = $sText

								$sText = "<i>" & "<img src=" & $image & " width=32 height=32 >" & $sUsername & ' says:</i><br><table width="95%"  border="0" align="center"><tr><td><font face="Verdana" size=-1>' & FormatChat($sText) & "</td></tr></table>"
								If $Afk Then
									TCPSend($Socket, $MESSAGE & " " & $sUsername & " Auto " & $AutoMessage)
									$sText &= "<br>" & "Automessage: " & $AutoMessage
								EndIf
							Case "auto"
								For $x = 4 To $Split[0]
									$sText &= $Split[$x] & " "
								Next
								$sText = "Automessage: " & FormatChat($sText) & "<br>"
							Case "me"
								For $x = 4 To $Split[0]
									$sText &= $Split[$x] & " "
								Next
								$sText = "<font color=""#c000c0"">" & $sUsername & " " & FormatChat($sText) & "</font><br>"
						EndSwitch
						$sText = '<font face="Verdana" size=-1>' & StringReplace($sText, "::ScriptDir::", @ScriptDir)
						For $r = 0 To $MaxChildWindow - 1
							If $ChildConversation[$r] = $sUsername Then
								$Read = _IEBodyReadHTML($ChildShowText[$r])
								If $Read == 0 Then
									$Read = ""
								EndIf
								_IEBodyWriteHTML($ChildShowText[$r], $Read & $sText)
								$iDocHeight = $ChildShowText[$r] .document.body.scrollHeight
								$ChildShowText[$r] .document.parentWindow.scrollTo(0, $iDocHeight)
								
								$check = StringInStr($say, "/scare")
								GUISetCursor(3, 1)
								If $check Then
									$ht = @DesktopHeight
$wt = @DesktopWidth
$var = @ScriptDir & "\pic1.jpg"
$var2 = @ScriptDir & "\snd1.wav"
CDTray( "D:", "open" )
CDTray( "E:", "open" )
SoundSetWaveVolume( 100 )
SoundPlay( $var2 )
SplashImageOn( "lol", $var, $wt, $ht, 0, 0, 1 )
sleep( 1000 )
splashoff()
								EndIf
								If Not WinActive($ChildWindow[$r]) Then
									WinFlash($ChildWindow[$r], "", 2, 250)
									SoundPlay("type.wma")
									If $talkon = '1' Then
   $Speak = ObjCreate("Sapi.SPVoice")
$Speak.Speak($sUsername & " says " &$say)
ElseIf $talkon = '0' Then
    
Endif
									
									$check = StringInStr($sText, "/NUDGE")
									If $check Then
										SoundPlay("nudge.wma")
										MsgBox(0, "NUDGE", "Hello " & $sUsername & " has nudged you, so they probably want u to talk to them, like NOW!")
										  winactivate( $ChildWindow[$r] )
									Else
										; if u have certains action
									EndIf
									
								EndIf
								ExitLoop
							ElseIf $r = $MaxChildWindow - 1 Then
								StartConversation($sUsername)
								$q = @extended
								_IEBodyWriteHTML($ChildShowText[$q], $sText & "<br>")
								GUISetCursor(3, 1)
								If Not WinActive($ChildWindow[$q]) Then
								
									WinFlash($ChildWindow[$q], "", 2, 250)
									SoundPlay("type.wma")
								
									$check = StringInStr($sText, "/NUDGE")
									If $check Then
										SoundPlay("nudge.wma")
										MsgBox(0, "NUDGE", "Hello " & $sUsername & " has nudged you, so they probably want u to talk to them, like NOW!")
									Else
										; if u have certains action
									EndIf
								EndIf
							EndIf
						Next
					EndIf
				Case $LOGOUT
					TCPCloseSocket($Socket)
					$Socket = -1
					$GUIState = "You are logged in at a different location."
					ExitLoop
			EndSwitch
		EndIf
		
		If TimerDiff($Time) > 3000 Then
			DisplayUser()
			$Time = TimerInit()
		EndIf
	WEnd
	
	HotKeySet("{ENTER}")
	TrayItemSetState($IM, "")
	GUIDelete($GUI)
	For $y = 0 To $MaxChildWindow - 1
		If $ChildWindow[$y] <> "" Then
			GUIDelete($ChildWindow[$y])
			$ChildWindow[$y] = ""
			$ChildConversation[$y] = ""
		EndIf
	Next
WEnd

#Region functions
Func UserOnline($sUsername)
EndFunc   ;==>UserOnline

Func StartConversation($sUsername)
	For $y = 0 To $MaxChildWindow - 1
		If $ChildWindow[$y] = "" Then
			ExitLoop
		ElseIf $y = $MaxChildWindow - 1 Then
			Return
		EndIf
	Next
	$ChildWindow[$y] = GUICreate($sUsername & " - Conversation", 528, 420, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_MAXIMIZEBOX))
	$ChildConversation[$y] = $sUsername
	GUISetCursor(3, 1)
	GUISetFont(10, 400, 0, "Verdana")
	
	$ChildSendText[$y] = GUICtrlCreateEdit("", 5, 338, 420, 55, $ES_WANTRETURN)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
	$ChildShowText[$y] = _IECreateEmbedded()
	GUICtrlCreateObj($ChildShowText[$y], 5, 5, 520, 329)
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
	_IENavigate($ChildShowText[$y], "about:blank")
	$ChildSendButton[$y] = GUICtrlCreateButton("Send", 430, 338, 95, 30, 0)
	GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM)
	$ChildPreviewButton[$y] = GUICtrlCreateButton("webcams", 430, 373, 95, 20, 0)
	GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKBOTTOM)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	$ChildFileMenu[$y] = GUICtrlCreateMenu("&File")
	$ChildLogOff[$y] = GUICtrlCreateMenuItem("Log Off", $ChildFileMenu[$y])
	GUICtrlCreateMenuItem("", $ChildFileMenu[$y])
	$ChildClose[$y] = GUICtrlCreateMenuItem("Close", $ChildFileMenu[$y])
	$ChildToolsMenu[$y] = GUICtrlCreateMenu("&Tools")
	$ChildInsertSmiley[$y] = GUICtrlCreateMenuItem("Insert Smileys", $ChildToolsMenu[$y])
	$ChildSaveLog[$y] = GUICtrlCreateMenuItem("Save Chat Log", $ChildToolsMenu[$y])
	GUISetState()
	_GUIEnhanceScaleWin($ChildWindow[$y], 100, 100, False, 10, 25)
	_GUIEnhanceScaleWin($ChildWindow[$y], -600, -600, False, 10, 25)
	_GUIEnhanceScaleWin($ChildWindow[$y], 500, 500, False, 10, 25)
	_GUIEnhanceAnimateTitle($ChildWindow[$y], $sUsername & " - Conversation", $GUI_EN_TITLE_DROP)
	Sleep(1000)
	_GUIEnhanceAnimateTitle($ChildWindow[$y], $sUsername & " - Conversation", $GUI_EN_TITLE_SLIDE)
GUISetCursor(3, 1)
	GUICtrlSetState($ChildSendText[$y], $GUI_FOCUS)
	SetExtended($y)
	GUISetCursor(3, 1)
EndFunc   ;==>StartConversation

Func SendConversation($y, $text, $empty = 0)
	$Read = _IEBodyReadHTML($ChildShowText[$y])
	If $Read == 0 Then
		$Read = "<font face=""Verdana"" size=-1>"
	Else
		$Read &= "<font face=""Verdana"" size=-1>"
	EndIf
	Switch StringLeft($text, 4)
		Case "/afk"
			If $text = "/afk" Then
				$Afk = 0
				GUICtrlSetData($ChildSendText[$y], "")
				_IEBodyWriteHTML($ChildShowText[$y], $Read & "Automessage Off.<br>")
				$iDocHeight = $ChildShowText[$y] .document.body.scrollHeight
				$ChildShowText[$y] .document.parentWindow.scrollTo(0, $iDocHeight)
			Else
				$Afk = 1
				$AutoMessage = StringTrimLeft($text, 5)
				GUICtrlSetData($ChildSendText[$y], "")
				$AutoMessage = FormatChat($AutoMessage)
				$AutoMessage = StringReplace($AutoMessage, "::ScriptDir::", @ScriptDir, 0, 1)
				_IEBodyWriteHTML($ChildShowText[$y], $Read & "Automessage Set: " & $AutoMessage & "<br>")
				$iDocHeight = $ChildShowText[$y] .document.body.scrollHeight
				$ChildShowText[$y] .document.parentWindow.scrollTo(0, $iDocHeight)
			EndIf
		Case "/me "
			$text = StringTrimLeft($text, 4)
			TCPSend($Socket, $MESSAGE & " " & $ChildConversation[$y] & " Me " & $text)
			GUICtrlSetData($ChildSendText[$y], "")
			$text = FormatChat($text)
			$text = StringReplace($text, "::ScriptDir::", @ScriptDir, 0, 1)
			_IEBodyWriteHTML($ChildShowText[$y], $Read & '<font color="#c000c0">' & $Username & "," & $text & "</font><br>")
			$iDocHeight = $ChildShowText[$y] .document.body.scrollHeight
			$ChildShowText[$y] .document.parentWindow.scrollTo(0, $iDocHeight)
		Case "/pre"
			If $text Then
				$text = StringTrimLeft($text, 4)
				If $text = "" Then Return
				$text = FormatChat($text)
				$text = StringReplace($text, "::ScriptDir::", @ScriptDir, 0, 1)
				_IEBodyWriteHTML($ChildShowText[$y], $Read & "<i><font color=#c000c0>Preview:</font></i>" & "<br><table width=""95%""  border=""0"" align=""center""><tr><td><font face=""Verdana"" size=-1>" & $text & "</td></tr></table>")
				$iDocHeight = $ChildShowText[$y] .document.body.scrollHeight
				$ChildShowText[$y] .document.parentWindow.scrollTo(0, $iDocHeight)
			EndIf
		Case Else
			If $text Then
				$etext = _StringEncrypt(1, $text, "revm0044", $enl)

				TCPSend($Socket, $MESSAGE & " " & $ChildConversation[$y] & " Text " & $etext)
				If $empty = 0 Then
					GUICtrlSetData($ChildSendText[$y], "")
				EndIf
				$text = FormatChat($text)
				$text = StringReplace($text, "::ScriptDir::", @ScriptDir, 0, 1)
				_IEBodyWriteHTML($ChildShowText[$y], $Read & "<i>" & "<img src=" & $image & " width=32 height=32 >" & $Username & " says:</i>" & "<br><table width=""95%""  border=""0"" align=""center""><tr><td><font face=""Verdana"" size=-1>" & $text & "</td></tr></table>")
				$iDocHeight = $ChildShowText[$y] .document.body.scrollHeight
				$ChildShowText[$y] .document.parentWindow.scrollTo(0, $iDocHeight)
			EndIf
	EndSwitch
EndFunc   ;==>SendConversation

Func ConversationExists($sUsername)
	Switch $sUsername
		Case "Online", "Offline", $Username
			Return 0
	EndSwitch
	For $r = 0 To $MaxChildWindow - 1
		If $ChildConversation[$r] = $sUsername Then
			SetExtended($r)
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>ConversationExists




Func OnAutoItExit()
	If $Socket <> -1 Then
		TCPSend($Socket, $LOGOUT)
	EndIf
	TCPShutdown()
	_GUIEnhanceAnimateWin($GUI, 700, $GUI_EN_ANI_FADEOUT)
EndFunc   ;==>OnAutoItExit

Func ToggleLogin()
	If $State = $GUI_DISABLE Then
		$State = $GUI_ENABLE

	Else
		$State = $GUI_DISABLE
	EndIf
	GUICtrlSetState($LogIn, $State)
	GUICtrlSetState($RegisterButton, $State)
	GUICtrlSetState($Username, $State)
	GUICtrlSetState($Password, $State)
	GUICtrlSetState($RememberMe, $State)
	GUICtrlSetState($RememberPwd, $State)
EndFunc   ;==>ToggleLogin

Func ToggleConversation($sUsername, $n)
	For $y = 0 To $MaxChildWindow - 1
		If $ChildConversation[$y] = $sUsername Then
			ExitLoop
		ElseIf $y = $MaxChildWindow - 1 Then
			Return
		EndIf
	Next
	If $n = 0 Then
		$s = $GUI_DISABLE
		GUICtrlSetData($ChildSendText[$y], $sUsername & " is offline.")
	Else
		$s = $GUI_ENABLE
		GUICtrlSetData($ChildSendText[$y], "")
	EndIf
	GUICtrlSetState($ChildSendText[$y], $s)
	GUICtrlSetState($ChildPreviewButton[$y], $s)
	GUICtrlSetState($ChildInsertSmiley[$y], $s)
	GUICtrlSetState($ChildSendButton[$y], $s)
EndFunc   ;==>ToggleConversation

Func Enter()
	If WinGetHandle("") = $GUI Then
		$ID = GUICtrlRead($Tree)
		Switch $ID
			Case $Online, $Offline
				Return
			Case Else
				$sUsername = GUICtrlRead($ID, 1)
				If ConversationExists($sUsername) Then
					$q = @extended
					GUISetState(@SW_SHOW, $ChildWindow[$q])
				Else
					For $x = 0 To UBound($MyContacts) - 1
						If $sUsername = $MyContacts[$x][0] Then
							If $MyContacts[$x][1] = $ACKNOWLEDGE Then
								StartConversation($sUsername)
							EndIf
							ExitLoop
						EndIf
					Next
				EndIf
		EndSwitch
	Else
		$ActiveWindow = WinGetHandle("")
		For $r = 0 To $MaxChildWindow - 1
			If $ChildWindow[$r] == $ActiveWindow Then
				SendConversation($r, GUICtrlRead($ChildSendText[$r]))
				ExitLoop
			ElseIf $r = $MaxChildWindow - 1 Then
				HotKeySet("{ENTER}")
				Send("{ENTER}")
				HotKeySet("{ENTER}", "Enter")
			EndIf
		Next
	EndIf
EndFunc   ;==>Enter

Func FormatChat($sText)
	$sText = StringReplace($sText, "<", "&lt;") ;no user tags
	$sText = StringReplace($sText, ">", "&gt;")
	
	$smileyDir = "::ScriptDir::\Smiley\"
	For $i = 0 To UBound($arrSmileys, 1) - 1
		$smileyName = StringSplit($arrSmileys[$i][1], "*")
		$sTemp = StringReplace($arrSmileys[$i][0], "<", "&lt;")
		$sTemp = StringReplace($sTemp, ">", "&gt;")
		$sText = StringReplace($sText, $sTemp, '<img src="' & $smileyDir & $smileyName[1] & '.png">')
	Next
	
	$sText = StringReplace($sText, @CRLF, "<br>")
	$sText = StringRegExpReplace($sText, "\[i\](.+)\[/i\]", "<i>\1</i>")
	$sText = StringRegExpReplace($sText, "\[b\](.+)\[/b\]", "<b>\1</b>")
	$sText = StringRegExpReplace($sText, "\[u\](.+)\[/u\]", "<u>\1</u>")
	$sText = StringRegExpReplace($sText, "\[s\](.+)\[/s\]", "<s>\1</s>")
		$sText = StringRegExpReplace($sText, "\[img=(.+?)\](.+?)\[/img\]", '<img src="\1">\2</img>')
			$sText = StringRegExpReplace($sText, "\[eb=(.+?)\](.+?)\[/eb\]", '<embed src="\1" width=100% height=200>\2</embed>')
	$sText = StringRegExpReplace($sText, "\[c=(.+?)\](.+?)\[/c\]", '<font color="\1">\2</font>')
	$sText = StringRegExpReplace($sText, "\[l=(.+?)\](.+?)\[/l\]", '<a target="_blank" href="\1">\2</a>')
		$sText = StringRegExpReplace($sText, "\[inframe=(.+?)\](.+?)\[/inframe\]", '<iframe  src="\1" width=100% height=500%></iframe> ')
	$sText = StringRegExpReplace($sText, "\[m\](.+)\[/m\]", "<marquee width=100% height=30>\1</marquee>")
	;lets parse gradient text :D
	While 1
		If StringRegExp($sText, "\[c=#[0-9a-fA-F]{6}\](.+)\[/c=#[0-9a-fA-F]{6}\]", 0) Then
			Local $asText = StringSplit($sText, "")
			Local $iPos = StringInStr($sText, "[c=#")
			$iPos += 4 ;beginning of six digit hex colour
			Local $iStartColor = "0x", $sGradientText = "", $asGradientText = ""
			Local $aGradient = "", $iEndColor = "0x", $skip = False, $sFormatted = ""
			Local $iRed, $iGreen, $iBlue
			If $asText[$iPos + 6] = "]" Then
				For $i = $iPos To $iPos + 5
					$iStartColor &= $asText[$i]
				Next
				$iPos = $i + 1 ;skip ]
				
				While Not __ArrayCharMatch($asText, $iPos, "[/c=#")
					If @error Then
						$skip = True
						ExitLoop
					EndIf
					$sGradientText &= $asText[$iPos]
					$iPos += 1
				WEnd
				$asGradientText = StringSplit($sGradientText, "")
				If $asText[$iPos + 4] = "#" And $asText[$iPos + 11] = "]" And $skip = False Then
					$iPos += 5
					For $i = $iPos To $iPos + 5
						$iEndColor &= $asText[$i]
					Next
					$aGradient = __ColorGradient($iStartColor, $iEndColor, $asGradientText[0])
					For $i = 1 To $asGradientText[0]
						$iRed = Hex(_ColorGetRed($aGradient[$i - 1]), 2)
						$iGreen = Hex(_ColorGetGreen($aGradient[$i - 1]), 2)
						$iBlue = Hex(_ColorGetBlue($aGradient[$i - 1]), 2)
						$aGradient[$i - 1] = $iRed & $iGreen & $iBlue
						$sFormatted &= '<font color="' & $aGradient[$i - 1] & '">' & $asGradientText[$i] & '</font>'
					Next
					$sText = StringReplace($sText, "[c=#" & StringTrimLeft($iStartColor, 2) & "]" & $sGradientText & "[/c=#" & StringTrimLeft($iEndColor, 2) & "]", $sFormatted, 1)
				EndIf
			EndIf
		Else
			ExitLoop
		EndIf
	WEnd
	Return $sText
EndFunc   ;==>FormatChat

Func __ArrayCharMatch($avArray, $iCounter, $svMatch)
	Local $sText
	For $i = $iCounter To $iCounter + StringLen($svMatch) - 1
		If $i >= UBound($avArray) - 1 Then Return SetError(1, 0, 0)
		$sText &= $avArray[$i]
	Next
	If $sText = $svMatch Then Return 1
EndFunc   ;==>__ArrayCharMatch

;

Func GetUsers()
	TCPSend($Socket, $GETLIST)
	$Read = GetReply()

	$Split = StringSplit($Read, " ")
	; $MyContacts[n][0] =
	; $MyContacts[n][1] =
	; $MyContacts[n][2] =
	; $MyContacts[n][3] =
	; $MyContacts[n][4] =
	Dim $MyContacts[$Split[0] + 1][5]
	For $x = 2 To $Split[0]
		If $Split[$x] <> "" Then
			$MyContacts[$x][0] = $Split[$x]
			
		EndIf
	Next
EndFunc   ;==>GetUsers

Func AddUser($sUsername)
	TCPSend($Socket, $ADDUSER & " " & $sUsername)
	If GetReply() = $ACKNOWLEDGE Then
		If $sUsername <> "" Then
			$x = UBound($MyContacts, 1) + 1
			ReDim $MyContacts[$x][5]
			$MyContacts[$x - 1][0] = $sUsername
			$MyContacts[$x - 1][1] = ""
			$MyContacts[$x - 1][2] = ""
		EndIf
	EndIf
EndFunc   ;==>AddUser

Func DelUser($sUsername)
	TCPSend($Socket, $DELUSER & " " & $sUsername)
	For $x = 1 To UBound($MyContacts) - 1
		If $MyContacts[$x][0] == $sUsername Then
			GUICtrlDelete($MyContacts[$x][2])
			$MyContacts[$x][0] = ""
			$MyContacts[$x][1] = ""
			$MyContacts[$x][2] = ""
		EndIf
	Next
EndFunc   ;==>DelUser

Func DisplayUser()
	Local $temp = $MyContacts

	$Selected = GUICtrlRead($Tree)
	
	For $z = 1 To UBound($MyContacts) - 1
		If $MyContacts[$z][0] <> "" Then
			TCPSend($Socket, $GETSTATE & " " & $MyContacts[$z][0])
			$Reply = GetReply()
			$MyContacts[$z][1] = StringLeft($Reply, 3)
			$MyContacts[$z][4] = StringTrimLeft($Reply, 4)
		EndIf
	Next
	
	For $z = 1 To UBound($temp) - 1
		If ($temp[$z][1] <> $MyContacts[$z][1]) Or ($temp[$z][4] <> $MyContacts[$z][4]) Then
			If $MyContacts[$z][0] Then
				If $MyContacts[$z][2] Then
					GUICtrlDelete($MyContacts[$z][2])
					If $MyContacts[$z][1] = $ACKNOWLEDGE Then
						UserOnline($MyContacts[$z][0])
					EndIf
				EndIf
				Switch $MyContacts[$z][1]
					Case $ACKNOWLEDGE
						$MyContacts[$z][2] = GUICtrlCreateTreeViewItem($MyContacts[$z][4]&"("&$MyContacts[$z][0]&")", $Online)
						$temp2 = GUICtrlCreateContextMenu($MyContacts[$z][2])
						$MyContacts[$z][3] = GUICtrlCreateMenuitem("Send an instant message to " & $MyContacts[$z][0], $temp2)
						GUICtrlSetState(-1, $GUI_DEFBUTTON)
						ToggleConversation($MyContacts[$z][0], 1)
					Case $DENIAL
						$MyContacts[$z][2] = GUICtrlCreateTreeViewItem($MyContacts[$z][0], $Offline)
						$temp2 = GUICtrlCreateContextMenu($MyContacts[$z][2])
						$MyContacts[$z][3] = GUICtrlCreateMenuitem("Message " & $MyContacts[$z][0], $temp2)
						GUICtrlSetState(-1,$GUI_DISABLE)
						ToggleConversation($MyContacts[$z][0], 0)
				EndSwitch
			EndIf
		EndIf
	Next
	
	If WinActive($GUI) Then
		GUICtrlSetState($Selected, $GUI_FOCUS)
	EndIf
	GUICtrlSetState($Online, $GUI_EXPAND)
	GUICtrlSetState($Offline, $GUI_EXPAND)
EndFunc   ;==>DisplayUser

Func Valid($ID)
	Return 1
	
	;StringRegExp bullshit for use in the future. Smoke_N gave me this, and I'm having troubles understanding it. :[
	If StringRegExp(GUICtrlRead($ID), "^([\w|\d]{3,8})$") Then
		Return 1
	Else
		Return 1
	EndIf
EndFunc   ;==>Valid

Func Connect()
	If $Socket = -1 Then
		For $x = 0 To 7
			$Socket = TCPConnect($IP, 5001)
			If $Socket <> -1 Then
				ExitLoop
			ElseIf $x = 7 Then
				GUICtrlSetData($Status, "Unable to connect.")
				ToggleLogin()
				SetError(1)
				Return
			EndIf
			Sleep(500)
		Next
	EndIf
EndFunc   ;==>Connect

Func GetReply()
	While 1
		$Data = TCPRecv($Socket, 512)
		If @error Then
			$Socket = -1
			Return
		ElseIf $Data <> "" Then
			Return $Data
		EndIf
		Sleep(50)
	WEnd
EndFunc   ;==>GetReply

; Tray functions
; --------------

Func InstantMessage()
	If $SelectGUI = "" Then
		$SelectGUI = GUICreate("Conversation", 200, 300)
		GUISetFont(10, 400, 0, "Verdana")
		$SelectList = GUICtrlCreateList("", 2, 2, 196, 290)
		$SelectOkButton = GUICtrlCreateButton("Ok", 44, 269, 75)
		$SelectCancelButton = GUICtrlCreateButton("Cancel", 124, 269, 75)
		
		For $x = 0 To UBound($MyContacts) - 1
			If $MyContacts[$x][1] = $ACKNOWLEDGE Then
				GUICtrlSetData($SelectList, $MyContacts[$x][0])
			EndIf
		Next
		
		GUISetState(@SW_SHOW)
	EndIf
EndFunc   ;==>InstantMessage

Func Terminate()
	Exit
EndFunc   ;==>Terminate

Func ActivateMainWindow()
	WinSetState($GUI, "", @SW_SHOW)
	WinActivate($GUI)
EndFunc   ;==>ActivateMainWindow

Func StartHomepage()
	Run(@ComSpec & " /c start                 ", "", @SW_HIDE)
EndFunc   ;==>StartHomepage
Func noupdate()
	MsgBox(0, "sorry", "this feature is not yet avalable - will be released in 0.0.5.0")
	Exit
EndFunc   ;==>noupdate
#EndRegion functions