#include-once
;_SS_UDF.au3 v1.3.1.0 - 29 April 2008: New _SS_ShouldExit method for determining idle status obeys sensitivity parameter again
If WinExists("ScrnSav:"&@ScriptFullPath) Then WinKill("ScrnSav:"&@ScriptFullPath)
AutoItWinSetTitle("ScrnSav:"&@ScriptFullPath)

If Not IsDeclared("SM_VIRTUALWIDTH") Then Global Const $SM_VIRTUALWIDTH = 78
If Not IsDeclared("SM_VIRTUALHEIGHT") Then Global Const $SM_VIRTUALHEIGHT = 79
$VirtualDesktopWidth = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALWIDTH)
$VirtualDesktopWidth = $VirtualDesktopWidth[0]
$VirtualDesktopHeight = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALHEIGHT)
$VirtualDesktopHeight = $VirtualDesktopHeight[0]

Global $_SS_WinWidth=$VirtualDesktopWidth;available to the user to get the width of the available screensaver window, regardless of it's a preview or full screensaver
Global $_SS_WinHeight=$VirtualDesktopHeight;available to the user to get the height of the available screensaver window, regardless of it's a preview or full screensaver
Global $_SS_IsPreview=0;available to the user so they can do different things depending on if it's a preview or the full screensaver

Global $_SS_MousePos=MouseGetPos()
Global $_SS_MainFunc="_SS_MainFunc";name of the function to use as the main screensaver loop in both preview and full screensaver
Global $_SS_ConfigFunc="_SS_ConfigFunc";name of the function to use to configure the screensaver

Func _SS_SetMainLoop($_ss_funcName="_SS_MainFunc");user calls this to name the function they'd like to use as the main screensaver loop
	$_SS_MainFunc=$_ss_funcName
EndFunc

Func _SS_SetConfigLoop($_ss_funcName="_SS_ConfigFunc");user calls this to name the function they'd like to use if the screensaver is attempted to be configured
	$_SS_ConfigFunc=$_ss_funcName
EndFunc

Func _SS_GUICreate();the function to create the correct type of GUI for the screensaver, regardless of it's a preview or not
	If $CmdLine[0] > 0 AND StringLeft($CmdLine[1],2)="/p" Then
		If $CmdLine[0] < 2 Then Exit
		$_SS_IsPreview=1
	EndIf
	If NOT $_SS_IsPreview Then
		Global $_SS_GUI=GUICreate(@ScriptFullPath,$_SS_WinWidth,$_SS_WinHeight,0,0,0x80000000,136);$WS_POPUP,$WS_EX_TOPMOST+$WS_EX_TOOLWINDOW
		GUISetCursor(16,1)
		GUISetBkColor(0x000000)
	Else
		$VirtualDesktopWidth=152
		$VirtualDesktopHeight=112
		Global $_SS_GUI=GUICreate("ColorBoxes Screensaver",$_SS_WinWidth,$_SS_WinHeight,0,0,0x80000000)
		GUISetBkColor(0x000000)
		$USER32 = DllOpen("user32.dll")
		DllCall($USER32,"int","SetParent","hwnd",$_SS_GUI,"hwnd",HWnd($CmdLine[2]))
		DllClose($USER32)
	EndIf
	Return $_SS_GUI
EndFunc

Func _SS_Start();the function to call when everything's set up- turns control over to the appropriate loops
	Global $_SS_LastActionTicks=_SS_LastAction()
	If Not IsDeclared("_SS_GUI") Then _SS_GUICreate()
	If ($CmdLine[0]=0 Or StringLeft($CmdLine[1],2)="/s") Or $_SS_IsPreview Then
		GUISetState(@SW_SHOW,$_SS_GUI)
		Call($_SS_MainFunc)
	ElseIf StringLeft($CmdLine[1],2)="/c" Then
		Call($_SS_ConfigFunc)
	EndIf
EndFunc

Func _SS_MainFunc();a generic main loop function in case the user doesn't define their own
	Do
		Sleep(15)
	Until _SS_ShouldExit() Or NOT WinExists($_SS_GUI)
EndFunc

Func _SS_ConfigFunc();a generic config function in case the user doesn't define their own
	MsgBox(0,"Configure Screen Saver","This screensaver has no options you may configure")
EndFunc

Func _SS_ShouldExit($_SS_Sensitivity=10);a generic "check if no longer idle" function...uses _SS_LastAction() to check if the user is no longer idle.  I'd like to find some way of finding out WHAT the event was though, so I could reimplement a sensitivity setting on the mouse.
	If NOT WinExists($_SS_GUI) Then Return SetError(1,"",0);user checked to see if it should exit before the window even exists
	If GUIGetMsg() = -3 Then Return 1;close event was registered
	If $_SS_IsPreview Then
		If NOT WinExists(HWnd($CmdLine[2])) Then Return 1;preview window has been closed
	Else
		If _SS_LastAction() <> $_SS_LastActionTicks Then
			If MouseGetPos(0)=$_SS_MousePos[0] AND MouseGetPos(1)=$_SS_MousePos[1] Then	Return 1;last action was keyboard
			If Abs(MouseGetPos(0)-$_SS_MousePos[0]) > $_SS_Sensitivity OR Abs(MouseGetPos(1)-$_SS_MousePos[1]) > $_SS_Sensitivity Then
				Return 1
			Else
				$_SS_MousePos=MouseGetPos()
				$_SS_LastActionTicks=_SS_LastAction()
			EndIf
		EndIf
	EndIf
	Return 0
EndFunc

Func _SS_LastAction();thanks to erifash for the heart of this function and Squirrely1 for pointing it out...returns the last time (in ticks) that any action was registered at the keyboard or mouse
	Local $IdleStruct=DllStructCreate("uint;dword")
	DllStructSetData($IdleStruct,1,DLLStructGetSize($IdleStruct))
	DllCall("user32.dll","int","GetLastInputInfo","ptr",DLLStructGetPtr($IdleStruct))
	Return DLLStructGetData($IdleStruct,2)
EndFunc