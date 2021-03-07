#AutoIt3Wrapper_Au3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <WinAPI.au3>
Opt('MustDeclareVars', 1)

_Main()

Func _Main()
	Local $aDevice, $i = 0, $text
	While 1
		$aDevice = _WinAPI_EnumDisplayDevices("", 1)
		if BitAND($aDevice[3], 1) then Run("DisplaySwitch.exe /internal")
		if not BitAND($aDevice[3], 1) then Run("DisplaySwitch.exe /extend")
		ExitLoop
	WEnd
EndFunc   ;==>_Main
