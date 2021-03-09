#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <Date.au3>
#include <Array.au3>
#include <Misc.au3>
#include <WindowsConstants.au3>

#include <WinAPI.au3>
#include <APIConstants.au3>



GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUIRegisterMsg($WM_SIZE, "WM_SIZE")


;Max weeks in a months is 6, then initialize the array with 6*7 days
Global Const $__CAL_MAXWEEKS = 6

;Kind of day constants:
Global Const $__CAL_DAYKINDOF_WEEKDAY = 1
Global Const $__CAL_DAYKINDOF_WEEKEND = 2
Global Const $__CAL_DAYKINDOF_OTHERMONTH = 3
Global Const $__CAL_DAYKINDOF_TODAY = 4

;Variables
Global $__CAL_WIDTH ;Calendar Width
Global $__CAL_HEIGHT ;Calendar Height
Global $__CAL_POSX ;Calendar Position X
Global $__CAL_POSY ;Calendar Position Y
Global $__CAL_CURSELMONTH ;Currently displayed Month
Global $__CAL_CURSELYEAR ;Currently displayed Year
Global $__CAL_CURSELDATE ;Currently selected Date in calendar (YYYY/MM/DD)
Global $__CAL_CURSELDATEKINDOF ;Kind of Currently selected Date in calendar (week day, weekend...)
Global $__CAL_CURSELCTRLID ;Currently selected control in calendar
Global $__CAL_MENUHEIGHT ;Menu Height
Global $__CAL_GRIDSIZE ;Grid Size
Global $__CAL_STARTONMONDAY ;True: Start on monday | False: Start on sunday
Global $__CAL_CALHEIGH ;Calendar area height
Global $__CAL_ONDATEDBLCLICKCALL ;Function registered on date clicked
Global $__CAL_CTRLIDMENU ;Control ID: Menu
Global $__CAL_CTRLIDBTNPREV ;Control ID: Button go to previous month
Global $__CAL_CTRLIDBTNNEXT ;Control ID: Button go to Next month
Global $__CAL_CTRLIDBG ;Control ID: Background
Global $__CAL_RESIZEFLAGS ;Resize
Global $__CAL_CTRLIDDAY1 ;Control ID: Menu Day 1
Global $__CAL_CTRLIDDAY2 ;Control ID: Menu Day 2
Global $__CAL_CTRLIDDAY3 ;Control ID: Menu Day 3
Global $__CAL_CTRLIDDAY4 ;Control ID: Menu Day 4
Global $__CAL_CTRLIDDAY5 ;Control ID: Menu Day 5
Global $__CAL_CTRLIDDAY6 ;Control ID: Menu Day 6
Global $__CAL_CTRLIDDAY7 ;Control ID: Menu Day 7
;Color:
Global $__CAL_COLOR_MENUBG = 0xC3D9FF
Global $__CAL_COLOR_MENUFG = 0x002E7E
Global $__CAL_COLOR_WEEKBG = 0xFFFFFF
Global $__CAL_COLOR_WEEKFG = 0x000000
Global $__CAL_COLOR_WEEKENDBG = 0xE8EEF7
Global $__CAL_COLOR_WEEKENDFG = 0x000000
Global $__CAL_COLOR_OTHERMONTHBG = 0xC3D9FF
Global $__CAL_COLOR_OTHERMONTHFG = 0x525252
Global $__CAL_COLOR_DAYSELECTBG = 0x76B8EC
Global $__CAL_COLOR_DAYSELECTFG = 0xFFFFFF
Global $__CAL_COLOR_DAYTODAYBG = 0xF9F9DA
Global $__CAL_COLOR_DAYTODAYFG = 0x000000
Global $__CAL_COLOR_EVENTBG = 0x316AC5
Global $__CAL_COLOR_EVENTFG = 0xFFFFFF
Global $__CAL_COLOR_GRIDBG = 0x316AC5


;$__aCALDAYS
;----------------------------------------
;$__aCALDAYS[0][0] = number of days maximum
;----------------------------------------
;$__aCALDAYS[n] = the day
;$__aCALDAYS[n][0] = Control ID
;$__aCALDAYS[n][1] = Date
;$__aCALDAYS[n][2] = Number of events this day
Global $__aCALDAYS[$__CAL_MAXWEEKS * 7 + 1][3] = [[$__CAL_MAXWEEKS * 7]]

;$__aEVENTS
;----------------------------------------
;$__aEVENTS[0][0] = Number of events
;----------------------------------------
;$__aEVENTS[n][0] = Event Date (YYYY/MM/DD)
;$__aEVENTS[n][1] = Event Text
;$__aEVENTS[n][2] = Event Control ID
Global $__aEVENTS[1][3] = [[0]]


; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_OnDateClickRegister
; Description ...:
; Syntax ........: _GuiCtrlCal_OnDateClickRegister($sFunction)
; Parameters ....: $sFunction           - A string value.
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_OnDateDblClickRegister($sFunction)
	$__CAL_ONDATEDBLCLICKCALL = $sFunction
EndFunc   ;==>_GuiCtrlCal_OnDateClickRegister

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_EventAdd
; Description ...:
; Syntax ........: _GuiCtrlCal_EventAdd($sText, $sDate)
; Parameters ....: $__aEVENTS             - An array of unknowns.
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_EventAdd($sDate, $sText)
	$__aEVENTS[0][0] += 1
	ReDim $__aEVENTS[$__aEVENTS[0][0] + 1][UBound($__aEVENTS, 2)]
	$__aEVENTS[$__aEVENTS[0][0]][0] = $sDate
	$__aEVENTS[$__aEVENTS[0][0]][1] = $sText
	$__aEVENTS[$__aEVENTS[0][0]][2] = _GuiCtrlCal_EventDraw($sDate, $sText)
	_ArraySort($__aEVENTS, 0, 1, $__aEVENTS[0][0], 0)
	_GuiCtrlCal_EventShow()
EndFunc   ;==>_GuiCtrlCal_EventAdd


; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_EventDraw
; Description ...:
; Syntax ........: _GuiCtrlCal_EventDraw($sDate, $sText)
; Parameters ....: $sDate               - A string value.
;                  $sText               - A string value.
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_EventDraw($sDate, $sText)
	;Event creation is here:
	Local $iCtrlID = GUICtrlCreateLabel($sText, 0, 0, 10, 10)
	GUICtrlSetBkColor($iCtrlID, $__CAL_COLOR_EVENTBG)
	GUICtrlSetColor($iCtrlID, $__CAL_COLOR_EVENTFG)
	GUICtrlSetState($iCtrlID, $GUI_HIDE)
	Return $iCtrlID
EndFunc   ;==>_GuiCtrlCal_EventDraw


; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_EventShowDateRange
; Description ...:
; Syntax ........: _GuiCtrlCal_EventShowDateRange($iYear, $iMonth)
; Parameters ....: none
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_EventShow()
	Local $iEventHeight = 15
	Local $iEventToday = 1

	For $i = 1 To $__aEVENTS[0][0]
		;by scanning $__aCALDAYS then we can auto filter the events by date.
		;get this date control ID and number of events:
		Local $iCtrlIDDate = _GuiCtrlCal_GetCtrlIDFromDate($__aEVENTS[$i][0])

		;check how many events there were this day:
		If $__aEVENTS[$i][0] = $__aEVENTS[$i - 1][0] Then
			$iEventToday += 1
		Else
			$iEventToday = 1
		EndIf

		;update the event position and visibility:
		If $iCtrlIDDate <> -1 Then

			Local $aPos = ControlGetPos(GUICtrlGetHandle($iCtrlIDDate), "", 0)
			If Not @error Then
				_WinAPI_MoveWindow(GUICtrlGetHandle($__aEVENTS[$i][2]), $aPos[0], $aPos[1] + ($iEventToday * $iEventHeight), $aPos[2], $iEventHeight)
				GUICtrlSetState($__aEVENTS[$i][2], $GUI_SHOW)
;~ 				GuiCtrlSetOnTop($__aEVENTS[$i][2])
			Else
				GUICtrlSetState($__aEVENTS[$i][2], $GUI_HIDE)
			EndIf
		Else
			GUICtrlSetState($__aEVENTS[$i][2], $GUI_HIDE)
		EndIf
	Next
EndFunc   ;==>_GuiCtrlCal_EventShow


; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_IsCalendarControl
; Description ...:
; Syntax ........: _GuiCtrlCal_IsCalendarControl($iCtrlID)
; Parameters ....: $iCtrlID             - An integer value.
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_IsCalendarControl($iCtrlID)
	For $i = 1 To $__aCALDAYS[0][0]
		If $__aCALDAYS[$i][0] = $iCtrlID Then
			Return $i
		EndIf
	Next
	Return -1
EndFunc   ;==>_GuiCtrlCal_IsCalendarControl

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_GetDayNumEvents
; Description ...:
; Syntax ........: _GuiCtrlCal_GetDayNumEvents($sDate)
; Parameters ....: $sDate               - A string value.
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_GetDayNumEvents($sDate)
	$iRet = 0
	For $i = 1 To $__aEVENTS[0][0]
		If $__aEVENTS[$i][0] = $sDate Then
			$iRet += 1
		EndIf
	Next
	Return $iRet
EndFunc   ;==>_GuiCtrlCal_GetDayNumEvents

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_GetCtrlIDFromDate
; Description ...:
; Syntax ........: _GuiCtrlCal_GetCtrlIDFromDate($sDate)
; Parameters ....: $sDate               - A string value.
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_GetCtrlIDFromDate($sDate)
	For $i = 1 To $__aCALDAYS[0][0]
		If $__aCALDAYS[$i][1] = $sDate Then
			Return $__aCALDAYS[$i][0]
		EndIf
	Next
	Return -1
EndFunc   ;==>_GuiCtrlCal_GetCtrlIDFromDate

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_GetDateFromCtrlID
; Description ...:
; Syntax ........: _GuiCtrlCal_GetDateFromCtrlID($iCtrlID)
; Parameters ....: $iCtrlID             - An integer value.
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_GetDateFromCtrlID($iCtrlID)
	For $i = 1 To $__aCALDAYS[0][0]
		If $__aCALDAYS[$i][0] = $iCtrlID Then
			Return $__aCALDAYS[$i][1]
		EndIf
	Next
	Return ""
EndFunc   ;==>_GuiCtrlCal_GetDateFromCtrlID

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_GetEventFromCtrlID
; Description ...:
; Syntax ........: _GuiCtrlCal_GetEventFromCtrlID($iCtrlID)
; Parameters ....: $iCtrlID             - An integer value.
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_GetEventFromCtrlID($iCtrlID)
	For $i = 1 To $__aEVENTS[0][0]
		If $__aEVENTS[$i][2] = $iCtrlID Then
			Return $__aEVENTS[$i][1]
		EndIf
	Next
	Return ""
EndFunc   ;==>_GuiCtrlCal_GetEventFromCtrlID

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_Destroy
; Description ...:
; Syntax ........: _GuiCtrlCal_Destroy()
; Parameters ....:
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_Destroy()
	For $i = 0 To UBound($__aCALDAYS) - 1
		GUICtrlDelete($__aCALDAYS[$i][0])
	Next
	GUICtrlDelete($__CAL_CTRLIDBG)
	GUICtrlDelete($__CAL_CTRLIDBTNPREV)
	GUICtrlDelete($__CAL_CTRLIDBTNNEXT)
	GUICtrlDelete($__CAL_CTRLIDDAY1)
	GUICtrlDelete($__CAL_CTRLIDDAY2)
	GUICtrlDelete($__CAL_CTRLIDDAY3)
	GUICtrlDelete($__CAL_CTRLIDDAY4)
	GUICtrlDelete($__CAL_CTRLIDDAY5)
	GUICtrlDelete($__CAL_CTRLIDDAY6)
	GUICtrlDelete($__CAL_CTRLIDDAY7)

	_GuiCtrlCal_DestroyEvents()
EndFunc   ;==>_GuiCtrlCal_Destroy

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_DestroyEvents
; Description ...:
; Syntax ........: _GuiCtrlCal_DestroyEvents()
; Parameters ....:
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_DestroyEvents()
	For $i = 1 To $__aEVENTS[0][0]
		GUICtrlDelete($__aEVENTS[$i][2])
	Next
	$__aEVENTS[0][0] = 0
	ReDim $__aEVENTS[$__aEVENTS[0][0] + 1][UBound($__aEVENTS, 2)]
	Return 1
EndFunc   ;==>_GuiCtrlCal_DestroyEvents

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_SetGridSize
; Description ...:
; Syntax ........: _GuiCtrlCal_SetGridSize($iSize)
; Parameters ....: $iSize              - An integer value.
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_SetGridSize($iSize)
	$__CAL_GRIDSIZE = $iSize
EndFunc   ;==>_GuiCtrlCal_SetGridSize

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_SetStartMonday
; Description ...:
; Syntax ........: _GuiCtrlCal_SetStartMonday([$fStartOnMonday = True])
; Parameters ....: $fStartOnMonday      - [optional] A boolean value. Default is True.
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_SetStartMonday($fStartOnMonday = True)
	$__CAL_STARTONMONDAY = $fStartOnMonday
EndFunc   ;==>_GuiCtrlCal_SetStartMonday

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_SetSelectedDate
; Description ...:
; Syntax ........: _GuiCtrlCal_SetSelectedDate($sDate)
; Parameters ....: $sDate             - A string value.
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_SetSelectedDate($sDate)
	For $i = 1 To $__aCALDAYS[0][0]
		If $__aCALDAYS[$i][1] = $sDate Then
			Local $iColorBG, $iColorFG
			Switch $__CAL_CURSELDATEKINDOF
				Case $__CAL_DAYKINDOF_OTHERMONTH
					$iColorBG = $__CAL_COLOR_OTHERMONTHBG
					$iColorFG = $__CAL_COLOR_OTHERMONTHFG
				Case $__CAL_DAYKINDOF_TODAY
					$iColorBG = $__CAL_COLOR_DAYTODAYBG
					$iColorFG = $__CAL_COLOR_DAYTODAYFG
				Case $__CAL_DAYKINDOF_WEEKDAY
					$iColorBG = $__CAL_COLOR_WEEKBG
					$iColorFG = $__CAL_COLOR_WEEKFG
				Case $__CAL_DAYKINDOF_WEEKEND
					$iColorBG = $__CAL_COLOR_WEEKENDBG
					$iColorFG = $__CAL_COLOR_WEEKENDFG
			EndSwitch
			GUICtrlSetBkColor($__CAL_CURSELCTRLID, $iColorBG)
			GUICtrlSetColor($__CAL_CURSELCTRLID, $iColorFG)
			$__CAL_CURSELCTRLID = $__aCALDAYS[$i][0]
			$__CAL_CURSELDATE = $__aCALDAYS[$i][2]
			$__CAL_CURSELDATEKINDOF = $__aCALDAYS[$i][2]
			GUICtrlSetBkColor($__CAL_CURSELCTRLID, $__CAL_COLOR_DAYSELECTBG)
			GUICtrlSetColor($__CAL_CURSELCTRLID, $__CAL_COLOR_DAYSELECTFG)
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_GuiCtrlCal_SetSelectedDate

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_SetThemeDark
; Description ...:
; Syntax ........: _GuiCtrlCal_SetThemeDark()
; Parameters ....:
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_SetThemeDark()
	Global $__CAL_COLOR_GRIDBG = 0x000000
	Global $__CAL_COLOR_MENUBG = 0x222222
	Global $__CAL_COLOR_MENUFG = 0x828282
	Global $__CAL_COLOR_WEEKBG = 0x202020
	Global $__CAL_COLOR_WEEKFG = 0x828282
	Global $__CAL_COLOR_WEEKENDBG = 0x151515
	Global $__CAL_COLOR_WEEKENDFG = 0x828282
	Global $__CAL_COLOR_OTHERMONTHBG = 0x101010
	Global $__CAL_COLOR_OTHERMONTHFG = 0x525252
	Global $__CAL_COLOR_DAYSELECTBG = 0xFFCC00
	Global $__CAL_COLOR_DAYSELECTFG = 0xFFFFFF
	Global $__CAL_COLOR_DAYTODAYBG = 0x003300
	Global $__CAL_COLOR_DAYTODAYFG = 0xFFFFFF
	Global $__CAL_COLOR_EVENTBG = 0x00FF00
	Global $__CAL_COLOR_EVENTFG = 0xFFFFFF
	_GuiCtrlCal_Refresh()
	_GuiCtrlCal_RefreshMenuColors()
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_SetThemeBlue
; Description ...:
; Syntax ........: _GuiCtrlCal_SetThemeBlue()
; Parameters ....:
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_SetThemeBlue()
	Global $__CAL_COLOR_GRIDBG = 0x316AC5
	Global $__CAL_COLOR_MENUBG = 0xC3D9FF
	Global $__CAL_COLOR_MENUFG = 0x002E7E
	Global $__CAL_COLOR_WEEKBG = 0xFFFFFF
	Global $__CAL_COLOR_WEEKFG = 0x000000
	Global $__CAL_COLOR_WEEKENDBG = 0xE8EEF7
	Global $__CAL_COLOR_WEEKENDFG = 0x000000
	Global $__CAL_COLOR_OTHERMONTHBG = 0xC3D9FF
	Global $__CAL_COLOR_OTHERMONTHFG = 0x525252
	Global $__CAL_COLOR_DAYSELECTBG = 0x76B8EC
	Global $__CAL_COLOR_DAYSELECTFG = 0xFFFFFF
	Global $__CAL_COLOR_DAYTODAYBG = 0xF9F9DA
	Global $__CAL_COLOR_DAYTODAYFG = 0x000000
	Global $__CAL_COLOR_EVENTBG = 0x316AC5
	Global $__CAL_COLOR_EVENTFG = 0xFFFFFF
	_GuiCtrlCal_Refresh()
	_GuiCtrlCal_RefreshMenuColors()
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_Refresh
; Description ...:
; Syntax ........: _GuiCtrlCal_Refresh()
; Parameters ....:
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_Refresh()
	_GuiCtrlCal_GoToMonth($__CAL_CURSELYEAR, $__CAL_CURSELMONTH)
EndFunc   ;==>_GuiCtrlCal_Refresh

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_RefreshMenuColors
; Description ...:
; Syntax ........: _GuiCtrlCal_RefreshMenuColors()
; Parameters ....:
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_RefreshMenuColors()
	GUICtrlSetBkColor($__CAL_CTRLIDBG, $__CAL_COLOR_GRIDBG)
	GUICtrlSetBkColor($__CAL_CTRLIDMENU, $__CAL_COLOR_MENUBG)
	GUICtrlSetColor($__CAL_CTRLIDMENU, $__CAL_COLOR_MENUFG)
	GUICtrlSetBkColor($__CAL_CTRLIDBTNNEXT, $__CAL_COLOR_MENUBG)
	GUICtrlSetColor($__CAL_CTRLIDBTNNEXT, $__CAL_COLOR_MENUFG)
	GUICtrlSetBkColor($__CAL_CTRLIDBTNPREV, $__CAL_COLOR_MENUBG)
	GUICtrlSetColor($__CAL_CTRLIDBTNPREV, $__CAL_COLOR_MENUFG)
	For $i = 1 To 7 ;every day of the week
		GUICtrlSetBkColor(Eval("__CAL_CTRLIDDAY" & $i), $__CAL_COLOR_MENUBG)
		GUICtrlSetColor(Eval("__CAL_CTRLIDDAY" & $i), $__CAL_COLOR_MENUFG)
	Next
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_Create
; Description ...:
; Syntax ........: _GuiCtrlCal_Create($sTitle, $iPosX, $iPosY, $iWidth, $iHeight[, $iMonth = @MON[, $iYear = @YEAR[,
;                  $iMenuHeight = 20[, $fStartOnMonday = False[, $iGridSize = 1[, $iResize = 802]]]]]])
; Parameters ....: $sTitle              - A string value.
;                  $iPosX               - An integer value.
;                  $iPosY               - An integer value.
;                  $iWidth              - An integer value.
;                  $iHeight             - An integer value.
;                  $iMonth              - [optional] An integer value. Default is @MON.
;                  $iYear               - [optional] An integer value. Default is @YEAR.
;                  $iMenuHeight         - [optional] An integer value. Default is 20.
;                  $fStartOnMonday      - [optional] A boolean value. Default is False.
;                  $iGridSize           - [optional] An integer value. Default is 1.
;                  $iResize             - [optional] An integer value. Default is 802.
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_Create($sTitle, $iPosX, $iPosY, $iWidth, $iHeight, $iMonth = @MON, $iYear = @YEAR, $iMenuHeight = 20, $fStartOnMonday = False, $iGridSize = 1, $iResize = 802)

	Local $iBtnWidth = Floor($iWidth / 3)
	Local $iFontSize = $iMenuHeight / 2 - 5

	Local $iCtrlIDBG = GUICtrlCreateLabel("", $iPosX, $iPosY, $iWidth, $iHeight)
	GUICtrlSetBkColor(-1, $__CAL_COLOR_GRIDBG)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetResizing(-1, $iResize)

	;Current month display
	Local $iCtrlIDMenu = GUICtrlCreateLabel(_DateToMonth($iMonth), $iPosX + $iBtnWidth, $iPosY, $iBtnWidth, $iMenuHeight / 2, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetBkColor(-1, $__CAL_COLOR_MENUBG)
	GUICtrlSetColor(-1, $__CAL_COLOR_MENUFG)
	GUICtrlSetFont(-1, $iFontSize)
	GUICtrlSetResizing(-1, $iResize)

	;Button left
	Local $iCtrlIDPrevMonth = GUICtrlCreateLabel("<<", $iPosX, $iPosY, $iBtnWidth, $iMenuHeight / 2, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetBkColor(-1, $__CAL_COLOR_MENUBG)
	GUICtrlSetColor(-1, $__CAL_COLOR_MENUFG)
	GUICtrlSetFont(-1, $iFontSize)
	GUICtrlSetResizing(-1, $iResize)

	;Button Right
	Local $iCtrlIDNextMonth = GUICtrlCreateLabel(">>", $iPosX + $iBtnWidth * 2, $iPosY, $iWidth - $iBtnWidth * 2, $iMenuHeight / 2, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetBkColor(-1, $__CAL_COLOR_MENUBG)
	GUICtrlSetColor(-1, $__CAL_COLOR_MENUFG)
	GUICtrlSetFont(-1, $iFontSize)
	GUICtrlSetResizing(-1, $iResize)


	$__CAL_WIDTH = $iWidth ;Calendar Width
	$__CAL_HEIGHT = $iHeight ;Calendar Height
	$__CAL_POSX = $iPosX ;Calendar Position X
	$__CAL_POSY = $iPosY ;Calendar Position Y
	$__CAL_CURSELMONTH = $iMonth ;Currently displayed Month
	$__CAL_CURSELYEAR = $iYear ;Currently displayed Year
	$__CAL_CURSELCTRLID = -1 ;Currently selected control in calendar
	$__CAL_MENUHEIGHT = $iMenuHeight ;Menu Height
	$__CAL_GRIDSIZE = $iGridSize ;Grid Size
	$__CAL_STARTONMONDAY = $fStartOnMonday ;True: Start on monday | False: Start on sunday
	$__CAL_CALHEIGH = $iHeight - $iMenuHeight ;Calendar area height
	$__CAL_ONDATEDBLCLICKCALL = "" ;Function registered on date clicked
	$__CAL_CTRLIDMENU = $iCtrlIDMenu ;Control ID: Menu
	$__CAL_CTRLIDBTNPREV = $iCtrlIDPrevMonth ;Control ID: Button go to previous month
	$__CAL_CTRLIDBTNNEXT = $iCtrlIDNextMonth ;Control ID: Button go to Next month
	$__CAL_CTRLIDBG = $iCtrlIDBG ;Control ID: Background
	$__CAL_RESIZEFLAGS = $iResize ;Resize Flags

	;Create and Assign the __CAL_CTRLIDDAY variables

	Local $fMenuDaysCreated = False
	Local $iDayOfWeek = 1
	Local $iWeekNumber = 1
	Local $iDayPosX = $iPosX
	Local $iDayPosY = $iPosY + $iMenuHeight
	For $i = 1 To $__aCALDAYS[0][0]
		Local $iDayWidth = Floor($iWidth / 7)
		If $iDayOfWeek = 7 Then
			$iDayWidth = $iWidth - (Floor($iWidth / 7) * 6)
		EndIf

		Local $iDayHeight = $__CAL_CALHEIGH / $__CAL_MAXWEEKS
		If $iWeekNumber = 6 Then
			$iDayHeight = $__CAL_CALHEIGH - ($__CAL_CALHEIGH / $__CAL_MAXWEEKS) * ($__CAL_MAXWEEKS - 1)
		EndIf

		If Not $fMenuDaysCreated Then
			Assign("__CAL_CTRLIDDAY" & $i, GUICtrlCreateLabel(_DateDayOfWeek($i), $iDayPosX, $iPosY + ($iMenuHeight / 2), $iDayWidth, $iMenuHeight / 2, $SS_CENTERIMAGE))
			GUICtrlSetBkColor(-1, $__CAL_COLOR_MENUBG)
			GUICtrlSetColor(-1, $__CAL_COLOR_MENUFG)
			GUICtrlSetFont(-1, $iMenuHeight / 2 - 8)
			GUICtrlSetResizing(-1, $iResize)

			If $iDayOfWeek = 7 Then $fMenuDaysCreated = True
		EndIf

		$__aCALDAYS[$i][0] = GUICtrlCreateLabel("", $iDayPosX + _Iif($iDayOfWeek = 7, 0, $iGridSize), $iDayPosY + $iGridSize, $iDayWidth - $iGridSize, $iDayHeight - $iGridSize)
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlSetBkColor(-1, $__CAL_COLOR_WEEKBG)
		GUICtrlSetColor(-1, $__CAL_COLOR_WEEKFG)
		GUICtrlSetFont(-1, 7)
		GUICtrlSetResizing(-1, $iResize)


		$iDayOfWeek += 1
		If $iDayOfWeek > 7 Then
			$iDayOfWeek = 1
			$iWeekNumber += 1
			$iDayPosX = $iPosX
			$iDayPosY += $iDayHeight
		Else
			$iDayPosX += $iDayWidth
		EndIf

	Next

;~ 	_ArrayDisplay($__aCALDAYS)
	_GuiCtrlCal_GoToMonth($iYear, $iMonth)

	Return True

EndFunc   ;==>_GuiCtrlCal_Create


; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_GoToMonth
; Description ...:
; Syntax ........: _GuiCtrlCal_GoToMonth($iYear, $iMonth)
; Parameters ....: $iYear               - An integer value.
;                  $iMonth              - An integer value.
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_GoToMonth($iYear, $iMonth)

	;Get the number of days in this month
	Local $iMonthDays = _DateDaysInMonth($iYear, $iMonth)

	;get the first day of this month
	Local $iFirstDay = _DateToDayOfWeek($iYear, $iMonth, 1)
	If $__CAL_STARTONMONDAY Then
		$iFirstDay -= 1
		;if the first day was a sunday
		If $iFirstDay = 0 Then $iFirstDay = 7
	EndIf

	;Get the number or rows in this month
	Local $iRows = Ceiling(($iMonthDays + $iFirstDay - 1) / 7)

	;get the number of total days this month and create an array of days:
	Local $iTotalDays = $iRows * 7
	Local $aDays[$iTotalDays + 1][4] = [[$iTotalDays]]

	Local $iPosX = $__CAL_POSX
	Local $iPosY = $__CAL_POSY + $__CAL_MENUHEIGHT

	;Write the month name:
	GUICtrlSetData($__CAL_CTRLIDMENU, _DateToMonth($iMonth) & " " & $iYear)

	;Update the current month and year
	$__CAL_CURSELMONTH = $iMonth
	$__CAL_CURSELYEAR = $iYear

	;Write the days of week in the menu:
	Local $iDay = 1
	For $i = 1 To 7
		$iDay = $i
		If $__CAL_STARTONMONDAY Then $iDay += 1
		If $iDay > 7 Then $iDay = 1
		GUICtrlSetData(Eval("__CAL_CTRLIDDAY" & $i), _DateDayOfWeek($iDay))
	Next

	;create the array of days:
	Local $iDay, $iNextMonthDay = 1, $iThisMonthDay = 1
	For $i = 1 To $aDays[0][0]
		Select
			Case $i < $iFirstDay
				Local $iPrevYear = $iYear
				Local $iPrevMonth = $iMonth - 1
				If $iPrevMonth < 1 Then
					$iPrevYear -= 1
					$iPrevMonth = 12
				EndIf
				$iPrevMonthDays = _DateDaysInMonth($iPrevYear, $iPrevMonth)

				$aDays[$i][0] = $iPrevMonthDays - ($iFirstDay - 1 - $i)
				$aDays[$i][1] = $iPrevYear
				$aDays[$i][2] = $iPrevMonth
				$aDays[$i][3] = _DateDayOfWeek(_DateToDayOfWeek($aDays[$i][1], $aDays[$i][2], $aDays[$i][0]))

			Case $i >= $iFirstDay And $i < $iMonthDays + $iFirstDay
				$aDays[$i][0] = $iThisMonthDay
				$aDays[$i][1] = $iYear
				$aDays[$i][2] = $iMonth
				$aDays[$i][3] = _DateDayOfWeek(_DateToDayOfWeek($aDays[$i][1], $aDays[$i][2], $aDays[$i][0]))
				$iThisMonthDay += 1

			Case $i > $iMonthDays
				Local $iNextYear = $iYear
				Local $iNextMonth = $iMonth + 1
				If $iNextMonth > 12 Then
					$iNextYear += 1
					$iNextMonth = 1
				EndIf
				$iNextMonthDays = _DateDaysInMonth($iNextYear, $iNextMonth)

				$aDays[$i][0] = $iNextMonthDay
				$aDays[$i][1] = $iNextYear
				$aDays[$i][2] = $iNextMonth
				$aDays[$i][3] = _DateDayOfWeek(_DateToDayOfWeek($aDays[$i][1], $aDays[$i][2], $aDays[$i][0]))
				$iNextMonthDay += 1
		EndSelect

	Next
;~ 	_ArrayDisplay($aDays)

	Local $iDayOfWeek = 1
	Local $iWeekNumber = 1

;~ 	_GuiCtrlCal_BeginUpdate()
	;Update the calendar:
	For $i = 1 To $__aCALDAYS[0][0]

		If $i > $aDays[0][0] Then
			GUICtrlSetState($__aCALDAYS[$i][0], $GUI_HIDE)
			$__aCALDAYS[$i][1] = ""
			ContinueLoop
		EndIf
		Local $sDate = StringFormat("%04d", $aDays[$i][1]) & "/" & StringFormat("%02d", $aDays[$i][2]) & "/" & StringFormat("%02d", $aDays[$i][0])

		If $iWeekNumber = $iRows Then
			Local $iDayHeight = $__CAL_CALHEIGH - (Floor($__CAL_CALHEIGH / $iRows) * ($iRows - 1)) - $__CAL_GRIDSIZE ;-1 is for the grid to finish
		Else
			Local $iDayHeight = Floor($__CAL_CALHEIGH / $iRows)
		EndIf

		If $iDayOfWeek = 7 Then
			Local $iDayWidth = $__CAL_WIDTH - (Floor($__CAL_WIDTH / 7) * 6) - $__CAL_GRIDSIZE ;-1 is for the grid to finish
		Else
			Local $iDayWidth = Floor($__CAL_WIDTH / 7)
		EndIf

		_WinAPI_MoveWindow(GUICtrlGetHandle($__aCALDAYS[$i][0]), $iPosX + $__CAL_GRIDSIZE, $iPosY + $__CAL_GRIDSIZE, $iDayWidth - $__CAL_GRIDSIZE, $iDayHeight - $__CAL_GRIDSIZE)
		GUICtrlSetData($__aCALDAYS[$i][0], $aDays[$i][0])
		GUICtrlSetState($__aCALDAYS[$i][0], $GUI_SHOW)

		Local $iDayKindOf
		If $aDays[$i][2] <> $iMonth Then
			;color of next or previous or next months
			GUICtrlSetBkColor($__aCALDAYS[$i][0], $__CAL_COLOR_OTHERMONTHBG)
			GUICtrlSetColor($__aCALDAYS[$i][0], $__CAL_COLOR_OTHERMONTHFG)
			$iDayKindOf = $__CAL_DAYKINDOF_OTHERMONTH
		ElseIf $aDays[$i][0] = @MDAY And $aDays[$i][2] = @MON And $aDays[$i][1] = @YEAR Then
			;color of today:
			GUICtrlSetBkColor($__aCALDAYS[$i][0], $__CAL_COLOR_DAYTODAYBG)
			GUICtrlSetColor($__aCALDAYS[$i][0], $__CAL_COLOR_DAYTODAYFG)
			$iDayKindOf = $__CAL_DAYKINDOF_TODAY
		ElseIf (Not $__CAL_STARTONMONDAY And ($iDayOfWeek = 1 Or $iDayOfWeek = 7)) Or ($__CAL_STARTONMONDAY And ($iDayOfWeek = 6 Or $iDayOfWeek = 7)) Then
			;color of weekends
			GUICtrlSetBkColor($__aCALDAYS[$i][0], $__CAL_COLOR_WEEKENDBG)
			GUICtrlSetColor($__aCALDAYS[$i][0], $__CAL_COLOR_WEEKENDFG)
			$iDayKindOf = $__CAL_DAYKINDOF_WEEKEND
		Else
			;week days
			GUICtrlSetBkColor($__aCALDAYS[$i][0], $__CAL_COLOR_WEEKBG)
			GUICtrlSetColor($__aCALDAYS[$i][0], $__CAL_COLOR_WEEKFG)
			$iDayKindOf = $__CAL_DAYKINDOF_WEEKDAY
		EndIf

		;Update the date array:
		$__aCALDAYS[$i][1] = $sDate ;The date of this day
		$__aCALDAYS[$i][2] = $iDayKindOf ;If it's a week day, or week end or other month


		If $iDayOfWeek = 7 Then
			$iPosX = $__CAL_POSX
			$iPosY += $iDayHeight
			$iDayOfWeek = 1
			$iWeekNumber += 1
		Else
			$iPosX += $iDayWidth
			$iDayOfWeek += 1
		EndIf

	Next

	_GuiCtrlCal_EventShow()
	;show the events for this month:
;~ 	_GuiCtrlCal_EndUpdate()
;~ 	_ArrayDisplay($__aCALDAYS)
EndFunc   ;==>_GuiCtrlCal_GoToMonth

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_GoToPreviousMonth
; Description ...:
; Syntax ........: _GuiCtrlCal_GoToPreviousMonth()
; Parameters ....:
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_GoToPreviousMonth()
	Local $iPrevYear = $__CAL_CURSELYEAR
	Local $iPrevMonth = $__CAL_CURSELMONTH - 1
	If $iPrevMonth < 1 Then
		$iPrevMonth = 12
		$iPrevYear = $__CAL_CURSELYEAR - 1
	EndIf
	_GuiCtrlCal_GoToMonth($iPrevYear, $iPrevMonth)
EndFunc   ;==>_GuiCtrlCal_GoToPreviousMonth

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_GoToNextMonth
; Description ...:
; Syntax ........: _GuiCtrlCal_GoToNextMonth()
; Parameters ....:
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_GoToNextMonth()
	Local $iNextYear = $__CAL_CURSELYEAR
	Local $iNextMonth = $__CAL_CURSELMONTH + 1
	If $iNextMonth > 12 Then
		$iNextMonth = 1
		$iNextYear = $__CAL_CURSELYEAR + 1
	EndIf
	_GuiCtrlCal_GoToMonth($iNextYear, $iNextMonth)
EndFunc   ;==>_GuiCtrlCal_GoToNextMonth

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_BeginUpdate
; Description ...:
; Syntax ........: _GuiCtrlCal_BeginUpdate()
; Parameters ....:
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_BeginUpdate()
	For $i = 1 To $__aCALDAYS[0][0]
		_SendMessage($__aCALDAYS[$i][0], $WM_SETREDRAW, False, 0)
	Next
EndFunc   ;==>_GuiCtrlCal_BeginUpdate

; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlCal_EndUpdate
; Description ...:
; Syntax ........: _GuiCtrlCal_EndUpdate()
; Parameters ....:
; Return values .: None
; Author ........: jmon
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlCal_EndUpdate()
	For $i = 1 To $__aCALDAYS[0][0]
		_SendMessage($__aCALDAYS[$i][0], $WM_SETREDRAW, True, 0)
		_WinAPI_RedrawWindow(GUICtrlGetHandle($__aCALDAYS[$i][0]))
	Next
;~ 	Local $tRECT = DllStructCreate($tagRect)
;~ 	DllStructSetData($tRECT, "Left", $__CAL_POSX)
;~ 	DllStructSetData($tRECT, "Top", $__CAL_POSY)
;~ 	DllStructSetData($tRECT, "Right", $__CAL_POSX + $__CAL_WIDTH)
;~ 	DllStructSetData($tRECT, "Bottom", $__CAL_HEIGHT + $__CAL_POSY)
;~ 	_WinAPI_RedrawWindow($GUI, $tRECT)
;~ 	$tRECT = 0
EndFunc   ;==>_GuiCtrlCal_EndUpdate


Func WM_SIZE($hWnd, $Msg, $wParam, $lParam)
	#forceref $Msg, $wParam
	Local $aPos = ControlGetPos(GUICtrlGetHandle($__CAL_CTRLIDBG), "", 0)
	If Not @error Then
		$__CAL_WIDTH = $aPos[2]
		$__CAL_HEIGHT = $aPos[3]
		$__CAL_POSX = $aPos[0]
		$__CAL_POSY = $aPos[1]
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE


Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $hWndFrom, $iIDFrom, $iCode
	$hWndFrom = $ilParam
	$iIDFrom = BitAND($iwParam, 0xFFFF) ; Low Word
	$iCode = BitShift($iwParam, 16) ; Hi Word

	Switch $iIDFrom
		Case $__CAL_CTRLIDBTNPREV ;User clicked on next month button
			Call("_GuiCtrlCal_GoToPreviousMonth")
		Case $__CAL_CTRLIDBTNNEXT ;User clicked on previous month button
			Call("_GuiCtrlCal_GoToNextMonth")
		Case Else
			Local $sEvent = _GuiCtrlCal_GetEventFromCtrlID($iIDFrom)
			If $sEvent <> "" Then
				_c("!This is an event", $sEvent)
			EndIf
			;check id the notification came from the calendar days
			Local $sDate = _GuiCtrlCal_GetDateFromCtrlID($iIDFrom)
			If $sDate <> "" Then
				_GuiCtrlCal_SetSelectedDate($sDate)
				Switch $iCode
					Case 1 ;$STN_DBLCLK :http://msdn.microsoft.com/en-us/library/windows/desktop/bb760769(v=vs.85).aspx
						If $__CAL_ONDATEDBLCLICKCALL <> "" Then Call($__CAL_ONDATEDBLCLICKCALL, $sDate)
				EndSwitch
			EndIf
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

; #FUNCTION# ====================================================================================================================
; Name ..........: GuiCtrlSetOnTop
; Description ...: Sets a control on top of others, by changing the z-ordering.
; Syntax ........: GuiCtrlSetOnTop($iCtrlID)
; Parameters ....: $iCtrlID             - A control ID or Handle.
; Return values .: 	True: Success
;					False: Failure
; Author ........: jmon
; Modified ......:
; Remarks .......: Need to include <WinAPI.au3> and <APIConstants.au3>
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func GuiCtrlSetOnTop($iCtrlID)
	Local $hWnd = $iCtrlID
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($iCtrlID)
	Return _WinAPI_SetWindowPos($hWnd, $HWND_BOTTOM, 0, 0, 0, 0, $SWP_NOMOVE + $SWP_NOSIZE + $SWP_NOCOPYBITS)
EndFunc   ;==>GuiCtrlSetOnTop



Func _c($sMsg1, $sMsg2 = Default, $sMsg3 = Default, $sMsg4 = Default, $sMsg5 = Default, $sMsg6 = Default, $sMsg7 = Default, $sMsg8 = Default, $sMsg9 = Default, $sMsg10 = Default)
	Local $sMsg = $sMsg1

	If $sMsg2 <> Default Then $sMsg &= " | " & $sMsg2
	If $sMsg3 <> Default Then $sMsg &= " | " & $sMsg3
	If $sMsg4 <> Default Then $sMsg &= " | " & $sMsg4
	If $sMsg5 <> Default Then $sMsg &= " | " & $sMsg5
	If $sMsg6 <> Default Then $sMsg &= " | " & $sMsg6
	If $sMsg7 <> Default Then $sMsg &= " | " & $sMsg7
	If $sMsg8 <> Default Then $sMsg &= " | " & $sMsg8
	If $sMsg9 <> Default Then $sMsg &= " | " & $sMsg9
	If $sMsg10 <> Default Then $sMsg &= " | " & $sMsg10

	Return ConsoleWrite($sMsg & @CRLF)
EndFunc   ;==>_c