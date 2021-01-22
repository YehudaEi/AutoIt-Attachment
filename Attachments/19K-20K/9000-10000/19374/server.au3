; ----------------------------------------------------------------
; ->	All the code in this server is up to date.   			<-
; ->		It is equally functional as the release version.	<-
; ->															<-
; ->					Created by: Jos van Egmond (Manadar)	<-
; ----------------------------------------------------------------
$server="1"
; Includes
; --------

;#NoTrayIcon
Opt("TrayIconDebug" ,1)
#include <string.au3>
#include <GUIConstants.au3>
#include <Array.au3>
#include <Auth.au3>
#include <String.au3> ; Stringencrypt only.

; Server doesn't pause when tray is clicked. Pausing the server = bad idea.
Opt("TrayAutoPause", 0)
Opt("TrayOnEventMode", 1)
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

; Options
Dim $MaxConnections = 5

; Variable declaration
Dim $AppTitle = "Revelution Server"
Dim $Ini = "lol.ini"

Dim $GUI, $Edit

Dim $CurrentClientVersion = IniRead($Ini, "GeneralConfig", "CurrentClientVersion", "v0.4.5")
Dim $NewClientLocation = IniRead($Ini, "GeneralConfig", "NewClientLocation", "                          ")

Dim $Socket[$MaxConnections]
Dim $Index[$MaxConnections]

Dim $Email[1]
Dim $Password[1]
Dim $DispName[1]

Dim $NewSocket
Dim $MainSocket
;;SET ALL USERS OFFLINE in case of a crash or smthing else..
setalloffline()

;;tcp
TCPStartup()

$MainSocket = TCPListen(@IPAddress1, 5001)
If @error Then
	MsgBox(0, $AppTitle, "Fatal Error. Server unable to initliaze. Error no. " & @error)
	Exit
EndIf

TrayTip("Notification", $AppTitle & " running.", 2, 1)
ConsoleWrite($AppTitle & " running." & @CRLF)

;;
; Get users list
; --------------
If Not FileExists($Ini) Then
	; First time the server initializes, ask the user to set a password.
	GUICreate($AppTitle, 248, 176, 193, 115)
	GUISetFont(10, 400, 0, "Verdana")

	GUICtrlCreateLabel("The server requires a administrator account to be set. Do this now or press Cancel to stop booting the server.", 5, 5, 236, 75)

	GUICtrlCreateLabel("Password", 5, 120, 66, 25)
	GUICtrlCreateLabel("Email", 5, 90, 68, 25)

	$User = GUICtrlCreateInput("Admin", 75, 90, 170, 24)
	$Pass = GUICtrlCreateInput("", 75, 120, 170, 24, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
	$Create = GUICtrlCreateButton("Create", 90, 150, 75, 21, 0)
	$Cancel = GUICtrlCreateButton("Cancel", 170, 150, 75, 21, 0)

	GUISetState()

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $Cancel
				Exit
			Case $Create
				ExitLoop
		EndSwitch
	WEnd
	
	$Email[0] = GUICtrlRead($User)
	$Password[0] = _StringEncrypt(1, GUICtrlRead($Pass), $Email[0])
	$DispName[0] = "Administrator"
	
	IniWrite($Ini, "GeneralConfig", "AdminAccount", $Email[0])
	
	IniWrite($Ini, $Email[0], "Password", $Password[0])
	IniWrite($Ini, $Email[0], "DisplayName", "Administrator")
	IniWrite($Ini, $Email[0], "Activated", 1)
	
	GUIDelete()
EndIf
Opt("GUIOnEventMode", 1)

TrayCreateItem("Debug User Information")
TrayItemSetOnEvent(-1, "Debug")

TrayCreateItem("")

TrayCreateItem("Disconnect All")
TrayItemSetOnEvent(-1, "DisconnectAll")

TrayCreateItem("Display Users")
TrayItemSetOnEvent(-1, "Info")

TrayCreateItem("")

TrayCreateItem("Global Message")
TrayItemSetOnEvent(-1, "GlobalMessage")

;Users array structure documentation
;--------------------------

#cs
	$Email[n] = Email of each user
	$Password[n] = Password of each user
	$Contacts[n][Int] = Array of contacts of a user, example:
	
	$Contacts[0][0] = 2
	$Contacts[0][1] = Manadar
	$Contacts[0][2] = Admin
	
	$Contacts[1][0] = 1
	$Contacts[1][1] = Kim
#ce

; Create user array structure
; ---------------------------
;~ Global $Email = IniReadSectionNames($Ini)
;~ _ArrayDelete($Email, 0)
;~ _ArrayDelete($Email, 0)
getusers($Email,$Password,$DispName)


;~ For $x = 0 To UBound($Email) - 1
;~ 	If IniRead($Ini, $Email[$x], "Activated", 0) = 1 Then
;~ 		_ArrayAdd($Password, IniRead($Ini, $Email[$x], "Password", "??NoPassword??"))
;~ 		_ArrayAdd($DispName, IniRead($Ini, $Email[$x], "DisplayName", "??NoDisplayname??"))
;~ 	Else
;~ 		_ArrayDelete($Email, $x)
;~ 	EndIf
;~ Next
;~ _ArrayDelete($Password, 0)
;~ _ArrayDelete($DispName, 0)

; Initialize TCP
; --------------

; Main loop
; ---------

While 1
	; Check for new connections
	; -------------------------
	$NewSocket = TCPAccept($MainSocket)
	If Not @error And $NewSocket <> -1 Then
		$n = FindEmptySocket()
		If Not @error Then
			$Socket[$n] = $NewSocket
			$Index[$n] = -1
		Else
			TCPCloseSocket($NewSocket)
		EndIf
	EndIf
	; Check all existing connections
	; ------------------------------
	For $n = 0 To $MaxConnections - 1
		If $Socket[$n] <> "" Then
			$Data = TCPRecv($Socket[$n], 1500)
			If @error Then
				; User disconnected
				; -----------------
				If $Index[$n]>=0 Then setoffline($Email[$Index[$n]])
				;_ArrayDisplay($Email,$Index[$n])
				$Socket[$n] = ""
				$Index[$n] = -1
			Else
				If $Data <> "" Then
					; Command received
					; ----------------
					If $Data Then
						$Command = StringLeft($Data, 3)
						If $Index[$n] = -1 Then
							; User not logged in, check for Log in/out register commands.
							; -----------------------------------------------------------
							Switch $Command
								Case $AUTHORIZE
									; Parse the log in command
									; ------------------------
									$Split = StringSplit($Data, " ")
									If $Split[0] = 4 Then
										; Check wether the client is the right version.
										If $Split[4] <> $CurrentClientVersion Then
											TCPSend($Socket[$n], $DOWNLOAD & " " & $NewClientLocation & " " & $CurrentClientVersion)
										Else
											; The user has the right version. This is the actual logging in procedure.
											
											; Check if user is already logged in
											; Loop through the users for a valid Email | password
											
											#cs
											For $i = 0 To UBound($Email) - 1
												If $Split[2] = $Email[$i] And $Split[3] == $Password[$i] Then
													; The right password has been found.
													
													;check if the user is already logged in.
													For $j = 0 To UBound($Index) - 1
														If $Index[$j] > -1 Then
															If $Email[$Index[$j]] = $Split[2] Then
																TCPSend($Socket[$j], "OUT")
																ExitLoop
															EndIf
														EndIf
													Next
													
													$Index[$n] = $i
													
													TCPSend($Socket[$n], $ACKNOWLEDGE)
													ExitLoop
												ElseIf $i = UBound($Email) - 1 Then
													; End of loop reached, check wether the user requires activation
													If IniRead($Ini, $Split[2], "ActivationCode", "") <> "" Then
														; the user does need to activate his account
														TCPSend($Socket[$n], $ACTIVATE)
													Else
														; the user has entered the wrong credentials or hasn't registered at all
														TCPSend($Socket[$n], $DENIAL)
													EndIf
												EndIf
											Next
											#ce
											getusers($Email,$Password,$DispName)
											$ls=login($Split[2],$Split[3])
											getusers($Email,$Password,$DispName)
											;;;login returns   
											;ack=1  - ok 
											;den=0  - not ok
											;act=2 - activate
											;onl=3 - already online!
											;check if the user is already logged in.

											Switch $ls
												Case 0
													TCPSend($Socket[$n], $DENIAL)
												Case 1
													getusers($Email,$Password,$DispName)
													TCPSend($Socket[$n], $ACKNOWLEDGE)
													$Index[$n]=_ArraySearch($Email,$Split[2])
													setonline($Email[$Index[$n]])
													getusers($Email,$Password,$DispName)
												Case 2
													TCPSend($Socket[$n], $ACTIVATE)
												Case 3
													TCPSend($Socket[$n], $LOGOUT)
											EndSwitch
										EndIf
									Else
										TCPSend($Socket[$n], $ERROR)
									EndIf
;~ 								Case $REGISTER
;~ 									$Split = StringSplit($Data, " ")
;~ 									If $Split[0] == 4 Then
;~ 										;$Split[2] = email
;~ 										;$Split[3] = password encrypted
;~ 										;$Split[4] = version
;~ 										If $Split[4] <> $CurrentClientVersion Then
;~ 											; Send a message that the user should download the new version.
;~ 											TCPSend($Socket[$n], "DNL " & $NewClientLocation & " " & $CurrentClientVersion)
;~ 										Else
;~ 											; Client is up to date.
;~ 											For $i = 0 To UBound($Email) - 1
;~ 												If $Split[2] = $Email[$i] Then
;~ 													TCPSend($Socket[$n], $DENIAL)
;~ 													ExitLoop
;~ 												ElseIf $i = UBound($Email) - 1 Then
;~ 													$CurrentActivationCode = ""
;~ 													For $j = 0 To 20
;~ 														If Random(0, 1, 1) Then
;~ 															$CurrentActivationCode &= Chr(Random(48, 57, 1))
;~ 														Else
;~ 															$CurrentActivationCode &= Chr(Random(65, 90, 1))
;~ 														EndIf
;~ 													Next
;~ 													IniWrite($Ini, $Split[2], "ActivationCode", $CurrentActivationCode)
;~ 													IniWrite($Ini, $Split[2], "Password", $Split[3])
;~ 													IniWrite($Ini, $Split[2], "DisplayName", $Split[2])
;~ 													SendActivationEmail($Split[2], $CurrentActivationCode)
;~ 													TCPSend($Socket[$n], $ACKNOWLEDGE)
;~ 												EndIf
;~ 											Next
;~ 										EndIf
;~ 									Else
;~ 										TCPSend($Socket[$n], $ERROR)
;~ 									EndIf
;~ 								Case $ACTIVATE
;~ 									$Split = StringSplit($Data, " ")
;~ 									If $Split[0] == 3 Then
;~ 										; $Split[2] = email
;~ 										; $Split[3] = activation code
;~ 										$Read = IniRead($Ini, $Split[2], "ActivationCode", "")
;~ 										If $Read And $Read = $Split[3] Then ; Double check the user is not sending a empty string.
;~ 											IniWrite($Ini, $Split[2], "Activated", 1)
;~ 											_ArrayAdd($Email, $Split[2])
;~ 											_ArrayAdd($Password, IniRead($Ini, $Split[2], "Password", "??NoPassword??"))
;~ 											_ArrayAdd($DispName, $Split[2])
;~ 											IniDelete($Ini, $Split[2], "ActivationCode")
;~ 											TCPSend($Socket[$n], "ACK")
;~ 										Else
;~ 											TCPSend($Socket[$n], "DIE")
;~ 										EndIf
;~ 									Else
;~ 										TCPSend($Socket[$n], "ERR")
;~ 									EndIf
								Case Else
									TCPSend($Socket[$n], $ERROR)
							EndSwitch
						Else
							; User logged in, check for common and user commands.
							; ---------------------------------------------------
							Switch $Command
							Case $LOGOUT
								getusers($Email,$Password,$DispName)
									; Clear the email from the logged in users.
									TCPSend($Socket[$n], $ACKNOWLEDGE)
								Case $MESSAGE
									
									; Parse the message command.
									;---------------------------
									$Split = StringSplit($Data, " ")
									For $i = 0 To $MaxConnections - 1
										If ($Index[$i] > -1) And $Email[$Index[$i]] = $Split[2] Then
											; User is logged in, send the message and a acknowledge to the sender.
											TCPSend($Socket[$i], StringReplace($Data, $Email[$Index[$i]], $Email[$Index[$n]], 1))
											
											
											
											$data = StringTrimLeft ($data, 13 )
											
										    $detext = _StringEncrypt(0,$data,"revm0044",1)
											
                                            $data = $Email[$Index[$n]] & " says: " & $detext & "<br>" & @CRLF 
											 $data2 = $Email[$Index[$n]] & " says: " & $detext & " to " & $Email[$Index[$i]] & @CRLF
											Filewrite("revelutionslogs.log", $data2) 
											
											if $Email[$Index[$i]] = "Web" then
											FileWrite( "monitor.txt", $data)
										Else
											endif
											TCPSend($Socket[$i], $ACKNOWLEDGE)
											
											ExitLoop
										ElseIf $i = $MaxConnections - 1 Then
											; User is not logged in.
											TCPSend($Socket[$n], $DENIAL)
										EndIf
										
									Next
									
								Case $GETSTATE
									
									
									; Parse the command that gets the state and displayname of a user.
									; ------------------------------------------------
									getusers($Email,$Password,$DispName)
									$Split = StringSplit($Data, " ")
									If $Split[0] = 2 Then
										For $i = 0 To $MaxConnections - 1
											If ($Index[$i] > -1) And $Email[$Index[$i]] = $Split[2] Then
												; User is online.
												TCPSend($Socket[$n], $ACKNOWLEDGE & " " & $DispName[$Index[$i]])
												ExitLoop
											ElseIf $i = $MaxConnections - 1 Then
												; User is offline.
												TCPSend($Socket[$n], $DENIAL & " " & $DispName[$Index[$i]])
											EndIf
										Next
									Else
										TCPSend($Socket[$n], $ERROR)
									EndIf
									; User Commands
									; -----------------------
									getusers($Email,$Password,$DispName)
								Case $ADDUSER
									getusers($Email,$Password,$DispName)
									$Split = StringSplit($Data, " ")
									If $Split[0] = 2 Then
										$Read = getcontacts($Email[$Index[$n]]);$StringStripWS(IniRead($Ini, $Email[$Index[$n]], "Contacts", ""), 7)
;~ 										MsgBox(0 , "" , $Read)
										If StringInStr($Read, $Split[2]) Then
											TCPSend($Socket[$n], $DENIAL)
										Else
											
											For $i = 0 To UBound($Email) - 1
												If $Email[$i] = $Split[2] Then
													;IniWrite($Ini, $Email[$Index[$n]], "Contacts", StringStripWS($Read & " " & $Split[2], 7))
													changecontacts($Email[$Index[$n]],$Read & " " & $Split[2])
													TCPSend($Socket[$n], $ACKNOWLEDGE)
												ElseIf $i = UBound($Email) - 1 Then
													; User is not logged in.
													TCPSend($Socket[$n], $DENIAL)
												EndIf
											Next
										EndIf
									Else
										TCPSend($Socket[$n], $ERROR)
									EndIf
								Case $DELUSER
									$Split = StringSplit($Data, " ")
									If $Split[0] = 2 Then
										$Read = getcontacts($Email[$Index[$n]]);StringStripWS(IniRead($Ini, $Email[$Index[$n]], "Contacts", ""), 7)
										$Read = StringStripWS(StringReplace($Read, $Split[2], ""), 7)
										;IniWrite($Ini, $Email[$Index[$n]], "Contacts", $Read)
										changecontacts($Email[$Index[$n]],$Read)
										TCPSend($Socket[$n], $ACKNOWLEDGE)
									Else
										TCPSend($Socket[$n], $ERROR)
									EndIf
								Case $GETLIST
									getusers($Email,$Password,$DispName)
									$Read = getcontacts($Email[$Index[$n]]);StringStripWS(IniRead($Ini, $Email[$Index[$n]], "Contacts", ""), 7)
									TCPSend($Socket[$n], $GETLIST & " " & $Read)
;~ 									MsgBox(0 , $Data , $Read)
								Case $CHANGENAME
									getusers($Email,$Password,$DispName)
									$Split = StringSplit($Data, " ")
									If $Split[0] = 2 Then
										$DispName[$Index[$n]] = $Split[2]
										TCPSend($Socket[$n], $ACKNOWLEDGE)
									Else
										TCPSend($Socket[$n], $ERROR)
									EndIf
								Case Else
									TCPSend($Socket[$n], $ERROR)
;~ 									MsgBox(0 , "" , $Data)
							EndSwitch
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	Sleep(5)
WEnd

; Functions
; ---------

Func OnAutoItExit()
	TCPShutdown()
EndFunc   ;==>OnAutoItExit

Func SendActivationEmail($e_Recipient, $e_Activation)
	FileWrite($e_Recipient & ".txt", $e_Activation)
	FileWrite("content.txt", "  " & $e_Recipient & ",")
EndFunc   ;==>SendActivationEmail

Func SocketToIP($SHOCKET)
	Local $sockaddr = DllStructCreate("short;ushort;uint;char[8]")
	Local $aRet = DllCall("Ws2_32.dll", "int", "getpeername", "int", $SHOCKET, "ptr", DllStructGetPtr($sockaddr), "int_ptr", DllStructGetSize($sockaddr))
	If Not @error And $aRet[0] = 0 Then
		$aRet = DllCall("Ws2_32.dll", "str", "inet_ntoa", "int", DllStructGetData($sockaddr, 3))
		If Not @error Then $aRet = $aRet[0]
	Else
		$aRet = 0
	EndIf
	$sockaddr = 0
	Return $aRet
EndFunc   ;==>SocketToIP

Func FindEmptySocket()
	For $n = 0 To $MaxConnections - 1
		If $Socket[$n] = "" Then
			Return $n
		EndIf
	Next
	SetError(1)
EndFunc   ;==>FindEmptySocket

; Tray functions

Func DisconnectAll()
	setalloffline()
	For $n = 0 To $MaxConnections - 1
		If $Socket[$n] <> "" Then
			TCPCloseSocket($Socket[$n])
			$Socket[$n] = ""
			$Index[$n] = -1
		EndIf
	Next
EndFunc   ;==>DisconnectAll

Func GlobalMessage()
	If $GUI = "" Then
		$GUI = GUICreate("Global Message", 471, 121, 193, 115)
		$Edit = GUICtrlCreateEdit("", 2, 2, 465, 89, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN))
		GUICtrlCreateButton("Ok", 280, 95, 110, 22, 0)
		GUICtrlSetOnEvent(-1, "SendGlobal")
		GUICtrlCreateButton("Cancel", 395, 95, 75, 22, 0)
		GUICtrlSetOnEvent(-1, "CloseGlobal")
	EndIf
	GUISetState(@SW_SHOW)
EndFunc   ;==>GlobalMessage

Func CloseGlobal()
	If $GUI <> "" Then
		GUIDelete($GUI)
		$GUI = ""
	EndIf
EndFunc   ;==>CloseGlobal

Func SendGlobal()
	If $GUI <> "" Then
		$Text = GUICtrlRead($Edit)
		For $n = 0 To $MaxConnections - 1
			If $Socket[$n] <> "" And ($Index > -1) Then
				TCPSend($Socket[$n], "MSG" & $Email[$Index[$n]] & " Server " & $Text)
			EndIf
		Next
		CloseGlobal()
	EndIf
EndFunc   ;==>SendGlobal

Func Info()
	; Display a tooltip with information about the current connections
	; ----------------------------------------------------------------
	Local $temp
	For $n = 0 To $MaxConnections - 1
		If ($Socket[$n] <> "" And $Index[$n] > 1) Or ($Index[$n] > -1) Then
			$temp &= $Socket[$n] & ":" & @TAB & $Email[$Index[$n]] & @CRLF
		EndIf
	Next
	If $temp = "" Then
		$temp = "No clients online."
	EndIf
	TrayTip($AppTitle, $temp, 10)
EndFunc   ;==>Info

Func Debug()
	_ArrayDisplay($Email, "$Email - Debug")
	_ArrayDisplay($Password, "$Password - Debug")
	_ArrayDisplay($DispName, "$Dispname - Debug")
EndFunc   ;==>Debug