#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Downloads\stock_timezone.ico
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Global $oIE[1], $lRegion[1], $lDate[1], $lTime[1], $input[1], $clocks
$clocks = InputBox("Clocks", "Input Number of Clocks")
ReDim $oIE[$clocks+1], $lRegion[$clocks+1], $lDate[$clocks+1], $lTime[$clocks+1], $input[$clocks+1]
For $i = 1 To $clocks
	$input[$i] = InputBox("City", "Input Time Code")
Next
GUICreate("Time", 257, 116*$clocks, -1, 1)
For $i = 1 To $clocks
	$lRegion[$i] = GUICtrlCreateLabel("", 1, 0+( ($i-1) * 60 )+( ($i-1) *54 ), 257, 24, $SS_CENTER)
	$lDate[$i] = GUICtrlCreateLabel("", 1, 30+( ($i-1) * 60 )+( ($i-1) *54 ), 257, 24, $SS_CENTER)
	GUICtrlSetFont(-1, 12)
	$lTime[$i] = GUICtrlCreateLabel("", 1, 60+( ($i-1) * 60 )+( ($i-1) *54 ), 257, 52, $SS_CENTER)
	GUICtrlSetFont(-1, 32, 600)
	GUICtrlCreateLabel("-----------------------------------------------------------------------------------------", 1, 102 +( ($i-1) * 60 )+( ($i-1) *54 ), -1, 20)
Next
GUISetState(@SW_SHOW)

Load()
Data()
AdlibRegister("Data", 900)

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
	Next
EndFunc

Func Data()
	Local $oDiv
	For $i = 1 to $clocks
		$oDiv = _IEGetObjById($oIE[$i], "i_date")
		GUICtrlSetData($lDate[$i], _IEPropertyGet($oDiv, "innertext"))
		$oDiv = _IEGetObjById ($oIE[$i], "i_time")
		GUICtrlSetData($lTime[$i], _IEPropertyGet($oDiv, "innertext"))
	Next
EndFunc