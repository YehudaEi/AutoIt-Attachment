#include <ANYGUIv2.6.au3>
#include <guiconstants.au3>
; ------------------------------------------------------------------------------
AutoItSetOption("WinTitleMatchMode", 4)
AutoItSetOption("MustDeclareVars",1)
; ------------------------------------------------------------------------------
Global Const $WM_DRAWITEM			= 0x002B
Global Const  $WM_NOTIFY = 0x004E

Global Const $BS_OWNERDRAW			= 0x0000000B
Global Const $BS_NOTIFY				= 0x00004000
; ------------------------------------------------------------------------------
Main()
; ------------------------------------------------------------------------------
Func Main()

	Local $pid, $winTitle, $hWndTarget, $Child
	Local $Button1, $Button2
	; Get notepad started
	$pid = Run("notepad.exe","",@SW_SHOW)
	Sleep(1000)
	$winTitle = "Untitled - "

	if not WInMove($winTitle,"", 0, 0, 400, 400) then 
		msgbox(16, "ERROR", "Could not move window", 5)
		WinClose($winTitle)
		Exit
	Endif

	$hWndTarget = _GuiTarget ($winTitle, 1); mode 1 set so all '_Targetadd(s) go to this window
	ControlMove($hWndTarget, "", 15, 0, 0, 300, 400);resize Edit1 control so everything fits
	$Child = _TargetaddChild ("Test", 301, 0, 98, 400);
	GUICtrlCreateGroup ("Group 1", 0, 0, 80, 260)
	$Button1 = GUICtrlCreateButton("Open", 8, 20, 60, 33, BitOR($BS_NOTIFY, $BS_OWNERDRAW) )
	$Button2 = GUICtrlCreateButton("Save", 8, 60, 60, 33)
		GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group

	GUIRegisterMsg($WM_NOTIFY, "WM_Notify_Events")
	GUIRegisterMsg($WM_DRAWITEM, "MY_WM_DRAWITEM")
	GUISetState(@SW_SHOW);
	; MSG LOOP -----------------------------------------------------
	dim $msg
	while 1
		$msg = GUIGetMsg()
		switch $msg
			case $Button1
				ControlSend($hWndTarget,"",15, "^o")
			case $Button2
				ControlSend($hWndTarget,"",15, "^s")
			case $GUI_EVENT_CLOSE
				Exit
			case else 
				if $msg <> 0 then ConsoleWrite("$msg:=" & $msg & @CR)
				If Not WinExists($hWndTarget) Then Exit
				sleep(250) ;Give the system a break..:)
		endswitch 
	wend 
	Exit
EndFunc
Func WM_Notify_Events($hWnd, $Msg, $wParam, $lParam)
	ConsoleWrite("WM_Notify_Events" & @CR)
	Return $GUI_RUNDEFMSG ; Proceed the default Autoit3 internal message commands
EndFunc
Func MY_WM_DRAWITEM($hWnd, $Msg, $wParam, $lParam)
	ConsoleWrite("MY_WM_DRAWITEM" & @CR)
	Return $GUI_RUNDEFMSG ; Proceed the default Autoit3 internal message commands
EndFunc