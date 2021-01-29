#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=E:\Programming\AU3 in progress\connector.ico
#AutoIt3Wrapper_Outfile=E:\Programming\AU3 in progress\Auto-Reconnector.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Auto-Reconnector v1.1 by Shlomi.Kalfa was made to disconnect and reconnect automaticaly from the internet using diffrent mathodes.  Yet another SK's Product, Enjoy.
#AutoIt3Wrapper_Res_Description=Disconnects & Reconnects your internet connection!
#AutoIt3Wrapper_Res_Fileversion=1.1.0.3
#AutoIt3Wrapper_res_requestedExecutionLevel=highestAvailable
#AutoIt3Wrapper_Res_Icon_Add=E:\Programming\AU3 in progress\Failure.ico
#AutoIt3Wrapper_Res_Icon_Add=E:\Programming\AU3 in progress\Start.ico
#AutoIt3Wrapper_Res_Icon_Add=E:\Programming\AU3 in progress\Success.ico
#AutoIt3Wrapper_Res_Icon_Add=E:\Programming\AU3 in progress\cp.ico
#AutoIt3Wrapper_Run_Au3check=n
#AutoIt3Wrapper_Run_Tidy=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs
	=========V0.1.2 24.03,07==========
	TODO:
	-.
	BUGS:
	-.
	CHANGES:
	-* V1.1.0.3
	-. Supports 251 routers + exports a router list for (E) to pick.
#ce
#include <GUIConstants.au3>
#include <INet.au3>
#include <IE.au3>
#include <Date.au3>
#include <Array.au3>
;BETA's
#include <ButtonConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
;Self includes.
#include "_StringToBase64.au3"
#include "Reconnect RouterNamingList.au3"
FileInstall("E:\Programming\AU3 in progress\curl.exe", @ScriptDir & '\curl.exe', 0)

Opt("OnExitFunc", "OnExitFunction")

$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
If FileGetSize(@ScriptDir & "\" & @ScriptName & ".Router.Log") / 1048576 > 3 Then FileDelete(@ScriptDir & "\" & @ScriptName & ".Router.Log") ;Check log before starting process!

Dim $IconsNonCompiled[4] = ["Failure.ico", "Start.ico", "Success.ico", "cp.ico"]
Dim $IconsCompiled[4] = [-3, -4, -5, -6]

Global $Version = "v1.1"
Global $Status, $OPT_PreferredIPInput, $OPT_PreferredIpCB, $persistantCB, $OPT_StatusTipCB, $success, $TrayCreated, $silent, _
		$state, $network, $connection, $login, $password, $UserIPTimeInterval, $NetWorkAndRouterLable, $DialUpConAndRouterIPLable
Global $NetworkConnection, $NetworkConnectionNET, $NetworkConnectionTimer, $Sleep, $IPLable, $IPLablePre, $IPStatus, _
		$ApplySettings, $OPT_NetwrokConnectionCombo, $OPT_DialUpConnectionInput, $OPT_RouterReconnectionRadio, $OPT_LoginInput, $OPT_PassWordInput, $OPT_ReconnectorSleepInput, $OPT_IPFlushRadio, $OPT_DialUpRadio, $OPT_DENetRadio, $OPT_ThoroughRadio, $persistant, $popupstatus, $PrefferedIP, $PrefferedIPToUse, $IPValidation, $OPT_ValidateIPCB, $OPT_ValidateIPInput
Global $IP = _GetIP()
Global $NewIP = $IP
Global $UseLogFile = 0
Global $Router_action = 0

$filecheck = FileExists(@ScriptDir & "\Reconnect.ini")
If $filecheck = 1 Then
	$silent = 1
	$state = IniRead("Reconnect.ini", "Settings:", "state", "")
	$network = IniRead("Reconnect.ini", "Settings:", "network", "")
	$connection = IniRead("Reconnect.ini", "Settings:", "connection", "")
	$Router_action = IniRead("Reconnect.ini", "Settings:", "Router_action", 0)
	$login = IniRead("Reconnect.ini", "Settings:", "login", "")
	$password = IniRead("Reconnect.ini", "Settings:", "password", "")
	$Sleep = IniRead("Reconnect.ini", "Settings:", "Sleep", "")
	$PrefferedIP = IniRead("Reconnect.ini", "Settings:", "PrefferedIP", 0)
	$PrefferedIPToUse = IniRead("Reconnect.ini", "Settings:", "PrefferedIPToUse", "")
	$persistant = IniRead("Reconnect.ini", "Settings:", "persistant", 1)
	$popupstatus = IniRead("Reconnect.ini", "Settings:", "popupstatus", 1)
	$IPValidation = IniRead("Reconnect.ini", "Settings:", "IPValidation", 0)
	$UserIPTimeInterval = IniRead("Reconnect.ini", "Settings:", "UserIPTimeInterval", "")
	$UseLogFile = IniRead("Reconnect.ini", "Settings:", "UseLogFile", 0)
	If $state = "" Then Setup()
	If $state = "NET" And $network = "" Then Setup()
	If $state = "DIAL" And ($connection = "" Or $login = "" Or $password = "") Then Setup()
	If $state = "ALL" And ($network = "" Or $connection = "" Or $login = "" Or $password = "") Then Setup()
	If $state = "ROUTER" And ($network = "" Or $connection = "") Then Setup()
	Reconnect(0)
	ExitProg()
Else
	$silent = 0
	Setup()
EndIf

Func Setup()
	#Region ### START Koda GUI section ### Form=E:\Programming\AU3 in progress\routerreconnectors\auto reconnector\autoreconnect.kxf
	$AutoReconnect = GUICreate("Auto Re'Connect " & $Version, 482, 283, 195, 185)
	GUISetBkColor(0xEEEFF7)
	GUISetIcon(@ScriptDir, "connector.ico", 0)
	$OPT_BuiltInGroup = GUICtrlCreateGroup("Auto'Reconnection Setup:", 7, 0, 469, 157)
	$OPT_ReconnectionGroup = GUICtrlCreateGroup("Reconnection Method:", 15, 16, 185, 113)
	$OPT_IPFlushRadio = GUICtrlCreateRadio("IP Flush. (adsl)", 23, 31, 161, 17)
	GUICtrlSetTip(-1, "Releases all network cards ip-addresses and Renews them.")
	$OPT_DialUpRadio = GUICtrlCreateRadio("Dial-Up. (all users with dial-up)", 23, 51, 169, 17)
	GUICtrlSetTip(-1, "Disconnects from the specified dial-up connection and Redials to it.")
	$OPT_DENetRadio = GUICtrlCreateRadio("Disable Network", 23, 71, 169, 17)
	GUICtrlSetTip(-1, "Disables the network connection specified and Enables it." & @CRLF & "(use only if you're a dhcp user!")
	$OPT_ThoroughRadio = GUICtrlCreateRadio("Thorough. (Recomanded)", 23, 91, 145, 17)
	GUICtrlSetTip(-1, "Tries the entire 3 mathodes. 'D/E Net', then 'IP-Flush'  'Dial-Up'." & @CRLF & "(Recommanded!)")
	$OPT_RouterReconnectionRadio = GUICtrlCreateRadio("Router Reconnection", 23, 111, 145, 17)
	GUICtrlSetTip(-1, "Performs a reconnection for router users." & @CRLF & "if your router is not on the supported list, contact SK!")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$OPT_LoginDetails = GUICtrlCreateGroup("Login Details:", 207, 16, 261, 113)
	$OPT_NetwrokConnectionCombo = GUICtrlCreateCombo("'Your Local Area Connection'", 315, 28, 149, 25)
	GUICtrlSetTip(-1, "Choose the propper network device you would like to reconnect.")
	$OPT_DialUpConnectionInput = GUICtrlCreateInput("'Your Dialing Connection'", 315, 52, 149, 21)
	GUICtrlSetTip(-1, "Input the name of the dialing connection to Disconnect and Redial to.")
	$OPT_LoginInput = GUICtrlCreateInput("'Your Login Name'", 315, 76, 149, 21)
	GUICtrlSetTip(-1, "Input the user name to use while Redialing.")
	$OPT_PassWordInput = GUICtrlCreateInput("'Your Password'", 315, 100, 149, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
	GUICtrlSetTip(-1, "Input the correct password to use while Redialing.")
	$NetWorkAndRouterLable = GUICtrlCreateLabel("Network connection:", 211, 32, 102, 17)
	$DialUpConAndRouterIPLable = GUICtrlCreateLabel("Dial-Up connection:", 211, 55, 102, 17)
	$Label10 = GUICtrlCreateLabel("Login name:", 211, 80, 102, 17)
	$Label11 = GUICtrlCreateLabel("Password:", 211, 104, 102, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$OPT_PreferredIpCB = GUICtrlCreateCheckbox("Preferred IP:", 77, 132, 78, 17)
	GUICtrlSetTip(-1, "If checked 'AutoReconnector' will reconnect untill it'll have the Preferred IP pattern!" & @CRLF & "X is used as variable char (can be anything!)")
	$OPT_PreferredIPInput = GUICtrlCreateInput("xxx.xxx.xxx.xxx|xxx.xxx.xxx.xxx", 155, 132, 71, 21)
	GUICtrlSetTip(-1, "Example: If you'd like to get an ip starting with '60' then you're to put x60.xxx.xxx.xxx" & @CRLF & "or with 2nd char '2' and last '7' put xx2.xxx.xxx.xx7" & @CRLF & "NB: this works with serveral prefferences delimited by '|' !")
	$OPT_ValidateIPCB = GUICtrlCreateCheckbox("Validate IP:", 229, 132, 70, 17)
	GUICtrlSetTip(-1, "This will record you'r previousely used IP and will reconnect in case you get that same IP withing the time interval!" & @CRLF & "RapidShare Blocks IPs for 125 Minutes!")
	$OPT_ValidateIPInput = GUICtrlCreateInput("125", 302, 132, 25, 21)
	GUICtrlSetTip(-1, "Input a time interval in Minutes to wait until the IP will be certainly cleaned and valid!")
	$Label12 = GUICtrlCreateLabel("Sleep:", 15, 134, 34, 17)
	$OPT_ReconnectorSleepInput = GUICtrlCreateInput("45", 49, 132, 25, 21)
	GUICtrlSetTip(-1, "Input a time interval in seconds to wait between each procces, 60 seconds is recommanded" & @CRLF & "that variable depends on your ISP IPs releasing policies! you might use a lesser number!")
	$OPT_PersistancyCB = GUICtrlCreateCheckbox("Persistancy", 332, 132, 73, 17)
	GUICtrlSetTip(-1, "If checked 'AutoReconnector' will compare the previous IP with the new one and will reconnect if it hasn't changed !")
	GUICtrlSetState(-1, $GUI_CHECKED)
	$OPT_StatusTipCB = GUICtrlCreateCheckbox("Status tip", 407, 132, 60, 17)
	GUICtrlSetTip(-1, "If checked 'AutoReconnector' show a status pop-up massage after each time the operation is done !")
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Group1 = GUICtrlCreateGroup("Status:", 7, 198, 470, 60)
	$Status = GUICtrlCreateLabel("Label3", 15, 213, 416, 37)
	If @Compiled = 0 Then
		$IPStatus = GUICtrlCreateIcon(@ScriptDir & "\" & $IconsNonCompiled[3], 0, 435, 213, 32, 32, BitOR($SS_NOTIFY, $WS_GROUP, $BS_ICON))
	Else
		$IPStatus = GUICtrlCreateIcon(@ScriptFullPath, $IconsCompiled[3], 435, 213, 32, 32, BitOR($SS_NOTIFY, $WS_GROUP, $BS_ICON))
	EndIf
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$ApplySettings = GUICtrlCreateButton("Save And Reconnect", 10, 160, 185, 35)
	$IPLable = GUICtrlCreateLabel("Current external IP: " & $NewIP, 290, 165, 269, 17)
	$IPLablePre = GUICtrlCreateLabel("Previous external IP: " & $IP, 290, 183, 269, 17)

	$CreditsL = GUICtrlCreateLabel("(E)Auto-Reconnect " & $Version & "(TM) by Shlomi.Kalfa, 2007.                            www.e-lephant.org", 0, 260, 481, 22, BitOR($SS_CENTER, $SS_CENTERIMAGE, $WS_BORDER))
	GUICtrlSetFont(-1, 4, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x9DB9EB)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	GUICtrlSetState($OPT_IPFlushRadio, $GUI_CHECKED)
	GUICtrlSetState($OPT_NetwrokConnectionCombo, $GUI_DISABLE)
	GUICtrlSetState($OPT_DialUpConnectionInput, $GUI_DISABLE)
	GUICtrlSetState($OPT_LoginInput, $GUI_DISABLE)
	GUICtrlSetState($OPT_PassWordInput, $GUI_DISABLE)
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

			Case $OPT_IPFlushRadio
				Radio1()
				;disable all settings + set function -> adsl.
			Case $OPT_DialUpRadio
				Radio2()
				;leave all slots, use dial up settings.
			Case $OPT_DENetRadio
				Radio3()

			Case $OPT_ThoroughRadio
				Radio4()
				;leave all slots, use all mathodes.

			Case $OPT_RouterReconnectionRadio
				Radio5()

			Case $ApplySettings
				If $state <> "IP" Then
					Switch $state
						Case "DIAL"
							$network = ""
							$connection = GUICtrlRead($OPT_DialUpConnectionInput)
							$login = GUICtrlRead($OPT_LoginInput)
							$password = GUICtrlRead($OPT_PassWordInput)
						Case "NET"
							$network = GUICtrlRead($OPT_NetwrokConnectionCombo)
							$connection = ""
							$login = ""
							$password = ""
						Case "ALL"
							$network = GUICtrlRead($OPT_NetwrokConnectionCombo)
							$connection = GUICtrlRead($OPT_DialUpConnectionInput)
							$login = GUICtrlRead($OPT_LoginInput)
							$password = GUICtrlRead($OPT_PassWordInput)
						Case "ROUTER"
							$network = GetRouterFuncBySearch(GUICtrlRead($OPT_NetwrokConnectionCombo))
							$connection = GUICtrlRead($OPT_DialUpConnectionInput)
							$login = GUICtrlRead($OPT_LoginInput)
							$password = GUICtrlRead($OPT_PassWordInput)
					EndSwitch
				Else
					$network = ""
					$connection = ""
					$login = ""
					$password = ""
				EndIf
				$PrefferedIPToUse = GUICtrlRead($OPT_PreferredIPInput)
				$UserIPTimeInterval = GUICtrlRead($OPT_ValidateIPInput)
				$Sleep = GUICtrlRead($OPT_ReconnectorSleepInput) * 1000
				$Router_action = IniRead("Reconnect.ini", "Settings:", "Router_action", 0)
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
				Else
					SetStatus("IP Switch Failed !", "")
				EndIf
				GuiSetStatus(1, 3, "Idle...")

			Case $persistantCB
				$persistant = Switcher($persistant)
			Case $OPT_StatusTipCB
				$popupstatus = Switcher($popupstatus)
			Case $OPT_ValidateIPCB
				$IPValidation = Switcher($IPValidation)
				ControlDependentSet($OPT_ValidateIPInput, $IPValidation)
			Case $OPT_PreferredIpCB
				$PrefferedIP = Switcher($PrefferedIP)
				ControlDependentSet($OPT_PreferredIPInput, $PrefferedIP)
			Case $CreditsL
				Run(@ComSpec & " /c " & "start " & "http://www.e-lephant.org" & " /SEPARATE", "", @SW_HIDE)
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
		Case "ROUTER"
			$op = Call("RouterReconnectCall_" & $network)
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
			If StringLower($prefsegseg[$i2]) <> "x" And StringLower($prefsegseg[$i2]) <> StringLower($ipsegseg[$i2]) Then
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
	For $i = $time To 0 Step -1
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
		GUICtrlSetState($OPT_NetwrokConnectionCombo, $GUI_DISABLE)
		GUICtrlSetState($OPT_DialUpConnectionInput, $GUI_DISABLE)
		GUICtrlSetState($OPT_LoginInput, $GUI_DISABLE)
		GUICtrlSetState($OPT_PassWordInput, $GUI_DISABLE)
		GUICtrlSetState($OPT_ReconnectorSleepInput, $GUI_DISABLE)
		GUICtrlSetState($OPT_IPFlushRadio, $GUI_DISABLE)
		GUICtrlSetState($OPT_DialUpRadio, $GUI_DISABLE)
		GUICtrlSetState($OPT_DENetRadio, $GUI_DISABLE)
		GUICtrlSetState($OPT_ThoroughRadio, $GUI_DISABLE)
		GUICtrlSetState($OPT_RouterReconnectionRadio, $GUI_DISABLE)
		GUICtrlSetState($OPT_PreferredIpCB, $GUI_DISABLE)
		GUICtrlSetState($OPT_PreferredIPInput, $GUI_DISABLE)
		GUICtrlSetState($OPT_ValidateIPCB, $GUI_DISABLE)
		GUICtrlSetState($OPT_ValidateIPInput, $GUI_DISABLE)
		GUICtrlSetState($persistantCB, $GUI_DISABLE)
		GUICtrlSetState($OPT_StatusTipCB, $GUI_DISABLE)
		GUICtrlSetState($ApplySettings, $GUI_DISABLE)
	Else ;GuiSetStatus(1,"cp.ico","Idle...")
		If $state = "IP" Then Radio1()
		If $state = "DIAL" Then Radio2()
		If $state = "NET" Then Radio3()
		If $state = "ALL" Then Radio4()
		If $state = "ROUTER" Then Radio5()
		If @Compiled = 0 Then
			$ret = GUICtrlSetImage($IPStatus, @ScriptDir & "\" & $IconsNonCompiled[$icon])
			;If $ret = 0 Then MsgBox(0,"Failed","Icon SHIT")
		Else
			$ret = GUICtrlSetImage($IPStatus, @ScriptFullPath, $IconsCompiled[$icon])
			;If $ret = 0 Then MsgBox(0,"Failed","Icon SHIT")
		EndIf
		GUICtrlSetTip($IPStatus, $msg)
		GUICtrlSetState($OPT_IPFlushRadio, $GUI_ENABLE)
		GUICtrlSetState($OPT_DialUpRadio, $GUI_ENABLE)
		GUICtrlSetState($OPT_DENetRadio, $GUI_ENABLE)
		GUICtrlSetState($OPT_ThoroughRadio, $GUI_ENABLE)
		GUICtrlSetState($OPT_RouterReconnectionRadio, $GUI_ENABLE)
		GUICtrlSetState($OPT_ReconnectorSleepInput, $GUI_ENABLE)
		GUICtrlSetState($OPT_PreferredIpCB, $GUI_ENABLE)
		ControlDependentSet($OPT_PreferredIPInput, $PrefferedIP)
		GUICtrlSetState($OPT_ValidateIPCB, $GUI_ENABLE)
		ControlDependentSet($OPT_ValidateIPInput, $IPValidation)
		GUICtrlSetState($persistantCB, $GUI_ENABLE)
		GUICtrlSetState($OPT_StatusTipCB, $GUI_ENABLE)
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
		Opt("TrayMenuMode", 1) ; Default tray menu items (Script Paused/Exit) will not be shown.
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
	$NetworkConnection = GUICtrlRead($OPT_DialUpConnectionInput)
	If $NetworkConnection <> "" And $NetworkConnection <> "'Your Dialing Connection'" Then Return $NetworkConnection
	If $state = "DIAL" Then Return $NetworkConnection
	GuiSetStatus(0, 3, "Collecting Information...")
	SetStatus("Dial-Up:", "looking for the current active connection...")
	; Run child process and provide console i/o for it.
	; Parameter of 2 = provide standard output
	$ourProcess = Run("rasdial", @SystemDir, @SW_HIDE, 2)
	; Loop and update the edit control unitl we hit EOF (and get an error)
	While 1
		If $ourProcess Then
			; Calling StdoutRead like this returns the characters waiting to be read
			$charsWaiting = StdoutRead($ourProcess, 1)
			If @error = -1 Then
				$ourProcess = 0
				SetStatus("Dial-Up:", "search is done!")
				ExitLoop
			EndIf
			If $charsWaiting Then
				$currentRead = StdoutRead($ourProcess, 1)
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
	If $NetworkConnection <> "'Your Dialing Connection'" Then
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
	$NetworkConnectionNET = GUICtrlRead($OPT_NetwrokConnectionCombo)
	If $NetworkConnectionNET <> "" And $NetworkConnectionNET <> "'Your Local Area Connection'" Then Return $NetworkConnectionNET
	GuiSetStatus(0, 3, "Collecting Information...")
	SetStatus("D/E-Net:", "looking your LAN devices...")
	; Run child process and provide console i/o for it.
	; Parameter of 2 = provide standard output
	$ourProcess = Run("ipconfig", @SystemDir, @SW_HIDE, 2)
	; Loop and update the edit control unitl we hit EOF (and get an error)
	While 1
		If $ourProcess Then
			; Calling StdoutRead like this returns the characters waiting to be read
			$charsWaiting = StdoutRead($ourProcess, 1)
			If @error = -1 Then
				$ourProcess = 0
				SetStatus("D/E-Net:", "search is done!")
				ExitLoop
			EndIf
			If $charsWaiting Then
				$currentRead = StdoutRead($ourProcess, 1)
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
	If $NetworkConnectionNET = "'Your Local Area Connection'" Then
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
Func GetRoutersIP()
	$NetworkConnection = GUICtrlRead($OPT_DialUpConnectionInput)
	If $NetworkConnection <> "" And $NetworkConnection <> "'Your Dialing Connection'" Then Return $NetworkConnection
	; Run child process and provide console i/o for it.
	; Parameter of 2 = provide standard output
	$ourProcess = Run("ipconfig", @SystemDir, @SW_HIDE, 2)
	; Loop and update the edit control unitl we hit EOF (and get an error)
	While 1
		If $ourProcess Then
			; Calling StdoutRead like this returns the characters waiting to be read
			$charsWaiting = StdoutRead($ourProcess, 1)
			If @error = -1 Then
				$ourProcess = 0
				ExitLoop
			EndIf
			If $charsWaiting Then
				$currentRead = StdoutRead($ourProcess, 1)
				;MsgBox(0, "", $currentRead)
				If StringInStr($currentRead, "Default Gateway") <> 0 Then
					$NetRegExp = StringRegExp($currentRead, "Default Gateway.+?(\d+.\d+.\d+.\d+)", 3)
					If @error <> 0 Then Return $NetworkConnection
					$NetworkConnection = $NetRegExp[0]
					For $i = 1 To UBound($NetRegExp) - 1
						$NetworkConnection = $NetworkConnection & "|" & $NetRegExp[$i] & "|"
						;MsgBox(0, "", $NetworkConnectionNET)
					Next
					ExitLoop
				Else
					;MsgBox(0, "", "I Am HERE!!!")
					$NetworkConnection = "'Your Router's IP'"
					ExitLoop
				EndIf
			EndIf
		EndIf
	WEnd
	;MsgBox(0, "", $NetworkConnectionNET)

	Return $NetworkConnection
EndFunc   ;==>GetRoutersIP

Func Radio1()
	GUICtrlSetData($NetWorkAndRouterLable, "Network connection:")
	GUICtrlSetState($OPT_NetwrokConnectionCombo, $GUI_DISABLE)
	GUICtrlSetState($OPT_DialUpConnectionInput, $GUI_DISABLE)
	GUICtrlSetData($DialUpConAndRouterIPLable, "Dial-Up connection:")
	GUICtrlSetTip($OPT_DialUpConnectionInput, "Input the name of the dialing connection to Disconnect and Redial to.")
	GUICtrlSetData($OPT_DialUpConnectionInput, "'Your Dialing Connection'")
	GUICtrlSetTip($OPT_LoginInput, "Input the user name to use while Redialing.")
	GUICtrlSetState($OPT_LoginInput, $GUI_DISABLE)
	GUICtrlSetTip($OPT_PassWordInput, "Input the correct password to use while Redialing.")
	GUICtrlSetState($OPT_PassWordInput, $GUI_DISABLE)
	$state = "IP"
EndFunc   ;==>Radio1
Func Radio2()
	GUICtrlSetData($NetWorkAndRouterLable, "Network connection:")
	GUICtrlSetData($DialUpConAndRouterIPLable, "Dial-Up connection:")
	GUICtrlSetData($OPT_DialUpConnectionInput, "'Your Dialing Connection'")
	GUICtrlSetData($OPT_DialUpConnectionInput, GetDialUpName())
	GUICtrlSetState($OPT_NetwrokConnectionCombo, $GUI_DISABLE)
	GUICtrlSetTip($OPT_DialUpConnectionInput, "Input the name of the dialing connection to Disconnect and Redial to.")
	GUICtrlSetState($OPT_DialUpConnectionInput, $GUI_ENABLE)
	GUICtrlSetTip($OPT_LoginInput, "Input the user name to use while Redialing.")
	GUICtrlSetState($OPT_LoginInput, $GUI_ENABLE)
	GUICtrlSetTip($OPT_PassWordInput, "Input the correct password to use while Redialing.")
	GUICtrlSetState($OPT_PassWordInput, $GUI_ENABLE)
	$state = "DIAL"
EndFunc   ;==>Radio2
Func Radio3()
	GUICtrlSetData($NetWorkAndRouterLable, "Network connection:")
	GUICtrlSetData($OPT_NetwrokConnectionCombo, "")
	GUICtrlSetData($OPT_NetwrokConnectionCombo, GetConnectionName())
	GUICtrlSetState($OPT_NetwrokConnectionCombo, $GUI_ENABLE)
	GUICtrlSetData($DialUpConAndRouterIPLable, "Dial-Up connection:")
	GUICtrlSetTip($OPT_DialUpConnectionInput, "Input the name of the dialing connection to Disconnect and Redial to.")
	GUICtrlSetData($OPT_DialUpConnectionInput, "'Your Dialing Connection'")
	GUICtrlSetState($OPT_DialUpConnectionInput, $GUI_DISABLE)
	GUICtrlSetTip($OPT_LoginInput, "Input the user name to use while Redialing.")
	GUICtrlSetState($OPT_LoginInput, $GUI_DISABLE)
	GUICtrlSetTip($OPT_PassWordInput, "Input the correct password to use while Redialing.")
	GUICtrlSetState($OPT_PassWordInput, $GUI_DISABLE)
	$state = "NET"
EndFunc   ;==>Radio3
Func Radio4()
	GUICtrlSetData($NetWorkAndRouterLable, "Network connection:")
	GUICtrlSetData($OPT_NetwrokConnectionCombo, "")
	GUICtrlSetData($OPT_NetwrokConnectionCombo, GetConnectionName())
	GUICtrlSetState($OPT_NetwrokConnectionCombo, $GUI_ENABLE)
	GUICtrlSetData($OPT_DialUpConnectionInput, "'Your Dialing Connection'")
	GUICtrlSetData($OPT_DialUpConnectionInput, GetDialUpName())
	GUICtrlSetData($DialUpConAndRouterIPLable, "Dial-Up connection:")
	GUICtrlSetTip($OPT_DialUpConnectionInput, "Input the name of the dialing connection to Disconnect and Redial to.")
	GUICtrlSetState($OPT_DialUpConnectionInput, $GUI_ENABLE)
	GUICtrlSetTip($OPT_LoginInput, "Input the user name to use while Redialing.")
	GUICtrlSetState($OPT_LoginInput, $GUI_ENABLE)
	GUICtrlSetTip($OPT_PassWordInput, "Input the correct password to use while Redialing.")
	GUICtrlSetState($OPT_PassWordInput, $GUI_ENABLE)
	$state = "ALL"
EndFunc   ;==>Radio4
Func Radio5()
	GUICtrlSetData($NetWorkAndRouterLable, "Router and model:")
	GUICtrlSetData($OPT_NetwrokConnectionCombo, "")
	GUICtrlSetData($OPT_NetwrokConnectionCombo, GetRoutersList())
	GUICtrlSetState($OPT_NetwrokConnectionCombo, $GUI_ENABLE)
	GUICtrlSetData($DialUpConAndRouterIPLable, "Routers IP:")
	GUICtrlSetTip($OPT_DialUpConnectionInput, "Set your router's IP address, EG: 192.168.0.1")
	GUICtrlSetData($OPT_DialUpConnectionInput, GetRoutersIP())
	GUICtrlSetState($OPT_DialUpConnectionInput, $GUI_ENABLE)
	GUICtrlSetTip($OPT_LoginInput, "Input the router's login name. {Leave blank if there is no need for authentication}")
	GUICtrlSetState($OPT_LoginInput, $GUI_ENABLE)
	GUICtrlSetTip($OPT_PassWordInput, "Input the router's password. {Leave blank if there is no need for authentication}")
	GUICtrlSetState($OPT_PassWordInput, $GUI_ENABLE)
	$state = "ROUTER"
EndFunc   ;==>Radio5

;-----------------------------------------------------------------ROUTERs Functions!----------------------------------------------
;SetStatus("Operation Started: Dial-Up", "disconnecting the connection '" & $connection & "'")

Func GetRoutersList()
	$RoutersCount = UBound($RoutersList) - 1
	If $RoutersCount = 0 Then Return ""

	_ArraySort($RoutersList, 0, 0, 0, 1)

	$RoutersL = $RoutersList[0][1]
	For $i = 1 To $RoutersCount
		$RoutersL &= "|" & $RoutersList[$i][1]
	Next

	GenerateRoutersListINI()

	Return $RoutersL
EndFunc   ;==>GetRoutersList
Func GenerateRoutersListINI()
	$RoutersCount = UBound($RoutersList) - 1
	If $RoutersCount = 0 Then Return

	If FileExists(@ScriptDir & '\Auto-Reconnector.SupportedRouters.ini') <> 0 Then
		If IniRead("Auto-Reconnector.SupportedRouters.ini", "SupportedRouters:", $RoutersCount, "N/A/N/A") <> "N/A/N/A" Then Return
	EndIf

	IniWrite("Auto-Reconnector.SupportedRouters.ini", "SupportedRouters:", 0, $RoutersList[0][1])
	For $i = 1 To $RoutersCount
		IniWrite("Auto-Reconnector.SupportedRouters.ini", "SupportedRouters:", $i, $RoutersList[$i][1])
	Next
EndFunc   ;==>GenerateRoutersListINI
Func GetRouterFuncBySearch($Srch)
	$ret = _ArraySearch($RoutersList, $Srch, 0, 0, 0, 0, 1, 1)
	If $ret <> -1 Then Return $RoutersList[$ret][0]
	Return ""
EndFunc   ;==>GetRouterFuncBySearch

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-[Inet GET - RECONNECTIONs]-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Func RouterReconnectInetGET($RoutersIP, $PerRR_Pages, $RoutersAdmin, $RoutersPass, $RoutersSleep)
	$Page = StringSplit($PerRR_Pages, "|")
	SetStatus("Operation Started: Router Reconnection", "connecting router '" & $network & "'")
	For $i = 1 To $Page[0]
		If $i = 1 Then SetStatus("Operation Started: Router Reconnection", "sending the disconnecting command'")
		If $i = 2 Then SetStatus("Operation Started: Router Reconnection", "sending the reconnecting command'")

		__LOG("[Getting: " & "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $Page[$i] & "]" & @CRLF)
		Local $ret = InetGet("http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $Page[$i], @ScriptDir & "/RR.html", 1, 0)
		If $ret = 1 Then
			__LOG("... Successfully done!")
		Else
			__LOG("... Failed !")
		EndIf

		SetStatus("Operation Started: Router Reconnection", "done!'")
		If $i = $Page[0] And $Page[0] > 1 Then ExitLoop
		__LOG("Sleeping: " & $RoutersSleep & " Secs" & @CRLF & "____________________________________________________________________" & @CRLF)
		Sleeper($RoutersSleep / 1000, "Operation Started: Router Reconnection")
	Next

	FileDelete(@ScriptDir & "/RR.html")
	Return "Router Reconnection"
EndFunc   ;==>RouterReconnectInetGET

;;; LinkSYS:::  "LinkSys_WAG_200G_1018", "LinkSys_WAG_54GS", "LinkSys_WAG_54G", "LinkSys_WAG_354G"
Func RouterReconnectCall_LinkSys_WAG_200G_1018() ;GET method!
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	$PerRR_Pages = "setup.cgi?next_file=Status.htm&this_file=Status.htm&todo=disconnect"
	$PerRR_Pages &= "|" & "setup.cgi?next_file=Status.htm&this_file=Status.htm&todo=connect"
	Return RouterReconnectInetGET($RoutersIP, $PerRR_Pages, $RoutersAdmin, $RoutersPass, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_LinkSys_WAG_200G_1018

Func RouterReconnectCall_UTStarCom_WA3002G4()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	$PerRR_Pages = "rebootinfo.cgi"
	Return RouterReconnectInetGET($RoutersIP, $PerRR_Pages, $RoutersAdmin, $RoutersPass, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_UTStarCom_WA3002G4

Func RouterReconnectCall_LinkSys_WAG_54GS() ;GET method!
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	$PerRR_Pages = "setup.cgi?todo=disconnect&ctype=pppoe&this_file=Status.htm&next_file=Status.htm"
	$PerRR_Pages &= "|" & "setup.cgi?todo=connect&ctype=pppoe&this_file=Status.htm&next_file=Status.htm"
	Return RouterReconnectInetGET($RoutersIP, $PerRR_Pages, $RoutersAdmin, $RoutersPass, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_LinkSys_WAG_54GS

Func RouterReconnectCall_LinkSys_WAG_54G() ;GET method!
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	$PerRR_Pages = "Gozila.cgi?RouterStatus.htm=255&hid_returnPoint=&hid_dialAction=2"
	$PerRR_Pages &= "|" & "Gozila.cgi?RouterStatus.htm=255&hid_returnPoint=&hid_dialAction=1"
	Return RouterReconnectInetGET($RoutersIP, $PerRR_Pages, $RoutersAdmin, $RoutersPass, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_LinkSys_WAG_54G

Func RouterReconnectCall_LinkSys_WAG_354G() ;GET method!
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	$PerRR_Pages = "apply.cgi?submit_button=Status_Router&submit_type=disconnect&change_action=gozila_cgi&wan_proto=dhcp"
	$PerRR_Pages &= "|" & "apply.cgi?submit_button=Status_Router&submit_type=connect&change_action=gozila_cgi&wan_proto=dhcp"
	Return RouterReconnectInetGET($RoutersIP, $PerRR_Pages, $RoutersAdmin, $RoutersPass, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_LinkSys_WAG_354G
;--------------------

Func RouterReconnectCall_Draytek_Vigor_2600() ;GET method!
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	$PerRR_Pages = "cgi-bin/online3.cgi"
	$PerRR_Pages &= "|" & "cgi-bin/goinet.cgi"
	Return RouterReconnectInetGET($RoutersIP, $PerRR_Pages, $RoutersAdmin, $RoutersPass, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_Draytek_Vigor_2600

Func RouterReconnectCall_Draytek_Vigor_2800() ;GET method!
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	$PerRR_Pages = "cgi-bin/online3.cgi?ifno=3"
	Return RouterReconnectInetGET($RoutersIP, $PerRR_Pages, $RoutersAdmin, $RoutersPass, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_Draytek_Vigor_2800

Func RouterReconnectCall_ASUS_AM_604g() ;GET method!
	Return RouterReconnectCall_ASUS_WL_600g()
EndFunc   ;==>RouterReconnectCall_ASUS_AM_604g
Func RouterReconnectCall_ASUS_WL_600g() ;GET method!
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	$PerRR_Pages = "rebootinfo.cgi"
	Return RouterReconnectInetGET($RoutersIP, $PerRR_Pages, $RoutersAdmin, $RoutersPass, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_ASUS_WL_600g

Func RouterReconnectCall_3COM_3CRWER100_75() ;GET method!
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	$PerRR_Pages = "iframerebootnocommit.htm" ; maybe use: stbar_reboot_nocommit.htm.
	Return RouterReconnectInetGET($RoutersIP, $PerRR_Pages, $RoutersAdmin, $RoutersPass, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_3COM_3CRWER100_75

Func RouterReconnectCall_Conexant_UNKNOWN() ;GET method!
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	$PerRR_Pages = "doc/doreboot.htm" ; maybe use: stbar_reboot_nocommit.htm.
	Return RouterReconnectInetGET($RoutersIP, $PerRR_Pages, $RoutersAdmin, $RoutersPass, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_Conexant_UNKNOWN

Func RouterReconnectCall_Siemens_2141SL()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	$PerRR_Pages = "constatus.html"

	SetStatus("Operation Started: Router Reconnection", "getting the router's security code.'")
	__LOG("[Getting: " & "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_Pages & "]" & @CRLF)
	Local $ret = InetGet("http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_Pages, @ScriptDir & "/RR.html", 1, 0)
	If $ret = 1 Then
		__LOG("... Successfully done!")
		SetStatus("Operation Started: Router Reconnection", "done!'")
	Else
		__LOG("... Failed !")
		SetStatus("Operation Started: Router Reconnection", "FAILD!'")
		Return
	EndIf

	$Fhandle = FileOpen(@ScriptDir & "/RR.html", 0)
	$text = FileRead($Fhandle)
	FileClose($Fhandle)

	$Parsed = StringRegExp($text, "randomNum = '(\d+)'", 3)
	If @error <> 0 Then
		__LOG("... Failed to parse!")
		SetStatus("Operation Started: Router Reconnection", "FAILD!'")
	EndIf
	$Scode = $Parsed[0]
	$PerRR_Pages = "disconnect.cgi?checkNum=" & $Scode
	Return RouterReconnectInetGET($RoutersIP, $PerRR_Pages, $RoutersAdmin, $RoutersPass, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_Siemens_2141SL

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-[HTTP OBJ - RECONNECTIONs]-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Func RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
		$AllHeaders, $AllPosts)

	$oHttpRequest = ObjCreate($PerRR_OBJ)
	If IsObj($oHttpRequest) <> 1 Then Exit MsgBox(0, @ScriptName & " Notice", "Couldn't set the OBJ, talk to the creator at www.e-lephant.org")

	$Posts = StringSplit($AllPosts, "|")

	For $i = 1 To $Posts[0]
		; Something for the status...
		If $i = 1 Then SetStatus("Operation Started: Router Reconnection", "connecting router '" & $network & "'")
		If $i = 2 Then SetStatus("Operation Started: Router Reconnection", "sending the disconnecting command'")
		If $i = 3 Then SetStatus("Operation Started: Router Reconnection", "sending the reconnecting command'")

		$EditData = ""
		$EditData &= "[Obj:" & $PerRR_OBJ & "][IP:" & $RoutersIPFormed & "][Method:" & $PerRR_Method & "]" & @CRLF & _
				"[Headers:" & @CRLF

		;Check Ups!
		$oHttpRequest.Open($PerRR_Method, $RoutersIPFormed, False)
		$Headers = StringSplit($AllHeaders, "<>", 1) ; $AllHeaders = Title|Content<>Title|Content
		For $i2 = 1 To $Headers[0]
			If $Headers[$i2] <> "" Then
				$HeaderParsed = StringSplit($Headers[$i2], "|")
				If @error = 1 Then ContinueLoop
				$oHttpRequest.setRequestHeader($HeaderParsed[1], $HeaderParsed[2])
				$EditData &= $HeaderParsed[1] & " | " & $HeaderParsed[2] & @CRLF
			EndIf
		Next
		$oHttpRequest.setRequestHeader("Content-Length", StringLen($Posts[$i]))
		$EditData &= "Content-Length" & " | " & StringLen($Posts[$i]) & @CRLF

		$EditData &= "/Headers]" & @CRLF & _
				"[Data:" & $Posts[$i] & "]" & @CRLF
		__LOG($EditData & @CRLF & "____________________________________________________________________" & @CRLF)
		$oHttpRequest.Send($Posts[$i])
		$Recieved = $oHttpRequest.Responsetext

		__LOG($Recieved & @CRLF & "____________________________________________________________________" & @CRLF)
		SetStatus("Operation Started: Router Reconnection", "done!'")
		If $i = 1 Then
			Sleeper(5, "Operation Started: Router Reconnection")
			ContinueLoop
		EndIf
		If $i = $Posts[0] And $Posts[0] > 2 Then ExitLoop
		__LOG("Sleeping: " & $RoutersSleep & " Secs" & @CRLF & "____________________________________________________________________" & @CRLF)
		Sleeper($RoutersSleep / 1000, "Operation Started: Router Reconnection")
	Next
	Return "Router Reconnection"
EndFunc   ;==>RouterReconnectHTTP
;-----------------------------------------------------------------RECONNECTORS:

Func RouterReconnectCall_NetGear_wpn824v2_v2010()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "st_poe.cgi"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "ConMethod=Disconnect"
	$AllPosts &= "|" & "ConMethod=  Connect  "
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_NetGear_wpn824v2_v2010

Func RouterReconnectCall_NetGear_wpn824v2_V20181217()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "RST_st_poe.htm"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "ConMethod=Disconnect"
	$AllPosts &= "|" & "ConMethod=  Connect  "
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_NetGear_wpn824v2_V20181217

Func RouterReconnectCall_NetGear_DG834v2()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "setup.cgi"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "todo=disconnect&this_file=st_poe.htm&next_file=st_poe.htm"
	$AllPosts &= "|" & "todo=connect&this_file=st_poe.htm&next_file=st_poe.htm"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|application/x-www-form-urlencoded"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_NetGear_DG834v2

Func RouterReconnectCall_ASUS_WL520g()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "apply.cgi"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "action_script=dhcpc_release&PPPConnection_x_WANAction_button=Disconnect"
	$AllPosts &= "|" & "action_script=dhcpc_renew&PPPConnection_x_WANAction_button1=Connect"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|application/x-www-form-urlencoded"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_ASUS_WL520g

Func RouterReconnectCall_BR6215SRg()
	Return RouterReconnectCall_Edimax_BR6541K()
EndFunc   ;==>RouterReconnectCall_BR6215SRg
Func RouterReconnectCall_Edimax_BR6104K()
	Return RouterReconnectCall_Edimax_BR6541K()
EndFunc   ;==>RouterReconnectCall_Edimax_BR6104K
Func RouterReconnectCall_Edimax_BR6204WG()
	Return RouterReconnectCall_Edimax_BR6541K()
EndFunc   ;==>RouterReconnectCall_Edimax_BR6204WG
Func RouterReconnectCall_Edimax_BR6541K()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "goform/formReboot"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "reset_flag=1"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_Edimax_BR6541K

Func RouterReconnectCall_DLink_DI524()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "restart.cgi"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "restart=Reboot"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_DLink_DI524

Func RouterReconnectCall_DLink_DI624()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "status.cgi"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "disconnect=Disconnect"
	$AllPosts &= "|" & "connect=Connect"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|application/x-www-form-urlencoded"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_DLink_DI624

Func RouterReconnectCall_DLink_DSL_G624T()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "cgi-bin/webcm?getpage=../html/status_deviceinfo.htm"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "connection0:pppoe:command/stop"
	$AllPosts &= "|" & "connection0:pppoe:command/start"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|application/x-www-form-urlencoded"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_DLink_DSL_G624T

Func RouterReconnectCall_DLink_DSL_520T()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "cgi-bin/webcm?getpage=../html/status/deviceinfofile.htm"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "connection0:pppoe:command/stop"
	$AllPosts &= "|" & "connection0:pppoe:command/start"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|application/x-www-form-urlencoded"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_DLink_DSL_520T

Func RouterReconnectCall_TrendNet_TW100_S4W1CA()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "system_reset.htm"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "page=system_reset"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_TrendNet_TW100_S4W1CA

Func RouterReconnectCall_SMC_SMCWBR14_G()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $return = ""
	For $i = 0 To 1
		Local $PerRR_RoutersDefaultCGI = "status_main.htm"
		Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
		Local $PerRR_Method = "POST" ; HTTP method.
		Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
		Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
		Local $AllPosts = "" ; Always send a blank post first for authentication.
		If $i = 0 Then $AllPosts &= "|" & "page=status_main&button=pptpcdisconnect"
		If $i = 0 Then $AllPosts &= "|" & "page=status_main&button=pptpcconnect"
		If $i = 1 Then $AllPosts &= "|" & "page=status_main&button=pppoedisconnect"
		If $i = 1 Then $AllPosts &= "|" & "page=status_main&button=pppoeconnect"
		Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
		$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
		$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
		$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=
		$return = RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
				$AllHeaders, $AllPosts)
	Next
	Return $return
EndFunc   ;==>RouterReconnectCall_SMC_SMCWBR14_G

Func RouterReconnectCall_TrendNet_TEW_431BRP()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "status.cgi"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "reboot=Restart"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_TrendNet_TEW_431BRP

Func RouterReconnectCall_Keysmart_KDSL_B4WR()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $return = ""
	For $i = 0 To 1
		If $i = 0 Then Local $PerRR_RoutersDefaultCGI = "goform/disconnect"
		If $i = 1 Then Local $PerRR_RoutersDefaultCGI = "goform/connect"
		Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
		Local $PerRR_Method = "POST" ; HTTP method.
		Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
		Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
		Local $AllPosts = "" ; Always send a blank post first for authentication.
		If $i = 0 Then $AllPosts &= "|" & "wan_connect_status=Connected"
		If $i = 1 Then $AllPosts &= "|" & "wan_connect_status=Disconnected"
		Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
		$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
		$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
		$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

		$return = RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
				$AllHeaders, $AllPosts)
	Next
	Return $return
EndFunc   ;==>RouterReconnectCall_Keysmart_KDSL_B4WR

Func RouterReconnectCall_3Com_3CRWE554G72T()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $return = ""
	For $i = 0 To 1
		If $i = 0 Then Local $PerRR_RoutersDefaultCGI = ""
		If $i = 1 Then Local $PerRR_RoutersDefaultCGI = "main/systools_restart.htm"
		Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
		Local $PerRR_Method = "POST" ; HTTP method.
		Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
		Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
		Local $GetEPOCH = _DateDiff('s', "1970/01/01 00:00:00", _NowCalc()) * 1000
		Local $AllPosts = "" ; Always send a blank post first for authentication.
		If $i = 0 Then $AllPosts &= "|" & "page=login&GetTimeVal=" & $GetEPOCH & "&URL=" & $RoutersPass
		If $i = 1 Then $AllPosts &= "|" & "page=systools_restart&press=0"
		Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
		$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
		$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
		$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

		$return = RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
				$AllHeaders, $AllPosts)
	Next
	Return $return
EndFunc   ;==>RouterReconnectCall_3Com_3CRWE554G72T

;curl "http://%USER%:%PWD%@%IP%/lineconn.tri" -d "wanId=1&Submit=Disconnect"

Func RouterReconnectCall_Siemens_Gigaset_SE515()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "lineconn.tri"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "wanId=1&Submit=Disconnect"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_Siemens_Gigaset_SE515

Func RouterReconnectCall_SpeedTouch_780i()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = ""
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "0=13&1=Internet&5=1"
	$AllPosts &= "|" & "0=12&1=Internet&5=1"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_SpeedTouch_780i

;Curl "http://%USER%:%PWD%@%IP%/apply.cgi" -d "submit_button=Status_Router&submit_type=Disconnect_pppoe&change_action=gozila_cgi&wan_proto=pppoe"
;Curl "http://%USER%:%PWD%@%IP%/apply.cgi" -d "submit_button=Status_Router&submit_type=Connect_pppoe&change_action=gozila_cgi&wan_proto=pppoe"
Func RouterReconnectCall_LinkSys_WRT_54GL_v4_30_5()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "apply.cgi"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "submit_button=Status_Router&submit_type=Disconnect_pppoe&change_action=gozila_cgi&wan_proto=pppoe"
	$AllPosts &= "|" & "submit_button=Status_Router&submit_type=Connect_pppoe&change_action=gozila_cgi&wan_proto=pppoe"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_LinkSys_WRT_54GL_v4_30_5

;curl "http://%USER%:%PWD%@%IP%/apply.cgi" -d "submit_button=WanMAC&action=ApplyTake&change_action=&submit_type=&mac_clone_enable=1&def_hwaddr=6&def_hwaddr_0=00&def_hwaddr_1=1A&def_hwaddr_2=92&def_hwaddr_3=2D&def_hwaddr_4=6A&def_hwaddr_5=%time:~3,2%&def_whwaddr=6&def_whwaddr_0=00&def_whwaddr_1=14&def_whwaddr_2=BF&def_whwaddr_3=F7&def_whwaddr_4=69&def_whwaddr_5=D5"
Func RouterReconnectCall_LinkSys_WRT_54XX_DDWRTv24()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "apply.cgi"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "submit_button=WanMAC&action=ApplyTake&change_action=&submit_type=&mac_clone_enable=1&def_hwaddr=6&def_hwaddr_0=00&def_hwaddr_1=1A&def_hwaddr_2=92&def_hwaddr_3=2D&def_hwaddr_4=6A&def_hwaddr_5=%time:~3,2%&def_whwaddr=6&def_whwaddr_0=00&def_whwaddr_1=14&def_whwaddr_2=BF&def_whwaddr_3=F7&def_whwaddr_4=69&def_whwaddr_5=D5"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_LinkSys_WRT_54XX_DDWRTv24

Func RouterReconnectCall_WebShare_440()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "reset/index.html"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "factory=E0"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_WebShare_440

Func RouterReconnectCall_LevelOne_WBR_3407()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "setup.cgi"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & "todo=reboot"
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)
EndFunc   ;==>RouterReconnectCall_LevelOne_WBR_3407


Func RouterReconnectCall_Powernet_Par720g_HPNA3()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $return = ""
	For $i = 0 To 1
		If $i = 0 Then Local $PerRR_RoutersDefaultCGI = "status-welcome-common.html/disconnect"
		If $i = 1 Then Local $PerRR_RoutersDefaultCGI = "status-welcome-common.html/connect"
		Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
		Local $PerRR_Method = "POST" ; HTTP method.
		Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
		Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
		Local $GetEPOCH = _DateDiff('s', "1970/01/01 00:00:00", _NowCalc()) * 1000
		Local $AllPosts = "" ; Always send a blank post first for authentication.
		If $i = 0 Then $AllPosts &= "|" & "EmWeb_ns:vim:3=/status.html&EmWeb_ns:vim:5.ImServices.wanlink.1:enabled=false&EmWeb_ns:vim:19=true"
		If $i = 1 Then $AllPosts &= "|" & "EmWeb_ns:vim:3=/status.html&EmWeb_ns:vim:5.ImServices.wanlink.1:enabled=true&EmWeb_ns:vim:19=true"
		Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
		$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
		$AllHeaders &= "<>" & "Content-Type|text/html; charset=iso-8859-1"
		$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

		$return = RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
				$AllHeaders, $AllPosts)
	Next
	Return $return
EndFunc   ;==>RouterReconnectCall_Powernet_Par720g_HPNA3

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-[TCP - RECONNECTIONs]-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Func RouterReconnectTCP($PerRR_Protocol, $PerRR_Method, $RoutersIP, $PerRR_Page, $RoutersSleep, $AllHeaders, $AllPosts, $Port = 80)
	; Call up TCP variables + defaults:
	TCPStartup()
	$_HTTPRecvBuffer = 1048576
	Dim $RoutersIP = TCPNameToIP($RoutersIP)
	Dim $HTTPsocket = TCPConnect($RoutersIP, $Port)
	If ($HTTPsocket == -1) Then
		__LOG("[***=>ERROR<=***]" & @CRLF & "Coudn't Connect the Router on IP: " & $RoutersIP & "; Script stopped!" & @CRLF & "[***=>ERROR<=*** ]")
		;Exit
	EndIf

	; Count and perform all posts needed.
	$Posts = StringSplit($AllPosts, "|")
	For $i = 1 To $Posts[0]
		; Something for the status...
		If $i = 1 Then SetStatus("Operation Started: Router Reconnection", "connecting router '" & $network & "'")
		If $i = 2 Then SetStatus("Operation Started: Router Reconnection", "sending the disconnecting command'")
		If $i = 3 Then SetStatus("Operation Started: Router Reconnection", "sending the reconnecting command'")

		;Check Ups!
		$EditData = ""
		$EditData &= "[Protocol:" & $PerRR_Protocol & "][IP:" & $RoutersIP & "][Method:" & $PerRR_Method & "]" & @CRLF & _
				"[Headers:" & @CRLF
		$EditData &= $PerRR_Method & " " & $PerRR_Page & " " & $PerRR_Protocol & @CRLF
		$EditData &= "Host: " & $RoutersIP & @CRLF
		$EditData &= "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)" & @CRLF
		$EditData &= "Connection: close" & @CRLF

		;Initiate the send details: [STATICS, should fit for all!]
		$command = $PerRR_Method & " " & $PerRR_Page & " " & $PerRR_Protocol & @CRLF
		$command &= "Host: " & $RoutersIP & @CRLF
		$command &= "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)" & @CRLF
		$command &= "Connection: close" & @CRLF

		;Stack headers to the send.
		$Headers = StringSplit($AllHeaders, "<>", 1) ; $AllHeaders = Title|Content<>Title|Content
		For $i2 = 1 To $Headers[0]
			If $Headers[$i2] <> "" Then
				$HeaderParsed = StringSplit($Headers[$i2], "|")
				If @error = 1 Then ContinueLoop
				$command &= $HeaderParsed[1] & ": " & $HeaderParsed[2] & @CRLF
				$EditData &= $HeaderParsed[1] & ": " & $HeaderParsed[2] & @CRLF
			EndIf
		Next
		$command &= "Content-Length: " & StringLen($Posts[$i]) & @CRLF

		;Debugging all headers: ['Header: Content']
		$EditData &= "/Headers]" & @CRLF
		$EditData &= "" & @CRLF
		$EditData &= "[Data.:" & $Posts[$i] & "/]" & @CRLF

		;Data To send: [An empty line followed by the data.]
		$command &= "" & @CRLF
		$command &= $Posts[$i] & @CRLF

		__LOG($EditData & @CRLF & "____________________________________________________________________" & @CRLF)
		; Sending Data to socket.
		Dim $bytessent = TCPSend($HTTPsocket, $command)
		If $bytessent == 0 Then __LOG("[***=>ERROR<=***]" & @CRLF & "Failed to send data to the router :(" & @CRLF & "[***=>ERROR<=*** ]")

		; Wating to recieve Data from socket.
		Dim $HTTPrecv = ""
		While 1
			Sleep(100)
			$HTTPrecv &= TCPRecv($HTTPsocket, $_HTTPRecvBuffer)
			If @error <> 0 Then
				$HTTPrecv &= @CRLF & "Finished Recieving from server!"
				ExitLoop
			EndIf
		WEnd
		__LOG($HTTPrecv & @CRLF & "____________________________________________________________________" & @CRLF)

		SetStatus("Operation Started: Router Reconnection", "done!'")
		If $i = 1 Then
			Sleeper(5, "Operation Started: Router Reconnection")
			ContinueLoop
		EndIf
		If $i = $Posts[0] And $Posts[0] > 2 Then ExitLoop
		__LOG("Sleeping: " & $RoutersSleep & " Secs" & @CRLF & "____________________________________________________________________" & @CRLF)
		Sleeper($RoutersSleep / 1000, "Operation Started: Router Reconnection")
	Next

	TCPShutdown()
	Return "Router Reconnection"
EndFunc   ;==>RouterReconnectTCP

Func RouterReconnectCall_AVM_FRITZBox_Fon_SEVERALROUTERS()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_Protocol = "HTTP/1.1"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $PerRR_RouterIP = $RoutersIP
	Local $PerRR_Page = "/upnp/control/WANIPConn1"
	Local $PerRR_Port = 49000
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	$AllPosts &= "|" & _
			'<?xml version="1.0" encoding="utf-8"?>' & @CRLF & _
			'<s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">' & @CRLF & _
			'<s:Body>' & @CRLF & _
			'<u:ForceTermination xmlns:u="urn:schemas-upnp-org:service:WANIPConnection:1" />' & @CRLF & _
			'</s:Body>' & @CRLF & _
			'</s:Envelope>'
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "SOAPACTION|urn:schemas-upnp-org:service:WANIPConnection:1#ForceTermination" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & 'CONTENT-TYPE|text/xml ; charset="utf-8"'
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=

	Return RouterReconnectTCP($PerRR_Protocol, $PerRR_Method, $RoutersIP, $PerRR_Page, $RoutersSleep, _
			$AllHeaders, $AllPosts, $PerRR_Port)
EndFunc   ;==>RouterReconnectCall_AVM_FRITZBox_Fon_SEVERALROUTERS

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-[TELNET - RECONNECTIONs]-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Func RouterReconnectTelnet($RoutersIP, $RoutersAdmin, $RoutersPass, $LoginRequired, $RoutersProtocol, $PerRR_StoreKey, _
		$PerRR_Login, $PerRR_Password, $PerRR_InputSignal, $PerRR_InputSignal2, $RoutersCMD, $RoutersCMD2, $PerRR_TerminatingSignal, _
		$PerRR_TerminatingSignal2, $RoutersSleep)

	SetStatus("Operation Started: Router Reconnection", "connecting router '" & $network & "'")
	;Load Indicating Variables.
	$PassAndUserDone = 0
	$ScriptIsDone = 0
	$SentRouterCMD = 0
	$SentRouterCMD2 = 0
	If $LoginRequired = 0 Then $PassAndUserDone = 1
	If $RoutersCMD2 = "" Then $SentRouterCMD2 = 1 ; if we don't have a 2nd send, mark it as done!
	Local $AutoExitTimer = 0

	; Run child process and provide console i/o for it.
	; Parameter of 2 = provide standard output
	__LOG("Running: " & @ScriptDir & "\plink.exe " & $RoutersProtocol & " " & $RoutersIP & @CRLF)
	$ourProcess = Run("plink.exe " & $RoutersProtocol & " " & $RoutersIP, @ScriptDir, @SW_HIDE, 3)
	; Loop and update the edit control unitl we hit EOF (and get an error)
	While 1

		If $PassAndUserDone = 1 And $SentRouterCMD = 1 And $SentRouterCMD2 = 1 Then $AutoExitTimer = TimerInit()

		If $ScriptIsDone = 1 Then
			Sleeper($RoutersSleep / 1000, "Operation Started: Router Reconnection")
			__LOG("Script should be done, Closing child!")
			ProcessClose($ourProcess)
		EndIf

		If ProcessExists($ourProcess) <> 0 Then
			SetStatus("Operation Started: Router Reconnection", "done!")
			; Calling StdoutRead like this returns the characters waiting to be read
			$charsWaiting = StdoutRead($ourProcess, 1)
			If @error <> 0 Then
				$ourProcess = 0
				__LOG("Failed to read the data from the process!!!")
				ExitLoop
			EndIf
			If $charsWaiting <> "" Then
				__LOG("Data retrieved from process: ")
				$currentRead = StdoutRead($ourProcess, 1)
				__LOG(@CRLF & "[LOG:" & @CRLF & $currentRead & @CRLF & "]" & @CRLF)
				__LOG(@CRLF & "[Details:" & @CRLF & "$PassAndUserDone=" & $PassAndUserDone & "| $SentRouterCMD=" & $SentRouterCMD & "| $SentRouterCMD2=" & $SentRouterCMD2 & "| $ScriptIsDone=" & $ScriptIsDone & @CRLF & "]" & @CRLF)
				;MsgBox(0, "", $currentRead)
				If StringInStr($currentRead, $PerRR_StoreKey) <> 0 Then
					__LOG(@CRLF & "[PROC:" & @CRLF & "Found Store key in cache question!" & @CRLF & "]")
					StdinWrite($ourProcess, "y" & @CRLF)
					__LOG(@CRLF & "[PROC:" & @CRLF & "Tried choosing yes" & @CRLF & "]")

				ElseIf StringInStr($currentRead, $PerRR_Login) <> 0 Then
					__LOG(@CRLF & "[PROC:" & @CRLF & "Found Login message - tring to log in!" & @CRLF & "]")
					StdinWrite($ourProcess, $RoutersAdmin & @CRLF)
					__LOG(@CRLF & "[PROC:" & @CRLF & "Tried inputting the username: " & $RoutersAdmin & @CRLF & "]")

				ElseIf StringInStr($currentRead, $PerRR_Password) <> 0 Then
					__LOG(@CRLF & "[PROC:" & @CRLF & "Found Password message - tring to input!" & @CRLF & "]")
					StdinWrite($ourProcess, $RoutersPass & @CRLF)
					__LOG(@CRLF & "[PROC:" & @CRLF & "Tried inputting the Password: " & $RoutersPass & @CRLF & "]")
					$PassAndUserDone = 1

				ElseIf StringInStr($currentRead, $PerRR_InputSignal) <> 0 Or StringInStr($currentRead, $PerRR_InputSignal2) <> 0 _
						And $PassAndUserDone = 1 And $SentRouterCMD = 0 Then
					SetStatus("Operation Started: Router Reconnection", "sending the disconnecting command'")
					__LOG(@CRLF & "[PROC:" & @CRLF & "Found '" & $PerRR_InputSignal & "' input code signal!" & @CRLF & "]")
					Sleep(250)
					__LOG(@CRLF & "[PROC:" & @CRLF & "Trying Sending the reconnecting Command: " & $RoutersCMD & @CRLF & "]")
					StdinWrite($ourProcess, $RoutersCMD & @CRLF)
					__LOG(@CRLF & "[PROC:" & @CRLF & "Waiting for exiting signal ..." & @CRLF & "]")
					$SentRouterCMD = 1

				ElseIf (StringInStr($currentRead, $PerRR_InputSignal) <> 0 Or StringInStr($currentRead, $PerRR_InputSignal2) <> 0) _
						And ($PassAndUserDone = 1 And $SentRouterCMD = 1 And $SentRouterCMD2 = 0) Then
					SetStatus("Operation Started: Router Reconnection", "sending the reconnecting command'")
					__LOG(@CRLF & "[PROC:" & @CRLF & "Found '" & $PerRR_InputSignal & "' input code signal!" & @CRLF & "]")
					Sleep(250)
					__LOG(@CRLF & "[PROC:" & @CRLF & "Trying Sending the second reconnecting Command: " & $RoutersCMD2 & @CRLF & "]")
					StdinWrite($ourProcess, $RoutersCMD2 & @CRLF)
					__LOG(@CRLF & "[PROC:" & @CRLF & "Waiting for exiting signal ..." & @CRLF & "]")
					$SentRouterCMD2 = 1

				ElseIf StringInStr($currentRead, $PerRR_TerminatingSignal) <> 0 Or StringInStr($currentRead, $PerRR_TerminatingSignal2) <> 0 _
						And $PassAndUserDone = 1 And $SentRouterCMD = 1 And $SentRouterCMD2 = 1 Then
					__LOG(@CRLF & "[PROC:" & @CRLF & "Found '" & $PerRR_TerminatingSignal & "' exiting signal!" & @CRLF & "]")
					__LOG(@CRLF & "[PROC:" & @CRLF & "Setting the script for closure in 15 seconds ..." & @CRLF & "]")
					$ScriptIsDone = 1

				ElseIf $PerRR_TerminatingSignal = "" And $PerRR_TerminatingSignal2 = "" And $PassAndUserDone = 1 And $SentRouterCMD = 1 _
						And $SentRouterCMD2 = 1 Then
					__LOG(@CRLF & "[PROC:" & @CRLF & "There is no exit singal!!!" & @CRLF & "]")
					__LOG(@CRLF & "[PROC:" & @CRLF & "Setting the script for closure in 15 seconds ..." & @CRLF & "]")
					$ScriptIsDone = 1

				EndIf
			EndIf
		Else
			__LOG(@CRLF & "[PROC:" & @CRLF & "Script Process was terminated, Exiting!" & @CRLF & "]")
			ExitLoop
		EndIf

		If TimerDiff($AutoExitTimer) > 15000 Then $ScriptIsDone = 1
	WEnd

	Return "Router Reconnection"
EndFunc   ;==>RouterReconnectTelnet

Func RouterReconnectCall_Rotal_RTA1025W()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep

	If $RoutersAdmin = "" And $RoutersPass = "" Then
		Local $LoginRequired = 0
	Else
		Local $LoginRequired = 1
	EndIf
	;-----------------------
	Local $RoutersProtocol = "-telnet"
	Local $StoreKey = "Store key"
	Local $login = "Login"
	Local $password = "Password"
	Local $InputSignal = ">" ; put both the same if the second doesn't exists!
	Local $InputSignal2 = ">" ; -> OR <-
	Local $CMD = "reboot"
	Local $CMD2 = "" ;Blank won't be used at all! ; -> Skip if Blank <-
	Local $TerminatingSignal = "Total" ; put both the same, Blank will Skip Waiting For Terminal String.
	Local $TerminatingSignal2 = "Total" ; -> OR <-

	Return RouterReconnectTelnet($RoutersIP, $RoutersAdmin, $RoutersPass, $LoginRequired, $RoutersProtocol, $StoreKey, _
			$login, $password, $InputSignal, $InputSignal2, $CMD, $CMD2, $TerminatingSignal, $TerminatingSignal2, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_Rotal_RTA1025W

Func RouterReconnectCall_Beetel_220BX()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep

	If $RoutersAdmin = "" And $RoutersPass = "" Then
		Local $LoginRequired = 0
	Else
		Local $LoginRequired = 1
	EndIf
	;-----------------------
	Local $RoutersProtocol = "-telnet"
	Local $StoreKey = "Store key"
	Local $login = "Login:"
	Local $password = "Password:"
	Local $InputSignal = "->" ; put both the same if the second doesn't exists!
	Local $InputSignal2 = "#" ; -> OR <-
	Local $CMD = "sh"
	Local $CMD2 = "reboot" ;Blank won't be used at all! ; -> Skip if Blank <-
	Local $TerminatingSignal = "" ; put both the same, Blank will Skip Waiting For Terminal String.
	Local $TerminatingSignal2 = "Connection to host lost" ; -> OR <-

	Return RouterReconnectTelnet($RoutersIP, $RoutersAdmin, $RoutersPass, $LoginRequired, $RoutersProtocol, $StoreKey, _
			$login, $password, $InputSignal, $InputSignal2, $CMD, $CMD2, $TerminatingSignal, $TerminatingSignal2, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_Beetel_220BX


Func RouterReconnectCall_BFocus_270pr()
	Return RouterReconnectCall_BFocus_352()
EndFunc   ;==>RouterReconnectCall_BFocus_270pr
Func RouterReconnectCall_BFocus_312()
	Return RouterReconnectCall_BFocus_352()
EndFunc   ;==>RouterReconnectCall_BFocus_312
Func RouterReconnectCall_BFocus_352()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep

	If $RoutersAdmin = "" And $RoutersPass = "" Then
		Local $LoginRequired = 0
	Else
		Local $LoginRequired = 1
	EndIf
	;-----------------------
	Local $RoutersProtocol = "-telnet"
	Local $StoreKey = "Store key"
	Local $login = "login"
	Local $password = "Password"
	Local $InputSignal = "$" ; put both the same if the second doesn't exists!
	Local $InputSignal2 = "#" ; -> OR <-
	Local $CMD = "reboot"
	Local $CMD2 = "" ;Blank won't be used at all! ; -> Skip if Blank <-
	Local $TerminatingSignal = "" ; put both the same, Blank will Skip Waiting For Terminal String.
	Local $TerminatingSignal2 = "" ; -> OR <-

	Return RouterReconnectTelnet($RoutersIP, $RoutersAdmin, $RoutersPass, $LoginRequired, $RoutersProtocol, $StoreKey, _
			$login, $password, $InputSignal, $InputSignal2, $CMD, $CMD2, $TerminatingSignal, $TerminatingSignal2, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_BFocus_352

Func RouterReconnectCall_Huawei_Aolynk_DR814()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep

	If $RoutersAdmin = "" And $RoutersPass = "" Then
		Local $LoginRequired = 0
	Else
		Local $LoginRequired = 1
	EndIf
	;-----------------------
	Local $RoutersProtocol = "-telnet"
	Local $StoreKey = "Store key"
	Local $login = "Login:"
	Local $password = "Password:"
	Local $InputSignal = "-->" ; put both the same if the second doesn't exists!
	Local $InputSignal2 = "-->" ; -> OR <-
	Local $CMD = "pppoe set transport 1 disabled"
	Local $CMD2 = "pppoe set transport 1 enable" ;Blank won't be used at all! ; -> Skip if Blank <-
	Local $TerminatingSignal = "-->" ; put both the same, Blank will Skip Waiting For Terminal String.
	Local $TerminatingSignal2 = "-->" ; -> OR <-

	Return RouterReconnectTelnet($RoutersIP, $RoutersAdmin, $RoutersPass, $LoginRequired, $RoutersProtocol, $StoreKey, _
			$login, $password, $InputSignal, $InputSignal2, $CMD, $CMD2, $TerminatingSignal, $TerminatingSignal2, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_Huawei_Aolynk_DR814

Func RouterReconnectCall_SendTek_PAR720G()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	Local $RouterAction = $Router_action

	If $RoutersAdmin = "" And $RoutersPass = "" Then
		Local $LoginRequired = 0
	Else
		Local $LoginRequired = 1
	EndIf
	;-----------------------
	Local $RoutersProtocol = "-telnet"
	Local $StoreKey = "Store key"
	Local $login = "Login:"
	Local $password = "Password:"
	Local $InputSignal = "Admin>" ; put both the same if the second doesn't exists!
	Local $InputSignal2 = "Admin>" ; -> OR <-
	If $RouterAction = 0 Then
		Local $CMD = "ip detach ipwan"
		Local $CMD2 = "ip attach ipwan wanlink" ;Blank won't be used at all! ; -> Skip if Blank <-
	Else
		Local $CMD = "system restart"
		Local $CMD2 = "" ;Blank won't be used at all! ; -> Skip if Blank <-
	EndIf
	Local $TerminatingSignal = "" ; put both the same, Blank will Skip Waiting For Terminal String.
	Local $TerminatingSignal2 = "Admin>" ; -> OR <-

	Return RouterReconnectTelnet($RoutersIP, $RoutersAdmin, $RoutersPass, $LoginRequired, $RoutersProtocol, $StoreKey, _
			$login, $password, $InputSignal, $InputSignal2, $CMD, $CMD2, $TerminatingSignal, $TerminatingSignal2, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_SendTek_PAR720G

Func RouterReconnectCall_Siemens_2141IS()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep

	If $RoutersAdmin = "" And $RoutersPass = "" Then
		Local $LoginRequired = 0
	Else
		Local $LoginRequired = 1
	EndIf
	;-----------------------
	Local $RoutersProtocol = "-telnet"
	Local $StoreKey = "Store key"
	Local $login = "Login name:"
	Local $password = "Password:"
	Local $InputSignal = ">" ; put both the same if the second doesn't exists!
	Local $InputSignal2 = ">" ; -> OR <-
	Local $CMD = "reboot"
	Local $CMD2 = "" ;Blank won't be used at all! ; -> Skip if Blank <-
	Local $TerminatingSignal = "Total" ; put both the same, Blank will Skip Waiting For Terminal String.
	Local $TerminatingSignal2 = "Total" ; -> OR <-

	Return RouterReconnectTelnet($RoutersIP, $RoutersAdmin, $RoutersPass, $LoginRequired, $RoutersProtocol, $StoreKey, _
			$login, $password, $InputSignal, $InputSignal2, $CMD, $CMD2, $TerminatingSignal, $TerminatingSignal2, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_Siemens_2141IS

Func RouterReconnectCall_SpeedTouch_536()
	Return RouterReconnectCall_SpeedTouch_570()
EndFunc   ;==>RouterReconnectCall_SpeedTouch_536
Func RouterReconnectCall_SpeedTouch_570()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep

	If $RoutersAdmin = "" And $RoutersPass = "" Then
		Local $LoginRequired = 0
	Else
		Local $LoginRequired = 1
	EndIf
	;-----------------------
	Local $RoutersProtocol = "-telnet"
	Local $StoreKey = "Store key"
	Local $login = "Username"
	Local $password = "Password"
	Local $InputSignal = "=>" ; put both the same if the second doesn't exists!
	Local $InputSignal2 = "=>" ; -> OR <-
	Local $CMD = "system reboot"
	Local $CMD2 = "" ;Blank won't be used at all! ; -> Skip if Blank <-
	Local $TerminatingSignal = "" ; put both the same, Blank will Skip Waiting For Terminal String.
	Local $TerminatingSignal2 = "" ; -> OR <-

	Return RouterReconnectTelnet($RoutersIP, $RoutersAdmin, $RoutersPass, $LoginRequired, $RoutersProtocol, $StoreKey, _
			$login, $password, $InputSignal, $InputSignal2, $CMD, $CMD2, $TerminatingSignal, $TerminatingSignal2, $RoutersSleep)
EndFunc   ;==>RouterReconnectCall_SpeedTouch_570

Func __LOG($text)
	ConsoleWrite($text & @CRLF)
	If $UseLogFile = 0 Then Return

	$html_fileH = FileOpen(@ScriptDir & "\" & @ScriptName & ".Router.Log", 9)
	FileWrite($html_fileH, @MDAY & "-" & @MON & "-" & @YEAR & " " & @HOUR & ":" & @MIN & @TAB & $text & @CRLF)
	FileClose($html_fileH)
EndFunc   ;==>__LOG
Func MyErrFunc() ;Error Handler - so that users won't see the autoit errors...
	$HexNumber = Hex($oMyError.number, 8)
	If $HexNumber = 80020009 Then
		__LOG("No Reply From OBJ, ERR: 80020009")
	Else
		__LOG("###  We intercepted a COM Error :" & $HexNumber & @CRLF & @CRLF & _
				"err.description is: " & @TAB & $oMyError.description & @CRLF & _
				"err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
				"err.number is: " & @TAB & Hex($oMyError.number, 8) & @CRLF & _
				"err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
				"err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
				"err.source is: " & @TAB & $oMyError.source & @CRLF & _
				"err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
				"err.helpcontext is: " & @TAB & $oMyError.helpcontext & @CRLF _
				)
	EndIf
EndFunc   ;==>MyErrFunc
Func OnExitFunction()
	If ProcessExists("plink.exe") <> 0 Then ProcessClose("plink.exe")
EndFunc   ;==>OnExitFunction

;#CS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ NOT CHECKED YET!!!

Func RouterReconnectCall_Aztech_DSL_600E()
	Local $RoutersIP = $connection
	Local $RoutersAdmin = $login
	Local $RoutersPass = $password
	Local $RoutersSleep = $Sleep
	;-----------------------
	Local $PerRR_RoutersDefaultCGI = "cgi-bin/webcm?getpage=../html/defs/style1/menus/menu1.html"
	Local $PerRR_OBJ = "MSXML2.ServerXMLHTTP"
	Local $PerRR_Method = "POST" ; HTTP method.
	Local $RoutersIPFormed = "http://" & $RoutersAdmin & ":" & $RoutersPass & "@" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI
	Local $RoutersAdminAndPassEncoded = _Base64Encode($RoutersAdmin & ":" & $RoutersPass, False)
	Local $AllPosts = "" ; Always send a blank post first for authentication.
	Local $AllHeaders = "User-Agent|Mozilla/4.0 (compatible; MSIE 5.00; Windows 98)" ;Should Be First !!!
	$AllHeaders &= "<>" & "Cache-Control|no-cache" ;Cache-Control|no-cache
	$AllHeaders &= "<>" & "Content-Type|application/x-www-form-urlencoded"
	$AllHeaders &= "<>" & "Authorization|Basic " & $RoutersAdminAndPassEncoded ;Should Be Last !!! Authorization|Basic YWRtaW46cGFzc3dvcmQ=
	$return = RouterReconnectHTTP($PerRR_OBJ, $PerRR_Method, $RoutersIPFormed, $RoutersAdminAndPassEncoded, $RoutersSleep, _
			$AllHeaders, $AllPosts)

	SetStatus("Operation Started: Router Reconnection", "sending the disconnecting command'")
	$oMyError = 0
	_IEErrorHandlerRegister()
	$oIE = _IECreateEmbedded()
	$GUIActiveX = GUICtrlCreateObj($oIE, -100, -100, 1, 1)
	GUICtrlSetState($GUIActiveX, @SW_HIDE)
	_IENavigate($oIE, "http://" & $RoutersIP & "/" & $PerRR_RoutersDefaultCGI)
	$oIEDoc = _IEDocGetObj($oIE)
	$oIEDoc.parentWindow.execScript("Javascript:doDisconnect('connection0','pppoa')", 0)

	__LOG("Sleeping: " & $RoutersSleep & " Secs" & @CRLF)
	Sleeper($RoutersSleep / 1000, "Operation Started: Router Reconnection")

	SetStatus("Operation Started: Router Reconnection", "sending the reconnecting command'")
	$oIEDoc.parentWindow.execScript("Javascript:doConnect('connection0','pppoa')", 0)

	__LOG("Sleeping: " & 5 & " Secs" & @CRLF & "____________________________________________________________________" & @CRLF)
	Sleeper(5, "Operation Started: Router Reconnection")
	_IEQuit($oIE)
	GUICtrlDelete($GUIActiveX)
	_IEErrorHandlerDeRegister()
	$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")

	Return $return
EndFunc   ;==>RouterReconnectCall_Aztech_DSL_600E
;#CE;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ NOT CHECKED YET/


;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-[GARBAGE BIN!]-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#cs
	-->                                                                            


#ce
