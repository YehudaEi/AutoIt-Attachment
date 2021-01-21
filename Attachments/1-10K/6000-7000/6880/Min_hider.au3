#NoTrayIcon
#include<guiconstants.au3>
#region ;Hotkeys
HotKeySet("{pgdn}", "Hide")
HotKeySet("{pgup}", "Unhide")
HotKeySet("{Delete}","Minimer")
HotKeySet("{Insert}","Vis")
#endregion

MsgBox(0,"Instruktioner","Brug Hhv. 'Page up' og 'Page down' til at fjerne/vise det ønskede Vindue.Brug Delete og Insert til at fjerne/vise selve hideren. ")
#region ;Gui'en
GUICreate("Hvilket Window?",200,200)
GUISetState()
Opt("wintitlematchmode", 2)
$Window=GUICtrlCreateInput("",0,75,155,25)
$Hvilket=GUICtrlCreateLabel("Hvilket vindue skal hides?",0,50)
$Credit = GUICtrlCreateLabel("Created by Mathias Blohm",0,180)
$go = GUICtrlCreateButton("Go!",155,72,30,30)
while 1
	
	$msg = GUIGetMsg()
	
	Select
	case $msg=$GUI_EVENT_CLOSE
		Exit
	Case $msg = $go
		Sleep(2500)
		Send("{pgdn}") 
		sleep(1000)
	EndSelect
WEnd
#endregion
 #region ;Funcs
 
 Func Hide() 
	 WinSetState(GUICtrlRead($Window),"",@SW_HIDE)
 EndFunc
 
 Func Unhide()
	 WinSetState(GUICtrlRead($Window),"",@SW_SHOW)
 EndFunc
 
 Func Minimer()
	 WinSetState("Hvilket Window?","",@SW_HIDE)
 EndFunc
 
 Func Vis()
	 WinSetState("Hvilket Window?","",@SW_SHOW)
 EndFunc
 

 #endregion