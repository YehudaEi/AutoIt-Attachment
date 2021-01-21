; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Program Name: Capture Pro                                                     +
; Description: Saves the entire scrren (or a window) in JPEG format.            +
; Author: Jordan Berry (Jordban)                                                +
; Date: Jull 22, 2006                                                           +
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Script Init                                                                   +
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#include <GUIConstants.au3>

Dim $filenames, $qualitys, $intervals, $xs, $ys, $widths, $heights, $i = 0, $capture = 0, $setboxflag = 0, $message = 0

If Not FileExists("captured") Then
	DirCreate("captured")
EndIf

; GUI setup
Opt("GUIOnEventMode", 1)
$mainwindow = GUICreate("Capture Pro Version 0.1", 275, 198)
GUISetIcon("icon.ico")

; labels
GUICtrlCreateLabel("Filename:", 8, 11)
GUICtrlCreateLabel("Interval:", 8, 33)
GUICtrlCreateLabel("(1000 = 1 second)", 122, 33)
GUICtrlCreateLabel("Quality:", 8, 55)
GUICtrlCreateLabel("(0-100)", 93, 55)
GUICtrlCreateLabel("Start X:", 8, 77)
GUICtrlCreateLabel("Start Y:", 8, 99)
GUICtrlCreateLabel("Width:", 8, 121)
GUICtrlCreateLabel("Height:", 8, 143)

; input
$filename = GUICtrlCreateInput("screen_capture_", 55, 8, 120, 20)
$interval = GUICtrlCreateInput("1000", 55, 30, 60, 20)
$quality = GUICtrlCreateInput("60", 55, 52, 30, 20)
$x = GUICtrlCreateInput("0", 55, 74, 40, 20)
$y = GUICtrlCreateInput("0", 55, 96, 40, 20)
$width = GUICtrlCreateInput("0", 55, 118, 40, 20)
$height = GUICtrlCreateInput("0", 55, 140, 40, 20)

; buttons
$startselected = GUICtrlCreateButton("Capture Region", 40, 168, 100, 22)
$startwhole = GUICtrlCreateButton("Capture All", 160, 168, 100, 22)
$setbox = GUICtrlCreateButton("Set Selected Capture Region", 110, 100, 150, 22)
$stopcapture = GUICtrlCreateButton("Stop Capture", 140, 134, 80, 22)

; styles
GUICtrlSetStyle($interval, $ES_NUMBER)
GUICtrlSetStyle($quality, $ES_NUMBER)
GUICtrlSetStyle($x, $ES_NUMBER)
GUICtrlSetStyle($y, $ES_NUMBER)
GUICtrlSetStyle($width, $ES_NUMBER)
GUICtrlSetStyle($height, $ES_NUMBER)
GUICtrlSetStyle($filename, $ES_OEMCONVERT)

; events
GUISetOnEvent($GUI_EVENT_CLOSE, "Exitp")
GuiCtrlSetOnEvent($setbox, "SetBox")
GuiCtrlSetOnEvent($startselected, "StartCaptureSelected")
GuiCtrlSetOnEvent($startwhole, "StartCaptureWhole")
GuiCtrlSetOnEvent($stopcapture, "StopCapturing")

GUISetState(@SW_SHOW)

; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Main Loop                                                                     +
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
While 1
	If $setboxflag = 1 Then
		If $message = 1 Then
			ToolTip("Put mouse at top left corner of box." & @LF & "Then push space.")
		ElseIf $message = 2 Then
			ToolTip("Put mouse at bottom right corner of box." & @LF & "Then push space.")
		EndIf
	EndIf
	If $capture = 1 Then
		Sleep($intervals)
		$i = $i + 1
		CaptureScreen("captured/" & $filenames & $i & ".jpg", $xs, $ys, $widths, $heights, $qualitys)
	EndIf
WEnd
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Functions                                                                     +
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Func CaptureScreen($filename, $x, $y, $width, $height, $quality)
	Return DllCall("captdll.dll", "int", "CaptureRegion", "str", $filename, "int", $x, "int", $y, "int", $width, "int", $height, "int", $quality)
EndFunc   ;==>CaptureScreen

Func Exitp()
	Exit
EndFunc   ;==>Exitp

Func CordSet()
	If $setboxflag = 1 Then
		If $message = 1 Then
			$pos = MouseGetPos()
			Global $tempx = $pos[0]
			Global $tempy = $pos[1]
			GUICtrlSetData($x, $tempx)
			GUICtrlSetData($y, $tempy)
			$message = 2
		Else
			$pos = MouseGetPos()
			$tempwidth = $pos[0] - $tempx
			$tempheight = $pos[1] - $tempy
			If $tempwidth < 0 Then
				$tempwidth = $tempwidth * - 1
			EndIf
			If $tempheight < 0 Then
				$tempheight = $tempheight * - 1
			EndIf
			GUICtrlSetData($width, $tempwidth)
			GUICtrlSetData($height, $tempheight)
			ToolTip("")
			$setboxflag = 0;
			GUISetState(@SW_SHOW)
			HotKeySet("{SPACE}")
			
			
		EndIf
	Else
		
	EndIf
EndFunc   ;==>CordSet

Func SetBox()
	$message = 1
	$setboxflag = 1;
	GUISetState(@SW_HIDE)
	HotKeySet("{SPACE}", "CordSet")
EndFunc   ;==>SetBox

Func StartCaptureSelected()
	$filenames = GUICtrlRead($filename)
	$intervals = GUICtrlRead($interval)
	$qualitys = GUICtrlRead($quality)
	$xs = GUICtrlRead($x)
	$ys = GUICtrlRead($y)
	$widths = GUICtrlRead($width)
	$heights = GUICtrlRead($height)
	If ValidateInput() = 0 Then
		$capture = 1;
	EndIf
EndFunc   ;==>StartCaptureSelected

Func StartCaptureWhole()
	$filenames = GUICtrlRead($filename)
	$qualitys = GUICtrlRead($quality)
	$intervals = GUICtrlRead($interval)
	$xs = 0
	$ys = 0
	$widths = @DesktopWidth
	$heights = @DesktopHeight
	If ValidateInput() = 0 Then
		$capture = 1;
	EndIf
EndFunc   ;==>StartCaptureWhole
Func ValidateInput()
	$errorflag = 0
	$errorlog = ""
	If $qualitys < 0 Or $qualitys > 100 Then
		$errorflag = 1
		$errorlog = $errorlog & @LF & "Quality must be between 0 and 100."
	EndIf
	If $intervals < 0 Then
		$errorflag = 1
		$errorlog = $errorlog & @LF & "Interval can't be less than 0."
	EndIf
	
	If $errorflag = 1 Then
		MsgBox(16, "Error(s)", "These error(s) were found:" & $errorlog)
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>ValidateInput

Func StopCapturing()
	If $i = 0 Then
		MsgBox(16, "Stop?", "Haven't started yet!")
	Else
		$tempi = $i
		$i = 0
		$capture = 0
		MsgBox(64, "Success!", $tempi & " Screenshots were taken.")
	EndIf
EndFunc   ;==>StopCapturing