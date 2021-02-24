#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Alexander Samuelsson (AdmiralAlkex)

 Script Function:
	Got an idea for an app that check which computers are turned on/off and warns/tells/logs it by continuously pinging ip's (or similar)

#ce ----------------------------------------------------------------------------

#include <Inet.au3>
#include <Array.au3>
#include <Constants.au3>

#region USER OPTIONS
Global $iIP_Timer = 300000
Global $iIP_Timeout = 3
#endregion

#region INIT
Opt("TrayAutoPause", 0)
OnAutoItExitRegister("__EXIT")
TCPStartup()
#endregion

#region SCRIPT
_SCRIPT()
#endregion

#region EXIT
Func __EXIT()
	TCPShutdown()
EndFunc
#endregion

#region FUNCTIONS
Func _SCRIPT()
	Local $asTest = __NetView()
	Local $sList = ""
	For $iX = 0 To UBound($asTest) - 1
		$sList &= $asTest[$iX] & @CRLF
	Next
	TrayTip(StringTrimRight(@ScriptName, 4) & "?", $sList, $iIP_Timeout, 16)
	Local $asOld = $asTest

	Local $iTimer = TimerInit()
	While 1
		Sleep(100)
		If TimerDiff($iTimer) > $iIP_Timer Then
			$asTest = __NetView()
			$asTestCopy = $asTest
			$sList = ""

			$sIP_New = "New since last scan:" & @CRLF
			$sIP_StillHere = "Still there:" & @CRLF
			$sIP_Disappeared = "Disappeared since last scan:" & @CRLF
			For $iX = UBound($asTest) - 1 To 0 Step - 1
				For $iY = UBound($asOld) - 1 To 0 Step - 1
					If $asTest[$iX] = $asOld[$iY] Then
						$sIP_StillHere &= $asTest[$iX] & @CRLF
						_ArrayDelete($asTest, $iX)
						_ArrayDelete($asOld, $iY)
						ContinueLoop 2
					EndIf
				Next
			Next
			For $iX = UBound($asTest) - 1 To 0 Step - 1
				$sIP_New &= $asTest[$iX] & @CRLF
				_ArrayDelete($asTest, $iX)
			Next
			For $iX = UBound($asOld) - 1 To 0 Step - 1
				$sIP_Disappeared &= $asOld[$iX] & @CRLF
				_ArrayDelete($asOld, $iX)
			Next
			If $sIP_New <> "New since last scan:" & @CRLF Then $sList &= $sIP_New
			If $sIP_StillHere <> "Still there:" & @CRLF Then $sList &= $sIP_StillHere
			If $sIP_Disappeared <> "Disappeared since last scan:" & @CRLF Then $sList &= $sIP_Disappeared
			TrayTip(StringTrimRight(@ScriptName, 4) & "?", $sList, $iIP_Timeout, 16)
			$asOld = $asTestCopy

			$iTimer = TimerInit()
		EndIf
	WEnd
EndFunc

Func __NetView()
	Local $iTimer = TimerInit()
	$iRet = Run("net view", "", @SW_HIDE, $STDOUT_CHILD)
	ProcessWaitClose($iRet)
	$sRet = StdoutRead($iRet)
	$sRet = StringReplace($sRet, @CRLF & @CRLF, "")
	$asRet = StringSplit($sRet, @CRLF, 1 + 2)
	_ArrayDelete($asRet, 0)
	_ArrayDelete($asRet, UBound($asRet) - 1)
	For $iX = 0 To UBound($asRet) - 1
		$iRet = StringInStr($asRet[$iX], " ")
		$asRet[$iX] = StringMid($asRet[$iX], 3, $iRet - 3)
	Next
	ConsoleWrite("__NetView took " & TimerDiff($iTimer) & @LF)
	Return $asRet
EndFunc
#endregion