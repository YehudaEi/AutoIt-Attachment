Global $winclose_sett
Global $winmin_sett

Func VistaGUI($TitleParent,$ParentWidth, $ParentHeight, $ParentBgColor, $ChildBgColor, $ClosePic, $MinPic)
	$Parent = GUICreate($TitleParent, $ParentWidth, $ParentHeight, -1, -1, $WS_POPUP)
    GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
    GUISetBkColor($ParentBgColor)
	GUISetState(@SW_DISABLE)
	GUISetState(@SW_SHOW)
	WinSetTrans($Parent,"",100)
	_GuiRoundCorners($Parent, 0, 0, 15, 15)
	$Child = GUICreate("", $ParentWidth-50, $ParentHeight-50, 22,-3, $WS_POPUP,$WS_EX_LAYERED+$WS_EX_MDICHILD,$Parent)
	GUISetBkColor($ChildBgColor)
	$winclose_sett = GUICtrlCreatePic ($ClosePic,400,0,43,17, BitOR($SS_NOTIFY,$WS_GROUP))
	$winmin_sett = GUICtrlCreatePic ($MinPic,375,0,26,17, BitOR($SS_NOTIFY,$WS_GROUP))
	GUISetState(@SW_SHOW)
	_GuiRoundCorners($Child, 0, 0, 15, 15)
	WinSetTrans($Child,"",238)
EndFunc


Func _Over($Pic, $PicSrc1,$PicSrc2)
	If $tempID = $Pic Then
		GUICtrlSetImage($Pic,$PicSrc2)
	Else
		GUICtrlSetimage($Pic,$PicSrc1)
	EndIf
EndFunc


Func _GuiRoundCorners($h_win, $i_x1, $i_y1, $i_x3, $i_y3);==>_GuiRoundCorners
   Dim $pos, $ret, $ret2
   $pos = WinGetPos($h_win)
    $ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long",  $i_x1, "long", $i_y1, "long", $pos[2], "long", $pos[3], "long", $i_x3,  "long", $i_y3)
   If $ret[0] Then
      $ret2 = DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $ret[0], "int", 1)
      If $ret2[0] Then
         Return 1
      Else
         Return 0
      EndIf
   Else
      Return 0
   EndIf
EndFunc ;==>_GuiRoundCorners







#region _ControlHover;
;===============================================================================
;	UDF Name: _ControlHover.au3 
;
;	Version v1.2.0  Sept 25, 2006, built with Autoit 3.2.1.3
;
;	Author: Valuater, Robert M
;
;	Contributions: marfdaman(Marvin), RazerM, Quaizywabbit(AnyGUI).
;	
;	Email: <Valuater [at] aol [dot] com>
;	
;	Use: Enable Mouse/Hover Over Control Events
;===============================================================================

#include-once
#include<Array.au3>

Global $cHoverID[2], $Global_cHID = 0, $cHoverActive = 0, $cHClicked = 0

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
	If not @Compiled Then Opt("TrayIconDebug", 1) ; 1=debug line info
	
	Select
		Case $cH_Mode = 0 Or $cH_Mode = 1 ; 0 = Check if mouse is over a control, 1 = Check if mouse clicked on a control 
			
			; Developer did not add any controls before the function mode 0 or 1 was called
			If UBound($cHoverID) = 2 Then ConsoleWrite("*** _ControlHover() Error *** " & @CRLF & "No Controls were Added" & @CRLF) 
			
			If $cH_hWin = "" Then 
				$cH_Data = GUIGetCursorInfo() ; Get cursor data from the active window
			Else
				If Not WinActive($cH_hWin) Then Return SetError( -1, 1, "Window not active") ; Dont waist CPU if the known window is not active
				$cH_Data = GUIGetCursorInfo($cH_hWin) ; Get cursor data from the known window
			EndIf
			
			If Not IsArray($cH_Data) Then Return SetError( -1, 2, "Window not found") ; A readable GUI window was not found
			
			For $cH_i = 1 to UBound($cHoverID) -1 ; Search the known controls for the currently hovered control 
				If $cH_Data[4] = $cHoverID[$cH_i] Then ; Mouse is over a current known control
					
					; Mode 1 - check for a Click on a known control
					If $cH_Mode And $cH_Data[2] = 1 and Not $cHClicked Then
						$cHClicked = 1
						Return SetError( 0, $cHoverID[$Global_cHID], 1) ; Mouse clicked on current control
					ElseIf $cH_Mode And $cH_Data[2] <> 1 And $cHClicked Then
						$cHClicked = 0
						Return SetError( 1, $cHoverID[$Global_cHID], 0) ; Release clicked current control
					EndIf
					If $cH_Mode Then Return SetError ( "", "", "") ; Mouse is still over last known control and may click again
					
					; Mode 0 & 1
					If $cHoverID[$cH_i] = $cHoverID[$Global_cHID] And $cHoverActive Then Return SetError ( "", "", "") ; Mouse is still over last known control
					If $cHoverActive Then 
						$cHoverActive = 0
						Return SetError( 1, $cHoverID[$Global_cHID], 0) ; Release Active - Mouse is over a new known control
					EndIf
					$cHoverActive = 1
					$cHoverID[$Global_cHID] = $cHoverID[$cH_i] ; Re-set the current control to the new known control
					Return SetError(0, $cHoverID[$Global_cHID], 1) ; Mouse is over the new-current known control
					
				EndIf
			Next
			; hover control not found in the known control list
			If $cHoverActive Then 
				If  $cH_Mode And $cHClicked Then  ; check - Release clicked current control
					$cHClicked = 0
					Return SetError( 1, $cHoverID[$Global_cHID], 0) ; Release clicked current control
				EndIf
				If $cH_Mode Then Return SetError ( "", "", "") ; Protect the release of the active control
				$cHoverActive = 0
				Return SetError( 1, $cHoverID[$Global_cHID], 0) ; Release Active - Mouse is over a new unknown control
			EndIf
			If  $cH_Mode And $cHClicked Then
				$cHClicked = 0
				Return SetError( 1, $cHoverID[$Global_cHID], 0) ; Release clicked current control
			EndIf
			Return SetError ( "", "", "")
		
		Case $cH_Mode = 2 ; Add the new control to the known control list
			
			If $cH_hCntrl = "" Then Return SetError( -1, 8, "Control not provided #1") ; The control ID was not given
			_ArrayAdd($cHoverID, $cH_hCntrl) ; Add the control to the known control array
			If @error Then Return SetError( -1, 9, "Control not added") ; Control not added to the known control list
			Return SetError( 0, 10, 1) ; ; Control was added to the known control list
			
		Case $cH_Mode = 3 ; Remove the control from the known control list
			
			If $cH_hCntrl = "" Then Return SetError( -1, 11, "Control not provided #2") ; The control ID was not given
			_ArrayDelete($cHoverID, $cH_hCntrl) ; Delete the control from the known control array list
			If @error Then Return SetError( -1, 12, "Control not removed") ; Control not deleted from the known control list
			Return SetError( 0, 13, 1) ; Control was deleted from the known control list
			
		Case $cH_Mode = 4 ; Verify if control is in the known control list
			
			If $cH_hCntrl = "" Then Return SetError( -1, 14, "Control not provided #3") ; The control ID was not given
			_ArraySearch($cHoverID, $cH_hCntrl) ; Search to verify if control is in the known control list
			If @error Then Return SetError( -1, 15, "Control not found") ; Control was not found in the known control list
			Return SetError( 0, 16, 1) ; Control was found in the known control list
			
		Case Else
			Return SetError( -1, 17, "$cH_Mode incorrect") ; $cH_Mode has an incorrect value
	EndSelect
	Return SetError( -1, 18, "Unknown Error") ; Error is Unknown
EndFunc
#endregion