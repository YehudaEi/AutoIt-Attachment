#include <GUIConstants.au3>
#include <array.au3>
Opt("GUIOnEventMode",1)     

$V1 = "Reminder ExtraOrdinaire by ...copyright "&Chr(169)&' 2006'

$Reminder01 = GUICreate($V1, 780, 380)
GUISetOnEvent($GUI_EVENT_CLOSE, "Getout")
GUISetBkColor(0x000080)

GUICtrlCreateLabel("Event", 15, 20, 85, 21, BitOR($SS_CENTER,$WS_GROUP))	;create event label
GUICtrlSetTip(-1, "Enter the event for which you wanted to be reminded...")
GUICtrlSetFont(-1, 10, 800, 0, "Garamond")
GUICtrlSetBkColor(-1, 0x00FFFF)

GUICtrlCreateLabel("Date", 15, 72, 85, 21, BitOR($SS_CENTER,$WS_GROUP))	;create date label
GUICtrlSetTip(-1, "Select date from calendar...")
GUICtrlSetFont(-1, 10, 800, 0, "Garamond")
GUICtrlSetBkColor(-1, 0x00FFFF)

GUICtrlCreateLabel("AdvNotice", 15, 128, 85, 21, BitOR($SS_CENTER,$WS_GROUP))	;create adance notice label
GUICtrlSetTip(-1, "Select amount of advance notice from dropdown or enter the number of days...")
GUICtrlSetFont(-1, 10, 800, 0, "Garamond")
GUICtrlSetBkColor(-1, 0x00FFFF)

GUICtrlCreateLabel("Frequency", 15, 183, 85, 21, BitOR($SS_CENTER,$WS_GROUP))	;create frequency label
GUICtrlSetTip(-1, "Select a repeat frequency from dropdown or enter number of days...")
GUICtrlSetFont(-1, 10, 800, 0, "Garamond")
GUICtrlSetBkColor(-1, 0x00FFFF)

GUICtrlCreateLabel("Comments", 15, 228, 85, 21, BitOR($SS_CENTER,$WS_GROUP))	;create comments label
GUICtrlSetTip(-1, "Enter comments...")
GUICtrlSetFont(-1, 10, 800, 0, "Garamond")
GUICtrlSetBkColor(-1, 0x00FFFF)

$MthCal = GUICtrlCreateMonthCal("2006/06/21", 524, 17, 235, 190, $WS_GROUP)	;create calendar
GUICtrlSetOnEvent(-1, "DateSelected")
GUICtrlSetTip(-1, "Select date...")

$Input1 = GUICtrlCreateInput("", 105, 18, 400, 24, BitOR($ES_AUTOHSCROLL,$WS_GROUP))	;create event field
GUICtrlSetOnEvent(-1, "Input1Enter")
GUICtrlSetTip(-1, "Enter the event for which you wanted to be reminded...")
GUICtrlSetFont(-1, 12, 800, 0, "Garamond")

$Input2 = GUICtrlCreateInput("", 105, 70, 400, 24, BitOR($ES_AUTOHSCROLL,$WS_GROUP))	;create date field
;GUICtrlSetOnEvent(-1, "Input2Enter")
GUICtrlSetTip(-1, "Select date from calendar...")
GUICtrlSetFont(-1, 12, 800, 0, "Garamond")

;$Combo1 = GUICtrlCreateCombo("", 105, 124, 400, 240, BitOR($CBS_DROPDOWNlist,$CBS_AUTOHSCROLL,$WS_GROUP))	;create advance notice field
$Combo1 = GUICtrlCreateCombo("", 105, 124, 400, 240, BitOR($CBS_DROPDOWNlist,$WS_GROUP))	;create advance notice field
GUICtrlSetOnEvent(-1, "Combo1Enter")
GUICtrlSetTip(-1, "Select amount of advance notice from dropdown or enter the number of days...")
GUICtrlSetFont(-1, 12, 800, 0, "Garamond")
GUICtrlSetData(-1, "30 days|15 days|7 days|3 days|1 day")

$Combo2 = GUICtrlCreateCombo("", 105,179, 400, 240, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL,$WS_GROUP))	;create frequency field
GUICtrlSetOnEvent(-1, "Combo2Enter")
GUICtrlSetTip(-1, "Select a repeat frequency from dropdown or enter number of days...")
GUICtrlSetFont(-1, 12, 800, 0, "Garamond")
GUICtrlSetData(-1, "Annually|Semi-annually|Quarterly|Monthly|Weekly|OneTime")

;$Edit1 = GUICtrlCreateEdit("", 105, 226, 654, 80, BitOR($ES_WANTRETURN,$WS_GROUP,$ES_MULTILINE,$WS_TABSTOP,$WS_VSCROLL))
$Edit1 = GUICtrlCreateEdit("", 105, 226, 654, 80, BitOR($WS_GROUP,$ES_MULTILINE,$WS_TABSTOP,$WS_VSCROLL))
GUICtrlSetOnEvent(-1, "Edit1Enter")
GUICtrlSetTip(-1, "Enter comments...")
GUICtrlSetFont(-1, 12, 800, 0, "Garamond")

GUICtrlSetState($Input1,$GUI_FOCUS)	;set focus to event field
GUISetState(@SW_SHOW)

While 1
	Sleep(1)
WEnd

Func Input1Enter()
	GUICtrlSetState($Input2,$GUI_FOCUS)	
EndFunc

Func Input2Enter()
	GUICtrlSetState($Combo1,$GUI_FOCUS)	
EndFunc

Func Combo1Enter()
	GUICtrlSetState($Combo2,$GUI_FOCUS)	
	MsgBox(0, "TestStop", "ID=" & @GUI_CTRLID & " WinHandle=" & @GUI_WINHANDLE & " CtrlHandle=" & @GUI_CTRLHANDLE)
	;MsgBox(0,'TestStop','1')	
EndFunc

Func Combo2Enter()
	GUICtrlSetState($Edit1,$GUI_FOCUS)	
EndFunc

Func Edit1Enter()
	;GUICtrlSetState($Btn4,$GUI_FOCUS)	
EndFunc

Func Getout()
	GUIDelete()
	Exit
EndFunc	

Func DateSelected()	;date selected from calendar
	$ODate=GUICtrlRead($MthCal)
	$NDate=StringMid($ODate,6,2)&'/'&StringRight($ODate,2)&'/'&StringLeft($ODate,4)
	GUICtrlSetData($Input2,$NDate)
	;MsgBox(0,'TestStop',$NDate)	
	GUICtrlSetState($Combo1,$GUI_FOCUS)	
EndFunc

