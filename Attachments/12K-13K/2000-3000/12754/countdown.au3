#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.2.2.0
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstants.au3>
#include <date.au3>

usr_chkini()

$nowdd=@mday
$nowmm=@mon
$nowyyyy=@year

$dd=IniRead("countdown.ini", "Date", "dd", "22")
$mm=IniRead("countdown.ini", "Date", "mm", "10")
$yyyy=IniRead("countdown.ini", "Date", "yyyy", "2010")
$time=IniRead("countdown.ini", "Date", "time", _NowTime(5))
$future=$yyyy&"/"&$mm&"/"&$dd&" "&$time





#Region ### START Koda GUI section ### Form=C:\Documents and Settings\b00b27\Desktop\time\gui.kxf
$Form2 = GUICreate("Countdown", 357, 203, 303, 219)
GUISetIcon("D:\009.ico")
$GroupBox1 = GUICtrlCreateGroup("", 8, 8, 257, 185)
$Label1 = GUICtrlCreateLabel("Today:", 16, 28, 37, 17)
$Label2 = GUICtrlCreateLabel("Countdown to:", 18, 48, 73, 17)
$Label3 = GUICtrlCreateLabel("Days:", 18, 88, 31, 17)
$Label4 = GUICtrlCreateLabel("Hours:", 18, 108, 35, 17)
$Label5 = GUICtrlCreateLabel("Minutes:", 18, 128, 44, 17)
$Label6 = GUICtrlCreateLabel("Seconds:", 18, 148, 49, 17)
$Label7 = GUICtrlCreateLabel("", 108, 28, 150, 17)

$inputnowdd = GUICtrlCreateInput("dd", 108, 28, 25, 21)
$inputnowmm = GUICtrlCreateInput("mm", 143, 28, 25, 21)
$inputnowyyyy = GUICtrlCreateInput("yyyy", 178, 28, 30, 21)



$inputdd = GUICtrlCreateInput("dd", 108, 48, 25, 21)
$inputmm = GUICtrlCreateInput("mm", 143, 48, 25, 21)
$inputyyyy = GUICtrlCreateInput("yyyy", 178, 48, 30, 21)

$resultdays = GUICtrlCreateInput("days", 108, 88, 100, 21)
$resulthours = GUICtrlCreateInput("hours", 108, 108, 100, 21)
$resultminutes = GUICtrlCreateInput("minutes", 108, 128, 100, 21)
$resultseconds = GUICtrlCreateInput("seconds", 108, 148, 100, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("&Set", 272, 16, 75, 25, 0)
$Button2 = GUICtrlCreateButton("&Exit", 272, 48, 75, 25, 0)

;GUICtrlSetData($Label7,$datetoday)
GUICtrlSetData($inputnowdd, $nowdd)
GUICtrlSetData($inputnowmm, $nowmm)
GUICtrlSetData($inputnowyyyy, $nowyyyy)

GUICtrlSetData($inputdd, $dd)
GUICtrlSetData($inputmm, $mm)
GUICtrlSetData($inputyyyy, $yyyy)



GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$calcdd=abs(_DateDiff('d', $future, _NowCalc()))
	$calchours=abs(_DateDiff('h', $future, _NowCalc()))
	$calcminutes=abs(_DateDiff('n', $future, _NowCalc()))
	$calcseconds=abs(_DateDiff('s', $future, _NowCalc()))
	GUICtrlSetData($resultdays, $calcdd)
	GUICtrlSetData($resulthours, $calchours)
	GUICtrlSetData($resultminutes, $calcminutes)
	GUICtrlSetData($resultseconds, $calcseconds)
	$nMsg = GUIGetMsg()

	Select
		Case $nMsg=$GUI_EVENT_CLOSE Or $nMsg=$Button2
			Exit



		Case $nMsg=$Button1
			usr_setdate()
			
		case _NowCalc() = $future
			usr_itstime()
	EndSelect
WEnd





func usr_chkini()
	If FileExists("countdown.ini") Then

	Else
		MsgBox(48,"Error", "Ini file does not exist. Restart script")
		iniwrite("countdown.ini", "Date", "dd", "22")
		iniwrite("countdown.ini", "Date", "mm", "10")
		iniwrite("countdown.ini", "Date", "yyyy", "2010")
		iniwrite("countdown.ini", "Date", "time", _NowTime(5))
		Exit
	EndIf
EndFunc

Func usr_setdate()
	$dd=GUICtrlRead($inputdd)
	$mm=GUICtrlRead($inputmm)
	$yyyy=GUICtrlRead($inputyyyy)
	iniwrite("countdown.ini", "Date", "dd", $dd)
	iniwrite("countdown.ini", "Date", "mm", $mm)
	iniwrite("countdown.ini", "Date", "yyyy", $yyyy)
	IniWrite("countdown.ini", "Date", "time", _NowTime(5))
	
	$dd=IniRead("countdown.ini", "Date", "dd", "22")
	$mm=IniRead("countdown.ini", "Date", "mm", "10")
	$yyyy=IniRead("countdown.ini", "Date", "yyyy", "2010")
	$time=IniRead("countdown.ini", "Date", "time", "00:00:00")
	$future=$yyyy&"/"&$mm&"/"&$dd&" "&$time


EndFunc


func usr_itstime()
	MsgBox(64, "It's time", "Italie, here I come!")
	EndFunc