; include needed data
#include <ScrollBarConstants.au3>
#include <GUIScrollBars.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>

; No auto pause when click autoit tray icon
AutoItSetOption("TrayAutoPause", 0)
; Remove exit and pause from the tray menu
Opt("TrayMenuMode",1)
; Disable exit on ESC
AutoItSetOption("GUICloseOnESC", 0)

; Make a menu for the tray icon
global $trayitemlogdir = TrayCreateItem("Logdir")
global $trayitemlog = TrayCreateItem("Log")
global $trayaboutitem = TrayCreateItem("About")
TrayCreateItem("")
global $trayexititem = TrayCreateItem("Exit")
TraySetState()

Global $_GUI = True
dim $scroll = False
dim $right = 10 ; Right space
dim $rowh = 20 ; Row height
; Get num elements
dim $size = 10
dim $width = 505
dim $totheight = $size * (($rowh - 1) + 1) + 20
dim $maxheight = @DesktopHeight - 100
dim $windowheight
dim $diff = -1
if($totheight > $maxheight) Then
	$windowheight = @DesktopHeight - 100
	$scroll = true
	$diff = (($totheight - $maxheight))
Else
	$windowheight = $totheight
EndIf
dim $hGUI = GuiCreate("Gui window", $width, $windowheight, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX))
GUICtrlSetResizing($hGUI, $GUI_DOCKMENUBAR)
; Menu
$filemenu = GUICtrlCreateMenu("File")
Global $menuinstall = GUICtrlCreateMenuItem("Installeren", $filemenu)
Global $menuexit = GUICtrlCreateMenuItem("Exit", $filemenu)
$editmenu = GUICtrlCreateMenu("Edit")
Global $editsall = GUICtrlCreateMenuItem("Select all", $editmenu)
Global $editsnone = GUICtrlCreateMenuItem("Select none", $editmenu)
Global $editsinv = GUICtrlCreateMenuItem("Inverse select", $editmenu)
$helpmenu = GUICtrlCreateMenu("?")
Global $aboutmenuitem = GUICtrlCreateMenuItem("About", $helpmenu)
; Make a rightclick menu on the gui
$trackmenu = GuiCtrlCreateContextMenu ()
Global $aboutrightclickitem = GuiCtrlCreateMenuitem ("About",$trackmenu)

Global $checkbox[($size + 1)]
$checkbox[0] = $size
;_ArrayDisplay($array)
;GUISetStyle (-1, $WS_VSCROLL)
FOR $i = 1 TO $size ; Look touch all the software things
	$checkbox[$i] = GuiCtrlCreateCheckbox($i, $right, (($rowh * $i) - $rowh))
	GUICtrlSetResizing( -1, 2 + 32 + 256 + 512)
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
NEXT

GUIRegisterMsg($WM_VSCROLL, "WM_VSCROLL")
GUIRegisterMsg($WM_SIZE, "WM_SIZE")
_GUIScrollBars_Init($hGUI)
;_GUIScrollBars_ShowScrollBar($hGUI, $SB_HORZ, false)
_GUIScrollBars_ShowScrollBar($hGUI, $SB_VERT, true)

GUISetState(@SW_SHOW)
While 1
	if(checkevents(10)) Then
		ExitLoop
	EndIf
WEnd
Exit 0


func setselectstate($cb, $type="inv")
		dim $size = $cb[0]
		for $i = 1 To $size
			switch $type
				case "none"
					GuiCtrlSetState($cb[$i], $GUI_UNCHECKED)
				case "all"
					GuiCtrlSetState($cb[$i], $GUI_CHECKED)
				case Else
					switch GUICtrlRead($cb[$i])
						case $GUI_CHECKED
							GuiCtrlSetState($cb[$i], $GUI_UNCHECKED)
						Case $GUI_UNCHECKED
							GuiCtrlSetState($cb[$i], $GUI_CHECKED)
					EndSwitch
			EndSwitch
		Next
EndFunc

#cs================================================
Check the defaul GUI buttons

@param none
@return bool ; if true it need to exit a loop
#CE
func checkevents($wait = 10) 
	dim $bool = false
	dim $i = 1
	while ($i < $wait)
		dim $msg = GuiGetMsg()
		dim $tray = TrayGetMsg()
		Select 
			case $tray = $trayexititem or ($_GUI and ($msg = $GUI_EVENT_CLOSE or $msg = $menuexit))
				exit 
			case $tray = $trayaboutitem or ($_GUI and ($msg = $aboutmenuitem or $msg = $aboutrightclickitem))
				about()
			case $_GUI and $msg = $menuinstall
				return true
			case $_GUI and $msg = $editsall
				setselectstate($checkbox, "all")
			case $_GUI and $msg = $editsnone
				setselectstate($checkbox, "none")
			case $_GUI and $msg = $editsinv
				setselectstate($checkbox, "inv")
		EndSelect
		$i = $i + 1
	WEnd
	return $bool
EndFunc

#cs================================================
Shows about box
@param none
@return void
#CE
func about()
	MsgBox(0, "GUI", "Myinstaller v "& @CRLF &"Created by Pimmetje" & @CRLF & "Please report bugs you may find." & @CRLF & "Known bugs," & @CRLF & "* GUI scrollbar gets to big (atm better then non)")
EndFunc

Func WM_VSCROLL($hWnd, $Msg, $wParam, $lParam)
	#forceref $Msg, $wParam, $lParam
	Local $nScrollCode = BitAND($wParam, 0x0000FFFF)
	Local $index = -1, $yChar, $yPos
	Local $Min, $Max, $Page, $Pos, $TrackPos

	For $x = 0 To UBound($aSB_WindowInfo) - 1
		If $aSB_WindowInfo[$x][0] = $hWnd Then
			$index = $x
			$yChar = $aSB_WindowInfo[$index][3]
			ExitLoop
		EndIf
	Next
	If $index = -1 Then Return 0


	; Get all the vertial scroll bar information
	Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_VERT)
	$Min = DllStructGetData($tSCROLLINFO, "nMin")
	$Max = DllStructGetData($tSCROLLINFO, "nMax")
	$Page = DllStructGetData($tSCROLLINFO, "nPage")
	; Save the position for comparison later on
	$yPos = DllStructGetData($tSCROLLINFO, "nPos")
	$Pos = $yPos
	$TrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")

	Switch $nScrollCode
		Case $SB_TOP ; user clicked the HOME keyboard key
			DllStructSetData($tSCROLLINFO, "nPos", $Min)

		Case $SB_BOTTOM ; user clicked the END keyboard key
			DllStructSetData($tSCROLLINFO, "nPos", $Max)

		Case $SB_LINEUP ; user clicked the top arrow
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - 1)

		Case $SB_LINEDOWN ; user clicked the bottom arrow
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + 1)

		Case $SB_PAGEUP ; user clicked the scroll bar shaft above the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - $Page)

		Case $SB_PAGEDOWN ; user clicked the scroll bar shaft below the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + $Page)

		Case $SB_THUMBTRACK ; user dragged the scroll box
			DllStructSetData($tSCROLLINFO, "nPos", $TrackPos)
	EndSwitch
	
;~    // Set the position and then retrieve it.  Due to adjustments
;~    //   by Windows it may not be the same as the value set.

	DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
	_GUIScrollBars_GetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
	;// If the position has changed, scroll the window and update it
	$Pos = DllStructGetData($tSCROLLINFO, "nPos")

	If ($Pos <> $yPos) Then
		_GUIScrollBars_ScrollWindow($hWnd, 0, $yChar * ($yPos - $Pos))
		$yPos = $Pos
	EndIf

	Return $GUI_RUNDEFMSG

EndFunc   ;==>WM_VSCROLL

Func WM_SIZE($hWnd, $Msg, $wParam, $lParam)
	#forceref $Msg, $wParam
	Local $index = -1, $yChar, $xChar, $xClientMax, $xClient, $yClient, $ivMax
	For $x = 0 To UBound($aSB_WindowInfo) - 1
		If $aSB_WindowInfo[$x][0] = $hWnd Then
			$index = $x
			$xClientMax = $aSB_WindowInfo[$index][1]
			$xChar = $aSB_WindowInfo[$index][2]
			$yChar = $aSB_WindowInfo[$index][3]
			$ivMax = $aSB_WindowInfo[$index][7]
			ExitLoop
		EndIf
	Next
	If $index = -1 Then Return 0

	Local $tSCROLLINFO = DllStructCreate($tagSCROLLINFO)
	
	; Retrieve the dimensions of the client area.
	$xClient = BitAND($lParam, 0x0000FFFF)
	$yClient = BitShift($lParam, 16)
	$aSB_WindowInfo[$index][4] = $xClient
	$aSB_WindowInfo[$index][5] = $yClient
	
	; Set the vertical scrolling range and page size
	DllStructSetData($tSCROLLINFO, "fMask", BitOR($SIF_RANGE, $SIF_PAGE))
	DllStructSetData($tSCROLLINFO, "nMin", 0)
	DllStructSetData($tSCROLLINFO, "nMax", $ivMax)
	DllStructSetData($tSCROLLINFO, "nPage", $yClient / $yChar)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
	
	; Set the horizontal scrolling range and page size
	DllStructSetData($tSCROLLINFO, "fMask", BitOR($SIF_RANGE, $SIF_PAGE))
	DllStructSetData($tSCROLLINFO, "nMin", 0)
	DllStructSetData($tSCROLLINFO, "nMax", 2 + $xClientMax / $xChar)
	DllStructSetData($tSCROLLINFO, "nPage", $xClient / $xChar)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE