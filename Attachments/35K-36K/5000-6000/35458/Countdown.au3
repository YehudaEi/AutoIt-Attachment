;
; Countdown.au3
; Created by William Reithmeyer (BillTheCreator)
;
; version 1
;
; Have as many count-downs as you'd like. You can change the max number below
; The numbers fade from dark to light. The higher the number the darker.
; To create an event count down, click on the link on the bottom of the GUI.
; If you dont see the link, it is becuase you have the max amount of countdowns already.
;
; You can edit the countdown after you created one. Click on the Edit button under the corrisponding numbers.
;
; Please use script as a learning experience
;
#include <Date.au3>
#include <Color.au3>
#include "GUICtrlOnHover.au3"
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <GuiDateTimePicker.au3>

Opt('MustDeclareVars', 1)

Global Const $Def_Font = "Century Gothic"

Global $Elements = 5
; Set this number to the amount of events you want. Depending on your screen resolutioin, you might want to keep it small

Global $Secs, $Mins, $Hours, $Days, $iTicks

Global $DaysLabel[$Elements+1], _
	   $HoursLabel[$Elements+1], _
	   $MinutesLabel[$Elements+1], _
	   $SecondsLabel[$Elements+1]

Global $Delete_Event[$Elements+1], _
	   $Edit_Event[$Elements+1], _
	   $Delete_Yes[$Elements+1], _
	   $Delete_No[$Elements+1]

Global $nMsg, $New_Countdown, $mPos, $cPos
Global $NoEvents = False

Global $Event = IniReadSectionNames("countdownIni.ini")
; read the amound of events
If @error Then
	Global $Event[2] = [1, 1]; shows items empty
	$NoEvents = True
	; this is set to true to hide the Delete and Edit button, because there is nothing to edit/delete
EndIf

Global $EventName, $EventDate, $EventTime

Global $ConstHeight = 140
; this is used to space out the events.

Global $GUI_Height = ($ConstHeight * $Event[0]) + 25
; this is used to determin the height of the GUI

If $Event[0] = $Elements Then $GUI_Height = $GUI_Height -21
; if your events max out, shorten the GUI by 25 pixels, and the "Create New" link will hide

Global $Countdown_GUI = GUICreate("Countdown", 735, $GUI_Height, -1, -1)

	GUISetFont(14, 400, 0, $Def_Font)
	GUISetBkColor(0xFFFFFF)
	GUICtrlSetDefColor(0xDEDEDE)


For $x = 1 To $Event[0]

	GUICtrlCreateGroup(IniRead("countdownIni.ini", $Event[$x], "EventName", "") , 5 , 2 + (($x-1) * $ConstHeight), 725, 137)

	GUICtrlCreateLabel("Days",    125, 72 + (($x-1) * $ConstHeight), 45, 28)
	_GUICtrl_OnHoverRegister(-1, "_Hover_2", "_Hover_2", "_Change_Color")
	GUICtrlCreateLabel("Hours",   289, 72 + (($x-1) * $ConstHeight), 55, 28)
	_GUICtrl_OnHoverRegister(-1, "_Hover_2", "_Hover_2", "_Change_Color")
	GUICtrlCreateLabel("Minutes", 461, 72 + (($x-1) * $ConstHeight), 70, 28)
	_GUICtrl_OnHoverRegister(-1, "_Hover_2", "_Hover_2", "_Change_Color")
	GUICtrlCreateLabel("Seconds", 641, 72 + (($x-1) * $ConstHeight), 79, 28)
	_GUICtrl_OnHoverRegister(-1, "_Hover_2", "_Hover_2", "_Change_Color")

	$DaysLabel[$x] 		= GUICtrlCreateLabel("0", 13,  30 + (($x-1) * $ConstHeight), 108, 78, $SS_RIGHT)
	GUICtrlSetFont(-1, 48)

	$HoursLabel[$x] 	= GUICtrlCreateLabel("0", 177, 30 + (($x-1) * $ConstHeight), 108, 78, $SS_RIGHT)
	GUICtrlSetFont(-1, 48)

	$MinutesLabel[$x] 	= GUICtrlCreateLabel("0", 349, 30 + (($x-1) * $ConstHeight), 108, 78, $SS_RIGHT)
	GUICtrlSetFont(-1, 48)

	$SecondsLabel[$x] 	= GUICtrlCreateLabel("0", 529, 30 + (($x-1) * $ConstHeight), 108, 78, $SS_RIGHT)
	GUICtrlSetFont(-1, 48)

	$Delete_Event[$x] 	= GUICtrlCreateLabel("Delete", 12, 110 + (($x-1) * $ConstHeight), Default, 21)
	GUICtrlSetFont(-1, 12)
	GUICtrlSetCursor(-1, 0)
	_GUICtrl_OnHoverRegister(-1, "_Hover_Func", "_Hover_Func")

	$Delete_Yes[$x] 	= GUICtrlCreateLabel("Yes", 12, 110 + (($x-1) * $ConstHeight), Default, 21)
	GUICtrlSetFont(-1, 12)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetState(-1, $GUI_HIDE)
	_GUICtrl_OnHoverRegister(-1, "_Hover_Func", "_Hover_Func")

	$Delete_No[$x] 	= GUICtrlCreateLabel("No", 58, 110 + (($x-1) * $ConstHeight), Default, 21)
	GUICtrlSetFont(-1, 12)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetState(-1, $GUI_HIDE)
	_GUICtrl_OnHoverRegister(-1, "_Hover_Func", "_Hover_Func")

	$Edit_Event[$x] 	= GUICtrlCreateLabel("Edit", 80, 110 + (($x-1) * $ConstHeight), Default, 21)
	GUICtrlSetFont(-1, 12)
	GUICtrlSetCursor(-1, 0)
	_GUICtrl_OnHoverRegister(-1, "_Hover_Func", "_Hover_Func")

	If $NoEvents Then ; hide if true
		GUICtrlSetState($Delete_Event[$x], $GUI_HIDE)
		GUICtrlSetState($Edit_Event[$x], $GUI_HIDE)
	EndIf

	GUICtrlCreateGroup("", -99, -99, 1, 1)
Next
_Countdown()

$New_Countdown = GUICtrlCreateLabel("Create New Event", 5, $ConstHeight + (($Event[0]-1) * $ConstHeight), 725, 21, $SS_CENTER)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetColor(-1, 0x3399FF)
	GUICtrlSetBkColor(-1, 0xFAFAFA)
	_GUICtrl_OnHoverRegister(-1, "_Hover_Func", "_Hover_Func")

If $Event[0] = $Elements Then GUICtrlSetState(-1, $GUI_HIDE)
; hide if you're not allowed to create more

GUISetState(@SW_SHOW)

AdlibRegister("_Countdown", 1000)
; run the countdown every second

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $New_Countdown
			_Create_Countdown($Countdown_GUI, "Type Event Name Here", _NowCalc(), _NowTime())
			; create new event

		Case $Delete_Event[1] To $Edit_Event[$Event[0]]
			For $f = 1 To $Event[0]
				If $nMsg = $Delete_Event[$f] Then
					; did you click on the delete link?
					GUICtrlSetState($Delete_Yes[$f], $GUI_SHOW)
					GUICtrlSetState($Delete_No[$f], $GUI_SHOW)

					GUICtrlSetState($Delete_Event[$f], $GUI_HIDE)
					GUICtrlSetState($Edit_Event[$f], $GUI_HIDE)
				EndIf

				If $nMsg = $Delete_Yes[$f] Then
					; if you click on the yes, after you click delete
					IniDelete("countdownIni.ini", $Event[$f])
					_RestartScript()

				EndIf

				If $nMsg = $Delete_No[$f] Then
					; if you click on the no, after you click delete
					GUICtrlSetState($Delete_Yes[$f], $GUI_HIDE)
					GUICtrlSetState($Delete_No[$f], $GUI_HIDE)

					GUICtrlSetState($Delete_Event[$f], $GUI_SHOW)
					GUICtrlSetState($Edit_Event[$f], $GUI_SHOW)

				EndIf

				If $nMsg = $Edit_Event[$f] Then
					; did you click on the edit link?
					_Create_Countdown(	$Countdown_GUI, _
										IniRead("countdownIni.ini", $Event[$f], "EventName", "Event " & $f), _
										StringTrimRight(IniRead("countdownIni.ini", $Event[$f], "dateStart", _NowCalc()), 9), _
										StringTrimLeft (IniRead("countdownIni.ini", $Event[$f], "dateStart", _NowTime()), 11), _
										True)
				EndIf
			Next
	EndSwitch
WEnd
;
Func _Create_Countdown($gui_hndl, $EventName, $EventDate, $EventTime, $Edit = False)
	GUISetState(@SW_DISABLE, $gui_hndl)
	; disable parent to restrict multiple edits

	Local $GUI_Title = "Create New Event"

	If $Edit Then $GUI_Title = "Edit " & $EventName
	; change the name if in edit mode

	Local $aRange[14] = [True, @YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC, True, @YEAR+2, 12, 31, 23, 59, 59]

	Local $GUI_Pos = WinGetPos($gui_hndl)
	; get GUI details to center this GUI with parent

	Local $x_p, $y_p

	$x_p = ($GUI_Pos[2] - 512)/2 + $GUI_Pos[0]
	$y_p = ($GUI_Pos[3] - 204)/2 + $GUI_Pos[1]
	; used to center this window with parent

	Local $Create_GUI	= GUICreate($GUI_Title, 512, 204, $x_p, $y_p)
		GUISetFont(11, 400, 0, $Def_Font)
		GUISetBkColor(0xFFFFFF)

	GUICtrlCreateLabel("Event Name:", 19, 16, 139, 24)
	GUICtrlCreateLabel("Date:", 19, 80, 44, 24)
	GUICtrlCreateLabel("Time:", 354, 80, 39, 24)

	Local $Event_Name = GUICtrlCreateInput($EventName, 17, 44, 477, 28)

	Local $Event_Date = GUICtrlCreateDate($EventDate, 19, 108, 314, 28)
		_GUICtrlDTP_SetRange (GUICtrlGetHandle($Event_Date), $aRange)
		_GUICtrlDTP_SetFormat(GUICtrlGetHandle($Event_Date), "yyyy/MM/dd")

	Local $Event_Time = GUICtrlCreateDate($EventTime, 354, 108, 140, 28, BitOR($DTS_UPDOWN,$DTS_TIMEFORMAT,$WS_TABSTOP))

	Local $Create_OK 		= GUICtrlCreateButton("OK", 336, 160, 75, 25, $WS_GROUP)
	Local $Create_Cancel	= GUICtrlCreateButton("Cancel", 421, 160, 75, 25, $WS_GROUP)


	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $Create_Cancel
				GUIDelete($Create_GUI)
				GUISetState(@SW_ENABLE, $gui_hndl)
				GUISetState(@SW_RESTORE, $gui_hndl)
				ExitLoop

			Case $Create_OK

				For $e = 1 To $Event[0]
					If $Edit Then
						If IniRead("countdownIni.ini", $Event[$e], "EventName", GUICtrlRead($Event_Name)) = $EventName Then
							; is what you're editing in the INI file. Based on the Event Name. If different, will create new.
							IniRenameSection ("countdownIni.ini", $Event[$e], GUICtrlRead($Event_Name))
						EndIf
					EndIf
				Next

				If $Edit And GUICtrlRead($Event_Name) = $EventName And GUICtrlRead($Event_Date) = $EventDate And GUICtrlRead($Event_Time) = $EventTime Then
					; if in edit mode and no change, dont restart, just leave.
					GUIDelete($Create_GUI)
					GUISetState(@SW_ENABLE, $gui_hndl)
					GUISetState(@SW_RESTORE, $gui_hndl)
					ExitLoop
				EndIf

				IniWrite("countdownIni.ini", GUICtrlRead($Event_Name), "dateStart", GUICtrlRead($Event_Date) & " " & GUICtrlRead($Event_Time))
				IniWrite("countdownIni.ini", GUICtrlRead($Event_Name), "EventName", GUICtrlRead($Event_Name))

				_RestartScript()
		EndSwitch
	WEnd
EndFunc
;
Func _Countdown()
	Local $GetSeconds

	For $c = 1 To $Event[0]
		; cycle through events

		$GetSeconds = _DateDiff( 's',_NowCalc(), IniRead("countdownIni.ini", $Event[$c], "dateStart", _NowCalc()))
		; grab seconds of difference from now to future date

		_Ticks_To_Time($GetSeconds, $Days, $Hours, $Mins, $Secs)
		; convert seconds to days/hours/minutes/seconds

		; set color and data
		_GUICtrlSetDataAndColor($DaysLabel[$c],    $Days)
		_GUICtrlSetDataAndColor($HoursLabel[$c],  $Hours)
		_GUICtrlSetDataAndColor($MinutesLabel[$c], $Mins)
		_GUICtrlSetDataAndColor($SecondsLabel[$c], $Secs, 1)
	Next
EndFunc
;
Func _Ticks_To_Time($iSeconds, ByRef $iDays, ByRef $iHours, ByRef $iMins, ByRef $iSecs)
	; second conversion.

	; modified: added days.
	If Number($iSeconds) > 0 Then
		$iDays =  Int($iSeconds / 86400)

		$iSeconds = Mod($iSeconds, 86400)
		$iHours = Int($iSeconds / 3600)

		$iSeconds = Mod($iSeconds, 3600)
		$iMins = Int($iSeconds / 60)

		$iSecs = Mod($iSeconds, 60)
		Return 1
	ElseIf Number($iTicks) <= 0 Then
		$iSeconds = 0
		$iDays = 0
		$iHours = 0
		$iMins = 0
		$iSecs = 0
		Return 1
	Else
		Return SetError(1,0,0)
	EndIf
EndFunc   ;==>_TicksToTime
;
Func _RestartScript()
    If @Compiled = 1 Then
        Run( FileGetShortName(@ScriptFullPath))
    Else
        Run( FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
    Exit
EndFunc
;
Func _GUICtrlSetDataAndColor($hndl, $val, $shade = 0)
	Local $col = 3 * $val
	$col =  Hex(0xDE - $col, 2)
	; high number is more darker
	; closer to 0 the lighter

	Local $Red = $col ; default black
	Local $Green = $col ; default black
	Local $Blue = $col ; default black

	Switch $shade
		Case 1 ; Red
			$Red = "FF"
		Case 2 ; Green
			$Green = "FF"
		Case 3 ; Blue
			$Blue = "FF"
	EndSwitch

	If GUICtrlRead($hndl) <> $val Then
		; if data is different then change. helps with flickering
		GUICtrlSetData($hndl, $val)
		GUICtrlSetColor($hndl, "0x" & $Red & $Green & $Blue)

		If $val > 1000 Then
			GUICtrlSetFont($hndl, 30)
		Else
			GUICtrlSetFont($hndl, 48)
		EndIf

	EndIf

EndFunc
;
Func _Hover_Func($iCtrlID, $iParam)
	; if hovered
	Local $color = 0xEEEEEE
	Local $color_2 = 0x3399FF
	Local $color_3 = $color_2
	Local $style = 4

	If $iParam = 2 Then ; not hovered
		$color = 0x3399FF
		$color_2 = 0xDEDEDE
		$color_3 = 0xFAFAFA
		$style = 0
	EndIf

	Switch $iCtrlID
		Case $New_Countdown
			GUICtrlSetBkColor($iCtrlID, $color_3)
			GUICtrlSetColor($iCtrlID, $color)
;~ 			GUICtrlSetFont($iCtrlID, Default, Default, $style)
		Case Else
			GUICtrlSetFont($iCtrlID, 12, Default, $style)
			GUICtrlSetColor($iCtrlID, $color_2)
	EndSwitch
EndFunc
;
Func _Hover_2($iCtrlID, $iParam)
	Local $color = 0xA8A8A8

	If $iParam = 2 Then
		$color = 0xDEDEDE
	EndIf

	GUICtrlSetColor($iCtrlID, $color)
EndFunc
