#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <WinApi.au3>
#include <Misc.au3>
Global $Form1 = GUICreate("Form1", 615, 437, 192, 124)
Global $Form1CoordControler = GUICtrlCreateLabel("", 0, 0, 1, 1)
	GUICtrlSetState($Form1CoordControler,$GUI_HIDE)
Global $Button1 = GUICtrlCreateButton("Button1", 228, 144, 75, 25)
Global $InputSnaping = GUICtrlCreateInput("1", 8, 408, 137, 21, $ES_NUMBER)
	GUICtrlCreateUpdown($InputSnaping)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $GUI_EVENT_PRIMARYDOWN
			$GuICurMsg = GUIGetCursorInfo($Form1)
			If IsArray($GuICurMsg) Then _ControlMove($GuICurMsg[4])
	EndSwitch
WEnd

Func _ControlMove(Const $cID)
	Local $SelPos = ControlGetPos($Form1,"",$cID)
		If Not IsArray($SelPos) Then Return 0
	Local $cMmsg = GUIGetCursorInfo($Form1)
		If Not IsArray($cMmsg) Then Return 0
	Local $Form1Pos = WinGetPos($Form1)
		If Not IsArray($Form1Pos) Then Return 0
	Local $Form1Width = _WinAPI_GetWindowWidth($Form1)
		If @error Then Return 0
	Local $Form1Height = _WinAPI_GetWindowHeight($Form1)
		If @error Then Return 0
	Local $SubstractX, $SubstractY
	$SubstractX = $cMmsg[0] - $SelPos[0]
	$SubstractY = $cMmsg[1] - $SelPos[1]
	Local $MouseTrap = WinGetClientPos()
		If Not IsArray($MouseTrap) Then Return 0
	_MouseTrap($MouseTrap[0],$MouseTrap[1],$MouseTrap[2],$MouseTrap[3])
	Local $Snaping = Number(GUICtrlRead($InputSnaping))
	While _IsPressed("01")
		$cMmsg = GUIGetCursorInfo($Form1)
		If IsArray($cMmsg) And Mod($cMmsg[0],$Snaping) = 0 And Mod($cMmsg[1],$Snaping) = 0 Then GUICtrlSetPos($cID,$cMmsg[0]-$SubstractX,$cMmsg[1]-$SubstractY)
		If _IsPressed("02") Then Return GUICtrlSetPos($cID,$SelPos[0],$SelPos[1]) + _MouseTrap()
	WEnd
	Return _MouseTrap()
EndFunc   ;==>_ControlMove

Func _ArrayGetElement($aArray, $Element)
	If Not IsArray($aArray) Then Return SetError(1,0,-1)
	If UBound($aArray)-1 < $Element Then Return SetError(2,0,-1)
	Return $aArray[$Element]
EndFunc

Func WinGetClientPos()
	Local $aPos = ControlGetPos($Form1, "", $Form1CoordControler)
	Local $tPoint = DllStructCreate("int X;int Y")
	DllStructSetData($tpoint, "X", $aPos[0])
	DllStructSetData($tpoint, "Y", $aPos[1])
	_WinAPI_ClientToScreen($Form1, $tPoint)
	Local $X = DllStructGetData($tpoint, "X")
	Local $Y = DllStructGetData($tpoint, "Y")
	Local $W = $X + _WinAPI_GetClientWidth($Form1)
	Local $H = $Y + _WinAPI_GetClientHeight($Form1)
	Local $cPos2[4] = [$X,$Y,$W,$H]
    Return $cPos2
EndFunc