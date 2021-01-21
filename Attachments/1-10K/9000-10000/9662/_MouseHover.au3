;====================================================================================================================================
;	UDF Name: _MouseHover.au3
;	
;	Author: marfdaman (Marvin)
;
;	Contributions: RazerM (adding SetText parameter to _HoverFound and _HoverUndo).
;	
;	email: marfdaman at gmail dot com
;	
;	Use: Enable hover events for controls
;
;	Note(s): If you want to use this i.c.w. an AdlibEnable in your current script, make your Adlib call "_HoverCheck()" as well.
;	In this case, _HoverOn must NOT be called.
;====================================================================================================================================
#include <Array.au3>
#include-once

Local $HoverArray[1], $ControlID, $Global_I = 0, $__ControlID, $HoverActive = 0, $Temp_Found = 0, $szTemp_Array[2]


;===============================================================================
; Description:			_HoverAddCtrl
; Parameter(s):		$___ControlID -> Control ID of control to be hoverchecked
;
; Requirement:			Array.au3
; Return Value(s):	None
;===============================================================================
Func _HoverAddCtrl($___ControlID)
	_ArrayAdd($HoverArray, $___ControlID)
EndFunc




;===============================================================================
; Description:			Checks whether the mousecursor is hovering over any of the defined controls.
; Parameter(s):		None
; Requirement:			None
; Return Value(s):	If a control has matched, an array will be returned, with $array[1] being either
;					"AcquiredHover" or "LostHover". $array[2] will contain the control ID.
;					It is recommended that you put this function in an AdlibEnable, since it's EXTREMELY
;					resource friendly.
;===============================================================================
Func _HoverCheck()
	$HoverData = GUIGetCursorInfo()
	If Not IsArray($HoverData) Then Exit
	$Temp_Found = 0
	For $i = 1 To UBound($HoverArray)-1
		If $HoverData[4] = $HoverArray[$i] Then
			$Temp_Found = $i
		EndIf
	Next
	Select
		Case $Temp_Found = 0 And $HoverActive = 1 Or $Temp_Found <> 0 And $Temp_Found <> $Global_I And $HoverActive = 1
			$HoverActive = 0
			$Temp_Found = 0
			$szTemp_Array[0] = "LostHover"
			$szTemp_Array[1] = $HoverArray[$Global_I]
			Return $szTemp_Array
		Case $Temp_Found > 0 And $HoverActive = 0
			$Global_I = $Temp_Found
			$HoverActive = 1
			$Temp_Found = 0
			$szTemp_Array[0] = "AcquiredHover"
			$szTemp_Array[1] = $HoverArray[$Global_I]
			Return $szTemp_Array
	EndSelect
EndFunc