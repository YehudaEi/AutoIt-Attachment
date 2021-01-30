#include <GuiMenu.au3>
#include "WinEventHook.au3"
Opt('WinSearchChildren', 1)

HotKeySet('{ESC}', '_EXIT')

Global Const $MN_GETHMENU = 0x01E1
Global $hFunc, $pFunc
Global $hWinHook

$hFunc = DllCallbackRegister('_WinEventProc', 'none', 'ptr;uint;hwnd;int;int;uint;uint')
$pFunc = DllCallbackGetPtr($hFunc)

$hWinHook = _SetWinEventHook($EVENT_MIN, $EVENT_MAX, 0, $pFunc, 0, 0, _
				BitOR($WINEVENT_SKIPOWNPROCESS, $WINEVENT_OUTOFCONTEXT))
				
If $hWinHook = 0 Then Exit MsgBox(0x10, 'Error', 'Could not register callback procedure')

While 1
	Sleep(20)
WEnd

Func _EXIT()
	Exit
EndFunc

Func OnAutoItExit()
	_UnhookWinEvent($hWinHook)
	DllCallbackFree($hFunc)
EndFunc

Func _WinEventProc($hHook, $iEvent, $hWnd, $iObjectID, $iChildID, $iEventThread, $imsEventTime)
	Local $hMenu
	
	If $iEvent =  $EVENT_SYSTEM_MENUPOPUPSTART Then
		$hMenu = _SendMessage($hWnd, 0x01E1)
		If _GUICtrlMenu_IsMenu($hMenu) Then
			For $i = 0 To _GUICtrlMenu_GetItemCount($hMenu)-1
				Local $sItemText = _GUICtrlMenu_GetItemText($hMenu, $i)
				If $sItemText = '' Then ContinueLoop
				
				ConsoleWrite($sItemText & ' is ')
				If _GUICtrlMenu_GetItemEnabled($hMenu, $i) Then
					ConsoleWrite('enabled.' & @CRLF)
				Else
					ConsoleWrite('disabled.' & @CRLF)
				EndIf
			Next
		EndIf
		ConsoleWrite(@CRLF)
	EndIf
EndFunc