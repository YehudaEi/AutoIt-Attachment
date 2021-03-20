#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
Global $oIE[1], $lRegion[1], $lDate[1], $lTime[1], $input[1], $LastDate[1], $NowDate[1], $LastTime[1], $NowTime[1], $clocks
$clocks = InputBox("Clocks", "Input Number of Clocks")
If Not StringIsDigit($clocks) Then
	MsgBox(16, "Error", "Must be a number", 5)
	Exit
EndIf
ReDim $oIE[$clocks+1], $lRegion[$clocks+1], $lDate[$clocks+1], $lTime[$clocks+1], $LastDate[$clocks+1], $NowDate[$clocks+1], $LastTime[$clocks+1], $NowTime[$clocks+1], $input[$clocks+1]
For $i = 1 To $clocks
	$input[$i] = InputBox("City", "Input Time Code")
	If Not StringIsDigit($input[$i]) Then
		MsgBox(16, "Error", "Must be a number", 5)
		Exit
	EndIf
Next
GUICreate("Time", 257, 113*$clocks, -1, 1)
For $i = 1 To $clocks
	$lRegion[$i] = GUICtrlCreateLabel("", 1, 0+( ($i-1) * 60 )+( ($i-1) *54 ), 257, 24, $SS_CENTER)
	$lDate[$i] = GUICtrlCreateLabel("", 1, 30+( ($i-1) * 60 )+( ($i-1) *54 ), 257, 24, $SS_CENTER)
	GUICtrlSetFont(-1, 12)
	$lTime[$i] = GUICtrlCreateLabel("", 1, 60+( ($i-1) * 60 )+( ($i-1) *54 ), 257, 52, $SS_CENTER)
	GUICtrlSetFont(-1, 32, 600)
	GUICtrlCreateLabel("-----------------------------------------------------------------------------------------", 1, 105 +( ($i-1) * 60 )+( ($i-1) *54 ), -1, 20)
Next
Load()
Data()
GUISetState(@SW_SHOW)
$AdlibTime = 60*$clocks
AdlibRegister("Data", $AdlibTime)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			For $i = 1 To $clocks
				_IEQuit($oIE[$i])
			Next
			Exit
	EndSwitch
WEnd

Func Load()
	Local $oDiv
	For $i = 1 To $clocks
		$url = "http://www.timeanddate.com/worldclock/fullscreen.html?n=" & $input[$i]
		$oIE[$i] = _IECreate($url, 0, 0)
		$oDiv = _IEGetObjById($oIE[$i], "rs1")
		GUICtrlSetData($lRegion[$i], StringTrimLeft(_IEPropertyGet($oDiv, "innertext"), 14))
		$oDiv = _IEGetObjById($oIE[$i], "i_date")
		$LastDate[$i] = _IEPropertyGet($oDiv, "innertext")
		ControlSetText("Time", "", $lDate[$i], $LastDate[$i])
		$oDiv = _IEGetObjById ($oIE[$i], "i_time")
		$LastTime[$i] = _IEPropertyGet($oDiv, "innertext")
		ControlSetText("Time", "", $lTime[$i], $LastTime[$i])
	Next
EndFunc

Func Data()
	Local $oDiv
	For $i = 1 to $clocks
		$oDiv = _IEGetObjById($oIE[$i], "i_date")
		$NowDate[$i] = _IEPropertyGet($oDiv, "innertext")
		If $NowDate[$i] <> $LastDate[$i] Then
			ControlSetText("Time", "", $lDate[$i], $NowDate[$i])
			$LastDate[$i] = $NowDate[$i]
		EndIf
		$oDiv = _IEGetObjById ($oIE[$i], "i_time")
		$NowTime[$i] = _IEPropertyGet($oDiv, "innertext")
		If $NowTime[$i] <> $LastTime[$i] Then
			ControlSetText("Time", "", $lTime[$i], $NowTime[$i])
			$LastTime[$i] = $NowTime[$i]
		EndIf
	Next
EndFunc