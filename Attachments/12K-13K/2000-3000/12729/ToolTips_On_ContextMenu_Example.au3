;Menu With Timed Tooltips
;Stephen Podhajecki [eltorro] gehossafats@netmdc.com
;
;Converted to GUIOnEventMode (0.2) by [Sunaj]
;Changes/updates:
;
;a) Removes need for Sleep() = smoother GUI
;b) Removes debugging engine, use original by eltorro for debugging
;c) Changes msg pull interval to be faster, no CPU usage difference 
;	noticed.
;d) Works with context menus now - hack had to be implemented because
;   context menus do NOT allow for registering when mouse is moved away in
;   the same way as normal menus. Works in uniform way for both type of
;   menus now.
;e) 0.2 fixes problem where tooltip would be wrongly shown if user moved
;	mouse quickly over a context menu, tweak EventLoop() as needed.


#include <GuiConstants.au3>
#include <Array.au3>

Opt("GUIOnEventMode", 1)

Global $USE_TOOLTIP = True
Local $aCtrlArray[1], $aCtrlMsgArray[1], $ControlID
Global $defaultstatus = "Ready"
Global $status
Global $MenuItemId
Global $IDLECounter			 = 0		; When 5 is reached tooltip is closed
Global $EVENT
Global $TIMERENABLED         = False    ; Flag set when SetTimer api is called
Global $TIP_TIMER                       ; Timestamp holder for tooltip visiblilty
Global Const $TIP_TIMER_ID   = 999      ; Timer id for SetTimer api
Global Const $TIPSHOW        = 1        ; Event
Global Const $TIPVISIBLE     = 2        ; Event
Global Const $TIP_TTL        = 2333     ; how long to show tooltip
Global Const $TIP_DELAY      = 333      ; how long to wait to show tooltip
Global Const $MSG_INTERVAL   = 33       ; Interval Windows will use to send

;Window Message Hooks.
Global Const $WM_MENUSELECT       = 0x011F
Global Const $WM_TIMER            = 0x0113
Global Const $WM_ENTERIDLE  	  = 0x0121

;GUIRegisterMsg ($WM_ENTERMENULOOP, "MenuTipHandler")
GUIRegisterMsg ($WM_MENUSELECT, "MenuTipHandler")
GUIRegisterMsg ($WM_ENTERIDLE ,"MenuTipHandler") ; to make context menues disappear when moving pointer off menu without closing it
GuiRegisterMsg ($WM_TIMER, "TimerCallBack")

$Form1 = GUICreate('Menu ToolTips', 400, 285)

;Normal menu initialization
$filemenu = GUICtrlCreateMenu("&File")
_AddCtrl($filemenu, "FileMenu")
$file1 = GUICtrlCreateMenu("Label 1", $filemenu)
$file2 = GUICtrlCreateMenuitem("Label 2", $filemenu)
_AddCtrl($file2, "Label 2 at Your Service")
$file3 = GUICtrlCreateMenuitem("Label3", $filemenu)
_AddCtrl($file3, "Pleased to meet you from Label 3")
$file4 = GUICtrlCreateMenuitem("Label 4", $filemenu)
_AddCtrl($file4, "Well, you get the picture, Label 4")
$statuslabel = GUICtrlCreateLabel($defaultstatus, 0, 250, 300, 16, BitOR($SS_SIMPLE, $SS_SUNKEN))
$statuslabel2 = GUICtrlCreateLabel($defaultstatus, 300, 250, 100, 16, BitOR($SS_SIMPLE, $SS_SUNKEN))
$file11 = GUICtrlCreateMenuitem("Label 11", $file1)
_AddCtrl($file11, "This is Label11 subitem of Label1")

;Context menu initialization
$hContextmenu    = GUICtrlCreateContextMenu ()
$hFileitem       = GUICtrlCreateMenuitem ("Open", $hContextmenu)
_AddCtrl($hFileitem,"Works in context menuitem '$hFileitem' as well!")
$hSaveitem       = GUICtrlCreateMenuitem ("Save", $hContextmenu)
_AddCtrl($hSaveitem,"Works in context menuitem '$hSaveitem' as well!")
$hInfoitem       = GUICtrlCreateMenuitem ("Info", $hContextmenu)
_AddCtrl($hInfoitem,"Works in context menuitem '$hInfoitem' as well!")

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

GUISetState()

While 1
	Sleep(333)
WEnd

Func EventLoop()
	Select
		Case $EVENT = $TIPSHOW
			If $IDLECounter < 11 Then ; this if/then fixes 'quick move over' problem with context menu
				If $TIP_TIMER Then
					If ((TimerDiff($TIP_TIMER) >= $TIP_DELAY) And ($MenuItemId > 0)) Then ShowMenuTip()
				EndIf
			EndIf
		Case $EVENT = $TIPVISIBLE
			If TimerDiff($TIP_TIMER) >= $TIP_TTL + $TIP_DELAY Then VoidMenuTip()
	EndSelect
EndFunc

Func _AddCtrl($ControlID, $ControlMsg)
	_ArrayAdd($aCtrlArray, $ControlID)
	_ArrayAdd($aCtrlMsgArray, $ControlMsg)
EndFunc

Func ShowMenuTip()
	For $x = 0 To UBound($aCtrlArray) - 1
		If $MenuItemId = ($aCtrlArray[$x]) Then
			GUICtrlSetData($statuslabel, $aCtrlMsgArray[$x])
			ToolTip($aCtrlMsgArray[$x])
			$EVENT = $TIPVISIBLE
			$IDLECounter = 0
			ExitLoop
		EndIf
	Next
EndFunc

Func VoidMenuTip()
	ToolTip("")
	GUICtrlSetData($statuslabel, $defaultstatus)
	$TIP_TIMER = 0
EndFunc

Func StartTimer($hWndGUI, $TimerId, $Interval)
	If $TIMERENABLED = True Then StopTimer($hWndGUI,$TimerId)
	$retval = DllCall("User32.dll", "int", "SetTimer", "hwnd", $hWndGUI, "int", $TimerId, "int", $Interval, "int", 0)
	$TIMERENABLED = True
EndFunc

Func StopTimer($hWndGUI, $TimerId)
	$retval = DllCall("User32.dll", "int", "KillTimer", "hwnd", $hWndGUI, "int", $TimerId)
	$TIMERENABLED = False
EndFunc

Func TimerCallBack($hWndGUI, $MsgID, $WParam, $LParam)
	Local $TimerId = BitAND($WParam, 0xFFFF)
	If $TimerId = $TIP_TIMER_ID Then EventLoop()
	Return $GUI_RUNDEFMSG
EndFunc

Func MenuTipHandler($hWndGUI, $MsgID, $WParam, $LParam)
	$IDLECounter += 1
	If $IDLECounter > 4 Then ;make context tip disappear on move away
		ToolTip("")
		GUICtrlSetData($statuslabel, $defaultstatus)
	EndIf
	Local $id = BitAND($WParam, 0xFFFF)
	If $MsgID = $WM_MENUSELECT Then
		If $USE_TOOLTIP Then
			StartTimer($Form1, $TIP_TIMER_ID, $MSG_INTERVAL)
			If Not ($MenuItemId = $id) Or ($MenuItemId = $id) Then
				$MenuItemId = $id
				ToolTip("")
				$IDLECounter = 0
				If $MenuItemId > 0 Then
					$TIP_TIMER = TimerInit()
					$EVENT = $TIPSHOW
				EndIf
			EndIf
		EndIf
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc

Func _Exit()
	Exit
EndFunc