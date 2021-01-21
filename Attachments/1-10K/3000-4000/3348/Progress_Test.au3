#include <GUIConstants.au3>
#include "Progress.au3"
#include <Array.au3>

If Not IsDeclared('Dark_Green') Then Dim $Dark_Green = 0x006400
If Not IsDeclared('Red') Then Dim $Red = 0xff0000
If Not IsDeclared('Yellow') Then Dim $Yellow = 0xffff00

GUICreate("My GUI Progressbar", 220, 200, 100, 200)

;~ _Progress_Create (left, top, width, height[,style[,backcolor[,progressbar color[,text color[,invert text color]]]]]) Returns Control Id for Progress Bar
Dim $h_progress

$button = GUICtrlCreateButton("Start", 75, 70, 70, 20)
$button_Create1 = GUICtrlCreateButton("Create 1", 5, 120, 70, 20)
$button_Create2 = GUICtrlCreateButton("Create 2", 5, 150, 70, 20)
$button_Delete1 = GUICtrlCreateButton("Delete", 140, 120, 70, 20)
$button_Delete2 = GUICtrlCreateButton("Delete", 140, 150, 70, 20)
GUISetState()

$wait = 50; wait time in ms for next progressstep
$s = 0; progressbar-saveposition
Do
	$msg = GUIGetMsg()
	Select
		Case $msg = $button
			GUICtrlSetData($button, "Stop")
			For $i = $s To 100
				$m = GUIGetMsg()
				
				If $m = -3 Then ExitLoop
				
				If $m = $button Then
					GUICtrlSetData($button, "Next")
					$s = $i;save the current bar-position to $s
					ExitLoop
				Else
					$s = 0
					_Progress_Update ($h_progress[0], $i)
					If UBound($h_progress) == 2 Then
						_Progress_Update ($h_progress[1], (100 - $i))
					EndIf
					Sleep($wait)
				EndIf
			Next
			If $i > 100 Then
				GUICtrlSetData($button, "Start")
			EndIf
		Case $msg = $button_Create1
			If IsArray($h_progress) Then
				ReDim $h_progress[UBound($h_progress) + 1]
			Else
				Dim $h_progress[1]
			EndIf
			$h_progress[UBound($h_progress) - 1] = _Progress_Create (10, 10, 200, 20, -1, -1, $Red, -1, $Yellow)
		Case $msg = $button_Create2
			If IsArray($h_progress) Then
				ReDim $h_progress[UBound($h_progress) + 1]
			Else
				Dim $h_progress[1]
			EndIf
			$h_progress[UBound($h_progress) - 1] = _Progress_Create (10, 40, 200, 20, -1, -1, $Dark_Green, -1, $Yellow)
		Case $msg = $button_Delete1
			; _Progress_Delete (array, progress bar id)
			If IsArray($h_progress) Then
				_Progress_Delete ($h_progress, $h_progress[0])
			EndIf
		Case $msg = $button_Delete2
			; _Progress_Delete (array, progress bar id)
			If IsArray($h_progress) Then
				_Progress_Delete ($h_progress, $h_progress[UBound($h_progress) - 1])
			EndIf
	EndSelect
Until $msg = $GUI_EVENT_CLOSE
