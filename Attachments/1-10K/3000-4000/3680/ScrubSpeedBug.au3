; Test scrub bug

;AutoItSetOption ( "TrayIconDebug", 1)
AutoItSetOption ( "MouseCoordMode", 1 ) ; full-screen pos
AutoItSetOption("WinTitleMatchMode", 4) ; advanced mode

RunScrubTestIter("", 1)

; Outputs debug strings - use DebugView or similar to catch debug messages
Func DebugPrint($debugString)
  DllCall("kernel32.dll", "none", "OutputDebugString", "str", $debugString)
EndFunc

Func DebugPrintFlush()
	For $i = 1 to 10
		DebugPrint(" ")
	Next
	Sleep(2000)
EndFunc

Func RunScrubTestIter($ProjectPath, $RunIter)
	$origDragDelay = AutoItSetOption ("MouseClickDragDelay", 50) ;50 milliseconds
	$ScrubSpeed1 = 100
	$TimeLineScrubberVPos = 623
	$ScrubHMin = 559
	$ScrubHMax = 1018
	$ScrubWidth = $ScrubHMax - $ScrubHMin

	Local $ScrubTimeStart = TimerInit()

	MouseClickDrag ( "left", $ScrubHMin, $TimeLineScrubberVPos, $ScrubHMax, $TimeLineScrubberVPos, $ScrubSpeed1 ) ;
	MouseClickDrag ( "left", $ScrubHMax, $TimeLineScrubberVPos, $ScrubHMin+$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubSpeed1 ) ;
	MouseClickDrag ( "left", $ScrubHMin+$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubHMin+2*$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubSpeed1 ) ;
	MouseClickDrag ( "left", $ScrubHMin+2*$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubHMin+3*$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubSpeed1 ) ;
	MouseClickDrag ( "left", $ScrubHMin+3*$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubHMin+2*$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubSpeed1 ) ;
;	Send("=") ; Zoom in
	MouseClickDrag ( "left", $ScrubHMin+2*$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubHMin+1*$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubSpeed1 ) ;
	MouseClickDrag ( "left", $ScrubHMin+1*$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubHMin+2*$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubSpeed1 ) ;
;	Send("=") ; Zoom in
	MouseClickDrag ( "left", $ScrubHMin+2*$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubHMin+3*$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubSpeed1 ) ;
	MouseClickDrag ( "left", $ScrubHMin+3*$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubHMin+2*$ScrubWidth/6, $TimeLineScrubberVPos, $ScrubSpeed1 ) ;

	Local $ScrubTime = TimerDiff($ScrubTimeStart)
	Local $OutMsg = "Scrub Time: " & $ScrubTime
	DebugPrint($OutMsg)

	MsgBox(0, "Scrub Test", $OutMsg)
	DebugPrintFlush()

	AutoItSetOption("MouseClickDragDelay", $origDragDelay)
EndFunc
