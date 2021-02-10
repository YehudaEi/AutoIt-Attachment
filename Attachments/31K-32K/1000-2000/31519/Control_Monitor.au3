#AutoIt3Wrapper_AU3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <Array.au3>
; sample control to monitor something (v2.0)
; by Mihai Iancu (aka taietel at yahoo dot com)
; modify to fit your needs
Global $points[1]
Global $aControl[8]
Global $hGui = GUICreate("A Whatever Monitor", 200, 120)
GUISetState(@SW_SHOW)

AdlibRegister("_Timer", 1000);register the timer

While 1
	Sleep(10)
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func _Timer()
	Local $RandVal = Random(0,100,1); Replace this with your value to monitor
	;let's generate graph based on my brain activity at this moment...
	_MControl_DrawGraph($RandVal)
	GUICtrlSetData($aControl[1],"taietel's brain:  "&$RandVal)
EndFunc

Func _MControl_Create($iX=10,$iY=10,$iW=180,$iH=80,$GridSpace=10,$GridColor=0x008800,$iBkColor=0x000000)
	If $iX = -1 Then $iX = 10
	If $iY = -1 Then $iY = 10
	If $iW < 180 Then $iW = 180
	If $iH < 80 Then $iH = 80

	Local $hGrafic = GUICtrlCreateGraphic($iX, $iY, $iW, $iH)
	GUICtrlSetColor(-1, $GridColor)
	GUICtrlSetBkColor(-1, $iBkColor)
	GUICtrlSetCursor(-1,0)

	Local $hValMon = GUICtrlCreateLabel("",$iX, $iY+$IH, $iW,12,BitOR($SS_LEFT,$SS_CENTERIMAGE))
	GUICtrlSetFont(-1,6,400,0,"Terminal")
	GUICtrlSetColor(-1,0x00CC00)
	GUICtrlSetBkColor(-1,0x000000)
	;store the data
	_ArrayInsert($aControl,0,$hGrafic)
	_ArrayInsert($aControl,1,$hValMon)
	_ArrayInsert($aControl,2,$iX)
	_ArrayInsert($aControl,3,$iY)
	_ArrayInsert($aControl,4,$iW)
	_ArrayInsert($aControl,5,$iH)
	_ArrayInsert($aControl,6,$GridColor)
	_ArrayInsert($aControl,7,$GridSpace)
	Return $aControl
EndFunc

Func _MControl_DrawGraph($iValue)
	Local $MaxValue = 100
	Local $MinValue = 0
    Local $maxSteps
	Local $fromPoint
    Local $toPoint
	Local $Step = 3
	If $iValue< $MinValue Or $iValue > $MaxValue Then
        Return False
    Else
        $maxSteps = $aControl[4]/$Step
        If UBound($points) >= $maxSteps Then
            For $i = 1 To UBound($points)-1
				_ArraySwap($points[$i - 1],$points[$i])
				_ArrayDelete($points,$i)
                Return False
            Next
        EndIf
		_ArrayInsert($points,UBound($points),$iValue)
	GUICtrlDelete($aControl[0])
	_MControl_Create()
	For $i = $aControl[5] To 0 Step - $aControl[7]
		GUICtrlSetGraphic($aControl[0], $GUI_GR_COLOR, $aControl[6])
		GUICtrlSetGraphic($aControl[0], $GUI_GR_MOVE, 0, $i)
		GUICtrlSetGraphic($aControl[0], $GUI_GR_LINE, $aControl[4], $i)
	Next
	For $i = $aControl[7] - 1 To $aControl[4] Step $aControl[7]
		GUICtrlSetGraphic($aControl[0], $GUI_GR_MOVE, $i,0)
		GUICtrlSetGraphic($aControl[0], $GUI_GR_LINE, $i,$aControl[5])
	Next
	If UBound($points) > 0 Then
        For $i = 1 To UBound($points)-1
			$fromPoint = $aControl[5] / ($MaxValue - $MinValue) * ($points[$i - 1] - $MinValue)
            $toPoint = $aControl[5] / ($MaxValue - $MinValue) * ($points[$i] - $MinValue)
			GUICtrlSetGraphic($aControl[0], $GUI_GR_COLOR, 0xFFFF00)
			GUICtrlSetGraphic($aControl[0], $GUI_GR_MOVE, $aControl[4] - (UBound($points) - $i + 1) * $Step, $aControl[5] - $fromPoint)
			GUICtrlSetGraphic($aControl[0], $GUI_GR_LINE, $aControl[4] - (UBound($points) - $i) * $Step, $aControl[5] - $toPoint)
        Next
		GUICtrlSetGraphic($aControl[0], $GUI_GR_REFRESH)
    EndIf
		Return True
    EndIf
EndFunc