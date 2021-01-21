; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         K.Y.Chan <92cyclone@gmail.com>
;
; Script Function: Center Text and create new lines.
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Text positioning V1.00
; If something's bugged, please mail me.

#include <GUIConstants.au3>
;;		Setup data		;;
$width	=	250
$height	=	150
$handle	=	GUICreate("Mini Screen",$width,$height)
$close	=	GUICtrlCreateButton(" Close Screen ",$width*0.35,$height*0.7)
HotKeySet("{ENTER}", "StopProgram")

;;		Using the GUICtrlCreateLabelPos()		;;
$MyMsg	=	"Hello, this script centers and also creates#a new line using the Hex as a new line :).#Have fun with it!"

GUICtrlCreateLabelPos("*#*#*#*#*#*#*#*","left")
GUICtrlCreateLabelPos($MyMsg,"center")
GUICtrlCreateLabelPos("*#*#*#*#*#*#*#*","right")

;$MyMsg	=	"Please be carefull when using this script,# if you use center_label more then once,# it can overlay the previous."
;GUICtrlCreateLabelPos($MyMsg,"center")

;;		Show GUI and Loop		;;
GUISetState(@SW_SHOW,$handle)

while 1
	$event	=	GUIGetMsg()

	Select
		Case $event = $GUI_EVENT_CLOSE or $event = $close
			Exit
			
	EndSelect
WEnd

Exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;		Functions		;;
Func GUICtrlCreateLabelPos($msg,$pos)
	$lines	=	StringSplit($msg,"#")	;; Strip rule into lines. (first array = numbers of splits)
	$max	=	UBound($lines)			;; Starts with 1 and ends with array max +1.
	$pos	=	StringLower($pos)
	
	For $int = 1 To $max-1 Step +1
		$chars	=	StringLen($lines[$int])					;; Example: 50 chars/2 = 25 chars
		If $pos="left"	Then $target=$width*0.05
		If $pos="center"Then $target=$width/2-$chars*2.25	;; Use 4.5 for positioning with the default Font
		If $pos="right"	Then $target=$width*0.95-$chars+1
		
		
		GUICtrlCreateLabel($lines[$int],$target,15*$int)
	Next
		
	EndFunc
Func StopProgram()
	Exit
EndFunc