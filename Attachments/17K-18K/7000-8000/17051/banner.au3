#include <Guiconstants.au3>
#include <Array.au3>
#include <file.au3>
#include "Char_Def.au3"
Opt("GUIOnEventMode", 1)


;VARIABLES-----------------------------------------------
Global Const $Row = 10, $Column = 70
Global Const $dim_red = 0x660000
Global Const $red = 0xff0000
Global Const $Pixel_Size = 2, $Spacing = 3
Global Const $Aux_Col = 700
Global $label[$Row][$Column]
Global $color[$Row][$Column]
Global $Message_len = 0
Global $AUX[10][$Aux_Col]
Dim $File_Dir = @MyDocumentsDir&"\banner.txt"
Dim $Text
;--------------------------------------------------------

;GUI-----------------------------------------------------
$main = GUICreate("Banner",$Column*$Spacing,$Row*$Spacing,100,100)
GUISetBkColor(0x000000,$main)
;--------------------------------------------------------

;LABELS--------------------------------------------------
For $i = 0 To $Row-1
	For $j = 0 To $Column-1
		$label[$i][$j] = GUICtrlCreateLabel("",$j*$Spacing,$i*$Spacing,$Pixel_Size,$Pixel_Size)
		GUICtrlSetBkColor($label[$i][$j],$dim_red)
		$color[$i][$j] = $dim_red
	Next
Next
;--------------------------------------------------------

GUISetState()

If Not FileExists($File_Dir) Then
	_FileCreate($File_Dir)
	$file = FileOpen($File_Dir, 2)
	FileWrite($file,"BANNER")
	FileClose($file)
EndIf

$Text = FileRead($File_Dir)

Aux_fill($Text)
;~ _ArrayDisplay($AUX)

GUISetOnEvent($GUI_EVENT_CLOSE, "quit")
;MESSAGE LOOP--------------------------------------------
While 1

	scroll($AUX)

WEnd
;--------------------------------------------------------

Func scroll($auxilary)
	Dim $count = 0
	Dim $frequency = $Message_len * 10
	Dim $Aux_pt = 0
	Dim $area =$Column-2
	
	While $count < $frequency
		;FILL LAST COLUMN---------------------------------------------
		For $i = 0 To 9
			If $auxilary[$i][$Aux_pt] = 1 Then
				GUICtrlSetBkColor($label[$i][$Column-1],$red)
				$color[$i][$Column-1] = $red
			Else
				GUICtrlSetBkColor($label[$i][$Column-1],$dim_red)
				$color[$i][$Column-1] = $dim_red
			EndIf
		Next
		;-------------------------------------------------------------
		;SHIFT TO THE LEFT--------------------------------------------
		For $j = 0 To $Column-2
			For $i = 0 To 9
				If $color[$i][$j] <> $color[$i][$j+1] Then
					GUICtrlSetBkColor($label[$i][$j], $color[$i][$j+1])
					$color[$i][$j] = $color[$i][$j+1]
				EndIf
			Next
		Next
		;-------------------------------------------------------------
		
		$count += 1
		$Aux_pt += 1
		If $Aux_pt > $Aux_Col-1 Then
			$Aux_pt = 0
		EndIf
	WEnd
EndFunc

Func Aux_fill($text = "banner")
	Dim $char
	Dim $char_count = 0
	Dim $k 
	Dim $i = 0,$j = 0,$offset = 0
	Dim $Found = False
	Dim $avail_slot = $Aux_Col/7
	
	$text = StringUpper($text)
	$Message_len = 0
	While $char_count < $avail_slot And $text <> ""
		For $k = 0 To $Total_char -1
			If $char[$k][0] = StringLeft($text,1) Then
				$c = $char[$k][1]
				$Found = True
			EndIf
		Next
		$text = StringTrimLeft($text,1)
		$c = StringSplit($c,",")
;~ 		_ArrayDisplay($c)
		
		$k = 1
		If $Found = True Then
			For $i = 0 To $Row-1
				For $j = $offset To 6+$offset	
					If $c[$k] = 1 Then		
						$AUX[$i][$j+$offset] = 1
					EndIf
					$k += 1
				Next
			Next
			$char_count += 1
			$offset += 4
			$Found = False
			$Message_len += 1
		EndIf
;~ 		_ArrayDisplay($AUX)

	WEnd
	
EndFunc

Func quit()
	Exit
EndFunc