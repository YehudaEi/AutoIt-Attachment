#include <GUIConstantsEx.au3>
#include <Misc.au3>
Opt("GUIOnEventMode", 1)

HotKeySet("{ESC}", "closeGUI")
Global $isMHK = 0
Global $m_checkParam[4], $user_dll = DllOpen("user32.dll")

$gui = GUICreate('Test Mouse-Hotkey')
GUISetOnEvent($GUI_EVENT_CLOSE, 'closeGUI')
GUICtrlCreateLabel('Close with <ESC> oder |X|', 50, 20, 150)
GUICtrlCreateLabel('Mouse:', 10, 78, 50)
$coMouse = GUICtrlCreateCombo('left', 70, 75, 50)
GUICtrlSetData(-1, 'right|middle', 'left')
GUICtrlCreateLabel('+ Key:', 150, 78, 50)
$coKey = GUICtrlCreateCombo('0', 190, 75, 40)
$sItem = ''
For $i = 49 To 90
	If $i = 58 Then $i = 65
	$sItem &= Chr($i) & '|'
Next
GUICtrlSetData($coKey, StringTrimRight($sItem, 1), '0')
$btSetMHK = GUICtrlCreateButton('Set Mouse-Hotkey', 40, 120, 180, 20)
GUICtrlSetOnEvent(-1, 'setMHK')
GUISetState()


While 1
	Sleep(20)
WEnd

Func closeGUI()
	If $isMHK Then HotKeyMouseSet()
	DllClose($user_dll)
	Exit
EndFunc   ;==>closeGUI

Func setMHK()
	If $isMHK Then
		HotKeyMouseSet()
		GUICtrlSetData($btSetMHK, 'Set Mouse-HotKey')
		WinSetTitle($gui, '', 'Hotkey is now deleted')
	Else
		HotKeyMouseSet(GUICtrlRead($coMouse), GUICtrlRead($coKey), 'test')
		GUICtrlSetData($btSetMHK, 'Delete Mouse-HotKey')
		WinSetTitle($gui, '', 'current MHK: ' & StringUpper(GUICtrlRead($coMouse)) & ' + ' & GUICtrlRead($coKey))
	EndIf
	$isMHK = BitXOR($isMHK, 1)
EndFunc   ;==>setMHK

Func HotKeyMouseSet($m_button = '', $key = '', $func = '', $r_time = 1000)
	If Not $m_button Then Return AdlibDisable()
	If Not $key Or Not $func Then Return SetError(1, 0, 0)
	If Not IsString($func) Then Return SetError(2, 0, 0)
	$key = Asc(StringUpper($key))
	If $m_button = 'left' Then
		$m_checkParam[0] = '01'
	ElseIf $m_button = 'right' Then
		$m_checkParam[0] = '02'
	ElseIf $m_button = 'middle' Then
		$m_checkParam[0] = '04'
	Else
		Return SetError(3, 0, 0)
	EndIf
	$m_checkParam[1] = $key
	$m_checkParam[2] = $func
	$m_checkParam[3] = $r_time
	Local $ret
	Do 
		For $i = 1 To 256
			$ret = DllCall($user_dll, "int", "GetAsyncKeyState", "int", "0x" & Hex($i, 2))
		Next
	Until $ret[0] = 0
	AdlibEnable('_checkMouse', 100)
EndFunc   ;==>HotKeyMouseSet

Func _checkMouse()
	Local $ts, $ret
	If _IsPressed($m_checkParam[0], $user_dll) Then
		$ts = TimerInit()
		Do
			$ret = DllCall($user_dll, "int", "GetAsyncKeyState", "int", "0x" & Hex($m_checkParam[1], 2))
			If $ret[0] Then Return Call($m_checkParam[2])
		Until TimerDiff($ts) > $m_checkParam[3]
	EndIf
EndFunc   ;==>_checkMouse

Func test()
	MsgBox(0, 'MausHotKey', 'Hotkey are used')
EndFunc   ;==>test