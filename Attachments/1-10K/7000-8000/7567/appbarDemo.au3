#region file comments
#cs HEADER:
FILE : 		appbarDemo.au3
VERSION : 	0.2
AUTHOR: 	Darren Allen
EMAIL: 		DarrenAllen85@gmail.com
DESCRIPTION:Command Bar - execute a cmd command from an appbar
			Demonstration of using appbarHelper.au3.
			to quickly and easily support appbars in 
			autoit.
Quality: 	Alpha
Change History
VERSION 0.1
			Initial Demonstration
Version 0.2
			Turn demo into useful program: autobar to execute dos commands ala jeffery richters example.
#ce

#endregion



#include "appbarHelper.au3"

Opt("GuiOnEventMode",1);
opt("RunErrorsFatal",0)
opt("MustDeclareVars",1)

; make a new appbar
global $hwnd=_AppbarNew("My Appbar","MY_CALLBACK");
global $commands
;global $hwnd=GUICreate("My Appbar");
;GUISetState()
GUISwitch($hwnd)

GUISetBkColor(0xA0CAA0)

; create some controls on it
local $cmd=GUICtrlCreateCombo("Enter Command Here",10,3,@DesktopWidth/2,100,$ES_AUTOHSCROLL+$CBS_DROPDOWN)
GUICtrlSetLimit(-1,100)
GUICtrlSetResizing ( -1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
GUICtrlSetBkColor(-1,0xAAAAAA)

GUICtrlCreateButton ( "Go",  @DesktopWidth/2 + 40, 3,30,Default,$BS_DEFPUSHBUTTON )
GUICtrlSetOnEvent 	( -1, "DoExecute" )
GUICtrlSetResizing ( -1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)


GUICtrlCreateButton ( "F",  @DesktopWidth - 50, 3,30,Default)
guictrlsettip(-1,"Goto the autoit forums")
GUICtrlSetFont(-1,14,Default,Default,"Times New Roman Bold")
GUICtrlSetOnEvent 	( -1, "DoForums" )
GUICtrlSetResizing ( -1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)


local $dockmenu = GUICtrlCreateContextMenu()
GUICtrlCreateMenuitem ("Top",$dockmenu)
GUICtrlSetOnEvent 	( -1, "dockTop" )
GUICtrlCreateMenuitem ("Bottom",$dockmenu)
GUICtrlSetOnEvent 	( -1, "dockBottom" )
GUICtrlCreateMenuitem ("",$dockmenu)
GUICtrlCreateMenuitem ("Exit",$dockmenu)
GUICtrlSetOnEvent 	( -1, "DoExit" )
GUICtrlCreateMenuitem ("",$dockmenu)
GUICtrlCreateMenuitem ("About",$dockmenu)
GUICtrlSetOnEvent 	( -1, "DoAbout" )


; send the appbar to the top of the screen
_AppbarSetDockingEdges(false,false,true,true)
_AppbarDock($hwnd,$ABE_TOP,100,40)


while 1=1
	sleep(100)
WEnd

; this will be called by the appbarHelper.au3 with msgs from the appbar
; to see this try docking the appbar at the bottom and then resize the windows
; taskbar
; NB: not all windows msgs are responded to yet.
func MY_CALLBACK($hWnd, $MsgID, $WParam, $LParam)
	ConsoleWrite("MY_CALLBACK hwnd: " & $hwnd & @LF)
EndFunc

func kbDoExecute()
		if (WinActive("My Appbar")) Then
			DoExecute()
		endif
EndFunc

; called by the exit button 
func DoExit()
	Exit
EndFunc

; called by the execute button 
func DoExecute()
	local $c=GUICtrlRead($cmd)
	$commands=$commands & "|" & $c
	run("cmd /K " & $c);
	if (@error) Then	
		MsgBox(0,"Error","command not found");
	EndIf	
	guictrlsetdata($cmd,$commands,$c)
EndFunc

func DoForums()
	run( @ProgramFilesDir & "\internet explorer\iexplore.exe www.autoitscript.com/forum");
	if (@error) Then	
		MsgBox(0,"Error","command not found");
	EndIf
EndFunc

; this will be called as autoit exits - this ensures the appbar is cleaned up
func OnAutoItExit()
	_AppbarRemove($hwnd)
EndFunc

; this will be by the bottom button
func dockBottom()
	_AppbarDock($hwnd,$ABE_BOTTOM,40,40)
EndFunc

; this will be by the bottom button
func dockTop()
	_AppbarDock($hwnd,$ABE_TOP,40,40)
EndFunc

Func DoAbout()
	MsgBox(0,"AppbarDemo","By Darren Allen" & @LF & "DarrenAllen85@gmail.com" & @LF & "Version 0.2")
EndFunc	
