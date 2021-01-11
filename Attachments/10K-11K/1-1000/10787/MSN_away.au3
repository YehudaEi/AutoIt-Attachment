Opt("WinTitleMatchMode", 2)
#include <GUIConstants.au3>
$oldtitle = ""
Global Const $AW_FADE_IN = 0x00080000 
Global Const $AW_FADE_OUT = 0x00090000
$oldtitle = ""
$originalgui = GUICreate("What message to you want to send when your friends atempt to contact you using MSN messenger?", 580, 26, -1, -1, $WS_CAPTION, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
GUISetBkColor(0x6BC072)
$message = GUICtrlCreateInput("I'm away... be back soon", 5, 3, 490, 20, $ES_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetBkColor(-1, 0xA6D9AA)
$exit = GUICtrlCreateButton("Exit", 500, 1, 35, 23)
$ok = GUICtrlCreateButton("OK", 540, 1, 35, 23)
GuiCtrlSetState($ok, $GUI_FOCUS)
GUISetState()

While 1
	$msg = GUIGetMsg()
	If $msg = $exit Then 
		_WinAnimate($originalgui, $AW_FADE_OUT)
		Exit
		Endif
	If $msg = $ok Then
		$message = GUICtrlRead($message)
		_WinAnimate($originalgui, $AW_FADE_OUT)
		GuiDelete()
		$newgui = GUICreate("The message below will be sent to your friends when they attempt contact you.", 580, 26, -1, -1, $WS_CAPTION, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
			GUISetBkColor(0x6BC072)
		$exit = GUICtrlCreateButton("Exit", 540, 1, 35, 23)
		_WinAnimate($newgui, $AW_FADE_IN)
		GUISetState()
		GuiCtrlCreateLabel($message, 4,5,532,20,$ES_CENTER)
			Do
			$oldtitle1 = WinGetTitle("Conversation")
			;If $oldtitle <> 0 then 
				WinActivate ( $oldtitle1 )
					If WinActive("Conversation") Then
						If WinGetTitle("Conversation") <> $oldtitle Then
							WinWaitActive("Conversation")
							Send("<This is an autoreply> " & $message & "{enter}")
							$oldtitle = WinGetTitle("Conversation")
						EndIf
					EndIf
				;Endif
			Until GUIGetMsg() = $exit
			_WinAnimate($newgui, $AW_FADE_OUT)
		Exitloop
	EndIf
WEnd

#cs
While 1
	If WinActive("Conversation") Then
		WinWaitActive("Conversation")
		Send("<This is an autoreply> " & $message)
		$oldtitle = WinGetTitle("Conversation")
	EndIf
	ExitLoop
WEnd


While 1
	If WinActive("Conversation") Then
		If WinGetTitle("Conversation") <> $oldtitle Then
			WinWaitActive("Conversation")
			Send("<This is an autoreply> " & $message)
			$oldtitle = WinGetTitle("Conversation")
		EndIf
	EndIf
WEnd
#ce

Func _WinAnimate($v_gui, $i_mode, $i_duration = 1000)
        DllCall("user32.dll", "int", "AnimateWindow", "hwnd", WinGetHandle($v_gui), "int", $i_duration, "long", $i_mode)
        Local $ai_gle = DllCall('kernel32.dll', 'int', 'GetLastError')
        If $ai_gle[0] <> 0 Then
            SetError(1)
            Return 0
        Return 1
    EndIf
EndFunc
