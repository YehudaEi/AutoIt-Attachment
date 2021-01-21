#include <GUIconstants.au3>
#include <Constants.au3>
Opt("TrayMenuMode",1)
Opt("TrayOnEventMode",1)
Dim $time,$len = 0
	$pos0 = MouseGetPos()
	$time0 =  TimerInit()
	HotKeySet("{ESC}","quit")
	$tAbout = TrayCreateItem("About")
	TrayItemSetOnEvent($tAbout,"aboutW")
	$tExit = TrayCreateItem("")
	$tExit = TrayCreateItem("Exit")
	TrayItemSetOnEvent($tExit,"quit")
		
	
While 1
	SplashTextOn("","     V="&$len&" px/s",100,40,@DesktopWidth/2,0,$DLG_NOTITLE + $DLG_TEXTLEFT,"Arial","10","400")
	$s0 = Round( Sqrt( ($pos0[0]*$pos0[0]) + ($pos0[1]*$pos0[1]) ) )	
	Sleep(250)
	$time = TimerDiff($time0)
	If Round($time) >= 1 Then
		$pos = MouseGetPos()
		$s = Round( Sqrt( ($pos[0]*$pos[0]) + ($pos[1]*$pos[1]) ) )
		$len = abs($s - $s0)
		$pos0 = MouseGetPos()
	$time0 =  TimerInit()
EndIf
	
	
WEnd
Func quit()
	Exit
EndFunc
Func aboutW()
	Opt("GUIOnEventMode",1)
	GUICreate("About v0.1",200,80,-1,-1,-1, $WS_EX_TOOLWINDOW)
	GUICtrlCreateLabel("Created by EF, 2005"&@CRLF&@CRLF&"          rejq@konto.pl",10,10,100,100)
	$bOK = GUICtrlCreateButton("OK",150,25)
	GUICtrlSetOnEvent($bOK,"Ahide")
	GUISetState(@SW_SHOW)
	GUISetOnEvent($GUI_EVENT_CLOSE,"Ahide")
EndFunc
Func Ahide()
	GUISetState(@SW_HIDE)
EndFunc