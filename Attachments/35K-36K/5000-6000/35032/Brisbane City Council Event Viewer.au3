#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiMonthCal.au3>
#Include <GuiListView.au3>
#include <EditConstants.au3>
#Include <Date.au3>
#Include <Array.au3>


Const $ini_filename = @ScriptDir & "\Brisbane City Council Event Viewer.ini"

Local $listview, $button, $item1, $item2, $item3, $input1, $msg
Global $hMonthCal, $calendaredit, $listview, $key_on_listview, $descriptionedit
dim $event_item[10]
dim $month[12] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]


$main_gui = GUICreate("Brisbane City Council Event Viewer", 800, 600)


;GUICtrlCreateLabel("Calendar", 10, 30, 130)
;$calendaredit = GUICtrlCreateInput(IniRead($ini_filename, "Main", "calendar", "community-events-brisbane"), 140, 30, 250, 20)
;$calendaredit2 = GUICtrlCreateInput(IniRead($ini_filename, "Main", "calendar2", "brisbane-city-council"), 140, 50, 250, 20)

$hMonthCal = _GUICtrlMonthCal_Create($main_gui, 480, 30, $WS_BORDER)

$listview = GUICtrlCreateListView("Summary|Dates|Location|Description", 10, 200, 750, 200);,$LVS_SORTDESCENDING)
_GUICtrlListView_SetColumnWidth($listview, 0, 200)
_GUICtrlListView_SetColumnWidth($listview, 1, 200)
_GUICtrlListView_SetColumnWidth($listview, 2, 300)
_GUICtrlListView_SetColumnWidth($listview, 3, 1000)

$descriptionedit = GUICtrlCreateEdit("", 10, 400, 750, 170, $ES_MULTILINE)

$statuslabel = GUICtrlCreateLabel("Ready", 10, 570, 750, 20)

GUISetState()

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

Do
	$msg = GUIGetMsg()

Until $msg = $GUI_EVENT_CLOSE



Func populate_listview($date_filter)

	SplashTextOn("Please Wait ...", "", 250, 50)

	; Community Events Brisbane

	_GUICtrlListView_BeginUpdate($listview)

	for $page_index = 0 to 500 Step 10

		$url = "http://www.trumba.com/s.aspx?calendar=community-events-brisbane&widget=main&date=" & $date_filter & "&index=" & $page_index & "&srpc.cbid=trumba.spud.2&srpc.get=true"
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $url = ' & $url & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

		ControlSetText("Please Wait ...", "", "Static1", "Getting Community Events " & $page_index & " to " & ($page_index + 10))

		$fff = BinaryToString(InetRead($url))

		for $i = 1 to 10

			; description / summary

			$twdescription_pos = StringInStr($fff, """twDescription\"">", 0, $i) + 17

			if $twdescription_pos = 17 Then

				ExitLoop
			EndIf

			$description_start_pos = StringInStr($fff, ">", 0, 1, $twdescription_pos) + 1
			$description_end_pos = StringInStr($fff, "<", 0, 1, $description_start_pos)
			$description = StringMid($fff, $description_start_pos, $description_end_pos - $description_start_pos)
			$description = StringReplace($description, "&amp;", "&")
			$description = StringReplace($description, "&#8217;", "'")
			$description = StringReplace($description, "\'", "'")
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $description = ' & $description & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

			$listviewitem = $description

			; detail / date

			$detail_start_pos = StringInStr($fff, """twDetail\"">", 0, $i) + 12

			if $detail_start_pos = 12 Then

				ExitLoop
			EndIf

			$detail_end_pos = StringInStr($fff, "<", 0, 1, $detail_start_pos)
			$detail = StringMid($fff, $detail_start_pos, $detail_end_pos - $detail_start_pos)
			$detail = StringReplace(StringReplace($detail, "&nbsp;", " "), "&ndash;", "-")
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $detail = ' & $detail & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

			if StringCompare(StringLeft($detail, 7), "Ongoing") <> 0 then

				$date_part = StringSplit($detail, ", ", 1)
				$date_part2 = StringSplit($date_part[2], ", ", 0)
				$start_date = $date_part2[1]
				$start_date_part = StringSplit($start_date, "/")
				$start_date_full = Number("2011" & StringFormat("%002i", $start_date_part[2]) & StringFormat("%002i", $start_date_part[1]))
	;			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $start_date_full = ' & $start_date_full & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

				if $start_date_full > Number($date_filter) Then

					ExitLoop 2
				EndIf

			EndIf

			$listviewitem = $listviewitem & "|" & $detail

			; location

			$location_start_pos = StringInStr($fff, """twLocation\""", 0, $i) + 13
			$location_start_pos = StringInStr($fff, ">", 0, 1, $location_start_pos) + 1

;			if $location_start_pos = 14 Then

;				ExitLoop
;			EndIf

			$location_end_pos = StringInStr($fff, "<", 0, 1, $location_start_pos)
			$location = StringMid($fff, $location_start_pos, $location_end_pos - $location_start_pos)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $location = ' & $location & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;Exit

			$listviewitem = $listviewitem & "|" & $location

			; onlyp / description

;			$onlyp_start_pos = StringInStr($fff, """onlyp\"">", 0, $i) + 9
			$onlyp_start_pos = StringInStr($fff, "<p class=\""", 0, 1, $location_end_pos) + 11
			$onlyp_start_pos = StringInStr($fff, ">", 0, 1, $onlyp_start_pos) + 1

;			if $onlyp_start_pos = 9 Then

;				ExitLoop
;			EndIf

			$onlyp_end_pos = StringInStr($fff, "</td>", 0, 1, $onlyp_start_pos)
			$onlyp = StringMid($fff, $onlyp_start_pos, $onlyp_end_pos - $onlyp_start_pos)
			$onlyp = StringReplace($onlyp, "</p>", "")
			$onlyp = StringReplace($onlyp, "&#8230;", "...")
			$onlyp = StringReplace($onlyp, "&#8217;", "'")
			$onlyp = StringReplace($onlyp, "\'", "'")
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $onlyp = ' & $onlyp & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

			$listviewitem = $listviewitem & "|" & $onlyp

			GUICtrlCreateListViewItem($listviewitem, $listview)

		Next
	Next


	; Brisbane City Council Events

	for $page_index = 0 to 250 Step 5

		$url = "http://www.trumba.com/s.aspx?calendar=brisbane-city-council&widget=main&date=" & $date_filter & "&index=" & $page_index & "&srpc.cbid=trumba.spud.2&srpc.get=true"
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $url = ' & $url & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

		ControlSetText("Please Wait ...", "", "Static1", "Getting Council Events " & $page_index & " to " & ($page_index + 5))

		$fff = BinaryToString(InetRead($url))

		for $i = 1 to 5

			; description / summary

			$twdescription_pos = StringInStr($fff, """twRyoPhotoEventsDescription\"">", 0, $i) + 31

			if $twdescription_pos = 31 Then

				ExitLoop
			EndIf

			$description_start_pos = StringInStr($fff, ">", 0, 1, $twdescription_pos) + 1
			$description_end_pos = StringInStr($fff, "<", 0, 1, $description_start_pos)
			$description = StringMid($fff, $description_start_pos, $description_end_pos - $description_start_pos)
			$description = StringReplace($description, "&amp;", "&")
			$description = StringReplace($description, "&#8217;", "'")
			$description = StringReplace($description, "\'", "'")
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $description = ' & $description & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

			$listviewitem = $description

			; detail / date

			$detail_start_pos = StringInStr($fff, """twRyoPhotoEventsItemHeaderDate\"">", 0, $i) + 34

			if $detail_start_pos = 34 Then

				ExitLoop
			EndIf

			$detail_end_pos = StringInStr($fff, "<", 0, 1, $detail_start_pos)
			$detail = StringMid($fff, $detail_start_pos, $detail_end_pos - $detail_start_pos)
			$detail = StringReplace(StringReplace($detail, "&nbsp;", " "), "&ndash;", "-")
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $detail = ' & $detail & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

			if StringCompare(StringLeft($detail, 7), "Ongoing") <> 0 then

				$date_part = StringSplit($detail, ",|", 0)
				$date_part2 = StringSplit(StringStripWS($date_part[2], 3), " ", 0)
				$month_num = _ArraySearch($month, $date_part2[2]) + 1
				$start_date_full = Number("2011" & StringFormat("%002i", $month_num) & StringFormat("%002i", $date_part2[1]))
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $start_date_full = ' & $start_date_full & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;				Exit

				if $start_date_full > Number($date_filter) Then

					ExitLoop 2
				EndIf

			EndIf

			$detail = StringReplace($detail, "|", "-")

			$listviewitem = $listviewitem & "|" & $detail

			; location

			$location_start_pos = StringInStr($fff, """twLocation\""", 0, $i) + 13
			$location_start_pos = StringInStr($fff, ">", 0, 1, $location_start_pos) + 1

;			if $location_start_pos = 14 Then

;				ExitLoop
;			EndIf

			$location_end_pos = StringInStr($fff, "<", 0, 1, $location_start_pos)
			$location = StringMid($fff, $location_start_pos, $location_end_pos - $location_start_pos)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $location = ' & $location & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;Exit

			$listviewitem = $listviewitem & "|" & $location

			; onlyp / description

;			$onlyp_start_pos = StringInStr($fff, """onlyp\"">", 0, $i) + 9
			$onlyp_start_pos = StringInStr($fff, "<p class=\""", 0, 1, $location_end_pos) + 11
			$onlyp_start_pos = StringInStr($fff, ">", 0, 1, $onlyp_start_pos) + 1

;			if $onlyp_start_pos = 9 Then

;				ExitLoop
;			EndIf

			$onlyp_end_pos = StringInStr($fff, "</div>", 0, 1, $onlyp_start_pos)
			$onlyp = StringMid($fff, $onlyp_start_pos, $onlyp_end_pos - $onlyp_start_pos)
			$onlyp = StringReplace($onlyp, "</p>", "")
			$onlyp = StringReplace($onlyp, "&#8230;", "...")
			$onlyp = StringReplace($onlyp, "&#8217;", "'")
			$onlyp = StringReplace($onlyp, "\'", "'")
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $onlyp = ' & $onlyp & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

			$listviewitem = $listviewitem & "|" & $onlyp

			GUICtrlCreateListViewItem($listviewitem, $listview)
;			Exit

		Next
	Next

	SplashOff()

	_GUICtrlListView_EndUpdate($listview)

	GUICtrlSetData($statuslabel, "Ready")

EndFunc












Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo

    $hWndListView = $listview
    If Not IsHWnd($listview) Then $hWndListView = GUICtrlGetHandle($listview)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom

		Case $hWndListView
            Switch $iCode
				Case $NM_CLICK ; Sent by a list-view control when the user clicks an item with the left mouse button
                    $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)

					$description = _GUICtrlListView_GetItemText($listview, DllStructGetData($tInfo, "Index"), 3)
					$description = StringReplace($description, "<p class=\""middlep\"">", @CRLF & @CRLF)
					$description = StringReplace($description, "<p class=\""lastp\"">", @CRLF & @CRLF)
					$description = StringReplace($description, "<br />", @CRLF)
					GUICtrlSetData($descriptionedit, $description)

;					ConsoleWrite(DllStructGetData($tInfo, "Index"))
;					ConsoleWrite(DllStructGetData($tInfo, "SubItem"))

				Case $LVN_KEYDOWN ; A key has been pressed
					$tInfo = DllStructCreate($tagNMLVKEYDOWN, $ilParam)

;					ConsoleWrite(_GUICtrlListView_GetSelectionMark($listview))

					$key_on_listview = True

 				Case $LVN_ITEMCHANGING ; An item is changing
 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)

					if $key_on_listview = True Then

						$key_on_listview = False

						$selected_index = _GUICtrlListView_GetSelectionMark($listview)

						$description = _GUICtrlListView_GetItemText($listview, $selected_index, 3)
						$description = StringReplace($description, "<p class=\""middlep\"">", @CRLF & @CRLF)
						$description = StringReplace($description, "<p class=\""lastp\"">", @CRLF & @CRLF)
						$description = StringReplace($description, "<br />", @CRLF)
						GUICtrlSetData($descriptionedit, $description)

					EndIf

;					ConsoleWrite(DllStructGetData($tInfo, "Index"))
;					ConsoleWrite(DllStructGetData($tInfo, "SubItem"))
;					ConsoleWrite(DllStructGetData($tInfo, "NewState"))
;					ConsoleWrite(DllStructGetData($tInfo, "Changed"))

			EndSwitch


		Case $hMonthCal
			Switch $iCode
				Case $MCN_SELECT ; Sent by a month calendar control when the user makes an explicit date selection within a month calendar control
					$tInfo = DllStructCreate($tagNMSELCHANGE, $ilParam)

					$selected_date = Number(DllStructGetData($tInfo, "BegYear") & StringFormat("%002i", DllStructGetData($tInfo, "BegMonth")) & StringFormat("%002i", DllStructGetData($tInfo, "BegDay")))
					_GUICtrlListView_DeleteAllItems($listview)
;					populate_listview($selected_date)
					populate_listview($selected_date)


;					ConsoleWrite(DllStructGetData($tInfo, "BegYear"))
;					ConsoleWrite(DllStructGetData($tInfo, "BegMonth"))
;					ConsoleWrite(DllStructGetData($tInfo, "BegDay"))

			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

