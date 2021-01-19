#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=C:\AU3 in progress\connector.ico
#AutoIt3Wrapper_outfile=C:\AU3 in progress\Reconnect v1.0.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=Auto-Re'connect v1.0 by Shlomi.Kalfa was made to disconnect and reconnect automaticaly from the internet using diffrent mathodes.  Yet another SK's Product, Enjoy.
#AutoIt3Wrapper_Res_Description=Disconnects & Reconnects your internet connection!
#AutoIt3Wrapper_Res_Fileversion=1.0.2.0
#AutoIt3Wrapper_Res_Icon_Add=C:\AU3 in progress\Failure.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\AU3 in progress\Start.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\AU3 in progress\Success.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\AU3 in progress\cp.ico
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Allow_Decompile=n
#cs
	=========V0.1.2 24.03,07==========
	TODO:
	-.
	BUGS:
	-.
	CHANGES:
	-* V1.0.2.0
	-. no longer uses the "ToggleNic.exe" file !!! (using netsh instead!)
	-* V1.0.1.7
	-. Now users have the ability to remove the status pop-up!
	-* V1.0.1.6
	-. Fixed the bug where you had to write the connection name on your own!
	-* V1.0.1.5
	-. Fixed Save Options Question! (now only if successfull operation!)
	-. Added the program the ability to autodetect the current active connections!
	-. Added the program the ability to autodetect the current active Dial-Up connection!
	-* V1.0.1.4
	-. Validates IPs by timer set by user ! (MIN)
	-. now supports multiple preffered IPs !
	-* V1.0.1.3
	-. pinging problam resolved! (don't use http:// before ping address !!!)
	-* V1.0.1.2
	-. now have a tray-icon showing that the program launched!
	-. now uses an ini file that is opened for all to edit!
	-. now shows a msg that informs if settings were saved or not!
	-* V1.0.1.0
	-. Shows ip status.
	-. Dial-Up -> connection must be with no spaces. -> fixed by adding quotation.
#ce
#include <GUIConstants.au3>
#include <INet.au3>
#include <IE.au3>

Dim $IconsNonCompiled[4] = ["Failure.ico", "Start.ico", "Success.ico", "cp.ico" ]
Dim $IconsCompiled[4] = [ -4, -5, -6, -7]

Global $Version = "v1.0" 
Global $Status, $PrefferedIPInput, $PrefferedIPCB, $persistantCB, $popupstatusCB, $success, $TrayCreated, $silent, $state, $network, $connection, $login, $password, $UserIPTimeInterval
Global $NetworkConnection, $NetworkConnectionNET, $NetworkConnectionTimer, $Sleep, $IPLable, $IPLablePre, $IPStatus, $ApplySettings, $DoubleClickCombo, $Input1, $Input2, $Input3, $Input4, $Radio1, $Radio2, $Radio3, $Radio4, $persistant, $popupstatus, $PrefferedIP, $PrefferedIPToUse, $IPValidation, $IPValidationCB, $IPValidationInput
Global $IP = _GetIP()
Global $NewIP = $IP

$filecheck = FileExists(@ScriptDir & "\Reconnect.ini")
If $filecheck = 1 Then
	$silent = 1
	$state = IniRead("Reconnect.ini", "Settings:", "state", "")
	$network = IniRead("Reconnect.ini", "Settings:", "network", "")
	$connection = IniRead("Reconnect.ini", "Settings:", "connection", "")
	$login = IniRead("Reconnect.ini", "Settings:", "login", "")
	$password = IniRead("Reconnect.ini", "Settings:", "password", "")
	$Sleep = IniRead("Reconnect.ini", "Settings:", "Sleep", "")
	$PrefferedIP = IniRead("Reconnect.ini", "Settings:", "PrefferedIP", 0)
	$PrefferedIPToUse = IniRead("Reconnect.ini", "Settings:", "PrefferedIPToUse", "")
	$persistant = IniRead("Reconnect.ini", "Settings:", "persistant", 1)
	$popupstatus = IniRead("Reconnect.ini", "Settings:", "popupstatus", 1)
	$IPValidation = IniRead("Reconnect.ini", "Settings:", "IPValidation", 0)
	$UserIPTimeInterval = IniRead("Reconnect.ini", "Settings:", "UserIPTimeInterval", "")
	If $state = "" Then Setup()
	If $state = "NET"  And $network = "" Then Setup()
	If $state = "DIAL"  And ($connection = "" Or $login = "" Or $password = "") Then Setup()
	If $state = "ALL"  And ($network = "" Or $connection = "" Or $login = "" Or $password = "") Then Setup()
	Reconnect(0)
	ExitProg()
Else
	$silent = 0
	Setup()
EndIf

Func Setup()
	#Region ### START Koda GUI section ### Form=c:\documents and settings\godsperfectbeing\my documents\uis\reconnect.kxf
	$AutoReconnect = GUICreate("Auto Re'Connect " & $Version, 262, 330, 190, 115)
	GUISetIcon(@ScriptDir, "connector.ico", 0)
	GUISetBkColor(0xE9ECE9)
	;$SpacerL = GUICtrlCreateLabel("_______________________________________________________", 16, 193, 234, 17)
	;GUICtrlSetBkColor(-1, 0xE9ECE9)
	;---------
	$Group1 = GUICtrlCreateGroup("Mathode:", 8, 4, 249, 42)
	$Label5 = GUICtrlCreateLabel("Ip-Flush", 16, 24, 37, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	$Radio1 = GUICtrlCreateRadio("", 54, 24, 17, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	GUICtrlSetTip($Radio1, "Releases all network cards ip-addresses and Renews them")

	$Label6 = GUICtrlCreateLabel("Dial-Up", 71, 24, 36, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	$Radio2 = GUICtrlCreateRadio("", 109, 24, 17, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	GUICtrlSetTip($Radio2, "Disconnects from the specified dial-up connection and Reconnect")

	$Label8 = GUICtrlCreateLabel("D/E-Net", 125, 24, 40, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	$Radio3 = GUICtrlCreateRadio("", 168, 24, 17, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	GUICtrlSetTip($Radio3, "Disables the network connection specified and Enables it." & @CRLF & "(use only if you're a 'dhcp' user !")

	$Label7 = GUICtrlCreateLabel("Thorough", 184, 24, 49, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	$Radio4 = GUICtrlCreateRadio("", 232, 24, 17, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	GUICtrlSetTip($Radio4, "Tries the entire 3 mathodes. 'D/E Net', then 'IP-Flush' & 'Dial-Up'")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	;------
	$Group2 = GUICtrlCreateGroup("Settings:", 8, 50, 249, 172)

	$Label0 = GUICtrlCreateLabel("Network Connection:", 16, 66, 104, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	;$Input0 = GUICtrlCreateInput("Local Area Connection", 123, 66, 128, 21)
	;GUICtrlSetTip(-1,"Input the name of the Connection To Disable And Enable")

	$DoubleClickCombo = GUICtrlCreateCombo("'Your Local Area Connection'", 123, 66, 128, 21)
	GUICtrlSetState(-1, $DoubleClickCombo)

	$Label2 = GUICtrlCreateLabel("Dial-Up Connection:", 16, 88, 104, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	$Input1 = GUICtrlCreateInput("'Your Dialing Connection'", 123, 88, 128, 21)
	GUICtrlSetTip(-1, "Input the name of the dialing connection to Disconnect and Redail to")
	$Label3 = GUICtrlCreateLabel("Login name:", 16, 110, 62, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	$Input2 = GUICtrlCreateInput("'Your User Name'", 123, 110, 128, 21)
	GUICtrlSetTip(-1, "Input the user name to use while Redailing")
	$Label4 = GUICtrlCreateLabel("Password:", 16, 132, 53, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	$Input3 = GUICtrlCreateInput("'Your Password'", 123, 132, 128, 21)
	GUICtrlSetTip(-1, "Input the correct password to use while Redailing")
	$PrefferedIPCB = GUICtrlCreateCheckbox("Preffered IP:", 16, 154, 85, 17)
	CheckboxStatusSet($PrefferedIPCB, 0)
	$PrefferedIP = CheckboxStatusGet($PrefferedIPCB)
	GUICtrlSetTip(-1, "If checked 'AutoReconnector' will reconnect untill it'll have the preffered IP pattern!" & @CRLF & "'X' is used as variable char (can be anything!)" & @CRLF & "'|' is used as a delimiter between preffered IPs!")
	$PrefferedIPInput = GUICtrlCreateInput("xxx.xxx.xxx.xxx|xxx.xxx.xxx.xxx", 123, 154, 128, 21)
	GUICtrlSetTip(-1, "Example: If you'd like to get an ip starting with '60' then you're to put x60.xxx.xxx.xxx" & @CRLF & "or with 2nd char '2' and last '7' put xx2.xxx.xxx.xx7" & @CRLF & "NB: this works with serveral prefferences delimited by '|' !")
	$persistantCB = GUICtrlCreateCheckbox("Persistancy", 16, 178, 80, 17)
	GUICtrlSetTip(-1, "If checked 'AutoReconnector' will compare the previous IP with the new one and will reconnect if it hasn't changed !")
	CheckboxStatusSet($persistantCB, 1)
	$persistant = CheckboxStatusGet($persistantCB)
	$popupstatusCB = GUICtrlCreateCheckbox("Status tip", 16, 202, 80, 17)
	GUICtrlSetTip(-1, "If checked 'AutoReconnector' show a status pop-up massage after each time the operation is done !")
	CheckboxStatusSet($popupstatusCB, 1)
	$popupstatus = CheckboxStatusGet($popupstatusCB)
	$IPValidationCB = GUICtrlCreateCheckbox("Validate IP ", 100, 178, 70, 17)
	CheckboxStatusSet($IPValidationCB, 0)
	$IPValidation = CheckboxStatusGet($IPValidationCB)
	GUICtrlSetTip(-1, "This will record you'r previousely used IP and will reconnect in case you get that same IP withing the time interval!" & @CRLF & "RapidShare Blocks IPs for 125 Minutes!")
	$IPValidationL = GUICtrlCreateLabel("Interval:", 173, 180, 47, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	$IPValidationInput = GUICtrlCreateInput("125", 211, 176, 40, 17)
	GUICtrlSetTip(-1, "Input a time interval in Minutes to wait untill the IP will be certainly cleaned and valid! (Minutes)")

	$Label5 = GUICtrlCreateLabel("Sleep:", 173, 198, 47, 17)
	GUICtrlSetBkColor(-1, 0xE9ECE9)
	$Input4 = GUICtrlCreateInput("60", 211, 198, 40, 17)
	GUICtrlSetTip(-1, "Input a time interval in seconds to wait between each procces, 60 seconds is recommanded" & @CRLF & "that variable depends on your ISP IPs releasing policies! you might use a lesser number!")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$IPLable = GUICtrlCreateLabel("Current:   " & $NewIP, 123, 229, 130, 17)
	$IPLablePre = GUICtrlCreateLabel("Previous: " & $IP, 123, 243, 130, 17)
	$ApplySettings = GUICtrlCreateButton("Save And Reconnect", 4, 229, 118, 28, 1)
	GUICtrlSetTip(-1, "This Page Will Not Appear After Settings Are Set! To reset the settings Delete the 'Reconnect.ini' file created.", "Save & Reconnect, Give it a try till you find the most suiteable mathode.", 2, 1)

	$Group3 = GUICtrlCreateGroup("Status:", 4, 262, 253, 48)
	$Status = GUICtrlCreateLabel("", 8, 278, 223, 28) ; 2 lines !!!
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	If @Compiled = 0 Then
		$IPStatus = GUICtrlCreateIcon(@ScriptDir & "\" & $IconsNonCompiled[3], 233, 278, 20, 20, BitOR($SS_NOTIFY, $WS_GROUP, $BS_ICON))
	Else
		$IPStatus = GUICtrlCreateIcon(@ScriptFullPath, $IconsCompiled[3], 233, 278, 20, 20, BitOR($SS_NOTIFY, $WS_GROUP, $BS_ICON))
	EndIf
	GUICtrlSetTip($IPStatus, "Idle...")
	GUICtrlSetCursor($IPStatus, 0)

	GUICtrlCreateLabel("Auto-Reconnect " & $Version & "(TM) by Shlomi.Kalfa, 2007", 0, 314, 263, 17)
	GUICtrlSetFont(-1, 4, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x9DB9EB)
	ControlDependentSet($IPValidationInput, $IPValidation)
	ControlDependentSet($PrefferedIPInput, $PrefferedIP)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	GUICtrlSetState($Radio1, $GUI_CHECKED)
	GUICtrlSetState($DoubleClickCombo, $GUI_DISABLE)
	GUICtrlSetState($Input1, $GUI_DISABLE)
	GUICtrlSetState($Input2, $GUI_DISABLE)
	GUICtrlSetState($Input3, $GUI_DISABLE)
	$state = "IP" 

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				If $success = 1 Then
					MsgBox(4144, Chr(153) & "Auto Re'Connect " & $Version, "Operation Successful, the new settings were saved!")
				Else
					MsgBox(4144, Chr(153) & "Auto Re'Connect " & $Version, "Operation Failed, the new settings were purged!")
				EndIf
				ExitProg()
				
			Case $Radio1
				Radio1()
				;disable all settings + set function -> adsl.
			Case $Radio2
				Radio2()
				;leave all slots, use dial up settings.
			Case $Radio3
				Radio3()
				
			Case $Radio4
				Radio4()
				;leave all slots, use all mathodes.
				
			Case $ApplySettings
				If $state <> "IP"  Then
					If $state = "DIAL"  Then
						$network = ""
						$connection = GUICtrlRead($Input1)
						$login = GUICtrlRead($Input2)
						$password = GUICtrlRead($Input3)
					ElseIf $state = "NET"  Then
						$network = GUICtrlRead($DoubleClickCombo)
						$connection = ""
						$login = ""
						$password = ""
					ElseIf $state = "ALL"  Then
						$network = GUICtrlRead($DoubleClickCombo)
						$connection = GUICtrlRead($Input1)
						$login = GUICtrlRead($Input2)
						$password = GUICtrlRead($Input3)
					EndIf
				Else
					$network = ""
					$connection = ""
					$login = ""
					$password = ""
				EndIf
				$PrefferedIPToUse = GUICtrlRead($PrefferedIPInput)
				$UserIPTimeInterval = GUICtrlRead($IPValidationInput)
				$Sleep = GUICtrlRead($Input4) * 1000
				GuiSetStatus(0, 1, "Operation Started!")
				$success = Reconnect(1)
				If $success = 1 Then
					SetStatus("IP Switched Successfuly !", "")
					IniWrite("Reconnect.ini", "Settings:", "state", $state)
					IniWrite("Reconnect.ini", "Settings:", "connection", $connection)
					IniWrite("Reconnect.ini", "Settings:", "network", $network)
					IniWrite("Reconnect.ini", "Settings:", "login", $login)
					IniWrite("Reconnect.ini", "Settings:", "password", $password)
					IniWrite("Reconnect.ini", "Settings:", "Sleep", $Sleep)
					IniWrite("Reconnect.ini", "Settings:", "PrefferedIP", $PrefferedIP)
					IniWrite("Reconnect.ini", "Settings:", "PrefferedIPToUse", $PrefferedIPToUse)
					IniWrite("Reconnect.ini", "Settings:", "persistant", $persistant)
					IniWrite("Reconnect.ini", "Settings:", "IPValidation", $IPValidation)
					IniWrite("Reconnect.ini", "Settings:", "UserIPTimeInterval", $UserIPTimeInterval)
					$ret = MsgBox(4132, Chr(153) & "Auto Re'Connect " & $Version, "Would you like to set USDownloader's scheduler to start me after a dl?!" & @CRLF & "(this will overwrite the 1st previously set item!)")
					If $ret = 6 Then
						$filepath = @ScriptDir & "\USDownloader.ini" 
						If FileExists($filepath) <> 1 Then
							$filepath = FileOpenDialog("Locate 'USDownloader.ini' for me!", @ScriptDir, "USDownloader.ini", 1, "USDownloader.ini")
						EndIf
						IniWrite($filepath, "Schedule", "item0_active", 1)
						IniWrite($filepath, "Schedule", "item0_day", 0)
						IniWrite($filepath, "Schedule", "item0_event", 6)
						IniWrite($filepath, "Schedule", "item0_time", 0)
						IniWrite($filepath, "Schedule", "item0_eventparam", "")
						IniWrite($filepath, "Schedule", "item0_action", 0)
						IniWrite($filepath, "Schedule", "item0_actparam", @ScriptFullPath & '|0|1')
						IniWrite($filepath, "Schedule", "item0_onetime", 0)
					EndIf
				Else
					SetStatus("IP Switch Failed !", "")
				EndIf
				GuiSetStatus(1, 3, "Idle...")
				
			Case $persistantCB
				$persistant = Switcher($persistant)
			Case $popupstatusCB
				$popupstatus = Switcher($popupstatus)
			Case $IPValidationCB
				$IPValidation = Switcher($IPValidation)
				ControlDependentSet($IPValidationInput, $IPValidation)
			Case $PrefferedIPCB
				$PrefferedIP = Switcher($PrefferedIP)
				ControlDependentSet($PrefferedIPInput, $PrefferedIP)
		EndSwitch
	WEnd
EndFunc   ;==>Setup

;---------------------- Functions !
Func Reconnect($mode)
	If $mode = 0 Then TrayCreate()
	SetStatus("Operation Started:", "")
	$IP = $NewIP
	$op = ""
	Switch $state
		Case "IP" 
			$op = LanReconnect()
		Case "DIAL" 
			$op = DialUpReconnect()
		Case "NET" 
			$op = NetworkReconnect()
		Case "ALL" 
			$op = ThoroughReconnect()
	EndSwitch
	SetStatus("Operation Done: " & $op, "Getting IP information...")
	$NewIP = _GetIP()
	GUICtrlSetData($IPLable, "Current:   " & $NewIP)
	GUICtrlSetData($IPLablePre, "Previous: " & $IP)
	If CheckConnection() = 0 Then
		VarifyContinuation($mode, $op, "Internet Connection Error! ")
		SetStatus("Checking For Connection: ", "Reconnecting! Mathode: " & $op)
		Reconnect($mode)
	EndIf
	If $NewIP <> $IP Then
		If @Compiled = 0 Then
			$ret = GUICtrlSetImage($IPStatus, @ScriptDir & "\" & $IconsNonCompiled[2])
			;If $ret = 0 Then MsgBox(0,"fag","SHIT")
		Else
			$ret = GUICtrlSetImage($IPStatus, @ScriptFullPath, $IconsCompiled[2])
			;If $ret = 0 Then MsgBox(0."fag","SHIT")
		EndIf
		GUICtrlSetTip($IPStatus, "Operation Successfuly Done!")
		If $popupstatus = 1 Then ShowToolTip("Operation Successfuly Done!", 1, 5)
		SetStatus("Operation Done: " & $op, "Operation Successfuly Done!")
		If $PrefferedIP = 1 Then
			If ExtractIps($NewIP, $PrefferedIPToUse) = 0 Then
				SetStatus("Checking For Preffered IP: ", "Reconnecting! Mathode: " & $op)
				VarifyContinuation($mode, $op, "Checking For Preffered IP: ")
			EndIf
		EndIf
		If $IPValidation = 1 Then
			If CheckValidIP($NewIP, $IP) = 0 Then
				SetStatus("Validating IP: ", "Reconnecting! Mathode: " & $op)
				VarifyContinuation($mode, $op, "Validating IP: ")
			EndIf
		EndIf
		
		Return 1
	Else
		If @Compiled = 0 Then
			$ret = GUICtrlSetImage($IPStatus, @ScriptDir & "\" & $IconsNonCompiled[0])
			;If $ret = 0 Then MsgBox(0,"fag","SHIT")
		Else
			$ret = GUICtrlSetImage($IPStatus, @ScriptFullPath, $IconsCompiled[0])
			;If $ret = 0 Then MsgBox(0,"fag","SHIT")
		EndIf
		GUICtrlSetTip($IPStatus, "Operation Failed!")
		If $popupstatus = 1 Then ShowToolTip("Operation Failed!", 3, 5)
		SetStatus("Operation Done: " & $op, "Operation Failed!")
		If $persistant = 1 Then
			SetStatus("Precistancy Checked!", "")
			VarifyContinuation($mode, $op, "Precistancy Checked! ")
		EndIf
		Return 0
	EndIf
	Return 0
EndFunc   ;==>Reconnect

Func VarifyContinuation($mode, $op, $header)
	If $mode = 1 Then
		$ret = MsgBox(4132, Chr(153) & "Auto Re'Connect " & $Version, "Would you like to repeat the operation " & $op & "?")
		If $ret = 6 Then
			SetStatus($header, "Reconnecting! Mathode: " & $op)
			Reconnect($mode)
		Else
			SetStatus($header, "Aborted By User!")
			Return
		EndIf
	Else
		SetStatus($header, "Reconnecting! Mathode: " & $op)
		Reconnect($mode)
	EndIf
EndFunc   ;==>VarifyContinuation

Func CheckConnection()
	SetStatus("Checking For Connection: ", "pinging server... (www.rapidshare.com)")
	$ret = Ping("www.rapidshare.com", 5000)
	If @error = 1 Then
		SetStatus("Checking For Connection: ", "pinging server... (www.google.com)")
		$ret = Ping("www.google.com", 5000)
	EndIf
	If $ret = 0 Then
		SetStatus("Checking For Connection: ", "no reply from server!")
		Return 0
	EndIf
	SetStatus("Checking For Connection: ", "server replied!")
	Return 1
EndFunc   ;==>CheckConnection

Func CheckValidIP($IPtoCheck, $prevIP)
	SetStatus("Validating IP: Evaluation time: " & $UserIPTimeInterval & " minutes.", "parsing previous IPs!")
	$overwrite = 0
	$IpOnWait = 0
	$IPtoCheckAge = 0
	$IPs = IniReadSection("Reconnect.ini", "UsedIPs")
	If @error = 1 Then Return 1
	For $i = 1 To $IPs[0][0]
		$IPsAge = TimerDiff($IPs[$i][1]) / 60000
		If $IPsAge >= $UserIPTimeInterval Then
			SetStatus("Validating IP: Evaluation time: " & $UserIPTimeInterval & " minutes.", $IPs[$i][0] & " is " & $IPsAge & " minutes old, deleting!")
			IniDelete("Reconnect.ini", "UsedIPs", $IPs[$i][0])
		Else
			SetStatus("Validating IP: Evaluation time: " & $UserIPTimeInterval & " minutes.", $IPs[$i][0] & " is " & $IPsAge & " minutes old, keeping!")
		EndIf
	Next
	SetStatus("Validating IP: Evaluation time: " & $UserIPTimeInterval & " minutes.", "validating current IP: " & $IPtoCheck)
	$IPs = IniReadSection("Reconnect.ini", "UsedIPs")
	If @error = 1 Then Return 1
	For $i = 1 To $IPs[0][0]
		If $IPs[$i][0] = $prevIP Then $overwrite = 1
		If $IPs[$i][0] = $IPtoCheck Then
			$IpOnWait = 1
			$IPtoCheckAge = TimerDiff($IPs[$i][1]) / 60000
		EndIf
	Next
	If $overwrite = 0 Then IniWrite("Reconnect.ini", "UsedIPs:", $prevIP, TimerInit())
	If $IpOnWait = 1 Then
		SetStatus("Validating IP: Evaluation time: " & $UserIPTimeInterval & " minutes.", $IPtoCheck & " is too old, its: " & $IPtoCheckAge & " minute old!")
		Return 0
	EndIf
	Return 1
EndFunc   ;==>CheckValidIP

Func ExtractIps($IP, $pref)
	$IPs = StringSplit($pref, "|")
	If IsArray($IPs) = 1 Then
		For $i = 1 To $IPs[0]
			If StringLen($IPs[$i]) > 0 Then
				$ret = CheckPrefferedIp($IP, $IPs[$i])
				If $ret = 1 Then Return 1
			Else
				$ret = CheckPrefferedIp($IP, $pref)
				If $ret = 1 Then Return 1
			EndIf
		Next
	Else
		$ret = CheckPrefferedIp($IP, $pref)
		If $ret = 1 Then Return 1
	EndIf
	Return 0
EndFunc   ;==>ExtractIps

Func CheckPrefferedIp($IP, $pref)
	SetStatus("Checking For Preffered IP: ", "parsing IPs: '" & $IP & "' | '" & $pref & "' ...")
	;MsgBox(0,"","parsing IPs: '"&$ip&"' | '"&$pref&"' ...")
	$ipseg = StringRegExp($IP, "(.*)\.(.*)\.(.*)\.(.*)", 3)
	If @error <> 0 Then Return MsgBox(4144, Chr(153) & "Auto Re'Connect " & $Version, "Operation Fault: Wrong IP retained from network adapter!")
	$parsedIP = ""
	For $i = 0 To UBound($ipseg) - 1
		While StringLen($ipseg[$i]) < 3
			$ipseg[$i] = "x" & $ipseg[$i]
		WEnd
		$parsedIP = $parsedIP & $ipseg[$i] & "." 
	Next
	$prefseg = StringRegExp($pref, "(.*)\.(.*)\.(.*)\.(.*)", 3)
	If @error <> 0 Then Return MsgBox(4144, Chr(153) & "Auto Re'Connect " & $Version, "Operation Fault: Wrong preffered IP pattern used !" & @CRLF & "(Eg: 217.xxx.xxx.xxx OR xxx.x87.xxx.xxx)")
	$parsedPrefIP = ""
	For $i = 0 To UBound($prefseg) - 1
		While StringLen($prefseg[$i]) < 3
			$prefseg[$i] = "x" & $prefseg[$i]
		WEnd
		$parsedPrefIP = $parsedPrefIP & $prefseg[$i] & "." 
	Next
	SetStatus("Checking For Preffered IP: ", "Ip's are processed, trailing patterned...")
	;MsgBox(0,"","processed IPs: '"&$parsedIP&"' and '"&$parsedPrefIP&"' checking...")
	For $i = 0 To UBound($prefseg) - 1
		;MsgBox(0,"",$prefseg[$i] & "|" & $ipseg[$i] & " | LIMIT: " & UBound($prefseg)-1)
		$prefsegseg = StringRegExp($prefseg[$i], "(.)", 3) ; x | 8| 7
		If @error <> 0 Then Return MsgBox(4144, Chr(153) & "Auto Re'Connect " & $Version, "Operation Fault: Wrong preffered IP parsed pattern! (empty segment!)")
		$ipsegseg = StringRegExp($ipseg[$i], "(.)", 3) ;     1 | 2| 3
		If @error <> 0 Then Return MsgBox(4144, Chr(153) & "Auto Re'Connect " & $Version, "Operation Fault:  Wrong IP retained from network adapter! (empty segment!)")
		For $i2 = 0 To UBound($prefsegseg) - 1
			;MsgBox(0,"",StringLower($prefsegseg[$i2]) &"|"& StringLower($ipsegseg[$i2]))
			If StringLower($prefsegseg[$i2]) <> "x"  And StringLower($prefsegseg[$i2]) <> StringLower($ipsegseg[$i2]) Then
				SetStatus("Checking For Preffered IP: ", "IP abberation found!")
				Return 0
			EndIf
		Next
		;MsgBox(0,"","END")
	Next
	SetStatus("Checking For Preffered IP: ", "IPs are oky to go!")
	Return 1
EndFunc   ;==>CheckPrefferedIp

Func Sleeper($time, $Pretxt)
	For $i = $time To 0 Step - 1
		SetStatus($Pretxt, "waiting for " & $time & " seconds... (" & $i & ")")
		Sleep(250)
	Next
EndFunc   ;==>Sleeper

Func LanReconnect()
	SetStatus("Operation Started: IP-Flush", "flushing dns... (ipconfig /flushdns)")
	ShellExecuteWait("ipconfig", "/flushdns", "", "", @SW_HIDE)
	Sleep(1000)
	SetStatus("Operation Started: IP-Flush", "done!")
	SetStatus("Operation Started: IP-Flush", "releasing all ips... (ipconfig /release *)")
	ShellExecuteWait("ipconfig", "/release *", "", "", @SW_HIDE)
	SetStatus("Operation Started: IP-Flush", "done!")
	Sleeper($Sleep / 1000, "Operation Started: IP-Flush")
	SetStatus("Operation Started: IP-Flush", "renewing all ips... (ipconfig /renew *)")
	ShellExecuteWait("ipconfig", "/renew *", "", "", @SW_HIDE)
	SetStatus("Operation Started: IP-Flush", "done!")
	Sleep(2000)
	Return "IP-Flush" 
EndFunc   ;==>LanReconnect

Func DialUpReconnect()
	SetStatus("Operation Started: Dial-Up", "disconnecting the connection '" & $connection & "'")
	ShellExecuteWait("rasdial", '"' & $connection & '"' & " /disconnect", "", "", @SW_HIDE)
	SetStatus("Operation Started: Dial-Up", "done!")
	Sleeper($Sleep / 1000, "Operation Started: Dial-Up")
	SetStatus("Operation Started: Dial-Up", "dialing: '" & $connection & ' Using your data.')
	ShellExecuteWait("rasdial", '"' & $connection & '"' & " " & $login & " " & $password, "", "", @SW_HIDE)
	SetStatus("Operation Started: Dial-Up", "done!")
	Sleep(2000)
	Return "Dial-Up" 
EndFunc   ;==>DialUpReconnect

Func NetworkReconnect()
	SetStatus("Operation Started: D/E-Net", "disabling the connection '" & $network & "'")
	ShellExecuteWait("netsh", '"interface ip set address "' & $network & '" static 10.0.0.1 255.0.0.0 10.0.0.2 1"', "", "", @SW_HIDE)
	SetStatus("Operation Started: D/E-Net", "done!")
	Sleeper($Sleep / 1000, "Operation Started: D/E-Net")
	SetStatus("Operation Started: D/E-Net", "enabling the connection '" & $network & "'")
	ShellExecuteWait("netsh", '"interface ip set address "' & $network & '" dhcp"', "", "", @SW_HIDE)
	SetStatus("Operation Started: D/E-Net", "done!")
	Sleep(2000)
	Return "D/E-Net" 
EndFunc   ;==>NetworkReconnect

Func ThoroughReconnect()
	SetStatus("Operation Started: D/E-Net", "disabling the connection '" & $network & "'")
	ShellExecuteWait("netsh", '"interface ip set address "' & $network & '" static 10.0.0.1 255.0.0.0 10.0.0.2 1"', "", "", @SW_HIDE)
	SetStatus("Operation Started: D/E-Net", "done!")
	Sleeper($Sleep / 1000, "Operation Started: D/E-Net")
	LanReconnect()
	SetStatus("Operation Started: D/E-Net", "enabling the connection '" & $network & "'")
	ShellExecuteWait("netsh", '"interface ip set address "' & $network & '" dhcp"', "", "", @SW_HIDE)
	SetStatus("Operation Started: D/E-Net", "done!")
	Sleep(2000)
	DialUpReconnect()
	Return "Thorough" 
EndFunc   ;==>ThoroughReconnect

Func GuiSetStatus($set, $icon, $msg)
	If $set = 0 Then ;GuiSetStatus(0,"Start.ico","Operation Started!")
		If @Compiled = 0 Then
			$ret = GUICtrlSetImage($IPStatus, @ScriptDir & "\" & $IconsNonCompiled[$icon])
			;If $ret = 0 Then MsgBox(0,$IconsCompiled[$icon],@ScriptFullPath)
		Else
			$ret = GUICtrlSetImage($IPStatus, @ScriptFullPath, $IconsCompiled[$icon])
			;If $ret = 0 Then MsgBox(0,$IconsCompiled[$icon],@ScriptFullPath)
		EndIf
		GUICtrlSetTip($IPStatus, $msg)
		GUICtrlSetState($DoubleClickCombo, $GUI_DISABLE)
		GUICtrlSetState($Input1, $GUI_DISABLE)
		GUICtrlSetState($Input2, $GUI_DISABLE)
		GUICtrlSetState($Input3, $GUI_DISABLE)
		GUICtrlSetState($Input4, $GUI_DISABLE)
		GUICtrlSetState($Radio1, $GUI_DISABLE)
		GUICtrlSetState($Radio2, $GUI_DISABLE)
		GUICtrlSetState($Radio3, $GUI_DISABLE)
		GUICtrlSetState($Radio4, $GUI_DISABLE)
		GUICtrlSetState($PrefferedIPCB, $GUI_DISABLE)
		GUICtrlSetState($PrefferedIPInput, $GUI_DISABLE)
		GUICtrlSetState($IPValidationCB, $GUI_DISABLE)
		GUICtrlSetState($IPValidationInput, $GUI_DISABLE)
		GUICtrlSetState($persistantCB, $GUI_DISABLE)
		GUICtrlSetState($popupstatusCB, $GUI_DISABLE)
		GUICtrlSetState($ApplySettings, $GUI_DISABLE)
	Else ;GuiSetStatus(1,"cp.ico","Idle...")
		If $state = "IP"  Then Radio1()
		If $state = "DIAL"  Then Radio2()
		If $state = "NET"  Then Radio3()
		If $state = "ALL"  Then Radio4()
		If @Compiled = 0 Then
			$ret = GUICtrlSetImage($IPStatus, @ScriptDir & "\" & $IconsNonCompiled[$icon])
			;If $ret = 0 Then MsgBox(0,"Failed","Icon SHIT")
		Else
			$ret = GUICtrlSetImage($IPStatus, @ScriptFullPath, $IconsCompiled[$icon])
			;If $ret = 0 Then MsgBox(0,"Failed","Icon SHIT")
		EndIf
		GUICtrlSetTip($IPStatus, $msg)
		GUICtrlSetState($Radio1, $GUI_ENABLE)
		GUICtrlSetState($Radio2, $GUI_ENABLE)
		GUICtrlSetState($Radio3, $GUI_ENABLE)
		GUICtrlSetState($Radio4, $GUI_ENABLE)
		GUICtrlSetState($Input4, $GUI_ENABLE)
		GUICtrlSetState($PrefferedIPCB, $GUI_ENABLE)
		ControlDependentSet($PrefferedIPInput, $PrefferedIP)
		GUICtrlSetState($IPValidationCB, $GUI_ENABLE)
		ControlDependentSet($IPValidationInput, $IPValidation)
		GUICtrlSetState($persistantCB, $GUI_ENABLE)
		GUICtrlSetState($popupstatusCB, $GUI_ENABLE)
		GUICtrlSetState($ApplySettings, $GUI_ENABLE)
		GUISetState(@SW_RESTORE)
	EndIf
EndFunc   ;==>GuiSetStatus

Func CheckboxStatusSet($control, $var)
	If $var = 1 Then
		GUICtrlSetState($control, $GUI_CHECKED)
	Else
		GUICtrlSetState($control, $GUI_UNCHECKED)
	EndIf
EndFunc   ;==>CheckboxStatusSet
Func CheckboxStatusGet($control)
	If GUICtrlRead($control) = $GUI_CHECKED Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>CheckboxStatusGet
Func ControlDependentSet($control, $var)
	If $var = 1 Then
		GUICtrlSetState($control, $GUI_ENABLE)
	Else
		GUICtrlSetState($control, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ControlDependentSet
Func Switcher($element)
	If $element = 0 Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>Switcher
Func SetStatus($Line1, $Line2)
	GUICtrlSetData($Status, $Line1 & @CRLF & $Line2)
	Sleep(750)
EndFunc   ;==>SetStatus

Func TrayCreate()
	If $TrayCreated = 0 Then
		$TrayCreated = 1
		Opt("TrayOnEventMode", 1)
		Opt("TrayMenuMode", 1) 	; Default tray menu items (Script Paused/Exit) will not be shown.
		$infoitem = TrayCreateItem("Exit")
		TrayItemSetOnEvent(-1, "ExitProg")
		TraySetIcon("connector.ico")
		TraySetToolTip("Dear user, Internet reconnection is in process!")
	EndIf
	TraySetState(1)
EndFunc   ;==>TrayCreate
Func ExitProg()
	Exit
EndFunc   ;==>ExitProg

Func ShowToolTip($text, $mode, $time)
	$Rtime = $time * 1000
	$timer = TimerInit()
	While 1
		If TimerDiff($timer) < $Rtime Then
			ToolTip($text, MouseGetPos(0), MouseGetPos(1), "Auto'Reconnect:", $mode, 1)
		Else
			ExitLoop
		EndIf
	WEnd
	ToolTip("")
EndFunc   ;==>ShowToolTip

Func GetDialUpName()
	$NetworkConnection = GUICtrlRead($Input1)
	If $NetworkConnection <> "'Your Dialing Connection'"  Then Return $NetworkConnection
	If $state = "DIAL"  Then Return $NetworkConnection
	GuiSetStatus(0, 3, "Collecting Information...")
	SetStatus("Dial-Up:", "looking for the current active connection...")
	; Run child process and provide console i/o for it.
	; Parameter of 2 = provide standard output
	$ourProcess = Run("rasdial", @SystemDir, @SW_HIDE, 2)
	; Loop and update the edit control unitl we hit EOF (and get an error)
	While 1
		If $ourProcess Then
			; Calling StdoutRead like this returns the characters waiting to be read
			$charsWaiting = StdoutRead($ourProcess, 0, 1)
			If @error = -1 Then
				$ourProcess = 0
				SetStatus("Dial-Up:", "search is done!")
				ExitLoop
			EndIf
			If $charsWaiting Then
				$currentRead = StdoutRead($ourProcess)
				If StringInStr($currentRead, "Connected to") <> 0 Then
					$NetRegExp = StringRegExp($currentRead, "Connected to.*\n(.*)", 3)
					$NetworkConnection = StringStripWS(StringStripCR($NetRegExp[0]), 3)
					;MsgBox(0,"","'"&$NetworkConnection&"'")
					ExitLoop
				ElseIf StringInStr($currentRead, "No connections") <> 0 Then
					$NetworkConnection = "'Your Dialing Connection'" 
					ExitLoop
				EndIf
			EndIf
		EndIf
	WEnd
	If $NetworkConnection <> "'Your Dialing Connection'"  Then
		SetStatus("Dial-Up:", "using current active connection: " & $NetworkConnection)
		ShowToolTip("Dial-Up Search:" & @CRLF & "Your dial-up connection was found:" & @CRLF & $NetworkConnection & @CRLF & "(input you're user-name and password!)", 1, 3)
		GuiSetStatus(1, 3, "Idle...")
		Return $NetworkConnection
	Else
		SetStatus("Dial-Up:", "current active connection not found!")
		ShowToolTip("Dial-Up Search:" & @CRLF & "Current active connection not found!" & @CRLF & "(it is most likely that you are not a dial-up user!)", 2, 5)
		GuiSetStatus(1, 3, "Idle...")
		Return $NetworkConnection
	EndIf
EndFunc   ;==>GetDialUpName

Func GetConnectionName()
	$NetworkConnectionNET = GUICtrlRead($DoubleClickCombo)
	If $state = "NET"  Then Return $NetworkConnectionNET
	GuiSetStatus(0, 3, "Collecting Information...")
	SetStatus("D/E-Net:", "looking your LAN devices...")
	; Run child process and provide console i/o for it.
	; Parameter of 2 = provide standard output
	$ourProcess = Run("ipconfig", @SystemDir, @SW_HIDE, 2)
	; Loop and update the edit control unitl we hit EOF (and get an error)
	While 1
		If $ourProcess Then
			; Calling StdoutRead like this returns the characters waiting to be read
			$charsWaiting = StdoutRead($ourProcess, 0, 1)
			If @error = -1 Then
				$ourProcess = 0
				SetStatus("D/E-Net:", "search is done!")
				ExitLoop
			EndIf
			If $charsWaiting Then
				$currentRead = StdoutRead($ourProcess)
				;MsgBox(0, "", $currentRead)
				If StringInStr($currentRead, "Ethernet adapter") <> 0 Then
					$NetRegExp = StringRegExp($currentRead, "Ethernet adapter (.*):", 3)
					;MsgBox(0, "", $NetRegExp[0])
					$NetworkConnectionNET = $NetRegExp[0]
					For $i = 1 To UBound($NetRegExp) - 1
						$NetworkConnectionNET = $NetworkConnectionNET & "|" & $NetRegExp[$i] & "|" 
						;MsgBox(0, "", $NetworkConnectionNET)
					Next
					ExitLoop
				Else
					;MsgBox(0, "", "I Am HERE!!!")
					$NetworkConnectionNET = "'Your Local Area Connection'" 
					ExitLoop
				EndIf
			EndIf
		EndIf
	WEnd
	;MsgBox(0, "", $NetworkConnectionNET)
	If $NetworkConnectionNET = "'Your Local Area Connection'"  Then
		SetStatus("D/E-Net:", "no 'LAN' connections were found!")
		ShowToolTip("D/E-Net Search:" & @CRLF & "Your 'LAN' devices were not found" & @CRLF & "(try entering it manualy!)", 2, 5)
		GuiSetStatus(1, 3, "Idle...")
		Return $NetworkConnectionNET
	Else
		SetStatus("D/E-Net:", "choose your active connection from the list")
		ShowToolTip("D/E-Net Search:" & @CRLF & "Your 'LAN' devices were found and mapped" & @CRLF & "(choose the active one from the list!)", 1, 3)
		GuiSetStatus(1, 3, "Idle...")
		Return $NetworkConnectionNET
	EndIf
EndFunc   ;==>GetConnectionName

Func Radio1()
	GUICtrlSetState($DoubleClickCombo, $GUI_DISABLE)
	GUICtrlSetState($Input1, $GUI_DISABLE)
	GUICtrlSetState($Input2, $GUI_DISABLE)
	GUICtrlSetState($Input3, $GUI_DISABLE)
	$state = "IP" 
EndFunc   ;==>Radio1
Func Radio2()
	GUICtrlSetData($Input1, GetDialUpName())
	GUICtrlSetState($DoubleClickCombo, $GUI_DISABLE)
	GUICtrlSetState($Input1, $GUI_ENABLE)
	GUICtrlSetState($Input2, $GUI_ENABLE)
	GUICtrlSetState($Input3, $GUI_ENABLE)
	$state = "DIAL" 
EndFunc   ;==>Radio2
Func Radio3()
	GUICtrlSetData($DoubleClickCombo, GetConnectionName())
	GUICtrlSetState($DoubleClickCombo, $GUI_ENABLE)
	GUICtrlSetState($Input1, $GUI_DISABLE)
	GUICtrlSetState($Input2, $GUI_DISABLE)
	GUICtrlSetState($Input3, $GUI_DISABLE)
	$state = "NET" 
EndFunc   ;==>Radio3
Func Radio4()
	GUICtrlSetState($DoubleClickCombo, $GUI_ENABLE)
	GUICtrlSetState($Input1, $GUI_ENABLE)
	GUICtrlSetState($Input2, $GUI_ENABLE)
	GUICtrlSetState($Input3, $GUI_ENABLE)
	$state = "ALL" 
EndFunc   ;==>Radio4
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-[GARBAGE BIN!]-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#cs

#ce