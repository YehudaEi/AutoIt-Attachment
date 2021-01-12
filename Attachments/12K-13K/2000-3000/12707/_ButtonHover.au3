
#region _ButtonHover;
;===============================================================================
;	UDF Name: _ButtonHover.au3
;
;	Version v1.0.0  January 1, 2007, built with Autoit 3.2.1.+
;
;	Author: Valuater, Robert M
;
;	Contributions: marfdaman(Marvin), RazerM, Quaizywabbit(AnyGUI).
;
;	Email: <Valuater [at] aol [dot] com>
;
;	Use: Mouse/Hover Over Buttons with chamge picture events
;===============================================================================

#include-once
#include <GUIConstants.au3>
#include <Array.au3>

Global $cHoverID[2], $Global_cHID = 0, $cHoverActive = 0, $cHClicked = 0, $XButton_Location, $XBType

;===============================================================================
;
; Function Name:    _ControlHover()
; Description:      Enable Mouse/Hover Over Control Events
;					Find if Mouse is over a known control
;					Find if a Mouse has Clicked on a known control
;					Add, Remove, or Verify the control within the known control list
; Parameter(s):     $cH_Mode	[default]   	0 = Find if Mouse is over a known control
;                           	[optional]		1 = Find if a Mouse has Clicked on a known control
;                           					2 = Add a control to the known control list
;                           					3 = Remove a control from the known control list
;                           					4 = Verify a control is in the known control list
;                   $cH_hWin	[optional]   	- Window handle as returned by GUICreate()
;								[preferred]		- Window handle to save CPU usage and speed of _ControlHover()
;												- and Avoid array errors for "non-active window"
;                   $cH_hCntrl	[required]   	- Control ID to Add, Remove, or Verify the control within the known control list
;								[not used]		- to find if a mouse is over or has clicked on a known control
; Requirement(s):   #include<Array.au3>
; Return Value(s):
;					$cH_Mode 0 or 1
;								On Success 	Return = 1		@error = 0, @extended = Current known control
;                   			While Success Return = ""
;                   			On Failure: Return = 0		@error = 1, @extended = Last known control
;					$cH_Mode 2, 3, or 4
;								On Success 	Return = 1		@error = 0, @extended = Function's return line number
;					All $cH_Mode's
;                   			On Error: 	Return = Description of the error
;															@error = -1, @extended = Function's return line number
; Author(s):        Valuater, Robert M
;
;===============================================================================
Func _ControlHover($cH_Mode = 0, $cH_hWin = "", $cH_hCntrl = "")
	
	Local $cH_i, $cH_Data
	If Not @Compiled Then Opt("TrayIconDebug", 1) ; 1=debug line info
	
	Select
		Case $cH_Mode = 0 Or $cH_Mode = 1 ; 0 = Check if mouse is over a control, 1 = Check if mouse clicked on a control
			
			; Developer did not add any controls before the function mode 0 or 1 was called
			If UBound($cHoverID) = 2 Then ConsoleWrite("*** _ControlHover() Error *** " & @CRLF & "No Controls were Added" & @CRLF)
			
			If $cH_hWin = "" Then
				$cH_Data = GUIGetCursorInfo() ; Get cursor data from the active window
			Else
				If Not WinActive($cH_hWin) Then Return SetError(-1, 1, "Window not active") ; Dont waist CPU if the known window is not active
				$cH_Data = GUIGetCursorInfo($cH_hWin) ; Get cursor data from the known window
			EndIf
			
			If Not IsArray($cH_Data) Then Return SetError(-1, 2, "Window not found") ; A readable GUI window was not found
			
			For $cH_i = 1 To UBound($cHoverID) - 1 ; Search the known controls for the currently hovered control
				If $cH_Data[4] = $cHoverID[$cH_i] Then ; Mouse is over a current known control
					
					; Mode 1 - check for a Click on a known control
					If $cH_Mode And $cH_Data[2] = 1 And Not $cHClicked Then
						$cHClicked = 1
						Return SetError(0, $cHoverID[$Global_cHID], 1) ; Mouse clicked on current control
					ElseIf $cH_Mode And $cH_Data[2] <> 1 And $cHClicked Then
						$cHClicked = 0
						Return SetError(1, $cHoverID[$Global_cHID], 0) ; Release clicked current control
					EndIf
					If $cH_Mode Then Return SetError("", "", "") ; Mouse is still over last known control and may click again
					
					; Mode 0 & 1
					If $cHoverID[$cH_i] = $cHoverID[$Global_cHID] And $cHoverActive Then Return SetError("", "", "") ; Mouse is still over last known control
					If $cHoverActive Then
						$cHoverActive = 0
						Return SetError(1, $cHoverID[$Global_cHID], 0) ; Release Active - Mouse is over a new known control
					EndIf
					$cHoverActive = 1
					$cHoverID[$Global_cHID] = $cHoverID[$cH_i] ; Re-set the current control to the new known control
					Return SetError(0, $cHoverID[$Global_cHID], 1) ; Mouse is over the new-current known control
					
				EndIf
			Next
			; hover control not found in the known control list
			If $cHoverActive Then
				If $cH_Mode And $cHClicked Then  ; check - Release clicked current control
					$cHClicked = 0
					Return SetError(1, $cHoverID[$Global_cHID], 0) ; Release clicked current control
				EndIf
				If $cH_Mode Then Return SetError("", "", "") ; Protect the release of the active control
				$cHoverActive = 0
				Return SetError(1, $cHoverID[$Global_cHID], 0) ; Release Active - Mouse is over a new unknown control
			EndIf
			If $cH_Mode And $cHClicked Then
				$cHClicked = 0
				Return SetError(1, $cHoverID[$Global_cHID], 0) ; Release clicked current control
			EndIf
			Return SetError("", "", "")
			
		Case $cH_Mode = 2 ; Add the new control to the known control list
			
			If $cH_hCntrl = "" Then Return SetError(-1, 8, "Control not provided #1") ; The control ID was not given
			_ArrayAdd($cHoverID, $cH_hCntrl) ; Add the control to the known control array
			If @error Then Return SetError(-1, 9, "Control not added") ; Control not added to the known control list
			Return SetError(0, 10, 1) ; ; Control was added to the known control list
			
		Case $cH_Mode = 3 ; Remove the control from the known control list
			
			If $cH_hCntrl = "" Then Return SetError(-1, 11, "Control not provided #2") ; The control ID was not given
			_ArrayDelete($cHoverID, $cH_hCntrl) ; Delete the control from the known control array list
			If @error Then Return SetError(-1, 12, "Control not removed") ; Control not deleted from the known control list
			Return SetError(0, 13, 1) ; Control was deleted from the known control list
			
		Case $cH_Mode = 4 ; Verify if control is in the known control list
			
			If $cH_hCntrl = "" Then Return SetError(-1, 14, "Control not provided #3") ; The control ID was not given
			_ArraySearch($cHoverID, $cH_hCntrl) ; Search to verify if control is in the known control list
			If @error Then Return SetError(-1, 15, "Control not found") ; Control was not found in the known control list
			Return SetError(0, 16, 1) ; Control was found in the known control list
			
		Case Else
			Return SetError(-1, 17, "$cH_Mode incorrect") ; $cH_Mode has an incorrect value
	EndSelect
	Return SetError(-1, 18, "Unknown Error") ; Error is Unknown
EndFunc   ;==>_ControlHover

Func _HoverButton($XBtext, $XBleft, $XBtop, $XBwidth, $XBheight, $XBcolor = "")
	If Not FileExists($XButton_Location & "\") Then
		MsgBox(64, "Error", " $XButton_Location - was not found    ", 3)
		Return
	EndIf
	If FileExists($XButton_Location & "\Normal.gif") Then
		$XBType = ".gif"
	ElseIf FileExists($XButton_Location & "\Normal.jpg") Then
		$XBType = ".jpg"
	ElseIf FileExists($XButton_Location & "\Normal.bmp") Then
		$XBType = ".bmp"
	Else
		MsgBox(64, "Error", " Unknown Button file type ( not - gif, jpg, or bmp )    ", 3)
		Return
	EndIf
	Local $Xbtn[2]
	$Xbtn[0] = GUICtrlCreatePic($XButton_Location & "\Normal" & $XBType, $XBleft, $XBtop, $XBwidth, $XBheight)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$Xbtn[1] = GUICtrlCreateLabel($XBtext, $XBleft, $XBtop, $XBwidth, $XBheight, $SS_NOTIFY & $SS_CENTER)
	If $XBcolor <> "" Then GUICtrlSetColor(-1, $XBcolor)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	_ControlHover(2, "", $Xbtn[1])
	Return $Xbtn[0]
EndFunc   ;==>_HoverButton

Func _CheckHoverAndPressed($_GUI = "")
	$CtrlId2 = _ControlHover(1, $_GUI)
	$tempID2 = @extended
	If $CtrlId2 = 1 Then
		GUICtrlSetImage($tempID2 - 1, $XButton_Location & "\Press" & $XBType)
	ElseIf $CtrlId2 = 0 Then
		GUICtrlSetImage($tempID2 - 1, $XButton_Location & "\Over" & $XBType)
	EndIf
	$CtrlId = _ControlHover(0, $_GUI)
	$tempID = @extended
	If $CtrlId = 1 Then
		GUICtrlSetImage($tempID - 1, $XButton_Location & "\Over" & $XBType)
	ElseIf $CtrlId = 0 Then
		GUICtrlSetImage($tempID - 1, $XButton_Location & "\Normal" & $XBType)
	EndIf
EndFunc   ;==>_CheckHoverAndPressed
#endregion