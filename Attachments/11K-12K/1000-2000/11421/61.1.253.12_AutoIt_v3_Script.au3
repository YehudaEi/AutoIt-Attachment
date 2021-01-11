#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.1.1.0
	Author: Rakesh Gopalan        myName
	
	Script Function:TO CONNECT TO ONLY ONE DIALUP SERVER AMONG THREE ,IE FROM 61.1.253.1,61.1.253.5 AND 61.1.253.12 I WANT TO CONNECT ONLY TO 61.1.253.12.
	
	HOW TO DO THAT,PLEASE ?
	Template AutoIt script.
	
#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
; Place at the top of your script
$g_szVersion = "My Script 1.1"
If WinExists($g_szVersion) Then Exit ; It's already running
AutoItWinSetTitle($g_szVersion)

HotKeySet("^!x", "MyExit")
#include <Array.au3>

Dim $avArray
Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)
Opt("OnExitFunc", "endscript")
;MsgBox(0,"","first statement")
For $i=1 To 10

;~ Const $scUserAgent = "WinInet Example"
;~ $INTERNET_OPEN_TYPE_PRECONFIG = 0x0
;~ $aiInternetAttemptConnect=DllCall("WinInet.dll","int","InternetAttemptConnect","int",0)
;~ If $aiInternetAttemptConnect[0] <> 0 Then Exit
;~ $aiInternetOpen=DllCall("WinInet.dll","int","InternetOpen","str","$scUserAgent","int",$INTERNET_OPEN_TYPE_PRECONFIG,"str","","str","","int",0)
;~ $isConnectToISP=($aiInternetOpen[0]=0)
;~ If $aiInternetOpen[0]=0 Then
;~ 	$isConnectToISP=False
;~ 	MsgBox(4096,"FALSEisConnecttoISP","FALSE")
;~ Else
;~ 	$isConnectToISP=True
;~ 	MsgBox(4096,"isConnecttoISP","true")
;~ EndIf
	Run("rasphone.exe -d gate")
	WinWait("classname=#32770","&Save Password")
	If Not WinActive("classname=#32770","&Save Password") Then WinActivate("classname=#32770","&Save Password")
	WinWaitActive("classname=#32770","&Save Password")
	ControlFocus("classname=#32770","&Save Password",1590)
	ControlClick("classname=#32770","&Save Password",1590)
	Run("rasphone.exe -s")
	WinWait("classname=#32770","Connection statistic")
	If Not WinActive("classname=#32770","Connection statistic") Then WinActivate("classname=#32770","Connection statistic")
	WinWaitActive("classname=#32770","Connection statistic")
	;--------------------------------------------------------------------------------------------
	;check $ret[0] for trueness, and $ret[1] for type of connection according to variables provided...
	;--------------------------------------------------------------------------------------------

	$INTERNET_CONNECTION_MODEM          = 0x1
	$INTERNET_CONNECTION_LAN            = 0x2
	$INTERNET_CONNECTION_PROXY          = 0x4
	$INTERNET_CONNECTION_MODEM_BUSY     = 0x8
	$INTERNET_RAS_INSTALLED             = 0x10
	$INTERNET_CONNECTION_OFFLINE        = 0x20
	$INTERNET_CONNECTION_CONFIGURED     = 0x40
	Do
		$ret = DllCall("WinInet.dll","int","InternetGetConnectedState","int_ptr",0,"int",0)
		$isconnect = ($ret[0] <> 0)

		If $ret[0] then
			;check type of connection
			$sX = ""
			If BitAND($ret[1], $INTERNET_CONNECTION_MODEM)      Then $sX = $sX & "MODEM" & @LF
			If BitAND($ret[1], $INTERNET_CONNECTION_LAN)        Then $sX = $sX & "LAN" & @LF
			If BitAND($ret[1], $INTERNET_CONNECTION_PROXY)      Then $sX = $sX & "PROXY" & @LF
			If BitAND($ret[1], $INTERNET_CONNECTION_MODEM_BUSY) Then $sX = $sX & "MODEM_BUSY" & @LF
			If BitAND($ret[1], $INTERNET_RAS_INSTALLED)         Then $sX = $sX & "RAS_INSTALLED" & @LF
			If BitAND($ret[1], $INTERNET_CONNECTION_OFFLINE)    Then $sX = $sX & "OFFLINE" & @LF
			If BitAND($ret[1], $INTERNET_CONNECTION_CONFIGURED) Then $sX = $sX & "CONFIGURED" & @LF
		Else
			$sX = "Not Connected"
		Endif
	Until $isconnect=True
;~ MsgBox(4096,$ret[0] & ":" & $ret[1],$sX,2)
	$enabledetails=ControlCommand("classname=#32770","Connection statistic","Button5","IsEnabled", "")
;~ MsgBox(4096,"Is Details enabled ?",$enabledetails,2)
	If $enabledetails Then
		ControlFocus("classname=#32770","Connection statistic",1190)
		ControlClick("classname=#32770","Connection statistic",1190)
		WinWait("classname=#32770","Network Registration")
		If Not WinActive("classname=#32770","Network Registration") Then WinActivate("classname=#32770","Network Registration")
		WinWaitActive("classname=#32770","Network Registration")
		$enabledialupserver=ControlCommand("classname=#32770","Network Registration","Static7","IsVisible", "")
		If $enabledialupserver Then
			$var = ControlGetText("classname=#32770", "Network Registration", "Static7")
			$array = StringSplit($var, '.')
			$avArray = _ArrayCreate($array[1], $array[2], $array[3], $array[4])
			_ArrayDisplay( $avArray, "Array created with _ArrayCreate" )
			Dim $sArrayString = _ArrayToString( $avArray,@TAB)
			MsgBox( 4096, "_ArrayToString() Test", $sArrayString )
			$text = StringStripWS($sArrayString,8)
			MsgBox(0, "All spaces stripped", $text)
			$z1 = Number($text)
			
			MsgBox(0,"The final number form we required",$z1)
			
			$notdesiredserver = ($z1 <> 61125312)
			MsgBox(0,"We check for notdesiredserver",$notdesiredserver)
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			;HERE IS THE PROBLEM PART.$notdesiredserver ALWAYS RETURNS TRUE.PEASEADVCE ME ON A BETTER WAY FO CODING THIS.
			
			
			If  $notdesiredserver = False Then endscript()
            
			;WHAT IS THE PROBLEM WITH THIS STATEMENT?

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


			MsgBox(4096,"Your dial up server is",$var,1)
			Run("rasphone.exe -h gate")
			$list = ProcessList("rasphone.exe")
			For $j = 1 to $list[0][0]
				ProcessClose($list[$j][0])
			Next
			If ProcessExists("rasphone.exe") Then
				ProcessWaitClose("rasphone.exe")
			EndIf

		EndIf


	EndIf
Next
Msgbox(4096,"THE BSNL","Won't allow me to connect to 61.1.253.12")
Func endscript()
	MsgBox(0,"","after last statement " & @EXITMETHOD)
EndFunc

Func MyExit()
	Exit
EndFunc