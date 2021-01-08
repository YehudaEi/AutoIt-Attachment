#include <GUIConstants.au3>
#include <Constants.au3>
#NoTrayIcon

; Check for program already running
$g_szVersion = "ClientNet 1.12"
If WinExists($g_szVersion) Then Exit ; It's already running
AutoItWinSetTitle($g_szVersion)
Opt("GUIResizeMode", $GUI_DOCKAUTO)
Opt("GUICloseOnESC", 0)
If @OSTYPE <> "WIN32_NT" Then
	MsgBox(0, "Invalid Operating System", "This program requires WIndows 2000 or later to run.")
	Exit
	EndIf

Dim $ClientWeb, $ReleaseError
Dim $INIfile = @ScriptDir & "\clnetutil.ini"
If FileExists($INIfile) Then
$ClientWeb = IniRead ($INIfile, "WEBSITE", "web", "" )
EndIf
; == GUI generated with Koda ==
$Form1 = GUICreate("Client Network Utility", 580, 330, -1, -1, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)


Dim $utilitymenu = GUICtrlCreateMenu ("&Network Utility")
	Dim $traceitem = GUICtrlCreateMenuitem ("Trace Route",$utilitymenu)
		GUICtrlSetState(-1,$GUI_DEFBUTTON)
		If Not $ClientWeb Then
			GUICtrlSetState($traceitem,$GUI_DISABLE)
		EndIf
		
	Dim $space1 = GUICtrlCreateMenuitem ("",$utilitymenu)	
	Dim $repairitem = GUICtrlCreateMenuitem ("Repair Connection",$utilitymenu)
	Dim $recyitem = GUICtrlCreateMenuitem ("Release/Renew",$utilitymenu)
	Dim $relitem = GUICtrlCreateMenuitem ("Release Network",$utilitymenu)
	Dim $renitem = GUICtrlCreateMenuitem ("Renew Network",$utilitymenu)
	
Dim $setmenu = GUICtrlCreateMenu("Settings")  
	Dim $timemenu = GUICtrlCreateMenu("Time Out", $setmenu, 1) 
	Dim $timeitem1 = GUICtrlCreateMenuitem ("3 Seconds",$timemenu)
	Dim $timeitem2 = GUICtrlCreateMenuitem ("4 Seconds",$timemenu)
	Dim $timeitem3 = GUICtrlCreateMenuitem ("5 Seconds",$timemenu)
		GUICtrlSetState($timeitem1,$GUI_CHECKED)
	Dim $pingmenu = GUICtrlCreateMenu("Host Tests", $setmenu, 1) 
	Dim $pingitem[11][3]
	$pingitem[1][1] = GUICtrlCreateMenuitem ("www.google.com",$pingmenu)
	$pingitem[1][2] = "www.google.com"
	$pingitem[2][1] = GUICtrlCreateMenuitem ("www.yahoo.com",$pingmenu)
	$pingitem[2][2] = "www.yahoo.com"
	$pingitem[3][1] = GUICtrlCreateMenuitem ("www.rr.com",$pingmenu)
	$pingitem[3][2] = "www.rr.com"
	$pingitem[4][1] = GUICtrlCreateMenuitem ("www.comcast.net",$pingmenu)
	$pingitem[4][2] = "www.comcast.net"
	$pingitem[5][1] = GUICtrlCreateMenuitem ("www.charter.net",$pingmenu)
	$pingitem[5][2] = "www.charter.net"
	$pingitem[6][1] = GUICtrlCreateMenuitem ("www.verizon.net",$pingmenu)
	$pingitem[6][2] = "www.verizon.net"
	$pingitem[7][1] = GUICtrlCreateMenuitem ("www.cox.net",$pingmenu)
	$pingitem[7][2] = "www.cox.net"
	$pingitem[8][1] = GUICtrlCreateMenuitem ("www.Level3.net",$pingmenu)
	$pingitem[8][2] = "www.Level3.net"
	$pingitem[9][1] = GUICtrlCreateMenuitem ("www.sprint.com",$pingmenu)
	$pingitem[9][2] = "www.sprint.com"
	$pingitem[10][1] = GUICtrlCreateMenuitem ("www.adelphia.net",$pingmenu)
	$pingitem[10][2] = "www.adelphia.net"
		GUICtrlSetState($pingitem[1][1],$GUI_CHECKED)
		GUICtrlSetState($pingitem[2][1],$GUI_CHECKED)		
	Dim $webmenu = GUICtrlCreateMenuItem("Client Web Site", $setmenu)	

Dim $infomenu = GUICtrlCreateMenu("Information",-1,1) 
	Dim $sysitem = GUICtrlCreateMenuitem ("System Information",$infomenu)
	Dim $netitem = GUICtrlCreateMenuitem ("Network Information",$infomenu)

Dim $copymenu = GUICtrlCreateMenu ("Window")
	Dim $clearitem = GUICtrlCreateMenuitem ("Clear Output",$copymenu)
	Dim $copyitem = GUICtrlCreateMenuitem ("Copy Window to Clipboard",$copymenu)
	
Dim $helpmenu = GUICtrlCreateMenu ("Help")
	Dim $instrhelp = GUICtrlCreateMenuitem ("Network Utility Instructions",$helpmenu)
	Dim $testhelp = GUICtrlCreateMenuitem ("Test Connection Help",$helpmenu)
	Dim $tracehelp = GUICtrlCreateMenuitem ("Network Utility - Trace Route",$helpmenu)
	Dim $repairhelp = GUICtrlCreateMenuitem ("Network Utility - Repair Connection",$helpmenu)
	Dim $recyhelp = GUICtrlCreateMenuitem ("Network Utility - Release/Renew",$helpmenu)
	Dim $relhelp = GUICtrlCreateMenuitem ("Network Utility - Release Network",$helpmenu)
	Dim $renhelp = GUICtrlCreateMenuitem ("Network Utility - Renew Network",$helpmenu)
	Dim $syshelp = GUICtrlCreateMenuitem ("Information - System Information",$helpmenu)
	Dim $nethelp = GUICtrlCreateMenuitem ("Information - Network Information",$helpmenu)
	Dim $tohelp = GUICtrlCreateMenuitem ("Settings - Time Out",$helpmenu)
	Dim $hosthelp = GUICtrlCreateMenuitem ("Settings - Host Tests",$helpmenu)
	Dim $wshelp = GUICtrlCreateMenuitem ("Settings - Client Web Site",$helpmenu)
	Dim $abouthelp = GUICtrlCreateMenuitem ("About Network Utility",$helpmenu)

$Edit1 = GUICtrlCreateEdit("", 20, 20, 540, 235, $ES_READONLY + $WS_VSCROLL, $WS_EX_CLIENTEDGE)
GUICtrlSetFont ($Edit1,9, 400, 0, "Lucida Console")
_CLS()
GuiCtrlSetBkColor($Edit1,0xf5f5f5)
GuiCtrlSetCursor($Edit1,2)

$Button1 = GUICtrlCreateButton("Test Connection", 145, 272, 90, 25)
$Button2 = GUICtrlCreateButton("Test Custom", 245, 272, 90, 25)
$Button3 = GUICtrlCreateButton("Quit", 345, 272, 90, 25)
GUISetState(@SW_SHOW)

Dim $timeOut = 3000

While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button3
		ExitLoop
		
	Case $msg = $timeitem1
		GUICtrlSetState($timeitem1,$GUI_CHECKED)
		$timeOut = 3000
		GUICtrlSetState($timeitem2,$GUI_UnCHECKED)
		GUICtrlSetState($timeitem3,$GUI_UnCHECKED)
		
	Case $msg = $timeitem2
		GUICtrlSetState($timeitem2,$GUI_CHECKED)
		$timeOut = 4000	
		GUICtrlSetState($timeitem1,$GUI_UnCHECKED)
		GUICtrlSetState($timeitem3,$GUI_UnCHECKED)
		
	Case $msg = $timeitem3
		GUICtrlSetState($timeitem3,$GUI_CHECKED)
		$timeOut = 5000
		GUICtrlSetState($timeitem1,$GUI_UnCHECKED)
		GUICtrlSetState($timeitem2,$GUI_UnCHECKED)
		
	Case $msg = $Button1	
		
		_CLS()
		For $p = 1 To UBound($pingitem) -1
				If BitAND(GUICtrlRead($pingitem[$p][1]),$GUI_CHECKED) = $GUI_CHECKED Then
					;If GUICtrlRead($pingitem[$p][1]) = 69 Then
				;MsgBox(0, "", $pingitem[$p][2])
				_PingIt($pingitem[$p][2])
				Sleep(1000)
				EndIf
			Next
			If FileExists($INIfile) Then
				$ClientWeb = IniRead ($INIfile, "WEBSITE", "web", "" )
					If $ClientWeb Then
						_PingIt($ClientWeb)
					EndIf
			EndIf
			GUICtrlSetData($Edit1, "Test Complete" & @crlf, 1)
			
		Case $msg = $Button2	
			$pingValue = InputBox("Test Custom Host", "Enter the URL without HTTP://", "", "", 200, 100, -1, -1)
			If $pingValue Then
				If StringInStr($pingValue, "http://") Then
					MsgBox(0, "Improper Entry", "The URL can't contain http://")
					ContinueLoop
				EndIf	
				_CLS()
				_PingIt($pingValue)	
			EndIf	
				GUICtrlSetData($Edit1, "Test Complete" & @crlf, 1)
				
	Case $msg = $clearitem
		_CLS()	
		
	Case $msg = $netitem
		_CLS()
		$ipinfo = Run(@ComSpec & " /c ipconfig /all", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		While 1
			$line = StdoutRead($ipinfo, -1)
			If @error = -1 Then ExitLoop
			GUICtrlSetData($Edit1, StringStripWS($line, 1) & @crlf, 1)
		Wend

	Case $msg = $copyitem
		$clipCopy = GUICtrlRead ($Edit1) 
		ClipPut($clipCopy)

	Case $msg = $traceitem
		If $ClientWeb Then
			$linect = 0
			_CLS()
			HotKeySet("{Esc}", "abortTrace")

			GUICtrlSetData($Edit1, "Tracing Route To: " & $ClientWeb & " - press Escape to quit" & @crlf, 1)
			Sleep(1000)
			$trinfo = Run(@ComSpec & " /c tracert -h 30 -w " & $timeOut & " " & $ClientWeb, @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)	
			While 1
			
			$line = StdoutRead($trinfo, -1)
				If @error = -1  Then 
					ExitLoop

Else
				GUICtrlSetData($Edit1, $line, 1)
				EndIf
			Wend
		EndIf
	
	Case $msg = $sysitem
		_CLS()
		_sysInfo()

	Case $msg = $webmenu
		If FileExists($INIfile) Then
			$ClientWeb = IniRead ($INIfile, "WEBSITE", "web", "" )
			EndIf
			$IniValue = InputBox("Client Web Site", "Your Web Site URL without HTTP://", $ClientWeb, "", 200, 100, -1, -1)
			If $IniValue Then
				If StringInStr($IniValue, "http://") Then
					MsgBox(0, "Improper Entry", "The URL can't contain http://")
					ContinueLoop
				EndIf	
				IniWrite ( $INIfile, "WEBSITE", "web", $IniValue )
				$ClientWeb = $IniValue
				GUICtrlSetState($traceitem,$GUI_ENABLE)
			EndIf
			
		Case $msg = $pingitem[1][1]
			
			If BitAND(GUICtrlRead($pingitem[1][1]),$GUI_CHECKED) Then
			GUICtrlSetState($pingitem[1][1],$GUI_UNCHECKED)
			Else
			GUICtrlSetState($pingitem[1][1],$GUI_CHECKED)
			EndIf
		Case $msg = $pingitem[2][1]
			If BitAND(GUICtrlRead($pingitem[2][1]),$GUI_CHECKED) Then
			GUICtrlSetState($pingitem[2][1],$GUI_UNCHECKED)
			Else
			GUICtrlSetState($pingitem[2][1],$GUI_CHECKED)
			EndIf
		Case $msg = $pingitem[3][1]
			If BitAND(GUICtrlRead($pingitem[3][1]),$GUI_CHECKED) Then
			GUICtrlSetState($pingitem[3][1],$GUI_UNCHECKED)
			Else
			GUICtrlSetState($pingitem[3][1],$GUI_CHECKED)
			EndIf
		Case $msg = $pingitem[4][1]
			If BitAND(GUICtrlRead($pingitem[4][1]),$GUI_CHECKED) Then
			GUICtrlSetState($pingitem[4][1],$GUI_UNCHECKED)
			Else
			GUICtrlSetState($pingitem[4][1],$GUI_CHECKED)
			EndIf
		Case $msg = $pingitem[5][1]
			If BitAND(GUICtrlRead($pingitem[5][1]),$GUI_CHECKED) Then
			GUICtrlSetState($pingitem[5][1],$GUI_UNCHECKED)
			Else
			GUICtrlSetState($pingitem[5][1],$GUI_CHECKED)
			EndIf
		Case $msg = $pingitem[6][1]
			If BitAND(GUICtrlRead($pingitem[6][1]),$GUI_CHECKED) Then
			GUICtrlSetState($pingitem[6][1],$GUI_UNCHECKED)
			Else
			GUICtrlSetState($pingitem[6][1],$GUI_CHECKED)
			EndIf
		Case $msg = $pingitem[7][1]
			If BitAND(GUICtrlRead($pingitem[7][1]),$GUI_CHECKED) Then
			GUICtrlSetState($pingitem[7][1],$GUI_UNCHECKED)
			Else
			GUICtrlSetState($pingitem[7][1],$GUI_CHECKED)
			EndIf
		Case $msg = $pingitem[8][1]
			If BitAND(GUICtrlRead($pingitem[8][1]),$GUI_CHECKED) Then
			GUICtrlSetState($pingitem[8][1],$GUI_UNCHECKED)
			Else
			GUICtrlSetState($pingitem[8][1],$GUI_CHECKED)
			EndIf
		Case $msg = $pingitem[9][1]
			If BitAND(GUICtrlRead($pingitem[9][1]),$GUI_CHECKED) Then
			GUICtrlSetState($pingitem[9][1],$GUI_UNCHECKED)
			Else
			GUICtrlSetState($pingitem[9][1],$GUI_CHECKED)
			EndIf
		Case $msg = $pingitem[10][1]
			If BitAND(GUICtrlRead($pingitem[10][1]),$GUI_CHECKED) Then
			GUICtrlSetState($pingitem[10][1],$GUI_UNCHECKED)
			Else
			GUICtrlSetState($pingitem[10][1],$GUI_CHECKED)
			EndIf			
			
		Case $msg = $recyitem
			_CLS()
			GUICtrlSetData($Edit1, "Recycling Network Connection" & @crlf, 1)
			$ipinfo = Run(@ComSpec & " /c ipconfig /release", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
				ProcessWaitClose($ipinfo)
				While 1
					$line = StdoutRead($ipinfo, -1)
					If @error = -1 Then ExitLoop
					GUICtrlSetData($Edit1, $line, 1)
				Wend
				sleep(1000)
				$ipinfo = Run(@ComSpec & " /c ipconfig /renew", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
				ProcessWaitClose($ipinfo)
				While 1
					$line = StdoutRead($ipinfo, -1)
					If @error = -1 Then ExitLoop
					GUICtrlSetData($Edit1, $line, 1)
				Wend
				GUICtrlSetData($Edit1, @crlf & "Network Recycle Complete" & @crlf, 1)
		Case $msg = $repairitem		
			_CLS()
			GUICtrlSetData($Edit1, "Repairing Network Connection" & @crlf, 1)	
			$ipinfo = Run(@ComSpec & " /c ipconfig /release", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
				ProcessWaitClose($ipinfo)
				While 1
					$line = StdoutRead($ipinfo, -1)
					If @error = -1 Then ExitLoop
					$ReleaseError = 1
					GUICtrlSetData($Edit1, $line, 1)
				Wend
				sleep(1000)
			If $ReleaseError = 1 Then
				$ipinfo = Run(@ComSpec & " /c ipconfig /renew", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
				ProcessWaitClose($ipinfo)
				While 1
					$line = StdoutRead($ipinfo, -1)
					If @error = -1 Then ExitLoop
					GUICtrlSetData($Edit1, $line, 1)
				Wend	
				sleep(1000)
				
				$ipinfo = Run(@ComSpec & " /c ARP -d *", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
				ProcessWaitClose($ipinfo)
				While 1
					$line = StdoutRead($ipinfo, -1)
					If @error = -1 Then ExitLoop
					GUICtrlSetData($Edit1, $line, 1)
				Wend	
				sleep(1000)
				
				$ipinfo = Run(@ComSpec & " /c NBTSTAT -R", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
				ProcessWaitClose($ipinfo)
				While 1
					$line = StdoutRead($ipinfo, -1)
					If @error = -1 Then ExitLoop
					GUICtrlSetData($Edit1, $line, 1)
				Wend	
				sleep(1000)
				
				$ipinfo = Run(@ComSpec & " /c NBTSTAT -RR", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
				ProcessWaitClose($ipinfo)
				While 1
					$line = StdoutRead($ipinfo, -1)
					If @error = -1 Then ExitLoop
					GUICtrlSetData($Edit1, $line, 1)
				Wend	
				sleep(1000)
    
				$ipinfo = Run(@ComSpec & " /c IPCONFIG /flushdns", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
				ProcessWaitClose($ipinfo)
				While 1
					$line = StdoutRead($ipinfo, -1)
					If @error = -1 Then ExitLoop
					GUICtrlSetData($Edit1, $line, 1)
				Wend	
				sleep(1000)
				
				$ipinfo = Run(@ComSpec & " /c IPCONFIG /registerdns", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
				ProcessWaitClose($ipinfo)
				While 1
					$line = StdoutRead($ipinfo, -1)
					If @error = -1 Then ExitLoop
					GUICtrlSetData($Edit1, $line, 1)
				Wend	
			GUICtrlSetData($Edit1, @crlf & "Network Repair Complete" & @crlf, 1)

			EndIf	
		Case $msg = $relitem
				_CLS()
				GUICtrlSetData($Edit1, "Releasing Network Connection" & @crlf, 1)
				$ipinfo = Run(@ComSpec & " /c ipconfig /release", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
				ProcessWaitClose($ipinfo)
				While 1
					$line = StdoutRead($ipinfo, -1)
					If @error = -1 Then ExitLoop
					GUICtrlSetData($Edit1, $line, 1)
				Wend
				GUICtrlSetData($Edit1, @crlf & "Network IP Released" & @crlf, 1)
				
		Case $msg = $renitem
				_CLS()
				GUICtrlSetData($Edit1, "Renewing Network Connection" & @crlf, 1)	
				$ipinfo = Run(@ComSpec & " /c ipconfig /renew", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
				ProcessWaitClose($ipinfo)

				While 1
					$line = StdoutRead($ipinfo, -1)
					If @error = -1 Then ExitLoop
					GUICtrlSetData($Edit1, $line, 1)
				Wend
				GUICtrlSetData($Edit1, @crlf & "Network IP Renewed" & @crlf, 1)
			
		Case $msg = $instrhelp
				_CLS()
				GUICtrlSetData($Edit1, "Network Utility Instructions" & @crlf & @crlf, 1)
				GUICtrlSetData($Edit1, "This utility is used to test your network connection status, and the route between your local system and your web site, displaying route points (hops) along the way. It can also be used to reset and renew your local network connection to your router which will often solve connection problems." & @crlf & @crlf & "You can obtain basic information about your system and network connection to assist support personnel in diagnosing a problem from the items on the information menu. Help is available for each function on the help menu." & @crlf & @crlf & "1.  To Begin:" & @crlf & "Click on the Settings menu and the Client Web Site selection. Enter your web site URL without the http://." & @crlf & @crlf & "2.  If you can't get your email, or reach your web site:" & @crlf & "Click on the test connection button. This will by default Ping Google, Yahoo, and your web site if you have entered one." & @crlf & @crlf & "If there is no response from any attempts, see the help item Repair Network under Network Utility." & @crlf & @crlf & "If Google and Yahoo return but not your web site, see the section Trace Route under Network Utility." & @crlf & @crlf & "If all Ping requests return OK your Internet connection is fine. Note: if you are only having problems sending email, and not receiving it, the problem is most likely the use authentication setting  of the outgoing mail server setup in your email software." & @crlf & @crlf & "The steps and tests outlined here should be performed before calling for support. If your connection still appears to be down after performing the tests and all procedures outlined in the Network Repair section, contact your Internet Service Provider for assistance.", 1)
				
		Case $msg = $testhelp
				_CLS()
				GUICtrlSetData($Edit1, "Help: Test Connection Button" & @crlf & @crlf, 1)
				GUICtrlSetData($Edit1, "Sends Ping commands to test the reachability the hosts selected in the Settings, Host Tests menu and your web site. If all requests time out, it usually means either your local network connection is down, or your ISP connection is down." & @crlf & @crlf & "Set up your web site test by entering your URL in the Settings, Client Web Site menu." & @crlf & @crlf & "Test Custom will prompt you for the host URL to test." & @crlf & @crlf & "Note: A Ping request sends small packets of data to a host computer and waits for a response. Not all web hosts respond to a Ping request, so lack of Ping response does not necessarily mean the host is offline.", 1)
				
		Case $msg = $tracehelp
				_CLS()
				GUICtrlSetData($Edit1, "Help: Network Utility Menu - Trace Route" & @crlf & @crlf, 1)
				GUICtrlSetData($Edit1, "Sends Ping commands to test the reachability your web site and returns data on each router stop (hop) along the way. Uses the Time Out value from the settings menu" & @crlf & @crlf & "Often when it appears that a web site is unreachable the problem is a router along the route, not the web site. The output from this command can help diagnose these problems." & @crlf & @crlf & "Email connections will often time-out when there is a routing problem and there are too many hops in between you and the mail server. Email can also bounce when there are too many hops in between the mail server and the destination mail server. This can happen even if web sites continue to load." & @crlf & @CRLF & "You may need to drag the window wider to properly see the output.", 1)
		
		Case $msg = $recyhelp
				_CLS()
				GUICtrlSetData($Edit1, "Help: Network Utility Menu - Release/Renew" & @crlf & @crlf, 1)
				GUICtrlSetData($Edit1, "If you receive no response from the connection test, and the problem is your local network connection, this selection should re-establish communications." & @crlf & @crlf & "Note: for most purposes, the repair connection is the best choice for re-establishing your network connection as it is more thorough.", 1)
		Case $msg = $repairhelp
				_CLS()
				GUICtrlSetData($Edit1, "Help: Network Utility Menu - Repair Network Connection" & @crlf & @crlf, 1)		
				GUICtrlSetData($Edit1, "If you receive no response from the connection test, the problem is either your local network connection, or your Internet provider connection." & @crlf & @crlf & "If the problem is your local network connection you may have lost communication with your router. Use the repair selection to re-establish communications and refresh local computer settings including re-registration of the computer NetBIOS network name and flushing the local DNS cache." & @crlf & @crlf & "Note: this should solve most of your local network Internet communication problems. If it doesn't work, you can try rebooting your computer, turning your router off for 15 seconds and restarting it. If none of these attempts work, the problem is most likely a connection issue with your ISP.", 1)
		Case $msg = $relhelp
				_CLS()
				GUICtrlSetData($Edit1, "Help: Network Utility Menu - Release Network" & @crlf & @crlf, 1)
				GUICtrlSetData($Edit1, "Will cause your system to purge the current IP address lease. Can be used to disconnect from the network in an emergency (like worms or hack attacks).", 1) 
		
		Case $msg = $renhelp
				_CLS()
				GUICtrlSetData($Edit1, "Help: Network Utility Menu - Renew Network" & @crlf & @crlf, 1)
				GUICtrlSetData($Edit1, "If you have released your network connection using the release network selection, this selection will re-establish it.", 1) 
		
		Case $msg = $syshelp
				_CLS()
				GUICtrlSetData($Edit1, "Help: Information Menu - System Information" & @crlf & @crlf, 1)
				GUICtrlSetData($Edit1, "This selection will provide a list of basic system information to aid support personnel.", 1)
		
		Case $msg = $nethelp
				_CLS()
				GUICtrlSetData($Edit1, "Help: Information Menu - Network Information" & @crlf & @crlf, 1)
				GUICtrlSetData($Edit1, "This selection will provide a information about your current network connection to aid support personnel.", 1)
		
		Case $msg = $tohelp
				_CLS()
				GUICtrlSetData($Edit1, "Help: Settings Menu - Time Out" & @crlf & @crlf, 1)
				GUICtrlSetData($Edit1, "This menu allows you to select the  length of time before the Ping requests will time-out. It can be changed if there is heavy network traffic and your tests are timing out.", 1)
		
		Case $msg = $hosthelp
				_CLS()
				GUICtrlSetData($Edit1, "Help: Settings Menu - Host Tests" & @crlf & @crlf, 1)
				GUICtrlSetData($Edit1, "By default the connection test will Ping Google.com, Yahoo.com, and your web site if you have it set up. This menu allows you to change or select different hosts to test, and includes a list of many popular ISPs that provide cable and DSL services.", 1)	
		
		Case $msg = $wshelp
				_CLS()
				GUICtrlSetData($Edit1, "Help: Settings Menu - Client Web Site" & @crlf & @crlf, 1)
				GUICtrlSetData($Edit1, "Enter the URL of your web site here to utilize the connection and trace route tests. Do not include the http://. This setting will be saved for future use.", 1)	
		
		Case $msg = $abouthelp
				MsgBox(0, "About Network Utility", "Client Network Utiltiy v1.11 by Bill Mezian" & @CRLF & "Licensed to Media Coast clients for use in diagnosing connection issues." & @CRLF & "Any other use or redistribution of this software is prohibited.")
	Case Else
		;;;;;;;
	EndSelect
WEnd
Exit
Func _PingIt($strHost)
	GUICtrlSetData($Edit1, "Testing Connection " & $strHost & @crlf, 1)
	Sleep(1000)
For $i = 1 to 3
$Preturn = Ping ($strHost, $timeOut)
Sleep(1000)
	If $Preturn Then
		$Pdisplay = "Host: " & $strHost & " Found: " & $Preturn & " ms Round Trip"
	Else
		$Pdisplay = "Host: " & $strHost & " REQUEST TIME OUT"
	EndIf
GUICtrlSetData($Edit1, $Pdisplay & @crlf, 1)
Next	
GUICtrlSetData($Edit1, @crlf, 1)
EndFunc
Func _sysInfo()
	
$VOL = DriveGetLabel("C:\")
$SERIAL = DriveGetSerial("C:\")
$TOTAL = DriveSpaceTotal("C:\")
$FREE = DriveSpaceFree("C:\")
$mem = MemGetStats ( )

GUICtrlSetData($Edit1, "")
GUICtrlSetData($Edit1, "System Information" & @crlf & @crlf, 1)
GUICtrlSetData($Edit1, "Computer Name: " & @ComputerName & @crlf, 1)
GUICtrlSetData($Edit1, "Current User Name: " & @UserName & @crlf, 1)
GUICtrlSetData($Edit1, "Operating System: " & @OSTYPE & @crlf, 1)
GUICtrlSetData($Edit1, "OS Version: " & @OSVersion & @crlf, 1)
GUICtrlSetData($Edit1, "Service Pack: " & @OSServicePack & @crlf, 1)
GUICtrlSetData($Edit1, "Processor: " & @ProcessorArch & @crlf, 1)
GUICtrlSetData($Edit1, "Memory Load: " & $mem[0] & @crlf, 1)
GUICtrlSetData($Edit1, "Total physical RAM: " & $mem[1] & " kb" & @crlf, 1)
GUICtrlSetData($Edit1, "Available physical RAM: " & $mem[2] & " kb" & @crlf, 1)
GUICtrlSetData($Edit1, "Total Pagefile: " & $mem[3] & " kb" & @crlf, 1)
GUICtrlSetData($Edit1, "Available Pagefile: " & $mem[4] & " kb" & @crlf, 1)
GUICtrlSetData($Edit1, "Total virtual: " & $mem[5] & " kb" & @crlf, 1)
GUICtrlSetData($Edit1, "Available virtual: " & $mem[6] & " kb" & @crlf, 1)
GUICtrlSetData($Edit1, "Volume Label: " & $VOL & @crlf, 1)
GUICtrlSetData($Edit1, "Serial Number: " & $SERIAL & @crlf, 1)
GUICtrlSetData($Edit1, "Total Space: " & Round($TOTAL, 2) & @crlf, 1)
GUICtrlSetData($Edit1, "Free Space: " & Round($FREE, 2) & @crlf, 1)
GUICtrlSetData($Edit1, "IP Address: " & @IPAddress1 & @crlf, 1)
GUICtrlSetData($Edit1, "Startup Directory: " & @StartupDir & @crlf, 1)
GUICtrlSetData($Edit1, "Windows Directory: " & @WindowsDir & @crlf, 1)
GUICtrlSetData($Edit1, "System Folder: " & @SystemDir & @crlf, 1)
GUICtrlSetData($Edit1, "Desktop Directory: " & @DesktopDir & @crlf, 1)
GUICtrlSetData($Edit1, "My Documents: " & @MyDocumentsDir & @crlf, 1)
GUICtrlSetData($Edit1, "Program Files: " & @ProgramFilesDir & @crlf, 1)
GUICtrlSetData($Edit1, "Start Menu: " & @StartMenuDir & @crlf, 1)
GUICtrlSetData($Edit1, "Temporary Files: " & @TempDir & @crlf, 1)
GUICtrlSetData($Edit1, "Desktop Width: " & @DesktopWidth & @crlf, 1)
GUICtrlSetData($Edit1, "Desktop Height: " & @DesktopHeight & @crlf, 1)
GUICtrlSetData($Edit1, "Date/Time: " & @MON & "-" & @MDAY & "-" & @YEAR & " " & @HOUR &  ":" & @MIN & ":" & @SEC& @crlf, 1)
EndFunc
Func _CLS()
	GUICtrlSetData($Edit1, "")
EndFunc
Func abortTrace()
	GUICtrlSetData($Edit1, @crlf & @crlf & "Command Aborted" & @crlf, 1)
	$line = ""
	$trinfo = ""
	SetError(-1)
	HotKeySet("{Esc}")
					
EndFunc

	

