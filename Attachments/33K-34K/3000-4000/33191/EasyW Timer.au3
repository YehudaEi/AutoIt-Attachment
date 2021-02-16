;;;;;;;;;;;;;;;;;;;;;;;;;Includes;;;;;;;;;;;;;;;;;;;;;;;
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

;;;;;;;;;;;;;;;;;;;;;;;;;Variables;;;;;;;;;;;;;;;;;;;;;;
Global $Ini = @ScriptDir & "\EWTimer.ini"
Global $aCurrent = _LoadIni()
Global $hGui, $EW, $iMinute, $iDay, $iPeriod, $iSong, $iBrowse, $iMessage, $iToggleAlarm, $iMsg, $nMsg
;Opt ("WinTitleMatchMode", 2)

#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("EasyWorship Timer                                        JDJ", 348, 393, 192, 164, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))
GUISetBkColor(0xFFFFFF)
$Label1 = GUICtrlCreateLabel("This program designed to be used with EasyWorship", 8, 8, 319, 20)
$Label2 = GUICtrlCreateLabel("It will press the 'Go Live' and optionaly another button", 8, 24, 322, 20)
$Label3 = GUICtrlCreateLabel("at a set time.", 120, 40, 78, 20)
$Label4 = GUICtrlCreateLabel("Time to activate :", 16, 72, 127, 20)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUIStartGroup()
$Radio1 = GUICtrlCreateRadio("'Go Live'", 16, 160, 81, 17)
$Radio2 = GUICtrlCreateRadio("'Logo'", 144, 160, 65, 17)
$Radio3 = GUICtrlCreateRadio("'Live'", 272, 160, 57, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Checkbox1 = GUICtrlCreateCheckbox("Enable Second Button:", 8, 224, 169, 17)
GUIStartGroup()
$Radio4 = GUICtrlCreateRadio("'Go Live'", 16, 272, 81, 17)
$Radio5 = GUICtrlCreateRadio("'Logo'", 136, 272, 65, 17)
$Radio6 = GUICtrlCreateRadio("'Live'", 272, 272, 57, 17)
$Checkbox2 = GUICtrlCreateCheckbox("Close Timer Afterward", 16, 312, 153, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Button1 = GUICtrlCreateButton("CANCEL", 248, 320, 75, 25, $WS_GROUP)
$Label6 = GUICtrlCreateLabel("Time Now:", 88, 104, 75, 20)
$Label7 = GUICtrlCreateLabel("0:00.00", 160, 104, 60, 20)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Checkbox3 = GUICtrlCreateCheckbox("Timer On Top", 16, 336, 105, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$ComboHour = GUICtrlCreateCombo("", 152, 72, 49, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10|11|12", $aCurrent[1])
$ComboMin = GUICtrlCreateCombo("", 208, 72, 49, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
For $i = 0 To 59
    GUICtrlSetData(-1, StringFormat("%02i", $i), $aCurrent[2])
Next
$ComboSec = GUICtrlCreateCombo("", 264, 72, 49, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
For $i = 0 To 59
    GUICtrlSetData(-1, StringFormat("%02i", $i), $aCurrent[3])
Next
$Group1 = GUICtrlCreateGroup("First Button to Press", 8, 128, 329, 73)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Second Butoon to Press", 8, 240, 329, 65)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_SetGUI()
GUICtrlSetData ( $Label2, "EasyWorship is not running yet. Please start it.")
GUICtrlSetData ( $Label3, "")
GUISetState ( @SW_DISABLE , $Form1_1 )
Do
	Sleep (1000)
Until WinExists ( "EasyWorship 2009") = 1
$EW = WinGetHandle ( "EasyWorship 2009", "" )
GUISetState ( @SW_ENABLE , $Form1_1 )
GUICtrlSetData ( $Label2, "It will press the 'Go Live' and optionaly another button")
GUICtrlSetData ( $Label3, "at a set time.")
AdlibRegister("_CheckAlarm", 250)

While 1
	$nMsg = GUIGetMsg()
	If WinExists ($EW) = 0 Then
		_WriteIni()
		Exit
	EndIf
	Switch $nMsg
		Case $Button1
			_WriteIni()
			Exit
	    Case $GUI_EVENT_CLOSE
			_WriteIni()
			Exit
		Case $Checkbox1
			If GUICtrlRead ( $nMsg ) = 1 Then
				GUICtrlSetState ( $Radio4, $GUI_ENABLE )
				GUICtrlSetState ( $Radio5, $GUI_ENABLE )
				GUICtrlSetState ( $Radio6, $GUI_ENABLE )
			Else
				GUICtrlSetState ( $Radio4, $GUI_DISABLE )
				GUICtrlSetState ( $Radio5, $GUI_DISABLE )
				GUICtrlSetState ( $Radio6, $GUI_DISABLE )
			EndIf
		Case $Checkbox2
			$aCurrent[7] = GUICtrlRead($nMsg)
		Case $Checkbox3
			If GUICtrlRead ($nMsg ) = 1 Then
				WinsetState ("EasyWorship Timer","",1)
			Else
				WinSetState ("EasyWorship Timer","",0)
			EndIf
		Case $ComboHour
			$aCurrent[1] = GUICtrlRead($nMsg)
		Case $ComboMin
			$aCurrent[2] = GUICtrlRead($nMsg)
		Case $ComboSec
			$aCurrent[3] = GUICtrlRead($nMsg)
		Case $Radio1
			If GUICtrlRead($nMsg)=1 Then $aCurrent[4] = 1
		Case $Radio2
			If GUICtrlRead($nMsg)=1 Then $aCurrent[4] = 2
		Case $Radio3
			If GUICtrlRead($nMsg)=1 Then $aCurrent[4] = 3
		Case $Radio4
			If GUICtrlRead($nMsg)=1 Then $aCurrent[6] = 1
		Case $Radio5
			If GUICtrlRead($nMsg)=1 Then $aCurrent[6] = 2
		Case $Radio6
			If GUICtrlRead($nMsg)=1 Then $aCurrent[6] = 3

	EndSwitch
WEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func _SetGUI()
	; 1=Hour 2=Min 3=Sec 4=ButtonRadio 5=SecondEnable 6=SecondRadio 7=CloseEnd 8=OnTop

	Switch $aCurrent[4]
		Case 1
			GUICtrlSetState($Radio1, $GUI_CHECKED)
		Case 2
			GUICtrlSetState($Radio2, $GUI_CHECKED)
		Case 3
			GUICtrlSetState($Radio3, $GUI_CHECKED)
	EndSwitch
		GUICtrlSetState($Radio4, $GUI_ENABLE )
		GUICtrlSetState($Radio5, $GUI_ENABLE )
		GUICtrlSetState($Radio6, $GUI_ENABLE )

	Switch $aCurrent[6]
		Case 1
			GUICtrlSetState($Radio4, $GUI_CHECKED)
		Case 2
			GUICtrlSetState($Radio5, $GUI_CHECKED)
		Case 3
			GUICtrlSetState($Radio6, $GUI_CHECKED)
	EndSwitch
	Switch $aCurrent[5]
		Case 0
			GUICtrlSetState($Radio4, $GUI_DISABLE )
			GUICtrlSetState($Radio5, $GUI_DISABLE )
			GUICtrlSetState($Radio6, $GUI_DISABLE )
		Case 1
			GUICtrlSetState($Radio4, $GUI_ENABLE )
			GUICtrlSetState($Radio5, $GUI_ENABLE )
			GUICtrlSetState($Radio6, $GUI_ENABLE )
	EndSwitch
	GUICtrlSetState($Checkbox1, $aCurrent[5])
	GUICtrlSetState($Checkbox2, $aCurrent[7])
	GUICtrlSetState($Checkbox3, $aCurrent[8])
	Switch $aCurrent[8]
		Case 0
			WinSetOnTop ("EasyWorship Timer","",0)
		Case 1
			WinSetOnTop ("EasyWorship Timer","",1)
	EndSwitch



EndFunc     ;==>_SetGUI


Func _12Hour($iHr)
    Switch $iHr
        Case 0
            Return 12
        Case 13 To 23
            Return $iHr - 12
        Case Else
            Return $iHr
    EndSwitch
EndFunc   ;==>_12Hour

Func _LoadIni()
	; 1=Hour 2=Min 3=Sec 4=ButtonRadio 5=SecondEnable 6=SecondRadio 7=CloseEnd 8=OnTop
    Dim $aRet[9] = [ 8, 9, 45, 00, 1, 0, 2, 1, 1]
    For $i = 1 To $aRet[0]
        $aRet[$i] = IniRead($Ini, "Time", $i, $aRet[$i])
    Next
    Return $aRet
EndFunc   ;==>_LoadIni


Func _WriteIni()
	; 1=Hour 2=Min 3=Sec 4=ButtonRadio 5=SecondEnable 6=SecondRadio 7=CloseEnd 8=OnTop

    $aCurrent[1] = GUICtrlRead($ComboHour)
    $aCurrent[2] = GUICtrlRead($ComboMin)
	$aCurrent[3] = GUICtrlRead($ComboSec)
        Select
			Case GUICtrlRead($Radio1) = 1
				$aCurrent[4] = 1
			Case GUICtrlRead($Radio2) = 1
				$aCurrent[4] = 2
			Case GUICtrlRead($Radio3) = 1
				$aCurrent[4] = 3
		EndSelect
		If GUICtrlRead ( $Checkbox1 ) = 1 Then
			$aCurrent[5] = 1
		Else
			$aCurrent[5] = 0
		EndIf
		Select
			Case GUICtrlRead($Radio4) = 1
				$aCurrent[6] = 1
			Case GUICtrlRead($Radio5) = 1
				$aCurrent[6] = 2
			Case GUICtrlRead($Radio6) = 1
				$aCurrent[6] = 3
		EndSelect
		If GUICtrlRead ( $Checkbox2 ) = 1 Then
			$aCurrent[7] = 1
		Else
			$aCurrent[7] = 0
		EndIf
		If GUICtrlRead ( $Checkbox3 ) = 1 Then
			$aCurrent[8] = 1
		Else
			$aCurrent[8] = 0
		EndIf

	    For $i = 1 To $aCurrent[0] - 1
            IniWrite($Ini, "Time", $i, $aCurrent[$i])
        Next
EndFunc   ;==>_WriteIni

Func _CheckAlarm()
	GUICtrlSetData ($Label7, _12Hour(@HOUR) & ":" & @MIN & "." & @SEC)
    If $aCurrent[1] = _12Hour(@HOUR) And $aCurrent[2] = @MIN And $aCurrent[3] = @SEC Then _PlayAlarm()
EndFunc   ;==>_CheckAlarm

Func _PlayAlarm()
	AdlibUnRegister("_CheckAlarm")
	; 1=Hour 2=Min 3=Sec 4=ButtonRadio 5=SecondEnable 6=SecondRadio 7=CloseEnd 8=OnTop

	MsgBox(1,"aCurrent 4",$aCurrent[4],1)
	Switch $aCurrent[4]
		Case 1
			WinActivate ($EW)
			ControlClick($EW, "", "TsdSpeedButton8")
		Case 2
			WinActivate ($EW)
			ControlClick($EW, "", "TsdSpeedButton6")
		Case 3
			WinActivate ($EW)
			ControlClick($EW, "", "TsdSpeedButton3")
			;WinMenuSelectItem ($EW,"Live","Show Live Output")
	EndSwitch
	If GUICtrlRead($Checkbox1) = 1 Then
		Switch $aCurrent[6]
			Case 1
				WinActivate ($EW)
				ControlClick($EW, "Go Live", "TsdSpeedButton8")
			Case 2
				WinActivate ($EW)
				ControlClick($EW, "Logo", "TsdSpeedButton6")
			Case 3
				WinActivate ($EW)
				ControlClick($EW, "Live", "TsdSpeedButton3")
		EndSwitch
	EndIf
	If GUICtrlRead($Checkbox2) = 1 Then
		_WriteIni()
		Exit
	EndIf
EndFunc   ;==>_PlayAlarm


