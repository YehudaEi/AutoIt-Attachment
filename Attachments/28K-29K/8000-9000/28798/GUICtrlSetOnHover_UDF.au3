#include-once

;_GUICtrl_SetOnHover Global Variables
Global $aHOVER_CONTROLS_ARRAY[1][1]
Global $aLAST_HOVERED_ELEMENT[2] 					= [-1, -1]
Global $aLAST_HOVERED_ELEMENT_MARK 					= -1
Global $hLAST_CLICKED_ELEMENT_MARK 					= -1
Global $iHOVER_CONTROLS_MODIFIED					= 0
Global $iHOVER_ON_BACKGROUND_WINDOW					= 1
Global $iLAST_PRIMARYDOWN_CTRLID					= 0

Global $__GUICtrl_SetOnHover_pTimerProc 			= 0
Global $__GUICtrl_SetOnHover_iTimerID 				= 0

Global $__GUICtrl_SetOnHover_sOriginal_OnExitFunc 	= Opt("OnExitFunc", "__GUICtrl_SetOnHover_OnAutoItExit")

Global Const $__GUICtrl_SetOnHover_WM_COMMAND		= 0x0111
Global Const $__GUICtrl_SetOnHover_WM_LBUTTONDOWN	= 0x0201

#Region =================== UDF Info ===================
; UDF Name:    _GUICtrl_SetOnHover
; Forum link:  http://www.autoitscript.com/forum/index.php?s=&showtopic=55120
; Author:      G.Sandler a.k.a MrCreatoR (CreatoR's Lab,                           )
;
; 
; {Version History}:
;
; [v1.8] - [28.09.2009]
; * Few Global variables now have more unique name.
; * Fixed an issue with false calling of function on PrimaryDown event. I.e when the user clicks on other place (not on the hovered control) and drag the cursor to the control, the PrimaryDown function was called.
; * Due to (and as a result of) previous issue, the UDF now registering WM_COMMAND and WM_LBUTTONDOWN messages at first UDF call.
; 
;
; [v1.7] - [07.07.2009]
; + Added _GUICtrl_SetHoverOnBackWindow...
;      Allows to set the hovering mode:
;             $iSetBackWin = 1 (default) hovering process will proceed even when GUI is not active (in background).
;             $iSetBackWin <> 1 hovering process will NOT proceed when GUI is not active.
;
;
; [v1.6] - [12.06.2009]
; * Now the UDF compatible with scripts (or other udfs) that uses OnAutoItExit function.
;      i.e: "OnAutoItExit" function that was *previously* set by user will be called as well.
;
; + Added new parameter $iKeepCall_Hover_Func. If this parameter = 1, 
;      then the $sHover_Func function *Will* be called constantly untill the control is no longer been hovered
;      (default is 0, do not call the function constantly).
; + Added new arguments to calling function...
;      The OnPrimaryDown/Up function now can recieve one more argument:
;                                        $iClickMode - Defines the Click mode (1 - Pressed, 2 - Released)
;
; Changed return value - function will return 2 when $iCtrlID is redefined (ReSet, already exists in the controls list).
;
; Fixed incorrect documentation parts.
; Fixed "OnClick" handeling. When using multiple GUIs, the active gui was not recognized properly.
; Fixed(?) bug with "dimension range exceeded" when trying to UnSet a Control.
;
; [v1.5]
; + Added AutoIt 3.2.10.0+ support, but 3.2.8.1 or less is dropped :( (due to lack of native CallBack functions).
; + Added Primary Down and Primary Up support. Helping to handle with the buttons pressing.
; + Added new arguments to calling function...
;      The OnHover function now can recieve two more arguments:
;                                        $iHoverMode - Defines the hover mode (1 - Hover, 2 - Leaves Hovering)
;                                        $hWnd_Hovered - Control Handle where the mouse is moved to (after hovering).
;
; * Almost all code of this UDF was rewritted.
; * Now the main function name is _GUICtrl_SetOnHover(),
;    but for backwards compatibility reasons, other (old) function names are still supported.
; * Fixed bug with hovering controls in other apps.
; * Improvements in generaly, the UDF working more stable now.
;
; [v1.?]
; * Beta changes, see "Forum link" for more details.
;
; [v1.0]
; * First release.
#EndRegion =================== UDF Info ===================
;

;===============================================================================
;
; Function Name:    _GUICtrl_SetOnHover()
; Description:      Set function(s) to call when hovering/leave hovering GUI elements.
;
; Parameter(s):     $iCtrlID              - The Ctrl ID to set hovering for (can be a -1 as indication to the last item created).
;
;                   $sHover_Func          - [Optional] Function to call when the mouse is hovering the control.
;                                             If this parameter passed as empty string (""),
;                                             then the specified CtrlID is UnSet from Hovering Handler list.
;
;                   $sLeaveHover_Func     - [Optional] Function to call when the mouse is leaving hovering the control
;                       (-1 no function used).
;                     * For both parameters, $sHover_FuncName and $sLeaveHover_FuncName,
;                       the specified function called with maximum 3 parameters:
;                                                     $iCtrlID      - CtrlID of hovered control.
;                                                     $iHoverMode   - Defines the hover mode (1 - Hover, 2 - Leaves Hovering).
;                                                     $hWnd_Hovered - Control Handle where the mouse is moved to (after hovering).
;
;                   $sPrimaryDownFunc     - [Optional] Function to call when Primary mouse button is *clicked* on the control.
;                       (-1 -> function is not called).
;
;                   $sPrimaryUpFunc       - [Optional] Function to call when Primary mouse button is *released* the control.
;                       (-1 -> function is not called).
;
;                     * For both parameters, $sPrimaryDownFunc and $sPrimaryUpFunc,
;                       the specified function called with maximum 2 parameters:
;                                                     $iCtrlID      - CtrlID of clicked control.
;                                                     $iClickMode   - Defines the click mode (1 - Pressed, 2 - Released).
;
;                   $iKeepCall_PrDn_Func  - [Optional] If this parameter < 1,
;                                            then the $sPrimaryDownFunc function will *Not* be called constantly untill
;                                            the primary mouse button is released (default behaviour - $iKeepCall_PrDn_Func = 1).
;
;                   $iKeepCall_Hover_Func - [Optional] If this parameter = 1,
;                                            then the $sHover_Func function *Will* be called constantly untill
;                                            the control is no longer been hovered (default behaviour - $iKeepCall_Hover_Func = 0).
;
; Return Value(s):  Always returns 1, except when $iCtrlID is redefined (ReSet, already exists in the controls list),
;                      in this case the return value is 2.
;
; Requirement(s):   AutoIt 3.2.10.0 +
;
; Note(s):          1) TreeView/ListView Items can not be set :(.
;                   2) When the window is not active, the hover/leave hover functions will still called,
;                      but not when the window is disabled.
;                   3) The hover/leave hover functions will be called even if the script is paused by such functions as MsgBox().
;                   4) It is not recommended to block the HoverFunc by calling functions like Sleep() or MsgBox().
;                   5) This UDF registering WM_COMMAND and WM_LBUTTONDOWN messages.
;
; Author(s):        G.Sandler (a.k.a CreatoR).
;
;===============================================================================
Func _GUICtrl_SetOnHover($iCtrlID, $sHover_Func="", $sLeaveHover_Func=-1, $sPrimaryDownFunc=-1, $sPrimaryUpFunc=-1, $iKeepCall_PrDn_Func=1, $iKeepCall_Hover_Func=0)
	Local $hCtrlID = GUICtrlGetHandle($iCtrlID)
	
	If $__GUICtrl_SetOnHover_pTimerProc = 0 Then
		$__GUICtrl_SetOnHover_pTimerProc = DllCallbackRegister("__MAIN_CALLBACK_ONHOVER_PROC", "none", "hwnd;int;int;dword")
		$__GUICtrl_SetOnHover_iTimerID = DllCall("User32.dll", "int", "SetTimer", "hwnd", 0, _
			"int", TimerInit(), "int", 10, "ptr", DllCallbackGetPtr($__GUICtrl_SetOnHover_pTimerProc))
		
		GUIRegisterMsg($__GUICtrl_SetOnHover_WM_COMMAND, "__GUICtrl_SetOnHover_WM_COMMAND")
		GUIRegisterMsg($__GUICtrl_SetOnHover_WM_LBUTTONDOWN, "__GUICtrl_SetOnHover_WM_LBUTTONDOWN")
		
		If IsArray($__GUICtrl_SetOnHover_iTimerID) Then $__GUICtrl_SetOnHover_iTimerID = $__GUICtrl_SetOnHover_iTimerID[0]
	EndIf
	
	;UnSet Hovering for specified control (remove control id from hovering checking process)
	If $sHover_Func = "" And @NumParams <= 2 Then
		Local $aHOVER_CONTROLS_Tmp[1][1]
		Local $aHOVER_CONTROLS_Swap = $aHOVER_CONTROLS_ARRAY ;This one prevents a bug with "dimension range exceeded"
		
		For $i = 1 To $aHOVER_CONTROLS_Swap[0][0]
			If $hCtrlID <> $aHOVER_CONTROLS_Swap[$i][0] Then
				$aHOVER_CONTROLS_Tmp[0][0] += 1
				ReDim $aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]+1][7]
				
				$aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]][0] = $aHOVER_CONTROLS_Swap[$i][0]
				$aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]][1] = $aHOVER_CONTROLS_Swap[$i][1]
				$aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]][2] = $aHOVER_CONTROLS_Swap[$i][2]
				$aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]][3] = $aHOVER_CONTROLS_Swap[$i][3]
				$aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]][4] = $aHOVER_CONTROLS_Swap[$i][4]
				$aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]][5] = $aHOVER_CONTROLS_Swap[$i][5]
				$aHOVER_CONTROLS_Tmp[$aHOVER_CONTROLS_Tmp[0][0]][6] = $aHOVER_CONTROLS_Swap[$i][6]
			EndIf
		Next
		
		If $aHOVER_CONTROLS_Tmp[0][0] < 1 Then
			__GUICtrl_SetOnHover_ReleaseResources_Proc() ;Release the callbacks
		Else
			$iHOVER_CONTROLS_MODIFIED = 1
			$aHOVER_CONTROLS_ARRAY = $aHOVER_CONTROLS_Tmp
		EndIf
		
		Return 1
	EndIf
	
	;Check if the hovering process already handle the passed CtrlID, if so, just assign new values (functions)
	For $i = 1 To $aHOVER_CONTROLS_ARRAY[0][0]
		If $hCtrlID = $aHOVER_CONTROLS_ARRAY[$i][0] Then
			$aHOVER_CONTROLS_ARRAY[$i][0] = $hCtrlID
			$aHOVER_CONTROLS_ARRAY[$i][1] = $sHover_Func
			$aHOVER_CONTROLS_ARRAY[$i][2] = $sLeaveHover_Func
			$aHOVER_CONTROLS_ARRAY[$i][3] = $sPrimaryDownFunc
			$aHOVER_CONTROLS_ARRAY[$i][4] = $sPrimaryUpFunc
			$aHOVER_CONTROLS_ARRAY[$i][5] = $iKeepCall_PrDn_Func
			$aHOVER_CONTROLS_ARRAY[$i][6] = $iKeepCall_Hover_Func
			
			Return 2
		EndIf
	Next
	
	$aHOVER_CONTROLS_ARRAY[0][0] += 1
	ReDim $aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]+1][7]
	
	$aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]][0] = $hCtrlID
	$aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]][1] = $sHover_Func
	$aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]][2] = $sLeaveHover_Func
	$aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]][3] = $sPrimaryDownFunc
	$aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]][4] = $sPrimaryUpFunc
	$aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]][5] = $iKeepCall_PrDn_Func
	$aHOVER_CONTROLS_ARRAY[$aHOVER_CONTROLS_ARRAY[0][0]][6] = $iKeepCall_Hover_Func
	
	Return 1
EndFunc

;Backwards compatibility function #1
Func GUICtrl_SetOnHover($iCtrlID, $sHover_Func="", $sLeaveHover_Func=-1, $sPrimaryDownFunc=-1, $sPrimaryUpFunc=-1, $iKeepCall_PrDn_Func=1, $iKeepCall_Hover_Func=0)
	_GUICtrl_SetOnHover($iCtrlID, $sHover_Func, $sLeaveHover_Func, $sPrimaryDownFunc, $sPrimaryUpFunc, $iKeepCall_PrDn_Func, $iKeepCall_Hover_Func)
EndFunc

;Backwards compatibility function #2
Func GUICtrlSetOnHover($iCtrlID, $sHover_Func="", $sLeaveHover_Func=-1, $sPrimaryDownFunc=-1, $sPrimaryUpFunc=-1, $iKeepCall_PrDn_Func=1, $iKeepCall_Hover_Func=0)
	_GUICtrl_SetOnHover($iCtrlID, $sHover_Func, $sLeaveHover_Func, $sPrimaryDownFunc, $sPrimaryUpFunc, $iKeepCall_PrDn_Func, $iKeepCall_Hover_Func)
EndFunc

;Backwards compatibility function #3
Func _GUICtrlSetOnHover($iCtrlID, $sHover_Func="", $sLeaveHover_Func=-1, $sPrimaryDownFunc=-1, $sPrimaryUpFunc=-1, $iKeepCall_PrDn_Func=1, $iKeepCall_Hover_Func=0)
	_GUICtrl_SetOnHover($iCtrlID, $sHover_Func, $sLeaveHover_Func, $sPrimaryDownFunc, $sPrimaryUpFunc, $iKeepCall_PrDn_Func, $iKeepCall_Hover_Func)
EndFunc

;Set the hovering mode:
;                      $iSetBackWin = 1 (default) hovering process will proceed even when GUI is not active (in background).
;                      $iSetBackWin <> 1 hovering process will NOT proceed when GUI is not active.
Func _GUICtrl_SetHoverOnBackWindow($iSetBackWin)
	$iHOVER_ON_BACKGROUND_WINDOW = Number($iSetBackWin = 1)
EndFunc

;CallBack function to handle the hovering process
Func __MAIN_CALLBACK_ONHOVER_PROC($hWnd, $uiMsg, $idEvent, $dwTime)
	$iHOVER_CONTROLS_MODIFIED = 0
	
	If $aHOVER_CONTROLS_ARRAY[0][0] < 1 Then Return
	
	If $iHOVER_ON_BACKGROUND_WINDOW Then
		Local $iControl_Hovered = _ControlGetHovered()
	Else
		Local $iControl_Hovered = GUIGetCursorInfo()
		If Not IsArray($iControl_Hovered) Then Return
		
		$iControl_Hovered = GUICtrlGetHandle($iControl_Hovered[4])
	EndIf
	
	Local $sCheck_LHE = $aLAST_HOVERED_ELEMENT[1]
	Local $iCheck_LCEM = $hLAST_CLICKED_ELEMENT_MARK
	Local $iCtrlID
	
	;Leave Hovering Process and reset variables
	If Not $iControl_Hovered Or ($sCheck_LHE <> -1 And $iControl_Hovered <> $sCheck_LHE) Then
		If $aLAST_HOVERED_ELEMENT_MARK = -1 Then Return
		
		If $aLAST_HOVERED_ELEMENT[0] <> -1 Then
			$iCtrlID = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $aLAST_HOVERED_ELEMENT[1])
			If IsArray($iCtrlID) Then $iCtrlID = $iCtrlID[0]
			
			;2 is the indicator of OnLeavHover process
			__GUICtrl_SetOnHover_Call_Proc($aLAST_HOVERED_ELEMENT[0], $iCtrlID, 2, $iControl_Hovered)
		EndIf
		
		$aLAST_HOVERED_ELEMENT[0] = -1
		$aLAST_HOVERED_ELEMENT[1] = -1
		$aLAST_HOVERED_ELEMENT_MARK = -1
		$hLAST_CLICKED_ELEMENT_MARK = -1
	Else ;Hovering Process, Primary Down/Up handler, and set LAST_HOVERED_ELEMENT
		If $iHOVER_CONTROLS_MODIFIED = 1 Then
			$iHOVER_CONTROLS_MODIFIED = 0
			Return
		EndIf
		
		Local $iUbound = UBound($aHOVER_CONTROLS_ARRAY)-1
		
		For $i = 1 To $aHOVER_CONTROLS_ARRAY[0][0]
			If $i > $iUbound Then ExitLoop
			
			If $aHOVER_CONTROLS_ARRAY[$i][0] = $iControl_Hovered Then
				$iCtrlID = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $iControl_Hovered)
				If IsArray($iCtrlID) Then $iCtrlID = $iCtrlID[0]
				
				;Primary Down/Up handler
				If ($aHOVER_CONTROLS_ARRAY[$i][3] <> "" Or $aHOVER_CONTROLS_ARRAY[$i][4] <> "") And _
					($iCheck_LCEM = -1 Or $iCheck_LCEM = $iControl_Hovered) Then
					
					Local $aCursorInfo = 0
					Local $hParent_Wnd = DllCall("User32.dll", "hwnd", "GetParent", "hwnd", $iControl_Hovered)
					
					If Not @error And IsArray($hParent_Wnd) Then
						$hParent_Wnd = $hParent_Wnd[0]
						$aCursorInfo = GUIGetCursorInfo($hParent_Wnd)
					Else
						$aCursorInfo = GUIGetCursorInfo()
					EndIf
					
					If IsArray($aCursorInfo) Then
						;Primary Down...
						;* First condition is to prevent function call when holding down m.button from other control
						;* Last condition is to Prevent/Allow multiple function call 
						;(depending on $iKeepCall_PrDn_Func param).
						If $iLAST_PRIMARYDOWN_CTRLID = $iControl_Hovered And WinActive($hParent_Wnd) And _
							$aCursorInfo[2] = 1 And $aHOVER_CONTROLS_ARRAY[$i][3] <> -1 And _
							(($aHOVER_CONTROLS_ARRAY[$i][5] < 1 And $iCheck_LCEM <> $iControl_Hovered) Or _
								$aHOVER_CONTROLS_ARRAY[$i][5] > 0) Then
							
							;1 is the indicator of Primary*Down* event
							__GUICtrl_SetOnHover_Call_Proc($aHOVER_CONTROLS_ARRAY[$i][3], $iCtrlID, 1)
							
							$hLAST_CLICKED_ELEMENT_MARK = $iControl_Hovered
						ElseIf $aCursorInfo[2] = 0 And $aHOVER_CONTROLS_ARRAY[$i][4] <> -1 And _ ;Primary Up
							$iCheck_LCEM = $iControl_Hovered Then
							
							;2 is the indicator of Primary*Up* event
							__GUICtrl_SetOnHover_Call_Proc($aHOVER_CONTROLS_ARRAY[$i][4], $iCtrlID, 2)
							
							$hLAST_CLICKED_ELEMENT_MARK = -1
						EndIf
					EndIf
				EndIf
				
				If $iHOVER_CONTROLS_MODIFIED = 1 Then ExitLoop
				
				If $aHOVER_CONTROLS_ARRAY[$i][6] < 1 And $aLAST_HOVERED_ELEMENT_MARK = $aHOVER_CONTROLS_ARRAY[$i][0] Then
					ExitLoop
				Else
					$aLAST_HOVERED_ELEMENT_MARK = $aHOVER_CONTROLS_ARRAY[$i][0]
				EndIf
				
				__GUICtrl_SetOnHover_Call_Proc($aHOVER_CONTROLS_ARRAY[$i][1], $iCtrlID, 1, 0) ;1 is the indicator of OnHover process
				
				If $iHOVER_CONTROLS_MODIFIED = 1 Then ExitLoop
				
				If $aHOVER_CONTROLS_ARRAY[$i][2] <> -1 Then
					$aLAST_HOVERED_ELEMENT[0] = $aHOVER_CONTROLS_ARRAY[$i][2]
					$aLAST_HOVERED_ELEMENT[1] = $iControl_Hovered
				EndIf
				
				ExitLoop
			EndIf
		Next
	EndIf
	
	$iHOVER_CONTROLS_MODIFIED = 0
EndFunc

Func __GUICtrl_SetOnHover_WM_COMMAND($hWndGUI, $MsgID, $WParam, $LParam)
	$iLAST_PRIMARYDOWN_CTRLID = $LParam
EndFunc

Func __GUICtrl_SetOnHover_WM_LBUTTONDOWN($hWndGUI, $MsgID, $WParam, $LParam)
	$iLAST_PRIMARYDOWN_CTRLID = 0
EndFunc

;Thanks to amel27 for that one!!!
Func _ControlGetHovered()
	Local $iOld_Opt_MCM = Opt("MouseCoordMode", 1)
	
	Local $aRet = DllCall("User32.dll", "int", "WindowFromPoint", _
		"long", MouseGetPos(0), _
		"long", MouseGetPos(1))
	
	;$aRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $aRet[0])
	
	Opt("MouseCoordMode", $iOld_Opt_MCM)
	
	Return $aRet[0]
EndFunc

;Call() function wrapper
Func __GUICtrl_SetOnHover_Call_Proc($sFunction, $sParam1="", $sParam2="", $sParam3="", $sParam4="", $sParam5="")
	Local $sCall_Params = 'Call("' & $sFunction & '"'
	Local $sEval = ''
	
	For $i = 2 To @NumParams
		$sEval = Eval("sParam" & $i-1)
		
		If IsNumber($sEval) Then
			$sCall_Params &= ', Number(' & $sEval & ')'
		Else
			$sCall_Params &= ', "' & $sEval & '"'
		EndIf
	Next
	
	If @NumParams < 2 Then $sCall_Params &= '"'
	$sCall_Params &= ')'
	
	Local $iRet = Execute($sCall_Params)
	Local $iError = @error
	
	While $iError <> 0
		$sCall_Params = StringRegExpReplace($sCall_Params, '(.*), .*\)$', '\1)', 1)
		If @extended = 0 Then ExitLoop
		
		$iRet = Execute($sCall_Params)
		$iError = @error
	WEnd
	
	Return SetError($iError, 0, $iRet)
EndFunc

;Release resources function
Func __GUICtrl_SetOnHover_ReleaseResources_Proc()
	If $__GUICtrl_SetOnHover_pTimerProc > 0 Then DllCallbackFree($__GUICtrl_SetOnHover_pTimerProc)
	If $__GUICtrl_SetOnHover_iTimerID > 0 Then _
		DllCall("user32.dll", "int", "KillTimer", "hwnd", 0, "int", $__GUICtrl_SetOnHover_iTimerID)
	
	GUIRegisterMsg($__GUICtrl_SetOnHover_WM_COMMAND, "")
	GUIRegisterMsg($__GUICtrl_SetOnHover_WM_LBUTTONDOWN, "")
	
	$__GUICtrl_SetOnHover_pTimerProc = 0
	$__GUICtrl_SetOnHover_iTimerID = 0
EndFunc

;Release the CallBack resources when exit
Func __GUICtrl_SetOnHover_OnAutoItExit()
	Call($__GUICtrl_SetOnHover_sOriginal_OnExitFunc)
	
	__GUICtrl_SetOnHover_ReleaseResources_Proc()
EndFunc
