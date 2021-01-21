;Clipboard notifier UDF example
;Steve Podhajecki [eltorro] steve@ocotillo.sytes.net
;

#Include <Clipboard.au3>

$hWnd_ME =GUICreate("Clipboard UDF Example.", 340, 260, (@DesktopWidth - 340) / 2, (@DesktopHeight - 260) / 2, -1)
GUICtrlCreateLabel("Copy something to the clipboard",8,8,200,25)
GUISetState(@SW_SHOW)
;----------------------------------------------------------
;Application
;----------------------------------------------------------
_InitAsClipViewer ($hWnd_ME) ; add this app as cliboard viewer
Main(1) ; Main msg/event handler
_StopAsClipViewer ($hWnd_ME) ; Remove this app as viewer, unhook msg
Exit

;----------------------------------------------------------
;Main msg/event loop
;----------------------------------------------------------
Func Main($bStartUp = 0)
	While 1
		$nMsg = GUIGetMsg()
		Select
			Case  $nMsg = $GUI_EVENT_CLOSE 
				ExitLoop
			Case $EVENT = $WM_DRAWCLIPBOARD
				;supress Startup msgbox.
				If Not ($bStartUp) Then
					MsgBox($MB_OK + $MB_SYSTEMMODAL + $MB_TOPMOST,"Clipboard UDF","The Clipboard has changed.")
				EndIf
			Case $EVENT =$WM_CHANGECBCHAIN
					MsgBox($MB_OK + $MB_SYSTEMMODAL + $MB_TOPMOST,"Clipboard UDF","The Clipboard chain has changed.")
			Case Else
				;;
		EndSelect
		$EVENT = 0
		If $bStartUp then $bStartUp = 0 
		Sleep(10)
	WEnd
EndFunc ;==>Main