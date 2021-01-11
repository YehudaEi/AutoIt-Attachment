#Run_Debug_Mode=n
;----------------------------------------------
;-------------- Created by Kohr ---------------
;----------------------------------------------
#region --- include, Opt, Globals, HotKeySet ---
#include <GUIConstants.au3>
#Include <Misc.au3>
#include <GuiListView.au3>
#include <Date.au3>
#include <IE.au3>

Opt("GUIOnEventMode", 1)
Opt("MouseCoordMode", 0)

Global $GUI = 9999
Global $gEditText
Global $gBoxSize[5] = [5, 2, 2, 2, 2]
Global $gReturn = 0
Global $GUISaveColors
Global $GUIexcel
Global $GUIpicture
Global $GUIpicture2
Global $lvColors1
Global $gSelectedColors[1]
Global $oExcel
Global $gAllColors[1]


;AU3MAG Globals
Global $quit = ""
Global $x_pixel
Global $y_pixel
Global $marea_increment
Global $zoom
Global $zoom_increment
Global $draw_grid
Global $draw_coord
Global $draw_me
Global $quit = ""

HotKeySet("{END}", "CloseClicked")
HotKeySet("{ESC}", "GlobalReturn")
#endregion --- include, Opt, Globals, HotKeySet ---
#region --- GUI ---
$GUImain = GUICreate("PixelGrab v1.7", 240, 470, -1, -1, $WS_SIZEBOX + $WS_SYSMENU + $WS_MINIMIZEBOX + $WS_MAXIMIZEBOX)
$btnDrawBox = GUICtrlCreateButton("DrawBox", 10, 10, 70, 20)
GUICtrlSetOnEvent($btnDrawBox, "DrawBox")
GUICtrlSetResizing($btnDrawBox, 802)
$labelBox1 = GUICtrlCreateLabel("", 90, 5, 130, 15)
GUICtrlSetResizing($labelBox1, 802)
$labelBox2 = GUICtrlCreateLabel("", 90, 25, 130, 15)
GUICtrlSetResizing($labelBox2, 802)
$labelBox3 = GUICtrlCreateLabel("", 90, 45, 130, 15)
GUICtrlSetResizing($labelBox2, 802)
$btnGetColors = GUICtrlCreateButton("GetColors", 10, 40, 70, 20)
GUICtrlSetOnEvent($btnGetColors, "GetColors")
GUICtrlSetState($btnGetColors, $GUI_HIDE)
GUICtrlSetResizing($btnGetColors, 802)

$btnMag = GUICtrlCreateButton("Mag", 10, 80, 70, 20)
GUICtrlSetOnEvent($btnMag, "AU3MAG")
GUICtrlSetResizing($btnMag, 802)
$labelMousePos = GUICtrlCreateLabel("", 90, 82, 100, 15)
GUICtrlSetResizing($labelMousePos, 802)
$labelHex = GUICtrlCreateLabel("", 90, 102, 70, 15)
GUICtrlSetResizing($labelHex, 802)
$labelHexColor = GUICtrlCreateLabel("", 180, 100, 40, 20)
GUICtrlSetResizing($labelHexColor, 802)

GUICtrlCreateGroup("Output", 5, 135, 230, 60)
$btnHtml = GUICtrlCreateButton("Html", 10, 150, 70, 20)
GUICtrlSetOnEvent($btnHtml, "Html")
GUICtrlSetResizing($btnHtml, 802)
$btnExcel = GUICtrlCreateButton("Excel", 10, 170, 70, 20)
GUICtrlSetOnEvent($btnExcel, "Excel")
GUICtrlSetResizing($btnExcel, 802)
$chkHtml = GUICtrlCreateCheckbox(">4000 pixels", 110, 160, 90, 20)
GUICtrlSetResizing($chkHtml, 802)

$btnSavedColorsWindow = GUICtrlCreateButton("> > >", 1, 200, 18, 50, $BS_MULTILINE)
GUICtrlSetOnEvent($btnSavedColorsWindow, "SavedColorsWindow")
GUICtrlSetResizing($btnSavedColorsWindow, 802)
$btnPictureWindow = GUICtrlCreateButton("P I C", 1, 300, 18, 50, $BS_MULTILINE)
GUICtrlSetOnEvent($btnPictureWindow, "PictureWindow")
GUICtrlSetResizing($btnPictureWindow, 802)
$btnPictureWindow2 = GUICtrlCreateButton("x 2", 1, 350, 18, 40, $BS_MULTILINE)
GUICtrlSetOnEvent($btnPictureWindow2, "PictureWindow2")
GUICtrlSetResizing($btnPictureWindow2, 802)

$lvColors = GUICtrlCreateListView("Color|X|Y", 20, 200, 210, 200, $LVS_SHOWSELALWAYS, $LVS_EX_FULLROWSELECT + $WS_EX_CLIENTEDGE + $LVS_EX_GRIDLINES)
GUICtrlSetResizing($lvColors, 102)
_GUICtrlListViewSetColumnWidth($lvColors, 0, 80)
_GUICtrlListViewSetColumnWidth($lvColors, 1, 20)
_GUICtrlListViewSetColumnWidth($lvColors, 2, 20)
$contextmenu_lvColors = GUICtrlCreateContextMenu($lvColors)
$menuitemDelete = GUICtrlCreateMenuitem("Delete", $contextmenu_lvColors)
GUICtrlSetOnEvent($menuitemDelete, "MenuDelete")
$menuitemMove = GUICtrlCreateMenuitem("Save Selected", $contextmenu_lvColors)
GUICtrlSetOnEvent($menuitemMove, "MenuSaveColors")

$labelTime = GUICtrlCreateLabel("", 10, 410, 150, 20)
GUICtrlSetResizing($labelTime, 576)

GUISetState(@SW_SHOW, $GUImain)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseClicked")
#endregion --- GUI ---
While 1
	Sleep(200)
	If $GUISaveColors <> "" Then _KeepWindowsDocked()
	$gReturn = 0
WEnd
Func DrawBox()
	;Credit goes to Manadar for most of this function
	GUICtrlSetState($btnDrawBox, $GUI_DISABLE)
	GUICtrlSetState($btnGetColors, $GUI_HIDE)
	Opt("MouseCoordMode", 1)
	GUIDelete($GUI)
	GUICtrlSetData($btnDrawBox, "Drawing...")
	Local $ScanWidth = 1, $ScanHeight = 1
	While 1
		$pos = MouseGetPos()
		If $pos[0] >= @DesktopWidth - 110 Then
			If $pos[1] >= @DesktopHeight - 50 Then
				ToolTip("Hit SpaceBar to set" & @CRLF & "x: " & $pos[0] & " y: " & $pos[1], $pos[0] - 110, $pos[1] - 50)
			Else
				ToolTip("Hit SpaceBar to set" & @CRLF & "x: " & $pos[0] & " y: " & $pos[1], $pos[0] - 110)
			EndIf
		Else
			If $pos[1] >= @DesktopHeight - 50 Then
				ToolTip("Hit SpaceBar to set" & @CRLF & "x: " & $pos[0] & " y: " & $pos[1], $pos[0], $pos[1] - 50)
			Else
				ToolTip("Hit SpaceBar to set" & @CRLF & "x: " & $pos[0] & " y: " & $pos[1])
			EndIf
		EndIf
		If _IsPressed(20) Then
			ToolTip("")
			ExitLoop
		EndIf
	WEnd
	While _IsPressed(20)
		Sleep(10)
	WEnd
	$x = $pos[0]
	$y = $pos[1]
	$GUI = GUICreate("", 0, 0, $x, $y, $WS_POPUP)
	$Top = GUICreate("Top Line", $ScanWidth, 2, $x, $y, $WS_POPUP, -1, $GUI)
	GUISetBkColor(0xFF0000)
	GUISetState()
	$Left = GUICreate("Left Line", 2, $ScanHeight, $x, $y, $WS_POPUP, -1, $GUI)
	GUISetBkColor(0xFF0000)
	GUISetState()
	$Right = GUICreate("Right Line", 2, $ScanHeight, $x + $ScanWidth - 2, $y, $WS_POPUP, -1, $GUI)
	GUISetBkColor(0xFF0000)
	GUISetState()
	$Bottom = GUICreate("Bottom Line", $ScanWidth, 2, $x, $y + $ScanHeight, $WS_POPUP, -1, $GUI)
	GUISetBkColor(0xFF0000)
	GUISetState()
	While 1
		$MousePos = MouseGetPos()
		If $MousePos[0] >= @DesktopWidth - 110 Then
			If $MousePos[1] >= @DesktopHeight - 50 Then
				ToolTip("Hit SpaceBar to set" & @CRLF & "x: " & $MousePos[0] & " y: " & $MousePos[1] & @CRLF & "Pixels:" & ($MousePos[0] + 1 - $pos[0]) * ($MousePos[1] + 1 - $pos[1]), $MousePos[0] - 110, $MousePos[1] - 50)
			Else
				ToolTip("Hit SpaceBar to set" & @CRLF & "x: " & $MousePos[0] & " y: " & $MousePos[1] & @CRLF & "Pixels:" & ($MousePos[0] + 1 - $pos[0]) * ($MousePos[1] + 1 - $pos[1]), $MousePos[0] - 110)
			EndIf
		Else
			If $MousePos[1] >= @DesktopHeight - 50 Then
				ToolTip("Hit SpaceBar to set" & @CRLF & "x: " & $MousePos[0] & " y: " & $MousePos[1] & @CRLF & "Pixels:" & ($MousePos[0] + 1 - $pos[0]) * ($MousePos[1] + 1 - $pos[1]), $MousePos[0], $MousePos[1] - 50)
			Else
				ToolTip("Hit SpaceBar to set" & @CRLF & "x: " & $MousePos[0] & " y: " & $MousePos[1] & @CRLF & "Pixels:" & ($MousePos[0] + 1 - $pos[0]) * ($MousePos[1] + 1 - $pos[1]))
			EndIf
		EndIf
		WinMove($Top, "", $x, $y, $ScanWidth, 2)
		WinMove($Left, "", $x, $y, 2, $ScanHeight)
		WinMove($Right, "", $x + $ScanWidth - 2, $y, 2, $ScanHeight)
		WinMove($Bottom, "", $x, $y + $ScanHeight, $ScanWidth, 2)
		If Not (($MousePos[0] - $x) <= 0) Then
			$ScanWidth = $MousePos[0] - $x + 1
		EndIf
		If Not (($MousePos[1] - $y) <= 0) Then
			$ScanHeight = $MousePos[1] - $y - 1
		EndIf
		If _IsPressed(20) Then
			ToolTip("")
			ExitLoop
		EndIf
	WEnd
	$gBoxSize[1] = Int($pos[0])
	$gBoxSize[2] = Int($pos[1])
	$gBoxSize[3] = Int($MousePos[0])
	$gBoxSize[4] = Int($MousePos[1])
;~ 	_ArrayDisplay($gBoxSize,"")
	GUICtrlSetData($btnDrawBox, "DrawBox")
	GUICtrlSetData($labelBox1, "Left: " & $gBoxSize[1] & " Top: " & $gBoxSize[2])
	GUICtrlSetData($labelBox2, "Right: " & $gBoxSize[3] & " Bottom: " & $gBoxSize[4])
	GUICtrlSetData($labelBox3, "Pixels: " & ($MousePos[0] + 1 - $pos[0]) * ($MousePos[1] + 1 - $pos[1]))
	Opt("MouseCoordMode", 0)
	GUICtrlSetState($btnGetColors, $GUI_SHOW)
	Dim $gAllColors[1]	;clear variable
	GUICtrlSetState($btnDrawBox, $GUI_ENABLE)
	Return 1
EndFunc   ;==>DrawBox
Func GetColors()
	GUIDelete($GUI)
	Sleep(200)
	GUICtrlSendMsg($lvColors, $LVM_DELETEALLITEMS, 0, 0)
	Sleep(200)
	$timer = TimerInit()
	GUISetState(@SW_SHOW, $GUImain)
	GUISetState(@SW_LOCK, $GUImain)
	SplashTextOn("Getting Colors", "Please Wait", 200, 50)
	$ControlMaxCounter = 0
	For $y = $gBoxSize[2] To $gBoxSize[4]
		For $x = $gBoxSize[1] To $gBoxSize[3]
			$ControlMaxCounter += 1
			If $ControlMaxCounter >= 4000 Then
				ExitLoop
			EndIf
			$Color = Hex(PixelGetColor($x, $y), 6)
			$row = GUICtrlCreateListViewItem($Color & "|" & $x & "|" & $y, $lvColors)
			;$row = _GUICtrlListViewInsertItem($lvColors, $index, $Color & "|" & $x & "|" & $y)
			GUICtrlSetBkColor($row, "0x" & $Color)
			_ArrayAdd($gAllColors, $Color & "|" & $x & "|" & $y)
			If $gReturn = 1 Then
				GUICtrlSetState($btnGetColors, $GUI_HIDE)
				GUISetState(@SW_UNLOCK, $GUImain)
				Return 0
			EndIf
		Next
		If $gReturn = 1 Then
			GUICtrlSetState($btnGetColors, $GUI_HIDE)
			GUISetState(@SW_UNLOCK, $GUImain)
			Return 0
		EndIf
	Next
	$gAllColors[0] = UBound($gAllColors) - 1
	Dim $Secs, $Mins, $Hour, $Time
	_TicksToTime(Int(TimerDiff($timer)), $Hour, $Mins, $Secs)
	$Time = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
	GUICtrlSetData($labelTime, "Elapsed time: " & $Time)
	SplashOff()
	GUISetState(@SW_UNLOCK, $GUImain)
	Dim $gBoxSize[5] = [5, 2, 2, 2, 2]
	GUICtrlSetState($btnGetColors, $GUI_HIDE)
	Return 1
EndFunc   ;==>GetColors
Func SavedColorsWindow()
	If GUICtrlRead($btnSavedColorsWindow) = "> > >" Then
		$GUISaveColors = GUICreate("Saved Colors", 221, 200, -1, -1, -1, $WS_EX_TOOLWINDOW)
		$lvColors1 = GUICtrlCreateListView("Color|X|Y", 10, 10, 190, 180, $LVS_SHOWSELALWAYS, $LVS_EX_FULLROWSELECT + $WS_EX_CLIENTEDGE + $LVS_EX_GRIDLINES)
		_GUICtrlListViewSetColumnWidth($lvColors1, 0, 80)
		_GUICtrlListViewSetColumnWidth($lvColors1, 1, 20)
		_GUICtrlListViewSetColumnWidth($lvColors1, 2, 20)
		$contextmenu_lvColors1 = GUICtrlCreateContextMenu($lvColors1)
		$menuitem1Delete = GUICtrlCreateMenuitem("Delete", $contextmenu_lvColors1)
		GUICtrlSetOnEvent($menuitem1Delete, "MenuDeleteSavedColors")
		$menuitem1DeleteAll = GUICtrlCreateMenuitem("Delete All", $contextmenu_lvColors1)
		GUICtrlSetOnEvent($menuitem1DeleteAll, "MenuDeleteAllSavedColors")
		$size = WinGetPos("")
		WinMove($GUISaveColors, "", $size[0] - 230, $size[1] + 200)
		DllCall("user32.dll", "int", "AnimateWindow", "hwnd", WinGetHandle($GUISaveColors), "int", 300, "long", 0x00040002);slide in from right
		GUICtrlSetData($btnSavedColorsWindow, "< < <")
		GUISetState(@SW_SHOW, $GUISaveColors)
		GUISetOnEvent($GUI_EVENT_CLOSE, "SavedColorsWindow")
		;show saved listview items
		If $gSelectedColors[0] <> 0 Then
			For $i = 1 To $gSelectedColors[0]
				$row = GUICtrlCreateListViewItem($gSelectedColors[$i], $lvColors1)
				GUICtrlSetBkColor($row, "0x" & StringLeft($gSelectedColors[$i], 6))
				If $gReturn = 1 Then Return 0
			Next
		EndIf
		Dim $gSelectedColors[1]
	Else
		;save listview items
		$CurrentSelectedCount = _GUICtrlListViewGetItemCount($lvColors1)
		$gSelectedColors[0] = $CurrentSelectedCount
		If $gSelectedColors[0] <> 0 Then
			For $i = 0 To $CurrentSelectedCount - 1
				_ArrayAdd($gSelectedColors, _GUICtrlListViewGetItemText($lvColors1, $i))
				If $gReturn = 1 Then Return 0
			Next
		EndIf
		DllCall("user32.dll", "int", "AnimateWindow", "hwnd", WinGetHandle($GUISaveColors), "int", 300, "long", 0x00050001);slide out to right
		GUICtrlSetData($btnSavedColorsWindow, "> > >")
		GUIDelete($GUISaveColors)
	EndIf
EndFunc   ;==>SavedColorsWindow
Func PictureWindow()
	;get all items from main listview
	Dim $AllColors[1]
	Dim $AllColorsNew[1]
	$Width = 1
	$Height = 1
	$Count = _GUICtrlListViewGetItemCount($lvColors)
	If $Count = 0 Then
		MsgBox(0, "", "ListView empty")
		Return 0
	EndIf
	SplashTextOn("Creating Picture", "Please Wait", 200, 50)
	For $i = 0 To $Count - 1
		_ArrayAdd($AllColors, _GUICtrlListViewGetItemText($lvColors, $i))
		If $gReturn = 1 Then
			SplashOff()
			Return 0
		EndIf
	Next
	$AllColors[0] = UBound($AllColors) - 1
	;redo x/y so it can draw correctly as picture
	For $i = 1 To $AllColors[0]
		$ret = StringSplit($AllColors[$i], "|")
		If $i = 1 Then
			$xBase = $ret[2]
			$yBase = $ret[3]
			$ret[2] = 1
			$ret[3] = 1
			_ArrayAdd($AllColorsNew, $ret[1] & "|1|1")
		Else
			$ret[2] = $ret[2] - $xBase + 1
			$ret[3] = $ret[3] - $yBase + 1
			_ArrayAdd($AllColorsNew, $ret[1] & "|" & $ret[2] & "|" & $ret[3])
		EndIf
		If $Width < $ret[2] Then
			$Width = $ret[2]
		EndIf
		If $Height < $ret[3] Then
			$Height = $ret[3]
		EndIf
		If $gReturn = 1 Then
			SplashOff()
			Return 0
		EndIf
	Next
	$AllColorsNew[0] = UBound($AllColorsNew) - 1
	SplashOff()
	$GUIpicture = GUICreate("Picture", $Width, $Height, -1, -1, -1, $WS_EX_TOOLWINDOW)
	$size = WinGetPos("")
	$a = GUICtrlCreateGraphic(0, 0, $Width, $Height, $SS_ETCHEDFRAME)
	GUICtrlSetResizing($a, 1)
	For $i = 1 To $AllColorsNew[0]
		$ret = StringSplit($AllColorsNew[$i], "|")
		GUICtrlSetGraphic(-1, $GUI_GR_COLOR, "0x" & $ret[1])
		GUICtrlSetGraphic(-1, $GUI_GR_PIXEL, $ret[2], $ret[3])
		If $gReturn = 1 Then
			GUIDelete($GUIpicture)
			Return 0
		EndIf
	Next
	GUISetState(@SW_SHOW, $GUIpicture)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseClickedPicture")
	GUICtrlSetState($btnPictureWindow, $GUI_HIDE)
EndFunc   ;==>PictureWindow
Func PictureWindow2()
	;get all items from main listview
	Dim $AllColors[1]
	Dim $AllColorsNew[1]
	$Width = 1
	$Height = 1
	$Count = _GUICtrlListViewGetItemCount($lvColors)
	If $Count = 0 Then
		MsgBox(0, "", "ListView empty")
		Return 0
	EndIf
	SplashTextOn("Creating Picture", "Please Wait", 200, 50)
	For $i = 0 To $Count - 1
		_ArrayAdd($AllColors, _GUICtrlListViewGetItemText($lvColors, $i))
		If $gReturn = 1 Then
			SplashOff()
			Return 0
		EndIf
	Next
	$AllColors[0] = UBound($AllColors) - 1
	;redo x/y so it can draw correctly as picture
	For $i = 1 To $AllColors[0]
		$ret = StringSplit($AllColors[$i], "|")
		If $i = 1 Then
			$xBase = $ret[2]
			$yBase = $ret[3]
			$ret[2] = 1
			$ret[3] = 1
			_ArrayAdd($AllColorsNew, $ret[1] & "|1|1")
		Else
			$ret[2] = $ret[2] - $xBase + 1
			$ret[3] = $ret[3] - $yBase + 1
			_ArrayAdd($AllColorsNew, $ret[1] & "|" & $ret[2] & "|" & $ret[3])
		EndIf
		If $Width < $ret[2] Then
			$Width = $ret[2]
		EndIf
		If $Height < $ret[3] Then
			$Height = $ret[3]
		EndIf
		If $gReturn = 1 Then
			SplashOff()
			Return 0
		EndIf
	Next
	$AllColorsNew[0] = UBound($AllColorsNew) - 1
	;section to double size of area
	Dim $AllColors2[1]
	Dim $aTemp[1]
	$xBase = 0
	$yBase = 1
	For $i = 1 To $AllColorsNew[0]
		$ret = StringSplit($AllColorsNew[$i], "|")
		If $xBase < $ret[2] Then
			If $yBase = $ret[3] Then
				_ArrayAdd($AllColors2, $ret[1] & "|" & $ret[2] + $xBase & "|" & $ret[3] + $yBase - 1)
				_ArrayAdd($AllColors2, $ret[1] & "|" & $ret[2] + $xBase + 1 & "|" & $ret[3] + $yBase - 1)
				_ArrayAdd($aTemp, $ret[1] & "|" & $ret[2] + $xBase & "|" & $ret[3] + $yBase)
				_ArrayAdd($aTemp, $ret[1] & "|" & $ret[2] + $xBase + 1 & "|" & $ret[3] + $yBase)
				$xBase += 1
			EndIf
		Else
			$xBase = 0
			For $j = 1 To UBound($aTemp) - 1
				_ArrayAdd($AllColors2, $aTemp[$j])
			Next
			Dim $aTemp[1]
			$yBase += 1
			If $yBase = $ret[3] Then
				_ArrayAdd($AllColors2, $ret[1] & "|" & $ret[2] + $xBase & "|" & $ret[3] + $yBase - 1)
				_ArrayAdd($AllColors2, $ret[1] & "|" & $ret[2] + $xBase + 1 & "|" & $ret[3] + $yBase - 1)
				_ArrayAdd($aTemp, $ret[1] & "|" & $ret[2] + $xBase & "|" & $ret[3] + $yBase)
				_ArrayAdd($aTemp, $ret[1] & "|" & $ret[2] + $xBase + 1 & "|" & $ret[3] + $yBase)
				$xBase += 1
			EndIf
		EndIf
		If $gReturn = 1 Then
			SplashOff()
			Return 0
		EndIf
	Next
	$AllColors2[0] = UBound($AllColors2) - 1
	SplashOff()
	$GUIpicture2 = GUICreate("Picture x2", $Width * 2, $Height * 2, -1, -1, -1, $WS_EX_TOOLWINDOW)
	$size = WinGetPos("")
	$a = GUICtrlCreateGraphic(0, 0, $Width * 2, $Height * 2, $SS_ETCHEDFRAME)
	For $i = 1 To $AllColors2[0]
		$ret = StringSplit($AllColors2[$i], "|")
		GUICtrlSetGraphic(-1, $GUI_GR_COLOR, "0x" & $ret[1])
		GUICtrlSetGraphic(-1, $GUI_GR_PIXEL, $ret[2], $ret[3])
		If $gReturn = 1 Then
			GUIDelete($GUIpicture2)
			Return 0
		EndIf
	Next
	GUISetState(@SW_SHOW, $GUIpicture2)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseClickedPicture2")
	GUICtrlSetState($btnPictureWindow2, $GUI_HIDE)
EndFunc   ;==>PictureWindow2
Func Excel()
	If GUICtrlRead($chkHtml) = $GUI_UNCHECKED Then
		$Count = _GUICtrlListViewGetItemCount($lvColors)
		If $Count = 0 Then
			MsgBox(0, "", "ListView empty")
			Return 0
		EndIf
		$timer = TimerInit()
	Else
		GUICtrlSetState($btnExcel, $GUI_DISABLE)
		DrawBox()
		$timer = TimerInit()
		GUIDelete($GUI)
		Sleep(200)
		SplashTextOn("Getting Colors", "Please Wait", 200, 50)
		For $y = $gBoxSize[2] To $gBoxSize[4]
			For $x = $gBoxSize[1] To $gBoxSize[3]
				$Color = Hex(PixelGetColor($x, $y), 6)
				_ArrayAdd($gAllColors, $Color & "|" & $x & "|" & $y)
				If $gReturn = 1 Then
					Return 0
				EndIf
			Next
			If $gReturn = 1 Then
				Return 0
			EndIf
		Next
		$gAllColors[0] = UBound($gAllColors) - 1
		SplashOff()
	EndIf
	SplashTextOn("Creating Excel", "Please Wait", 200, 50)
	$oExcel = ObjCreate("Excel.Application")
	With $oExcel
		.Visible = 0
		.WorkBooks.Add
		.ActiveWorkbook.Sheets (1).Select ()
	EndWith
	Dim $AllColorsNew[1]
	$Width = 1
	$Height = 1
	;redo x/y
	For $i = 1 To $gAllColors[0]
		$ret = StringSplit($gAllColors[$i], "|")
		If $i = 1 Then
			$xBase = $ret[2]
			$yBase = $ret[3]
			$ret[2] = 1
			$ret[3] = 1
			_ArrayAdd($AllColorsNew, $ret[1] & "|1|1")
		Else
			$ret[2] = $ret[2] - $xBase + 1
			$ret[3] = $ret[3] - $yBase + 1
			_ArrayAdd($AllColorsNew, $ret[1] & "|" & $ret[2] & "|" & $ret[3])
		EndIf
		If $Width < $ret[2] Then
			$Width = $ret[2]
		EndIf
		If $Height < $ret[3] Then
			$Height = $ret[3]
		EndIf
		If $gReturn = 1 Then
			SplashOff()
			GUIDelete($GUIexcel)
			Return 0
		EndIf
	Next
	$AllColorsNew[0] = UBound($AllColorsNew) - 1
	$sheet4 = 0
	$sheet5 = 0
	For $i = 1 To $AllColorsNew[0]
		$ret = StringSplit($AllColorsNew[$i], "|")
		If $ret[2] <= 256 Then	;sheet 1 for column 1 - 256
			$oExcel.ActiveWorkbook.Sheets (1).Select ()
			$oExcel.Activesheet.Cells (Number($ret[3]), Number($ret[2]) ).Value = "0x" & $ret[1]
		EndIf
		If $ret[2] >= 257 Then	;sheet 2 for column 257 - 512
			If $ret[2] <= 512 Then
				$oExcel.ActiveWorkbook.Sheets (2).Select ()
				$oExcel.Activesheet.Cells (Number($ret[3]), Number($ret[2] - 256) ).Value = "0x" & $ret[1]
			EndIf
		EndIf
		If $ret[2] >= 513 Then	;sheet 3 for column 513 - 768
			If $ret[2] <= 768 Then
				$oExcel.ActiveWorkbook.Sheets (3).Select ()
				$oExcel.Activesheet.Cells (Number($ret[3]), Number($ret[2] - 512) ).Value = "0x" & $ret[1]
			EndIf
		EndIf
		If $ret[2] >= 769 Then	;sheet 4 for column 769 - 1024
			If $ret[2] <= 1024 Then
				If $ret[2] = 769 And $sheet4 = 0 Then
					$oExcel.ActiveWorkBook.WorkSheets.Add.Activate
					$oExcel.Sheets (4).Move ($oExcel.Sheets (3))
					$sheet4 = 1
				EndIf
				$oExcel.ActiveWorkbook.Sheets (4).Select ()
				$oExcel.Activesheet.Cells (Number($ret[3]), Number($ret[2] - 768) ).Value = "0x" & $ret[1]
			EndIf
		EndIf
		If $ret[2] >= 1025 Then	;sheet 5 for column 1025 - 1280
			If $ret[2] <= 1280 Then
				If $ret[2] = 1025 And $sheet5 = 0 Then
					$oExcel.ActiveWorkBook.WorkSheets.Add.Activate
					$oExcel.Sheets (5).Move ($oExcel.Sheets (4))
					$sheet5 = 1
				EndIf
				$oExcel.ActiveWorkbook.Sheets (5).Select ()
				$oExcel.Activesheet.Cells (Number($ret[3]), Number($ret[2] - 1024) ).Value = "0x" & $ret[1]
			EndIf
		EndIf
		If $gReturn = 1 Then
			SplashOff()
			GUIDelete($GUIexcel)
			Return 0
		EndIf
	Next
	SplashOff()
	$oExcel.Activesheet.Columns ("A:IV").Autofit
	$oExcel.Visible = 1
	$oExcel = ""
	Dim $Secs, $Mins, $Hour, $Time
	_TicksToTime(Int(TimerDiff($timer)), $Hour, $Mins, $Secs)
	$Time = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
	GUICtrlSetData($labelTime, "Elapsed time: " & $Time)
	GUICtrlSetState($btnExcel, $GUI_ENABLE)
	Return 1
EndFunc   ;==>Excel
Func Html()
	If GUICtrlRead($chkHtml) = $GUI_UNCHECKED Then
		$Count = _GUICtrlListViewGetItemCount($lvColors)
		If $Count = 0 Then
			MsgBox(0, "", "ListView empty")
			Return 0
		EndIf
		$timer = TimerInit()
	Else
		GUICtrlSetState($btnHtml, $GUI_DISABLE)
		DrawBox()
		$timer = TimerInit()
		GUIDelete($GUI)
		Sleep(200)
		SplashTextOn("Getting Colors", "Please Wait", 200, 50)
		For $y = $gBoxSize[2] To $gBoxSize[4]
			For $x = $gBoxSize[1] To $gBoxSize[3]
				$Color = Hex(PixelGetColor($x, $y), 6)
				_ArrayAdd($gAllColors, $Color & "|" & $x & "|" & $y)
				If $gReturn = 1 Then
					Return 0
				EndIf
			Next
			If $gReturn = 1 Then
				Return 0
			EndIf
		Next
		$gAllColors[0] = UBound($gAllColors) - 1
		SplashOff()
	EndIf
	SplashTextOn("Creating Html", "Please Wait", 200, 50)
	;IE section
	$oIE = _IECreate()
	$sHTML = "<h1></h1>"
	$sHTML &= "<table cellspacing='1' cellpadding='1' border='1' style='border-collapse: collapse' width='100%' align='center'>"
	$ret = StringSplit($gAllColors[1], "|")
	$row = $ret[3]
	$sHTML &= "<tr>"
	For $i = 1 To $gAllColors[0]
		$ret = StringSplit($gAllColors[$i], "|")
		If $ret[3] <> $row Then
			$sHTML &= "<tr>"
			$row += 1
		EndIf
		$sHTML &= "<td bgcolor='#" & $ret[1] & "'><small>" & $ret[1] & "." & $ret[2] & "." & $ret[3] & "</small>"
;~ 		$sHTML &= "<td bgcolor='#" & $ret[1] & "'>" & $ret[1]
;~ 		$sHTML &= "<td bgcolor='#" & $ret[1] & "'>."	;find way to make this work without period
		If $gReturn = 1 Then
			SplashOff()
			GUIDelete($GUIexcel)
			Return 0
		EndIf
		If $gReturn = 1 Then
			SplashOff()
			Return 0
		EndIf
	Next
	_IEBodyWriteHTML($oIE, $sHTML)
	SplashOff()
	Dim $Secs, $Mins, $Hour, $Time
	_TicksToTime(Int(TimerDiff($timer)), $Hour, $Mins, $Secs)
	$Time = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
	GUICtrlSetData($labelTime, "Elapsed time: " & $Time)
	GUICtrlSetState($btnHtml, $GUI_ENABLE)
	Return 1
EndFunc   ;==>Html
Func GlobalReturn()
	$gReturn = 1
	SplashOff()
	Return 1
EndFunc   ;==>GlobalReturn
Func _KeepWindowsDocked()
	$p_win1 = WinGetPos($GUImain)
	$p_win2 = WinGetPos($GUISaveColors)
	$x1 = $p_win1[0]
	$y1 = $p_win1[1]
	$x2 = $x1 - 225
	$y2 = $y1 + 200
	WinMove($GUISaveColors, "", $x2, $y2)
EndFunc   ;==>_KeepWindowsDocked
#region --- Menu items ---
Func MenuSaveColors()
	If GUICtrlRead($btnSavedColorsWindow) = "> > >" Then
		SavedColorsWindow()
	EndIf
	$CurrentSelected = _GUICtrlListViewGetCurSel($lvColors)
	$CurrentSelectedCount = _GUICtrlListViewGetSelectedCount($lvColors)
	For $i = 0 To $CurrentSelectedCount - 1
		$ItemText = _GUICtrlListViewGetItemText($lvColors, $CurrentSelected + $i)
		$ItemColor = _GUICtrlListViewGetItemText($lvColors, $CurrentSelected + $i, 0)
		GUICtrlCreateListViewItem($ItemText, $lvColors1)
		GUICtrlSetBkColor(-1, "0x" & $ItemColor)
	Next
EndFunc   ;==>MenuSaveColors
Func MenuDelete()
	_GUICtrlListViewDeleteItemsSelected($lvColors)
EndFunc   ;==>MenuDelete
Func MenuDeleteSavedColors()
	_GUICtrlListViewDeleteItemsSelected($lvColors1)
EndFunc   ;==>MenuDeleteSavedColors
Func MenuDeleteAllSavedColors()
	_GUICtrlListViewDeleteAllItems($lvColors1)
EndFunc   ;==>MenuDeleteAllSavedColors
#endregion --- Menu items ---
#region --- Functions for closing ---
Func CloseClickedPicture()
	GUIDelete($GUIpicture)
	GUICtrlSetState($btnPictureWindow, $GUI_SHOW)
EndFunc   ;==>CloseClickedPicture
Func CloseClickedPicture2()
	GUIDelete($GUIpicture2)
	GUICtrlSetState($btnPictureWindow2, $GUI_SHOW)
EndFunc   ;==>CloseClickedPicture2
Func CloseExcelWindow()
	GUIDelete($GUIexcel)
EndFunc   ;==>CloseExcelWindow
Func CloseClicked()
	Exit
EndFunc   ;==>CloseClicked
#endregion --- Functions for closing ---


#region --- AU3MAG ---
Func AU3MAG()
	;credit to Larry and Xandl
	Opt("WinTitleMatchMode", 4)
	Opt("WinWaitDelay", 0)
	Opt("MouseCoordMode", 1)

	$SRCCOPY = 0x00CC0020
	$x_pixel = 100 	; target area width
	$y_pixel = 100 	; target area heigt
	$marea_increment = 10	; target area pixel increment
	$xy_dist = 20 	; distance from mouse cursor
	$zoom = 50 	; source area width and height
	$zoom_increment = 4 	; source area pixel increment
	Local $west[2] 	; points for grid
	Local $east[2]; points for grid
	Local $north[2]; points for grid
	Local $south[2]; points for grid
	$draw_grid = 1; boolean for grid
	$draw_coord = 1; boolean for mouse coordinates
	$draw_me = 1; boolean for main window
	$quit = ""; boolean for quit
	
	HotKeySet("{PAUSE}", "Quit")
	HotKeySet("{ESC}", "Quit")
	HotKeySet("{F1}", "Help")
	HotKeySet("{RIGHT}", "Magarea_Up")
	HotKeySet("{LEFT}", "Magarea_Down")
	HotKeySet("{UP}", "Zoom_Up")
	HotKeySet("{DOWN}", "Zoom_Down")
	HotKeySet("^{PGDN}", "GridToggle")
	HotKeySet("^{END}", "CoordToggle")
	HotKeySet("^{DEL}", "ShadowToggle")

	ToolTip("AU3MAG", 0, 0)
	Global $MyhWnd = WinGetHandle("classname=tooltips_class32")
	$quit = 0
	While Not $quit
		$MyHDC = DllCall("user32.dll", "int", "GetDC", "hwnd", $MyhWnd)
		If @error Then Return
		$DeskHDC = DllCall("user32.dll", "int", "GetDC", "hwnd", 0)
		If Not @error Then
			$xy = MouseGetPos()
			If Not @error Then
				If Not $draw_me Then
					$xy[0] = -10000
					$xy[1] = -10000
				EndIf
				$l = $xy[0] - $zoom / 2
				$t = $xy[1] - $zoom / 2
				DllCall("gdi32.dll", "int", "StretchBlt", "int", $MyHDC[0], "int", _
						0, "int", 0, "int", $x_pixel, "int", $y_pixel, "int", $DeskHDC[0], "int", _
						$l, "int", $t, "int", $zoom, "int", $zoom, "long", $SRCCOPY)
				$x_winpos = $xy[0] + $xy_dist
				$y_winpos = $xy[1] + $xy_dist
				If ($x_winpos + $x_pixel) > @DesktopWidth Then $x_winpos = @DesktopWidth - $x_pixel - $xy_dist
				If ($y_winpos + $y_pixel) > @DesktopHeight Then $y_winpos = $xy[1] - $y_pixel - $xy_dist
				WinMove($MyhWnd, "", $x_winpos, $y_winpos, $x_pixel, $y_pixel)
				If $draw_grid Then
					$xp2 = $x_pixel / 2 - 1
					$yp2 = $y_pixel / 2 - 1
					$west[0] = 0
					$west[1] = $yp2
					$east[0] = $x_pixel
					$east[1] = $yp2
					$north[0] = $xp2
					$north[1] = 0
					$south[0] = $xp2
					$south[1] = $y_pixel
					DllCall("gdi32.dll", "int", "SetROP2", "int", $MyHDC[0], "int", 2)
					DllCall("gdi32.dll", "int", "MoveToEx", "ptr", $MyHDC[0], "int", $west[0], "int", $west[1], 'ptr', 0)
					DllCall("gdi32.dll", "int", "LineTo", "int", $MyHDC[0], "int", $east[0], "int", $east[1])
					DllCall("gdi32.dll", "int", "MoveToEx", "ptr", $MyHDC[0], "int", $north[0], "int", $north[1], 'ptr', 0)
					DllCall("gdi32.dll", "int", "LineTo", "int", $MyHDC[0], "int", $south[0], "int", $south[1])
				EndIf
				If $draw_coord Then
					$str = " " & $xy[0] & ", " & $xy[1] & " "
					$str = StringFormat("%." & StringLen($str) + 1 & "s", $str)
					DllCall("gdi32.dll", "int", "SetBkMode", "int", $MyHDC[0], "int", 2)
					DllCall("gdi32.dll", "int", "TextOut", "int", $MyHDC[0], "int", $west[0] + 2, "int", $south[1] - 20, "string", $str, "int", StringLen($str))
				EndIf
				WinSetOnTop($MyhWnd, "", 1)
			EndIf
			DllCall("user32.dll", "int", "ReleaseDC", "int", $DeskHDC[0], "hwnd", 0)
		EndIf
		DllCall("user32.dll", "int", "ReleaseDC", "int", $MyHDC[0], "hwnd", $MyhWnd)
		;to gui
		GUICtrlSetData($labelMousePos, "X: " & $xy[0] & "    Y: " & $xy[1])
		$Color = Hex(PixelGetColor($xy[0], $xy[1]), 6)
		GUICtrlSetData($labelHex, "Hex: " & $Color)
		GUICtrlSetBkColor($labelHexColor, "0x" & $Color)
	WEnd
	;addition
	Opt("WinTitleMatchMode", 1)
	Opt("MouseCoordMode", 0)
	HotKeySet("{ESC}", "GlobalReturn")
	HotKeySet("{PAUSE}")
	HotKeySet("{F1}")
	HotKeySet("{RIGHT}")
	HotKeySet("{LEFT}")
	HotKeySet("{UP}")
	HotKeySet("{DOWN}")
	HotKeySet("^{PGDN}")
	HotKeySet("^{END}")
	HotKeySet("^{DEL}")
	Return 0
EndFunc   ;==>AU3MAG
Func Quit()
	$quit = 1
	ToolTip("")
EndFunc   ;==>Quit
Func GridToggle()
	If $draw_grid = 0 Then
		$draw_grid = 1
	Else
		$draw_grid = 0
	EndIf
EndFunc   ;==>GridToggle
Func CoordToggle()
	If $draw_coord = 0 Then
		$draw_coord = 1
	Else
		$draw_coord = 0
	EndIf
EndFunc   ;==>CoordToggle
Func ShadowToggle()
	If $draw_me = 0 Then
		$draw_me = 1
	Else
		$draw_me = 0
	EndIf
EndFunc   ;==>ShadowToggle
Func Magarea_Up()
	If $x_pixel > @DesktopWidth / 2 Then Return
	$x_pixel = $x_pixel + $marea_increment
	$y_pixel = $y_pixel + $marea_increment
EndFunc   ;==>Magarea_Up
Func Magarea_Down()
	If $x_pixel < 20 Then Return
	$x_pixel = $x_pixel - $marea_increment
	$y_pixel = $y_pixel - $marea_increment
EndFunc   ;==>Magarea_Down
Func Zoom_Up()
	If $zoom - $zoom_increment <= 0 Then Return
	$zoom = $zoom - $zoom_increment
EndFunc   ;==>Zoom_Up
Func Zoom_Down()
	$zoom = $zoom + $zoom_increment
EndFunc   ;==>Zoom_Down
Func Help()
	$msg = "A-Zoom Keys:" & @LF & @LF & "Esc,Pause - exit" & @LF
	$msg = $msg & "Ctrl-Delete - toggle magnification area display" & @LF
	$msg = $msg & "Ctrl-End " & "-" & " toggle mouse coordinate display" & @LF
	$msg = $msg & "Ctrl-PageDown " & "-" & " toggle crosshair display" & @LF
	$msg = $msg & "UP-Arrow - increase magnification" & @LF & "DOWN-Arrow - decrease magnification" & @LF
	$msg = $msg & "RIGHT-Arrow - increase magnification area" & @LF & "LEFT-Arrow - decrease magnification area" & @LF & @LF
	$msg = $msg & "Current values:" & @LF
	$msg = $msg & "Magnification area width: " & $x_pixel & " pixel" & @LF
	$msg = $msg & "Magnification area height: " & $y_pixel & " pixel" & @LF
	$msg = $msg & "Zoom factor: 1:" & StringFormat("%.1f", $x_pixel / $zoom) & @LF
	MsgBox(4096, "A-Zoom Instructions", $msg)
EndFunc   ;==>Help
#endregion --- AU#MAG ---


Func ExcelWindow()
	SplashTextOn("Creating Excel", "Please Wait", 200, 50)
	$oExcel = ObjCreate("OWC.Spreadsheet")
	$GUIexcel = GUICreate("Embedded Web Control", 600, 600, -1, -1, $WS_SIZEBOX + $WS_SYSMENU + $WS_MINIMIZEBOX + $WS_MAXIMIZEBOX)
	GUISetState(@SW_HIDE, $GUIexcel)
	GUISetState(@SW_LOCK, $GUIexcel)
	$GUIActiveX = GUICtrlCreateObj($oExcel, 0, 0, 595, 570)
	GUICtrlSetResizing($GUIActiveX, 1)
	Dim $AllColorsNew[1]
	$Width = 1
	$Height = 1
	;redo x/y
	For $i = 1 To $gAllColors[0]
		$ret = StringSplit($gAllColors[$i], "|")
		If $i = 1 Then
			$xBase = $ret[2]
			$yBase = $ret[3]
			$ret[2] = 1
			$ret[3] = 1
			_ArrayAdd($AllColorsNew, $ret[1] & "|1|1")
		Else
			$ret[2] = $ret[2] - $xBase + 1
			$ret[3] = $ret[3] - $yBase + 1
			_ArrayAdd($AllColorsNew, $ret[1] & "|" & $ret[2] & "|" & $ret[3])
		EndIf
		If $Width < $ret[2] Then
			$Width = $ret[2]
		EndIf
		If $Height < $ret[3] Then
			$Height = $ret[3]
		EndIf
		If $gReturn = 1 Then
			SplashOff()
			GUIDelete($GUIexcel)
			Return 0
		EndIf
	Next
	$AllColorsNew[0] = UBound($AllColorsNew) - 1
	For $i = 1 To $AllColorsNew[0]
		$ret = StringSplit($AllColorsNew[$i], "|")
		If $ret[2] <= 702 Then	;column limit in embedded excel - excel limit is 256
			$oExcel.Activesheet.Cells ($ret[3], $ret[2]).Value = "0x" & $ret[1]
			$oExcel.Activesheet.Rows ($i).RowHeight = 15
		EndIf
		If $gReturn = 1 Then
			SplashOff()
			GUIDelete($GUIexcel)
			Return 0
		EndIf
	Next
	$oExcel.Activesheet.Columns ("A:ZZ").ColumnWidth = 49
	$oExcel.Activesheet.Range ("A1:ZZ6000").Font.Size = 7
	SplashOff()
	$oExcel = ""
	GUISetState(@SW_UNLOCK, $GUIexcel)
	GUISetState(@SW_SHOW, $GUIexcel)
	GUISetState()
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseExcelWindow")
EndFunc   ;==>ExcelWindow