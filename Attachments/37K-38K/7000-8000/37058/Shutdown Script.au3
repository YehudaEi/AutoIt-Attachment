#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <file.au3>


Opt("GUIOnEventMode", 1) 


#Region
$mainwindow = GUICreate("Shutdown Panel", 800, 500)
GUISetBkColor(0x000000)
GUICtrlCreatePic("bkg.jpg", 0, 0, 800, 500)
$helpmenu = GUICtrlCreateMenu ("&Menu")
$menuitem1 = GUICtrlCreateMenuItem("About", $helpmenu)
GUISetOnEvent($menuitem1, "ABOUT")
$help = GUICtrlCreateMenuItem("Help", $helpmenu)
$close = GUICtrlCreateMenuItem("Close", $helpmenu)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
$title = GUICtrlCreateLabel("Please Select a Shutdown Function", 10, 40, 400, 40)
GUICtrlSetColor($title, 0xC83335)
GUICtrlSetFont($title, 18)
$hibernate = GUICtrlCreateButton("Hibernate", 15, 400, 80, 23)
GUICtrlSetFont($hibernate, 14)
GUICtrlSetBkColor($hibernate, 0x590100)
GUICtrlSetColor($hibernate, 0x000000)
GUICtrlSetOnEvent($hibernate, "Hibernate")
HotKeySet("h", "Hibernate")
$restart = GUICtrlCreateButton("Restart", 100, 400, 60, 23)
GUICtrlSetFont($restart, 14)
GUICtrlSetBkColor($restart, 0x590100)
GUICtrlSetColor($restart, 0x000000)
GUICtrlSetOnEvent($restart, "Restart")
HotKeySet("r", "Restart")
$shutdown = GUICtrlCreateButton("Shutdown", 165, 400, 80, 23)
GUICtrlSetFont($shutdown, 14)
GUICtrlSetBkColor($shutdown, 0x590100)
GUICtrlSetColor($shutdown, 0x000000)
guictrlsetonevent($shutdown, "Shtdown")
HotKeySet("s", "shtdown")
$logoff = GUICtrlCreateButton("Log Off", 250, 400, 60, 23)
GUICtrlSetFont($logoff, 14)
GUICtrlSetBkColor($logoff, 0x590100)
GUICtrlSetColor($logoff, 0x000000)
guictrlsetonevent($logoff, "offlog")
HotKeySet("l", "offlog")
$reset = GUICtrlCreateButton("  ", 790, 490, 10, 10)
GUICtrlSetFont($reset, 14)
GUICtrlSetBkColor($reset, 0x000000)
GUICtrlSetColor($reset, 0x000000)
guictrlsetonevent($reset, "reset")
HotKeySet("r", "reset")
$standby = GUICtrlCreateButton("Standby",  315, 400, 65, 23)
GUICtrlSetFont($standby, 14)
GUICtrlSetBkColor($standby, 0x590100)
GUICtrlSetColor($standby, 0x000000)
guictrlsetonevent($standby, "standby")
HotKeySet("r", "reset")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


GUISetOnEvent($menuitem1, "ABOUT")
GUISetOnEvent($close, "Close")







While 1
  Sleep(1000)
WEnd


Func ABOUT()
msgbox(0, "Info...", "This script is written by Bastian Müller")

EndFunc

Func Hibernate()

run("taskmgr")
WinWaitActive("Windows Task Manager")
WinSetState("Windows Task Manager", "", @SW_HIDE)
send("!u")
Send("{DOWN}")
Send("{ENTER}")
Exit
EndFunc

Func Restart()
WinWaitActive("Windows Task Manager")
WinSetState("Windows Task Manager", "", @SW_HIDE)
send("!u")
Send("{DOWN}")
Send("{DOWN}")
Send("{DOWN}")
Send("{ENTER}")
   Exit
EndFunc

Func Shtdown()
WinWaitActive("Windows Task Manager")
WinSetState("Windows Task Manager", "", @SW_HIDE)
send("!u")
Send("{DOWN}")
Send("{DOWN}")
Send("{ENTER}")
   Exit
EndFunc

Func offlog()
WinWaitActive("Windows Task Manager")
WinSetState("Windows Task Manager", "", @SW_HIDE)
send("!u")
Send("{DOWN}")
Send("{DOWN}")
Send("{DOWN}")
Send("{DOWN}")
Send("{ENTER}")
   Exit
EndFunc

Func reset()
   run("taskmgr")
WinWaitActive("Windows Task Manager")
WinSetState("Windows Task Manager", "", @SW_SHOW)
Send("!f")
Send("{DOWN}")
Send("{ENTER}")
exit
EndFunc

Func standby()
   run("taskmgr")
WinWaitActive("Windows Task Manager")
WinSetState("Windows Task Manager", "", @SW_SHOW)
Send("!f")
Send("{ENTER}")
   Exit
EndFunc

Func Close()
   Exit
   
   EndFunc

Func CLOSEClicked()
  Exit
EndFunc