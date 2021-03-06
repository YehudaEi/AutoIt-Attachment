Global Const $EVENT_MIN = 0x00000001
Global Const $EVENT_MAX = 0x7FFFFFFF

Global Const $WINEVENT_OUTOFCONTEXT = 0x0000
Global Const $WINEVENT_SKIPOWNTHREAD = 0x0001
Global Const $WINEVENT_SKIPOWNPROCESS = 0x0002
Global Const $WINEVENT_INCONTEXT = 0x0004

Global Const $EVENT_SYSTEM_SOUND = 0x0001
Global Const $EVENT_SYSTEM_ALERT = 0x0002
Global Const $EVENT_SYSTEM_FOREGROUND = 0x0003
Global Const $EVENT_SYSTEM_MENUSTART = 0x0004
Global Const $EVENT_SYSTEM_MENUEND = 0x0005
Global Const $EVENT_SYSTEM_MENUPOPUPSTART = 0x0006
Global Const $EVENT_SYSTEM_MENUPOPUPEND = 0x0007
Global Const $EVENT_SYSTEM_CAPTURESTART = 0x0008
Global Const $EVENT_SYSTEM_CAPTUREEND = 0x0009
Global Const $EVENT_SYSTEM_MOVESIZESTART = 0x000A
Global Const $EVENT_SYSTEM_MOVESIZEEND = 0x000B
Global Const $EVENT_SYSTEM_CONTEXTHELPSTART = 0x000C
Global Const $EVENT_SYSTEM_CONTEXTHELPEND = 0x000D
Global Const $EVENT_SYSTEM_DRAGDROPSTART = 0x000E
Global Const $EVENT_SYSTEM_DRAGDROPEND = 0x000F
Global Const $EVENT_SYSTEM_DIALOGSTART = 0x0010
Global Const $EVENT_SYSTEM_DIALOGEND = 0x0011
Global Const $EVENT_SYSTEM_SCROLLINGSTART = 0x0012
Global Const $EVENT_SYSTEM_SCROLLINGEND = 0x0013
Global Const $EVENT_SYSTEM_SWITCHSTART = 0x0014
Global Const $EVENT_SYSTEM_SWITCHEND = 0x0015
Global Const $EVENT_SYSTEM_MINIMIZESTART = 0x0016
Global Const $EVENT_SYSTEM_MINIMIZEEND = 0x0017
Global Const $EVENT_OBJECT_CREATE = 0x8000
Global Const $EVENT_OBJECT_DESTROY = 0x8001
Global Const $EVENT_OBJECT_SHOW = 0x8002
Global Const $EVENT_OBJECT_HIDE = 0x8003
Global Const $EVENT_OBJECT_REORDER = 0x8004
Global Const $EVENT_OBJECT_FOCUS = 0x8005
Global Const $EVENT_OBJECT_SELECTION = 0x8006
Global Const $EVENT_OBJECT_SELECTIONADD = 0x8007
Global Const $EVENT_OBJECT_SELECTIONREMOVE = 0x8008
Global Const $EVENT_OBJECT_SELECTIONWITHIN = 0x8009
Global Const $EVENT_OBJECT_STATECHANGE = 0x800A
Global Const $EVENT_OBJECT_LOCATIONCHANGE = 0x800B
Global Const $EVENT_OBJECT_NAMECHANGE = 0x800C
Global Const $EVENT_OBJECT_DESCRIPTIONCHANGE = 0x800D
Global Const $EVENT_OBJECT_VALUECHANGE = 0x800E
Global Const $EVENT_OBJECT_PARENTCHANGE = 0x800F
Global Const $EVENT_OBJECT_HELPCHANGE = 0x8010
Global Const $EVENT_OBJECT_DEFACTIONCHANGE = 0x8011
Global Const $EVENT_OBJECT_ACCELERATORCHANGE = 0x8012

Global Const $OBJID_WINDOW = 0
Global Const $OBJID_SYSMENU = 0xFFFFFFFF
Global Const $OBJID_TITLEBAR = 0xFFFFFFFE
Global Const $OBJID_MENU = 0xFFFFFFFD
Global Const $OBJID_CLIENT = 0xFFFFFFFC
Global Const $OBJID_VSCROLL = 0xFFFFFFFB
Global Const $OBJID_HSCROLL = 0xFFFFFFFA
Global Const $OBJID_SIZEGRIP = 0xFFFFFFF9
Global Const $OBJID_CARET = 0xFFFFFFF8
Global Const $OBJID_CURSOR = 0xFFFFFFF7
Global Const $OBJID_ALERT = 0xFFFFFFF6
Global Const $OBJID_SOUND = 0xFFFFFFF5
Global Const $OBJID_QUERYCLASSNAMEIDX = 0xFFFFFFF4
Global Const $OBJID_NATIVEOM = 0xFFFFFFF0


Func _SetWinEventHook($ieventMin, $ieventMax, $hMod, $pCallback, $iProcID, $iThreadID, $iFlags)
	Local $aRet
	
	$aRet = DllCall('user32.dll', 'ptr', 'SetWinEventHook', 'uint', $ieventMin, 'uint', $ieventMax, _
				'hwnd', $hMod, 'ptr', $pCallback, 'dword', $iProcID, 'dword', $iThreadID, 'uint', $iFlags)
	
	If @error Or $aRet[0] = 0 Then Return SetError(1, 0, 0)
	Return $aRet[0]
EndFunc

Func _UnhookWinEvent($hWinEventHook)
	Local $aRet
	
	$aRet = DllCall('user32.dll', 'int', 'UnhookWinEvent', 'ptr', $hWinEventHook)
	If @error Or $aRet[0] = 0 Then Return SetError(1, 0, 0)
	Return $aRet[0]
EndFunc