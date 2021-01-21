
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


#include <GUIConstants.au3>

Opt("GUIResizeMode", 802)
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)
Opt("TrayIconDebug",1)
TraySetIcon(@ScriptDir&"\Data\new.ico")
Global $mainwin, $ti, $tf, $edit, $pressed = 0, $Button_1, $Button_2
Global $tray1,$tray2,$tray3,$tray4
Global $progver = "Tiny program"

#Region ### START Koda GUI section ### Form=E:\New Folder\Smart AV\mainwin.kxf
$mainwin = GUICreate($progver, 632, 278, -1, -1)
$Button_2 = GUICtrlCreateButton("B1", 34, 44, 175, 30, 0)
$filemenu = GUICtrlCreateMenu("&File")
$logitem = GUICtrlCreateMenuItem("Clear Log", $filemenu)
$exititem = GUICtrlCreateMenuItem("Exit", $filemenu)
$helpmenu = GUICtrlCreateMenu("&Help")
$aboutitem = GUICtrlCreateMenuItem("About", $helpmenu)	
$tray1= TrayCreateItem('Launch Smart Anti-Virus')
TrayCreateItem('')
$tray2 = TrayCreateItem('Tray Mode')
$tray3 = TrayCreateItem('About')
$tray4 = TrayCreateItem('Exit')
#EndRegion ### END Koda GUI section ###

	While 1
		$msgtray = TrayGetMsg()
		$msg = GUIGetMsg()		
		Select
			
		
			Case $msg = $GUI_EVENT_MINIMIZE
				WinSetState($progver,"",@SW_HIDE)
			Case $msgtray = $TRAY_EVENT_PRIMARYDOUBLE
				GUISetState()
				WinActivate($progver,"")
			Case $msgtray = $tray1
				GUISetState()
				WinActivate($progver,"")
			Case $msgtray = $tray2
				WinSetState($progver,"",@SW_HIDE)
			Case $msgtray = $tray3
				aboutwin ()
			
			Case $msgtray = $tray4
					ExitLoop
			Case $msg = $GUI_EVENT_CLOSE
			
				ExitLoop
			Case $msg = $logitem

			Case $msg = $Button_2

			Case $msg = $exititem
				
				ExitLoop
			Case $msg = $aboutitem
				aboutwin ()
				EndSelect
			WEnd
			
			Func aboutwin()
Local $msg,$msgtray
$aboutWin = GuiCreate("About "&$progver, 330, 210,-1,-1,$GUI_SS_DEFAULT_GUI,$WS_EX_MDICHILD,$mainwin)
GUISetState (@SW_SHOW)
GUIsetIcon(@SystemDir & "\shell32.dll", 24)
GUICtrlCreateEdit("about", 120, 20, 200,150,$ES_READONLY, $WS_EX_STATICEDGE)
$button_4 = GUICtrlCreateButton("Send Feedback",16,180,90,20)
$button_5 = GUICtrlCreateButton("OK",200,180,80,20)
GUICtrlSetState($button_5,$GUI_FOCUS)
$TagsPageC = GuiCtrlCreateLabel('Visit Technodigits', 16, 150,100, 15, $SS_CENTER)
GuiCtrlSetFont($TagsPageC,9,400,4)
GuiCtrlSetColor($TagsPageC,0x0000ff)
GuiCtrlSetCursor($TagsPageC,0)
While 1
    $msg = GUIGetMsg()
	$msgtray = TrayGetMsg()
    Select	
		Case $msg = $button_4 	
			ShellExecute($turl)
		Case $msg = $button_5
			GUIDelete($aboutwin)
			Return
		Case $msg= $GUI_EVENT_CLOSE
			GUIDelete($aboutwin)
			Return
		Case $msg = $TagsPageC
			ShellExecute("                                  ")
		Case $msgtray <> 0 
			GUIDelete($aboutwin)
			Return			
	EndSelect
Wend
EndFunc