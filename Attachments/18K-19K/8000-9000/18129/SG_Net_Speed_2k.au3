
#region
HotKeySet("^!x", "_exit") ; exit hotkeys are Ctrl + Alt + X
HotKeySet("^!z","_mon") ; toggle monintoring
Opt("GUIOnEventMode", 1)
Opt('TrayIconDebug', 1)
#include <GUIConstants.au3>

GUICreate("SG-Net Speed",220,150,@DesktopWidth - 250,10,-1,$WS_EX_TOOLWINDOW)
GUISetOnEvent($GUI_EVENT_CLOSE,"_exit")
WinSetTrans("SG-Net Speed","",200)
$label1 = GUICtrlCreateLabel ( "Waiting for data...", 10, 5,200,20)
$progressbar1 = GUICtrlCreateProgress (10,20,200,20,$PBS_SMOOTH)
$label2 = GUICtrlCreateLabel ( "Waiting for data...", 10, 50,200,20)
$progressbar2 = GUICtrlCreateProgress (10,65,200,20,$PBS_SMOOTH)
GUISetState ()

$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$colItems = ""
$strComputer = "localhost"
;~ $strComputer = "fileserver"
$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
;~ $objWMIService = ObjGet("WinMgmts:{impersonationLevel=impersonate}" _
;~     & "!//fileserver/root/cimv2")
;~ "WinMgmts:{impersonationLevel=impersonate}" _
;~     & "!//myServer/root/cimv2:Win32_LogicalDisk"
$isMON = True
_detect2000()
while 1
   Sleep(100)
WEnd
#region
Func _mon()
	If $isMON Then
		$isMON = False
	Else
		$isMON = True
		_detect2000()
	EndIf
EndFunc
Func _detect2000()
	Local $xx = 0,$bIN = 0,$pbIN = 0, $bOUT = 0, $pbOUT = 0, $ts = 0, $pts = 0
	Local $frq = 0, $rateIN = 0, $rateOUT = 0, $coFAX = 0, $step = 1, $ostep = 1
	While $xx = 0
		Sleep(1000) ; 250 matches Task Manager
		$colItems = $objWMIService.ExecQuery("SELECT BytesReceivedPerSec, BytesSentPerSec, Timestamp_PerfTime," _
			& "Frequency_Perftime, CurrentBandwidth FROM Win32_PerfRawData_Tcpip_NetworkInterface", "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
		If IsObj($colItems) Then
			For $objItem In $colItems
				If $frq = 0 Then ; get first frequency counter then repeat
					$frq = $objItem.Frequency_PerfTime
					ExitLoop
				EndIf
				$bIN = $objItem.BytesReceivedPersec ; current bps value, every 1000ms
				$bOUT = $objItem.BytesSentPersec
				$frq = $objItem.Frequency_PerfTime
				$ts = $objItem.Timestamp_PerfTime
				$nMAX = $objItem.CurrentBandwidth;/1000000 ; connection speed of NIC
				If $nMAX = 1000000000 Then
					$nMAX = "1 Gb"
					$coFAX = 125000
				ElseIf $nMAX = 100000000 Then
					$nMAX = "100 Mb"
					$coFAX = 12500
				ElseIf $nMAX = 10000000 Then
					$nMAX = "10 Mb"
					$coFAX = 1250
				EndIf
				
				; 1 megabit (Mb) = 1,000,000 bits or 125,000 bytes or 125 kilobytes
				$rateIN = ($bIN - $pbIN) / (($ts - $pts) / $frq)
				$rateOUT = ($bOUT - $pbOUT) / (($ts - $pts) / $frq)
				GUICtrlSetData($label1,"Incoming... " & Round(($rateIN/12500)/10,2) & "Mbps   of " & $nMAX)
				GUICtrlSetData($progressbar1,Int(($rateIN/$coFAX)/10))
				GUICtrlSetData($label2,"Outgoing... " & Round(($rateOUT/12500)/10,2) & "Mbps   of " & $nMAX)
				GUICtrlSetData($progressbar2,Int(($rateOUT/$coFAX)/10))					
				$pbIN = $bIN ; set previous IN
				$pbOUT = $bOUT ; set previous OUT
				$pts = $ts ; set previous Timestamp
				; draw a graph for the speed history
				If $step = 1 Then
					$gr1 = GUICtrlCreateGraphic(10,95,200,50,$SS_BLACKFRAME)
					GUICtrlSetGraphic(-1,$GUI_GR_PENSIZE,1.25)
					GUICtrlSetGraphic(-1,$GUI_GR_COLOR,0xff0000) ;0x61c200);408000
					GUICtrlSetGraphic($gr1,$GUI_GR_MOVE,0,49)					
					$gr2 = GUICtrlCreateGraphic(10,95,200,50)
					GUICtrlSetGraphic(-1,$GUI_GR_PENSIZE,1.25)
					GUICtrlSetGraphic(-1,$GUI_GR_COLOR,0x0055e5) ;0x61c200);408000
					GUICtrlSetGraphic($gr2,$GUI_GR_MOVE,0,49)
				EndIf
;~ 				GUICtrlSetGraphic(-1,$GUI_GR_COLOR,0xff0000)
				GUICtrlSetGraphic($gr1,$GUI_GR_LINE,$step, 48 - Int(($rateIN/$coFAX)/25))
;~ 				GUICtrlSetGraphic($gr1,$GUI_GR_COLOR,0x0055e5)
				GUICtrlSetGraphic($gr2,$GUI_GR_LINE,$step, 48 - Int(($rateOUT/$coFAX)/25))
				GUICtrlSetGraphic($gr1,$GUI_GR_REFRESH)
				GUICtrlSetGraphic($gr2,$GUI_GR_REFRESH)
				$step += 1
				If $step = 199 Then 
					GUICtrlDelete($gr1)
					GUICtrlDelete($gr2)
					$step = 1
				EndIf
				ExitLoop
			Next
		EndIf
		If Not $isMON Then
			$xx = 1
			GUICtrlSetData($label1,"Disabled...")
			GUICtrlSetData($label2,"Disabled...")
		EndIf
	WEnd	
EndFunc
Func _exit()
	Exit
EndFunc
