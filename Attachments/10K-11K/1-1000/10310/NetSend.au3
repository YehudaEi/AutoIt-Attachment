#NoTrayIcon
#include <GUIConstants.au3>

GUICreate("NetSend", 200, 140, -1, -1)
GUICtrlCreateLabel("Message:", 10, 13, 50, 15)
$Message = GUICtrlCreateInput("", 60, 10, 130, 20)
GUICtrlCreateLabel("Sender:", 10, 43, 50, 15)
$Sender = GUICtrlCreateInput("", 60, 40, 130, 20)
GUICtrlCreateLabel("Receiver:", 10, 73, 50, 15)
$Receiver = GUICtrlCreateInput("", 60, 70, 130, 20)
$OK = GUICtrlCreateButton("Send", 10, 100, 180, 30)
GUISetState()

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $OK
			$Send = NetSend(GUICtrlRead($Sender), GUICtrlRead($Receiver), GUICtrlRead($Message))
			If $Send = 0 Then
				MsgBox(16, "NetSend", "Error! The message could not be sent!")
			EndIf
	EndSwitch
WEnd

Func NetSend($szSender, $szReceiver, $szMessage)
	Local Const $GENERIC_WRITE = 0x40000000
	Local Const $FILE_SHARE_READ = 0x00000001
	Local Const $OPEN_EXISTING = 0x00000003
	Local Const $FILE_ATTRIBUTE_NORMAL = 0x00000080
		
	Local $bRet = 0
	
	Local $pucMessage = DllStructCreate("byte[" & StringLen($szSender & Chr(0) & $szReceiver & Chr(0) & $szMessage & Chr(0)) & "]")
	For $i = 1 To StringLen($szSender & Chr(0) & $szReceiver & Chr(0) & $szMessage & Chr(0))
		DllStructSetData($pucMessage, 1, Asc(StringMid($szSender & Chr(0) & $szReceiver & Chr(0) & $szMessage & Chr(0), $i, 1)), $i)
	Next
	
	Local $pszMailSlot = DllStructCreate("char[" & StringLen("\\" & $szReceiver & "\MAILSLOT\messngr") + 1 & "]")
	DllStructSetData($pszMailSlot, 1, "\\" & $szReceiver & "\MAILSLOT\messngr")
	
	Local $hHandle = DllCall("kernel32.dll", "hwnd", "CreateFile", "ptr", DllStructGetPtr($pszMailSlot), _
								"int", $GENERIC_WRITE, _
								"int", $FILE_SHARE_READ, _
								"ptr", 0, _
								"int", $OPEN_EXISTING, _
								"int", $FILE_ATTRIBUTE_NORMAL, _
								"int", 0)
	$hHandle = $hHandle[0]
	
	If $hHandle Then
		Local $bRet = DllCall("kernel32.dll", "int", "WriteFile", "hwnd", $hHandle, _
								"ptr", DllStructGetPtr($pucMessage), _
								"int", StringLen($szSender & Chr(0) & $szReceiver & Chr(0) & $szMessage & Chr(0)), _
								"long_ptr", 0, _
								"ptr", 0)
		$bRet = $bRet[4]
		
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hHandle)
	EndIf
	
	Return $bRet
EndFunc